local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------
local imageDirectory = "images/SignUp/"
local imageDirectory2 = "images/PlaceOrder/"
local imageDirectory3 = "images/MainMenu/"
local imageDirectory4 = "images/Product/"

local defaultPhoto = { }
local image = { }
local ordersBg = { } 
local quantityArr = { }
local incrementArr = { }
local decrementArr = { }
local editBtnArr = { }
local orderName = { }
local orderPrice = { }
local extraItemArr = { }
local extraItemPrice = { }
local varietyNameArr = { }
local varietyNamePrice = { }
local orderNote = { }
local orderNoteBg = { }
local placeOrderArr = { }
local changedProductIdArr = { }
local changedProductVarietyIdArr = { } 
local changedProductPriceArr = { }
local allergyValue,takeAwayOrderFlag
local placeOrderButton,noteBg,noteTextBox,placeOrderScrollView,header,heading,backBg,backBtn,orderSummaryBg,orderSummaryDevider,orderSummaryLabel,subtotalLabel
local total,totalQuantity,grandTotal,s_tax,o_tax,totalAddOnValue, s_tax2, o_tax2, total2, grandTotal2
local placeOrderGroup,yPos
local placeOrderRequest1,placeOrderRequest2


local function onDoNothing()

	return true
end

function reloadPrice()
	total = 0
	totalQuantity = 0
	grandTotal = 0
	totalAddOnValue = 0
	
	for i = 1,#_CartArray do
		roundDigit(tonumber(_CartArray[i].price))
		
		total = total + (_CartArray[i].quantity * tonumber(digValue3))
    		
    	for j = 1, #_CartArray[i].extraItems do
    		roundDigit(_CartArray[i].extraItems[j].sub_amount)
    		total = total + (_CartArray[i].quantity * digValue3)
    		totalAddOnValue = totalAddOnValue + 1	
    	end
    		
    	totalQuantity = totalQuantity + _CartArray[i].quantity
	end
	
	roundDigit(s_tax)
	s_tax2 = digValue3
	
	roundDigit(o_tax)
	o_tax2 = digValue3
	
	roundDigit(total)
	total2 = digValue3
	
	local t = total2 + s_tax2 + o_tax2
	
	roundDigit(t)
	grandTotal2 = digValue3
	
	grandTotal = grandTotal2
	
	grandTotalLabel.text = GBCLanguageCabinet.getText("GrandTotalLabel",_LanguageKey).." $ "..make2Digit(grandTotal)
	 
end

local function handleBackButtonEvent( event )
	composer.gotoScene( "menu" )
	
	return true
end

local function handleBackButtonEventTouch( event )
	if event.phase == "ended" then
		local previous = composer.getSceneName( "previous" )
		if(composer.getSceneName("previous") == "stripeRegistration" or composer.getSceneName( "previous" ) == "ProvidePin" or composer.getSceneName( "previous" ) == "cardSelection"  ) then
			composer.gotoScene( "menu" )
		else
			composer.gotoScene( previous )
		end
	end

	return true
end

local function inputListener( event )
    if event.phase == "began" then
        placeOrderGroup.y = placeOrderGroup.y - _H/2
		header:toFront()
		heading:toFront()
		backBtn:toFront()  
        

    elseif event.phase == "ended" or event.phase == "submitted" then
		placeOrderGroup.y = yPos
		
    elseif event.phase == "editing" then
        
    end
end

local function handleOk( event )
	composer.gotoScene( composer.getSceneName( "previous" ) )

	return true
end

function scene:resumeGame()
    if(noteTextBox) then
    	noteTextBox.isVisible = true
    end
    return true
end

local function makeChanges()
	for j = 1,#changedProductIdArr do
	
	for i = 1,#_CartArray do
	
		if(_CartArray[i].productID == changedProductIdArr[j] and _CartArray[i].variety_id == changedProductVarietyIdArr[j]) then
			_CartArray[i] = { kitchenID = _CartArray[i].kitchenID,title = _CartArray[i].title ,productID = _CartArray[i].productID,price = changedProductPriceArr[j],discount = _CartArray[i].discount,variety_id =  _CartArray[i].variety_id, quantity = _CartArray[i].quantity, extraItems = _CartArray[i].extraItems, Note = _CartArray[i].Note}
			
			placeOrderTableView:reloadData()
			reloadPrice()
		end
		
	end
	
	end
end

