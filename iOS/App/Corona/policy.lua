local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

local imageDirectory = "images/SignUp/"

local title, policyScrollView,heading
local policyGroup,policyRequest

local function onDoNothing( event )

	return true
end

local function handleBackButtonEvent( event )
	if( composer.getSceneName( "previous" ) == "login" ) then
		composer.gotoScene( "login" )
	elseif( composer.getSceneName( "previous" ) == "signUp" ) then
		composer.gotoScene( "signUp" )
	else
		composer.gotoScene( "login" )
	end
	return true
end

local function handleBackButtonEventTouch( event )
	if event.phase == "ended" then
		if( composer.getSceneName( "previous" ) == "login" ) then
			composer.gotoScene( "login" )
		elseif( composer.getSceneName( "previous" ) == "signUp" ) then
			composer.gotoScene( "signUp" )
		else
			composer.gotoScene( "login" )
		end
	end

	return true
end


local function policyDataNetworkListener( event )
	
	if ( event.isError ) then
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
    else
        
        local policyData = json.decode(event.response)
        
        if termsList == 0 then
        	noData = display.newText( GBCLanguageCabinet.getText("noTermsLabel",_LanguageKey) , _W/2,_H/2,_FontArr[6], _H/40)
        	noData:setFillColor( 83/255, 80/255, 79/255 )
        	policyGroup:insert(noData)
        else
        	title = display.newText( "", _W/32, _H/48, _W - _W/16, 0, _FontArr[6], _H/30 )
    		title.anchorX = 0
   			title.anchorY = 0
   			title.text = policyData.value
    		title:setFillColor( 83/255, 80/255, 79/255 )
    		policyScrollView:insert( title )
    		
    		policyScrollView:setScrollHeight( title.height + _H/4 )
    		
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
        
        heading = display.newText( GBCLanguageCabinet.getText("PrivacyPolicyLabel",_LanguageKey), header.x, header.y, _FontArr[6], _H/30 )
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
        
        
        heading.text = GBCLanguageCabinet.getText("PrivacyPolicyLabel",_LanguageKey)
        
        if( _LanguageKey == "ru" ) then
        	heading.size = _H/50
        else
        
        end
        
        policyGroup = display.newGroup()
        sceneGroup:insert(policyGroup)
        
        policyScrollView = widget.newScrollView
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
		policyGroup:insert( policyScrollView )
        
        
        -- Access Google over SSL:
		
		local headers = {}
		
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		local body
		if( _LanguageKey == "en" ) then
			body = ""
		else
			body = "lang=".._LanguageKey
		end
		local params = {}
		params.headers = headers
		params.body = body
				
		local url = _WebLink.."site-policy.php?"
		policyRequest = network.request( url, "POST", policyDataNetworkListener, params )
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
        if(title) then
        	display.remove( title )
        	title = nil
        end
        
        display.remove( policyScrollView )
        policyScrollView = nil
        
        if(noData) then
        	display.remove(noData)
        	noData = nil
        end
        
        display.remove(policyGroup)
        policyGroup = nil
        
        
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
        if(policyRequest) then
        	network.cancel( policyRequest )
        	policyRequest = nil
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