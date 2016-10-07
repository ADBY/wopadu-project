local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


local imageDirectory = "images/SignUp/"

local title, forgotPswdBtn, emailBg, emailTf, emailTfValue, heading
local forgotPassRequest
local textFieldWidth = _W/32
local textFieldHeight = _H/64

local function onDoNothing( event )

	return true
end

local function handleOk2( event )
	emailTf.text = ""

	return true
end

local function handleOk( event )
	

	return true
end

local function onEmailEdit( event )
	if ( event.phase == "began" ) then
	
    elseif ( event.phase == "ended" ) then
        print( event.target.text )
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then
	
    end

	return true
end

local function handleBackButtonEvent( event )
	local previous = composer.getSceneName( "previous" )
	if(_passwordPreviousScene) then
		composer.gotoScene( _passwordPreviousScene )
	else
		composer.gotoScene( previous )
	end
	
	return true
end

local function handleBackButtonEventTouch( event )
	if event.phase == "ended" then
		local previous = composer.getSceneName( "previous" )
		if(_passwordPreviousScene) then
			composer.gotoScene( _passwordPreviousScene )
		else
			composer.gotoScene( previous )
		end
	end
	return true
end

local function handleBackgroundEvent( event )
	native.setKeyboardFocus( nil )
	
	return true
end

local function handleBackgroundEventTouch( event )
	if event.phase == "ended" then
		native.setKeyboardFocus( nil )
	end
	
	return true
end

local function forgotPswdListNetworkListener( event )

	if ( event.isError ) then
        print( "Network error!" )
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
    else
        print ( "RESPONSE:" .. event.response )
        
        local forgotPswdList = json.decode(event.response)
		
		if( forgotPswdList == 0 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( forgotPswdList == 1 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Email1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk2 )
        
        elseif( forgotPswdList == 2 ) then
        	local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("Email3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk2 )
        	
        elseif( forgotPswdList == 3 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )

        elseif( forgotPswdList == 4 ) then
        	local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("Email4Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk2 )
        	
        elseif event.response == "OK" then
        	print( "mail sent successfully" )
        	local options = {
        		params = { emailForChangePswd = emailTfValue }
        	}
        	composer.gotoScene( "changePassword2", options )
        
        end
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
        
    end
	return true
end

local function handleButtonEvent( event )
	if event.phase == "ended" then
		
		if event.target.id == "forgot" then
			print( "forgot password" )
			if emailTf.text == "" then
				local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("Email1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk2 )
			
			else
				-- Access Google over SSL:
				
				local headers = {}
			
				headers["Content-Type"] = "application/x-www-form-urlencoded"
				headers["Accept-Language"] = "en-US"
			
				emailTfValue = emailTf.text:gsub( "&", "%%26" )
							
				local body = "ws=1&step=1&email="..emailTfValue
				local params = {}
				params.headers = headers
				params.body = body
				
				local url = _WebLink.."password-forgot.php?"
				print( url..body )
				forgotPassRequest = network.request( url, "POST", forgotPswdListNetworkListener, params )
				native.setActivityIndicator( true )
			
			end
			
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
        background:addEventListener( "tap", handleBackgroundEvent )
        background:addEventListener( "touch", handleBackgroundEventTouch )
        sceneGroup:insert( background )
        
        local header = display.newImageRect( imageDirectory.."f_Header.png", _W, _H/13.61 )
        header.x = _W/2
        header.y = _H/27
        sceneGroup:insert( header )
        
        heading = display.newText( GBCLanguageCabinet.getText("ForgotPasswordLabel",_LanguageKey), header.x, header.y, _FontArr[6], _H/30 )
        heading:setFillColor( 1 )
        sceneGroup:insert( heading )
        --[[
        local backBtn = display.newImageRect( imageDirectory.."Back_Btn.png", _W/15.42, _H/33.10 )
        backBtn.x = _W/13.5
        backBtn.y = header.y
        sceneGroup:insert( backBtn )
       			
		local backBg = display.newRect( backBtn.x, backBtn.y, backBtn.width + _W/21.6, backBtn.height + 38.4 )
		backBg:setFillColor( 83/255, 20/255, 111/255 )
		backBg:addEventListener( "tap", handleBackButtonEvent )
		backBg:addEventListener( "tap", handleBackButtonEventTouch )
		sceneGroup:insert( backBg )
		backBtn:toFront()
    	]]--
    	
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
        
        
        print( "In forgot Password screen....." )
        
        heading.text = GBCLanguageCabinet.getText("ForgotPasswordLabel",_LanguageKey)
        
        local option = {
         	text = GBCLanguageCabinet.getText("forgotPassStrLabel",_LanguageKey),
         	x = _W/2,
         	y = _H/19.2 + _H/27.42,
         	width =  _W - _W/27 ,
         	height = 0,
         	font = _FontArr[6],
         	fontSize = titleFontSize,
         	align  = "center"
         
        }
        title = display.newText(option)
        title.anchorY = 0
        title:setFillColor( 83/255, 80/255, 79/255 )
        sceneGroup:insert( title )
        
        emailBg = display.newImageRect( imageDirectory.."f_TextField.png", _W/1.08, _H/13.33 )
        emailBg.x = title.x
        emailBg.y = title.y + title.height + _H/19.2
        sceneGroup:insert( emailBg )
        
        emailTf = native.newTextField( emailBg.x, emailBg.y, emailBg.width - textFieldWidth, emailBg.height - textFieldHeight )
		emailTf.hasBackground = false
		emailTf.inputType = "email"
		emailTf.placeholder = GBCLanguageCabinet.getText("EmailLabel",_LanguageKey)
		emailTf:addEventListener( "userInput", onEmailEdit )
		emailTf.font = native.newFont( _FontArr[10], _H/28 )
		sceneGroup:insert( emailTf )
        
        forgotPswdBtn = widget.newButton
		{
    		width = _W/1.08,
    		height = _H/16.27,
    		defaultFile = imageDirectory.."f_Submit_Btn.png",
   			overFile = imageDirectory.."f_Submit_Btn.png",
    		label = GBCLanguageCabinet.getText("ForgotPasswordLabel",_LanguageKey),
    		labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
    		labelYOffset = _H/275,
    		fontSize = _H/30,
    		font = _FontArr[6],
    		id = "forgot",
    		onEvent = handleButtonEvent
		}
		forgotPswdBtn.x = _W/2
		forgotPswdBtn.y = emailBg.y + emailBg.height/2 + forgotPswdBtn.height/2 + _H/19.2
		sceneGroup:insert( forgotPswdBtn )
		
        
        
        
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
        
        display.remove( forgotPswdBtn )
        forgotPswdBtn = nil
        
        display.remove( emailBg )
        emailBg = nil
        
        display.remove( emailTf )
        emailTf = nil
        
        
        
        
        
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
        if(forgotPassRequest) then
        	network.cancel( forgotPassRequest )
        	forgotPassRequest = nil
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