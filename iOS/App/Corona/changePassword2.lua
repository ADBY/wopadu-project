local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


local imageDirectory = "images/SignUp/"
local imageDirectory2 = "images/ChangePassword/"

local title, savePswdBtn, verificationCodeBg, verificationCodeTf, newPswdBg, newPswdTf, retypePswdBg, retypePswdTf, param
local changePassRequest, heading
local textFieldWidth = _W/32
local textFieldHeight = _H/64


local function onDoNothing( event )

	return true
end

local function storeData(name,data)
	local saveData = data
	local path = system.pathForFile( name, system.DocumentsDirectory )
	local file = io.open( path, "w" )
	file:write( saveData )
	io.close( file )
	file = nil
end

local function handleOk2( event )
	newPswdTf.text = ""
	retypePswdTf.text = ""

	return true
end

local function handleOk3( event )
	newPswdTf.text = ""
	retypePswdTf.text = ""
	verificationCodeTf.text = ""

	return true
end

local function handleOk4( event )
	verificationCodeTf.text = ""
	
	return true
end

local function handleOk( event )
	_Password = newPswdTf.text
	storeData( "Password", newPswdTf.text )
	
	newPswdTf.text = ""
	retypePswdTf.text = ""
	verificationCodeTf.text = ""
	composer.gotoScene( "login" )

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

local function onNewPswdEdit( event )
	if ( event.phase == "began" ) then
	
    elseif ( event.phase == "ended" ) then
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then
	
    end

	return true
end

local function onRetypePswdEdit( event )
	if ( event.phase == "began" ) then
	
    elseif ( event.phase == "ended" ) then
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then
	
    end

	return true
end

local function handleBackButtonEvent( event )
	composer.gotoScene( "forgotPassword" )
	
	return true
end

local function handleBackButtonEventTouch( event )
	if event.phase == "ended" then
		composer.gotoScene( "forgotPassword" )
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

local function changePswdListNetworkListener( event )

	if ( event.isError ) then
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
    else
        
        local changePswdList = json.decode(event.response)
		
		if( changePswdList == 0 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( changePswdList == 1 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( changePswdList == 2 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Password4Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk2 )
        	
        elseif( changePswdList == 3 ) then 
        	local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("Password5Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk2 )

        elseif( changePswdList == 4 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( changePswdList == 5 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Email4Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk3 )
        	
        elseif( changePswdList == 6 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("4Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk4 )
        	
        elseif( changePswdList == 7 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("5Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk4 )
        	
        elseif( changePswdList == 8 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif event.response == "OK" then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Password6Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk )
        	
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
			
			local headers = {}
			
			headers["Content-Type"] = "application/x-www-form-urlencoded"
			headers["Accept-Language"] = "en-US"
			
			local verificationCodeTfValue = verificationCodeTf.text:gsub( "&", "%%26" )
			local newPswdTfValue = newPswdTf.text:gsub( "&", "%%26" )
			local retypePswdTfValue = retypePswdTf.text:gsub( "&", "%%26" )
			
			local body = "ws=1&step=2&email="..param.emailForChangePswd.."&verif_code="..verificationCodeTfValue.."&n_password="..newPswdTfValue.."&r_password="..retypePswdTfValue
			local params = {}
			params.headers = headers
			params.body = body
			
			local url = _WebLink.."password-forgot.php?"
			changePassRequest = network.request( url, "POST", changePswdListNetworkListener, params )
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
        
        heading = display.newText( GBCLanguageCabinet.getText("savePasswordLabel",_LanguageKey), header.x, header.y, _FontArr[6], _H/30 )
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
    param = event.params

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
                
        heading.text = GBCLanguageCabinet.getText("savePasswordLabel",_LanguageKey)
        
        title = display.newText(  GBCLanguageCabinet.getText("SaveYourPasswordLabel",_LanguageKey), _W/2, _H/26 + _H/26 + _H/27.42, _FontArr[6], _H/35 )
        title:setFillColor( 83/255, 80/255, 79/255 )
        sceneGroup:insert( title )
        
        verificationCodeBg = display.newImageRect( imageDirectory2.."OldPassTextField.png", _W/1.08, _H/15.11 )
        verificationCodeBg.x = title.x
        verificationCodeBg.y = title.y + title.height + _H/19.2
        sceneGroup:insert( verificationCodeBg )
        
        verificationCodeTf = native.newTextField( verificationCodeBg.x, verificationCodeBg.y, verificationCodeBg.width - textFieldWidth, verificationCodeBg.height - textFieldHeight )
		verificationCodeTf.hasBackground = false
		verificationCodeTf.placeholder = GBCLanguageCabinet.getText("VerificationCodeLabel",_LanguageKey)
		verificationCodeTf:addEventListener( "userInput", onVerificationCodeEdit )
		verificationCodeTf.font = native.newFont( _FontArr[10], _H/28 )
		sceneGroup:insert( verificationCodeTf )
		
		newPswdBg = display.newImageRect( imageDirectory2.."NewPassTextField.png", _W/1.08, _H/15.11 )
        newPswdBg.x = title.x
        newPswdBg.y = verificationCodeBg.y + verificationCodeBg.height
        sceneGroup:insert( newPswdBg )
        
        newPswdTf = native.newTextField( newPswdBg.x, newPswdBg.y, newPswdBg.width - textFieldWidth, newPswdBg.height - textFieldHeight )
		newPswdTf.hasBackground = false
		newPswdTf.isSecure = true 
		newPswdTf.placeholder = GBCLanguageCabinet.getText("NewPasswordLabel",_LanguageKey)
		newPswdTf:addEventListener( "userInput", onNewPswdEdit )
		newPswdTf.font = native.newFont( _FontArr[10], _H/28 )
		sceneGroup:insert( newPswdTf )
		
		retypePswdBg = display.newImageRect( imageDirectory2.."rePassTextField.png", _W/1.08, _H/15.11 )
        retypePswdBg.x = title.x
        retypePswdBg.y = newPswdBg.y + newPswdBg.height
        sceneGroup:insert( retypePswdBg )
        
        retypePswdTf = native.newTextField( retypePswdBg.x, retypePswdBg.y, retypePswdBg.width - textFieldWidth, retypePswdBg.height - textFieldHeight )
		retypePswdTf.hasBackground = false
		retypePswdTf.isSecure = true
		retypePswdTf.placeholder = GBCLanguageCabinet.getText("RetypePasswordLabel",_LanguageKey)
		retypePswdTf:addEventListener( "userInput", onRetypePswdEdit )
		retypePswdTf.font = native.newFont( _FontArr[10], _H/28 )
		sceneGroup:insert( retypePswdTf )
        
        savePswdBtn = widget.newButton
		{
    		width = _W/1.08,
    		height = _H/16.27,
    		defaultFile = imageDirectory2.."Submit_Btn2.png",
   			overFile = imageDirectory2.."Submit_Btn2.png",
    		label = GBCLanguageCabinet.getText("saveLabel",_LanguageKey),
    		labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
    		labelYOffset = _H/275,
    		fontSize = _H/30,
    		font = _FontArr[6],
    		id = "save",
    		onEvent = handleButtonEvent
		}
		savePswdBtn.x = _W/2
		savePswdBtn.y = retypePswdBg.y + retypePswdBg.height/2 + savePswdBtn.height/2 + _H/19.2
		sceneGroup:insert( savePswdBtn )
		
        
        
        
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
        
        display.remove( savePswdBtn )
        savePswdBtn = nil
        
        display.remove( verificationCodeBg )
        verificationCodeBg = nil
        
        display.remove( verificationCodeTf )
        verificationCodeTf = nil
        
        display.remove( newPswdBg )
        newPswdBg = nil
        
        display.remove( newPswdTf )
        newPswdTf = nil
        
        display.remove( retypePswdBg )
        retypePswdBg = nil
        
        display.remove( retypePswdTf )
        retypePswdTf = nil
        
        
        
        
        
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
        if(changePassRequest) then
        	network.cancel( changePassRequest )
        	changePassRequest = nil
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