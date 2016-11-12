local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------
local param
local imageDirectory = "images/SignUp/"


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

local function handleBackButtonEvent( event )
	if( notificationFlag2 == true or notificationFlag  == true ) then
		composer.gotoScene("welcomeScreen")
		notificationFlag = false
		notificationFlag2 = false
	else
		composer.gotoScene("menu")
		notificationFlag = false
		notificationFlag2 = false
	end
	return true
end

-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
    param = event.params

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
        
        local background = display.newImageRect( imageDirectory.."Background.png", _W, _H )
        background.x = _W/2
        background.y = _H/2
        sceneGroup:insert( background )
        
        local header = display.newImageRect( imageDirectory.."f_Header.png", _W, _H/13.61 )
        header.x = _W/2
        header.y = _H/27
        sceneGroup:insert( header )
        
        local heading = display.newText( GBCLanguageCabinet.getText("OrderNotificationLabel",_LanguageKey), header.x, header.y, _FontArr[30], _H/36.76 )
        heading:setFillColor( 1 )
        sceneGroup:insert( heading )
        
        local busiName = display.newText( _HotelName, header.x, header.y + header.height + _H/96, _FontArr[30], _H/36.76 )
        busiName:setFillColor( 206/255, 23/255, 100/255 )
        sceneGroup:insert( busiName )
      
      	local option = {
    		text = GBCLanguageCabinet.getText("hiLabel",_LanguageKey).." ".._fName..",\n\n"..GBCLanguageCabinet.getText("YourOderIsReadyLabel",_LanguageKey),
    		x = _W/2,
    		y = busiName.y + busiName.height + _H/19.2,	
    		width = _W - _W/54,
    		height = 0,
    		font = _FontArr[30] ,
    		fontSize = _H/40,
    		align = "center"
    		
    	}
    	
      	local Label1 = display.newText( option )
    	Label1:setFillColor( 83/255, 20/255, 111/255 )
    	sceneGroup:insert( Label1 )
		
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
        
    local DetailsTable = param.noti_table    
    
    orderNoValue = DetailsTable.order_number
    orderNameValue = DetailsTable.item_name
    loopIndex = 0
    
    extraItemArr = { }
    if( DetailsTable.options == nil or DetailsTable.options == "" ) then
    	
    else
    	loopIndex = #DetailsTable.options
    
    end 
    
    local orderLabel = display.newText( GBCLanguageCabinet.getText("orderNoLabel",_LanguageKey).." : "..orderNoValue,_W/2, Label1.y + Label1.height + _H/19.2 , _FontArr[30], _H/25 )
    orderLabel:setFillColor( 206/255, 23/255, 100/255 )
    sceneGroup:insert( orderLabel )
    
    local dateTime = display.newText( DetailsTable.order_time,_W/2, Label1.y + Label1.height/2 + _H/38.4,0,0, _FontArr[30], _H/55 )
    dateTime:setFillColor( 0.5,0.5,0.5,0.5 )
    sceneGroup:insert( dateTime )
    
    local s = orderNameValue
    if(s:len() > 27) then
        s = s:sub(1,27).."..."
    else	
    	s = s
	end
    
    orderName = display.newText( "",_W/36, orderLabel.y + orderLabel.height,_FontArr[6],_H/35)
    orderName:setTextColor( 83/255, 20/255, 111/255 )
    orderName.text = s
    orderName.anchorX = 0
    sceneGroup:insert(orderName)
        		
    quantityArr = display.newText("",_W/2 + _W/6, _H/24.30,_FontArr[6],_H/35)
    quantityArr:setTextColor( 83/255, 20/255, 111/255 )
    quantityArr.text = _CartArray.quantity
    sceneGroup:insert(quantityArr)
        		
    if(loopIndex > 0) then
    	
    	for j = 1, loopIndex do
    
    	extraItemArr[j] = display.newText("",_W/36, _H/24.30,_FontArr[6],_H/35)
    	extraItemArr[j]:setTextColor( 0, 0, 0,0.5 )
    	extraItemArr[j].anchorX = 0
    	extraItemArr[j].anchorY = 0
    	sceneGroup:insert(extraItemArr[j])
    	extraItemArr[j].text = DetailsTable.options[j].option_name .. " : "..DetailsTable.options[j].sub_name
    	if(j == 1) then
    		extraItemArr[j].y = orderName.y + orderName.height/2 + _H/192
    		
    	else
    		extraItemArr[j].y = extraItemArr[j-1].y + extraItemArr[j-1].height + _H/192
    	
    	end
    	
    end
    
    end
    
    local Label2 = display.newText( GBCLanguageCabinet.getText("HaveAGreatDayLabel",_LanguageKey),_W/2, _H - _H/48,0,0, _FontArr[30], _H/40 )
    Label2:setFillColor( 83/255, 20/255, 111/255 )
    Label2.anchorY = 1
    sceneGroup:insert( Label2 )   
        
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
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
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