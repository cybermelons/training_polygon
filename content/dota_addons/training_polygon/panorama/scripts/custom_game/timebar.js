//since draggable panels duplicates on ui reload, i gonna create them in js, 
// because it is annoying to restart custom game every time to clear screen
var rootPanel = $.GetContextPanel();
/* $.Each(rootPanel.Children(), function( oPanel )
{
    oPanel.DeleteAsync(0)
}); */

/* var timebarContainer = $.CreatePanel('Panel', rootPanel, 'TimebarContainer');
timebarContainer.AddClass('TimebarContainer')
var resizeAnchor = $.CreatePanel('Panel', timebarContainer, 'ResizeAnchor');
resizeAnchor.AddClass("ResizeAnchor") */
var timebarContainer = $('#TimebarContainer')
var resizeAnchor =$('#ResizeAnchor')
var lockButton=$('#LockButton')
timebarContainer.SetDraggable(true);

var minWidth = 400;
var minHeight = 150;
var positionTemp = "";
var timeBarLocked=false;
// Resize state
var isResizing = false;
var resizeStartMouseX = 0;
var resizeStartMouseY = 0;
var resizeStartWidth = 0;
var resizeStartHeight = 0;
var resizeStartOffsetX = 0;
var resizeStartOffsetY = 0;
var mouseOffsetX = 0; // Offset between mouse and anchor at start
var mouseOffsetY = 0;

var isMouseOverAnchor = false;
var wasMouseDown = false;

// Calculate UI scale
var screenScaleX = 1 / rootPanel.actualuiscale_x;
var screenScaleY = 1 / rootPanel.actualuiscale_y;
$.Msg('UI scales:', screenScaleX, " ", screenScaleY);

//debug
/* var debugMouse=$.CreatePanel('Panel', rootPanel, 'debugMouse');
debugMouse.style.width="10px"
debugMouse.style.height="10px"
debugMouse.style.backgroundColor = '#00FF00'; */

// Drag handlers
$.RegisterEventHandler('DragStart', timebarContainer, OnDragStart);
$.RegisterEventHandler('DragEnter', timebarContainer, OnDragEnter);
$.RegisterEventHandler('DragLeave', timebarContainer, OnDragLeave);
$.RegisterEventHandler('DragDrop', timebarContainer, OnDragDrop);
$.RegisterEventHandler('DragEnd', timebarContainer, OnDragEnd);
$.RegisterEventHandler('DragMove', timebarContainer, OnDragMove);

function OnDragStart(panelId, dragCallbacks) {
    let mousePos = GameUI.GetCursorPosition();
    dragCallbacks.displayPanel = panelId;
    
    var dragStartOffsetX = mousePos[0] - timebarContainer.actualxoffset;
    var dragStartOffsetY = mousePos[1] - timebarContainer.actualyoffset;
    dragCallbacks.offsetX = dragStartOffsetX;
    dragCallbacks.offsetY = dragStartOffsetY;
}

function OnDragEnter(a, draggedPanel) {}
function OnDragMove(a, draggedPanel) {
    positionTemp = draggedPanel.style.position;
}
function OnDragLeave(panelId, draggedPanel) {}
function OnDragDrop(panelId, draggedPanel) {}
function OnDragEnd(panelId, draggedPanel) {
    draggedPanel.style.position = positionTemp;
    positionTemp = "";
}

// Track mouse over anchor
resizeAnchor.SetPanelEvent("onmouseover", function() {
    isMouseOverAnchor = true;
    if (!isResizing) {
        timebarContainer.SetDraggable(false);
    }
});

resizeAnchor.SetPanelEvent("onmouseout", function() {
    isMouseOverAnchor = false;
    if (!isResizing) {
        timebarContainer.SetDraggable(true);
    }
});
lockButton.SetPanelEvent("onmouseactivate", function() {
    if (timeBarLocked==false){
        timeBarLocked=true;
        timebarContainer.SetDraggable(false);
        lockButton.AddClass('Locked')
        $.Msg('Timebar locked')
    }else{
        timeBarLocked=false;
        timebarContainer.SetDraggable(true);
        lockButton.RemoveClass('Locked')
        $.Msg('Timebar unlocked')
    }
    
});
// Update resize and check mouse state
function UpdateResize() {
    var isMouseDown = GameUI.IsMouseDown(0);
    let mousePos = GameUI.GetCursorPosition();
    
    // Scale mouse position to UI space
    let scaledMouseX = mousePos[0] * screenScaleX;
    let scaledMouseY = mousePos[1] * screenScaleY;
    /* debugMouse.style.position=`${scaledMouseX}px ${scaledMouseY}px 0px` */
    // Detect mouse press
    if (isMouseDown && !wasMouseDown && !timeBarLocked) {
        if (isMouseOverAnchor) {
            isResizing = true;
            
            // Store starting values
            resizeStartMouseX = scaledMouseX;
            resizeStartMouseY = scaledMouseY;
            resizeStartWidth = timebarContainer.actuallayoutwidth;
            resizeStartHeight = timebarContainer.actuallayoutheight;
            resizeStartOffsetX=timebarContainer.actualxoffset;
            resizeStartOffsetY=timebarContainer.actualyoffset;
            mouseOffsetX=resizeStartMouseX-resizeStartWidth-resizeStartOffsetX
            mouseOffsetY=resizeStartMouseY-resizeStartHeight-resizeStartOffsetY
            timebarContainer.SetDraggable(false);
            $.Msg('=== RESIZE START ===');
            $.Msg('Start size: ' + resizeStartWidth + 'x' + resizeStartHeight);
            $.Msg('actual offset: ' + resizeStartOffsetX + 'x' + resizeStartOffsetY);
            $.Msg('mouse pos: ' + resizeStartMouseX + 'x' + resizeStartMouseY);
        }
    }
    
    // Detect mouse release
    if (!isMouseDown && wasMouseDown && !timeBarLocked) {
        if (isResizing) {
            isResizing = false;
            timebarContainer.SetDraggable(true);
            $.Msg('=== RESIZE END ===');
        }
    }
    
    wasMouseDown = isMouseDown;
    
    // Perform resize if active
    if (isResizing) {
        
        
        /* let newWidth = Math.max(minWidth,  scaledMouseX -resizeStartOffsetX);
        let newHeight = Math.max(minHeight, scaledMouseY -resizeStartOffsetY); */
        let mouseDeltaX=scaledMouseX-resizeStartMouseX
        let mouseDeltaY=scaledMouseY-resizeStartMouseY
        let newWidth = Math.max(minWidth,  (resizeStartWidth*screenScaleX+mouseDeltaX));
        let newHeight = Math.max(minHeight, (resizeStartHeight*screenScaleY+mouseDeltaY));
        timebarContainer.style.width = newWidth + "px";
        timebarContainer.style.height = newHeight + "px";
        /* $.Msg('=== RESIZing ===');
        $.Msg('mouse del: ' + mouseDeltaX + 'x' + mouseDeltaY); */
    }
    
    $.Schedule(0.01, UpdateResize);
}

// Start the update loop 
UpdateResize();