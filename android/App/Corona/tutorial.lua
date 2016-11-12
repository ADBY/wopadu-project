local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


local imageDirectory = "images/Tutorial/"
local imageDirectory2 = "images/Product/"
local lineImg, close, nextBtn, endX, beginX, k, totalNoImages
local imgArr = { }

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
	end
	
end

local function changeNextImage( )
	for i = 1, #imgArr do
		imgArr[i].isVisible = false
	end
	
	if(k == #imgArr) then
		k = 1
	else
		k = k + 1
	end
	
	imgArr[k].isVisible = true
	
end

local function changePreviousImage( )
	for i = 1, #imgArr do
		imgArr[i].isVisible = false
	end
	
	if(k == 1) then
		k = #imgArr
	else
		k = k - 1
	end
	
	imgArr[k].isVisible = true
	
end

local function checkDirection( )
	if(beginX > endX) then
		if((beginX - endX) > 10) then
			changeNextImage()
		end
		
	else
		if((endX - beginX) > 10) then
			changePreviousImage()
		end
		
	end
	
	return true
end

local function handleNextBtnEventListenerTap( event )
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
        
                        
        totalNoImages = 12
        
        for i = 1, totalNoImages do
        	imgArr[i] = display.newImageRect( imageDirectory..i..".png", _W, _H )
        	imgArr[i].x = _W/2
        	imgArr[i].y = _H/2
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
			label = "CLOSE",
			font = _FontArr[6],
			fontSize = _H/21.33,
			labelYOffset = 5,
			labelColor = { default={1,1,1,1}, over={1,1,1,1} },
		}
		)
		close.x = close.width/2 + _W/108
		close.y = _H - close.height/2 - _H/192
		close:addEventListener( "tap", handleCloseEventListenerTap  )
		sceneGroup:insert( close )
		
        nextBtn = widget.newButton(
		{
			width = (_W/5.5)*2,
			height = (_H/28.23)*2,
			defaultFile = imageDirectory2.."unSelected_CheckBox1.png",
			overFile = imageDirectory2.."unSelected_CheckBox1.png",
			label = "NEXT",
			font = _FontArr[6],
			fontSize = _H/21.33,
			labelYOffset = 5,
			labelColor = { default={1,1,1,1}, over={1,1,1,1} },
		}
		)
		nextBtn.x = _W - nextBtn.width/2 - _W/108
		nextBtn.y = _H - nextBtn.height/2 - _H/192
		nextBtn:addEventListener( "tap", handleNextBtnEventListenerTap  )
		sceneGroup:insert( nextBtn )
        
        lineImg = display.newImageRect( imageDirectory.."DeviderLine.png", _W, _H/384 )
		lineImg.x = _W/2
		lineImg.y = nextBtn.y - nextBtn.height/2 - _H/96
		sceneGroup:insert( lineImg )
        
        k = 1
        
        imgArr[k].isVisible = true
        
        
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