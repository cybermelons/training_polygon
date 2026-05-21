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
var selectedItems = {};
var currentItemsCost = 0;

var pickerPanel = $('#lasthitPicker');
var hudPanel = $('#lasthitHud');
var errorMsg = $('#errorMsg');
var costLabel = $('#lasthitItemsCost');

function updateCostLabel() {
    costLabel.text = currentItemsCost + ' / ' + ITEM_COST_CAP;
}

function drawItemsGrid() {
    var grid = $('#lasthitItemsGrid');
    for (var i = 0; i < LASTHIT_ITEMS.length; i++) {
        var itemName = LASTHIT_ITEMS[i][0];
        var cost = LASTHIT_ITEMS[i][1];
        var btn = $.CreatePanel('ToggleButton', grid, 'btn_' + itemName);
        btn.AddClass('lasthitItemButton');
        btn.SetAttributeString('itemname', itemName);
        btn.SetAttributeInt('cost', cost);

        var img = $.CreatePanel('DOTAItemImage', btn, 'img_' + itemName);
        img.itemname = itemName;
        img.AddClass('lasthitItemImage');

        var costLbl = $.CreatePanel('Label', btn, 'cost_' + itemName);
        costLbl.text = cost + 'g';
        costLbl.AddClass('lasthitItemCostLabel');

        btn.SetPanelEvent('onactivate', (function(b, n, c) {
            return function() { toggleItem(b, n, c); };
        })(btn, itemName, cost));

        btn.SetPanelEvent('onmouseover', (function(b, n) {
            return function() { $.DispatchEvent('DOTAShowAbilityTooltip', b, n); };
        })(btn, itemName));
        btn.SetPanelEvent('onmouseout', (function(b) {
            return function() { $.DispatchEvent('DOTAHideAbilityTooltip', b); };
        })(btn));
    }
}

function toggleItem(btn, itemName, cost) {
    if (selectedItems[itemName]) {
        delete selectedItems[itemName];
        currentItemsCost -= cost;
        btn.checked = false;
    } else {
        if (currentItemsCost + cost > ITEM_COST_CAP) {
            btn.checked = false;
            errorMsg.text = 'Item exceeds 600g cap.';
            return;
        }
        selectedItems[itemName] = true;
        currentItemsCost += cost;
        btn.checked = true;
        errorMsg.text = '';
    }
    updateCostLabel();
}

// --- Hero picker (mirrors dodge.js pattern) ---
var defaultHero = 'npc_dota_hero_antimage';
var heroPicker = $('#hero_picker');
var popupContainer = $('#lasthit_popup_container');
var heroPickerIcon = $('#hero_picker_selected');
heroPickerIcon.heroname = defaultHero;
var heroList = [];

GameEvents.SendCustomGameEventToServer('dotadb_get_hero_list', {});

function saveHeroList(data) {
    heroList = data.hero_list;
    var keys = [];
    for (var key in heroList) { keys[keys.length] = key; }
    for (var i = 0; i < keys.length - 1; i++) {
        for (var j = i + 1; j < keys.length; j++) {
            var nameA = heroList[keys[i]].replace('npc_dota_hero_', '');
            var nameB = heroList[keys[j]].replace('npc_dota_hero_', '');
            if (nameA > nameB) { var t = keys[i]; keys[i] = keys[j]; keys[j] = t; }
        }
    }
    var popup = $('#lasthit_hero_picker_popup');
    for (var i = 0; i < keys.length; i++) {
        var k = keys[i];
        var heroButton = $.CreatePanel('Button', popup, heroList[k]);
        heroButton.AddClass('heroPickerButton');
        var heroIcon = $.CreatePanel('DOTAHeroImage', heroButton, 'hero_icon_' + k);
        heroIcon.heroimagestyle = 'icon';
        heroIcon.heroname = heroList[k];
        if (heroList[k] == defaultHero) {
            heroButton.AddClass('heroPickerSelected');
        }
        heroButton.SetPanelEvent('onactivate', (function(b) {
            return function() {
                var prev = $('#' + defaultHero);
                if (prev) { prev.RemoveClass('heroPickerSelected'); }
                defaultHero = b.id;
                heroPickerIcon.heroname = defaultHero;
                b.AddClass('heroPickerSelected');
                popupContainer.style.opacity = '0';
                popupContainer.style.visibility = 'collapse';
            };
        })(heroButton));
    }
}

heroPicker.SetPanelEvent('onactivate', function() {
    popupContainer.style.opacity = '1';
    popupContainer.style.visibility = 'visible';
});
popupContainer.SetPanelEvent('onactivate', function() {
    popupContainer.style.opacity = '0';
    popupContainer.style.visibility = 'collapse';
});

GameEvents.Subscribe('dotadb_get_hero_list_answer', saveHeroList);

// --- Start / Stop ---
function startLasthit() {
    var items = [];
    for (var n in selectedItems) { items.push(n); }
    var side = $('#lasthitSideDire').checked ? 1 : 0;
    var sniper = $('#lasthitSniperToggle').checked ? 1 : 0;

    GameEvents.SendCustomGameEventToServer('lasthit_start', {
        hero: defaultHero,
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

drawItemsGrid();
updateCostLabel();
