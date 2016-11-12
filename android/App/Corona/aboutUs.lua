local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


local imageDirectory = "images/SignUp/"

local title, aboutUsScrollView,heading
local aboutUsGroup,aboutUSRequest
local networkReqCount = 0

local function onDoNothing( event )
	return true
end

local function handleBackButtonEvent( event )
	composer.gotoScene( "Setting" )
	return true
end

local function handleBackButtonEventtouch( event )
	if event.phase == "ended" then
		composer.gotoScene( "Setting" )
	end

	return true
end

local function aboutUsListNetworkListener( event )
	
	if ( event.isError ) then
        networkReqCount = networkReqCount + 1
        
    	native.setActivityIndicator( false )
		
		if( networkReqCount > 3 ) then
		
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		else
			local url = _WebLink.."site-about-us.php"
			local url2 = url:gsub(" ", "%%20")
		
			aboutUSRequest = network.request( url2, "GET", aboutUsListNetworkListener )
        	native.setActivityIndicator( true )
		
		end
    else
        
        local aboutUsList = json.decode(event.response)
        
        if aboutUsList == 0 then
        	noData = display.newText( GBCLanguageCabinet.getText("noInfoLabel",_LanguageKey) , _W/2,_H/2,_FontArr[6], _H/40)
        	noData:setFillColor( 83/255, 80/255, 79/255 )
        	aboutUsGroup:insert(noData)
        	
        else
        	title = display.newText( "", _W/32, _H/48, _W - _W/16, 0, _FontArr[6], _H/30 )
    		title.anchorX = 0
   			title.anchorY = 0
   			title.text = aboutUsList.value
    		title:setFillColor( 83/255, 80/255, 79/255 )
    		aboutUsScrollView:insert( title )
    		
    		aboutUsScrollView:setScrollHeight( title.height + _H/4 )
    		
        end
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
        
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
        
        local header = display.newImageRect( imageDirectory.."f_Header.png", _W, _H/13.61 )
        header.x = _W/2
        header.y = _H/27
        sceneGroup:insert( header )
        
        heading = display.newText( GBCLanguageCabinet.getText("AboutUsLabel",_LanguageKey), header.x, header.y, _FontArr[6], _H/30 )
        heading:setFillColor( 1 )
        sceneGroup:insert( heading )
        
	local backBtn = widget.newButton
	{
    	width = _W/9,
    	height = _H/14.76,
    	defaultFile = imageDirectory.."Back_Btn2.png",
   		overFile = imageDirectory.."Back_Btn2.png",
    	id = "back",
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
        
        
        heading.text = GBCLanguageCabinet.getText("AboutUsLabel",_LanguageKey)
        
        aboutUsGroup = display.newGroup()
        sceneGroup:insert(aboutUsGroup)
        networkReqCount = 0
        
        aboutUsScrollView = widget.newScrollView
		{
    		top = _H/12,
    		left = 0,
    		width = _W,
    		height = _H,
    		scrollWidth = _W,
    		scrollHeight = _H * 2,
    		hideBackground = true,
    		horizontalScrollDisabled = true,
    		bottomPadding = _H/8
    	}
		aboutUsGroup:insert( aboutUsScrollView )
        
        
        -- Access Google over SSL:
		
		if( _LanguageKey == "en" ) then
		
			local url = _WebLink.."site-about-us.php"
			local url2 = url:gsub(" ", "%%20")
		
			aboutUSRequest = network.request( url2, "GET", aboutUsListNetworkListener )
		else
			local url = _WebLink.."site-about-us.php?lang=".._LanguageKey
			local url2 = url:gsub(" ", "%%20")
		
			aboutUSRequest = network.request( url2, "GET", aboutUsListNetworkListener )
		
		end
		
		
        native.setActivityIndicator( true )

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
        
        
        display.remove( title )
        title = nil
        
        display.remove( aboutUsScrollView )
        aboutUsScrollView = nil
        
        if(noData) then
        	display.remove(noData)
        	noData = nil
        end
        
        display.remove(aboutUsGroup)
        aboutUsGroup = nil
        
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
        if(aboutUSRequest) then
        	network.cancel( aboutUSRequest )
        	aboutUSRequest = nil
        end
        
        
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