local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local forward references should go here

-- -------------------------------------------------------------------------------

local imageDirectory = "images/SignUp/"
local orderDetailsImageDirectory = "images/OrderDetails/"

local name, restaurantDetailsGroup, backBtn, description, scrollView, heading



local function handleBackButtonEvent( event )
	composer.gotoScene( "RestaurantsList" )
	
	return true
end

local function handleLocationButtonEvent( event )
	composer.gotoScene( "ViewMap" )
	
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
        
        restaurantDetailsGroup = display.newGroup()
        sceneGroup:insert( restaurantDetailsGroup )
        
        scrollView = widget.newScrollView
		{
    		width = _W,
    		height = _H - _H/13.61 - _H/38.4,
    		top = _H/13.61 + _H/38.4,
	   		bottomPadding = _H/9.6,
    		horizontalScrollDisabled = true
		}
		restaurantDetailsGroup:insert( scrollView )
        
        name = display.newText( _RestaurantData.store_name, _W/21.6, _H/96, _FontArr[30], _H/36.76 )
        name.anchorX = 0
        name.anchorY = 0
        name:setFillColor( 205/255, 34/255, 100/255 )
        scrollView:insert( name )
        
        local imagePath = system.pathForFile( "Restaurant".._RestaurantData.id..".png",system.TemporaryDirectory )
    	local imageFile = io.open( imagePath, "r" )
    
    	if(imageFile == nil) then
        
        	restaurantImg = display.newImage("images/defaultImage.png")
			restaurantImg.height = _W/1.08/(restaurantImg.width/restaurantImg.height)
			restaurantImg.width = _W/1.08
	
			if(restaurantImg.height > _H/3) then
				restaurantImg.height = _H/3
			else	
				
			end
			
			restaurantImg.x = _W/108 + restaurantImg.width/2
			restaurantImg.y =  name.y + name.height + restaurantImg.height/2 + _H/96
			scrollView:insert(restaurantImg)
			
		else
		
			restaurantImg = display.newImage("Restaurant".._RestaurantData.id..".png",system.TemporaryDirectory)
			restaurantImg.height = _W/1.08/(restaurantImg.width/restaurantImg.height)
			restaurantImg.width = _W/1.08
	
			if(restaurantImg.height > _H/3) then
				restaurantImg.height = _H/3
			else	
				
			end
			restaurantImg.x = _W/108 + restaurantImg.width/2
			restaurantImg.y =  name.y + name.height + restaurantImg.height/2 + _H/96
			scrollView:insert(restaurantImg)
		
		
		end	
        
        description = display.newText( "", _W/21.6, restaurantImg.y + restaurantImg.height/2 + _H/38.4, _W - _W/13.5, 0, _FontArr[30], _H/38.4 )
        description.anchorX = 0
        description.anchorY = 0
        description:setFillColor( 83/255, 20/255, 111/255 )
        scrollView:insert( description )
        
        if _RestaurantData.description == "" or _RestaurantData.description == " " or _RestaurantData.description == nil then
        	description.text = GBCLanguageCabinet.getText("13Alert", _LanguageKey)
        else 
        	description.text = _RestaurantData.description
        end
        
    	locationBtn = widget.newButton
		{
    		width = _W/2.05,
    		height = _H/16.27,
	    	defaultFile = orderDetailsImageDirectory.."RepeatOrder_Btn2.png",
   			overFile = orderDetailsImageDirectory.."RepeatOrder_Btn2.png",
    		id = "location",
    		label = GBCLanguageCabinet.getText("viewLocationLabel", _LanguageKey),
   			labelYOffset = -3,
   			labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
   			font = _FontArr[1],
   			fontSize = _H/60,
		}
		locationBtn.anchorY = 0
		locationBtn.x = _W/2
		locationBtn.y = description.y + description.height + _H/19.2
		locationBtn:addEventListener("tap",handleLocationButtonEvent)
		scrollView:insert( locationBtn )
    	
    	
    	
        
        
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
        
                
        display.remove( name )
        name = nil
        
        display.remove( backBtn )
        backBtn = nil
        
        display.remove( heading )
        heading = nil
        
        display.remove( description )
        description = nil
        
        display.remove( scrollView )
        scrollView = nil
        
        display.remove( restaurantDetailsGroup )
        restaurantDetailsGroup = nil
        
        
        
        
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