local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

local imageDirectory = "images/SignUp/"

local signUpGroup, title, fNameBg, lNameBg, mobNoBg, emailBg, pswdBg, lineImg, title2, terms, title3,heading, signUpGroupY
local fNameTf, lNameTf, mobNoTf, emailTf, pswdTf, signUpBtn, facebookBtn, googleBtn, policy, termsBg, policyBg, twitterBtn
local textFieldWidth = _W/32
local textFieldHeight = _H/64

local fbCommand,signUpFbRequest,signUpGoogleRequest,signUpRequest
local LOGOUT = 1
local SHOW_DIALOG = 2
local POST_MSG = 3
local POST_PHOTO = 4
local GET_USER_INFO = 5
local GET_PLATFORM_INFO = 6
local networkReqCount1,networkReqCount2,networkReqCount3,networkReqCount4
local response,decodeResponse


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
	fNameTf.text = ""
	mobNoTf.text = ""
	emailTf.text = ""
	pswdTf.text = ""
	local options = {
		params = { userIdForVerification = _UserID }
	}
	composer.gotoScene( "verifiedAcc", options )
	
	return true
end

local function handleOk2( event )
	fNameTf.text = ""
	mobNoTf.text = ""
	emailTf.text = ""
	pswdTf.text = ""
		
	return true
end

local function handleOk3( event )
	fNameTf.text = ""
		
	return true
end

local function handleOk4( event )
		
	return true
end

local function handleOk5( event )
	emailTf.text = ""
		
	return true
end

local function handleOk6( event )
	pswdTf.text = ""
		
	return true
end

local function handleOk7( event )

	return true
end

local function onFNameEdit( event )
	if ( event.phase == "began" ) then
		signUpGroup.y = -_H/4.3
		facebookBtn.isVisible = false
		twitterBtn.isVisible = false
		lineImg.isVisible = false
		
    elseif ( event.phase == "ended" ) then
        
        signUpGroup.y = signUpGroupY
        facebookBtn.isVisible = true
		twitterBtn.isVisible = true
		lineImg.isVisible = true
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( lNameTf )
	
    elseif ( event.phase == "editing" ) then
	
    end

	return true
end

local function onLNameEdit( event )
	if ( event.phase == "began" ) then
		signUpGroup.y = -_H/4.3
		facebookBtn.isVisible = false
		twitterBtn.isVisible = false
		lineImg.isVisible = false
		
    elseif ( event.phase == "ended" ) then
        
        signUpGroup.y = signUpGroupY
        facebookBtn.isVisible = true
		twitterBtn.isVisible = true
		lineImg.isVisible = true
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( mobNoTf )
	
    elseif ( event.phase == "editing" ) then
	
    end

	return true
end

local function onMobNoEdit( event )
	if ( event.phase == "began" ) then
		signUpGroup.y = -_H/4.3
		facebookBtn.isVisible = false
		twitterBtn.isVisible = false
		lineImg.isVisible = false
		
    elseif ( event.phase == "ended" ) then
        
        signUpGroup.y = signUpGroupY
        facebookBtn.isVisible = true
		twitterBtn.isVisible = true
		lineImg.isVisible = true
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( emailTf )

    elseif ( event.phase == "editing" ) then
	
    end

	return true
end

local function onEmailEdit( event )
	if ( event.phase == "began" ) then
		signUpGroup.y = -_H/4.3
		facebookBtn.isVisible = false
		twitterBtn.isVisible = false
		lineImg.isVisible = false
		
    elseif ( event.phase == "ended" ) then
        
        signUpGroup.y = signUpGroupY
        facebookBtn.isVisible = true
		twitterBtn.isVisible = true
		lineImg.isVisible = true
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( pswdTf )

    elseif ( event.phase == "editing" ) then
	
    end

	return true
end

local function onPswdEdit( event )
	if ( event.phase == "began" ) then
		signUpGroup.y = -_H/4.3
		facebookBtn.isVisible = false
		twitterBtn.isVisible = false
		lineImg.isVisible = false
		
    elseif ( event.phase == "ended" ) then
        
        signUpGroup.y = signUpGroupY
        facebookBtn.isVisible = true
		twitterBtn.isVisible = true
		lineImg.isVisible = true
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then
	
    end

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

local function handleBackButtonEvent( event )
	
		composer.gotoScene( "login" )
	
	return true
end

local function handleBackButtonEventTouch( event )
	if event.phase == "ended" then
		composer.gotoScene( "login" )
	end

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
		local url2 = url:gsub( " ", "%%20" )
		deviceRequest = network.request( url2, "GET", deviceIdNetworkListener )
		native.setActivityIndicator( true )
		
	return true
