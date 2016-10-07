local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


local imageDirectory = "images/SignUp/"
local imageDirectory2 = "images/ChangePassword/"

local title, title2, saveChangesBtn, f_NameBg, f_NameTf, l_NameBg, l_NameTf, mobileNoBg, mobileNoTf
local getUserSocialInfoRequest,getUserInfoRequest,editProfileRequest
local textFieldWidth = _W/32
local textFieldHeight = _H/64

local editProfileRequest,getUserInfoRequest

local function storeData(name,data)
	local saveData = data
	local path = system.pathForFile( name, system.DocumentsDirectory )
	local file = io.open( path, "w" )
	file:write( saveData )
	io.close( file )
	file = nil
end

local function loadData(name)
	 path = system.pathForFile(name, system.DocumentsDirectory )
	 local fhd = io.open( path )
	if(fhd) then
		print("der")
		local file = io.open( path, "r" )
		 var= file:read( "*a" )
		 io.close( file )
		file = nil
		return var	
	else
		return nil	
	end
end

local function onDoNothing( event )
	return true
end

local function handleOk( event )
	
	composer.gotoScene( composer.getSceneName("previous") )
	
	return true
end

local function handleOk2( event )
	f_NameTf.text = ""
	
	return true
end

local function handleOk3( event )
	
	mobileNoTf.text = ""
	
	return true
end

local function onFirstNameEdit( event )
	if ( event.phase == "began" ) then
	
    elseif ( event.phase == "ended" ) then
        print( event.target.text )
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then
	
    end

	return true
end

local function onLastNameEdit( event )
	if ( event.phase == "began" ) then
	
    elseif ( event.phase == "ended" ) then
        print( event.target.text )
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then
	
    end

	return true
end

local function onMobileNoEdit( event )
	if ( event.phase == "began" ) then
	
    elseif ( event.phase == "ended" ) then
        print( event.target.text )
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then
	
    end

	return true
end

local function onAlleregyEdit( event )
	if ( event.phase == "began" ) then
	
    elseif ( event.phase == "ended" ) then
        print( event.target.text )
    
    elseif ( event.phase == "submitted" ) then
    	--native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then
	
    end

	return true
end


local function handleBackButtonEvent( event )
	local previous = composer.getSceneName( "previous" )
	composer.gotoScene( "menu" )
	
	return true
end

local function handleBackButtonEventTouch( event )
	if event.phase == "ended" then
		local previous = composer.getSceneName( "previous" )
		composer.gotoScene( "menu" )
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

local function handleForgotPswdEvent( event )
	composer.gotoScene( "forgotPassword" )

	return true
end

local function handleForgotPswdEventTouch( event )
	if event.phase == "ended" then
		composer.gotoScene( "forgotPassword" )
	end

	return true
end

local function EditProfileNetworkListener( event )
	
	if ( event.isError ) then
        print( "Network error!" )
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		
		local alert = native.showAlert( alertLabel, NetworkErrorMsg, { "OK" }, onDoNothing )
    else
        print ( "RESPONSE:111" .. event.response )
        
        local changePswdList = json.decode(event.response)

		if( changePswdList == 0 ) then
        	local alert = native.showAlert( alertLabel, "All fields are mandatory.", { "OK" }, onDoNothing )
        	
        elseif( changePswdList == 1 ) then
        	local alert = native.showAlert( alertLabel, "All fields are mandatory.", { "OK" }, onDoNothing )
        
        elseif( changePswdList == 2 ) then
        	local alert = native.showAlert( alertLabel, "Name is invalid. It should have only alphabets.", { "OK" }, handleOk2 )
        	
       --[[ elseif( changePswdList == 3 ) then
        	local alert = native.showAlert( alertLabel, "Password required minimum 6 characters.", { "OK" }, handleOk2 )
		]]--
        elseif( changePswdList == 4 ) then
        	local alert = native.showAlert( alertLabel, "Mobile number is invalid. It should have only numbers.", { "OK" }, handleOk3 )
        	
        elseif( changePswdList == 5 ) then
        	local alert = native.showAlert( alertLabel, "Something went wrong, Query error.", { "OK" }, onDoNothing )
        	
        elseif( changePswdList == 6 ) then
        	local alert = native.showAlert( alertLabel, "User id does not exist.", { "OK" }, onDoNothing )
        	
        elseif( changePswdList == 7 ) then
        	local alert = native.showAlert( alertLabel, "Something went wrong, Query error.", { "OK" }, onDoNothing )
        
        else
        	local alert = native.showAlert( alertLabel, "Your Account has been updated successfully.", { "OK" }, handleOk )
        	
        	storeData( "F_Name", changePswdList.first_name )
			storeData( "L_Name", changePswdList.last_name )
			storeData( "Allergies", changePswdList.allergies )
			
			_fName = changePswdList.first_name
			_lName = changePswdList.last_name
			_Alleregy = changePswdList.allergies
        	
        end
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
        
    end
	return true
