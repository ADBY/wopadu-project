local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


local imageDirectory = "images/SignUp/"
local imageDirectory3 = "images/RateWopado/"

local title, title2, suportScrollView, reviewBg, reviewTf, submitBtn, header, heading, backBtn, bgRect
local feedbackRequest, networkReqCount2, posY



local function onDoNothing( event )
	return true
end

local function onBgTap( event )
	native.setKeyboardFocus( nil )
	suportScrollView.y = posY
	
	return true
end

local function onBgTouch( event )
	if event.phase == "ended" then
		native.setKeyboardFocus( nil )
		suportScrollView.y = posY
	end
	
	return true
end

local function handleBackButtonEvent( event )
	local previous = composer.getSceneName( "previous" )
	composer.gotoScene( previous )

	return true
end

local function handleBackButtonEventTouch( event )
	if event.phase == "ended" then
		local previous = composer.getSceneName( "previous" )
		composer.gotoScene( previous )
	end

	return true
end

local function onReviewEdit( event )
	if event.phase == "began" then
    	suportScrollView.y = _H/4
    	
    elseif event.phase == "ended" or event.phase == "submitted" then
        suportScrollView.y = posY
        
    elseif event.phase == "editing" then
        
    end
	
	return true
end

local function supportListNetworkListener( event )
	
	if ( event.isError ) then
        print( "Network error!" )
        networkReqCount2 = networkReqCount2 + 1
    	native.setActivityIndicator( false )
    	if( networkReqCount2 > 3 ) then
	        local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
	    
	    else
	    	-- Access Google over SSL:
		
		local headers = {}
		
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		
		local body
		if( _LanguageKey == "en" ) then
			body = "lang=".._LanguageKey
		else
			body = ""
		end
		local params = {}
		params.headers = headers
		params.body = body
		
		local url = _WebLink.."site-faq.php?"
		network.request( url, "POST", supportListNetworkListener, params )
		native.setActivityIndicator( true )
	    	
	    end
    else
        print ( "RESPONSE:" .. event.response )
        
        local supportList = json.decode(event.response)
        
        print( supportList.value )
        
        if supportList == 0 then
        	print( "No data is available." )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("13Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        	timer.performWithDelay( 200, function() 
    			native.setActivityIndicator( false )
			end )
        else
        	title = display.newText( "", _W/32, _H/48, _W - _W/16, 0, _FontArr[6], _H/40 )
    		title.anchorX = 0
   			title.anchorY = 0
   			title.text = supportList.value
    		title:setFillColor( 83/255, 80/255, 79/255 )
    		suportScrollView:insert( title )
    		
    		--suportScrollView:setScrollHeight( title.height + _H/4 )
    		
    		timer.performWithDelay( 200, function() 
    			native.setActivityIndicator( false )
			end )
    		
    		feedbackFunction()
    		
        end
        
    end
	return true
end

