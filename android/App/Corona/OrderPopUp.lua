local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

local parent
local whiteBg,Background,popUpBg,logo,Label1,Label3,chefImage,OkayButton

local ImageDirectory = "images/PopUp/"

local function handleButtonEvent( event )
    if ( "ended" == event.phase ) then
        print( "Button was pressed and released" )
        if(event.target.id == "OKAY") then
        
        	composer.gotoScene( "menu" )
        	
        end
    end
    return true
end

local function onBgTouch( event )
	if( event.phase == "began" ) then
	
		
		--composer.hideOverlay( "fade", 400 )
		--parent:resumeGame()
		composer.gotoScene("menu")
		
	end
	return true
end

local function onBgTap( event )
	
	
	--composer.hideOverlay( "fade", 400 )
	--parent:resumeGame()
	composer.gotoScene("menu")
	return true
	
end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    
    
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
	parent = event.parent
    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
     if( _LanguageKey == "ja" or _LanguageKey == "ru" or _LanguageKey == "th" or _LanguageKey == "uk") then
    	letterFontSize = _H/38
    
    else
    	letterFontSize = _H/31.48
    
    end     
        
        
    whiteBg = display.newImageRect( "images/Login/White_Background.png", _W, _H )
    whiteBg.x = _W/2
    whiteBg.y = _H/2
    sceneGroup:insert( whiteBg )
    
    Background = display.newImageRect(ImageDirectory.."Background.png",_W,_H)
    Background.x = _W/2
    Background.y = _H/2
    Background:addEventListener("touch",onBgTouch)
    Background:addEventListener("tap",onBgTap)
    sceneGroup:insert(Background)
    
    popUpBg = display.newImageRect(ImageDirectory.."PopUpBg.png",_W/1.15,_H/2.70)
    popUpBg.x = _W/2
    popUpBg.y = _H/3.07 + popUpBg.height/2
    sceneGroup:insert(popUpBg)
    
    logo = display.newImageRect("images/Wopadu_Logo.png",_W/5.83,_H/10.37)
    logo.x = popUpBg.x
    logo.y = popUpBg.y - popUpBg.height/2.15	
    sceneGroup:insert(logo)
    
    
	OkayButton = widget.newButton
	{
    	width = _W/1.32,
    	height = _H/14.65,
    	defaultFile = ImageDirectory.."CheckOutStatus_Btn2.png",
    	overFile = ImageDirectory.."CheckOutStatus_Btn2.png",
    	label = GBCLanguageCabinet.getText("OkayLabel",_LanguageKey),
    	id = "OKAY",
    	font = _FontArr[1],
    	fontSize = _H/38,
    	labelYOffset = -_H/192,
    	labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
    	onEvent = handleButtonEvent
	}

	-- Center the button
	OkayButton.x = _W/8.30 + OkayButton.width/2
	OkayButton.y = _H/1.71 + OkayButton.height/2
	sceneGroup:insert(OkayButton)
	
	
	
	local option = {
		text = "",
		font = _FontArr[7],
		fontSize = letterFontSize,
		align = "center"
	}
	
	local option2 = {
		text = "",
		font = _FontArr[6],
		fontSize = letterFontSize,
		width = _W/2
	}
	
	Label1 = display.newText(option2)
	Label1.text = GBCLanguageCabinet.getText("OrderPopupLabel",_LanguageKey)
	Label1.x = _W/2.55
	Label1.y = _H/2.45
	Label1.anchorX = 0
	Label1.anchorY = 0
	Label1:setFillColor( 83/255, 20/255, 111/255 )
	sceneGroup:insert(Label1)
	
	Label3 = display.newText(option)
	Label3.text = GBCLanguageCabinet.getText("ThankYouLabel",_LanguageKey)
	Label3.x = Label1.x + Label1.width/2
	Label3.y = Label1.y + Label1.height + _H/384
	--Label3.anchorX = 0
	Label3.anchorY = 0
	Label3:setFillColor( 83/255, 20/255, 111/255 )
	sceneGroup:insert(Label3)
	
	chefImage = display.newImageRect(ImageDirectory.."likeBtn.png",_W/4.32,_H/8.10)
	chefImage.x = _W/8 + chefImage.width/2
	chefImage.y = _H/2.35 + chefImage.height/2
	sceneGroup:insert(chefImage)
	
    
       
local function onKeyEvent( event )
    -- If the "back" key was pressed on Android, then prevent it from backing out of your app.
	if (event.keyName == "back") and (system.getInfo("platformName") == "Android") and event.phase == "up"  then
    	
    	composer.gotoScene("menu")
		
	end

	return true
end
        
      
--Runtime:addEventListener( "key", onKeyEvent )
        
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
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
        
        display.remove( whiteBg )
        whiteBg = nil
        
        display.remove( Background )
        Background = nil
        
        display.remove( popUpBg )
        popUpBg = nil
        
        display.remove( logo )
        logo = nil
        
        display.remove( Label1 )
        Label1 = nil
        
        display.remove( Label3 )
        Label3 = nil
        
        display.remove( chefImage )
        chefImage = nil
        
        display.remove( OkayButton )
        OkayButton = nil
        
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