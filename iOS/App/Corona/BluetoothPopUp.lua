local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

local ImageDirectory = "images/PopUp/"

local function handleButtonEvent( event )
    if ( "ended" == event.phase ) then
        print( "Button was pressed and released" )
        if(event.target.id == "CANCEL") then
        
        
        elseif(event.target.id == "okay") then
        
        
        end
    end
    return true
end


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    
    local whiteBg = display.newImageRect( "images/Login/White_Background.png", _W, _H )
    whiteBg.x = _W/2
    whiteBg.y = _H/2
    sceneGroup:insert( whiteBg )
    
    local Background = display.newImageRect(ImageDirectory.."Background.png",_W,_H)
    Background.x = _W/2
    Background.y = _H/2
    sceneGroup:insert(Background)
    
    local popUpBg = display.newImageRect(ImageDirectory.."PopUpBg.png",_W/1.15,_H/2.70)
    popUpBg.x = _W/2
    popUpBg.y = _H/3.07 + popUpBg.height/2
    sceneGroup:insert(popUpBg)
    
    local logo = display.newImageRect(ImageDirectory.."Logo.png",_W/5.83,_H/10.37)
    logo.x = popUpBg.x
    logo.y = popUpBg.y - popUpBg.height/2.15	
    sceneGroup:insert(logo)
    
    --130,1120
    
    

	local CancelButton = widget.newButton
	{
    	width = _W/2.79,
    	height = _H/14.65,
    	defaultFile = ImageDirectory.."Cancel_Btn2.png",
    	overFile = ImageDirectory.."Cancel_Btn2.png",
    	label = "CANCEL",
    	id = "CANCEL",
    	font = _FontArr[1],
    	fontSize = _H/27.55,
    	labelYOffset = -_H/192,
    	labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
    	onEvent = handleButtonEvent
	}

	-- Center the button
	CancelButton.x = _W/8.30 + CancelButton.width/2
	CancelButton.y = _H/1.71 + CancelButton.height/2
	sceneGroup:insert(CancelButton)
	
	local OkayButton = widget.newButton
	{
    	width = _W/2.79,
    	height = _H/14.65,
    	defaultFile = ImageDirectory.."Create_Btn2.png",
    	overFile = ImageDirectory.."Create_Btn2.png",
    	label = "okay",
    	id = "okay",
    	font = _FontArr[1],
    	fontSize = _H/27.55,
    	labelYOffset = -_H/192,
    	labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
    	onEvent = handleButtonEvent
	}

	-- Center the button
	OkayButton.x = _W/1.92 + OkayButton.width/2
	OkayButton.y = CancelButton.y
	sceneGroup:insert(OkayButton)
	
	local option = {
		text = "",
		font = _FontArr[7],
		fontSize = _H/31.48,
		
	}
	
	local Label1 = display.newText(option)
	Label1.text = "Wopadu"
	Label1.x = _W/2.55
	Label1.y = _H/2.37
	Label1.anchorX = 0
	Label1.anchorY = 0
	Label1:setFillColor( 83/255, 20/255, 111/255 )
	sceneGroup:insert(Label1)
	
	local option2 = {
		text = "",
		font = _FontArr[6],
		fontSize = _H/31.48,
		
	}
	
	local Label2 = display.newText(option2)
	Label2.text = "needs to"
	Label2.x = Label1.x + Label1.width + _W/54
	Label2.y = _H/2.37
	Label2.anchorX = 0
	Label2.anchorY = 0
	Label2:setFillColor( 83/255, 20/255, 111/255 )
	sceneGroup:insert(Label2)
	
	
	local Label3 = display.newText(option2)
	Label3.text = "switch on your"
	Label3.x = Label1.x
	Label3.y = Label1.y + Label1.height + _H/384
	Label3.anchorX = 0
	Label3.anchorY = 0
	Label3:setFillColor( 83/255, 20/255, 111/255 )
	sceneGroup:insert(Label3)
    
	
	local Label2 = display.newText(option)
	Label2.text = "Bluetooth"
	Label2.x = Label3.x + Label3.width + _W/54
	Label2.y = Label3.y
	Label2.anchorX = 0
	Label2.anchorY = 0
	Label2:setFillColor( 83/255, 20/255, 111/255 )
	sceneGroup:insert(Label2)
	
	local Label3 = display.newText(option2)
	Label3.text = "to connect to restaurant"
	Label3.x = Label1.x
	Label3.y = Label2.y + Label2.height + _H/384
	Label3.anchorX = 0
	Label3.anchorY = 0
	Label3:setFillColor( 83/255, 20/255, 111/255 )
	sceneGroup:insert(Label3)
	
	local chefImage = display.newImageRect(ImageDirectory.."ChefImg.png",_W/5.62,_H/6.76)
	chefImage.x = _W/6.17 + chefImage.width/2
	chefImage.y = _H/2.46 + chefImage.height/2
	sceneGroup:insert(chefImage)
	
    
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
        
        --95,625
        
        
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