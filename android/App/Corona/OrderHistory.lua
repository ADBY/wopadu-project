local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------
local imageDirectory = "images/SignUp/"
local imageDirectory2 = "images/OrderHistory/"

local pageIndex,orderHistoryData,orderHistoryExtraData,heading
local orderID = { }
local orderRect = { }
local orderName = { }
local orderListRequest,extraOrderListRequest
local networkReqCount1, networkReqCount2

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

local function onOrderHistoryRowRender( event )
	local row = event.row
    
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth
	
	local i = row.index	
	
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
		
	end
	return true
end


local function ViewMyOrdersNetworkListener( event )
	if ( event.isError ) then
    	
		
		networkReqCount1 = networkReqCount1 + 1		
    	
    	native.setActivityIndicator( false )
		
		if( networkReqCount1 > 3 ) then
				
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		else
		
			local url = _WebLink.."orders-store.php?ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&page="..pageIndex
			local url2 = url:gsub(" ", "%%20")
			orderListRequest = network.request( url2, "GET", ViewMyOrdersNetworkListener )
			native.setActivityIndicator( true )
		
		end		
	else	
		timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		if(event.response == "0" or event.response == 0) then
		
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif(event.response == "1" or event.response == 1) then
		
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif(event.response == "2" or event.response == 2) then
		
			noItem = display.newText(GBCLanguageCabinet.getText("Order6Alert",_LanguageKey),_W/2,_H/2,_FontArr[26],_H/35)
			noItem:setTextColor( 0 )
			orderHistoryGroup:insert(noItem)
			
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
			
				noItem = display.newText(GBCLanguageCabinet.getText("Order6Alert",_LanguageKey),_W/2,_H/2,_FontArr[26],_H/35)
				noItem:setTextColor( 0 )
				orderHistoryGroup:insert(noItem)
			
			end
			
		end
	end			
	return true
	
end

local function ViewMyExtraOrdersNetworkListener( event )
	if ( event.isError ) then
    	
				
    	networkReqCount2 = networkReqCount2 + 1
    	native.setActivityIndicator( false )

		if( networkReqCount2 > 3 ) then
				
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		else
		
			local url = _WebLink.."orders-store.php?ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&page="..pageIndex
			local url2 = url:gsub(" ", "%%20")
			extraOrderListRequest = network.request( url2, "GET", ViewMyExtraOrdersNetworkListener )
			native.setActivityIndicator( true )
			
		end		
	else	
		timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		if(event.response == "0" or event.response == 0) then
			pageIndex = pageIndex - 1
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif(event.response == "1" or event.response == 1) then
			pageIndex = pageIndex - 1
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif(event.response == "2" or event.response == 2) then
			pageIndex = pageIndex - 1
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
				
				for i = ((oldIndex) + 1), (oldIndex + #orderHistoryExtraData) do
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
       	if ( event.direction == "up" ) then 

				pageIndex = pageIndex + 1
				
		local url = _WebLink.."orders-store.php?ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&page="..pageIndex
		local url2 = url:gsub(" ", "%%20")
		extraOrderListRequest = network.request( url2, "GET", ViewMyExtraOrdersNetworkListener )
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
        
        
        heading.text = GBCLanguageCabinet.getText("orderHistoryLabel",_LanguageKey)
        
        networkReqCount1 = 0
        networkReqCount2 = 0
        
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
		
		local url = _WebLink.."orders-store.php?ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&page="..pageIndex
		local url2 = url:gsub(" ", "%%20")
		orderListRequest = network.request( url2, "GET", ViewMyOrdersNetworkListener )
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