local function onChnagedProductPrice( event )
if event.action == "clicked" then
	
	makeChanges()
	
    local i = event.index
    if i == 1 then
        placeOrderArr = { }
		
	if(#_CartArray > 0) then
		options_ID_Str = ""
		options_Total_Amount = 0
		
		for i = 1, #_CartArray do	
			local finalPrice = 0
			local itemAmount = 0
			if(_CartArray[i].extraItems) then
				options_ID_Str = ""
				options_Total_Amount = 0
				if(#_CartArray[i].extraItems > 0) then
				for j = 1, #_CartArray[i].extraItems do
					if(j == 1) then
						options_ID_Str = _CartArray[i].extraItems[j].item_option_sub_id
						options_Total_Amount = tonumber(_CartArray[i].extraItems[j].sub_amount)
					else
						options_ID_Str = options_ID_Str..",".._CartArray[i].extraItems[j].item_option_sub_id
						options_Total_Amount = options_Total_Amount + tonumber(_CartArray[i].extraItems[j].sub_amount)
					end
				end
				end
			else
				options_ID_Str = ""
				options_Total_Amount = 0
			end
			
			finalPrice = roundDigit( (tonumber(_CartArray[i].price) + tonumber(options_Total_Amount)* _CartArray[i].quantity))
			itemAmount = roundDigit(tonumber(_CartArray[i].price))
			local discount = "0"
			local itemNote = ""
			itemNote = tostring(_CartArray[i].Note):gsub( "&", "%%26" )
			placeOrderArr[#placeOrderArr + 1] = { item_id = _CartArray[i].productID,kitchen_id = _CartArray[i].kitchenID ,item_options_id = options_ID_Str,item_variety_id = _CartArray[i].variety_id,item_quantity = _CartArray[i].quantity,item_amount = itemAmount,item_options_amount = options_Total_Amount,item_discount = discount,final_amount = finalPrice,item_note = itemNote  }
			
		end
		
		local tab = json.encode(placeOrderArr)
		local noteTextBoxValue
		if(noteTextBox) then
			noteTextBoxValue = noteTextBox.text:gsub( "&", "%%26" )
		else
			noteTextBoxValue = ""
		end	
		
		_PlaceOrderBody = "ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&items="..tab.."&table_location=".._TableNumber.."&grand_total="..grandTotal.."&order_note="..noteTextBoxValue.."&allergies="..allergyValue
		_PlaceOrderTotal = grandTotal
		
		local headers = {}
		
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		
		local body = "ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&items="..tab.."&table_location=".._TableNumber.."&grand_total="..grandTotal.."&order_note="..noteTextBoxValue.."&allergies="..allergyValue
		
		local params = {}
		params.headers = headers
		params.body = body
		params.timeout = 180
		
		local url = _WebLink.."place-order.php?"
		
		placeOrderRequest1 = network.request( url, "POST", placeOrdersNetworkListener, params )
		native.setActivityIndicator( true )
		
	else
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Item5Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
	end
    
    elseif i == 2 then
    	
    end
    
end
return true
end

function placeOrdersNetworkListener( event )
	if ( event.isError ) then
				
    	timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
				
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				
	else	
		timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		
		if(event.phase == "ended") then
		
		if( event.response == "0" or event.response == 0 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("6Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		elseif( event.response == "1" or event.response == 1 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		elseif( event.response == "2" or event.response == 2 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		elseif( event.response == "3" or event.response == 3 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif( event.response == "4" or event.response == 4 ) then 
			local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("Item1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif( event.response == "5" or event.response == 5 ) then 
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Item2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif( event.response == "6" or event.response == 6 ) then 
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Item3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		else
			
			changedData = json.decode( event.response )
			
			if(#changedData > 0) then
		
			changedProductIdArr = { }
			changedProductVarietyIdArr = { }
			changedProductPriceArr = { }
			
			local k = 1
			if(#changedData > 0) then
				for i = 1, #changedData do
					if(tonumber(changedData[i].item_amount) == tonumber(changedData[i].item_new_price)) then
						
					else
						changedProductIdArr[k] = changedData[i].item_id
						changedProductVarietyIdArr[k] = changedData[i].item_variety_id
						changedProductPriceArr[k] = changedData[i].item_new_price
						
						k = k + 1
					end
				end
			end
			
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("7Alert",_LanguageKey), { GBCLanguageCabinet.getText("continueLabel",_LanguageKey),GBCLanguageCabinet.getText("reviewLabel",_LanguageKey) }, onChnagedProductPrice )
		
		
			else
			
			for i = 1, #_CartArray do
				
			end
			
			_OrderID = changedData.order_id
			
			if(_StripeCustomerID) then
				composer.gotoScene( "ProvidePin" )
			else
				composer.gotoScene( "stripeRegistration" )
			end
			
			end
		end
		end
		
	end
	return true
end

local function handlePlaceOrderButtonEvent( event )
	if( event.phase == "ended" ) then
		
    	native.setActivityIndicator( true )
		
		placeOrderArr = { }
		
	if(#_CartArray > 0) then
	options_ID_Str = ""
	options_Total_Amount = 0
	
	for i = 1, #_CartArray do	
		local finalPrice = 0
		local itemAmount = 0
		if(_CartArray[i].extraItems) then
			options_ID_Str = ""
			options_Total_Amount = 0
			if(#_CartArray[i].extraItems > 0) then
			for j = 1, #_CartArray[i].extraItems do
				if(j == 1) then
					options_ID_Str = _CartArray[i].extraItems[j].item_option_sub_id
					options_Total_Amount = tonumber(_CartArray[i].extraItems[j].sub_amount)
				else
					options_ID_Str = options_ID_Str..",".._CartArray[i].extraItems[j].item_option_sub_id
					options_Total_Amount = options_Total_Amount + tonumber(_CartArray[i].extraItems[j].sub_amount)
				end
			end
			end
		else
			options_ID_Str = ""
			options_Total_Amount = 0
		end
		finalPrice = roundDigit( (tonumber(_CartArray[i].price) + tonumber(options_Total_Amount)* _CartArray[i].quantity))
		itemAmount = roundDigit(tonumber(_CartArray[i].price))
		local discount = "0"
		local itemNote = ""
		itemNote = tostring(_CartArray[i].Note):gsub( "&", "%%26" )
		placeOrderArr[#placeOrderArr + 1] = { item_id = _CartArray[i].productID,kitchen_id = _CartArray[i].kitchenID ,item_options_id = options_ID_Str,item_variety_id = _CartArray[i].variety_id,item_quantity = _CartArray[i].quantity,item_amount = itemAmount,item_options_amount = options_Total_Amount,item_discount = discount,final_amount = finalPrice,item_note = itemNote  }
		
	end	
	
	local tab = json.encode(placeOrderArr)
	local noteTextBoxValue
	
	if(noteTextBox) then
		noteTextBoxValue = noteTextBox.text:gsub( "&", "%%26" )
	else
		noteTextBoxValue = ""
	end
	
	if( _Alleregy ) then
		allergyValue = _Alleregy:gsub( "&", "%%26" )
	else
		allergyValue = ""
	end
	_PlaceOrderBody = "ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&items="..tab.."&table_location=".._TableNumber.."&grand_total="..grandTotal.."&order_note="..noteTextBoxValue.."&allergies="..allergyValue
	_PlaceOrderTotal = grandTotal
	
	
local function BeaconDataForTableNetworkListener( event )
	if ( event.isError ) then
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
        local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey) , { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing  )
    else
		
		if( event.response == 0 or event.response == "0" ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey) , { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing  )
        	
        elseif( event.response == 1 or event.response == "1" ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey) , { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing  )
        	
        elseif( event.response == 2 or event.response == "2" ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey) , { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing  )

        elseif( event.response == 3 or event.response == "3" ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey) , { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing  )
        	
		else
			tableData = json.decode( event.response )
			
			if(tableData) then
				_TableNumber = tableData.table_name
				
				local headers = {}
		
				headers["Content-Type"] = "application/x-www-form-urlencoded"
				headers["Accept-Language"] = "en-US"
		
				local body = "ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&items="..tab.."&table_location=".._TableNumber.."&grand_total="..grandTotal.."&order_note="..noteTextBoxValue.."&allergies="..allergyValue
		
				local params = {}
				params.headers = headers
				params.body = body
				params.timeout = 180
		
				local url = _WebLink.."place-order.php?"
		
				placeOrderRequest2 = network.request( url, "POST", placeOrdersNetworkListener, params )
				native.setActivityIndicator( true )
				
			else
			
			end
		end
	end
	return true
end      

local function fetchTabelNameFunc()
		local headers = {}
		
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		
		local body = "beacon_major=".._majorBea.."&beacon_minor=".._minorBea
		local params = {}
		params.headers = headers
		params.body = body
		params.timeout = 180
		
		local url2 = _WebLink.."table-find.php?"
		menuRequest = network.request( url2, "POST", BeaconDataForTableNetworkListener, params )
end

local function onGoBack( event )
	os.exit()
	
	return true
end

local function onChooseOrderTypeFunc( event )
	if event.action == "clicked" then
        local i = event.index
        if i == 1 then
			_TableNumber = "Takeaway"
			local headers = {}
			
			headers["Content-Type"] = "application/x-www-form-urlencoded"
			headers["Accept-Language"] = "en-US"
			
			local body = "ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&items="..tab.."&table_location=Takeaway&grand_total="..grandTotal.."&order_note="..noteTextBoxValue.."&allergies="..allergyValue
			
			local params = {}
			params.headers = headers
			params.body = body
			params.timeout = 180
			
			local url = _WebLink.."place-order.php?"
			
			placeOrderRequest2 = network.request( url, "POST", placeOrdersNetworkListener, params )
			native.setActivityIndicator( true )
			
        elseif i == 2 then
        	_Flag = true
        	
			timer.performWithDelay( 200, function()
				iBeacon.allocateBluetoothInstance( listener )
				iBeacon.getBluetoothStatues( listener )
			end )
			
			timer.performWithDelay( 4000, function()
				if iBeaconRunning then
					iBeacon.getBeacons( listener )
				else
					
				end
			end )
			
			local function onSelectOrderType( event )
				if event.action == "clicked" then
					local i = event.index
					if i == 1 then
						_TableNumber = "Takeaway"
						local headers = {}
			
						headers["Content-Type"] = "application/x-www-form-urlencoded"
						headers["Accept-Language"] = "en-US"
			
						local body = "ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&items="..tab.."&table_location=Takeaway&grand_total="..grandTotal.."&order_note="..noteTextBoxValue.."&allergies="..allergyValue
			
						local params = {}
						params.headers = headers
						params.body = body
						params.timeout = 180
			
						local url = _WebLink.."place-order.php?"
			
						placeOrderRequest2 = network.request( url, "POST", placeOrdersNetworkListener, params )
						native.setActivityIndicator( true )
						
					elseif i == 2 then						
						local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Order3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onGoBack  )
	
					end
					
				end
				
				return true
			end  
			
			timer.performWithDelay( 8000, function ()
				if(_majorBea == nil or _majorBea == "" or _minorBea == "" or _minorBea == nil ) then
					timer.performWithDelay( 200, function() 
					native.setActivityIndicator( false )
					end )
					
					if _StopTimerFlag == false then
						local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Order4Alert",_LanguageKey), { GBCLanguageCabinet.getText("YesLabel",_LanguageKey),GBCLanguageCabinet.getText("NoLabel",_LanguageKey) }, onSelectOrderType  )
					else
						
					end
					
				else
					timer.performWithDelay( 200, function() 
					native.setActivityIndicator( false )
					end )
					
					if _StopTimerFlag == false then
						fetchTabelNameFunc()
					else
						
					end
					
				end
			end)
			
        end
    end
    return true
end

local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Order4Alert",_LanguageKey), { GBCLanguageCabinet.getText("YesLabel",_LanguageKey),GBCLanguageCabinet.getText("NoLabel",_LanguageKey) }, onChooseOrderTypeFunc  )

	else
		
		timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("NoItemsLabel",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
	end
	
	end
	return true
end

local function onDecrementTouch( event )
	if(event.phase == "began") then
		
		_CartArray[event.target.id].quantity = tonumber(_CartArray[event.target.id].quantity) - 1
		
		local function onRemoveProduct( e ) 
			 if e.action == "clicked" then
        		local i = e.index
        		if i == 1 then
        			
            		placeOrderTableView:deleteRow(event.target.id)
					table.remove(_CartArray,event.target.id)					
					
					local function deleteProduct()
						reloadPrice()
						placeOrderTableView:deleteAllRows()
						for i = 1, #_CartArray do
        					if(#_CartArray[i].extraItems < 2) then
    							rowHeight = _H/2.95
    						else
    							rowHeight = _H/2.95 + ((#_CartArray[i].extraItems - 1) * _H/32)
    						end
    		
    						placeOrderTableView:insertRow{
    							rowHeight = rowHeight,
    							lineColor = { 1, 0, 0, 0 }
    						}
						end
					end
					timer.performWithDelay( 500, deleteProduct )
					
        		elseif i == 2 then
            		_CartArray[event.target.id].quantity = tonumber(_CartArray[event.target.id].quantity) + 1
        		end
    		end
			return true
		end
		
		if(_CartArray[event.target.id].quantity == 0) then
		
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Item6Alert",_LanguageKey), { GBCLanguageCabinet.getText("YesLabel",_LanguageKey),GBCLanguageCabinet.getText("NoLabel",_LanguageKey) }, onRemoveProduct )
		else
			quantityArr[event.target.id].text = _CartArray[event.target.id].quantity	
			reloadPrice()
			placeOrderTableView:reloadData()
		end
		
	end
	return true
end

local function onIncrementTouch( event )
	if(event.phase == "began") then
		_CartArray[event.target.id].quantity = tonumber(_CartArray[event.target.id].quantity) + 1
		quantityArr[event.target.id].text = _CartArray[event.target.id].quantity
		reloadPrice()
		placeOrderTableView:reloadData()
	end
	return true
end

function scene:resumeGame()
    if(noteTextBox) then
    	noteTextBox.isVisible = true
    end
    return true
end

local function onShowProductNote( event )
	if(event.phase == "began") then
		if(noteTextBox) then
			noteTextBox.isVisible = false
		end
		local option = {
			params = {
				noteValue = _CartArray[event.target.id].Note
			}
		}
		composer.showOverlay( "NoteOverlay", option )
		
	end
	return true
end

local function handleEditButtonEvent( event )
	_selectedProductID = event.target.id
	for i = 1, #_CartArray do
		if _CartArray[i].productID == _selectedProductID then
			_EditProductDetails = _CartArray[i]
			break
		end
	end
	
	_EditFlag = true
	composer.gotoScene( "Product" )
	
	return true
end

local function onRowRender( event )
    local row = event.row
	local i = row.index
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth
    
	extraItemArr = { }
	extraItemPrice = { }
	varietyNameArr = { }
	varietyNamePrice = { }

    ordersBg[i] = display.newImageRect(imageDirectory2.."OrderRowBg.png",_W,rowHeight)
    ordersBg[i].x = _W/2
    ordersBg[i].y = rowHeight * 0.5
    row:insert(ordersBg[i])
    
    local s = _CartArray[i].title
   	
	local imagePath = system.pathForFile( "Product".._CartArray[i].productID..".png", system.TemporaryDirectory )
	local imageFile = io.open( imagePath, "r" )
	defaultPhoto[i] = display.newImageRect(imageDirectory3.."ProductBg.png", _W/2.04, _H/4.86)
	defaultPhoto[i].x = _W/36 + defaultPhoto[i].width/2
	defaultPhoto[i].y = defaultPhoto[i].height/2 + _H/96
	row:insert( defaultPhoto[i] )
	
	if imageFile then
		
		image[i] = display.newImage("Product".._CartArray[i].productID..".png", system.TemporaryDirectory)
		image[i].x = defaultPhoto[i].x
		image[i].y = defaultPhoto[i].y
		image[i].width = defaultPhoto[i].height/(image[i].height/image[i].width)
		image[i].height = defaultPhoto[i].height
		
		if( image[i].width > defaultPhoto[i].width ) then
			image[i].width = defaultPhoto[i].width
		else
		
		end
		row:insert( image[i] )
		
		image[i]:toFront()
	end
    
    orderName[i] = display.newText("",_W/36, defaultPhoto[i].y + defaultPhoto[i].height/2 + _H/96,_W/2,_H/30,_FontArr[6],_H/30)
    orderName[i]:setTextColor( 83/255, 20/255, 111/255 )
    orderName[i].text = s
    orderName[i].anchorX = 0
    orderName[i].anchorY = 0
    row:insert(orderName[i])
        		
    quantityArr[i] = display.newText("",_W/2 + _W/6, rowHeight * 0.25,_FontArr[6],_H/30)
    quantityArr[i]:setTextColor( 83/255, 20/255, 111/255 )
    quantityArr[i].text = _CartArray[i].quantity
    row:insert(quantityArr[i])
        		
    decrementArr[i] = display.newImageRect(imageDirectory2.."descrement_Btn.png",_W/18.94,_H/33.68)
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
    row:insert(incrementArr[i])
    
    editBtnArr[i] = widget.newButton(
	{
		width = _W/5.5,
		height = _H/28.23,
		id = _CartArray[i].productID,
		defaultFile = imageDirectory4.."unSelected_CheckBox1.png",
		overFile = imageDirectory4.."unSelected_CheckBox1.png",
		label = GBCLanguageCabinet.getText("EditLabel",_LanguageKey),
		labelYOffset = _H/275,
		font = _FontArr[6],
		fontSize = _H/40,
		labelColor = { default={1,1,1,1}, over={1,1,1,1} }
	}
	)
	editBtnArr[i].x = quantityArr[i].x
	editBtnArr[i].y = decrementArr[i].y + decrementArr[i].height + editBtnArr[i].height/2 + _H/38.4
	editBtnArr[i]:addEventListener( "tap", handleEditButtonEvent )
	row:insert(editBtnArr[i])
    
    local a = 0
    for j = 1, #_CartArray[i].extraItems do
    	a = a + (tonumber(_CartArray[i].extraItems[j].sub_amount))
    end
    roundDigit(tonumber(_CartArray[i].price) + tonumber(a))
    
    orderPrice[i] = display.newText(make2Digit(tonumber(_CartArray[i].quantity) * tonumber(digValue3)),_W - _W/36, rowHeight * 0.25,_FontArr[6],_H/30)
    orderPrice[i]:setTextColor( 206/255, 23/255, 100/255 )
    orderPrice[i].anchorX = 1
    row:insert(orderPrice[i])
    
    if(_CartArray[i].extraItems) then
   		if(#_CartArray[i].extraItems > 0) then
			for j = 1, #_CartArray[i].extraItems do
				extraItemArr[j] = display.newText("",_W/36, _H/24.30,_FontArr[6],_H/40)
				extraItemArr[j]:setTextColor( 0 )
				extraItemArr[j].anchorX = 0
				extraItemArr[j].anchorY = 0
				row:insert(extraItemArr[j])
				extraItemArr[j].text = _CartArray[i].extraItems[j].sub_name
				
				if(j == 1) then
					extraItemArr[j].y = orderName[i].y + orderName[i].height + _H/192
				else
					extraItemArr[j].y = extraItemArr[j-1].y + extraItemArr[j-1].height + _H/192
				end
				
				roundDigit(_CartArray[i].extraItems[j].sub_amount)
				
				extraItemPrice[j] = display.newText("$ "..make2Digit(_CartArray[i].quantity * tonumber(digValue3)),_W - _W/36, extraItemArr[j].y,_FontArr[6],_H/40)
				extraItemPrice[j]:setTextColor( 0 )
				extraItemPrice[j].anchorX = 1
				extraItemPrice[j].anchorY = 0
				row:insert(extraItemPrice[j])
				
			end
    	end
    	
    end
	
	if _CartArray[i].variety_name == "" or _CartArray[i].variety_name == nil or _CartArray[i].variety_name == " " then
    	
    else
		varietyNameArr[i] = display.newText(_CartArray[i].variety_name, _W/36, orderName[i].y + orderName[i].height + _H/192, _FontArr[6], _H/40)
		varietyNameArr[i]:setTextColor( 0 )
		varietyNameArr[i].anchorX = 0
		varietyNameArr[i].anchorY = 0
		row:insert(varietyNameArr[i])
		
		if(#_CartArray[i].extraItems > 0) then
    		varietyNameArr[i].y = extraItemArr[#extraItemArr].y + extraItemArr[#extraItemArr].height + _H/192
    	end
		
		roundDigit(_CartArray[i].variety_price)
		
		varietyNamePrice[i] = display.newText("$ "..make2Digit(_CartArray[i].quantity * tonumber(digValue3)), _W - _W/36, varietyNameArr[i].y, _FontArr[6], _H/40)
		varietyNamePrice[i]:setTextColor( 0 )
		varietyNamePrice[i].anchorX = 1
		varietyNamePrice[i].anchorY = 0
		row:insert(varietyNamePrice[i])
	end
	
    if(_CartArray[i].Note == "" or _CartArray[i].Note == nil or _CartArray[i].Note == " ") then
    	
    else	
    	
    	orderNote[i] = display.newText(GBCLanguageCabinet.getText("NotesLabel",_LanguageKey),_W/36, rowHeight * 0.85,_FontArr[6],_H/40)
    	orderNote[i]:setTextColor( 83/255, 20/255, 111/255 )
    	orderNote[i].anchorX = 0
    	row:insert(orderNote[i])
    	
    	orderNoteBg[i] = display.newRect(orderNote[i].x + orderNote[i].width/2,orderNote[i].y - orderNote[i].height/2,orderNote[i].width + _W/27,orderNote[i].height + _H/96)
    	orderNoteBg[i]:setFillColor( 1, 1, 1, 0.01 )
    	orderNoteBg[i].anchorY = 0
    	orderNoteBg[i].id = i
    	orderNoteBg[i]:addEventListener("touch",onShowProductNote)
    	row:insert(orderNoteBg[i])
    	
		orderNoteLine = display.newLine(orderNote[i].x ,orderNote[i].y + orderNote[i].height/2, orderNote[i].x + orderNote[i].width,orderNote[i].y + orderNote[i].height/2)
        orderNoteLine:setStrokeColor( 83/255, 20/255, 111/255 )
		orderNoteLine.strokeWidth = 2
        row:insert(orderNoteLine)
           
        orderNote[i]:toFront() 	
        orderNoteLine:toFront()
    
    end   
       
end

local function onBgTap( event )
	native.setKeyboardFocus( nil )
	placeOrderGroup.y = yPos
end

local function onBgTouch( event )
	if( event.phase == "ended" ) then
		native.setKeyboardFocus( nil )
		placeOrderGroup.y = yPos
	end
	return true
end

local function onSwitchPress( event )
	if( radioButton1Img.isVisible == true ) then
		radioButton1Img.isVisible = false
		radioButton1Img2.isVisible = true
		takeAwayOrderFlag = true
		
	
	elseif( radioButton1Img2.isVisible == true ) then
		radioButton1Img.isVisible = true
		radioButton1Img2.isVisible = false
		takeAwayOrderFlag = false


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
        background:addEventListener("tap",onBgTap)
        background:addEventListener("touch",onBgTouch)
        sceneGroup:insert( background )
        
     
    
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
        
        takeAwayOrderFlag = false
        _Flag = false
        
        total = 0
        totalQuantity = 0
        grandTotal = 0
        s_tax = 0
        o_tax = 0
        _EditFlag = false
        
        header = display.newImageRect( imageDirectory.."f_Header.png", _W, _H/13.61 )
        header.x = _W/2
        header.y = _H/27
        sceneGroup:insert( header )
        
        heading = display.newText( GBCLanguageCabinet.getText("placeOrderLabel",_LanguageKey), header.x, header.y, _FontArr[30], _H/36.76 )
        heading:setFillColor( 1 )
        sceneGroup:insert( heading )
        
        local buttonSize2
		
		if( _LanguageKey == "ar" or _LanguageKey == "zh" or _LanguageKey == "hi" or _LanguageKey == "it" or _LanguageKey == "ja" or _LanguageKey == "ko" ) then
			buttonSize2 = _H/40
			labelyOff = -1
		elseif( _LanguageKey == "de" or _LanguageKey == "th" or _LanguageKey == "vi" ) then
			buttonSize2 = _H/45
		elseif( _LanguageKey == "ru" ) then
			buttonSize2 = _H/70
		else
			buttonSize2 = _H/32
		end
        
		backBtn = widget.newButton(
		{
			width = _W/3.75,
			height = _H/19.2,
			defaultFile = imageDirectory4.."unSelected_CheckBox1.png",
			overFile = imageDirectory4.."unSelected_CheckBox1.png",
			label = GBCLanguageCabinet.getText("AddLabel2",_LanguageKey),
			labelYOffset = labelyOff,
			font = _FontArr[6],
			fontSize = buttonSize2,
			labelColor = { default={1,1,1,1}, over={1,1,1,1} }
		}
		)
		backBtn.x = backBtn.width/2 + _W/54
		backBtn.y = header.y
		backBtn:addEventListener( "tap", handleBackButtonEvent  )
		sceneGroup:insert(backBtn)
		
        placeOrderGroup = display.newGroup()
        sceneGroup:insert(placeOrderGroup)
        
		placeOrderTableView = widget.newTableView
		{
    		top = _H/13.61,
    		left = 0,
   		 	width = _W,
    		height = _H - _H/13.61 - _H/4.8,
    		onRowRender = onRowRender,
    		onRowTouch = onRowTouch,
    		hideBackground = true,
    		horizontalScrollDisabled = true,
    		noLines = true,
    		listener = scrollListener
		}
		placeOrderGroup:insert(placeOrderTableView)
        
        for i = 1, #_CartArray do
        	if(#_CartArray[i].extraItems < 2) then
    			rowHeight = _H/2.95
    		else
    			
    			rowHeight = _H/2.95 + ((#_CartArray[i].extraItems - 1) * _H/20)
    		end
    		
    		placeOrderTableView:insertRow{
    		
    			rowHeight = rowHeight,
    			lineColor = { 1, 0, 0, 0 }
    			
    		}
    		
    		roundDigit(tonumber(_CartArray[i].price))
    		
    		total = total + (_CartArray[i].quantity * tonumber(digValue3))
    		
    		for j = 1, #_CartArray[i].extraItems do
    			
    			roundDigit(_CartArray[i].extraItems[j].sub_amount)    			
    			total = total + (_CartArray[i].quantity * tonumber(digValue3))
    			
    		end
    		
    		totalQuantity = totalQuantity + _CartArray[i].quantity
		end
		
		roundDigit(s_tax)
		s_tax2 = digValue3
		
		roundDigit(o_tax)
		o_tax2 = digValue3
		
		roundDigit(total)
		total2 = digValue3
		
		local t = total2 + s_tax2 + o_tax2
		roundDigit(t)
		grandTotal2 = digValue3
        
        grandTotal = grandTotal2
    	
        orderSummaryDevider = display.newLine(0,placeOrderTableView.y + placeOrderTableView.height/2 + _H/384,_W,placeOrderTableView.y + placeOrderTableView.height/2+ _H/384)
        orderSummaryDevider:setStrokeColor( 0, 0, 0, 0.5 )
		orderSummaryDevider.strokeWidth = 3
        placeOrderGroup:insert(orderSummaryDevider)
        
        grandTotalLabel = display.newText(GBCLanguageCabinet.getText("GrandTotalLabel",_LanguageKey).." $ "..make2Digit(grandTotal) ,_W - _W/36, placeOrderTableView.y + placeOrderTableView.height/2 + _H/48,_FontArr[6],_H/35)
        grandTotalLabel.anchorX = 1
        grandTotalLabel.anchorY = 0
        grandTotalLabel:setTextColor( 206/255, 23/255, 100/255 )
        placeOrderGroup:insert(grandTotalLabel)
        
        if(_isNotesVisible == "1") then
        
        noteBg = display.newImageRect(imageDirectory2.."NotesBg.png",_W,_H/8.64)
        noteBg.x = _W/2
        noteBg.y = _H - _H/9.45
        noteBg.anchorY = 1
        placeOrderGroup:insert(noteBg)
        
		noteTextBox = native.newTextBox( noteBg.x, noteBg.y - noteBg.height/2, noteBg.width - _W/54, noteBg.height - _H/48 )
		noteTextBox.placeholder = GBCLanguageCabinet.getText("addNotesLabel",_LanguageKey)
		noteTextBox.isEditable = true
		noteTextBox.font = native.newFont( _FontArr[41],_H/40  )
		noteTextBox:addEventListener( "userInput", inputListener )
		noteTextBox:setReturnKey( "done" )
        placeOrderGroup:insert(noteTextBox)
        
        else
        
        end
        
        placeOrderButton = widget.newButton
		{
   	 		width = _W/1.08,
    		height = _H/16.13,
    		defaultFile = imageDirectory2.."Send_Btn2.png",
    		overFile = imageDirectory2.."Send_Btn2.png",
    		label = GBCLanguageCabinet.getText("PayForOrderLabel",_LanguageKey),
    		labelColor = { default={ 1, 1, 1 }, over={ 1,1,1 } },
    		fontSize = _H/30,
    		font = _FontArr[6],
    		labelYOffset = _H/275,
    		onEvent = handlePlaceOrderButtonEvent
		}
		placeOrderButton.x = _W/2
		placeOrderButton.y = _H - _H/18.64
        placeOrderGroup:insert(placeOrderButton)
        
        yPos = placeOrderGroup.y
        
        
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
        
        if(#ordersBg > 0) then
        	for i = 1,#ordersBg do
        		display.remove(ordersBg[i])
        		ordersBg[i] = nil
        	end
        end
        
        if(#defaultPhoto > 0) then
        	for i = 1,#defaultPhoto do
        		display.remove(defaultPhoto[i])
        		defaultPhoto[i] = nil
        	end
        end
        
        if(#image > 0) then
        	for i = 1,#image do
        		display.remove(image[i])
        		image[i] = nil
        	end
        end
        
        if(#orderName > 0) then
        	for i = 1,#orderName do
        		display.remove(orderName[i])
        		orderName[i] = nil
        	end
        end
        
        if(#quantityArr > 0) then
        	for i = 1,#quantityArr do
        		display.remove(quantityArr[i])
        		quantityArr[i] = nil
        	end
        end
        
        if(#decrementArr > 0) then
        	for i = 1,#decrementArr do
        		display.remove(decrementArr[i])
        		decrementArr[i] = nil
        	end
        end
        
        if(#incrementArr > 0) then
        	for  i = 1,#incrementArr do
        		display.remove(incrementArr[i])
        		incrementArr[i] = nil
        	end
        end
        
        if(#editBtnArr > 0) then
        	for  i = 1,#editBtnArr do
        		display.remove(editBtnArr[i])
        		editBtnArr[i] = nil
        	end
        end
        
        if(#orderPrice > 0) then
        	for i = 1,#orderPrice do
        		display.remove(orderPrice[i])
        		orderPrice[i] = nil
        	end
        end
        
        if(#extraItemArr > 0) then
        	for i = 1,#extraItemArr do
        		display.remove(extraItemArr[i])
        		extraItemArr[i] = nil
        	end
        end
        
        if(#extraItemPrice > 0) then
       		for i = 1,#extraItemPrice do
        		display.remove(extraItemPrice[i])
        		extraItemPrice[i] = nil
        	end
        end
        
        if(#varietyNameArr > 0) then
        	for i = 1,#varietyNameArr do
        		display.remove(varietyNameArr[i])
        		varietyNameArr[i] = nil
        	end
        end
        
        if(#varietyNamePrice > 0) then
       		for i = 1,#varietyNamePrice do
        		display.remove(varietyNamePrice[i])
        		varietyNamePrice[i] = nil
        	end
        end
        
        if(#orderNote > 0) then
        	for i = 1,#orderNote do
        		display.remove(orderNote[i])
        		orderNote[i] = nil
        	end
        end
        
        if(#orderNoteBg > 0) then
        	for i = 1,#orderNoteBg do
        		display.remove(orderNoteBg[i])
        		orderNoteBg[i] = nil
        	end
        end
        
        if(orderNoteLine) then
        	display.remove(orderNoteLine)
        	orderNoteLine = nil
        end
        
        display.remove(rect1)
        rect1 = nil
        
        display.remove(radioButton1)
        radioButton1 = nil
        
        display.remove(radioButton1Img)
        radioButton1Img = nil
        
        display.remove(radioButton1Img2)
        radioButton1Img2 = nil
        
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
        
        display.remove(placeOrderTableView)
        placeOrderTableView = nil
        if(noteBg) then
       	 	display.remove(noteBg)
        	noteBg = nil
        end
        
        if(noteTextBox) then
        	display.remove(noteTextBox)
        	noteTextBox = nil
        end
        
        display.remove(orderSummaryDevider)
        orderSummaryDevider = nil
        
        display.remove(orderSummaryBg)
        orderSummaryBg = nil
        
        display.remove(orderSummaryLabel)
        orderSummaryLabel = nil
        
        display.remove(grandTotalLabel)
        grandTotalLabel = nil
        
        
        display.remove(placeOrderGroup)
        placeOrderGroup = nil
        
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
        if(placeOrderRequest1) then
        	network.cancel( placeOrderRequest1 )
        	placeOrderRequest1 = nil
        end
        
        if(placeOrderRequest2) then
        	network.cancel( placeOrderRequest2 )
        	placeOrderRequest2 = nil
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