if dodge == nil then
  dodge = class({})
end


function dodge:Init()
    -- Each entry: {spell_name, hero_name, level, aghs, shard, is_ability}
    -- Numeric keys allow addressing back from JS
    self.spellTable=
    { item_manta=
        {
        [1]={spell_name="lina_light_strike_array", hero_name="npc_dota_hero_lina", level=1, aghs=false, shard=false, is_ability=true},
        [2]={spell_name="kunkka_ghostship", hero_name="npc_dota_hero_kunkka", level=1, aghs=false, shard=false, is_ability=true},
        [3]={spell_name="lina_laguna_blade", hero_name="npc_dota_hero_lina", level=1, aghs=false, shard=false, is_ability=true},
        [4]={spell_name="bloodseeker_blood_bath", hero_name="npc_dota_hero_bloodseeker", level=1, aghs=false, shard=false, is_ability=true},
        [5]={spell_name="pugna_nether_blast", hero_name="npc_dota_hero_pugna", level=1, aghs=false, shard=false, is_ability=true},
        [6]={spell_name="meepo_poof", hero_name="npc_dota_hero_meepo", level=1, aghs=false, shard=false, is_ability=true},
        [7]={spell_name="necrolyte_death_pulse", hero_name="npc_dota_hero_necrolyte", level=1, aghs=false, shard=false, is_ability=true},
        [8]={spell_name="mirana_starfall", hero_name="npc_dota_hero_mirana", level=1, aghs=false, shard=false, is_ability=true},
        [9]={spell_name="nevermore_shadowraze2", hero_name="npc_dota_hero_nevermore", level=1, aghs=false, shard=false, is_ability=true},
        [10]={spell_name="zuus_lightning_bolt", hero_name="npc_dota_hero_zuus", level=1, aghs=false, shard=false, is_ability=true},
        [11]={spell_name="zuus_thundergods_wrath", hero_name="npc_dota_hero_zuus", level=1, aghs=false, shard=false, is_ability=true},
        [12]={spell_name="tidehunter_anchor_smash", hero_name="npc_dota_hero_tidehunter", level=1, aghs=false, shard=false, is_ability=true},
        [13]={spell_name="ursa_earthshock", hero_name="npc_dota_hero_ursa", level=1, aghs=false, shard=false, is_ability=true},
        [14]={spell_name="omniknight_purification", hero_name="npc_dota_hero_omniknight", level=1, aghs=false, shard=false, is_ability=true},
        [15]={spell_name="alchemist_unstable_concoction", hero_name="npc_dota_hero_alchemist", level=1, aghs=false, shard=false, is_ability=true},
        [16]={spell_name="skywrath_mage_arcane_bolt", hero_name="npc_dota_hero_skywrath_mage", level=1, aghs=false, shard=false, is_ability=true},
        [17]={spell_name="medusa_mystic_snake", hero_name="npc_dota_hero_medusa", level=1, aghs=false, shard=false, is_ability=true},
        [18]={spell_name="medusa_stone_gaze", hero_name="npc_dota_hero_medusa", level=1, aghs=false, shard=false, is_ability=true},
        [19]={spell_name="shadow_demon_demonic_purge", hero_name="npc_dota_hero_shadow_demon", level=1, aghs=false, shard=false, is_ability=true},
        [20]={spell_name="earthshaker_fissure", hero_name="npc_dota_hero_earthshaker", level=1, aghs=false, shard=false, is_ability=true},
        [21]={spell_name="earthshaker_enchant_totem", hero_name="npc_dota_hero_earthshaker", level=1, aghs=false, shard=false, is_ability=true},
        [22]={spell_name="invoker_emp", hero_name="npc_dota_hero_invoker", level=1, aghs=false, shard=false, is_ability=true},
        [23]={spell_name="obsidian_destroyer_sanity_eclipse", hero_name="npc_dota_hero_obsidian_destroyer", level=1, aghs=false, shard=false, is_ability=true},
        [24]={spell_name="undying_decay", hero_name="npc_dota_hero_undying", level=1, aghs=false, shard=false, is_ability=true},
        [25]={spell_name="elder_titan_echo_stomp", hero_name="npc_dota_hero_elder_titan", level=1, aghs=false, shard=false, is_ability=true},
        [26]={spell_name="rattletrap_rocket_flare", hero_name="npc_dota_hero_rattletrap", level=1, aghs=false, shard=false, is_ability=true},
        [27]={spell_name="rattletrap_hookshot", hero_name="npc_dota_hero_rattletrap", level=1, aghs=false, shard=false, is_ability=true},
        [28]={spell_name="windrunner_powershot", hero_name="npc_dota_hero_windrunner", level=1, aghs=false, shard=false, is_ability=true},
        [29]={spell_name="huskar_life_break", hero_name="npc_dota_hero_huskar", level=1, aghs=false, shard=false, is_ability=true},
        [30]={spell_name="gyrocopter_homing_missile", hero_name="npc_dota_hero_gyrocopter", level=1, aghs=false, shard=false, is_ability=true},
        [31]={spell_name="tiny_toss", hero_name="npc_dota_hero_tiny", level=1, aghs=false, shard=false, is_ability=true},
        [32]={spell_name="phoenix_supernova", hero_name="npc_dota_hero_phoenix", level=1, aghs=false, shard=false, is_ability=true},
        [33]={spell_name="legion_commander_overwhelming_odds", hero_name="npc_dota_hero_legion_commander", level=1, aghs=false, shard=false, is_ability=true},
        [34]={spell_name="magnataur_reverse_polarity", hero_name="npc_dota_hero_magnataur", level=1, aghs=false, shard=false, is_ability=true},
        [35]={spell_name="slardar_slithereen_crush", hero_name="npc_dota_hero_slardar", level=1, aghs=false, shard=false, is_ability=true},
        [36]={spell_name="axe_berserkers_call", hero_name="npc_dota_hero_axe", level=1, aghs=false, shard=false, is_ability=true},
        [37]={spell_name="brewmaster_thunder_clap", hero_name="npc_dota_hero_brewmaster", level=1, aghs=false, shard=false, is_ability=true},
        [38]={spell_name="centaur_hoof_stomp", hero_name="npc_dota_hero_centaur", level=1, aghs=false, shard=false, is_ability=true},
        [39]={spell_name="lion_finger_of_death", hero_name="npc_dota_hero_lion", level=1, aghs=false, shard=false, is_ability=true},
        [40]={spell_name="queenofpain_scream_of_pain", hero_name="npc_dota_hero_queenofpain", level=1, aghs=false, shard=false, is_ability=true},
        [41]={spell_name="visage_summon_familiars_stone_form", hero_name="npc_dota_visage_familiar1", level=1, aghs=false, shard=false, is_ability=true},
        [42]={spell_name="polar_furbolg_ursa_warrior_thunder_clap", hero_name="npc_dota_neutral_polar_furbolg_ursa_warrior", level=1, aghs=false, shard=false, is_ability=true},
        [43]={spell_name="centaur_khan_war_stomp", hero_name="npc_dota_neutral_centaur_khan", level=1, aghs=false, shard=false, is_ability=true},
        [44]={spell_name="techies_suicide", hero_name="npc_dota_hero_techies", level=1, aghs=false, shard=false, is_ability=true},
        [45]={spell_name="obsidian_destroyer_astral_imprisonment", hero_name="npc_dota_hero_obsidian_destroyer", level=1, aghs=false, shard=false, is_ability=true},
        [46]={spell_name="roshan_slam", hero_name="npc_dota_roshan", level=1, aghs=false, shard=false, is_ability=true},
        [47]={spell_name="invoker_sun_strike", hero_name="npc_dota_hero_invoker", level=1, aghs=false, shard=false, is_ability=true},
        [48]={spell_name="kunkka_torrent", hero_name="npc_dota_hero_kunkka", level=1, aghs=false, shard=false, is_ability=true},
        [49]={spell_name="kunkka_tidebringer", hero_name="npc_dota_hero_kunkka", level=1, aghs=false, shard=false, is_ability=true},
        [50]={spell_name="elder_titan_earth_splitter", hero_name="npc_dota_hero_elder_titan", level=1, aghs=false, shard=false, is_ability=true},
        [51]={spell_name="leshrac_split_earth", hero_name="npc_dota_hero_leshrac", level=1, aghs=false, shard=false, is_ability=true},
        [52]={spell_name="warlock_rain_of_chaos", hero_name="npc_dota_hero_warlock", level=1, aghs=false, shard=false, is_ability=true},
        [53]={spell_name="pangolier_shield_crash", hero_name="npc_dota_hero_pangolier", level=1, aghs=false, shard=false, is_ability=true},
        [54]={spell_name="dark_willow_terrorize", hero_name="npc_dota_hero_dark_willow", level=1, aghs=false, shard=false, is_ability=true},
        [55]={spell_name="item_meteor_hammer", hero_name="npc_dota_hero_riki", level=1, aghs=false, shard=false, is_ability=false},
        }
    }
    -- Assign the reference of item_manta to other dodge types for now, in future we can make a different spell lists for different dodge types
    self.spellTable.ember_spirit_sleight_of_fist = self.spellTable.item_manta
    self.spellTable.puck_phase_shift = self.spellTable.item_manta
    self.spellTable.storm_spirit_ball_lightning = self.spellTable.item_manta
    self.spellTable.bane_nightmare = self.spellTable.item_manta
    self.spellTable.monkey_king_mischief = self.spellTable.item_manta
    self.spellTable.void_spirit_dissimilate = self.spellTable.item_manta
    self.spellTable.antimage_counterspell = self.spellTable.item_manta
    self.spellTable.riki_tricks_of_the_trade = self.spellTable.item_manta
    self.spellTable.nyx_assassin_spiked_carapace = self.spellTable.item_manta
    -- Define a table mapping abilities to heroes
    self.unitTable = {
        item_manta = "npc_dota_hero_antimage",
        ember_spirit_sleight_of_fist = "npc_dota_hero_ember_spirit",
        puck_phase_shift = "npc_dota_hero_puck",
        storm_spirit_ball_lightning = "npc_dota_hero_storm_spirit",
        bane_nightmare = "npc_dota_hero_bane",
        monkey_king_mischief = "npc_dota_hero_monkey_king",
        void_spirit_dissimilate = "npc_dota_hero_void_spirit",
        antimage_counterspell = "npc_dota_hero_antimage",
        riki_tricks_of_the_trade = "npc_dota_hero_riki",
        nyx_assassin_spiked_carapace = "npc_dota_hero_nyx_assassin",
    }
    self.type="sandbox" -- Define the type of mode
    self.name="dodge" -- Name of the gamemode
    self.activated=false -- Whether the mode is activated
    self.Player=nil -- Reference to the player
    self.playerHero=nil -- Reference to the player's hero
    self.trainingPlace=Vector(879.7060546875,4036.7941894531,128) -- Location for training
    self.castDelay=2 --delay between unit spawn and cast
    self.afterCastDelay=1 --delay between cast and unit removal
    --register listeners here
    CustomGameEventManager:RegisterListener("get_dodge_spell_table", function(_, event)
        dodge:SendSpellTable()
    end)
    print('dodge inited')
