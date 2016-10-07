local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

local parent,notesGroup,notesScrollView,notes,param
local whiteBg,popUpBg,logo,Background


local ImageDirectory = "images/PopUp/"


local function onBgTouch( event )
	if( event.phase == "ended" ) then
		
		composer.hideOverlay( "fade", 400 )
		parent:resumeGame()
		
	end
	return true
end

local function onBgTap( event )
	
	composer.hideOverlay( "fade", 400 )
	parent:resumeGame()
	return true
	
end

local function onPopUpTap( event )

	return true
end

local function onPopUpTouch( event )
	
	return true
end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   
   
    
end

local function scrollListener( event )

	return true
end

-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
	parent = event.parent
	param = event.params
	
    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
        notesGroup = display.newGroup()
        sceneGroup:insert(notesGroup)
        
        
    whiteBg = display.newImageRect( "images/Login/White_Background.png", _W, _H )
    whiteBg.x = _W/2
    whiteBg.y = _H/2
    notesGroup:insert( whiteBg )
    
    Background = display.newImageRect(ImageDirectory.."Background.png",_W,_H)
    Background.x = _W/2
    Background.y = _H/2
    notesGroup:insert(Background)
    
    popUpBg = display.newImageRect(ImageDirectory.."PopUpBg.png",_W/1.15,_H/2.70)
    popUpBg.x = _W/2
    popUpBg.y = _H/3.07 + popUpBg.height/2
    
    notesGroup:insert(popUpBg)
    
    logo = display.newImageRect("images/Wopadu_Logo.png",_W/5.83,_H/10.37)
    logo.x = popUpBg.x
    logo.y = popUpBg.y - popUpBg.height/2.15	
    notesGroup:insert(logo)
        
        
        notesScrollView = widget.newScrollView
		{
    		top = _H/2.56,
    		left = _W/9.81,
    		width = _W/1.26,
    		height = _H/3.72,
    		scrollWidth = _W,
    		scrollHeight = _H * 2,
    		hideBackground = true,
    		horizontalScrollDisabled = true,
    		listener = scrollListener,
    		bottomPadding = _H/8
    	}
		notesGroup:insert( notesScrollView )
		
		notes = ""
        notes = param.noteValue
        --notes = "A unique double layered Paneer patty with a spicy creamy sauce, covered with fresh lettuce in a soft warm bun An oven baked omelette with onions & bell peppers; filled with Molten cheddar cheese, jalapenos, paprika & chillies & topped with a crispy Golden hash-brown - enclosed in a soft bun with spicy chilli mayo!"
        
       local option = {
		text = notes,
		font = _FontArr[26],
		fontSize = _H/40,
		width = notesScrollView.width ,
		height = 0
	}
	
	Label1 = display.newText(option)
	Label1.x = _W/216
	Label1.y = _H/384
	Label1.anchorX = 0
	Label1.anchorY = 0
	Label1:setFillColor( 83/255, 20/255, 111/255 )
	notesScrollView:insert(Label1)
        
        
local function onKeyEvent( event )
    -- If the "back" key was pressed on Android, then prevent it from backing out of your app.
	if (event.keyName == "back") and (system.getInfo("platformName") == "Android") and event.phase == "up"  then
    	
    	composer.hideOverlay( "fade", 400 )
		parent:resumeGame()
    
	end

	return true
end
        
      
Runtime:addEventListener( "key", onKeyEvent )
      
        
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        
        local function addEvents( event )
        	Background:addEventListener("touch",onBgTouch)
    		Background:addEventListener("tap",onBgTap)
        	
        	popUpBg:addEventListener("touch",onPopUpTouch)
    		popUpBg:addEventListener("tap",onPopUpTap)
        end
        
        timer.performWithDelay( 1000, addEvents)
        
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
        
        Label1.text = ""
        
        display.remove(Label1)
    	Label1 = nil 
        
        display.remove(notesScrollView)
        notesScrollView = nil
        
        display.remove(whiteBg)
        whiteBg = nil
        
        display.remove(popUpBg)
        popUpBg = nil
        
        display.remove(logo)
        logo = nil
        
        display.remove(Background)
        Background = nil
        
           
    
        display.remove(notesGroup)
        notesGroup = nil
        
        
        
        --parent:resumeGame()
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene