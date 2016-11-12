local scene = composer.newScene()
  
  
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local forward references should go here

-- -------------------------------------------------------------------------------
local imageDirectory = "images/SignUp/"
local imageDirectory2 = "images/Setting/"
local backBtn, restaurantListScrollView, restaurantListRequest, latitudeText, longitudeText, locationTimer, restImageCount, heading
local restaurantListGroup
local restaurantList = { }
local rectBg = { }
local title = { }

local address = { }
local restaurantImg = { }
local restaurantDescri = { }
local restaurantImageRequest = { }


local function onDoNothing()
	return true
end

local function handleOk( event )
	if _PreviousSceneforSetting == nil then
		native.requestExit()
	else
		composer.gotoScene( "menu" )
	end
	return true
end

local function handleBackButtonEvent( event )
	if _PreviousSceneforSetting == nil then
		native.requestExit()
	else
		composer.gotoScene( _PreviousSceneforSetting )
	end
	
	return true
end

local function onRectTap( event )
	_RestaurantData = restaurantList[event.target.id]
	composer.gotoScene( "RestaurantDetails" )
	
	return true
end

local function onRectTouch( event )
	if(event.phase == "began") then
		_RestaurantData = restaurantList[event.target.id]
		composer.gotoScene( "RestaurantDetails" )
		
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
        latitudeText = ""
        longitudeText = ""
        
        heading = display.newText( GBCLanguageCabinet.getText("restaurantLabel",_LanguageKey), _W/2, _H/27, _FontArr[30], _H/36.76 )
        heading:setFillColor( 1 )
        sceneGroup:insert( heading )
        
	backBtn = widget.newButton
	{
    	width = _W/9,
    	height = _H/14.76,
    	defaultFile = imageDirectory.."Back_Btn2.png",
   		overFile = imageDirectory.."Back_Btn2.png",
    	id = "back",
	}
	backBtn.x = _W/13.5
	backBtn.y = _H/27
	backBtn:addEventListener("tap",handleBackButtonEvent)
	sceneGroup:insert( backBtn )
        
        restaurantListGroup = display.newGroup()
        sceneGroup:insert( restaurantListGroup )
        
        if( composer.getSceneName("previous") == nil ) then
        	backBtn.isVisible = false
        else
        	backBtn.isVisible = true
        end
        
        
restaurantListScrollView = widget.newScrollView(
    {
        top = _H/13.61,
        left = 0,
        width = _W,
        height = _H - _H/13.61,
        scrollWidth = _W,
        scrollHeight = _H,
        horizontalScrollDisabled = true,
        listener = scrollListener
    }
)
restaurantListGroup:insert( restaurantListScrollView )    

	local function displayData( )
	
		rectBg = { }
		title = { }
		address = { }
		restaurantImg = { }
		restaurantDescri = { }
		restaurantImageRequest = { }
			
		for i = 1, #restaurantList do
		
			if( i == 1 ) then
			
				rectBg[i] = display.newImageRect(imageDirectory2.."RowBg.png",_W,_H/6)
				rectBg[i].x = _W/2
				rectBg[i].y =  ((i-1) * _H/6)
				rectBg[i].anchorY = 0
				rectBg[i].id = i
				rectBg[i]:addEventListener("tap",onRectTap)
				restaurantListScrollView:insert(rectBg[i])
			
				title[i] = display.newText(restaurantList[i].store_name,_W/4,rectBg[i].y + rectBg[i].height/6,_FontArr[6],_H/36.76)
				title[i]:setTextColor( 205/255, 34/255, 100/255 ) 
				title[i].anchorX = 0
				restaurantListScrollView:insert(title[i])
				local add
				if( restaurantList[i].address == nil or restaurantList[i].address == "" ) then
					add = "NA"
				else
					add = restaurantList[i].address
				end
				local addressValue 
				if( add:len() > 85 ) then
					addressValue = add:sub( 1,82 ).."..."
				else
					addressValue = add
				end
				
				address[i] = display.newText(addressValue,_W/4,title[i].y + title[i].height/2,_W - _W/3.5,0,_FontArr[30],_H/45)
				address[i]:setTextColor( 83/255 ,20/255 ,111/255) 
				address[i].anchorX = 0
				address[i].anchorY = 0
				restaurantListScrollView:insert(address[i]) 
				
				if( restaurantList[i].image == nil or restaurantList[i].image == "") then
				
					restaurantImg[i] = display.newImage("images/defaultImage.png")
					restaurantImg[i].height = _W/4.5/(restaurantImg[i].width/restaurantImg[i].height)
					restaurantImg[i].width = _W/4.5
	
					if(restaurantImg[i].height > _H/8) then
						restaurantImg[i].height = _H/8
						restaurantImg[i].y = rectBg[i].y + rectBg[i].height/2
					else	
						restaurantImg[i].y =  rectBg[i].y + rectBg[i].height/2
					end
				
					restaurantImg[i].x = _W/108 + restaurantImg[i].width/2
					restaurantImg[i].y =  rectBg[i].y + rectBg[i].height/2
					restaurantImg[i].id = i
					restaurantListScrollView:insert(restaurantImg[i])
				
				else
				
					local imagePath = system.pathForFile( "Restaurant"..restaurantList[i].id..".png",system.TemporaryDirectory )
    				local imageFile = io.open( imagePath, "r" )
    
    				if(imageFile == nil) then
    				
    				else
					restaurantImg[i] = display.newImage("Restaurant"..restaurantList[i].id..".png",system.TemporaryDirectory)
					restaurantImg[i].height = _W/4.5/(restaurantImg[i].width/restaurantImg[i].height)
					restaurantImg[i].width = _W/4.5
	
					if(restaurantImg[i].height > _H/8) then
						restaurantImg[i].height = _H/8
						restaurantImg[i].y = rectBg[i].y + rectBg[i].height/2
					else	
						restaurantImg[i].y =  rectBg[i].y + rectBg[i].height/2
					end
				
					restaurantImg[i].x = _W/108 + restaurantImg[i].width/2
					restaurantImg[i].y =  rectBg[i].y + rectBg[i].height/2
					restaurantImg[i].id = i
					restaurantListScrollView:insert(restaurantImg[i])
						
					end
				
				end
				
				local description = restaurantList[i].description
				local descriValue 
				if( description:len() > 85 ) then
					descriValue = description:sub( 1,82 ).."..."
				else
					descriValue = description
				end
				
				restaurantDescri[i] = display.newText(descriValue,_W/4,address[i].y + address[i].height + _H/384,_W - _W/3.5,_H/12,_FontArr[10],_H/40)
				restaurantDescri[i]:setTextColor( 83/255 ,20/255 ,111/255) 
				restaurantDescri[i].anchorX = 0
				restaurantDescri[i].anchorY = 0
				restaurantListScrollView:insert(restaurantDescri[i]) 
				
			else
		
				rectBg[i] = display.newImageRect(imageDirectory2.."RowBg.png",_W,_H/6)
				rectBg[i].x = _W/2
				rectBg[i].y =  ((i-1) * _H/6)
				rectBg[i].anchorY = 0
				rectBg[i].id = i
				rectBg[i]:addEventListener("tap",onRectTap)
				restaurantListScrollView:insert(rectBg[i])
			
				title[i] = display.newText(restaurantList[i].store_name,_W/4,rectBg[i].y + rectBg[i].height/6,_FontArr[6],_H/36.76)
				title[i]:setTextColor( 205/255, 34/255, 100/255 ) 
				title[i].anchorX = 0
				restaurantListScrollView:insert(title[i])
				
				local add
				if( restaurantList[i].address == nil or restaurantList[i].address == "" ) then
					add = "NA"
				else
					add = restaurantList[i].address
				end
				local addressValue 
				if( add:len() > 85 ) then
					addressValue = add:sub( 1,82 ).."..."
				else
					addressValue = add
				end
				
				address[i] = display.newText(addressValue,_W/4,title[i].y + title[i].height/2,_W - _W/3.5,0,_FontArr[30],_H/45)
				address[i]:setTextColor( 83/255 ,20/255 ,111/255) 
				address[i].anchorX = 0
				address[i].anchorY = 0
				restaurantListScrollView:insert(address[i]) 
				
				if( restaurantList[i].image == nil or restaurantList[i].image == "") then
				
					restaurantImg[i] = display.newImage("images/defaultImage.png")
					restaurantImg[i].height = _W/4.5/(restaurantImg[i].width/restaurantImg[i].height)
					restaurantImg[i].width = _W/4.5
	
					if(restaurantImg[i].height > _H/8) then
						restaurantImg[i].height = _H/8
						restaurantImg[i].y = rectBg[i].y + rectBg[i].height/2
					else	
						restaurantImg[i].y =  rectBg[i].y + rectBg[i].height/2
					end
				
					restaurantImg[i].x = _W/108 + restaurantImg[i].width/2
					restaurantImg[i].y =  rectBg[i].y + rectBg[i].height/2
					restaurantImg[i].id = i
					restaurantListScrollView:insert(restaurantImg[i])
				
				else
				
					local imagePath = system.pathForFile( "Restaurant"..restaurantList[i].id..".png",system.TemporaryDirectory )
    				local imageFile = io.open( imagePath, "r" )
    
    				if(imageFile == nil) then
    				
    				
    				else
					restaurantImg[i] = display.newImage("Restaurant"..restaurantList[i].id..".png",system.TemporaryDirectory)
					restaurantImg[i].height = _W/4.5/(restaurantImg[i].width/restaurantImg[i].height)
					restaurantImg[i].width = _W/4.5
	
					if(restaurantImg[i].height > _H/8) then
						restaurantImg[i].height = _H/8
						restaurantImg[i].y = rectBg[i].y + rectBg[i].height/2
					else	
						restaurantImg[i].y =  rectBg[i].y + rectBg[i].height/2
					end
				
					restaurantImg[i].x = _W/108 + restaurantImg[i].width/2
					restaurantImg[i].y =  rectBg[i].y + rectBg[i].height/2
					restaurantImg[i].id = i
					restaurantListScrollView:insert(restaurantImg[i])
						
					end
				
				end
				
				local description = restaurantList[i].description
				local descriValue 
				if( description:len() > 85 ) then
					descriValue = description:sub( 1,82 ).."..."
				else
					descriValue = description
				end
				
				restaurantDescri[i] = display.newText(descriValue,_W/4,address[i].y + address[i].height + _H/384,_W - _W/3.5,_H/12,_FontArr[10],_H/40)
				restaurantDescri[i]:setTextColor( 83/255 ,20/255 ,111/255 ) 
				restaurantDescri[i].anchorX = 0
				restaurantDescri[i].anchorY = 0
				restaurantListScrollView:insert(restaurantDescri[i]) 
				
			
			end
			
		end
	
	
	end

	local function passLocation( )
		
		local function restaurantListNetworkListener( event )
		if ( event.isError ) then
    		
    		timer.performWithDelay( 200, function() 
			native.setActivityIndicator( false )
			end )
    		
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )

		else
			
			native.setActivityIndicator( true )
			
			if( event.response == "0" or event.response == 0 ) then
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				
				timer.performWithDelay( 200, function() 
				native.setActivityIndicator( false )
				end )
				
			elseif( event.response == "0" or event.response == 0 ) then
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				
				timer.performWithDelay( 200, function() 
				native.setActivityIndicator( false )
				end )
				
			elseif( event.response == "2" or event.response == 2 ) then
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("13Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				
				timer.performWithDelay( 200, function() 
				native.setActivityIndicator( false )
				end )
				
			else
			
			restaurantList = json.decode( event.response )
			restImageCount = 0
			restaurantImageRequest = {} 
			
			local function networkListenerRestuarantImage( event )
				if ( event.isError ) then
					restImageCount = restImageCount + 1
					if restImageCount == #restaurantList then
		
						timer.performWithDelay( 200, function() 
						native.setActivityIndicator( false )
						end )
			
						displayData()
        
        			end
        
    			elseif ( event.phase == "began" ) then
		
    			elseif ( event.phase == "ended" ) then
		
					restImageCount = restImageCount + 1
		
					if restImageCount == #restaurantList then
		
						timer.performWithDelay( 200, function() 
						native.setActivityIndicator( false )
						end )
			
						displayData()
        			end
        
    			end
			end	
			
			for i = 1, #restaurantList do
			
			
				if( restaurantList[i].image == nil or restaurantList[i].image == "" ) then
					restImageCount = restImageCount + 1
					if restImageCount == #restaurantList then
		
						timer.performWithDelay( 200, function() 
						native.setActivityIndicator( false )
						end )
			
						displayData()
        
        			end
				else
				
					restaurantImageRequest[i] = network.download(
        				restaurantList[i].image,
    					"GET",
   						networkListenerRestuarantImage,
    					params,
    					"Restaurant"..restaurantList[i].id..".png",
    					system.TemporaryDirectory
					)
				end
			
			end
			
			end
		
			end
		
		end
		
		if( latitudeText == "" or latitudeText == nil or longitudeText == nil or longitudeText == nil ) then
		
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("GPSAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey)}, handleOk  )

		else
		
		local url
		
		if _LanguageKey == "en" then
			url = _WebLink.."store-locator.php?map_latitude="..latitudeText.."&map_longitude="..longitudeText
		else
			url = _WebLink.."store-locator.php?map_latitude="..latitudeText.."&map_longitude="..longitudeText.."&lang=".._LanguageKey
		end
		
		restaurantListRequest = network.request( url, "GET", restaurantListNetworkListener )
		native.setActivityIndicator( true )
		
		end
		
	end
	
		
local locationHandler = function( event )
	
    if ( event.errorCode ) then
        native.showAlert( "GPS Location Error", event.errorMessage, {GBCLanguageCabinet.getText("okLabel",_LanguageKey)}, onDoNothing )
        
    else
        latitudeText = string.format( '%.4f', event.latitude )
        longitudeText = string.format( '%.4f', event.longitude )
        
    end
end

Runtime:addEventListener( "location", locationHandler )

local function checkLocation( event )
	
	if event.count == 10 then
		
		timer.performWithDelay( 200, function() 
		native.setActivityIndicator( false )
		end )
		
		if latitudeText:len() and longitudeText:len() > 0 then
			if locationTimer then
        		timer.cancel( locationTimer )
        		locationTimer = nil
        	end
        	
        	Runtime:removeEventListener( "location", locationHandler )
			passLocation()
			
		else
			Runtime:removeEventListener( "location", locationHandler )
			passLocation()
		end
		
	else
		if latitudeText:len() and longitudeText:len() > 0 then
			if locationTimer then
        		timer.cancel( locationTimer )
        		locationTimer = nil
        	end
        	
        	Runtime:removeEventListener( "location", locationHandler )
			passLocation()
			
		end
	end
	
	return true
end

locationTimer = timer.performWithDelay( 500, checkLocation, 10 )
native.setActivityIndicator( true )

        
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
        
        if( rectBg ) then
        for i = 1, #rectBg do
        	if( rectBg[i] ) then
        		display.remove( rectBg[i] )
        		rectBg[i] = nil
        	end
        end
        end
        rectBg = { }
        
        if( restaurantImg ) then
        for i = 1, #restaurantImg do
        	if( restaurantImg[i] ) then
        		display.remove( restaurantImg[i] )
        		restaurantImg[i] = nil
        	end
        end
        end
        restaurantImg = { }
        
        if( restaurantDescri ) then
        for i = 1, #restaurantDescri do
        	if( restaurantDescri[i] ) then
        		display.remove( restaurantDescri[i] )
        		restaurantDescri[i] = nil
        	end
        end
        end
        restaurantDescri = { }
        
        if( address ) then
        for i = 1, #address do
        	if( address[i] ) then
        		display.remove( address[i] )
        		address[i] = nil
        	end
        end
        end
        address = { }
        
        if( title ) then
        for i = 1, #title do
        	if( title[i] ) then
        		display.remove( title[i] )
        		title[i] = nil
        	end
        end
        end
        title = {}
        
        display.remove( backBtn )
        backBtn = nil
        
        display.remove( heading )
        heading = nil
        
        display.remove( restaurantListScrollView )
        restaurantListScrollView = nil
        
        display.remove( restaurantListGroup )
        restaurantListGroup = nil
        
        if locationTimer then
        	timer.cancel( locationTimer )
        	locationTimer = nil
        end
        
        restaurantList = { }
                
        
        
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
