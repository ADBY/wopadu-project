local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------
local imageDirectory = "images/Login/"
local signInBtn,signUpBtn

local function handleButtonEvent( event )
	if( event.phase == "ended" ) then
		if( event.target.id == "signIn" ) then
		
			composer.gotoScene( "login" )
		elseif( event.target.id == "signUp" ) then
		
			composer.gotoScene( "signUp" )
		end
	end	
	return true
end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    
    local background = display.newImageRect( imageDirectory.."Background.png", _W, _H )
    background.x = _W/2
    background.y = _H/2
    sceneGroup:insert( background )
    
    local logo = display.newImageRect( "images/Wopadu_Logo.png", _W/1.8, _H/3.5 )
    logo.anchorY = 1
    logo.x = _W/2
    logo.y = _H/2.5
    sceneGroup:insert( logo )
    
    
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
        if( _LanguageKey == "ru" ) then
        	s_fontSize = _H/60
        elseif( _LanguageKey == "uk"  ) then
        	s_fontSize = _H/45
        else
        	s_fontSize = _H/30
        end
        
        signInBtn = widget.newButton
		{
    		width = _W/2.5,
    		height = _H/16.27,
    		defaultFile = imageDirectory.."NewSignIn_Btn2.png",
   			overFile = imageDirectory.."NewSignIn_Btn2.png",
    		label = GBCLanguageCabinet.getText("SignInLabel",_LanguageKey),
    		labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
    		labelYOffset = _H/275,
    		fontSize = s_fontSize,
    		font = _FontArr[6],
    		id = "signIn",
    		onEvent = handleButtonEvent
		}
		signInBtn.x = _W/2
		signInBtn.y = signInBtn.height/2 + _H/1.9
		sceneGroup:insert( signInBtn )
    
    
    signUpBtn = widget.newButton
		{
    		width = _W/2.5,
    		height = _H/16.27,
    		defaultFile = imageDirectory.."NewSignIn_Btn2.png",
   			overFile = imageDirectory.."NewSignIn_Btn2.png",
    		label = GBCLanguageCabinet.getText("SignUpLabel",_LanguageKey),
    		labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
    		labelYOffset = _H/275,
    		fontSize = s_fontSize,
    		font = _FontArr[6],
    		id = "signUp",
    		onEvent = handleButtonEvent
		}
		signUpBtn.x = _W/2
		signUpBtn.y = signInBtn.y + signInBtn.height + signUpBtn.height
		sceneGroup:insert( signUpBtn )
    
    
        
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
        
        display.remove( signInBtn )
        signInBtn = nil
        
        display.remove( signUpBtn )
        signUpBtn = nil
        
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