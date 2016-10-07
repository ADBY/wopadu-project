local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


local imageDirectory = "images/Tutorial/"
local imageDirectory2 = "images/Product/"
local lineImg, close, nextBtn, endX, beginX, k, totalNoImages
local imgArr = { }
--local dot = { }
--local dot2 = { }


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
	if composer.getSceneName( "previous" ) == "welcomeTutorialScreen" then
		composer.gotoScene( "welcomeScreen" )
	else
		composer.gotoScene( composer.getSceneName( "previous" ) )
	end
	
	return true
end

local function changeNextImage2( )
	for i = 1, #imgArr do
		imgArr[i].isVisible = false
		--dot2[i].isVisible = false
--		dot[i].isVisible = true
	end
	
	if(k == #imgArr) then
		k = 1
		if composer.getSceneName( "previous" ) == "welcomeTutorialScreen" then
			composer.gotoScene( "welcomeScreen" )
		else
			composer.gotoScene( composer.getSceneName( "previous" ) )
		end
		
	else
		k = k + 1
		
		imgArr[k].isVisible = true
		--dot2[k].isVisible = true
--		dot[k].isVisible = false
	end
	
end

local function changeNextImage( )
	for i = 1, #imgArr do
		imgArr[i].isVisible = false
		--dot2[i].isVisible = false
--		dot[i].isVisible = true
	end
	
	if(k == #imgArr) then
		k = 1
	else
		k = k + 1
	end
	
	imgArr[k].isVisible = true
	--dot2[k].isVisible = true
--	dot[k].isVisible = false
	
end

local function changePreviousImage( )
	for i = 1, #imgArr do
		imgArr[i].isVisible = false
		--dot2[i].isVisible = false
--		dot[i].isVisible = true
	end
	
	if(k == 1) then
		k = #imgArr
	else
		k = k - 1
	end
	
	imgArr[k].isVisible = true
	--dot2[k].isVisible = true
--	dot[k].isVisible = false
	
end

local function checkDirection( )
	print( beginX, endX )
	if(beginX > endX) then
		if((beginX - endX) > 10) then
			print( "swipe right" )
			changeNextImage()
		end
		
	else
		if((endX - beginX) > 10) then
			print( "swipe left" )
			changePreviousImage()
		end
		
	end
	
	return true
end

local function handleNextBtnEventListenerTap( event )
	print( ">>>>" )
	changeNextImage2()
	
	return true
end

local function handleImageEventListener( event )
	if(event.phase == "began") then
		beginX = event.x
		
	elseif(event.phase == "moved") then
		endX = event.x
		
	elseif(event.phase == "ended") then
		if(beginX and endX) then
			checkDirection()
		end
		
	end
	
	return true
end



-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    
    local background = display.newImageRect( imageDirectory.."Background.png", _W, _H )
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
        
        
        print( "In tutorial screen....." )
        print( composer.getSceneName( "previous" ) )
        
        --if composer.getSceneName( "previous" ) == nil then
--        	totalNoImages = 7
--        else
--        	totalNoImages = 12
--        end
        
        totalNoImages = 12
        
        for i = 1, totalNoImages do
        	imgArr[i] = display.newImageRect( imageDirectory..i..".png", _W, _H )
        	imgArr[i].x = _W/2
        	imgArr[i].y = _H/2 --- _H/38.4
        	imgArr[i]:addEventListener( "touch", handleImageEventListener )
        	sceneGroup:insert( imgArr[i] )
        	imgArr[i].isVisible = false
        	
        end
        
		close = widget.newButton(
		{
			width = (_W/5.5)*2,
			height = (_H/28.23)*2,
			defaultFile = imageDirectory2.."Selected_CheckBox2.png",
			overFile = imageDirectory2.."Selected_CheckBox2.png",
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
--        close:setFillColor( 206/255, 23/255, 100/255 )
--        close:addEventListener( "tap", handleCloseEventListenerTap )
--        sceneGroup:insert( close )
        
        nextBtn = widget.newButton(
		{
			width = (_W/5.5)*2,
			height = (_H/28.23)*2,
			defaultFile = imageDirectory2.."unSelected_CheckBox1.png",
			overFile = imageDirectory2.."unSelected_CheckBox1.png",
			label = "NEXT",--GBCLanguageCabinet.getText("NextLabel",_LanguageKey),
			font = _FontArr[6],
			fontSize = _H/21.33,--forwardBtnTextSize
			labelYOffset = 5,
			labelColor = { default={1,1,1,1}, over={1,1,1,1} },
			--onEvent = handleButtonEvent,
		}
		)
		nextBtn.x = _W - nextBtn.width/2 - _W/108
		nextBtn.y = _H - nextBtn.height/2 - _H/192
		nextBtn:addEventListener( "tap", handleNextBtnEventListenerTap  )
		sceneGroup:insert( nextBtn )
        
        --nextBtn = display.newImageRect( imageDirectory.."ForwardArrow.png", _W/18, _H/36.22 )
        --nextBtn = display.newText( "NEXT", _W - _W/36, close.y, _FontArr[30], _H/48 )
--        nextBtn.anchorX = 1
--        nextBtn.anchorY = 0
--        nextBtn:setFillColor( 206/255, 23/255, 100/255 )
--		nextBtn:addEventListener( "tap", handleNextBtnEventListenerTap )
--		sceneGroup:insert( nextBtn )
        
        lineImg = display.newImageRect( imageDirectory.."DeviderLine.png", _W, _H/384 )
		lineImg.x = _W/2
		lineImg.y = nextBtn.y - nextBtn.height/2 - _H/96
		sceneGroup:insert( lineImg )
        
        --[[for i = 1, #imgArr do
        	if i == 1 then
        		dot2[i] = display.newImageRect( imageDirectory.."pink.png", _W/36,_H/64 )
    	    	dot2[i].x = _W/2 - dot2[i].width*(#imgArr-1)
        		dot2[i].y = close.y + close.height/2
        		dot2[i].alpha = 0.5
        		sceneGroup:insert( dot2[i] )
        		
	        	dot[i] = display.newImageRect( imageDirectory.."pink.png", dot2[i].width,dot2[i].height )
    	    	dot[i].x = dot2[i].x
        		dot[i].y = dot2[i].y
        		sceneGroup:insert( dot[i] )
        		
        	else
        		dot2[i] = display.newImageRect( imageDirectory.."pink.png", _W/36,_H/64 )
    	    	dot2[i].x = dot[i-1].x + dot[i-1].width*2
        		dot2[i].y = dot[i-1].y
        		dot2[i].alpha = 0.5
        		sceneGroup:insert( dot2[i] )
        		
        		dot[i] = display.newImageRect( imageDirectory.."pink.png", dot2[i].width,dot2[i].height )
    	    	dot[i].x = dot2[i].x
        		dot[i].y = dot2[i].y
        		sceneGroup:insert( dot[i] )
        		
        	end
        	
        	--dot2[i].isVisible = false
--	        dot[i].isVisible = false
        	
        end]]--
        
        k = 1
        
        --for i = 1, #imgArr do
--        	dot2[i].isVisible = false
--	        dot[i].isVisible = true
--        end
        
        imgArr[k].isVisible = true
        --dot2[k].isVisible = true
--        dot[k].isVisible = false
        

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
        
        for i = 1, #imgArr do
        	display.remove( imgArr[i] )
	        imgArr[i] = nil
        end
        imgArr = { }
        
        --for i = 1, #dot2 do
--        	display.remove( dot2[i] )
--	        dot2[i] = nil
--        end
--        dot2 = { }
        
        --for i = 1, #dot do
--        	display.remove( dot[i] )
--	        dot[i] = nil
--        end
--        dot = { }
        
        endX = nil
        beginX = nil
        k = nil
        
        
        

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