local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local forward references should go here

-- -------------------------------------------------------------------------------
local imageDirectory = "images/SignUp/"
local imageDirectory2 = "images/Setting/"
local backBtn,heading
local languageListGroup
local rectBg = { }
local title = { }

local function storeData(name,data)
	local saveData = data
	local path = system.pathForFile( name, system.DocumentsDirectory )
	local file = io.open( path, "w" )
	file:write( saveData )
	io.close( file )
	file = nil
end

local function handleBackButtonEvent( event )
	composer.gotoScene( composer.getSceneName("previous") )
	
	return true
end

local function onRectTap( event )
	_LanguageKey = event.target.id
	storeData( "Langauge", _LanguageKey )
	if( composer.getSceneName("previous") == "FrontPage" or composer.getSceneName("previous") == nil ) then
		composer.gotoScene("FrontPage")
	else
		composer.gotoScene("welcomeScreen")
	end
	return true
end



local function onRectTouch( event )
	if(event.phase == "began") then
		_LanguageKey = event.target.id
	storeData( "Langauge", _LanguageKey )
	if( composer.getSceneName("previous") == "FrontPage" or composer.getSceneName("previous") == nil ) then
		composer.gotoScene("FrontPage")
	else
		composer.gotoScene("welcomeScreen")
	end
	end
	return true
end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    
    	local background = display.newImageRect( imageDirectory.."Background.png", _W, _H )
        background.x = _W/2
        background.y = _H/2
        sceneGroup:insert( background )
        
        local header = display.newImageRect( imageDirectory.."f_Header.png", _W, _H/13.61 )
        header.x = _W/2
        header.y = _H/27
        sceneGroup:insert( header )
        
        heading = display.newText( GBCLanguageCabinet.getText("languageLabel", _LanguageKey), header.x, header.y, _FontArr[30], _H/36.76 )
        heading:setFillColor( 1 )
        sceneGroup:insert( heading )
      
		
	
    
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen)
        
        
        
        heading.text = GBCLanguageCabinet.getText("languageLabel", _LanguageKey)
        
    backBtn = widget.newButton
	{
    	width = _W/9,
    	height = _H/14.76,
    	defaultFile = imageDirectory.."Back_Btn2.png",
   		overFile = imageDirectory.."Back_Btn2.png",
    	id = "back",
	}
	backBtn.x = _W/13.5
	backBtn.y = heading.y
	backBtn:addEventListener("tap",handleBackButtonEvent)
	sceneGroup:insert( backBtn )
        
        
        languageListGroup = display.newGroup()
        sceneGroup:insert( languageListGroup )
         if( composer.getSceneName("previous") == "FrontPage" or composer.getSceneName("previous") == nil ) then
        	backBtn.isVisible = false
         else
         	backBtn.isVisible = true
         end
        
languageListScrollView = widget.newScrollView(
    {
        top = _H/13.61,
        left = 0,
        width = _W,
        height = _H - _H/9.18,
        scrollWidth = _W,
        scrollHeight = _H,
        horizontalScrollDisabled = true,
        listener = scrollListener
    }
)
languageListGroup:insert( languageListScrollView )    


local function onDoNothing()
	return true
end
	
		local function languageListNetworkListener( event )
		if ( event.isError ) then
    		native.setActivityIndicator( false )
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )

		else
			native.setActivityIndicator( false )
			if( event.response == "0" or event.response == 0 ) then
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )

			elseif( event.response == "1" or event.response == 1 ) then
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("13Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )

			else
			
				languageList = json.decode( event.response )
		
			rectBg = { }
			title = { }
			
			for i = 1, tonumber(#languageList + 1) do
		
				if( i == 1 ) then
				rectBg[i] = display.newImageRect(imageDirectory2.."RowBg.png",_W,_H/12.22)
				rectBg[i].x = _W/2
				rectBg[i].y =  ((i-1) * _H/12.20)
				rectBg[i].anchorY = 0
				rectBg[i].id = "en"
				rectBg[i]:addEventListener("tap",onRectTap)
				languageListScrollView:insert(rectBg[i])
			
				title[i] = display.newText("English",_W/54,rectBg[i].y + rectBg[i].height/2,_FontArr[6],_H/36.76)
				title[i]:setTextColor( 83/255 ,20/255 ,111/255) 
				title[i].anchorX = 0
				languageListScrollView:insert(title[i])
			else
		
				rectBg[i] = display.newImageRect(imageDirectory2.."RowBg.png",_W,_H/12.22)
				rectBg[i].x = _W/2
				rectBg[i].y =  ((i-1) * _H/12.20)
				rectBg[i].anchorY = 0
				rectBg[i].id = languageList[i-1].language_code
				rectBg[i]:addEventListener("tap",onRectTap)
				languageListScrollView:insert(rectBg[i])
			
				title[i] = display.newText(languageList[i-1].language_name_2,_W/54,rectBg[i].y + rectBg[i].height/2,_FontArr[6],_H/36.76)
				title[i]:setTextColor( 83/255 ,20/255 ,111/255) 
				title[i].anchorX = 0
				languageListScrollView:insert(title[i])
			
			end
			
			end
		
			end
		
			end
		
		end
		
		local url = _WebLink.."languages.php"
		languageListRequest = network.request( url, "GET", languageListNetworkListener )
		native.setActivityIndicator( true )
		
		
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen
        -- Insert code here to make the scene come alive
        -- Example: start timers, begin animation, play audio, etc.
    end
end



-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen)
        -- Insert code here to "pause" the scene
        -- Example: stop timers, stop animation, stop audio, etc.
        
        display.remove( background )
        background = nil
        
        for i = 1, #rectBg do
        	if( rectBg[i] ) then
        		display.remove( rectBg[i] )
        		rectBg[i] = nil
        	end
        end
        rectBg = { }
        
        for i = 1, #title do
        	if( title[i] ) then
        		display.remove( title[i] )
        		title[i] = nil
        	end
        end
        title = {}
         
        display.remove( languageListGroup )
        languageListGroup = nil
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view
    -- Insert code here to clean up the scene
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
