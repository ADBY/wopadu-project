local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


local imageDirectory = "images/SignUp/"
local imageDirectory2 = "images/ChangePassword/"

local changePasswordGroup,changePassRequest,heading
local title, title2, savePswdBtn, oldPswdBg, oldPswdTf, newPswdBg, newPswdTf, retypePswdBg, retypePswdTf
local textFieldWidth = _W/32
local textFieldHeight = _H/64
local networkReqCount = 0



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
	_Password = newPswdTf.text
	storeData( "Password", newPswdTf.text )
	
	oldPswdTf.text = ""
	newPswdTf.text = ""
	retypePswdTf.text = ""

	composer.gotoScene( "Setting" )
	
	return true
end

local function handleOk2( event )
	oldPswdTf.text = ""
	
	return true
end

local function handleOk3( event )
	newPswdTf.text = ""
	retypePswdTf.text = ""
	
	return true
end

local function onOldPswdEdit( event )
	if ( event.phase == "began" ) then
	
    elseif ( event.phase == "ended" ) then
        print( event.target.text )
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then
	
    end

	return true
end

local function onNewPswdEdit( event )
	if ( event.phase == "began" ) then
	
    elseif ( event.phase == "ended" ) then
        print( event.target.text )
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then
	
    end

	return true
end

local function onRetypePswdEdit( event )
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
	
		composer.gotoScene( "Setting" )
	
	return true
end

local function handleBackButtonEventTouch( event )
	if event.phase == "ended" then
		composer.gotoScene( "Setting" )
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

local function changePswdListNetworkListener( event )
	
	if ( event.isError ) then
        print( "Network error!" )
        
        networkReqCount = networkReqCount + networkReqCount
        
        
    	native.setActivityIndicator( false )
		
		
		if( networkReqCount > 3 ) then
		
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		else
		
			local oldPswdTfValue = oldPswdTf.text:gsub( "&", "%%26" )
			local newPswdTfValue = newPswdTf.text:gsub( "&", "%%26" )
			local retypePswdTfValue = retypePswdTf.text:gsub( "&", "%%26" )
			
			local url = _WebLink.."password-change.php?ws=1&user_id=".._UserID.."&c_password="..oldPswdTfValue.."&n_password="..newPswdTfValue.."&r_password="..retypePswdTfValue
			local url2 = url:gsub(" ", "%%20")
			changePassRequest = network.request( url2, "GET", changePswdListNetworkListener )
			native.setActivityIndicator( true )
			
		end
    else
        print ( "RESPONSE:" .. event.response )
        
        local changePswdList = json.decode(event.response)

		if( changePswdList == 0 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( changePswdList == 1 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( changePswdList == 2 ) then 
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Password3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk2 )
        	
        elseif( changePswdList == 3 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Password4Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk2 )

        elseif( changePswdList == 4 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Password5Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk3 )
        	
        elseif( changePswdList == 5 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( changePswdList == 6 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Password3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk2 )
        	
        elseif( changePswdList == 7 ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif event.response == "OK" then
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("Password6Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk )
        	
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
			
			local oldPswdTfValue = oldPswdTf.text:gsub( "&", "%%26" )
			local newPswdTfValue = newPswdTf.text:gsub( "&", "%%26" )
			local retypePswdTfValue = retypePswdTf.text:gsub( "&", "%%26" )
			
			--[[local headers = {}
			
			headers["Content-Type"] = "application/x-www-form-urlencoded"
			headers["Accept-Language"] = "en-US"
			
			
			
			local body = "ws=1&user_id=".._UserID.."&c_password="..oldPswdTfValue.."&n_password="..newPswdTfValue.."&r_password="..retypePswdTfValue
			local params = {}
			params.headers = headers
			params.body = body
			
			local url = _WebLink.."password-change.php?"
			print( url..body )
			changePassRequest = network.request( url, "POST", changePswdListNetworkListener, params )
			]]--
			
			local url = _WebLink.."password-change.php?ws=1&user_id=".._UserID.."&c_password="..oldPswdTfValue.."&n_password="..newPswdTfValue.."&r_password="..retypePswdTfValue
			local url2 = url:gsub(" ", "%%20")
			changePassRequest = network.request( url2, "GET", changePswdListNetworkListener )
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
        
        heading = display.newText( GBCLanguageCabinet.getText("ChangePasswordLabel",_LanguageKey), header.x, header.y, _FontArr[6], _H/30 )
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
        
        heading.text = GBCLanguageCabinet.getText("ChangePasswordLabel",_LanguageKey)
        networkReqCount = 0
        
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        
        _passwordPreviousScene = composer.getSceneName( "current" )
        print( "In change Password screen123....." )
        changePasswordGroup = display.newGroup()
        sceneGroup:insert(changePasswordGroup)
        
        
        title = display.newText( GBCLanguageCabinet.getText("ChangePasswordLabel",_LanguageKey)..",", _W/2.8, _H/26 + _H/26 + _H/27.42, _FontArr[6], _H/35 )
        title:setFillColor( 83/255, 80/255, 79/255 )
        changePasswordGroup:insert( title )
        
        title2 = display.newText( " "..tostring(GBCLanguageCabinet.getText("ForgotPasswordLabel",_LanguageKey)).."?", title.x + title.width/2 + _W/360, title.y, _FontArr[6], _H/35 )
        title2.anchorX = 0
        title2:setFillColor( 206/255, 23/255, 100/255 )
        changePasswordGroup:insert( title2 )
        
        title2Bg = display.newRect( title2.x + title2.width/2 , title2.y, title2.width + _W/21.6, title2.height + _H/38.4 )
        title2Bg:setFillColor( 0, 0, 0, 0.01 )
        title2Bg:addEventListener( "tap", handleForgotPswdEvent)
        title2Bg:addEventListener( "touch", handleForgotPswdEventTouch)
        changePasswordGroup:insert( title2Bg )
        
        oldPswdBg = display.newImageRect( imageDirectory2.."OldPassTextField.png", _W/1.08, _H/13.33 )
        oldPswdBg.x = _W/2
        oldPswdBg.y = title.y + title.height + _H/19.2
        changePasswordGroup:insert( oldPswdBg )
        
        oldPswdTf = native.newTextField( oldPswdBg.x, oldPswdBg.y, oldPswdBg.width - textFieldWidth, oldPswdBg.height - textFieldHeight )
		oldPswdTf.hasBackground = false
		oldPswdTf.isSecure = true
		oldPswdTf.placeholder = GBCLanguageCabinet.getText("OldPasswordLabel",_LanguageKey)
		oldPswdTf:addEventListener( "userInput", onOldPswdEdit )
		oldPswdTf.font = native.newFont( _FontArr[10], _H/28 )
		changePasswordGroup:insert( oldPswdTf )
		
		newPswdBg = display.newImageRect( imageDirectory2.."NewPassTextField.png", _W/1.08, _H/13.33 )
        newPswdBg.x = _W/2
        newPswdBg.y = oldPswdBg.y + oldPswdBg.height
        changePasswordGroup:insert( newPswdBg )
        
        newPswdTf = native.newTextField( newPswdBg.x, newPswdBg.y, newPswdBg.width - textFieldWidth, newPswdBg.height - textFieldHeight )
		newPswdTf.hasBackground = false
		newPswdTf.isSecure = true
		newPswdTf.placeholder = GBCLanguageCabinet.getText("NewPasswordLabel",_LanguageKey)
		newPswdTf:addEventListener( "userInput", onNewPswdEdit )
		newPswdTf.font = native.newFont( _FontArr[10], _H/28 )
		changePasswordGroup:insert( newPswdTf )
		
		retypePswdBg = display.newImageRect( imageDirectory2.."rePassTextField.png", _W/1.08, _H/13.33 )
        retypePswdBg.x = _W/2
        retypePswdBg.y = newPswdBg.y + newPswdBg.height
        changePasswordGroup:insert( retypePswdBg )
        
        retypePswdTf = native.newTextField( retypePswdBg.x, retypePswdBg.y, retypePswdBg.width - textFieldWidth, retypePswdBg.height - textFieldHeight )
		retypePswdTf.hasBackground = false
		retypePswdTf.isSecure = true
		retypePswdTf.placeholder = GBCLanguageCabinet.getText("RetypePasswordLabel",_LanguageKey)
		retypePswdTf:addEventListener( "userInput", onRetypePswdEdit )
		retypePswdTf.font = native.newFont( _FontArr[10], _H/28 )
		changePasswordGroup:insert( retypePswdTf )
        
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
		changePasswordGroup:insert( savePswdBtn )
        
        
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
        
        display.remove(title2Bg)
        title2Bg = nil
        
        display.remove( savePswdBtn )
        savePswdBtn = nil
        
        display.remove( oldPswdBg )
        oldPswdBg = nil
        
        display.remove( oldPswdTf )
        oldPswdTf = nil
        
        display.remove( newPswdBg )
        newPswdBg = nil
        
        display.remove( newPswdTf )
        newPswdTf = nil
        
        display.remove( retypePswdBg )
        retypePswdBg = nil
        
        display.remove( retypePswdTf )
        retypePswdTf = nil
        
        display.remove(changePasswordGroup)
        changePasswordGroup = nil
        
        
        
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