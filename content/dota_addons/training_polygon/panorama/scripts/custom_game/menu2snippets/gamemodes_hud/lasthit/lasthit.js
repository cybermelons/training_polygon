$.Msg('lasthit loaded')

// Items list: [name, cost]. Cost matches Dota's item KV so we can sum client-side.
// Lua validates total<=600 in lasthit_start_fix; we mirror that here.
var LASTHIT_ITEMS = [
    ["item_quelling_blade",     200],
    ["item_stout_shield",       250],
    ["item_blades_of_attack",   450],
    ["item_gauntlets",           60],
    ["item_slippers",            60],
    ["item_branches",            45],
    ["item_tango",              125],
    ["item_flask",              110],
    ["item_faerie_fire",         85],
    ["item_ring_of_protection", 175],
    ["item_circlet",            155],
    ["item_mantle",             140]
];
var ITEM_COST_CAP = 600;
var INVENTORY_SLOTS = 6;
// inventory[i] = {name, cost} or null. Dupes allowed.
var inventory = new Array(INVENTORY_SLOTS);
for (var s = 0; s < INVENTORY_SLOTS; s++) { inventory[s] = null; }

var pickerPanel = $('#lasthitPicker');
var hudPanel = $('#lasthitHud');
var errorMsg = $('#errorMsg');
var costLabel = $('#lasthitItemsCost');

function totalCost() {
    var total = 0;
    for (var i = 0; i < INVENTORY_SLOTS; i++) {
        if (inventory[i]) { total += inventory[i].cost; }
    }
    return total;
}

function updateCostLabel() {
    costLabel.text = totalCost() + ' / ' + ITEM_COST_CAP;
}

function findFreeSlot() {
    for (var i = 0; i < INVENTORY_SLOTS; i++) {
        if (inventory[i] === null) { return i; }
    }
    return -1;
}

function renderInventory() {
    var invRow = $('#lasthitInventory');
    invRow.RemoveAndDeleteChildren();
    for (var i = 0; i < INVENTORY_SLOTS; i++) {
        var slotBtn = $.CreatePanel('Button', invRow, 'lasthitSlot_' + i);
        slotBtn.AddClass('lasthitInventorySlot');
        var entry = inventory[i];
        if (entry) {
            var img = $.CreatePanel('DOTAItemImage', slotBtn, 'slotImg_' + i);
            img.itemname = entry.name;
            img.AddClass('lasthitItemImage');
            slotBtn.AddClass('lasthitInventorySlotFilled');
            slotBtn.SetPanelEvent('onmouseover', (function(b, n) {
                return function() { $.DispatchEvent('DOTAShowAbilityTooltip', b, n); };
            })(slotBtn, entry.name));
            slotBtn.SetPanelEvent('onmouseout', (function(b) {
                return function() { $.DispatchEvent('DOTAHideAbilityTooltip', b); };
            })(slotBtn));
        }
        slotBtn.SetPanelEvent('onactivate', (function(idx) {
            return function() { clearSlot(idx); };
        })(i));
    }
}

function addItem(itemName, cost) {
    var slot = findFreeSlot();
    if (slot === -1) {
        errorMsg.text = 'Inventory full (6 slots).';
        return;
    }
    if (totalCost() + cost > ITEM_COST_CAP) {
        errorMsg.text = 'Item exceeds 600g cap.';
        return;
    }
    inventory[slot] = { name: itemName, cost: cost };
    errorMsg.text = '';
    renderInventory();
    updateCostLabel();
}

function clearSlot(idx) {
    if (!inventory[idx]) { return; }
    inventory[idx] = null;
    errorMsg.text = '';
    renderInventory();
    updateCostLabel();
}

function drawItemsGrid() {
    var grid = $('#lasthitItemsGrid');
    for (var i = 0; i < LASTHIT_ITEMS.length; i++) {
        var itemName = LASTHIT_ITEMS[i][0];
        var cost = LASTHIT_ITEMS[i][1];
        var btn = $.CreatePanel('Button', grid, 'btn_' + itemName);
        btn.AddClass('lasthitItemButton');

        var img = $.CreatePanel('DOTAItemImage', btn, 'img_' + itemName);
        img.itemname = itemName;
        img.AddClass('lasthitItemImage');

        var costLbl = $.CreatePanel('Label', btn, 'cost_' + itemName);
        costLbl.text = cost + 'g';
        costLbl.AddClass('lasthitItemCostLabel');

        btn.SetPanelEvent('onactivate', (function(n, c) {
            return function() { addItem(n, c); };
        })(itemName, cost));

        btn.SetPanelEvent('onmouseover', (function(b, n) {
            return function() { $.DispatchEvent('DOTAShowAbilityTooltip', b, n); };
        })(btn, itemName));
        btn.SetPanelEvent('onmouseout', (function(b) {
            return function() { $.DispatchEvent('DOTAHideAbilityTooltip', b); };
        })(btn));
    }
}

