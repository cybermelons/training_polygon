-- Simple disk-backed prefs store for training_polygon. Persists across game
-- sessions on the local machine (the host of the lobby). Single-player /
-- solo-host use case only -- not synced across machines.

if Prefs == nil then
    Prefs = class({})
end

local PREFS_FILE = "training_polygon_prefs.json"

-- In-memory cache so we don't pay the disk hit (or sandbox failure) per call.
Prefs._cache = nil

function Prefs:Load()
    if Prefs._cache ~= nil then return Prefs._cache end
    local ok, result = pcall(function()
        local f = io.open(PREFS_FILE, "r")
        if not f then return {} end
        local s = f:read("*a")
        f:close()
        if not s or s == "" then return {} end
        return json.decode(s) or {}
    end)
    if ok and type(result) == "table" then
        Prefs._cache = result
    else
        print("[Prefs] load failed (sandbox may block io). Using empty.")
        Prefs._cache = {}
    end
    return Prefs._cache
end

function Prefs:Save(data)
    Prefs._cache = data
    local ok = pcall(function()
        local f = io.open(PREFS_FILE, "w")
        if not f then error("io.open returned nil") end
        f:write(json.encode(data))
        f:close()
    end)
    if not ok then
        print("[Prefs] save failed (sandbox may block io). Kept in memory only.")
    end
    return ok
end

function Prefs:Get(key, default)
    local p = Prefs:Load()
    if p[key] ~= nil then return p[key] end
    return default
end

function Prefs:Set(key, value)
    local p = Prefs:Load()
    p[key] = value
    Prefs:Save(p)
end

function Prefs:Init()
    CustomGameEventManager:RegisterListener("prefs_get", function(_, args)
        local data = Prefs:Load()
        CustomGameEventManager:Send_ServerToAllClients("prefs_answer", { data = data })
    end)

    CustomGameEventManager:RegisterListener("get_item_costs", function(_, args)
        local items = args.items or {}
        local costs = {}
        for _, name in pairs(items) do
            -- Try the engine API first, fall back to reading items.txt KV
            -- directly via DotaDB (some basic-shop components return 0 from
            -- GetItemCost depending on patch state).
            local cost = GetItemCost(name) or 0
            if cost == 0 and DotaDB and DotaDB.items_KV then
                local kv = DotaDB.items_KV[name]
                if kv and kv.ItemCost then
                    cost = tonumber(kv.ItemCost) or 0
                end
            end
            costs[name] = cost
            print("[Prefs] item cost", name, "=", cost)
        end
        CustomGameEventManager:Send_ServerToAllClients("item_costs_answer", { costs = costs })
    end)
end

Prefs:Init()
