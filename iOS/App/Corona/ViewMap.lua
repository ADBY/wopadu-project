local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local forward references should go here

-- -------------------------------------------------------------------------------

local imageDirectory = "images/SignUp/"

local closeBtn, myMap, backBtn, addressText, heading


local function handleCloseButtonEvent( event )
	local options = {
		time = 400,
		effect = "slideDown"
	}
	composer.gotoScene( "RestaurantDetails", options )
	
	return true
end

local function handleBackButtonEvent( event )
	composer.gotoScene( "RestaurantDetails" )
	
	return true
end

local function handleButtonEvent( event )
	if( event.phase == "ended" ) then
		if( event.target.id == "Reached" ) then
			composer.gotoScene( "welcomeScreen" )
		end
	end
	return true
end


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    
    
   		local background = display.newImageRect( imageDirectory.."Background.png", _W, _H )
        background.x = _W/2
        background.y = _H/2
        sceneGroup:insert( background )
        
        local header = display.newImageRect( imageDirectory.."f_Header.png", _W, _H/13.61 )
        header.x = _W/2
        header.y = _H/27
        sceneGroup:insert( header )
        
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen)
        
        
        print( "In view map screen.........".._LanguageKey )
        
        heading = display.newText( GBCLanguageCabinet.getText("viewLocationLabel",_LanguageKey), _W/2, _H/27, _FontArr[30], _H/36.76 )
        heading:setFillColor( 1 )
        sceneGroup:insert( heading )
        
        --closeBtn = widget.newButton
--		{
--    		width = _W/9.47,
--    		height = _H/18.64,
--	    	defaultFile = "images/CancelBtn.png",
--   			overFile = "images/CancelBtn.png",
--    		id = "close",
--	    	--onEvent = handleButtonEvent
--		}
--		closeBtn.x = _W/13.5
--		closeBtn.y = _H/27
--		closeBtn:addEventListener("tap",handleCloseButtonEvent)
--		sceneGroup:insert( closeBtn )
		
		backBtn = widget.newButton
		{
    		width = _W/9,
    		height = _H/14.76,
	    	defaultFile = imageDirectory.."Back_Btn2.png",
   			overFile = imageDirectory.."Back_Btn2.png",
    		id = "back",
	    	--onEvent = handleButtonEvent
		}
		backBtn.x = _W/13.5
		backBtn.y = _H/27
		backBtn:addEventListener("tap",handleBackButtonEvent)
		sceneGroup:insert( backBtn )
		
		addressText = display.newText( GBCLanguageCabinet.getText("addressLabel", _LanguageKey).." : ", _W/21.6, _H - _H/7.68, _W - _W/13.5, 0, _FontArr[30], _H/38.4 )
        addressText.anchorX = 0
        addressText.anchorY = 0
        addressText:setFillColor( 206/255, 23/255, 100/255 )--83/255, 20/255, 111/255 )
        sceneGroup:insert( addressText )
        
        if _RestaurantData.address == "" or _RestaurantData.address == " " or _RestaurantData.address == nil then
        	addressText.text = ""
        	addressText.text = GBCLanguageCabinet.getText("addressLabel", _LanguageKey).." : NA"
        else
        	addressText.text = ""
        	addressText.text = GBCLanguageCabinet.getText("addressLabel", _LanguageKey).." : ".._RestaurantData.address
        end
		
		--ReachedBtn = widget.newButton
--		{
--    		width = _W/1.08,
--    		height = _H/16.27,
--    		defaultFile = "images/SignUp/SinUp_Btn.png",
--   			overFile = "images/SignUp/SinUp_Btn.png",
--    		label = GBCLanguageCabinet.getText("checkMenuLabel", _LanguageKey), 
--    		labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
--    		labelYOffset = _H/275,
--    		fontSize = _H/30,
--    		font = _FontArr[6],
--    		id = "Reached",
--    		onEvent = handleButtonEvent
--		}
--		ReachedBtn.x = _W/2
--		ReachedBtn.y = _H - ReachedBtn.height/2 - _H/38.4
--		sceneGroup:insert( ReachedBtn )
		
		myMap = native.newMapView( _W/2, _H/2 + _H/27.22 - _H/16, _W, _H - _H/4 )
		
		-- Display map as vector drawings of streets (other options are "satellite" and "hybrid")
		myMap.mapType = "standard"
		
		local function locationHandler( event )
		    if ( event.isError ) then
        		print( "Map Error: " .. event.errorMessage )
		    else
        		print( "The specified string is at: " .. event.latitude .. "," .. event.longitude )
		        --myMap:setCenter( event.latitude, event.longitude )
		        myMap:setCenter( tonumber(_RestaurantData.map_latitude), tonumber(_RestaurantData.map_longitude) )
        		--local lat, long = event.latitude, event.longitude
        		local lat, long = tonumber(_RestaurantData.map_latitude), tonumber(_RestaurantData.map_longitude)
		        myMap:addMarker( lat, long, { title = _RestaurantData.store_name, subtitle = _RestaurantData.description } )
		    end
		    
		end
		
		myMap:requestLocation( "Royal Complex, Dhebar Rd, Millpara, Bhakti Nagar, Rajkot, Gujarat 360002", locationHandler )
        
        
        
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen
        -- Insert code here to make the scene come alive
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen)
        -- Insert code here to "pause" the scene
        -- Example: stop timers, stop animation, stop audio, etc.
        
        
        display.remove( closeBtn )
        closeBtn = nil
        
        display.remove( backBtn )
        backBtn = nil
        
        display.remove( heading )
        heading = nil
        
        display.remove( addressText )
        addressText = nil
        
        display.remove( myMap )
        myMap = nil
        
        
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view
    -- Insert code here to clean up the scene
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