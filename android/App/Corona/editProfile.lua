local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


local imageDirectory = "images/SignUp/"
local imageDirectory2 = "images/ChangePassword/"

local title, title2, saveChangesBtn, f_NameBg, f_NameTf, l_NameBg, l_NameTf, mobileNoBg, mobileNoTf,heading
local getUserSocialInfoRequest,getUserInfoRequest,editProfileRequest
local textFieldWidth = _W/32
local textFieldHeight = _H/64
local networkReqCount1,networkReqCount2,networkReqCount3

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
        
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then
	
    end

	return true
end

local function onLastNameEdit( event )
	if ( event.phase == "began" ) then
	
    elseif ( event.phase == "ended" ) then
        
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then
	
    end

	return true
end

local function onMobileNoEdit( event )
	if ( event.phase == "began" ) then
	
    elseif ( event.phase == "ended" ) then
        
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then
	
    end

	return true
end

local function onAlleregyEdit( event )
	if ( event.phase == "began" ) then
	
    elseif ( event.phase == "ended" ) then
        
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( nil )

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
        
        networkReqCount1 = networkReqCount1 + 1
        
    	native.setActivityIndicator( false )
		
		if( networkReqCount1 > 3 ) then
		
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		else
		
			local f_NameTfValue = f_NameTf.text:gsub( "&", "%%26" )
			local l_NameTfValue = l_NameTf.text:gsub( "&", "%%26" )
			local mobileNoTfValue = mobileNoTf.text:gsub( "&", "%%26" )
			local alleregyTfTfValue = alleregyTf.text:gsub( "&", "%%26" )
			
			local url = _WebLink.."profile-edit.php?ws=1&user_id=".._UserID.."&first_name="..f_NameTfValue.."&last_name="..l_NameTfValue.."&mobile="..mobileNoTfValue.."&allergies="..alleregyTfTfValue
			local url2 = url:gsub(" ", "%%20")
			editProfileRequest = network.request( url2, "GET", EditProfileNetworkListener )
			native.setActivityIndicator( true )
			
			
		end
		
		
    else
        
        local changePswdList = json.decode(event.response)

		if( changePswdList == 0 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( changePswdList == 1 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( changePswdList == 2 ) then
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk2 )
        	
        elseif( changePswdList == 4 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk3 )
        	
        elseif( changePswdList == 5 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( changePswdList == 6 ) then 
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("User1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( changePswdList == 7 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        else
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Account1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk )
        	
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
			-- Access Google over SSL:
			
			local f_NameTfValue = f_NameTf.text:gsub( "&", "%%26" )
			local l_NameTfValue = l_NameTf.text:gsub( "&", "%%26" )
			local mobileNoTfValue = mobileNoTf.text:gsub( "&", "%%26" )
			local alleregyTfTfValue = alleregyTf.text:gsub( "&", "%%26" )
			
			local url = _WebLink.."profile-edit.php?ws=1&user_id=".._UserID.."&first_name="..f_NameTfValue.."&last_name="..l_NameTfValue.."&mobile="..mobileNoTfValue.."&allergies="..alleregyTfTfValue
			local url2 = url:gsub(" ", "%%20")
			editProfileRequest = network.request( url2, "GET", EditProfileNetworkListener )
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
        
        
        networkReqCount2 = networkReqCount2 + 1
        
    	native.setActivityIndicator( false )
		
		if( networkReqCount2 > 3 ) then
		
			local alert = native.showAlert( alertLabel, NetworkErrorMsg, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		else
			
			local url = _WebLink.."login.php?ws=1&email=".._UserName.."&password=".._Password
			local url2 = url:gsub(" ", "%%20")
			getUserInfoRequest = network.request( url, "GET", SignInNetworkListener )
			native.setActivityIndicator( true )
			
		end
    else
        
        local signInList = json.decode(event.response)
        
        if( signInList == 0 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
        	
        elseif( signInList == 1 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
        
        elseif( signInList == 2 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
        	
        elseif( signInList == 3 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
		
        elseif( signInList == 4 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
        	
        elseif( signInList == 5 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
        	
        elseif( signInList == 6 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
        	
        elseif( signInList == 7 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Account2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
        	
        elseif( signInList == 8 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Account3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
        	
        else
        	
        	f_NameTf.text = signInList.first_name
        	mobileNoTf.text = signInList.mobile
        	l_NameTf.text = signInList.last_name
        	
        	if signInList.allergies == "" or signInList.allergies == " " or signInList.allergies == nil then
        		alleregyTf.text = nil
        	else
        		alleregyTf.text = signInList.allergies
        	end
        	
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
        
        heading = display.newText( GBCLanguageCabinet.getText("editAccountLabel",_LanguageKey), header.x, header.y, _FontArr[6], _H/30 )
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
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        
        heading.text = GBCLanguageCabinet.getText("editAccountLabel",_LanguageKey)
                
        networkReqCount1 = 0
        networkReqCount2 = 0
        networkReqCount3 = 0
        
        f_NameBg = display.newImageRect( imageDirectory2.."OldPassTextField.png", _W/1.08, _H/13.33 )
        f_NameBg.x = _W/2
        f_NameBg.y = _H/26 + _H/26 + _H/27.42 + _H/19.2
        sceneGroup:insert( f_NameBg )
        
        f_NameTf = native.newTextField( f_NameBg.x, f_NameBg.y, f_NameBg.width - textFieldWidth, f_NameBg.height - textFieldHeight )
		f_NameTf.hasBackground = false
		f_NameTf.placeholder = GBCLanguageCabinet.getText("firstNameLabel",_LanguageKey)
		f_NameTf:addEventListener( "userInput", onFirstNameEdit )
		f_NameTf.font = native.newFont( _FontArr[10], _H/28 )
		sceneGroup:insert( f_NameTf )
		
		l_NameBg = display.newImageRect( imageDirectory2.."NewPassTextField.png", _W/1.08, _H/13.33 )
        l_NameBg.x = _W/2
        l_NameBg.y = f_NameBg.y + f_NameBg.height
        sceneGroup:insert( l_NameBg )
        
        l_NameTf = native.newTextField( l_NameBg.x, l_NameBg.y, l_NameBg.width - textFieldWidth, l_NameBg.height - textFieldHeight )
		l_NameTf.hasBackground = false
		l_NameTf.placeholder = GBCLanguageCabinet.getText("lastNameLabel",_LanguageKey)
		l_NameTf:addEventListener( "userInput", onLastNameEdit )
		l_NameTf.font = native.newFont( _FontArr[10], _H/28 )
		sceneGroup:insert( l_NameTf )
		
		mobileNoBg = display.newImageRect( imageDirectory2.."rePassTextField.png", _W/1.08, _H/13.33 )
        mobileNoBg.x = _W/2
        mobileNoBg.y = l_NameBg.y + l_NameBg.height
        sceneGroup:insert( mobileNoBg )
        
        mobileNoTf = native.newTextField( mobileNoBg.x, mobileNoBg.y, mobileNoBg.width - textFieldWidth, mobileNoBg.height - textFieldHeight )
		mobileNoTf.hasBackground = false
		mobileNoTf.inputType = "phone"
		mobileNoTf:setReturnKey( "done" )
		mobileNoTf.placeholder = GBCLanguageCabinet.getText("mobileNoLabel",_LanguageKey)
		mobileNoTf:addEventListener( "userInput", onMobileNoEdit )
		mobileNoTf.font = native.newFont( _FontArr[10], _H/28 )
		sceneGroup:insert( mobileNoTf )
        
        alleregyBg = display.newImageRect( imageDirectory2.."rePassTextField.png", _W/1.08, _H/6.66 )
        alleregyBg.x = _W/2
        alleregyBg.y = mobileNoBg.y + mobileNoBg.height/2 + alleregyBg.height/2
        sceneGroup:insert( alleregyBg )
        
        alleregyTf = native.newTextBox( alleregyBg.x, alleregyBg.y, alleregyBg.width - textFieldWidth, alleregyBg.height - textFieldHeight )
		alleregyTf.hasBackground = false
		alleregyTf:setReturnKey( "done" )
		alleregyTf.isEditable = true
		alleregyTf.placeholder = GBCLanguageCabinet.getText("allergiesLabel",_LanguageKey)
		alleregyTf:addEventListener( "userInput", onAlleregyEdit )
		alleregyTf.font = native.newFont( _FontArr[10], _H/28 )
		sceneGroup:insert( alleregyTf )
        
        if(_StripeCustomerID) then
			 updateAccount = display.newText( GBCLanguageCabinet.getText("updateCreditCardLabel",_LanguageKey), alleregyBg.x + alleregyBg.width/2, alleregyBg.y + alleregyBg.height/2 + _H/38.4, _FontArr[6], _H/32 )
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
			 updateAccount = display.newText( GBCLanguageCabinet.getText("updateCreditCardLabel",_LanguageKey), alleregyBg.x + alleregyBg.width/2, alleregyBg.y + alleregyBg.height/2 + _H/38.4, _FontArr[6], _H/32 )
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
    		defaultFile = imageDirectory2.."Submit_Btn3.png",
   			overFile = imageDirectory2.."Submit_Btn3.png",
    		label = GBCLanguageCabinet.getText("saveLabel",_LanguageKey),
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
		local ifTwitterLogin = loadData( "twitter" )
		
		if(ifFbLogin == "1") then
         	
			local url = _WebLink.."fb-g-connect.php?first_name=".._fName.."&last_name=".._lName.."&email=".._UserName.."&connect=fb"
			local url2 = url:gsub(" ", "%%20")
			getUserSocialInfoRequest = network.request( url, "GET", SignInNetworkListener )
			native.setActivityIndicator( true )
		
		elseif (ifTwitterLogin == "1") then
			
			local url = _WebLink.."fb-g-connect.php?first_name=".._fName.."&last_name=".._lName.."&email=".._UserName.."&connect=t"
			local url2 = url:gsub(" ", "%%20")
			getUserSocialInfoRequest = network.request( url, "GET", SignInNetworkListener )
			native.setActivityIndicator( true )
			
		else
			
			local url = _WebLink.."login.php?ws=1&email=".._UserName.."&password=".._Password
			local url2 = url:gsub(" ", "%%20")
			getUserInfoRequest = network.request( url, "GET", SignInNetworkListener )
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