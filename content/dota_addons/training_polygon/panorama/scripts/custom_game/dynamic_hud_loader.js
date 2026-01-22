// Dynamic HUD Loader - loads gamemode-specific HUD panels dynamically

var hudContainer = $.GetContextPanel();
var currentHud = null;
var currentHudName = null;

function clearHud() {
    $.Msg("[DynamicHudLoader] Clearing HUD");

    // Remove all children from the container
    $.Each(hudContainer.Children(), function(panel) {
        panel.DeleteAsync(0);
    });

    currentHud = null;
    currentHudName = null;
}

function loadHud(data) {
    var hudName = data.name;

    if (!hudName) {
        $.Msg("[DynamicHudLoader] Error: No HUD name provided");
        return;
    }

    $.Msg("[DynamicHudLoader] Loading HUD: " + hudName);

    // Clear existing HUD first
    clearHud();

    // Build the layout path: layout/custom_game/gamemode_hud/{name}/{name}.xml
    var layoutPath = "file://{resources}/layout/custom_game/gamemode_hud/" + hudName + "/" + hudName + ".xml";

    $.Msg("[DynamicHudLoader] Layout path: " + layoutPath);

    // Create a new panel and load the layout
    var hudPanel = $.CreatePanel("Panel", hudContainer, hudName + "_hud");
    var loadSuccess = hudPanel.BLoadLayout(layoutPath, false, false);

    if (loadSuccess) {
        $.Msg("[DynamicHudLoader] Successfully loaded HUD: " + hudName);
        currentHud = hudPanel;
        currentHudName = hudName;
    } else {
        $.Msg("[DynamicHudLoader] Failed to load HUD: " + hudName);
        hudPanel.DeleteAsync(0);
    }
}

function onClearHud(data) {
    clearHud();
}

// Subscribe to events
GameEvents.Subscribe("load_hud", loadHud);
GameEvents.Subscribe("clear_hud", onClearHud);

$.Msg("[DynamicHudLoader] Initialized");
