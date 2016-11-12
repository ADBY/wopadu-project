local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


local imageDirectory = "images/Login/"

local signInGroup, signInTitle, emailBg, pswdBg, emailTf, pswdTf, forgotPswdBg, forgotPswd, lineImg, signInGroupY
local signInBtn, facebookBtn, googleBtn, signUpBg, signUp, title, terms, title2, policy, termsBg, policyBg, twitterBtn
local signInRequest,signInGoogleRequest,signInFbRequest,deviceRequest, signInTwitterRequest
local textFieldWidth = _W/32
local textFieldHeight = _H/64
local fbCommand
local LOGOUT = 1
local SHOW_DIALOG = 2
local POST_MSG = 3
local POST_PHOTO = 4
local GET_USER_INFO = 5
local GET_PLATFORM_INFO = 6
local decodeResponse,response, fName, lName

local networkReqCount1,networkReqCount2,networkReqCount3,networkReqCount4



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

local function handleOk( event )
	emailTf.text = ""
	pswdTf.text = ""
	
	return true
end

local function handleOk2( event )
	emailTf.text = ""
	
	return true
end

local function handleOk3( event )
	pswdTf.text = ""
		
	return true
end

local function handleOk4( event )
	emailTf.text = ""
	pswdTf.text = ""
		
	return true
end

local function handleOk5( event )
	storeData( "UserName", emailTf.text )
	storeData( "Password", pswdTf.text )
	storeData( "Varified", "0" )
	
	local options = {
		params = { userIdForVerification = emailTf.text, pswdForVerification = pswdTf.text }
	}
	composer.gotoScene( "verifiedAcc", options )
	
	return true
end

local function onEmailEdit( event )
	if ( event.phase == "began" ) then
       signInGroup.y = -_H/2.7
       signInTitle.isVisible = false
       facebookBtn.isVisible = false
       twitterBtn.isVisible = false
       signUp.isVisible = false

    elseif ( event.phase == "ended" ) then
    	signInGroup.y = signInGroupY
        signInTitle.isVisible = true
       	facebookBtn.isVisible = true
       	twitterBtn.isVisible = true
       	signUp.isVisible = true
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( pswdTf )

    elseif ( event.phase == "editing" ) then
        
    end

	return true
end

local function onPswdEdit( event )
	if ( event.phase == "began" ) then
       signInGroup.y = -_H/2.7
       signInTitle.isVisible = false
       facebookBtn.isVisible = false
       twitterBtn.isVisible = false
       signUp.isVisible = false

    elseif ( event.phase == "ended" ) then
        signInGroup.y = signInGroupY
        signInTitle.isVisible = true
       	facebookBtn.isVisible = true
       	twitterBtn.isVisible = true
       	signUp.isVisible = true
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then
        
    end

	return true
end

local function handleForgotPasswordEvent( event )
	composer.gotoScene( "forgotPassword" )

	return true
end

local function handleSignUpEvent( event )
	composer.gotoScene( "signUp" )

	return true
end

local function handleTermsEvent( event )
	composer.gotoScene( "terms" )

	return true
end

local function handlePolicyEvent( event )
	composer.gotoScene( "policy" )

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
		
		local url = _WebLink.."reg-device.php?user_id=".._UserID.."&device_id="..deviceID.."&notif_id="..RegistrationId.."&type="..platformName.."&action=login"
		local url2 = url:gsub(" ", "%%20")
		deviceRequest = network.request( url2, "GET", deviceIdNetworkListener )
		native.setActivityIndicator( true )
	
	return true
end

