local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------
local imageDirectory = "images/SignUp/"
local imageDirectory2 = "images/PlaceOrder/"

local ordersBg = { } 
local quantityArr = { }
local incrementArr = { }
local decrementArr = { }
local orderName = { }
local orderPrice = { }
local extraItemArr = { }
local extraItemPrice = { }
local orderNote = { }
local orderNoteBg = { }
local discountValue
local orderDetailsRequest
local placeOrderButton,noteBg,noteTextBox,placeOrderScrollView,header,heading,backBg,backBtn,orderSummaryBg,orderSummaryDevider,orderSummaryLabel,subtotalLabel
local total,totalQuantity,grandTotal,s_tax,o_tax, s_tax2, o_tax2, total2, grandTotal2
local orderDetailsGroup,yPos
local orderData

local function onDoNothing()

	return true
end


local function handleBackButtonEvent( event )
	composer.gotoScene( "OrderHistory" )

	return true
end

local function handleBackButtonEventTouch( event )
	if event.phase == "ended" then
		composer.gotoScene( "OrderHistory" )
	end

	return true
end

local function inputListener( event )
    if event.phase == "began" then
        orderDetailsGroup.y = orderDetailsGroup.y - _H/2
        backBtn:toFront()    
		header:toFront()
		heading:toFront()
        

    elseif event.phase == "ended" then
		orderDetailsGroup.y = yPos
    elseif event.phase == "editing" then
        
    end
end

local function handlePlaceOrderButtonEvent( event )
	if( event.phase == "ended" ) then
		
	end
	return true
end

local function reloadPrice()
	total = 0
	totalQuantity = 0
	grandTotal = 0
	totalAddOnValue = 0
	
	for i = 1,#orderData.items do
		roundDigit(tonumber(orderData.items[i].item_amount) )
		
		total = total + (orderData.items[i].quantity * digValue3)
    	if(orderData.items[i].item_options) then	
    		for j = 1, #orderData.items[i].item_options do
    			roundDigit(orderData.items[i].item_options[j].sub_amount)				
    			total = total + (orderData.items[i].quantity * digValue3)
    			totalAddOnValue = totalAddOnValue + 1
    		end
    	end
    	totalQuantity = totalQuantity + orderData.items[i].quantity
	end
	
	roundDigit(total)
	total2 = digValue3
	
	local t = total2
	
	roundDigit(t)
	grandTotal2 = digValue3
	
	grandTotal = grandTotal2
	
	totalItemLabel.text =  GBCLanguageCabinet.getText("TotalItemLabel",_LanguageKey)..tostring(totalQuantity)
	totalAddOnsLabel.text = GBCLanguageCabinet.getText("TotalAddOnsLabel",_LanguageKey)..tostring(totalAddOnValue)
	subtotalLabel.text = GBCLanguageCabinet.getText("SubTotalLabel",_LanguageKey).." $ "..make2Digit(total)
	grandTotalLabel.text = GBCLanguageCabinet.getText("GrandTotalLabel",_LanguageKey).." $ "..make2Digit(grandTotal)
	 
end

local function onDecrementTouch( event )
	if(event.phase == "began") then
		orderData.items[event.target.id].quantity = tonumber(orderData.items[event.target.id].quantity) - 1
		
		
		local function onRemoveProduct( e ) 
			 if e.action == "clicked" then
        		local i = e.index
        		if i == 1 then
        			
            		orderDetailsTableView:deleteRow(event.target.id)
					table.remove(orderData.items,event.target.id)
					quantityArr[event.target.id].text = orderData.items[event.target.id].quantity
					
					
					local function deleteProduct()
						reloadPrice()
						orderDetailsTableView:deleteAllRows()
						for i = 1, #orderData.items do
        					if(#orderData.items[i].item_options < 2) then
    							rowHeight = _H/8.06
    						else
    							rowHeight = _H/8.06 + ((#orderData.items[i].item_options - 1) * _H/32)
    						end
    		
    						orderDetailsTableView:insertRow{
    							rowHeight = rowHeight,
    							lineColor = { 1, 0, 0, 0 }
    						}
						end
					end
					timer.performWithDelay( 500, deleteProduct )
					
        		elseif i == 2 then
            		
        		end
    		end
			return true
		end
		
		if(orderData.items[event.target.id].quantity == 0) then
		
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Item6Alert",_LanguageKey), { "YES", "No" }, onRemoveProduct )
		else
			quantityArr[event.target.id].text = orderData.items[event.target.id].quantity	
			reloadPrice()
			orderDetailsTableView:reloadData()
		end
		
	end
	return true
end

local function onIncrementTouch( event )
	if(event.phase == "began") then
		orderData.items[event.target.id].quantity = tonumber(orderData.items[event.target.id].quantity) + 1
		quantityArr[event.target.id].text = orderData.items[event.target.id].quantity
		reloadPrice()
		orderDetailsTableView:reloadData()
	end
	return true
end


function scene:resumeGame()
    return true
end

local function onShowProductNote( event )
	if(event.phase == "began") then
	
		if(event.target.id == 0) then
			local option = {
				params = {
					noteValue = orderData.add_note
					}
				}
			composer.showOverlay( "NoteOverlay", option )
			
		else
			
				local option = {
				params = {
					noteValue = orderData.items[event.target.id].add_note
					}
				}
			composer.showOverlay( "NoteOverlay", option )
		end
	end
	return true
end

local function onRowRender( event )

    local row = event.row
	local i = row.index
	
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    ordersBg[i] = display.newImageRect(imageDirectory2.."OrderRowBg.png",_W,rowHeight)
    ordersBg[i].x = _W/2
    ordersBg[i].y = rowHeight * 0.5
    row:insert(ordersBg[i])
    
    local s = tostring(orderData.items[i].item_name)
    if(s:len() > 27) then
        s = s:sub(1,27).."..."
    else	
    	s = s
	end
    
    orderName[i] = display.newText("",_W/36, _H/24.30,_FontArr[6],_H/35)
    orderName[i]:setTextColor( 83/255, 20/255, 111/255 )
    orderName[i].text = s
    orderName[i].anchorX = 0
    row:insert(orderName[i])
        		
    quantityArr[i] = display.newText("",_W/2 + _W/6, _H/24.30,_FontArr[6],_H/35)
    quantityArr[i]:setTextColor( 83/255, 20/255, 111/255 )
    quantityArr[i].text = orderData.items[i].quantity
    row:insert(quantityArr[i])
    
    roundDigit(tonumber(orderData.items[i].item_amount) )
    
    orderPrice[i] = display.newText(make2Digit(orderData.items[i].quantity * tonumber(digValue3)),_W - _W/36, _H/24.30,_FontArr[6],_H/35)
    orderPrice[i]:setTextColor( 206/255, 23/255, 100/255 )
    orderPrice[i].anchorX = 1
    row:insert(orderPrice[i])
    
    if(orderData.items[i].item_options) then
    
    for j = 1, #orderData.items[i].item_options do
    	extraItemArr[j] = display.newText("",_W/36, _H/24.30,_FontArr[6],_H/40)
    	extraItemArr[j]:setTextColor( 0 )
    	extraItemArr[j].anchorX = 0
    	extraItemArr[j].anchorY = 0
    	row:insert(extraItemArr[j])
    	extraItemArr[j].text = orderData.items[i].item_options[j].sub_name
    	if(j == 1) then
    		extraItemArr[j].y = orderName[j].y + orderName[j].height/2 + _H/192
    		
    	else
    		extraItemArr[j].y = extraItemArr[j-1].y + extraItemArr[j-1].height + _H/192
    	
    	end
    	
    	roundDigit(orderData.items[i].item_options[j].sub_amount)    	
    	extraItemPrice[j] = display.newText("$ "..make2Digit(orderData.items[i].quantity * tonumber(digValue3)),_W - _W/36, extraItemArr[j].y,_FontArr[6],_H/40)
    	extraItemPrice[j]:setTextColor( 0 )
    	extraItemPrice[j].anchorX = 1
    	extraItemPrice[j].anchorY = 0
    	row:insert(extraItemPrice[j])
    	
    	
    end
      
    end 
       
    if(orderData.items[i].add_note == "" or orderData.items[i].add_note == nil or orderData.items[i].add_note == " ") then
    	
    else	
    	
    	orderNote[i] = display.newText(GBCLanguageCabinet.getText("NotesLabel",_LanguageKey),_W/36, rowHeight * 0.85,_FontArr[6],_H/40)
    	orderNote[i]:setTextColor( 83/255, 20/255, 111/255 )
    	orderNote[i].anchorX = 0
    	row:insert(orderNote[i])
    	
    	orderNoteBg[i] = display.newRect(orderNote[i].x + orderNote[i].width/2,orderNote[i].y - orderNote[i].height/2 ,orderNote[i].width + _W/27,orderNote[i].height + _H/96)
    	orderNoteBg[i]:setFillColor( 1, 1, 1, 0.01 )
    	orderNoteBg[i].anchorY = 0
    	orderNoteBg[i].id = i
    	orderNoteBg[i]:addEventListener("touch",onShowProductNote)
    	row:insert(orderNoteBg[i])
    	
		orderNoteLine = display.newLine(orderNote[i].x ,orderNote[i].y + _H/110 , orderNote[i].x + orderNote[i].width,orderNote[i].y + _H/110)
        orderNoteLine:setStrokeColor( 83/255, 20/255, 111/255 )
		orderNoteLine.strokeWidth = 2
        row:insert(orderNoteLine)
           
        orderNote[i]:toFront() 	
        orderNoteLine:toFront()
    
    end   

    	reloadPrice()
       
end

local function ViewMyOrderDetailNetworkListener( event )
	if ( event.isError ) then
				
    	timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
				
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				
	else	
		timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		
		if(event.response == "0" or event.response == 0) then
			
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif(event.response == "1" or event.response == 1) then
			
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif(event.response == "2" or event.response == 2) then
			
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Order1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif(event.response == "3" or event.response == 3) then
			
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif(event.response == "4" or event.response == 4) then
			
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Order1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		else
		
			orderData = json.decode(event.response)
			
			
			for i = 1, #orderData.items do
			if(orderData.items[i].item_options) then
        	if(#orderData.items[i].item_options < 2) then
    			rowHeight = _H/8.06
    		else    			
    			rowHeight = _H/8.06 + ((#orderData.items[i].item_options - 1) * _H/32)
    		end
    		else
    			rowHeight = _H/8.06
    		end
    		orderDetailsTableView:insertRow{
    		
    			rowHeight = rowHeight,
    			lineColor = { 1, 0, 0, 0 }
    			
    		}
    		
    		roundDigit(tonumber(orderData.items[i].item_amount))
    		
    		total = total + (orderData.items[i].quantity * tonumber(digValue3))
    		if(orderData.items[i].item_options) then
    		
    		for j = 1, #orderData.items[i].item_options do
    		
    			roundDigit(orderData.items[i].item_options[j].sub_amount)
    			
    			total = total + (orderData.items[i].quantity * tonumber(digValue3))
    			
    		end
    		
    		end
    			totalQuantity = totalQuantity + orderData.items[i].quantity
			end
			
			if(orderData.add_note == "" or orderData.add_note == " " or orderData.add_note == nil) then
				orderNote_main.isVisible = false	
        		orderNote_mainLine.isVisible = false
        		orderNote_mainBg.isVisible = false
			else	
				orderNote_main.isVisible = true	
        		orderNote_mainLine.isVisible = true
        		orderNote_mainBg.isVisible = true
			end
		
		end
		
		
	end
	return true
end

local function handleAddToCartButtonEvent( event )
	if( event.phase == "ended" ) then
		
		for i = 1, #orderData.items do
			CartRepeatFlag = 0
			extraItemArr = {}
			for k = 1,#_CartArray do
				if(_CartArray[k].productID == orderData.items[i].item_id) then
					CartRepeatFlag = CartRepeatFlag - 1
				else
					CartRepeatFlag = CartRepeatFlag + 1
				end
			end		
		
		if(CartRepeatFlag == #_CartArray) then
			if(orderData.items[i].item_options_id == "" or orderData.items[i].item_options_id == nil or orderData.items[i].item_options_id == " ") then
				extraItemArr = {}
			else
				extraItemArr = orderData.items[i].item_options
			end
    		_CartArray[#_CartArray + 1] = { kitchenID = orderData.items[i].kitchen_id,title = orderData.items[i].item_name ,productID = orderData.items[i].item_id ,price = orderData.items[i].item_amount,discount = discountValue,variety_id = orderData.items[i].item_variety_id ,quantity = orderData.items[i].quantity, extraItems = extraItemArr, Note = orderData.items[i].add_note}
		else
					
			for j = 1,#_CartArray do
				if(_CartArray[j].productID == orderData.items[i].item_id and _CartArray[j].variety_id == orderData.items[i].item_variety_id) then
					if(orderData.items[i].item_options_id == "" or orderData.items[i].item_options_id == nil or orderData.items[i].item_options_id == " ") then
						extraItemArr = {}
					else
						extraItemArr = orderData.items[i].item_options
					end
					if(#_CartArray[j].extraItems > 0) then
						for m = 1,#_CartArray[j].extraItems do
							for n = 1,#extraItemArr do
								if(_CartArray[j].extraItems[m].id == extraItemArr[n].id) then
									flag = 1
									break
								else
									flag = 0
								end
							end
							if(flag == 0) then
								extraItemArr[#extraItemArr + 1] = _CartArray[j].extraItems[m]
							end
						end
					else
					
					end
					local q = tonumber(orderData.items[i].quantity) + _CartArray[j].quantity
    				_CartArray[j] = { kitchenID = orderData.items[i].kitchen_id,title = orderData.items[i].item_name ,productID = orderData.items[i].item_id ,price = orderData.items[i].item_amount,discount = discountValue,variety_id = orderData.items[i].item_variety_id ,quantity = q , extraItems = extraItemArr, Note = orderData.items[i].add_note}
				end
			end
			
		end
		
		
		end
		
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Item4Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
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

end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
        
        total = 0
        totalQuantity = 0
        grandTotal = 0
        discountValue = 0
       	
        header = display.newImageRect( imageDirectory.."f_Header.png", _W, _H/13.61 )
        header.x = _W/2
        header.y = _H/27
        sceneGroup:insert( header )
        
        heading = display.newText(GBCLanguageCabinet.getText("OrderDetailsLabel",_LanguageKey), header.x, header.y, _FontArr[30], _H/36.76 )
        heading:setFillColor( 1 )
        sceneGroup:insert( heading )
		
	backBtn = widget.newButton
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
		
        orderDetailsGroup = display.newGroup()
        sceneGroup:insert(orderDetailsGroup)
        
		
		orderDetailsTableView = widget.newTableView
		{
    		top = _H/13.61,
    		left = 0,
   		 	width = _W,
    		height = _H - _H/13.61 - _H/2.67,
    		onRowRender = onRowRender,
    		onRowTouch = onRowTouch,
    		hideBackground = true,
    		horizontalScrollDisabled = true,
    		noLines = true,
    		listener = scrollListener
		}
		orderDetailsGroup:insert(orderDetailsTableView)
        
		roundDigit(total)
		total2 = digValue3
		
		local t = total2 
		roundDigit(t)
		grandTotal2 = digValue3
        
        grandTotal = grandTotal2
        
    	
        orderSummaryDevider = display.newLine(0,orderDetailsTableView.y + orderDetailsTableView.height/2 + _H/384,_W,orderDetailsTableView.y + orderDetailsTableView.height/2+ _H/384)
        orderSummaryDevider:setStrokeColor( 0, 0, 0, 0.5 )
		orderSummaryDevider.strokeWidth = 3
        orderDetailsGroup:insert(orderSummaryDevider)
        
        orderSummaryBg = display.newImageRect(imageDirectory2.."OrderSummaryBg.png",_W,_H/6.62)
        orderSummaryBg.x = _W/2
        orderSummaryBg.y = orderDetailsTableView.y + orderDetailsTableView.height/2 + _H/384
        orderSummaryBg.anchorY = 0
        orderDetailsGroup:insert(orderSummaryBg)
        
        orderSummaryLabel = display.newText(GBCLanguageCabinet.getText("OrderSummaryLabel",_LanguageKey),_W/36, orderSummaryBg.y + _H/96,_FontArr[6],_H/35)
        orderSummaryLabel.anchorX = 0
        orderSummaryLabel.anchorY = 0
        orderSummaryLabel:setTextColor( 83/255, 20/255, 111/255 )
        orderDetailsGroup:insert(orderSummaryLabel)
        
        
        
        
        totalItemLabel = display.newText(GBCLanguageCabinet.getText("TotalItemLabel",_LanguageKey).." "..totalQuantity ,orderSummaryLabel.x, orderSummaryLabel.y + orderSummaryLabel.height + _H/384,_FontArr[6],_H/50)
        totalItemLabel.anchorX = orderSummaryLabel.anchorX
        totalItemLabel.anchorY = 0
        totalItemLabel:setTextColor( 0 )
        orderDetailsGroup:insert(totalItemLabel)
        
        totalAddOnsLabel = display.newText(GBCLanguageCabinet.getText("TotalAddOnsLabel",_LanguageKey).." " ,orderSummaryLabel.x, totalItemLabel.y + totalItemLabel.height + _H/384,_FontArr[6],_H/50)
        totalAddOnsLabel.anchorX = orderSummaryLabel.anchorX
        totalAddOnsLabel.anchorY = 0
        totalAddOnsLabel:setTextColor( 0 )
        orderDetailsGroup:insert(totalAddOnsLabel)
        
        subtotalLabel = display.newText(GBCLanguageCabinet.getText("SubTotalLabel",_LanguageKey).." $ "..make2Digit(total),orderSummaryLabel.x, totalAddOnsLabel.y + totalAddOnsLabel.height + _H/384,_FontArr[6],_H/40)
        subtotalLabel.anchorX = 0
        subtotalLabel.anchorY = 0
        subtotalLabel:setTextColor( 206/255, 23/255, 100/255 )
        orderDetailsGroup:insert(subtotalLabel)
        
        grandTotalLabel = display.newText(GBCLanguageCabinet.getText("GrandTotalLabel",_LanguageKey).." $ "..make2Digit(grandTotal) ,subtotalLabel.x, subtotalLabel.y + subtotalLabel.height + _H/96,_FontArr[6],_H/35)
        grandTotalLabel.anchorX = subtotalLabel.anchorX
        grandTotalLabel.anchorY = 0
        grandTotalLabel:setTextColor( 206/255, 23/255, 100/255 )
        orderDetailsGroup:insert(grandTotalLabel)
        
        orderNote_main = display.newText(GBCLanguageCabinet.getText("NotesLabel",_LanguageKey),_W - _W/36, grandTotalLabel.y + grandTotalLabel.height + _H/19.2,_FontArr[6],_H/45)
    	orderNote_main:setTextColor( 83/255, 20/255, 111/255 )
    	orderNote_main.anchorX = 1
    	orderDetailsGroup:insert(orderNote_main)
    	
    	orderNote_mainBg = display.newRect(orderNote_main.x + orderNote_main.width/2,orderNote_main.y - orderNote_main.height/2 - _H/192,orderNote_main.width + _W/27,orderNote_main.height + _H/96)
    	orderNote_mainBg:setFillColor( 1, 1, 1, 0.01 )
    	orderNote_mainBg.anchorY = 0
    	orderNote_mainBg.id = 0
    	orderNote_mainBg:addEventListener("touch",onShowProductNote)
    	orderDetailsGroup:insert(orderNote_mainBg)
    	
		orderNote_mainLine = display.newLine(orderNote_main.x ,orderNote_main.y + _H/110 , orderNote_main.x + orderNote_main.width,orderNote_main.y + _H/110)
        orderNote_mainLine:setStrokeColor( 83/255, 20/255, 111/255 )
		orderNote_mainLine.strokeWidth = 2
        orderDetailsGroup:insert(orderNote_mainLine)
           
        orderNote_main:toFront() 	
        orderNote_mainLine:toFront()
        
        AddToCartBtn = widget.newButton
		{
   	 		width = _W/1.08,
    		height = _H/16.13,
    		defaultFile = imageDirectory.."SinUp_Btn.png",
    		overFile = imageDirectory.."SinUp_Btn.png",
    		label = GBCLanguageCabinet.getText("RepeatOrderLabel",_LanguageKey),
    		labelColor = { default={ 1, 1, 1 }, over={ 1,1,1 } },
    		fontSize = _H/30,
    		font = _FontArr[6],
    		labelYOffset = _H/275,
    		onEvent = handleAddToCartButtonEvent
		}
		AddToCartBtn.x = _W/2
		AddToCartBtn.y = _H - _H/18.64
        orderDetailsGroup:insert(AddToCartBtn)
        
        local headers = {}
		
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		local body
		
		if( _LanguageKey == "en" ) then
			body = " ws=1&order_id=".._selectedOrderID
		else
			body = " ws=1&order_id=".._selectedOrderID.."&lang=".._LanguageKey
		end
		
		
		local params = {}
		params.headers = headers
		params.body = body
		params.timeout = 180
		
		local url = _WebLink.."orders-detail.php?"
		orderDetailsRequest = network.request( url, "POST", ViewMyOrderDetailNetworkListener, params )
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
        
        display.remove(header)
        header = nil
        
        display.remove(heading)
        heading = nil
        
        display.remove(backBtn)
        backBtn = nil
        
        display.remove(backBg)
        backBg = nil
        
        display.remove(placeOrderButton)
        placeOrderButton = nil
        
        display.remove(orderDetailsTableView)
        orderDetailsTableView = nil
        
        display.remove(noteBg)
        noteBg = nil
        
        display.remove(noteTextBox)
        noteTextBox = nil
        
        orderData = nil
        
        display.remove(orderDetailsGroup)
        orderDetailsGroup = nil
        
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
        if(orderDetailsRequest) then
        	network.cancel( orderDetailsRequest )
        	orderDetailsRequest = nil
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