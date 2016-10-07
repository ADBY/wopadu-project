local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


local imageDirectory = "images/Tutorial/"
local imageDirectory2 = "images/Login/"
local imageDirectory3 = "images/Product/"
local lineImg, close, nextBtn, appStatusText

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

local function storeData(name,data)
	local saveData = data
	local path = system.pathForFile( name, system.DocumentsDirectory )
	local file = io.open( path, "w" )
	file:write( saveData )
	io.close( file )
	file = nil
end

local function handleCloseEventListenerTap( event )
	if _Tutorial == "0" then
		_Tutorial = "1"
		storeData( "Tutorial", _Tutorial )
		composer.gotoScene( "welcomeScreen" )
	else
		composer.gotoScene( composer.getSceneName( "previous" ) )
	end
	
	return true
end

local function handleNextBtnEventListenerTap( event )
	_Tutorial = "1"
	storeData( "Tutorial", _Tutorial )
	composer.gotoScene( "tutorial" )
	
	return true
end



-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    
    local background = display.newImageRect( imageDirectory2.."Background.png", _W, _H )
    background.x = _W/2
    background.y = _H/2
    sceneGroup:insert( background )

end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        
        
        print( "In welcomeTutorial screen......" )
        
        print( _Tutorial )
        
        local options = {
        	text = "",
        	x = _W/2,
        	y = _H/2,
        	width = _W - _W/21.6,
        	height = 0,
        	font = _FontArr[6],
        	fontSize = _H/30 ,
        	align = "center"
        }
        
        appStatusText = display.newText( options )
		appStatusText:setFillColor( 1 )
		sceneGroup:insert( appStatusText )
		
		appStatusText.text = GBCLanguageCabinet.getText("welcomeLabel",_LanguageKey).." \n "..GBCLanguageCabinet.getText("toLabel",_LanguageKey).." \n Wopadu".." \n "..GBCLanguageCabinet.getText("demoLabel",_LanguageKey)
        
		close = widget.newButton(
		{
			width = (_W/5.5)*2,
			height = (_H/28.23)*2,
			defaultFile = imageDirectory3.."Selected_CheckBox2.png",
			overFile = imageDirectory3.."Selected_CheckBox2.png",
			label = "CLOSE",--GBCLanguageCabinet.getText("NextLabel",_LanguageKey),
			font = _FontArr[6],
			fontSize = _H/21.33,--forwardBtnTextSize
			labelYOffset = 5,
			labelColor = { default={1,1,1,1}, over={1,1,1,1} },
			--onEvent = handleButtonEvent,
		}
		)
		close.x = close.width/2 + _W/108
		close.y = _H - close.height/2 - _H/192
		close:addEventListener( "tap", handleCloseEventListenerTap  )
		sceneGroup:insert( close )
		
		--close = display.newText( "CLOSE", _W/36, lineImg.y + lineImg.height/2 + _H/64, _FontArr[30], _H/48 )
--		close.anchorX = 0
--		close.anchorY = 0
--        close:setFillColor( 1 )--206/255, 23/255, 100/255 )
--        close:addEventListener( "tap", handleCloseEventListenerTap )
--        sceneGroup:insert( close )
        
        nextBtn = widget.newButton(
		{
			width = (_W/5.5)*2,
			height = (_H/28.23)*2,
			defaultFile = imageDirectory3.."unSelected_CheckBox1.png",
			overFile = imageDirectory3.."unSelected_CheckBox1.png",
			label = "NEXT",--GBCLanguageCabinet.getText("NextLabel",_LanguageKey),
			font = _FontArr[6],
			fontSize = _H/21.33,--forwardBtnTextSize
			labelYOffset = 5,
			labelColor = { default={1,1,1,1}, over={1,1,1,1} },
			onPress = handleNextBtnEventListenerTap,
		}
		)
		nextBtn.x = _W - nextBtn.width/2 - _W/108
		nextBtn.y = _H - nextBtn.height/2 - _H/192
		--nextBtn:addEventListener( "tap", handleNextBtnEventListenerTap  )
		sceneGroup:insert( nextBtn )
        
        --nextBtn = display.newImageRect( imageDirectory.."ForwardArrow.png", _W/18, _H/36.22 )
        --nextBtn = display.newText( "NEXT", _W - _W/36, close.y, _FontArr[30], _H/48 )
--        nextBtn.anchorX = 1
--        nextBtn.anchorY = 0
--        nextBtn:setFillColor( 1 )--206/255, 23/255, 100/255 )
--		nextBtn:addEventListener( "tap", handleNextBtnEventListenerTap )
--		sceneGroup:insert( nextBtn )
        
        lineImg = display.newImageRect( imageDirectory.."DeviderLine2.png", _W, _H/384 )
		lineImg.x = _W/2
		lineImg.y = nextBtn.y - nextBtn.height/2 - _H/96
		sceneGroup:insert( lineImg )        
        

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        
        
        display.remove( lineImg )
        lineImg = nil
        
        display.remove( close )
        close = nil
        
        display.remove( nextBtn )
        nextBtn = nil
        
        display.remove( appStatusText )
        appStatusText = nil
        

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene