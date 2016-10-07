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
local orderDetailsRequest,networkReqCount

--[[local orderData.items = {
	{ title = "Pane Casaresio", productID = 1,final_amount = 50, quantity = 2 , item_options = { {e_title = "Extra Cheese", e_price = 2.60}, {e_title = "Fresh Tomattos", e_price = 3}, {e_title = "Potato Chips", e_price = 5.00} }, Note = "Make it Spicy" },
	{ title = "Friselle", productID = 2, final_amount = 30,quantity = 1 ,item_options = { {e_title = "Extra Cheese", e_price = 4.60} } , Note = "Make it Spicy"},
	{ title = "Rosemary Bread", productID = 3, final_amount = 20,quantity = 1 ,item_options = { {e_title = "Extra Cheese", e_price = 2}, {e_title = "Fresh Tomattos", e_price = 2.60} , {e_title = "Potato Chips", e_price = 3.20} , {e_title = "Black Olives", e_price = 6} ,{e_title = "Garlic" , e_price = 2.60}}, Note = "Make is Sweet" },
	{ title = "Pasta Italiana", productID = 4,final_amount = 70, quantity = 1 ,item_options = { {e_title = "Extra Cheese" , e_price = 2.60}} , Note = "Make it Spicy"},
}]]--

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
        -- user begins editing textBox
        print( event.text )
        orderDetailsGroup.y = orderDetailsGroup.y - _H/2
        backBtn:toFront()    
		header:toFront()
		heading:toFront()
        

    elseif event.phase == "ended" then
        -- do something with textBox text
        print( event.target.text )
		orderDetailsGroup.y = yPos
    elseif event.phase == "editing" then
        print( event.newCharacters )
        print( event.oldText )
        print( event.startPosition )
        print( event.text )
    end
end

local function handlePlaceOrderButtonEvent( event )
	if( event.phase == "ended" ) then
		print("place order")
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
		print( "~~~~~~~~~~~"..digValue3 )
		
		total = total + (orderData.items[i].quantity * digValue3)
    	if(orderData.items[i].item_options) then	
    		for j = 1, #orderData.items[i].item_options do
    			roundDigit(orderData.items[i].item_options[j].sub_amount)
				print( "~~~~~~~~~~~"..digValue3 )
				
    			total = total + (orderData.items[i].quantity * digValue3)
    			totalAddOnValue = totalAddOnValue + 1
    		end
    	end
    	totalQuantity = totalQuantity + orderData.items[i].quantity
	end
	print("total is"..total)
	
	--[[roundDigit(s_tax)
	print( "s_tax :::: "..digValue3 )
	s_tax2 = digValue3
	
	roundDigit(o_tax)
	print( "o_tax :::: "..digValue3 )
	o_tax2 = digValue3]]--
	
	roundDigit(total)
	print( "total :::: "..digValue3 )
	total2 = digValue3
	
	local t = total2
	
	roundDigit(t)
	print( "grandTotal :::: "..digValue3 )
	grandTotal2 = digValue3
	
	grandTotal = grandTotal2
	
	totalItemLabel.text =  tostring(GBCLanguageCabinet.getText("TotalItemLabel",_LanguageKey))..tostring(totalQuantity)
	totalAddOnsLabel.text =  tostring(GBCLanguageCabinet.getText("TotalAddOnsLabel",_LanguageKey))..tostring(totalAddOnValue)
	--serviceTaxLabel.text = "Service Tax(5%) $"..tostring(s_tax)
	--otherTaxLabel.text = "Other Tax(7%) $"..tostring(o_tax)
	
	subtotalLabel.text =  tostring(GBCLanguageCabinet.getText("SubTotalLabel",_LanguageKey)).." $ "..make2Digit(total)
	grandTotalLabel.text =  tostring(GBCLanguageCabinet.getText("GrandTotalLabel",_LanguageKey)).." $ "..make2Digit(grandTotal)
	 
end

local function onDecrementTouch( event )
	if(event.phase == "began") then
		print(event.target.id.."decrement")
		orderData.items[event.target.id].quantity = tonumber(orderData.items[event.target.id].quantity) - 1
		
		
		local function onRemoveProduct( e ) 
			 if e.action == "clicked" then
        		local i = e.index
        		if i == 2 then
        			
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
    							rowHeight = _H/8.06 + ((#orderData.items[i].item_options - 1) * _H/20)
    						end
    		
    						orderDetailsTableView:insertRow{
    							rowHeight = rowHeight,
    							lineColor = { 1, 0, 0, 0 }
    						}
						end
					end
					timer.performWithDelay( 500, deleteProduct )
					
        		elseif i == 1 then
            		print("dont remove the product...")
        		end
    		end
			return true
		end
		
		if(orderData.items[event.target.id].quantity == 0) then
			
			local alert = native.showAlert( alertLabel,  tostring(GBCLanguageCabinet.getText("Item6Alert",_LanguageKey)), { "No", "Yes" }, onRemoveProduct )
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
		print(event.target.id.."increment")
		orderData.items[event.target.id].quantity = tonumber(orderData.items[event.target.id].quantity) + 1
		quantityArr[event.target.id].text = orderData.items[event.target.id].quantity
		reloadPrice()
		orderDetailsTableView:reloadData()
	end
	return true
end


function scene:resumeGame()
    --code to resume game
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
			
			print("Show Notes of product "..orderData.items[event.target.id].add_note)
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

    -- Get reference to the row group
    local row = event.row
	local i = row.index
    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
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
        		
    --[[decrementArr[i] = display.newImageRect(imageDirectory2.."descrement_Btn.png",_W/18.94,_H/33.68)
    decrementArr[i].x = quantityArr[i].x - _W/12
    decrementArr[i].y = quantityArr[i].y - quantityArr[i].height/2
    decrementArr[i].anchorY = 0
    decrementArr[i].id = i
    decrementArr[i]:addEventListener("touch",onDecrementTouch)
    row:insert(decrementArr[i])
        		
    incrementArr[i] = display.newImageRect(imageDirectory2.."Increment_Btn.png",_W/18.94,_H/33.68)
    incrementArr[i].x = quantityArr[i].x + _W/12
    incrementArr[i].y = quantityArr[i].y - quantityArr[i].height/2
    incrementArr[i].anchorY = 0
    incrementArr[i].id = i
    incrementArr[i]:addEventListener("touch",onIncrementTouch)
    row:insert(incrementArr[i])]]--
    
    roundDigit(tonumber(orderData.items[i].final_amount) )
    print( "%%%%%%%%%%%%%%%"..digValue3 )    
    
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
    	print( "############"..digValue3 )
    	
    	extraItemPrice[j] = display.newText("$ "..make2Digit(orderData.items[i].quantity * tonumber(digValue3)),_W - _W/36, extraItemArr[j].y,_FontArr[6],_H/40)
    	extraItemPrice[j]:setTextColor( 0 )
    	extraItemPrice[j].anchorX = 1
    	extraItemPrice[j].anchorY = 0
    	row:insert(extraItemPrice[j])
    	
    	
    end
      
    end 
       
    if(orderData.items[i].add_note == "" or orderData.items[i].add_note == nil or orderData.items[i].add_note == " ") then
    	
    	print("no notes in row "..i)
    
    else	
    	
    	orderNote[i] = display.newText( tostring(GBCLanguageCabinet.getText("NotesLabel",_LanguageKey)),_W/36, rowHeight * 0.85,_FontArr[6],_H/40)
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
    	print( "Network error!" )
    	
    	native.setActivityIndicator( false )
		
		networkReqCount = networkReqCount + 1
					
		if( networkReqCount > 3 ) then		
			
			local alert = native.showAlert( alertLabel,  tostring(GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey)), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		else
		
			if( _LanguageKey == "en" ) then
				local url = _WebLink.."orders-detail.php?%20ws=1&order_id=".._selectedOrderID
				local url2 = url:gsub(" ", "%%20")
				orderDetailsRequest = network.request( url2, "GET", ViewMyOrderDetailNetworkListener )
			else	
				local url = _WebLink.."orders-detail.php?%20ws=1&order_id=".._selectedOrderID.."&lang=".._LanguageKey
				local url2 = url:gsub(" ", "%%20")
				orderDetailsRequest = network.request( url2, "GET", ViewMyOrderDetailNetworkListener )
			end	
				
			
			native.setActivityIndicator( true )
        
		end	
	else	
		timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
			print("order Details resposne: "..event.response)
		if(event.response == "0" or event.response == 0) then
			
			local alert = native.showAlert( alertLabel,  tostring(GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey)), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif(event.response == "1" or event.response == 1) then
			
			local alert = native.showAlert( alertLabel,  tostring(GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey)), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif(event.response == "2" or event.response == 2) then
			
			local alert = native.showAlert( alertLabel,  tostring(GBCLanguageCabinet.getText("Order1Alert",_LanguageKey)), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif(event.response == "3" or event.response == 3) then
			
			local alert = native.showAlert( alertLabel,  tostring(GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey)), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif(event.response == "4" or event.response == 4) then
			
			local alert = native.showAlert( alertLabel,  tostring(GBCLanguageCabinet.getText("Order1Alert",_LanguageKey)), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		else
		
			orderData = json.decode(event.response)
			
			
			for i = 1, #orderData.items do
			if(orderData.items[i].item_options) then
        	if(#orderData.items[i].item_options < 2) then
        		print("only 2 item")
    			rowHeight = _H/8.06
    		else
    			print("more items")
    			
    			rowHeight = _H/8.06 + ((#orderData.items[i].item_options - 1) * _H/20)
    		end
    		else
    			rowHeight = _H/8.06
    		end
    		orderDetailsTableView:insertRow{
    		
    			rowHeight = rowHeight,
    			lineColor = { 1, 0, 0, 0 }
    			
    		}
    		
    		roundDigit(tonumber(orderData.items[i].item_amount))
    		print( "$$$$$$$$$$"..digValue3 )
    		
    		total = total + (orderData.items[i].quantity * tonumber(digValue3))
    		if(orderData.items[i].item_options) then
    		
    		for j = 1, #orderData.items[i].item_options do
    		
    			roundDigit(orderData.items[i].item_options[j].sub_amount)
    			print( "~~~~~~~~~"..digValue3 )
    		
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
			print("Item loop"..i)
			CartRepeatFlag = 0
			extraItemArr = {}
			for k = 1,#_CartArray do
				if(_CartArray[k].productID == orderData.items[i].item_id) then
					CartRepeatFlag = CartRepeatFlag - 1
				else
					CartRepeatFlag = CartRepeatFlag + 1
				end
			end		
		
		print(CartRepeatFlag.."//"..#_CartArray)
		if(CartRepeatFlag == #_CartArray) then
			if(orderData.items[i].item_options_id == "" or orderData.items[i].item_options_id == nil or orderData.items[i].item_options_id == " ") then
				extraItemArr = {}
			else
				extraItemArr = orderData.items[i].item_options
			end
    		_CartArray[#_CartArray + 1] = { kitchenID = orderData.items[i].kitchen_id,title = orderData.items[i].item_name ,productID = orderData.items[i].item_id ,price = orderData.items[i].item_amount,discount = discountValue,variety_id = orderData.items[i].item_variety_id ,quantity = orderData.items[i].quantity, extraItems = extraItemArr, Note = orderData.items[i].add_note}
    		print(#_CartArray)
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
									print("repeat option")
									flag = 1
									break
								else
									flag = 0
								end
							end
							if(flag == 0) then
								print("new option")
								extraItemArr[#extraItemArr + 1] = _CartArray[j].extraItems[m]
							end
						end
					else
					
					end
					local q = tonumber(orderData.items[i].quantity) + _CartArray[j].quantity
    				_CartArray[j] = { kitchenID = orderData.items[i].kitchen_id,title = orderData.items[i].item_name ,productID = orderData.items[i].item_id ,price = orderData.items[i].item_amount,discount = discountValue,variety_id = orderData.items[i].item_variety_id ,quantity = q , extraItems = extraItemArr, Note = orderData.items[i].add_note}
					print(#_CartArray..q)
				end
			end
			
		end
		
		
		end
		
		local alert = native.showAlert( alertLabel,  tostring(GBCLanguageCabinet.getText("Item4Alert",_LanguageKey)), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
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
        
        print("Order details page ........................................")
        total = 0
        totalQuantity = 0
        grandTotal = 0
        discountValue = 0
        networkReqCount = 0
       -- s_tax = 2.99
       -- o_tax = 7.99
        
        header = display.newImageRect( imageDirectory.."f_Header.png", _W, _H/13.61 )
        header.x = _W/2
        header.y = _H/27
        sceneGroup:insert( header )
        
        heading = display.newText(  tostring(GBCLanguageCabinet.getText("OrderDetailsLabel",_LanguageKey)), header.x, header.y, _FontArr[30], _H/36.76 )
        heading:setFillColor( 1 )
        sceneGroup:insert( heading )
        --[[
        backBtn = display.newImageRect( imageDirectory.."Back_Btn.png", _W/15.42, _H/33.10 )
        backBtn.x = _W/13.5
        backBtn.y = header.y
        sceneGroup:insert( backBtn )
       			
		backBg = display.newRect( backBtn.x, backBtn.y, backBtn.width + _W/21.6, backBtn.height + _H/38.4 )
		backBg:setFillColor( 83/255, 20/255, 111/255 )
		backBg:addEventListener( "tap", handleBackButtonEvent )
		backBg:addEventListener( "touch", handleBackButtonEventTouch )
		sceneGroup:insert( backBg )
		backBtn:toFront()
		]]--
		
	backBtn = widget.newButton
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
        
      --[[  roundDigit(s_tax)
		print( "@@@@@@@@@"..digValue3 )
		s_tax2 = digValue3
		
		roundDigit(o_tax)
		print( "!!!!!!!!!!!"..digValue3 )
		o_tax2 = digValue3]]--
		
		roundDigit(total)
		print( "&&&&&&&&&&"..digValue3 )
		total2 = digValue3
		
		local t = total2 
		roundDigit(t)
		print( "grand total is ::::: "..digValue3 )
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
        
        orderSummaryLabel = display.newText( tostring(GBCLanguageCabinet.getText("OrderSummaryLabel",_LanguageKey)),_W/36, orderSummaryBg.y + _H/96,_FontArr[6],_H/35)
        orderSummaryLabel.anchorX = 0
        orderSummaryLabel.anchorY = 0
        orderSummaryLabel:setTextColor( 83/255, 20/255, 111/255 )
        orderDetailsGroup:insert(orderSummaryLabel)
        
        
        totalItemLabel = display.newText( tostring(GBCLanguageCabinet.getText("TotalItemLabel",_LanguageKey)).." "..totalQuantity ,orderSummaryLabel.x, orderSummaryLabel.y + orderSummaryLabel.height + _H/384,_FontArr[6],_H/45)
        totalItemLabel.anchorX = orderSummaryLabel.anchorX
        totalItemLabel.anchorY = 0
        totalItemLabel:setTextColor( 0 )
        orderDetailsGroup:insert(totalItemLabel)
        
        totalAddOnsLabel = display.newText( tostring(GBCLanguageCabinet.getText("TotalAddOnsLabel",_LanguageKey)).." " ,orderSummaryLabel.x, totalItemLabel.y + totalItemLabel.height + _H/384,_FontArr[6],_H/45)
        totalAddOnsLabel.anchorX = orderSummaryLabel.anchorX
        totalAddOnsLabel.anchorY = 0
        totalAddOnsLabel:setTextColor( 0 )
        orderDetailsGroup:insert(totalAddOnsLabel)
        
        --[[serviceTaxLabel = display.newText("Service Tax(5%) $"..s_tax ,subtotalLabel.x, subtotalLabel.y + subtotalLabel.height + _H/384,_FontArr[6],_H/50)
        serviceTaxLabel.anchorX = subtotalLabel.anchorX
        serviceTaxLabel.anchorY = 0
        serviceTaxLabel:setTextColor( 0,0,0,0.5 )
        orderDetailsGroup:insert(serviceTaxLabel)]]--
        
        --[[otherTaxLabel = display.newText("Other Tax(7%) $"..o_tax ,subtotalLabel.x, subtotalLabel.y + subtotalLabel.height + _H/384,_FontArr[6],_H/50)
        otherTaxLabel.anchorX = subtotalLabel.anchorX
        otherTaxLabel.anchorY = 0
        otherTaxLabel:setTextColor( 0,0,0,0.5 )
        orderDetailsGroup:insert(otherTaxLabel)]]--
        
        subtotalLabel = display.newText( tostring(GBCLanguageCabinet.getText("SubTotalLabel",_LanguageKey)).." $ "..make2Digit(total),orderSummaryLabel.x, totalAddOnsLabel.y + totalAddOnsLabel.height + _H/384,_FontArr[6],_H/40)
        subtotalLabel.anchorX = 0
        subtotalLabel.anchorY = 0
        subtotalLabel:setTextColor( 206/255, 23/255, 100/255 )
        orderDetailsGroup:insert(subtotalLabel)
        
        grandTotalLabel = display.newText( tostring(GBCLanguageCabinet.getText("GrandTotalLabel",_LanguageKey)).." $ "..make2Digit(grandTotal) ,subtotalLabel.x, subtotalLabel.y + subtotalLabel.height + _H/96,_FontArr[6],_H/35)
        grandTotalLabel.anchorX = subtotalLabel.anchorX
        grandTotalLabel.anchorY = 0
        grandTotalLabel:setTextColor( 206/255, 23/255, 100/255 )
        orderDetailsGroup:insert(grandTotalLabel)
        
        
        orderNote_main = display.newText( tostring(GBCLanguageCabinet.getText("NotesLabel",_LanguageKey)),_W - _W/36, grandTotalLabel.y + grandTotalLabel.height + _H/19.2,_FontArr[6],_H/45)
    	orderNote_main:setTextColor( 83/255, 20/255, 111/255 )
    	orderNote_main.anchorX = 1
    	orderDetailsGroup:insert(orderNote_main)
    	
    	orderNote_mainBg = display.newRect(orderNote_main.x - orderNote_main.width/2,orderNote_main.y - orderNote_main.height/2 - _H/192,orderNote_main.width + _W/27,orderNote_main.height + _H/96)
    	orderNote_mainBg:setFillColor( 1, 1, 1, 0.01 )
    	orderNote_mainBg.anchorY = 0
    	orderNote_mainBg.id = 0
    	orderNote_mainBg:addEventListener("touch",onShowProductNote)
    	orderDetailsGroup:insert(orderNote_mainBg)
    	
		orderNote_mainLine = display.newLine(orderNote_main.x - orderNote_main.width,orderNote_main.y + _H/110 , orderNote_main.x ,orderNote_main.y + _H/110)
        orderNote_mainLine:setStrokeColor( 83/255, 20/255, 111/255 )
		orderNote_mainLine.strokeWidth = 3
        orderDetailsGroup:insert(orderNote_mainLine)
           
        orderNote_main:toFront() 	
        orderNote_mainLine:toFront()
        
        AddToCartBtn = widget.newButton
		{
   	 		width = _W/1.08,
    		height = _H/16.13,
    		defaultFile = imageDirectory.."SinUp_Btn.png",
    		overFile = imageDirectory.."SinUp_Btn.png",
    		label =  tostring(GBCLanguageCabinet.getText("RepeatOrderLabel",_LanguageKey)),
    		labelColor = { default={ 1, 1, 1 }, over={ 1,1,1 } },
    		fontSize = _H/30,
    		font = _FontArr[6],
    		labelYOffset = _H/275,
    		-- FONT AND FONT SIZE 
    		onEvent = handleAddToCartButtonEvent
		}
		AddToCartBtn.x = _W/2
		AddToCartBtn.y = _H - _H/18.64
        orderDetailsGroup:insert(AddToCartBtn)
        
        
        --[[noteBg = display.newImageRect(imageDirectory2.."NotesBg.png",_W,_H/8.64)
        noteBg.x = _W/2
        noteBg.y = _H - _H/9.45
        noteBg.anchorY = 1
        orderDetailsGroup:insert(noteBg)
        
		noteTextBox = native.newTextBox( noteBg.x, noteBg.y - noteBg.height/2, noteBg.width - _W/54, noteBg.height - _H/48 )
		noteTextBox.placeholder = "Add notes for your order"
		noteTextBox.isEditable = true
		noteTextBox.font = native.newFont( _FontArr[41],_H/45  )
		noteTextBox:addEventListener( "userInput", inputListener )
        orderDetailsGroup:insert(noteTextBox)
        
        
        placeOrderButton = widget.newButton
		{
   	 		width = _W/1.08,
    		height = _H/16.13,
    		defaultFile = imageDirectory2.."Send_Btn2.png",
    		overFile = imageDirectory2.."Send_Btn2.png",
    		label = "SEND ORDER TO KITCHEN",
    		labelColor = { default={ 1, 1, 1 }, over={ 1,1,1 } },
    		fontSize = _H/30,
    		font = _FontArr[6],
    		labelYOffset = _H/275,
    		-- FONT AND FONT SIZE 
    		onEvent = handlePlaceOrderButtonEvent
		}
		placeOrderButton.x = _W/2
		placeOrderButton.y = _H - _H/18.64
        orderDetailsGroup:insert(placeOrderButton)
        
        yPos = orderDetailsGroup.y]]--
        
        --[[local headers = {}
		
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		
		local body = " ws=1&order_id=".._selectedOrderID
		
		local params = {}
		params.headers = headers
		params.body = body
		params.timeout = 180
		
		local url = _WebLink.."orders-detail.php?"
		print( url..body )
		orderDetailsRequest = network.request( url, "POST", ViewMyOrderDetailNetworkListener, params )]]--
		
		if( _LanguageKey == "en" ) then
		
			local url = _WebLink.."orders-detail.php?%20ws=1&order_id=".._selectedOrderID
			local url2 = url:gsub(" ", "%%20")
			orderDetailsRequest = network.request( url2, "GET", ViewMyOrderDetailNetworkListener )
		else
			local url = _WebLink.."orders-detail.php?%20ws=1&order_id=".._selectedOrderID.."&lang=".._LanguageKey
			local url2 = url:gsub(" ", "%%20")
			orderDetailsRequest = network.request( url2, "GET", ViewMyOrderDetailNetworkListener )
		
		end
		
		
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
        
        
        --display.remove()
        --noteTextBox = nil
        
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