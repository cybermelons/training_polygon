--class for precaching heroes before individual gamemode starts
--precaching loading models of heroes, can be done while custom game loading, but i dont want people who wants to play specific minigame load heroes for every minigame
if precache == nil then
    precache = class({})
end

-- markDone fires once the engine finishes loading 'name'. Sets cached, clears
-- queued, and fires any registered waiters (gamemode doPrecache calls that
-- raced with a hover/drip on the same unit).
local function makeMarkDone(name)
    return function()
        precache.cached[name] = true
        precache.queued[name] = nil
        local waiters = precache.waiters[name]
        if waiters then
            precache.waiters[name] = nil
            for _, w in ipairs(waiters) do w() end
        end
    end
end

local function kickOff(name, playerID)
    if precache.cached[name] or precache.queued[name] then return end
    precache.queued[name] = true
    PrecacheUnitByNameAsync(name, makeMarkDone(name), playerID or -1)
end

function precache:Init()
    self.precacheTable = {}
    self.cached = {}          -- name -> true once async callback fires
    self.queued = {}          -- name -> true once added (in-flight)
    self.waiters = {}         -- name -> list of fn(): fires when load finishes
    self.dripStarted = false

    -- Hover-triggered hero precache. Client fires this from the hero picker
    -- onmouseover so the asset warms up while the user decides.
    CustomGameEventManager:RegisterListener("precache_hero_hover", function(_, args)
        local name = args and args.hero
        if not name then return end
        if precache.cached[name] or precache.queued[name] then return end
        print("[Precache] hover precache: "..name)
        kickOff(name, 0)
    end)
end

function precache:PrecaheAddItemToList(itemList)
    for k,v in pairs(itemList) do
        if not self.cached[v] then
            table.insert(self.precacheTable, {'item', v})
        end
    end
end

function precache:PrecacheAddUnitToList(unitList)
    for k,v in pairs(unitList) do
        if not self.cached[v] then
            table.insert(self.precacheTable, {'unit', v})
        end
    end
end

function precache:PrecacheAddPlayerUnitToList(unitList)
    for k,v in pairs(unitList) do
        if not self.cached[v] then
            table.insert(self.precacheTable, {'p_unit', v})
        end
    end
end

function precache:doPrecache(callback)
    local totalCount = #self.precacheTable

    -- Always hide the main menu before gameplay begins, regardless of whether
    -- we show the precache modal.
    GameMode:HideMenu()

    if totalCount == 0 then
        print("Precache: nothing to precache (all cached)")
        if callback then callback() end
        return
    end

    print('Precache started ('..totalCount..' items)')
    local showModal = totalCount > 1
    if showModal then
        CustomGameEventManager:Send_ServerToAllClients("precache_start", {total = totalCount})
    end

    local currentCount = 0
    function precacheElement(cb)
        if self.precacheTable[1] == nil then
            print("Precache done")
            if showModal then
                CustomGameEventManager:Send_ServerToAllClients("precache_complete", {})
            end
            if cb then cb() end
            return
        end

        local itemType = self.precacheTable[1][1]
        local itemName = self.precacheTable[1][2]

        currentCount = currentCount + 1
        print("Precaching:", itemType, itemName, "(" .. currentCount .. "/" .. totalCount .. ")")
        if showModal then
            CustomGameEventManager:Send_ServerToAllClients("precache_progress", {
                item = itemName,
                current = currentCount,
                total = totalCount
            })
        end

        local advance = function()
            table.remove(self.precacheTable, 1)
            precacheElement(cb)
        end

        if self.cached[itemName] then
            -- Already loaded (probably by an earlier gamemode). Skip immediately.
            advance()
        elseif self.queued[itemName] then
            -- In-flight from hover or drip. Register a waiter that fires
            -- when the original async completes, then advance.
            self.waiters[itemName] = self.waiters[itemName] or {}
            table.insert(self.waiters[itemName], advance)
        else
            -- Fresh load. Kick off the async; markDone-style callback fires
            -- both cached/queued bookkeeping AND any registered waiters.
            self.queued[itemName] = true
            local cbForThis = function()
                makeMarkDone(itemName)()
                advance()
            end
            if itemType == "unit" then
                PrecacheUnitByNameAsync(itemName, cbForThis, -1)
            elseif itemType == "p_unit" then
                PrecacheUnitByNameAsync(itemName, cbForThis, 0)
            else
                PrecacheItemByNameAsync(itemName, cbForThis)
            end
        end
    end

    precacheElement(callback)
end

function precache:clearTable()
    self.precacheTable = {}
end

-- Background drip: walk every hero in the Dota roster and lazily precache one
-- every ~500ms. Heroes already loaded (via hover or a previous gamemode) are
-- skipped via the shared cached/queued set, so the drip costs nothing for them.
function precache:StartIdleDrip()
    if self.dripStarted then return end
    self.dripStarted = true
    local heroes = DotaDB:GetAllHeroes()
    print("[Precache] idle drip queued "..#heroes.." heroes")
    local i = 1
    Timers:CreateTimer(2.0, function()
        if i > #heroes then
            print("[Precache] idle drip done")
            return nil
        end
        local name = heroes[i]
        i = i + 1
        kickOff(name, 0)
        return 0.5
    end)
end
