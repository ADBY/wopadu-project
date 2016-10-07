local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------
local imageDirectory = "images/SignUp/"
local imageDirectory2 = "images/Setting/"
local heading
local rectBg = { }
local title = { }
local titleName = { } 

local function handleBackButtonEvent( event )
	
	local previous = composer.getSceneName( "previous" )
	print( "##########".._PreviousSceneforSetting )
	if previous == "changePassword" or previous == "terms" or previous == "aboutUs" or previous == "RatePage" or previous == "ShareWopado_Overlay" then
		composer.gotoScene( _PreviousSceneforSetting )
	else
		composer.gotoScene( previous )
	end
	
	return true
end

local function handleBackButtonEventTouch( event )
	if event.phase == "ended" then
		local previous = composer.getSceneName( "previous" )
		if previous == "changePassword" or previous == "terms" or previous == "aboutUs" or previous == "RatePage" or previous == "ShareWopado_Overlay" then
			composer.gotoScene( _PreviousSceneforSetting )
		else
			composer.gotoScene( previous )
		end
	end

	return true
end


local function onRectTap( event )
	if(event.target.id == 1) then
		composer.gotoScene("changePassword") 
	elseif(event.target.id == 2) then
		composer.gotoScene("terms") 
	elseif(event.target.id == 3) then
		composer.gotoScene("aboutUs") 
	elseif(event.target.id == 4) then
		composer.gotoScene("RatePage") 
	elseif(event.target.id == 5) then
		shareFunc()
	end
	return true
end

local function onRectTouch( event )
	if(event.phase == "began") then
		if(event.target.id == 1) then
			composer.gotoScene("changePassword") 
		elseif(event.target.id == 2) then
			composer.gotoScene("terms") 
		elseif(event.target.id == 3) then
			composer.gotoScene("aboutUs") 
		elseif(event.target.id == 4) then
			composer.gotoScene("RatePage") 
		elseif(event.target.id == 5) then
			shareFunc()
		end
	end
	return true
end

function shareFunc(e)
    --[[for i = 1, #rectBg do
    
    	rectBg[i]:removeEventListener("tap",onRectTap)
		rectBg[i]:removeEventListener("touch",onRectTouch)
    	
    end ]]--   			
    
	composer.gotoScene( "ShareWopado_Overlay" )
					
    return true
end

--[[function scene:resumeGame()
    --code to resume game
    local function onActivateEvents()
    
    for i = 1, #rectBg do
    
    	rectBg[i]:addEventListener("tap",onRectTap)
		rectBg[i]:addEventListener("touch",onRectTouch)
    	
    end   

	end
    timer.performWithDelay(1500,onActivateEvents)
    
    return true
end]]--


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    
		local background = display.newImageRect( imageDirectory.."Background.png", _W, _H )
        background.x = _W/2
        background.y = _H/2
        sceneGroup:insert( background )
        
        local header = display.newImageRect( imageDirectory.."f_Header.png", _W, _H/13.61 )
        header.x = _W/2
        header.y = _H/27
        sceneGroup:insert( header )
        
        heading = display.newText( tostring(GBCLanguageCabinet.getText("settingLabel",_LanguageKey)), header.x, header.y, _FontArr[30], _H/36.76 )
        heading:setFillColor( 1 )
        sceneGroup:insert( heading )
      
		
	local backBtn = widget.newButton
	{
    	width = _W/9,
    	height = _H/14.76,
    	defaultFile = imageDirectory.."Back_Btn2.png",
   		overFile = imageDirectory.."Back_Btn2.png",
    	id = "back",
    	--onEvent = handleButtonEvent
	}
	backBtn.x = _W/13.5
	backBtn.y = header.y
	backBtn:addEventListener("tap",handleBackButtonEvent)
	sceneGroup:insert( backBtn )
		
	
    
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
        heading.text = tostring(GBCLanguageCabinet.getText("settingLabel",_LanguageKey))
        print( "previous scene name is :::>>>>>> ".._PreviousSceneforSetting )
        
        rectBg = { }
		title = { } 
		
		titleName = {tostring(GBCLanguageCabinet.getText("ChangePasswordLabel",_LanguageKey)),tostring(GBCLanguageCabinet.getText("termsCondiLabel",_LanguageKey)),tostring(GBCLanguageCabinet.getText("AboutUsLabel",_LanguageKey)),tostring(GBCLanguageCabinet.getText("RateWopaduLabel",_LanguageKey)),tostring(GBCLanguageCabinet.getText("shareLabel",_LanguageKey))}
		
		for i = 1, #titleName do
		
			rectBg[i] = display.newImageRect(imageDirectory2.."RowBg.png",_W,_H/12.22)
			rectBg[i].x = _W/2
			rectBg[i].y = _H/13.61 + ((i-1) * _H/12.20)
			rectBg[i].anchorY = 0
			rectBg[i].id = i
			rectBg[i]:addEventListener("tap",onRectTap)
			rectBg[i]:addEventListener("touch",onRectTouch)
			sceneGroup:insert(rectBg[i])
			
			title[i] = display.newText(titleName[i],_W/54,rectBg[i].y + rectBg[i].height/2,_FontArr[6],_H/36.76)
			title[i]:setTextColor( 83/255 ,20/255 ,111/255) 
			title[i].anchorX = 0
			sceneGroup:insert(title[i])
			
		end
        
        
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