// --- Side picker ---
var selectedSide = 0; // 0 = Radiant, 1 = Dire
function selectSide(side) {
    selectedSide = side;
    var rad = $('#lasthitSideRadiantBtn');
    var dir = $('#lasthitSideDireBtn');
    if (side === 0) { rad.AddClass('lasthitSideActive'); dir.RemoveClass('lasthitSideActive'); }
    else            { dir.AddClass('lasthitSideActive'); rad.RemoveClass('lasthitSideActive'); }
}

// --- Hero picker (inline grid) ---
var selectedHero = 'npc_dota_hero_antimage';

// "npc_dota_hero_storm_spirit" -> "Storm Spirit"
function prettifyHeroName(npcName) {
    var raw = npcName.replace('npc_dota_hero_', '');
    var parts = raw.split('_');
    for (var i = 0; i < parts.length; i++) {
        if (parts[i].length > 0) {
            parts[i] = parts[i].charAt(0).toUpperCase() + parts[i].substring(1);
        }
    }
    return parts.join(' ');
}

GameEvents.SendCustomGameEventToServer('dotadb_get_hero_list', {});

function saveHeroList(data) {
    var heroList = data.hero_list;
    var keys = [];
    for (var key in heroList) { keys[keys.length] = key; }
    for (var i = 0; i < keys.length - 1; i++) {
        for (var j = i + 1; j < keys.length; j++) {
            var nameA = heroList[keys[i]].replace('npc_dota_hero_', '');
            var nameB = heroList[keys[j]].replace('npc_dota_hero_', '');
            if (nameA > nameB) { var t = keys[i]; keys[i] = keys[j]; keys[j] = t; }
        }
    }
    var grid = $('#lasthitHeroGrid');
    grid.RemoveAndDeleteChildren();
    for (var i = 0; i < keys.length; i++) {
        var heroName = heroList[keys[i]];
        var heroButton = $.CreatePanel('Button', grid, heroName);
        heroButton.AddClass('lasthitHeroButton');
        // Halo behind the icon — shown when this hero is selected.
        var halo = $.CreatePanel('Panel', heroButton, 'halo_' + keys[i]);
        halo.AddClass('lasthitHeroHalo');

        var heroIcon = $.CreatePanel('DOTAHeroImage', heroButton, 'icon_' + keys[i]);
        heroIcon.heroimagestyle = 'icon';
        heroIcon.heroname = heroName;
        heroIcon.AddClass('lasthitHeroIcon');
        if (heroName == selectedHero) {
            heroButton.AddClass('lasthitHeroSelected');
        }
        heroButton.SetPanelEvent('onactivate', (function(b, n) {
            return function() {
                var prev = $('#' + selectedHero);
                if (prev) { prev.RemoveClass('lasthitHeroSelected'); }
                selectedHero = n;
                b.AddClass('lasthitHeroSelected');
            };
        })(heroButton, heroName));
        heroButton.SetPanelEvent('onmouseover', (function(b, n) {
            return function() {
                $.DispatchEvent('DOTAShowTextTooltip', b, prettifyHeroName(n));
            };
        })(heroButton, heroName));
        heroButton.SetPanelEvent('onmouseout', (function(b) {
            return function() { $.DispatchEvent('DOTAHideTextTooltip'); };
        })(heroButton));
    }
}

GameEvents.Subscribe('dotadb_get_hero_list_answer', saveHeroList);

// --- Start / Stop ---
function startLasthit() {
    var items = [];
    for (var i = 0; i < INVENTORY_SLOTS; i++) {
        if (inventory[i]) { items.push(inventory[i].name); }
    }
    var side = selectedSide;
    var sniper = $('#lasthitSniperToggle').checked ? 1 : 0;

    GameEvents.SendCustomGameEventToServer('lasthit_start', {
        hero: selectedHero,
        lane: 'mid',
        items: items,
        side: side,
        sniper: sniper
    });

    pickerPanel.AddClass('Hidden');
    hudPanel.RemoveClass('Hidden');
    errorMsg.text = '';
}

function stopLasthit() {
    GameEvents.SendCustomGameEventToServer('lasthit_end', {});
    hudPanel.AddClass('Hidden');
    pickerPanel.RemoveClass('Hidden');
    $('#lasthitGood').text = '0';
    $('#lasthitBad').text = '0';
    $('#lasthitAvg').text = '0.00s';
}

// Server emits refresh_lasthit_values from casting.lua on every detected hit.
function refreshLasthitValues(data) {
    if (data.killed !== undefined) { $('#lasthitGood').text = String(data.killed); }
    if (data.missed !== undefined) { $('#lasthitBad').text = String(data.missed); }
    if (data.avg !== undefined) { $('#lasthitAvg').text = data.avg; }
}

GameEvents.Subscribe('refresh_lasthit_values', refreshLasthitValues);

$('#lasthitSniperToggle').checked = true;
renderInventory();
drawItemsGrid();
updateCostLabel();