end

local function handleButtonEvent( event )
	if event.phase == "ended" then
		
		if event.target.id == "save" then
			print( "save password" )
			-- Access Google over SSL:
			
			local headers = {}
			
			headers["Content-Type"] = "application/x-www-form-urlencoded"
			headers["Accept-Language"] = "en-US"
			
			
			local f_NameTfValue = f_NameTf.text:gsub( "&", "%%26" )
			local l_NameTfValue = l_NameTf.text:gsub( "&", "%%26" )
			local mobileNoTfValue = mobileNoTf.text:gsub( "&", "%%26" )
			local alleregyTfTfValue = alleregyTf.text:gsub( "&", "%%26" )
			
			
			local body = "ws=1&user_id=".._UserID.."&first_name="..f_NameTfValue.."&last_name="..l_NameTfValue.."&mobile="..mobileNoTfValue.."&allergies="..alleregyTfTfValue
			local params = {}
			params.headers = headers
			params.body = body
			
			local url = _WebLink.."profile-edit.php?"
			print( url..body )
			editProfileRequest = network.request( url, "POST", EditProfileNetworkListener, params )
			native.setActivityIndicator( true )
			
			
		end
		
	end
	
	return true
end

local function onDoNothing2( event )
	composer.gotoScene("menu")
	return true
end


local function SignInNetworkListener( event )

	if ( event.isError ) then
        print( "Network error!" )
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		local alert = native.showAlert( alertLabel, NetworkErrorMsg, { "OK" }, onDoNothing )
    else
        print ( "sign in details RESPONSE:" .. event.response )
        
        local signInList = json.decode(event.response)
        
        if( signInList == 0 ) then
        	local alert = native.showAlert( alertLabel, "Something went wrong, Please try again later.", { "OK" }, onDoNothing2 )
        	
        elseif( signInList == 1 ) then
        	local alert = native.showAlert( alertLabel, "Something went wrong, Please try again later.", { "OK" }, onDoNothing2 )
        
        elseif( signInList == 2 ) then
        	local alert = native.showAlert( alertLabel, "Something went wrong, Please try again later.", { "OK" }, onDoNothing2 )
        	
        elseif( signInList == 3 ) then
        	local alert = native.showAlert( alertLabel, "Something went wrong, Please try again later.", { "OK" }, onDoNothing2 )
		
        elseif( signInList == 4 ) then
        	local alert = native.showAlert( alertLabel, "Something went wrong, Please try again later.", { "OK" }, onDoNothing2 )
        	
        elseif( signInList == 5 ) then
        	local alert = native.showAlert( alertLabel, "Something went wrong, Please try again later.", { "OK" }, onDoNothing2 )
        	
        elseif( signInList == 6 ) then
        	local alert = native.showAlert( alertLabel, "Something went wrong, Please try again later.", { "OK" }, onDoNothing2 )
        	
        elseif( signInList == 7 ) then
        	local alert = native.showAlert( alertLabel, "You did not verify your account.", { "OK" }, onDoNothing2 )
        	
        elseif( signInList == 8 ) then
        	local alert = native.showAlert( alertLabel, "Your account has been deactivated.", { "OK" }, onDoNothing2 )
        	
        else
        	print( "login successfully" )
        	
        	f_NameTf.text = signInList.first_name
        	mobileNoTf.text = signInList.mobile
        	l_NameTf.text = signInList.last_name
        	alleregyTf.text = signInList.allergies
        end
      	
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
        
    end
	return true
end

local function handleAddStripeAccountEvent( event )
	
	composer.gotoScene( "stripeRegistration" )
	return true
end