end
function dodge:cycleEnemies()


end
function dodge:cast_lina_light_strike_array(playerHero,castDelay,afterCastDelay)
    local abilityName="lina_light_strike_array"
    local abilityKV = DotaDB:GetAbilityKV(abilityName)
    local castPoint=parseQuadroValue(abilityKV["AbilityCastPoint"])
    local damageDelay=parseQuadroValue(abilityKV["AbilityValues"]["light_strike_array_delay_time"])
    
end
function dodge:Prepare(args)
    print("[Dodge] Preparing gamemode")
    precache:clearTable()

    local dodgeName = args.dodgeName or "item_manta"
    local selectedSpells = args.dodgeSpells or {}

    print("[Dodge] Dodge type: " .. dodgeName)

    -- Count selected spells (it's now an object/table with string keys)
    local spellCount = 0
    for _ in pairs(selectedSpells) do spellCount = spellCount + 1 end
    print("[Dodge] Selected spells count: " .. spellCount)

    local unitsToPrecache = {}
    local unitsAdded = {}

    -- Add player hero based on dodge type
    local playerHero = self.unitTable[dodgeName]
    if playerHero then
        unitsToPrecache[#unitsToPrecache + 1] = playerHero
        unitsAdded[playerHero] = true
        print("[Dodge] Adding player hero: " .. playerHero)
    end

    -- Add enemy caster heroes for selected spells
    -- selectedSpells is now a table with numeric keys matching spellTable indices
    -- Format: { [key] = { spell_name, hero_name, level, aghs, shard, is_ability }, ... }
    for key, spellInfo in pairs(selectedSpells) do
        if spellInfo and spellInfo.hero_name then
            local enemyHero = spellInfo.hero_name
            if enemyHero and enemyHero ~= "" and not unitsAdded[enemyHero] then
                unitsToPrecache[#unitsToPrecache + 1] = enemyHero
                unitsAdded[enemyHero] = true
                print("[Dodge] Adding enemy hero: " .. enemyHero)
            end
        end
        -- Log the full spell info for debugging
        -- key can be used to address self.spellTable[dodgeName][key]
        print("[Dodge] Key: " .. tostring(key) ..
              ", Spell: " .. (spellInfo.spell_name or "nil") ..
              ", hero: " .. (spellInfo.hero_name or "nil") ..
              ", level: " .. (spellInfo.level or "nil") ..
              ", aghs: " .. tostring(spellInfo.aghs) ..
              ", shard: " .. tostring(spellInfo.shard))
    end

    -- Add units to precache list
    if playerHero then
        precache:PrecacheAddPlayerUnitToList({playerHero})
    end

    local enemyUnits = {}
    for _, unit in ipairs(unitsToPrecache) do
        if unit ~= playerHero then
            enemyUnits[#enemyUnits + 1] = unit
        end
    end
    if #enemyUnits > 0 then
        precache:PrecacheAddUnitToList(enemyUnits)
    end

    -- Store args for use after precaching
    self.pendingArgs = args

    -- Start precaching with callback to start the actual game
    precache:doPrecache(function()
        dodge:StartGame(self.pendingArgs)
    end)
end

function dodge:StartGame(args)
    print("[Dodge] Starting game after precache")
    DeepPrintTable(args)
    self.activated = true
    CustomGameEventManager:Send_ServerToAllClients("load_hud",{name=self.name})
    self:cast_lina_light_strike_array()
    CustomGameEventManager:Send_ServerToAllClients("timebar_show", {width=400, title="Training"})
    -- TODO: Implement actual game start logic here
end
function dodge:SendSpellTable()
    --[[ print(self.spellTable)
    DeepPrintTable(self.spellTable) ]]
    CustomGameEventManager:Send_ServerToAllClients("dodge_spell_table",{data=self.spellTable})
end
function dodge:OnNPCSpawned(keys)

end

function dodge:OrderFilter(event)

end

function dodge:ModifierGained(event)

end

function dodge:OnIllusionsCreated(keys)

end

function dodge:OnNonPlayerUsedAbility(keys)

end

function dodge:OnAbilityUsed(keys)

end

function dodge:OnEntityHurt(keys)

end