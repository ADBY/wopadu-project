local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

local parent,shareGroup,notesScrollView,notes,param
local whiteBg,popUpBg,logo,Background1,emailBg,emailTf
local textFieldWidth = _W/32 
local textFieldHeight = _H/64
local shareRequest,networkReqCount

local ImageDirectory = "images/PopUp/"
local imageDirectory2 = "images/Login/"

local function onBgTouch( event )
	if( event.phase == "ended" ) then
	
		composer.gotoScene( composer.getSceneName( "previous" ) )
		
	end
	return true
end

local function onBgTap( event )
	
	composer.gotoScene( composer.getSceneName( "previous" ) )
	return true
end

local function onPopUpTap( event )

	return true
end

local function onPopUpTouch( event )
	
	return true
end

local function onEmailEdit( event )
	if ( event.phase == "began" ) then

    elseif ( event.phase == "ended" ) then
    	native.setKeyboardFocus( nil )
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then
        
    end

	return true
end

local function onDoNothing()

	return true
end

local function onHandle1()
	emailTf.text = ""
	
	return true
end

local function onComplete( event )

	composer.gotoScene( composer.getSceneName( "previous" ) )
	
	return true
end

local function shareWopadoNetworkListener( event )
	if ( event.isError ) then
        networkReqCount = networkReqCount + 1
        
    	native.setActivityIndicator( false )
		
		if( networkReqCount > 3 ) then
		
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		else
		
			local url = _WebLink.."share-app.php?user_id=".._UserID.."&email="..emailTf.text.."&desc="
			local url2 = url:gsub( " ", "%%20" )
			shareRequest = network.request( url2, "GET", shareWopadoNetworkListener )
			native.setActivityIndicator( true )
		
		end
    else
        
        local googleSignInList = json.decode(event.response)
        
        if( event.response == 0 or event.response == "0") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 1 or event.response == "1") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 2 or event.response == "2") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end ) 
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Email2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onHandle1 )
        	
        elseif( event.response == 3 or event.response == "3") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 4 or event.response == "4") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("User1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing ) 
        	
        elseif( event.response == 5 or event.response == "5") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Email8Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing ) 
        else
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end ) 
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Email10Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onComplete ) 
        	
        end

	end
	return true
end

local function handleButtonEvent( event )
	if( event.phase == "ended" ) then
		local url = _WebLink.."share-app.php?user_id=".._UserID.."&email="..emailTf.text.."&desc="
		local url2 = url:gsub( " ", "%%20" )
		shareRequest = network.request( url2, "GET", shareWopadoNetworkListener )
		native.setActivityIndicator( true )
		
	end
	return true
end


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   
   
    
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
	parent = event.parent
	
    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
        shareGroup = display.newGroup()
        sceneGroup:insert(shareGroup)
        networkReqCount = 0
        
    whiteBg = display.newImageRect( "images/Login/White_Background.png", _W, _H )
    whiteBg.x = _W/2
    whiteBg.y = _H/2
    shareGroup:insert( whiteBg )
    
    Background1 = display.newImageRect(ImageDirectory.."Background.png",_W,_H)
    Background1.x = _W/2
    Background1.y = _H/2
    Background1:addEventListener("touch",onBgTouch)
    Background1:addEventListener("tap",onBgTap)
    shareGroup:insert(Background1)
    
    popUpBg = display.newImageRect(ImageDirectory.."PopUpBg.png",_W/1.15,_H/2.70)
    popUpBg.x = _W/2
    popUpBg.y = _H/3.07 + popUpBg.height/2
    popUpBg:addEventListener("touch",onPopUpTouch)
    popUpBg:addEventListener("tap",onPopUpTap)
    shareGroup:insert(popUpBg)
    
    logo = display.newImageRect("images/Wopadu_Logo.png",_W/5.83,_H/10.37)
    logo.x = popUpBg.x
    logo.y = popUpBg.y - popUpBg.height/2.15	
    shareGroup:insert(logo)
        
        
        emailBg = display.newImageRect( imageDirectory2.."Email_Bg.png", popUpBg.width - _W/8, _H/13.33 )
        emailBg.x = _W/2.01
        emailBg.y = _H/2.2
        shareGroup:insert( emailBg )
        
        emailTf = native.newTextField( emailBg.x, emailBg.y, emailBg.width - textFieldWidth, emailBg.height - textFieldHeight )
		emailTf.hasBackground = false
		emailTf.inputType = "email"
		emailTf.placeholder = GBCLanguageCabinet.getText("EmailLabel",_LanguageKey) 
		emailTf:addEventListener( "userInput", onEmailEdit )
		emailTf.font = native.newFont( _FontArr[10], _H/28 )
		shareGroup:insert( emailTf )
		
		shareBtn = widget.newButton
		{
    		width = emailBg.width,
    		height = _H/16.27,
    		defaultFile = imageDirectory2.."SinIn_Btn2.png",
   			overFile = imageDirectory2.."SinIn_Btn2.png",
    		label = GBCLanguageCabinet.getText("SubmitLabel",_LanguageKey),
    		labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
    		labelYOffset = _H/275,
    		fontSize = _H/30,
    		font = _FontArr[6],
    		id = "1",
    		onEvent = handleButtonEvent
		}
		shareBtn.x = _W/2
		shareBtn.y = emailBg.y + emailBg.height + shareBtn.height/2
		shareGroup:insert( shareBtn )	
		
        
        

      
        
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
        
        
        display.remove(emailBg)
    	emailBg = nil 
        
        display.remove(emailTf)
        emailTf = nil
        
        display.remove(whiteBg)
        whiteBg = nil
        
        display.remove(popUpBg)
        popUpBg = nil
        
        display.remove(logo)
        logo = nil
        
        display.remove(Background)
        Background = nil
        
        display.remove(shareBtn)
        shareBtn = nil
    
        display.remove(shareGroup)
        shareGroup = nil
        
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
        if(shareRequest) then
        	network.cancel( shareRequest )
        	shareRequest = nil
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