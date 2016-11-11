local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


local imageDirectory = "images/SignUp/"

local title, verificationCodeBg, verificationCodeTf, verificationCodeBtn, param, heading, emailTfValue, pswdTfValue
local textFieldWidth = _W/32
local textFieldHeight = _H/64
local verificationRequest1,verificationRequest2,verificationRequest3, signInRequest


local function storeData(name,data)
	local saveData = data
	local path = system.pathForFile( name, system.DocumentsDirectory )
	local file = io.open( path, "w" )
	file:write( saveData )
	io.close( file )
	file = nil
end

local function onDoNothing( event )
	return true
end


local function deviceIdNetworkListener( event )
	native.setActivityIndicator( false )
    if _Tutorial == "0" then
		composer.gotoScene("welcomeTutorialScreen")
	else
		composer.gotoScene("welcomeScreen")
	end
	
end

local function registerDeviceFunc( event )


	local deviceID = system.getInfo( "deviceID" )
    local platformName
        		
    if system.getInfo( "platformName" ) == "Android" then
        platformName = 2
    elseif system.getInfo( "platformName" ) == "iPhone OS" then
        platformName = 1
    else
        platformName = 1
    end
		if(RegistrationId == "") then
			RegistrationId = "testingRegistrationId"
		else
	
		end					
							
		local headers = {}
			
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		
		local body = "user_id=".._UserID.."&device_id="..deviceID.."&notif_id="..RegistrationId.."&type="..platformName.."&action=login"
			
		local params = {}
		params.headers = headers
		params.body = body
		params.timeout = 180
			
		local url = _WebLink.."reg-device.php?"
			
		deviceRequest = network.request( url, "POST", deviceIdNetworkListener, params )
		native.setActivityIndicator( true )


	
	return true
end


local function handleOk( event )
	verificationCodeTf.text = ""
	registerDeviceFunc()

	return true
end

local function handleOk2( event )
	verificationCodeTf.text = ""

	return true
end

local function handleOk3( event )
	-- Access Google over SSL:
	
	local headers = {}
	
	headers["Content-Type"] = "application/x-www-form-urlencoded"
	headers["Accept-Language"] = "en-US"
	
	local body
	
	if _UserID == nil then
		body = "ws=1&user_id="..param.userIdForVerification.."&send_email=1"
	else
		body = "ws=1&user_id=".._UserID.."&send_email=1"
	end
	
	local params = {}
	params.headers = headers
	params.body = body
	
	local url = _WebLink.."account-verify.php?"
	
	verificationRequest1 = network.request( url, "POST", verificationListNetworkListener2, params )
	
	return true
end

local function handleOk4( event )
	verificationFunc()
	
	return true
end

local function handleOk5( event )
	storeData( "UserName", emailTfValue )
	storeData( "Password", pswdTfValue )
	storeData( "Varified", "0" )
	
	verificationFunc()
	
	return true
end

local function onVerificationCodeEdit( event )
	if ( event.phase == "began" ) then
	
    elseif ( event.phase == "ended" ) then
        
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then
	
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