local function signInListNetworkListener( event )

	if ( event.isError ) then
        networkReqCount1 = networkReqCount1 + 1
        
    	native.setActivityIndicator( false )
		
		if( networkReqCount1 > 3 ) then
		
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		else
		
			local emailTfValue = emailTf.text:gsub( "&", "%%26" )
			local pswdTfValue = pswdTf.text:gsub( "&", "%%26" )
				
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
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( signInList == 1 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( signInList == 2 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Email2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk2 )
        	
        elseif( signInList == 3 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Password4Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk3 )
		
        elseif( signInList == 4 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( signInList == 5 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("Password7Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk4 )
        	
        elseif( signInList == 6 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Password2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk3 )
        	
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
        	storeData( "UserName", emailTf.text )
			storeData( "Password", pswdTf.text )
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
			
			_UserName = emailTf.text
			_fName = signInList.first_name
			_lName = signInList.last_name
			_Password = pswdTf.text
			_UserID = signInList.id
			_Varified = signInList.verif_account
			_Alleregy = signInList.allergies
			
			
			registerDeviceFunc()
        	
        end
      	
        
    end
	return true
end

local function signInUsingFBNetworkListener( event )
	if ( event.isError ) then
        
        networkReqCount3 = networkReqCount3 + 1
        
    	native.setActivityIndicator( false )
    	
    	if( networkReqCount3 > 3 ) then
		
			local alert = native.showAlert( alertLabel, NetworkErrorMsg, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		else
			
			local url = _WebLink.."fb-g-connect.php?first_name="..response.first_name.."&last_name="..response.last_name.."&email="..response.email.."&connect=fb"
			local url2 = url:gsub(" ", "%%20")
			signInFbRequest = network.request( url2, "GET", signInUsingFBNetworkListener )
			native.setActivityIndicator( true )
			
		end
    else
        
        local fbSignInList = json.decode(event.response)
        
        if( fbSignInList == 0 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "All fields are mandatory.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( fbSignInList == 1 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "All fields are mandatory.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( fbSignInList == 2 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Invalid connection variable.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( fbSignInList == 3 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Something went wrong, Query Error.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
        elseif( fbSignInList == 4 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Something went wrong, Query Error.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        else
        	_UserID = fbSignInList.id
			storeData( "UserID", fbSignInList.id )
        	storeData( "UserName", fbSignInList.email )
			storeData( "Password", "" )
			storeData( "Varified", "1" )
			storeData( "F_Name", fbSignInList.first_name )
			storeData( "twitter", "1" )
			storeData( "L_Name", fbSignInList.last_name )
			storeData( "Allergies", fbSignInList.allergies )
			
			if(fbSignInList.card_number == nil or fbSignInList.card_number == "" or fbSignInList.card_number == " ") then
				
			else
				storeData( "S_CardNo", fbSignInList.card_number )
				storeData( "S_CVVNo", fbSignInList.cvv_number )
				storeData( "S_ExpiryMonth", fbSignInList.expiry_date_month )
				storeData( "S_ExpiryYear", fbSignInList.expiry_date_year )
				storeData( "S_Pin", fbSignInList.pin_number )
				_StripeCardNo = fbSignInList.card_number
				_StripeCVVNo = fbSignInList.cvv_number
				_StripeExpMont = fbSignInList.expiry_date_month
				_StripeExpYear = fbSignInList.expiry_date_year
				_StripePin = fbSignInList.pin_number
			end
			
			_UserName = fbSignInList.email
			_fName = fbSignInList.first_name
			_lName = fbSignInList.last_name
			_Password = ""
			_UserID = fbSignInList.id
			_Varified = "1"
			_Alleregy = fbSignInList.allergies
			
			registerDeviceFunc()
        	
        end
     
    end
	return true
	
end

local function signInUsingTwitterNetworkListener( event )
	if ( event.isError ) then
        
        networkReqCount4 = networkReqCount4 + 1
        
    	native.setActivityIndicator( false )
    	
    	if( networkReqCount4 > 3 ) then
		
			local alert = native.showAlert( alertLabel, NetworkErrorMsg, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		else
			
			local url = _WebLink.."fb-g-connect.php?first_name="..fName.."&last_name="..lName.."&email="..response.email.."&connect=t"
			local url2 = url:gsub(" ", "%%20")
			signInTwitterRequest = network.request( url2, "GET", signInUsingTwitterNetworkListener )
			native.setActivityIndicator( true )
			
		end
    else
        
        local twitterSignInList = json.decode(event.response)
        
        if( twitterSignInList == 0 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "All fields are mandatory.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( twitterSignInList == 1 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "All fields are mandatory.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( twitterSignInList == 2 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Invalid connection variable.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( twitterSignInList == 3 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Something went wrong, Query Error.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
        elseif( twitterSignInList == 4 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Something went wrong, Query Error.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        else
        	_UserID = twitterSignInList.id
			storeData( "UserID", twitterSignInList.id )
        	storeData( "UserName", twitterSignInList.email )
			storeData( "Password", "" )
			storeData( "Varified", "1" )
			storeData( "F_Name", twitterSignInList.first_name )
			storeData( "twitter", "1" )
			storeData( "L_Name", twitterSignInList.last_name )
			storeData( "Allergies", twitterSignInList.allergies )
			
			if(twitterSignInList.card_number == nil or twitterSignInList.card_number == "" or twitterSignInList.card_number == " ") then
				
			else
				storeData( "S_CardNo", twitterSignInList.card_number )
				storeData( "S_CVVNo", twitterSignInList.cvv_number )
				storeData( "S_ExpiryMonth", twitterSignInList.expiry_date_month )
				storeData( "S_ExpiryYear", twitterSignInList.expiry_date_year )
				storeData( "S_Pin", twitterSignInList.pin_number )
				_StripeCardNo = twitterSignInList.card_number
				_StripeCVVNo = twitterSignInList.cvv_number
				_StripeExpMont = twitterSignInList.expiry_date_month
				_StripeExpYear = twitterSignInList.expiry_date_year
				_StripePin = twitterSignInList.pin_number
			end
			
			_UserName = twitterSignInList.email
			_fName = twitterSignInList.first_name
			_lName = twitterSignInList.last_name
			_Password = ""
			_UserID = twitterSignInList.id
			_Varified = "1"
			_Alleregy = twitterSignInList.allergies
			
			registerDeviceFunc()
        	
        end
     
    end
	return true
	
end

local function printTable( t, label, level )
	if label then print( label ) end
	level = level or 1

	if t then
		for k,v in pairs( t ) do
			local prefix = ""
			for i=1,level do
				prefix = prefix .. "\t"
			end

			print( prefix .. "[" .. tostring(k) .. "] = " .. tostring(v) )
			if type( v ) == "table" then
				print( prefix .. "{" )
				printTable( v, nil, level + 1 )
				print( prefix .. "}" )
			end
		end
	end
end

local function fbListener( event )

--- Debug Event parameters printout --------------------------------------------------
--- Prints Events received up to 20 characters. Prints "..." and total count if longer
---
	
	local maxStr = 20		-- set maximum string length
	local endStr
	
	for k,v in pairs( event ) do
		local valueString = tostring(v)
		if string.len(valueString) > maxStr then
			endStr = " ... #" .. tostring(string.len(valueString)) .. ")"
		else
			endStr = ")"
		end
		print( "   " .. tostring( k ) .. "(" .. tostring( string.sub(valueString, 1, maxStr ) ) .. endStr )
	end
--- End of debug Event routine -------------------------------------------------------

-----------------------------------------------------------------------------------------
	-- After a successful login event, send the FB command
	-- Note: If the app is already logged in, we will still get a "login" phase
	--
    if ( "session" == event.type ) then
        -- event.phase is one of: "login", "loginFailed", "loginCancelled", "logout"
		
		if event.phase ~= "login" then
			
			return
		end
		
		if event.phase == "login" then
        	local fbSessionToken = event.token
        	local fbSessionExpiry = event.expiration
        	if fbSessionToken then
         		local params = {
             		fields = "first_name,last_name,email"
           		}
           		facebook.request( "me", "GET", params )
        	end
      	end
		
		-- Request the current logged in user's info
		if fbCommand == GET_USER_INFO then
			facebook.request( "me" )
		end
		
-----------------------------------------------------------------------------------------

    elseif ( "request" == event.type ) then
        -- event.response is a JSON object from the FB server
        local response = event.response
        	
		if ( not event.isError ) then
	        response = json.decode( event.response )
	        
	        if fbCommand == GET_USER_INFO then
	        	printTable( response, "User Info", 3 )
				
				if(response.email == nil or response.email == "" or response.email == " ") then
					
				else
				
					local headers = {}
			
					headers["Content-Type"] = "application/x-www-form-urlencoded"
					headers["Accept-Language"] = "en-US"
			
					local body = "first_name="..response.first_name.."&last_name="..response.last_name.."&email="..response.email.."&connect=fb"
					local params = {}
					params.headers = headers
					params.body = body
					params.timeout = 180
				
					local url = _WebLink.."fb-g-connect.php?"
					signInFbRequest = network.request( url, "POST", signInUsingFBNetworkListener, params )
					native.setActivityIndicator( true )
					
				end
				
			end
			
    	else
        	-- Post Failed
			printTable( event.response, "Post Failed Response", 3 )
		end
		
	elseif ( "dialog" == event.type ) then
		-- showDialog response
		--
    end
    
end

local function handleButtonEvent( event )
	if event.phase == "ended" then
		
		if event.target.id == "signIn" then
			if emailTf.text == "" then
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Email1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk2 )
			
			elseif pswdTf.text == "" then
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Password1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk3 )
		
			else
				-- Access Google over SSL:
				local emailTfValue = emailTf.text:gsub( "&", "%%26" )
				local pswdTfValue = pswdTf.text:gsub( "&", "%%26" )
				
				local url = _WebLink.."login.php?ws=1&email="..emailTfValue.."&password="..pswdTfValue
				local url2 = url:gsub(" ", "%%20")
				signInRequest = network.request( url2, "GET", signInListNetworkListener )
				native.setActivityIndicator( true )
				
			end
		
		elseif event.target.id == "facebook" then
			if ( appId ) then
				fbCommand = GET_USER_INFO
				facebook.login( fbListener, {"email"}  )
				
			else
				native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey),{ GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			end
			
		elseif event.target.id == "twitter" then
			
			local listener = function( event )
				if event.phase == "authorised" then
					local postMessage = {"users", "account/verify_credentials.json", "GET",
						{"screen_name", "SELF"}, {"skip_status", "true"},
						{"include_entities", "false"}, {"include_email", "true"} }
					twitter:getInfo( postMessage )
				end
			end
			
			twitter = GGTwitter:new( consumerKey, consumerSecret, listener )
			twitter:authorise()
			
		end
		
	end

	return true
end

local function handleBackgroundEvent( event )
	native.setKeyboardFocus( nil )
	signInGroup.y = signInGroupY
	signInTitle.isVisible = true
	facebookBtn.isVisible = true
	twitterBtn.isVisible = true
	signUp.isVisible = true
	
	return true
end

local function handleBackgroundEventTouch( event )
	if event.phase == "ended" then
		native.setKeyboardFocus( nil )
		signInGroup.y = signInGroupY
		signInTitle.isVisible = true
		facebookBtn.isVisible = true
		twitterBtn.isVisible = true
		signUp.isVisible = true
		
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
        
        local whiteBg = display.newImageRect( imageDirectory.."White_Background.png", _W, _H/1.25 )
        whiteBg.anchorY = 1
        whiteBg.x = _W/2
        whiteBg.y = _H
        whiteBg:addEventListener( "tap", handleBackgroundEvent )
        whiteBg:addEventListener( "touch", handleBackgroundEventTouch )
        sceneGroup:insert( whiteBg )
        
        local logo = display.newImageRect( "images/Wopadu_Logo.png", _W/3.91, _H/6.78 )
        logo.anchorY = 1
        logo.x = _W/2
        logo.y = whiteBg.y - whiteBg.height - _H/38.4
        sceneGroup:insert( logo )
    
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
        
        
        networkReqCount1 = 0
        networkReqCount2 = 0
        networkReqCount3 = 0
        networkReqCount4 = 0
        
        _passwordPreviousScene = composer.getSceneName( "current" )
        signInGroup = display.newGroup()
        sceneGroup:insert( signInGroup )
        
        signInTitle = display.newText( GBCLanguageCabinet.getText("SignInLabel",_LanguageKey), _W/2, _H/4.08, _FontArr[6], _H/25 )
        signInTitle:setFillColor( 83/255, 20/255, 111/255 )
        signInGroup:insert( signInTitle )
		
		if( _LanguageKey == "ru" or _LanguageKey == "uk" ) then
			signUpTextSize = _H/45
		else
			signUpTextSize = _H/32
		end
		
		facebookBtn = widget.newButton
		{
    		width = _W/1.08,
    		height = _H/16.27,
    		defaultFile = imageDirectory.."Facebook_Btn.png",
   			overFile = imageDirectory.."Facebook_Btn.png",
    		label = GBCLanguageCabinet.getText("FacebookLabel",_LanguageKey),
    		labelColor = { default={ 52/255, 85/255, 146/255 }, over={ 52/255, 85/255, 146/255 } },
    		labelYOffset = _H/275,
    		fontSize = _H/30,
    		font = _FontArr[10],
    		id = "facebook",
    		onEvent = handleButtonEvent
		}
		facebookBtn.x = _W/2
		facebookBtn.y = _H/3.03
		signInGroup:insert( facebookBtn )
		
		twitterBtn = widget.newButton
		{
    		width = _W/1.08,
    		height = _H/16.27,
    		defaultFile = imageDirectory.."Twitter_Btn.png",
   			overFile = imageDirectory.."Twitter_Btn.png",
    		label = GBCLanguageCabinet.getText("TwitterLabel",_LanguageKey),
    		labelColor = { default={ 0/255, 172/255, 237/255 }, over={ 0/255, 172/255, 237/255 } },
    		labelYOffset = _H/275,
    		fontSize = _H/30,
    		font = _FontArr[10],
    		id = "twitter",
    		onEvent = handleButtonEvent
		}
		twitterBtn.x = _W/2
		twitterBtn.y = facebookBtn.y + facebookBtn.height/2 + twitterBtn.height/2 + _H/38.4
		signInGroup:insert( twitterBtn )
		
		signUp = widget.newButton
		{
    		width = _W/1.08,
    		height = _H/16.27,
    		defaultFile = imageDirectory.."SinUp_Btn2.png",
   			overFile = imageDirectory.."SinUp_Btn2.png",
    		label = GBCLanguageCabinet.getText("signUpWithEmailLabel",_LanguageKey),
    		labelColor = { default={ 83/255, 80/255, 79/255 }, over={ 83/255, 80/255, 79/255 } },
    		labelYOffset = _H/275,
    		fontSize = signUpTextSize,
    		font = _FontArr[6],
    		onEvent = handleSignUpEvent
		}
		signUp.x = _W/2
		signUp.y = twitterBtn.y + twitterBtn.height/2 + signUp.height/2 + _H/38.4
		signInGroup:insert( signUp )
		
		lineImg = display.newImageRect( imageDirectory.."DeviderLine.png", _W, _H/384 )
		lineImg.x = _W/2
		lineImg.y = signUp.y + signUp.height/2 + _H/27.42
		signInGroup:insert( lineImg )
		
		emailBg = display.newImageRect( imageDirectory.."Email_Bg.png", _W/1.08, _H/13.33 )
        emailBg.x = _W/2.01
        emailBg.y = lineImg.y + lineImg.height/2 + emailBg.height/2 + _H/38.4
        signInGroup:insert( emailBg )
        
        emailTf = native.newTextField( emailBg.x, emailBg.y, emailBg.width - textFieldWidth, emailBg.height - textFieldHeight )
		emailTf.hasBackground = false
		emailTf.inputType = "email"
		emailTf.placeholder = GBCLanguageCabinet.getText("EmailLabel",_LanguageKey)
		emailTf:addEventListener( "userInput", onEmailEdit )
		emailTf.font = native.newFont( _FontArr[10], _H/28 )
		signInGroup:insert( emailTf )
		
        pswdBg = display.newImageRect( imageDirectory.."Password_Bg.png", _W/1.08, _H/13.33 )
        pswdBg.x = _W/2.01
        pswdBg.y = emailBg.y + emailBg.height
        signInGroup:insert( pswdBg )
        
        pswdTf = native.newTextField( pswdBg.x, pswdBg.y, pswdBg.width - textFieldWidth, pswdBg.height - textFieldHeight )
		pswdTf.hasBackground = false
		pswdTf.isSecure = true
		pswdTf.placeholder = GBCLanguageCabinet.getText("passwordLabel",_LanguageKey)
		pswdTf.font = native.newFont( _FontArr[10], _H/28 )
		pswdTf:addEventListener( "userInput", onPswdEdit )
		signInGroup:insert( pswdTf )
		
		forgotPswd = display.newText(GBCLanguageCabinet.getText("ForgotPasswordLabel",_LanguageKey).."?" , _W/18, pswdBg.y + pswdBg.height/2 + _H/38.4, _FontArr[6], _H/32 )
		forgotPswd.anchorX = 0
		forgotPswd.anchorY = 0
        forgotPswd:setFillColor( 83/255, 80/255, 79/255 )
        signInGroup:insert( forgotPswd )
        
        forgotPswdBg = display.newRect( forgotPswd.x, forgotPswd.y, forgotPswd.width + _W/36, forgotPswd.height + _H/96 )
        forgotPswdBg.anchorX = 0
        forgotPswdBg.anchorY = 0
        forgotPswdBg:setFillColor( 0, 0, 0, 0.01 )
        forgotPswdBg:addEventListener( "tap", handleForgotPasswordEvent )
        signInGroup:insert( forgotPswdBg )
		
		signInBtn = widget.newButton
		{
    		width = _W/1.08,
    		height = _H/16.27,
    		defaultFile = imageDirectory.."SinIn_Btn2.png",
   			overFile = imageDirectory.."SinIn_Btn2.png",
    		label = GBCLanguageCabinet.getText("SignInLabel",_LanguageKey),
    		labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
    		labelYOffset = _H/275,
    		fontSize = signUpTextSize,
    		font = _FontArr[6],
    		id = "signIn",
    		onEvent = handleButtonEvent
		}
		signInBtn.x = _W/2
		signInBtn.y = forgotPswdBg.y + forgotPswdBg.height + signInBtn.height/2 + _H/96
		signInGroup:insert( signInBtn )
		
         if( _LanguageKey == "de" or _LanguageKey == "ru" ) then
        
        	labelTextSizes = _H/70
        elseif( _LanguageKey == "es" ) then
        
        	labelTextSizes = _H/65
        else
        
        	labelTextSizes = _H/55.20
        end
		
        title = display.newText(tostring(GBCLanguageCabinet.getText("20Alert",_LanguageKey)), _W/2, _H/1.07 - _H/96, _FontArr[30], labelTextSizes )
		title.anchorY = 0
        title:setFillColor( 139/255, 139/255, 139/255 )
        signInGroup:insert( title )
        
        title2 = display.newText(GBCLanguageCabinet.getText("andLabel",_LanguageKey), _W/2, _H/1.045- _H/96, _FontArr[30], labelTextSizes )
		title2.anchorY = 0
        title2:setFillColor( 139/255, 139/255, 139/255 )
        signInGroup:insert( title2 )
                
        terms = display.newText(  GBCLanguageCabinet.getText("21Alert",_LanguageKey), title2.x - title2.width/2 - _W/108, _H/1.045- _H/96, _FontArr[30], labelTextSizes )
		terms.anchorX = 1
		terms.anchorY = 0
        terms:setFillColor( 206/255, 23/255, 100/255 )
        signInGroup:insert( terms )
        
        termsBg = display.newRect( terms.x, terms.y- _H/96, terms.width + _W/36, terms.height + _H/96 )
        termsBg.anchorX = 1
        termsBg.anchorY = 0
        termsBg:setFillColor( 0, 0, 0, 0.01 )
        termsBg:addEventListener( "tap", handleTermsEvent )
        signInGroup:insert( termsBg )
        
        policy = display.newText( GBCLanguageCabinet.getText("PrivacyPolicyLabel",_LanguageKey), title2.x + title2.width/2 + _W/108, _H/1.045- _H/96, _FontArr[30], labelTextSizes )
		policy.anchorX = 0
		policy.anchorY = 0
        policy:setFillColor( 206/255, 23/255, 100/255 )
        signInGroup:insert( policy )
        
        policyBg = display.newRect( policy.x, policy.y- _H/96, policy.width + _W/36, policy.height + _H/96 )
        policyBg.anchorX = 0
        policyBg.anchorY = 0
        policyBg:setFillColor( 0, 0, 0, 0.01 )
        policyBg:addEventListener( "tap", handlePolicyEvent )
        signInGroup:insert( policyBg )
        
        signInGroupY = signInGroup.y
        
        
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
        
        
        display.remove( signInTitle )
        signInTitle = nil
        
        display.remove( emailBg )
        emailBg = nil
        
        display.remove( pswdBg )
        pswdBg = nil
        
        display.remove( emailTf )
        emailTf = nil
        
        display.remove( pswdTf )
        pswdTf = nil
        
        display.remove( forgotPswdBg )
        forgotPswdBg = nil
        
        display.remove( forgotPswd )
        forgotPswd = nil
        
        display.remove( signInBtn )
        signInBtn = nil
        
        display.remove( facebookBtn )
        facebookBtn = nil
        
        display.remove( twitterBtn )
        twitterBtn = nil
        
        display.remove( signUp )
        signUp = nil
        
        display.remove( lineImg )
        lineImg = nil
        
        display.remove( title )
        title = nil
        
        display.remove( terms )
        terms = nil
        
        display.remove( title2 )
        title2 = nil
        
        display.remove( policy )
        policy = nil
        
        display.remove( termsBg )
        termsBg = nil
        
        display.remove( policyBg )
        policyBg = nil
        
        display.remove( signInGroup )
        signInGroup = nil
        
        
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
        if(signInRequest) then
        	network.cancel( signInRequest )
        	signInRequest = nil
        end
        
        if(signInFbRequest) then
        	network.cancel( signInFbRequest )
        	signInFbRequest = nil
        end
        
        if(signInTwitterRequest) then
        	network.cancel( signInTwitterRequest )
        	signInTwitterRequest = nil
        end
        
        if(signInGoogleRequest) then
        	network.cancel( signInGoogleRequest )
        	signInGoogleRequest = nil
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