local function handleUpdateStripeAccountEvent( event )

	composer.gotoScene( "stripeRegistration" )
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
        
        local heading = display.newText( "Edit Account", header.x, header.y, _FontArr[6], _H/30 )
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
		backBg:addEventListener( "touch", handleBackButtonEventTouch )
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
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        
        
        
        print( "In Edit Profile screen..................." )
        
        --[[title = display.newText( "Change your password,", _W/2.8, _H/26 + _H/26 + _H/27.42, _FontArr[6], _H/40 )
        title:setFillColor( 83/255, 80/255, 79/255 )
        sceneGroup:insert( title )
        
        title2 = display.newText( " Forgot Password?", title.x + title.width/2 + _W/8.30, title.y, _FontArr[6], _H/40 )
        title2:setFillColor( 206/255, 23/255, 100/255 )
        sceneGroup:insert( title2 )
        
        title2Bg = display.newRect( title2.x, title2.y, title2.width + _W/21.6, title2.height + _H/38.4 )
        title2Bg:setFillColor( 0, 0, 0, 0.01 )
        title2Bg:addEventListener( "tap", handleForgotPswdEvent)
        title2Bg:addEventListener( "touch", handleForgotPswdEventTouch)
        sceneGroup:insert( title2Bg )]]--
        
        f_NameBg = display.newImageRect( imageDirectory2.."OldPassTextField.png", _W/1.08, _H/13.33 )
        f_NameBg.x = _W/2
        f_NameBg.y = _H/26 + _H/26 + _H/27.42 + _H/19.2
        sceneGroup:insert( f_NameBg )
        
        f_NameTf = native.newTextField( f_NameBg.x, f_NameBg.y, f_NameBg.width - textFieldWidth, f_NameBg.height - textFieldHeight )
		f_NameTf.hasBackground = false
		--f_NameTf.isSecure = true
		f_NameTf.placeholder = "Name"
		f_NameTf:addEventListener( "userInput", onFirstNameEdit )
		f_NameTf.font = native.newFont( _FontArr[10], _H/28 )
		sceneGroup:insert( f_NameTf )
		
		l_NameBg = display.newImageRect( imageDirectory2.."NewPassTextField.png", _W/1.08, _H/13.33 )
        l_NameBg.x = _W/2
        l_NameBg.y = f_NameBg.y + f_NameBg.height
        sceneGroup:insert( l_NameBg )
        
        l_NameTf = native.newTextField( l_NameBg.x, l_NameBg.y, l_NameBg.width - textFieldWidth, l_NameBg.height - textFieldHeight )
		l_NameTf.hasBackground = false
		--l_NameTf.isSecure = true
		l_NameTf.placeholder = "Last Name"
		l_NameTf:addEventListener( "userInput", onLastNameEdit )
		l_NameTf.font = native.newFont( _FontArr[10], _H/28 )
		sceneGroup:insert( l_NameTf )
		
		mobileNoBg = display.newImageRect( imageDirectory2.."rePassTextField.png", _W/1.08, _H/13.33 )
        mobileNoBg.x = _W/2
        mobileNoBg.y = l_NameBg.y + l_NameBg.height
        sceneGroup:insert( mobileNoBg )
        
        mobileNoTf = native.newTextField( mobileNoBg.x, mobileNoBg.y, mobileNoBg.width - textFieldWidth, mobileNoBg.height - textFieldHeight )
		mobileNoTf.hasBackground = false
		--mobileNoTf.isSecure = true
		mobileNoTf.inputType = "phone"
		mobileNoTf:setReturnKey( "done" )
		mobileNoTf.placeholder = "Mobile Number"
		mobileNoTf:addEventListener( "userInput", onMobileNoEdit )
		mobileNoTf.font = native.newFont( _FontArr[10], _H/28 )
		sceneGroup:insert( mobileNoTf )
        
        alleregyBg = display.newImageRect( imageDirectory2.."rePassTextField.png", _W/1.08, _H/6.66 )
        alleregyBg.x = _W/2
        alleregyBg.y = mobileNoBg.y + mobileNoBg.height/2 + alleregyBg.height/2
        sceneGroup:insert( alleregyBg )
        
        alleregyTf = native.newTextBox( alleregyBg.x, alleregyBg.y, alleregyBg.width - textFieldWidth, alleregyBg.height - textFieldHeight )
		alleregyTf.hasBackground = false
		alleregyTf.isEditable = true
		alleregyTf:setReturnKey( "done" )
		alleregyTf.placeholder = "Allergies"
		alleregyTf:addEventListener( "userInput", onAlleregyEdit )
		alleregyTf.font = native.newFont( _FontArr[10], _H/28 )
		sceneGroup:insert( alleregyTf )
        
        
        if(_StripeCustomerID) then
			 updateAccount = display.newText( "Update Stripe Account", alleregyBg.x + alleregyBg.width/2, alleregyBg.y + alleregyBg.height/2 + _H/38.4, _FontArr[6], _H/32 )
			 updateAccount.anchorX = 1
			 updateAccount.anchorY = 0
    		 updateAccount:setFillColor( 206/255 ,23/255 ,100/255 )
    		 sceneGroup:insert( updateAccount )
        
    		 updateAccountBg = display.newRect( updateAccount.x, updateAccount.y, updateAccount.width + _W/36, updateAccount.height + _H/96 )
    		 updateAccountBg.anchorX = 1
    		 updateAccountBg.anchorY = 0
    		 updateAccountBg:setFillColor( 0, 0, 0, 0.01 )
    		 updateAccountBg:addEventListener( "tap", handleUpdateStripeAccountEvent )
    		 sceneGroup:insert( updateAccountBg )    
    
    		 updateAccountBg:toFront()
		else
			 updateAccount = display.newText( "Create Stripe Account", alleregyBg.x + alleregyBg.width/2, alleregyBg.y + alleregyBg.height/2 + _H/38.4, _FontArr[6], _H/32 )
			 updateAccount.anchorX = 1
			 updateAccount.anchorY = 0
    		 updateAccount:setFillColor( 206/255 ,23/255 ,100/255 )
    		 sceneGroup:insert( updateAccount )
        
    		 updateAccountBg = display.newRect( updateAccount.x, updateAccount.y, updateAccount.width + _W/36, updateAccount.height + _H/96 )
    		 updateAccountBg.anchorX = 1
    		 updateAccountBg.anchorY = 0
    		 updateAccountBg:setFillColor( 0, 0, 0, 0.01 )
    		 updateAccountBg:addEventListener( "tap", handleAddStripeAccountEvent )
    		 sceneGroup:insert( updateAccountBg )    
    
    		 updateAccountBg:toFront()
		end
        
        
        saveChangesBtn = widget.newButton
		{
    		width = _W/1.08,
    		height = _H/16.27,
    		defaultFile = imageDirectory2.."Submit_Btn.png",
   			overFile = imageDirectory2.."Submit_Btn.png",
    		label = "SAVE",
    		labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
    		labelYOffset = _H/275,
    		fontSize = _H/30,
    		font = _FontArr[6],
    		id = "save",
    		onEvent = handleButtonEvent
		}
		saveChangesBtn.x = _W/2
		saveChangesBtn.y = updateAccount.y + updateAccount.height/2 + saveChangesBtn.height/2 + _H/19.2
		sceneGroup:insert( saveChangesBtn )
        saveChangesBtn:setEnabled( false )
        
        
        local ifFbLogin = loadData( "fb" )
		local ifGoogleLogin = loadData( "google" )
		if(ifFbLogin == "1" or ifGoogleLogin == "1") then
         
         	local headers = {}
							
			headers["Content-Type"] = "application/x-www-form-urlencoded"
			headers["Accept-Language"] = "en-US"
							
			local body = "first_name=".._fName.."&last_name=".._lName.."&email=".._UserName.."&connect=fb"
			local params = {}
			params.headers = headers
			params.body = body
							
			local url = _WebLink.."fb-g-connect.php?"
			print( url..body )
			getUserSocialInfoRequest = network.request( url, "POST", SignInNetworkListener, params )
			native.setActivityIndicator( true )
		
		else
		
        local headers = {}
			
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
			
			
		local body = "ws=1&email=".._UserName.."&password=".._Password
		local params = {}
		params.headers = headers
		params.body = body
			
		local url = _WebLink.."login.php?"
		print( url..body )
		getUserInfoRequest = network.request( url, "POST", SignInNetworkListener, params )
		native.setActivityIndicator( true )
        
        end
        
        local function onActivateBtn( event )
        	if(composer.getSceneName("current") == "editProfile") then
        		
        		saveChangesBtn:setEnabled( true )
        		
        	end
        	return true
        end
        timer.performWithDelay(500,onActivateBtn,1)
        
       
        
        
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
        
        display.remove( saveChangesBtn )
        saveChangesBtn = nil
        
        display.remove( f_NameBg )
        f_NameBg = nil
        
        display.remove( f_NameTf )
        f_NameTf = nil
        
        display.remove( l_NameBg )
        l_NameBg = nil
        
        display.remove( l_NameTf )
        l_NameTf = nil
        
        display.remove( mobileNoBg )
        mobileNoBg = nil
        
        display.remove( mobileNoTf )
        mobileNoTf = nil
        
        display.remove( alleregyBg )
        alleregyBg = nil
        
        display.remove( alleregyTf )
        alleregyTf = nil
        
        display.remove(updateAccount)
        updateAccount = nil
        
        display.remove(updateAccountBg)
        updateAccountBg = nil
        
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
        if(getUserInfoRequest) then
        	network.cancel( getUserInfoRequest )
        	getUserInfoRequest = nil
        end
        
        if(getUserSocialInfoRequest) then
        	network.cancel( getUserSocialInfoRequest )
        	getUserSocialInfoRequest = nil
        end
        
        if(editProfileRequest) then
        	network.cancel( editProfileRequest )
        	editProfileRequest = nil
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