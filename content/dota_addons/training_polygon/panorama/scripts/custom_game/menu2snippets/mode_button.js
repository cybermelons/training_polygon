

var mode=$.GetContextPanel().GetAttributeString("mode", "")
var type=$.GetContextPanel().GetAttributeString("type", "")
var menuContent = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().GetParent();
var leftMenu = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent().FindChild("menu_left_bar");
var playButton=leftMenu.FindChild("menu_button_container").FindChild("menu_play")

// Per-mode thumbnails using existing addon PNGs. Modes not listed fall back
// to menu_other.png so unknown additions still render something.
var MODE_THUMBS = {
	dodge:    "manta_menu",
	timing:   "timing_training",
	lasthit:  "creep_radiant",
	aim_ez:   "aim",
	aim_med:  "aim2",
	aim_hard: "aim3",
	map_aim:  "map_aim",
	aim_move: "reaction_menu",
	glimpse:  "glimpse_train",
	armlet:   "armlet_menu",
	invoker:  "invoker_menu",
	hookshot: "hookshot_menu",
	shop:     "shop_menu",
	other:    "menu_other"
};
var thumbName = MODE_THUMBS[mode] || "menu_other";
var thumb = $('#mode_thumb');
thumb.SetImage('file://{images}/custom_game/' + thumbName + '.png');

var modeName=$('#mode_name')
modeName.text=mode
$.GetContextPanel().SetPanelEvent(
	"onactivate", 
	function() {
		$.Msg('clicked')
		/* clearMenuContentAndDrawModePanel()
		var mode_menu = $.CreatePanel( "Panel", menuContent, mode+"_menu" ); */
		/* var result=mode_menu.BLoadLayout( "file://{resources}/layout/custom_game/menu2snippets/gamemodes_hud/"+mode+"/"+mode+".xml", false, false );  */
		GameEvents.SendCustomGameEventToServer (
			"main_menu_load_page_request",
				{
					page:"file://{resources}/layout/custom_game/menu2snippets/gamemodes_hud/"+mode+"/"+mode+".xml"
				}
		);
		/* if (result){
			$.Msg('panel loaded ',mode)
		}else{
			$.Msg('panel not loaded ',mode)
		} */
	}
)


function clearMenuContentAndDrawModePanel(){
	playButton.checked=false
	$.Each(menuContent.Children(), function( oPanel )
	{
		oPanel.DeleteAsync(0)
	});
}