function verificationListNetworkListener2( event )

	if ( event.isError ) then
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
        
        local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
    else
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
        local verificationList2 = json.decode(event.response)
		
		if( verificationList2 == 0 ) then
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( verificationList2 == 1 ) then
        	local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( verificationList == 2 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("User1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )

        elseif( verificationList == 3 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )

        elseif( verificationList == 4 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Email8Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk3 )
        	
        elseif event.response == "OK" then
        
        end
		
    end
    return true
end

local function verificationListNetworkListener( event )

	if ( event.isError ) then
        
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
    else
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
        local verificationList = json.decode(event.response)
		
		if( verificationList == 0 ) then
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( verificationList == 1 ) then
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( verificationList == 2 ) then
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( verificationList == 3 ) then
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("User1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )

        elseif( verificationList == 4 ) then
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("User4Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk )
        	
        elseif( verificationList == 5 ) then
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("5Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk2 )
        	
        elseif( verificationList == 6 ) then
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("4Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( verificationList == 7 ) then
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        else
        	if verificationList.user_id ~= nil then
        		_UserID = verificationList.user_id
        		storeData( "UserID", verificationList.user_id )
        	end
        	if verificationList.flag == "OK" then
        		_Varified = "1"
	        	storeData( "Varified", "1" )
	        end
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("Account4Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk )
        	
        end

        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
        
    end
    return true
end

local function signInListNetworkListener( event )

	if ( event.isError ) then
        
        networkReqCount1 = networkReqCount1 + 1
        
    	native.setActivityIndicator( false )
		
		if( networkReqCount1 > 3 ) then
		
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		else
			
			local url = _WebLink.."login.php?ws=1&email="..emailTfValue.."&password="..pswdTfValue
			local url2 = url:gsub(" ", "%%20")
			signInRequest = network.request( url2, "GET", signInListNetworkListener )
			native.setActivityIndicator( true )
			
		end
    else
        
        
        local signInList = json.decode(event.response)
        
        if( signInList == 0 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk4 )
        	
        elseif( signInList == 1 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk4 )
        
        elseif( signInList == 2 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk4 )
        	
        elseif( signInList == 3 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk4 )
		
        elseif( signInList == 4 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk4 )
        	
        elseif( signInList == 5 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk4 )
        	
        elseif( signInList == 6 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk4 )
        	
        elseif( signInList == 7 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Account2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk5 )
        	
        elseif( signInList == 8 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("Account3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk4 )
        	
        else
        	storeData( "UserID", signInList.id )
        	storeData( "UserName", emailTfValue )
			storeData( "Password", pswdTfValue )
			storeData( "Varified", signInList.verif_account )
			storeData( "F_Name", signInList.first_name )
			storeData( "L_Name", signInList.last_name )
			storeData( "Allergies", signInList.allergies )
			
			if(signInList.card_number == nil or signInList.card_number == "" or signInList.card_number == " ") then
				
			else
				storeData( "S_CardNo", signInList.card_number )
				storeData( "S_CVVNo", signInList.cvv_number )
				storeData( "S_ExpiryMonth", signInList.expiry_date_month )
				storeData( "S_ExpiryYear", signInList.expiry_date_year )
				_StripeCardNo = signInList.card_number
				_StripeCVVNo = signInList.cvv_number
				_StripeExpMont = signInList.expiry_date_month
				_StripeExpYear = signInList.expiry_date_year
				_StripePin = signInList.pin_number
			end
			
			_UserName = emailTfValue
			_fName = signInList.first_name
			_lName = signInList.last_name
			_Password = pswdTfValue
			_UserID = signInList.id
			_Varified = signInList.verif_account
			_Alleregy = signInList.allergies
			
			registerDeviceFunc()
        	
        end
      	
        
    end
	return true
end

local function handleButtonEvent( event )
	if event.phase == "ended" then
		
		if event.target.id == "verify" then
			-- Access Google over SSL:
			
			local headers = {}
			
			headers["Content-Type"] = "application/x-www-form-urlencoded"
			headers["Accept-Language"] = "en-US"
			
			local verificationCodeTfValue = verificationCodeTf.text:gsub( "&", "%%26" )
			
			local body
			
			if _UserID == nil then
				body = "ws=1&user_id="..param.userIdForVerification.."&verif_code="..verificationCodeTfValue
			else
				body = "ws=1&user_id=".._UserID.."&verif_code="..verificationCodeTfValue
			end
			
			local params = {}
			params.headers = headers
			params.body = body
			
			local url = _WebLink.."account-verify.php?"
			
			verificationRequest2 = network.request( url, "POST", verificationListNetworkListener, params )
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
        background:addEventListener( "tap", handleBackgroundEvent )
        background:addEventListener( "touch", handleBackgroundEventTouch )
        sceneGroup:insert( background )
        
        local header = display.newImageRect( imageDirectory.."f_Header.png", _W, _H/13.61 )
        header.x = _W/2
        header.y = _H/27
        sceneGroup:insert( header )
        
        heading = display.newText( GBCLanguageCabinet.getText("VerificationLabel",_LanguageKey), header.x, header.y, _FontArr[6], _H/30 )
        heading:setFillColor( 1 )
        sceneGroup:insert( heading )
        
        
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
    param = event.params

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
        
        heading.text = GBCLanguageCabinet.getText("VerificationLabel",_LanguageKey)
        
        function verificationFunc( )
			
			title = display.newText( GBCLanguageCabinet.getText("VerificationStrLabel",_LanguageKey), _W/2, _H/26 + _H/26 + _H/27.42, _FontArr[6], _H/40 )
			title:setFillColor( 83/255, 80/255, 79/255 )
			sceneGroup:insert( title )
			
			verificationCodeBg = display.newImageRect( imageDirectory.."f_TextField.png", _W/1.08, _H/13.33 )
			verificationCodeBg.x = title.x
			verificationCodeBg.y = title.y + title.height + _H/19.2
			sceneGroup:insert( verificationCodeBg )
			
			verificationCodeTf = native.newTextField( verificationCodeBg.x, verificationCodeBg.y, verificationCodeBg.width - textFieldWidth, verificationCodeBg.height - textFieldHeight )
			verificationCodeTf.hasBackground = false
			verificationCodeTf.placeholder = GBCLanguageCabinet.getText("VerificationCodeLabel",_LanguageKey)
			verificationCodeTf.inputType = "number"
			verificationCodeTf:addEventListener( "userInput", onVerificationCodeEdit )
			verificationCodeTf.font = native.newFont( _FontArr[10], _H/28 )
			sceneGroup:insert( verificationCodeTf )
			
			verificationCodeBtn = widget.newButton
			{
				width = _W/1.08,
				height = _H/16.27,
				defaultFile = imageDirectory.."f_Submit_Btn.png",
				overFile = imageDirectory.."f_Submit_Btn.png",
				label = GBCLanguageCabinet.getText("verifyAccountLabel",_LanguageKey), 
				labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
				labelYOffset = _H/275,
				fontSize = _H/30,
				font = _FontArr[6],
				id = "verify",
				onEvent = handleButtonEvent
			}
			verificationCodeBtn.x = _W/2
			verificationCodeBtn.y = verificationCodeBg.y + verificationCodeBg.height/2 + verificationCodeBtn.height/2 + _H/19.2
			sceneGroup:insert( verificationCodeBtn )
			
			if composer.getSceneName( "previous" ) ~= "signUp" then
				-- Access Google over SSL:
				
				local headers = {}
				
				headers["Content-Type"] = "application/x-www-form-urlencoded"
				headers["Accept-Language"] = "en-US"
				
				local body
				
				if _UserID == nil then
					body = "ws=1&user_id="..param.userIdForVerification.."&send_email=1"
				else
					body = "ws=1&user_id=".._UserID.."&send_email=1"
				end
				local params = {}
				params.headers = headers
				params.body = body
				
				local url = _WebLink.."account-verify.php?"
				
				verificationRequest3 = network.request( url, "POST", verificationListNetworkListener2, params )
				
			else
				
			end
			
		end
        
        if param.userIdForVerification and param.pswdForVerification then
        	
        	emailTfValue = (param.userIdForVerification):gsub( "&", "%%26" )
			pswdTfValue = (param.pswdForVerification):gsub( "&", "%%26" )
			
			local url = _WebLink.."login.php?ws=1&email="..emailTfValue.."&password="..pswdTfValue
			local url2 = url:gsub(" ", "%%20")
			signInRequest = network.request( url2, "GET", signInListNetworkListener )
			native.setActivityIndicator( true )
			
        else
        	verificationFunc()
        	
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
        
        
        display.remove( title )
        title = nil
        
        display.remove( verificationCodeBtn )
        verificationCodeBtn = nil
        
        display.remove( verificationCodeBg )
        verificationCodeBg = nil
        
        display.remove( verificationCodeTf )
        verificationCodeTf = nil       
        
        
        
        
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
        if(verificationRequest1) then
        	network.cancel( verificationRequest1 )
        	verificationRequest1 = nil
        end
        
        if(verificationRequest2) then
        	network.cancel( verificationRequest2 )
        	verificationRequest2 = nil
        end
        
        if(verificationRequest3) then
        	network.cancel( verificationRequest3 )
        	verificationRequest3 = nil
        end
        
        if(signInRequest) then
        	network.cancel( signInRequest )
        	signInRequest = nil
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