end


local function signUpListNetworkListener( event )

	if ( event.isError ) then
        
        
        networkReqCount2 = networkReqCount2 + 1
    	native.setActivityIndicator( false )
		
		if( networkReqCount2 > 3 ) then
		
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		else
			
			local fNameTfValue = fNameTf.text:gsub( "&", "%%26" )
			local lNameTfValue = lNameTf.text:gsub( "&", "%%26" )
			local emailTfValue = emailTf.text:gsub( "&", "%%26" )
			local passwordTfValue = pswdTf.text:gsub( "&", "%%26" )
			local mobNoTfValue = mobNoTf.text:gsub( "&", "%%26" )
				
			local url = _WebLink.."register.php?ws=1&first_name="..fNameTfValue.."&last_name="..lNameTfValue.."&email="..emailTfValue.."&password="..passwordTfValue.."&pin_number=1234&mobile="..mobNoTfValue
			local url2 = url:gsub( " ", "%%20" )
			signUpRequest = network.request( url2, "GET", signUpListNetworkListener )
			native.setActivityIndicator( true )
			
		end
    else
        
        
        local signUpList = json.decode(event.response)
        
        if( signUpList == 0 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( signUpList == 1 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( signUpList == 2 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk3 ) 
        	
        elseif( signUpList == 4 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Email2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk5 ) 
        	
        elseif( signUpList == 5 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Password4Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk6 )
        	
        elseif( signUpList == 6 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Pin2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing ) 
        	
        elseif( signUpList == 7 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Email9Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk5 ) 
        	
        elseif( signUpList == 8 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        else
        	storeData( "UserID", signUpList.id )
        	storeData( "UserName", signUpList.email )
			storeData( "Password", pswdTf.text )
			storeData( "Varified", "0" )
			storeData( "F_Name", signUpList.first_name )
			storeData( "L_Name", signUpList.last_name )
			
			
			_UserName = signUpList.email
			_fName = signUpList.first_name
			_lName = signUpList.last_name
			_Password = pswdTf.text
			_UserID = signUpList.id
			_Varified = "0"
			
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Email10Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk )
        	
        end
      	
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
        
    end
	return true
end

local function signUpUsingFBNetworkListener( event )
	if ( event.isError ) then
        
        
        networkReqCount1 = networkReqCount1 + 1
    	native.setActivityIndicator( false )
    	
		if( networkReqCount1 > 3 ) then
		
			local alert = native.showAlert( alertLabel, NetworkErrorMsg, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		else
		
			local url = _WebLink.."fb-g-connect.php?first_name="..response.first_name.."&last_name="..response.last_name.."&email="..response.email.."&connect=fb"
			local url2 = url:gsub( " ", "%%20" )
			signUpFbRequest = network.request( url2, "GET", signUpUsingFBNetworkListener )
			native.setActivityIndicator( true )
		
		end
    else
        
        
        local signUpList = json.decode(event.response)
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
        if( signUpList == 0 ) then
        	local alert = native.showAlert( alertLabel, "All fields are mandatory.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( signUpList == 1 ) then
        	local alert = native.showAlert( alertLabel, "All fields are mandatory.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( signUpList == 2 ) then
        	local alert = native.showAlert( alertLabel, "Invalid connection variable.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( signUpList == 3 ) then
        	local alert = native.showAlert( alertLabel, "Something went wrong, Query Error.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
        elseif( signUpList == 4 ) then
        	local alert = native.showAlert( alertLabel, "Something went wrong, Query Error.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        else
        
        	_UserID = signUpList.id
			storeData( "UserID", signUpList.id )
        	storeData( "UserName", signUpList.email )
			storeData( "Password", "" )
			storeData( "Varified", "1" )
			storeData( "F_Name", signUpList.first_name )
			storeData( "L_Name", signUpList.last_name )
			storeData( "fb", "1" )
			
			if(signUpList.stripe_id) then
				storeData( "S_ID", signUpList.stripe_id )
				_StripeCustomerID = signUpList.stripe_id
			end
			
			_UserName = signUpList.email
			_fName = signUpList.first_name
			_lName = signUpList.last_name
			_Password = ""
			_UserID = signUpList.id
			_Varified = "1"
			
			registerDeviceFunc()
        	
        end
      
        
        
    end
	return true


end

local function signUpUsingTwitterNetworkListener( event )
	if ( event.isError ) then
        
        
        networkReqCount4 = networkReqCount4 + 1
        
    	native.setActivityIndicator( false )
    	
    	if( networkReqCount4 > 3 ) then
		
			local alert = native.showAlert( alertLabel, NetworkErrorMsg, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		else
			
			local url = _WebLink.."fb-g-connect.php?first_name="..fName.."&last_name="..lName.."&email="..response.email.."&connect=t"
			local url2 = url:gsub(" ", "%%20")
			signInTwitterRequest = network.request( url2, "GET", signUpUsingTwitterNetworkListener )
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
			-- Exit if login error
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
					signInFbRequest = network.request( url, "POST", signUpUsingFBNetworkListener, params )
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
		
		if event.target.id == "signUp" then
			if fNameTf.text == "" then
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Enter1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk7 ) 
			
			elseif lNameTf.text == "" then
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Enter2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk7 )
			
			elseif mobNoTf.text == "" then
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Enter3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk7 )
			
			elseif emailTf.text == "" then 
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Email1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk7 )
			
			elseif pswdTf.text == "" then
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Password1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk7 ) 
		
			else
				-- Access Google over SSL:
				
				
				local fNameTfValue = fNameTf.text:gsub( "&", "%%26" )
				local lNameTfValue = lNameTf.text:gsub( "&", "%%26" )
				local emailTfValue = emailTf.text:gsub( "&", "%%26" )
				local passwordTfValue = pswdTf.text:gsub( "&", "%%26" )
				local mobNoTfValue = mobNoTf.text:gsub( "&", "%%26" )
				
				local url = _WebLink.."register.php?ws=1&first_name="..fNameTfValue.."&last_name="..lNameTfValue.."&email="..emailTfValue.."&password="..passwordTfValue.."&pin_number=1234&mobile="..mobNoTfValue
				local url2 = url:gsub( " ", "%%20" )
				signUpRequest = network.request( url2, "GET", signUpListNetworkListener )
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
	signUpGroup.y = signUpGroupY
	facebookBtn.isVisible = true
	twitterBtn.isVisible = true
	lineImg.isVisible = true
	
	return true
end

local function handleBackgroundEventTouch( event )
	if event.phase == "ended" then
		native.setKeyboardFocus( nil )
		signUpGroup.y = signUpGroupY
        facebookBtn.isVisible = true
		twitterBtn.isVisible = true
		lineImg.isVisible = true
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
        
        local header = display.newImageRect( imageDirectory.."Header.png", _W, _H/13.24 )
        header.x = _W/2
        header.y = _H/27
        sceneGroup:insert( header )
        
        heading = display.newText( GBCLanguageCabinet.getText("SignUpLabel",_LanguageKey), header.x, header.y, _FontArr[6], _H/30 ) 
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
        
        
        
        heading.text = GBCLanguageCabinet.getText("SignUpLabel",_LanguageKey)
        
        signUpGroup = display.newGroup()
        sceneGroup:insert( signUpGroup )
        
        networkReqCount1 = 0
        networkReqCount2 = 0
        networkReqCount3 = 0
        networkReqCount4 = 0
        
        facebookBtn = widget.newButton
		{
    		width = _W/1.08,
    		height = _H/16.27,
    		defaultFile = imageDirectory.."Facebook_Btn.png",
   			overFile = imageDirectory.."Facebook_Btn.png",
    		label = "CONNECT WITH FACEBOOK",
    		labelColor = { default={ 52/255, 85/255, 146/255 }, over={ 52/255, 85/255, 146/255 } },
    		labelYOffset = _H/275,
    		fontSize = _H/30,
    		font = _FontArr[10],
    		id = "facebook",
    		onEvent = handleButtonEvent
		}
		facebookBtn.x = _W/2
		facebookBtn.y = _H/7.68 
		signUpGroup:insert( facebookBtn )
		
		twitterBtn = widget.newButton
		{
    		width = _W/1.08,
    		height = _H/16.27,
    		defaultFile = imageDirectory.."Twitter_Btn.png",
   			overFile = imageDirectory.."Twitter_Btn.png",
    		label = "CONNECT WITH TWITTER",
    		labelColor = { default={ 0/255, 172/255, 237/255 }, over={ 0/255, 172/255, 237/255 } },
    		labelYOffset = _H/275,
    		fontSize = _H/30,
    		font = _FontArr[10],
    		id = "twitter",
    		onEvent = handleButtonEvent
		}
		twitterBtn.x = _W/2
		twitterBtn.y = facebookBtn.y + facebookBtn.height/2 + twitterBtn.height/2 + _H/38.4 
		signUpGroup:insert( twitterBtn )
		
		lineImg = display.newImageRect( imageDirectory.."DeviderLine.png", _W, _H/384 )
		lineImg.x = _W/2
		lineImg.y = twitterBtn.y + twitterBtn.height/2 + _H/27.42
		signUpGroup:insert( lineImg )
        
        local option = {
        	text = GBCLanguageCabinet.getText("wopaduNeedsDetailsLabel",_LanguageKey),
        	x = _W/2,
        	y = lineImg.y + lineImg.height/2 + _H/27.42, 
        	width = _W - _W/27,
        	height = 0,
        	font = _FontArr[6],
        	fontSize =  _H/35,
        	align = "center"
        }
        
        title = display.newText( option )
        title.anchorY = 0
        title:setFillColor( 83/255, 80/255, 79/255 )
        signUpGroup:insert( title )
        
        fNameBg = display.newImageRect( imageDirectory.."TextField.png", _W/1.08, _H/13.33 )
        fNameBg.x = title.x
        fNameBg.y = title.y + title.height/2 + _H/12.8
        signUpGroup:insert( fNameBg )
        
        fNameTf = native.newTextField( fNameBg.x, fNameBg.y, fNameBg.width - textFieldWidth, fNameBg.height - textFieldHeight )
		fNameTf.hasBackground = false
		fNameTf.placeholder = GBCLanguageCabinet.getText("firstNameLabel",_LanguageKey)
		fNameTf:addEventListener( "userInput", onFNameEdit )
		fNameTf.font = native.newFont( _FontArr[10], _H/28 )
		signUpGroup:insert( fNameTf )
        
        lNameBg = display.newImageRect( imageDirectory.."MidTextField.png", _W/1.08, _H/13.33 )
        lNameBg.x = fNameBg.x
        lNameBg.y = fNameBg.y + fNameBg.height
        signUpGroup:insert( lNameBg )
        
        lNameTf = native.newTextField( lNameBg.x, lNameBg.y, lNameBg.width - textFieldWidth, lNameBg.height - textFieldHeight )
		lNameTf.hasBackground = false
		lNameTf.placeholder = GBCLanguageCabinet.getText("lastNameLabel",_LanguageKey)
		lNameTf:addEventListener( "userInput", onLNameEdit )
		lNameTf.font = native.newFont( _FontArr[10], _H/28 )
		signUpGroup:insert( lNameTf )
        
        mobNoBg = display.newImageRect( imageDirectory.."MidTextField.png", _W/1.08, _H/13.33 )
        mobNoBg.x = fNameBg.x
        mobNoBg.y = lNameBg.y + lNameBg.height
        signUpGroup:insert( mobNoBg )
        
        mobNoTf = native.newTextField( mobNoBg.x, mobNoBg.y, mobNoBg.width - textFieldWidth, mobNoBg.height - textFieldHeight )
		mobNoTf.hasBackground = false
		mobNoTf.inputType = "phone"
		mobNoTf.placeholder = GBCLanguageCabinet.getText("mobileNoLabel",_LanguageKey)
		mobNoTf:addEventListener( "userInput", onMobNoEdit )
		mobNoTf.font = native.newFont( _FontArr[10], _H/28 )
		signUpGroup:insert( mobNoTf )
        
        emailBg = display.newImageRect( imageDirectory.."MidTextField.png", _W/1.08, _H/13.33 )
        emailBg.x = mobNoBg.x
        emailBg.y = mobNoBg.y + mobNoBg.height
        signUpGroup:insert( emailBg )
        
        emailTf = native.newTextField( emailBg.x, emailBg.y, emailBg.width - textFieldWidth, emailBg.height - textFieldHeight )
		emailTf.hasBackground = false
		emailTf.inputType = "email"
		emailTf.placeholder = GBCLanguageCabinet.getText("EmailLabel",_LanguageKey)
		emailTf:addEventListener( "userInput", onEmailEdit )
		emailTf.font = native.newFont( _FontArr[10], _H/28 )
		signUpGroup:insert( emailTf )
        
        pswdBg = display.newImageRect( imageDirectory.."endTextField.png", _W/1.08, _H/13.33 )
        pswdBg.x = emailBg.x
        pswdBg.y = emailBg.y + emailBg.height
        signUpGroup:insert( pswdBg )
        
        pswdTf = native.newTextField( pswdBg.x, pswdBg.y, pswdBg.width - textFieldWidth, pswdBg.height - textFieldHeight )
		pswdTf.hasBackground = false
		pswdTf.isSecure = true
		pswdTf.placeholder = GBCLanguageCabinet.getText("passwordLabel",_LanguageKey)
		pswdTf.font = native.newFont( _FontArr[10], _H/28 )
		pswdTf:addEventListener( "userInput", onPswdEdit )
		signUpGroup:insert( pswdTf )
		
		signUpBtn = widget.newButton
		{
    		width = _W/1.08,
    		height = _H/16.27,
    		defaultFile = imageDirectory.."SinUp_Btn.png",
   			overFile = imageDirectory.."SinUp_Btn.png",
    		label = GBCLanguageCabinet.getText("SignUpLabel",_LanguageKey), 
    		labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
    		labelYOffset = _H/275,
    		fontSize = _H/30,
    		font = _FontArr[6],
    		id = "signUp",
    		onEvent = handleButtonEvent
		}
		signUpBtn.x = _W/2
		signUpBtn.y = pswdBg.y + pswdBg.height/2 + signUpBtn.height/2 + _H/19.2 
		signUpGroup:insert( signUpBtn )
		
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
        signUpGroup:insert( title )
        
        title2 = display.newText(GBCLanguageCabinet.getText("andLabel",_LanguageKey), _W/2, _H/1.045- _H/96, _FontArr[30], labelTextSizes )
		title2.anchorY = 0
        title2:setFillColor( 139/255, 139/255, 139/255 )
        signUpGroup:insert( title2 )
        
        terms = display.newText(  GBCLanguageCabinet.getText("21Alert",_LanguageKey), title2.x - title2.width/2 - _W/108, _H/1.045- _H/96, _FontArr[30], labelTextSizes )
		terms.anchorX = 1
		terms.anchorY = 0
        terms:setFillColor( 206/255, 23/255, 100/255 )
        signUpGroup:insert( terms )
        
        termsBg = display.newRect( terms.x, terms.y- _H/96, terms.width + _W/36, terms.height + _H/96 )
        termsBg.anchorX = 1
        termsBg.anchorY = 0
        termsBg:setFillColor( 0, 0, 0, 0.01 )
        termsBg:addEventListener( "tap", handleTermsEvent )
        signUpGroup:insert( termsBg )
        
        policy = display.newText( GBCLanguageCabinet.getText("PrivacyPolicyLabel",_LanguageKey), title2.x + title2.width/2 + _W/108, _H/1.045- _H/96, _FontArr[30], labelTextSizes )
		policy.anchorX = 0
		policy.anchorY = 0
        policy:setFillColor( 206/255, 23/255, 100/255 )
        signUpGroup:insert( policy )
        
        policyBg = display.newRect( policy.x, policy.y- _H/96, policy.width + _W/36, policy.height + _H/96 )
        policyBg.anchorX = 0
        policyBg.anchorY = 0
        policyBg:setFillColor( 0, 0, 0, 0.01 )
        policyBg:addEventListener( "tap", handlePolicyEvent )
        signUpGroup:insert( policyBg )
        
     	signUpGroupY = signUpGroup.y
        
        
        
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
        
        
        display.remove( signUpGroup )
        signUpGroup = nil
        
        display.remove( title )
        title = nil
        
        display.remove( fNameBg )
        fNameBg = nil
        
        display.remove( lNameBg )
        lNameBg = nil
        
        display.remove( mobNoBg )
        mobNoBg = nil
        
        display.remove( emailBg )
        emailBg = nil
        
        display.remove( pswdBg )
        pswdBg = nil
        
        display.remove( fNameTf )
        fNameTf = nil
        
        display.remove( lNameTf )
        lNameTf = nil
        
        display.remove( mobNoTf )
        mobNoTf = nil
        
        display.remove( emailTf )
        emailTf = nil
        
        display.remove( pswdTf )
        pswdTf = nil
        
        display.remove( facebookBtn )
        facebookBtn = nil
        
        display.remove( twitterBtn )
        twitterBtn = nil
        
        display.remove( lineImg )
        lineImg = nil
        
        display.remove( title2 )
        title2 = nil
        
        display.remove( terms )
        terms = nil
        
        display.remove( title3 )
        title3 = nil
        
        display.remove( policy )
        policy = nil
        
        display.remove( termsBg )
        termsBg = nil
        
        display.remove( policyBg )
        policyBg = nil
        
        
        
        
        
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
        if(signUpRequest) then
        	network.cancel( signUpRequest )
        	signUpRequest = nil
        end
        
        if(signUpFbRequest) then
        	network.cancel( signUpFbRequest )
        	signUpFbRequest = nil
        end
        
        if(signUpGoogleRequest) then
        	network.cancel( signUpGoogleRequest )
        	signUpGoogleRequest = nil
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