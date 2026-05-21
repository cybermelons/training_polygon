--class for precaching heroes before individual gamemode starts
--precaching loading models of heroes, can be done while custom game loading, but i dont want people who wants to play specific minigame load heroes for every minigame
if precache == nil then
    precache = class({})
end

function precache:Init()
    self.precacheTable = {}
    self.cached = {}          -- name -> true once async callback fires
    self.queued = {}          -- name -> true once added (in-flight)
    self.dripStarted = false

    -- Hover-triggered hero precache. Client fires this from the hero picker
    -- onmouseover so the asset warms up while the user decides.
    CustomGameEventManager:RegisterListener("precache_hero_hover", function(_, args)
        local name = args and args.hero
        if not name then return end
        if precache.cached[name] or precache.queued[name] then return end
        precache.queued[name] = true
        print("[Precache] hover precache: "..name)
        PrecacheUnitByNameAsync(name, function()
            precache.cached[name] = true
            precache.queued[name] = nil
        end)
    end)
end

function precache:PrecaheAddItemToList(itemList)
    for k,v in pairs(itemList) do
        -- Only skip when fully cached. If the hero is mid-flight from a hover
        -- precache, we still need to wait on the gamemode's doPrecache before
        -- spawning the unit -- so add it to the table and let the engine dedupe
        -- the actual asset load.
        if not self.cached[v] then
            table.insert(self.precacheTable, {'item', v})
            print(v.." added to table")
        end
    end
end

function precache:PrecacheAddUnitToList(unitList)
    for k,v in pairs(unitList) do
        -- Only skip when fully cached. If the hero is mid-flight from a hover
        -- precache, we still need to wait on the gamemode's doPrecache before
        -- spawning the unit -- so add it to the table and let the engine dedupe
        -- the actual asset load.
        if not self.cached[v] then
            table.insert(self.precacheTable, {'unit', v})
            print(v.." added to table")
        end
    end
end

function precache:PrecacheAddPlayerUnitToList(unitList)
    for k,v in pairs(unitList) do
        -- Only skip when fully cached. If the hero is mid-flight from a hover
        -- precache, we still need to wait on the gamemode's doPrecache before
        -- spawning the unit -- so add it to the table and let the engine dedupe
        -- the actual asset load.
        if not self.cached[v] then
            table.insert(self.precacheTable, {'p_unit', v})
            print(v.." added to table")
        end
    end
end

function precache:doPrecache(callback)
    local totalCount = #self.precacheTable

    -- Always hide the main menu before gameplay begins, regardless of whether
    -- we show the precache modal. The modal visibility is independent of the
    -- main-menu visibility.
    GameMode:HideMenu()

    -- Nothing new to load: skip the modal entirely and go straight to callback.
    if totalCount == 0 then
        print("Precache: nothing to precache (all cached)")
        if callback then callback() end
        return
    end

    print('Precache started ('..totalCount..' items)')
    -- Only flash the modal when there's enough work to be noticeable.
    local showModal = totalCount > 1
    if showModal then
        CustomGameEventManager:Send_ServerToAllClients("precache_start", {total = totalCount})
    end

    local currentCount = 0
    function precacheElement(callback)
        if self.precacheTable[1] ~= nil then
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

            local markDone = function()
                self.cached[itemName] = true
                self.queued[itemName] = nil
                table.remove(self.precacheTable, 1)
                precacheElement(callback)
            end

            if itemType == "unit" then
                PrecacheUnitByNameAsync(itemName, markDone)
            elseif itemType == "p_unit" then
                PrecacheUnitByNameAsync(itemName, markDone, 0)
            else
                PrecacheItemByNameAsync(itemName, markDone)
            end
        else
            print("Precache done")
            if showModal then
                CustomGameEventManager:Send_ServerToAllClients("precache_complete", {})
            end
            if callback then callback() end
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
        if not self.cached[name] and not self.queued[name] then
            self.queued[name] = true
            PrecacheUnitByNameAsync(name, function()
                self.cached[name] = true
                self.queued[name] = nil
            end)
        end
        return 0.5
    end)
end
