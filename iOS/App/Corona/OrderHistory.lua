local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------
local imageDirectory = "images/SignUp/"
local imageDirectory2 = "images/OrderHistory/"

local pageIndex,orderHistoryData,orderHistoryExtraData, heading
local orderID = { }
local orderRect = { }
local orderName = { }
local orderListRequest,extraOrderListRequest

local function onDoNothing( event )

	return true
end


local function handleBackButtonEvent( event )
	local previous = composer.getSceneName( "previous" )
	if previous == "OrderDetailsPage" then
		composer.gotoScene( _PreviousSceneforOrder )
	elseif( previous == "PlaceOrder" or previous == "OrderPopUp") then
		composer.gotoScene( "menu" )
	else
		composer.gotoScene( previous )
	end

	return true
end

local function handleBackButtonEventTouch( event )
	if event.phase == "ended" then
		local previous = composer.getSceneName( "previous" )
		if previous == "OrderDetailsPage" then
			composer.gotoScene( _PreviousSceneforOrder )
		elseif( previous == "PlaceOrder" or previous == "OrderPopUp" ) then
			composer.gotoScene( "menu" )
		else
			composer.gotoScene( previous )
		end
	end

	return true
end

local function getDateValue( str )
	local d = str:sub(1,10)
	return d
end

--[[local function onTouchOrderRect( event )
	if( event.phase == "began" ) then
		
		
	
	end
	return true
end]]--


local function onOrderHistoryRowRender( event )
	 local row = event.row
    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth
	
	local i = row.index
	print("row"..i)
	
	
	
	row.id = orderHistoryData[i].id
	
	orderRect[i] = display.newImageRect(row,imageDirectory2.."RowBg.png",_W,rowHeight)
	orderRect[i].x = _W/2
	orderRect[i].y = rowHeight * 0.5
	
	
	orderIcon = display.newImageRect(row,imageDirectory2.."rowIcon.png",_W/9.15,_H/16.41)
	orderIcon.x = _W/30.85
	orderIcon.y = rowHeight * 0.5
	orderIcon.anchorX = 0
	
	orderName[i] = display.newText(row,_HotelName..tostring(orderHistoryData[i].order_number),_W/6,rowHeight * 0.4,_FontArr[6],_H/31.48)
	orderName[i].anchorX = 0
	orderName[i]:setTextColor( 83/255,20/255,111/255 )
	
	
	local date = getDateValue(tostring(orderHistoryData[i].n_datetime))
	
	
	orderDate = display.newText(row,tostring(date),_W/6,rowHeight * 0.72,_FontArr[6],_H/55.09)
	orderDate.anchorX = 0
	orderDate:setTextColor( 83/255,20/255,111/255 )
	
    preparingIcon = display.newImageRect(row,imageDirectory2.."Preparing_Icon.png",_W/18.94,_H/34.28)
	preparingIcon.x = _W/1.12
	preparingIcon.y = rowHeight * 0.3
	preparingIcon.isVisible = false
    
    servedIcon = display.newImageRect(row,imageDirectory2.."Servede_Icon.png",_W/15.65,_H/31.47)
	servedIcon.x = _W/1.12
	servedIcon.y = rowHeight * 0.3
	servedIcon.isVisible = false
	
	 local option = {
    	parent = row,
    	text = "",
    	x = _W/1.12,
    	y = rowHeight * 0.75,
    	width = _W/5,
    	height = _H/25,
    	font = _FontArr[6],
    	fontSize = _H/50,
    	align = "center"
    	
    }
	
	
	preparingLabel = display.newText(option)
	preparingLabel.text = "Preparing"
	preparingLabel:setTextColor( 206/255,23/255,100/255 )
	preparingLabel.isVisible = false
	
    servedLabel = display.newText(option)
    servedLabel.text = "Served"
	servedLabel:setTextColor( 0,0,0,0.5 )
	servedLabel.isVisible = false
	
	if( orderHistoryData[i].status == "Received" ) then
		preparingIcon.isVisible = true	
		preparingLabel.text = GBCLanguageCabinet.getText("ReceivedLabel",_LanguageKey)
		preparingLabel.isVisible = true
		servedIcon.isVisible = false
		servedLabel.isVisible = false
		 
	elseif( orderHistoryData[i].status == "Processing" ) then
	
		preparingIcon.isVisible = true	
		preparingLabel.text = GBCLanguageCabinet.getText("ProcessingLabel",_LanguageKey)
		preparingLabel.isVisible = true
		servedIcon.isVisible = false
		servedLabel.isVisible = false
		
	elseif( orderHistoryData[i].status == "Ready to be collected" ) then
		preparingIcon.isVisible = false	
		
		preparingLabel.isVisible = false
		servedIcon.isVisible = true
		servedLabel.text = GBCLanguageCabinet.getText("ReadyToCollectLabel",_LanguageKey)
		servedLabel.isVisible = true
		orderName[i]:setTextColor( 0,0,0,0.5 )
		orderDate:setTextColor( 0,0,0,0.5 )
		
	elseif( orderHistoryData[i].status == "Completed" ) then
		preparingIcon.isVisible = false	
		preparingLabel.isVisible = false
		servedIcon.isVisible = true
		servedLabel.text = GBCLanguageCabinet.getText("CompletedLabel",_LanguageKey)
		servedLabel.isVisible = true
		orderName[i]:setTextColor( 0,0,0,0.5 )
		orderDate:setTextColor( 0,0,0,0.5 )
	
	elseif( orderHistoryData[i].status == "Cancelled" ) then
		
		preparingIcon.isVisible = false	
		preparingLabel.isVisible = false
		servedIcon.isVisible = true
		servedLabel.text = GBCLanguageCabinet.getText("CancelledLabel",_LanguageKey)
		servedLabel.isVisible = true
		orderName[i]:setTextColor( 0,0,0,0.5 )
		orderDate:setTextColor( 0,0,0,0.5 )
	
	end
	
	

end

local function onOrderHistoryRowTouch( event )
	if(event.phase == "tap") then
		_selectedOrderID = event.row.id
		composer.gotoScene("OrderDetailsPage")
	
	--[[elseif(event.phase == "tap") then
		_selectedOrderID = event.row.id
		composer.gotoScene("OrderDetailsPage")
		]]--
	end
	return true
end


local function ViewMyOrdersNetworkListener( event )
	if ( event.isError ) then
    	print( "Network error!" )
				
    	timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
				
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				
	else	
		timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
			print("add/update rating resposne: "..event.response)
		if(event.response == "0" or event.response == 0) then
		
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif(event.response == "1" or event.response == 1) then
		
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif(event.response == "2" or event.response == 2) then
		
			noItem = display.newText(GBCLanguageCabinet.getText("Order6Alert",_LanguageKey),_W/2,_H/2,_FontArr[26],_H/35)
			noItem:setTextColor( 0 )
			orderHistoryGroup:insert(noItem)
			
			--local alert = native.showAlert( alertLabel, "No previous orders found", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		else
			orderHistoryData = json.decode(event.response)
			
			if(#orderHistoryData > 0) then
				
				if(noItem) then
					display.remove(noItem)
					noItem = nil
				end
				if(composer.getSceneName( "current" ) == "OrderHistory") then
				for i = 1, #orderHistoryData do
					orderHistoryTableView:insertRow{
						rowHeight = _H/10.66,
						lineColor = { 1, 0, 0, 0 }
					}	
				end     
				end
			else
			
				noItem = display.newText("No Previous Orders",_W/2,_H/2,_FontArr[26],_H/35)
				noItem:setTextColor( 0 )
				orderHistoryGroup:insert(noItem)
			
			end
			
		end
	end			
	return true
	
end

local function ViewMyExtraOrdersNetworkListener( event )
	if ( event.isError ) then
    	print( "Network error!" )
				
    	timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
				
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				
	else	
		timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
			print("add/update rating resposne: "..event.response)
		if(event.response == "0" or event.response == 0) then
			pageIndex = pageIndex - 1
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif(event.response == "1" or event.response == 1) then
			pageIndex = pageIndex - 1
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif(event.response == "2" or event.response == 2) then
			pageIndex = pageIndex - 1
			--local alert = native.showAlert( alertLabel, "No previous orders found", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		else
			orderHistoryExtraData = json.decode(event.response)
			
			if(orderHistoryExtraData) then
			
			if(#orderHistoryExtraData > 0) then
				local oldIndex = #orderHistoryData
				
				for i = 1,#orderHistoryExtraData do
				
					table.insert(orderHistoryData,orderHistoryExtraData[i])
					
				end
				
				if(noItem) then
					display.remove(noItem)
					noItem = nil
				end
				print("indexssss")
				print(((oldIndex) + 1))
				print((oldIndex + #orderHistoryExtraData))
				
				
				
				for i = ((oldIndex) + 1), (oldIndex + #orderHistoryExtraData) do
					print("inser row.....")
					orderHistoryTableView:insertRow{
						rowHeight = _H/10.66,
						lineColor = { 1, 0, 0, 0 }
					}	
				end     
			
			else
			
			
			
			end
			
			else
			
			
			end
			
		end
	end			
	return true

end


local function orderHistoryScrollListener( event )
	if ( event.limitReached ) then
		print(event.direction)
       	if ( event.direction == "up" ) then 
       		print("reached limit"..pageIndex)

				pageIndex = pageIndex + 1
				print("pagination search")
				
			local headers = {}
		
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		
		--local body = "ws=1&user_id=".._UserID.."&page="..pageIndex
		local body = "ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&page="..pageIndex
		local params = {}
		params.headers = headers
		params.body = body
		params.timeout = 180
		
		local url = _WebLink.."orders-store.php?"
		print( url..body )
		extraOrderListRequest = network.request( url, "POST", ViewMyExtraOrdersNetworkListener, params )
		native.setActivityIndicator( true )
			
       		
       	elseif ( event.direction == "down" ) then 
       		
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
        sceneGroup:insert( background )
        
        local header = display.newImageRect( imageDirectory.."f_Header.png", _W, _H/13.61 )
        header.x = _W/2
        header.y = _H/27
        sceneGroup:insert( header )
        
        heading = display.newText( GBCLanguageCabinet.getText("orderHistoryLabel",_LanguageKey), header.x, header.y, _FontArr[30], _H/36.76 )
        heading:setFillColor( 1 )
        sceneGroup:insert( heading )
        --[[
        local backBtn = display.newImageRect( imageDirectory.."Back_Btn.png", _W/15.42, _H/33.10 )
        backBtn.x = _W/13.5
        backBtn.y = header.y
        sceneGroup:insert( backBtn )
       			
		local backBg = display.newRect( backBtn.x, backBtn.y, backBtn.width + _W/21.6, backBtn.height + _H/38.4 )
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
        
        print(" ORder History Page ...............................")
        heading.text = GBCLanguageCabinet.getText("orderHistoryLabel",_LanguageKey)
        
        orderHistoryGroup = display.newGroup()
        sceneGroup:insert(orderHistoryGroup)
        
orderHistoryTableView = widget.newTableView
{
    left = 0,
    top = _H/13.61,
    height = _H - _H/13.61,
    width = _W,
    noLines = true,
    onRowRender = onOrderHistoryRowRender,
    onRowTouch = onOrderHistoryRowTouch,
    listener = orderHistoryScrollListener
}
orderHistoryGroup:insert(orderHistoryTableView)


		pageIndex = 1
		local headers = {}
		
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		--local body
		--local body = "ws=1&user_id=".._UserID.."&page="..pageIndex
		local body = "ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&page="..pageIndex
		local params = {}
		params.headers = headers
		params.body = body
		params.timeout = 180
		
		local url = _WebLink.."orders-store.php?"
		print( url..body )
		orderListRequest = network.request( url, "POST", ViewMyOrdersNetworkListener, params )
		native.setActivityIndicator( true )

        
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
        
        orderID = { }
	 	orderRect = { }
		orderName = { }
        
        display.remove(orderHistoryTableView)
        orderHistoryTableView = nil
        
        display.remove(orderHistoryGroup)
        orderHistoryGroup = nil
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
        if(extraOrderListRequest) then
        	network.cancel( extraOrderListRequest )
        	extraOrderListRequest = nil
        end
        
        if(orderListRequest) then
        	network.cancel( orderListRequest )
        	orderListRequest = nil
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