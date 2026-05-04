if timing == nil then
  timing = class({})
end

function timing:Init()
    self.type="sandbox" -- Define the type of mode
    self.name="timing" -- Name of the gamemode
    self.activated=false -- Whether the mode is activated
    self.Player=nil -- Reference to the player
    self.playerHero=nil -- Reference to the player's hero
    self.trainingPlace=Vector(879.7060546875,4036.7941894531,128) -- Location for training
    self.spellTable=
    {
        item_cyclone=
        {
            [1]={spell_name="item_meteor_hammer"},
            [2]={spell_name="axe_berserkers_call"},
            [3]={spell_name="centaur_hoof_stomp"},
            [4]={spell_name="earth_spirit_boulder_smash"},
            [5]={spell_name="earthshaker_fissure"},
            [6]={spell_name="earthshaker_enchant_totem"},
            [7]={spell_name="earthshaker_enchant_totem"},
            [8]={spell_name="earthshaker_echo_slam"},
            [9]={spell_name="elder_titan_echo_stomp"},
            [10]={spell_name="ember_spirit_searing_chains"},
            [11]={spell_name="gyrocopter_call_down"},
            [12]={spell_name="kunkka_torrent"},
            [13]={spell_name="kunkka_ghostship"},
            [14]={spell_name="kunkka_ghostship"},
            [15]={spell_name="magnataur_skewer"},
            [16]={spell_name="magnataur_reverse_polarity"},
            [17]={spell_name="pudge_meat_hook"},
            [18]={spell_name="sandking_burrowstrike"},
            [19]={spell_name="slardar_slithereen_crush"},
            [20]={spell_name="spirit_breaker_charge_of_darkness"},
            [21]={spell_name="tidehunter_ravage"},
            [22]={spell_name="tusk_snowball"},
            [23]={spell_name="bloodseeker_blood_bath"},
            [24]={spell_name="lone_druid_savage_roar"},
            [25]={spell_name="meepo_poof"},
            [26]={spell_name="mirana_arrow"},
            [27]={spell_name="monkey_king_boundless_strike"},
            [28]={spell_name="nyx_assassin_impale"},
            [29]={spell_name="pangolier_shield_crash"},
            [30]={spell_name="nevermore_shadowraze1"},
            [31]={spell_name="nevermore_shadowraze2"},
            [32]={spell_name="nevermore_shadowraze3"},
            [33]={spell_name="nevermore_requiem"},
            [34]={spell_name="ancient_apparition_cold_feet"},
            [35]={spell_name="ancient_apparition_ice_blast"},
            [36]={spell_name="dark_seer_vacuum"},
            [37]={spell_name="dark_willow_cursed_crown"},
            [38]={spell_name="death_prophet_silence"},
            [39]={spell_name="invoker_emp"},
            [40]={spell_name="invoker_chaos_meteor"},
            [41]={spell_name="invoker_sun_strike"},
            [42]={spell_name="leshrac_split_earth"},
            [43]={spell_name="lina_light_strike_array"},
            [44]={spell_name="lion_impale"},
            [45]={spell_name="puck_waning_rift"},
            [46]={spell_name="pugna_nether_blast"},
            [47]={spell_name="visage_summon_familiars"},
            [48]={spell_name="warlock_rain_of_chaos"},
            [49]={spell_name="windrunner_shackleshot"}
        }
    }
    self.spellTable.shadow_demon_disruption = self.spellTable.item_cyclone
    self.spellTable.obsidian_destroyer_astral_imprisonment = self.spellTable.item_cyclone
    self.spellTable.item_aegis = self.spellTable.item_cyclone
    self.spellTable.skeleton_king_reincarnation = self.spellTable.item_cyclone
    self.spellTable.item_travel_boots = self.spellTable.item_cyclone
    --declaring spells this way, so we can declare different lists of spells to different types of timings
    --for now let them be the same
end