local function feedbackNetworkListener( event )
	if ( event.isError ) then
        print( "Network error!" )
        local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
    else
        print ( "RESPONSE:" .. event.response )
        
		if( event.response == "0" or event.response == 0 ) then
			local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
		elseif( event.response == "1" or event.response == 1 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
		elseif( event.response == "2" or event.response == 2 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
		elseif( event.response == "3" or event.response == 3 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
		elseif( event.response == "OK" ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("14Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleBackButtonEvent )
			timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
		end
	end
	return true
end

local function handleSubmitButtonEvent( event )
	if( event.phase == "ended" ) then
	
		if(reviewTf.text == "" or reviewTf.text == nil or reviewTf.text == " ") then
			
			local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		else
		
		local headers = {}
		
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		
		local body = "ws=1&user_id=".._UserID.."&content="..reviewTf.text
		local params = {}
		params.headers = headers
		params.body = body
		
		local url = _WebLink.."feedback-email.php?"
		print( url..body )
		feedbackRequest = network.request( url, "POST", feedbackNetworkListener, params )
		native.setActivityIndicator( true )
		end
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
        
        
        --[[
        local backBtn = display.newImageRect( imageDirectory.."Back_Btn.png", _W/15.42, _H/33.10 )
        backBtn.x = _W/13.5
        backBtn.y = header.y
        sceneGroup:insert( backBtn )
       			
		local backBg = display.newRect( backBtn.x, backBtn.y, backBtn.width + _W/21.6, backBtn.height + 38.4 )
		backBg:setFillColor( 83/255, 20/255, 111/255 )
		backBg:addEventListener( "tap", handleBackButtonEvent )
		backBg:addEventListener( "touch", handleBackButtonEventTouch )
		sceneGroup:insert( backBg )
		backBtn:toFront()
    	]]--
    	
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
        print( "In support screen......" )
        
        networkReqCount2 = 0
        
        local textHeightGap = _H/96
		local textFieldWidth = _W/32
		local textFieldHeight = _H/4
		
    	header = display.newImageRect( imageDirectory.."f_Header.png", _W, _H/13.61 )
        header.x = _W/2
        header.y = _H/27
        sceneGroup:insert( header )
        
        heading = display.newText(  GBCLanguageCabinet.getText("faqLabel",_LanguageKey), header.x, header.y, _FontArr[6], _H/30 )
        heading:setFillColor( 1 )
        sceneGroup:insert( heading )
        
        bgRect = display.newRect( _W/2, _H/2, _W, _H )
        bgRect:setFillColor( 1, 1, 1, 0.01 )
        bgRect:addEventListener( "tap", onBgTap )
        bgRect:addEventListener( "touch", onBgTouch )
        sceneGroup:insert( bgRect )
        
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
	backBtn.y = header.y
	backBtn:addEventListener("tap",handleBackButtonEvent)
	sceneGroup:insert( backBtn )
        
      	suportScrollView = widget.newScrollView
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
		sceneGroup:insert( suportScrollView )
       	
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
		
		local url = _WebLink.."site-faq.php?"
		print( url..body )
		network.request( url, "POST", supportListNetworkListener, params )
		native.setActivityIndicator( true )
        
		
	function feedbackFunction()
		
		title2 = display.newText( "", _W/32, title.y + title.height + _H/38.4, _W - _W/16, 0, _FontArr[6], _H/27.42 )
		title2.anchorX = 0
		title2.anchorY = 0
		title2.text = GBCLanguageCabinet.getText("FaqStrLabel",_LanguageKey)
		title2:setFillColor( 206/255, 23/255, 100/255 )
		suportScrollView:insert( title2 )
		
		reviewBg = display.newImageRect( imageDirectory3.."TextBox Bg.png", _W, textFieldHeight )
        reviewBg.x = _W/2
        reviewBg.anchorY = 0
        reviewBg.y = title2.y + title2.height + _H/38.4
        suportScrollView:insert( reviewBg )
        
        reviewTf = native.newTextBox( reviewBg.x, reviewBg.y, reviewBg.width - textFieldWidth, reviewBg.height - textHeightGap )
		reviewTf.hasBackground = false
		reviewTf.isEditable = true
		reviewTf.anchorY = 0
		--reviewTf.placeholder = "Add Feedback here..."
		reviewTf:addEventListener( "userInput", onReviewEdit )
		reviewTf.font = native.newFont( _Font2, _H/38.4 )
		suportScrollView:insert( reviewTf )
		
		submitBtn = widget.newButton
		{
    		width = _W/1.08,
    		height = _H/16.27,
    		defaultFile = imageDirectory.."SinUp_Btn.png",
   			overFile = imageDirectory.."SinUp_Btn.png",
    		label = tostring(GBCLanguageCabinet.getText("SubmitLabel",_LanguageKey)),
    		labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
    		fontSize = _H/32,
    		font = _FontArr[10],
    		labelYOffset = _H/275,
    		id = "submit",
    		onEvent = handleSubmitButtonEvent
		}
		submitBtn.x = _W/2
		submitBtn.y = reviewBg.y + reviewBg.height + submitBtn.height/2 + _H/38.4 
		suportScrollView:insert( submitBtn )
		
		posY = suportScrollView.y
		
		suportScrollView:setScrollHeight( title.height + title2.height + reviewBg.height + reviewTf.height + submitBtn.height + _H/19.2 )
		
	end
		
		header:toFront()
    	heading:toFront()
    	backBtn:toFront()
		
        -- http://bridgetechnocrats.in/wopado/ws/feedback-email.php?ws=1&user_id=1&content=this-is-the-message
        
                
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
        
        display.remove( title2 )
        title2 = nil
        
        display.remove( suportScrollView )
        suportScrollView = nil
        
        display.remove( reviewBg )
        reviewBg = nil
        
        display.remove( reviewTf )
        reviewTf = nil
        
        display.remove( submitBtn )
        submitBtn = nil
        
        display.remove( header )
        header = nil
        
        display.remove( heading )
        heading = nil
        
        display.remove( backBtn )
        backBtn = nil
        
        display.remove( bgRect )
        bgRect = nil
        
        
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
        if(feedbackRequest) then
        	network.cancel( feedbackRequest )
        	feedbackRequest = nil
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