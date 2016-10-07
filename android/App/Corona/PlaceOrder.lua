local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------
local imageDirectory = "images/SignUp/"
local imageDirectory2 = "images/PlaceOrder/"
local imageDirectory3 = "images/MainMenu/"

local defaultPhoto = { }
local image = { }
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
local placeOrderArr = { }
local changedProductIdArr = { }
local changedProductVarietyIdArr = { } 
local changedProductPriceArr = { }
local allergyValue,takeAwayOrderFlag --,rect1,radioButton1,radioButton1Img,radioButton1Img2

local networkReqCount1,networkReqCount2,networkReqCount3,networkReqCount4


--[[local _CartArray = {
	{ title = "Pane Casaresio", productID = 1,price = 50, quantity = 2 , extraItems = { {e_title = "Extra Cheese", e_price = 2.60}, {e_title = "Fresh Tomattos", e_price = 3}, {e_title = "Potato Chips", e_price = 5.00} }, Note = "Make it Spicy" },
	{ title = "Friselle", productID = 2, price = 30,quantity = 1 ,extraItems = { {e_title = "Extra Cheese", e_price = 4.60} } , Note = "Make it Spicy"},
	{ title = "Rosemary Bread", productID = 3, price = 20,quantity = 1 ,extraItems = { {e_title = "Extra Cheese", e_price = 2}, {e_title = "Fresh Tomattos", e_price = 2.60} , {e_title = "Potato Chips", e_price = 3.20} , {e_title = "Black Olives", e_price = 6} ,{e_title = "Garlic" , e_price = 2.60}}, Note = "Make is Sweet" },
	{ title = "Pasta Italiana", productID = 4,price = 70, quantity = 1 ,extraItems = { {e_title = "Extra Cheese" , e_price = 2.60}} , Note = "Make it Spicy"},
}]]--

local placeOrderButton,noteBg,noteTextBox,placeOrderScrollView,header,heading,backBg,backBtn,orderSummaryBg,orderSummaryDevider,orderSummaryLabel,subtotalLabel
local total,totalQuantity,grandTotal,s_tax,o_tax,totalAddOnValue, s_tax2, o_tax2, total2, grandTotal2
local placeOrderGroup,yPos
local placeOrderRequest1,placeOrderRequest2,tableNameGetRequest


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
		print( "~~~~~~~~~~~"..digValue3 )
		
		total = total + (_CartArray[i].quantity * tonumber(digValue3))
    		
    	for j = 1, #_CartArray[i].extraItems do
    		roundDigit(_CartArray[i].extraItems[j].sub_amount)
    		print( "@@@@@@@@@@@"..digValue3 )
    		
    		total = total + (_CartArray[i].quantity * digValue3)
    		totalAddOnValue = totalAddOnValue + 1	
    	end
    		
    	totalQuantity = totalQuantity + _CartArray[i].quantity
	end
	print("total is"..total)
	
	roundDigit(s_tax)
	print( "s_tax :::: "..digValue3 )
	s_tax2 = digValue3
	
	roundDigit(o_tax)
	print( "o_tax :::: "..digValue3 )
	o_tax2 = digValue3
	
	roundDigit(total)
	print( "total :::: "..digValue3 )
	total2 = digValue3
	
	local t = total2 + s_tax2 + o_tax2
	
	roundDigit(t)
	print( "grandTotal :::: "..digValue3 )
	grandTotal2 = digValue3
	
	grandTotal = grandTotal2
	
	--totalItemLabel.text =  "Total Items "..tostring(totalQuantity)
	--totalAddOnsLabel.text = "Total AddOns "
	--serviceTaxLabel.text = "Service Tax(5%) $"..tostring(s_tax)
	--otherTaxLabel.text = "Other Tax(7%) $"..tostring(o_tax)
	--subtotalLabel.text = GBCLanguageCabinet.getText("SubTotalLabel",_LanguageKey).." $ "..make2Digit(total)
	grandTotalLabel.text = GBCLanguageCabinet.getText("GrandTotalLabel",_LanguageKey).." $ "..make2Digit(grandTotal)
	 
end

local function handleBackButtonEvent( event )
	
	local previous = composer.getSceneName( "previous" )
	if(composer.getSceneName("previous") == "stripeRegistration" or composer.getSceneName( "previous" ) == "ProvidePin" or composer.getSceneName( "previous" ) == "cardSelection"  ) then
		composer.gotoScene( "menu" )
	else
		composer.gotoScene( previous )
	end
	
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
        -- user begins editing textBox
        print( event.text )
        placeOrderGroup.y = placeOrderGroup.y - _H/2
		header:toFront()
		heading:toFront()
		backBtn:toFront()  
        

    elseif event.phase == "ended" or event.phase == "submitted" then
        -- do something with textBox text
        print( event.target.text )
		placeOrderGroup.y = yPos
		
    elseif event.phase == "editing" then
        print( event.newCharacters )
        print( event.oldText )
        print( event.startPosition )
        print( event.text )
    end
end

local function handleOk( event )
	composer.gotoScene( composer.getSceneName( "previous" ) )

	return true
end

function scene:resumeGame()
    --code to resume game
    if(noteTextBox) then
    	noteTextBox.isVisible = true
    end
    return true
end

local function makeChanges()
	for j = 1,#changedProductIdArr do
		
	
	for i = 1,#_CartArray do
	
		if(_CartArray[i].productID == changedProductIdArr[j] and _CartArray[i].variety_id == changedProductVarietyIdArr[j]) then
			--local q = tonumber(VariableTable.QuantityLabel.text) + _CartArray[i].quantity
			--_CartArray[i] = { id = id, quantity = q}
					
			--[[if(#_CartArray[i].extraItems > 0) then
				for m = 1,#_CartArray[i].extraItems do
					for n = 1,#extraItemsArr do
						if(_CartArray[i].extraItems[m].id == extraItemsArr[n].id) then
							flag = 1
							break
						else
							flag = 0
						end
					end
					if(flag == 0) then
						extraItemsArr[#extraItemsArr + 1] = _CartArray[i].extraItems[m]
					end
				end
			else
					
			end]]--
					
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
    if i == 2 then
        print("continue payment with updated price")
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
		
		print("items"..options_ID_Str)
		print("items total "..options_Total_Amount)
		 finalPrice = roundDigit( (tonumber(_CartArray[i].price) + tonumber(options_Total_Amount)* _CartArray[i].quantity))
		 itemAmount = roundDigit(tonumber(_CartArray[i].price))
		local discount = "0"
		local itemNote = ""
		itemNote = tostring(_CartArray[i].Note):gsub( "&", "%%26" )
		placeOrderArr[#placeOrderArr + 1] = { item_id = _CartArray[i].productID,kitchen_id = _CartArray[i].kitchenID ,item_options_id = options_ID_Str,item_variety_id = _CartArray[i].variety_id,item_quantity = _CartArray[i].quantity,item_amount = itemAmount,item_options_amount = options_Total_Amount,item_discount = discount,final_amount = finalPrice,item_note = itemNote  }
		
	end	
	
		
		local tab = json.encode(placeOrderArr)
		print("json data")
		print(tab)
		local noteTextBoxValue
		if(noteTextBox) then
			noteTextBoxValue = noteTextBox.text:gsub( "&", "%%26" )
		else
			noteTextBoxValue = ""
		end	
		local allergyValue
		if( _Alleregy ) then
		 	allergyValue = _Alleregy:gsub( "&", "%%26" )
		else
			allergyValue = ""
		end
		
		_PlaceOrderBody = "ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&items="..tab.."&table_location=".._TableNumber.."&grand_total="..grandTotal.."&order_note="..noteTextBoxValue.."&allergies="..allergyValue
		_PlaceOrderTotal = grandTotal
		
		--[[local headers = {}
		
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		
		local body = "ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&items="..tab.."&table_location=".._TableNumber.."&grand_total="..grandTotal.."&order_note="..noteTextBoxValue
		
		local params = {}
		params.headers = headers
		params.body = body
		params.timeout = 180
		
		local url = _WebLink.."place-order.php?"
		
		placeOrderRequest1 = network.request( url, "POST", placeOrdersNetworkListener, params )]]--
		
		local allergyValue
		if( _Alleregy ) then
		 	allergyValue = _Alleregy:gsub( "&", "%%26" )
		else
			allergyValue = ""
		end
		local url = _WebLink.."place-order.php?ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&items="..tab.."&table_location=".._TableNumber.."&grand_total="..grandTotal.."&order_note="..noteTextBoxValue.."&allergies="..allergyValue
		local url2 = url:gsub( " ", "%%20" )
		placeOrderRequest1 = network.request( url2, "GET", placeOrdersNetworkListener )
		native.setActivityIndicator( true )
		
		
	else
		
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Item5Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
	end
            
    elseif i == 1 then
          print("let user first review the updated product price ")
          	
    end
end
return true
end

function placeOrdersNetworkListener( event )
	if ( event.isError ) then
    	print( "Network error!" )
		
		networkReqCount1 = networkReqCount1 + 1
				
    	native.setActivityIndicator( false )
			
		if( networkReqCount1 > 3 ) then	
				
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		else
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
		
				print("items"..options_ID_Str)
				print("items total "..options_Total_Amount)
		 		finalPrice = roundDigit( (tonumber(_CartArray[i].price) + tonumber(options_Total_Amount)* _CartArray[i].quantity))
		 		itemAmount = roundDigit(tonumber(_CartArray[i].price))
				local discount = "0"
				local itemNote = ""
				itemNote = tostring(_CartArray[i].Note):gsub( "&", "%%26" )
				placeOrderArr[#placeOrderArr + 1] = { item_id = _CartArray[i].productID,kitchen_id = _CartArray[i].kitchenID ,item_options_id = options_ID_Str,item_variety_id = _CartArray[i].variety_id,item_quantity = _CartArray[i].quantity,item_amount = itemAmount,item_options_amount = options_Total_Amount,item_discount = discount,final_amount = finalPrice,item_note = itemNote  }
		
		end	
	
		
			local tab = json.encode(placeOrderArr)
			print("json data")
			print(tab)
			local noteTextBoxValue
			if(noteTextBox) then
				noteTextBoxValue = noteTextBox.text:gsub( "&", "%%26" )
			else
				noteTextBoxValue = ""
			end	
			local allergyValue
			if( _Alleregy ) then
		 		allergyValue = _Alleregy:gsub( "&", "%%26" )
			else
				allergyValue = ""
			end
			_PlaceOrderBody = "ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&items="..tab.."&table_location=".._TableNumber.."&grand_total="..grandTotal.."&order_note="..noteTextBoxValue.."&allergies="..allergyValue
			_PlaceOrderTotal = grandTotal
		
			local allergyValue
			if( _Alleregy ) then
		 		allergyValue = _Alleregy:gsub( "&", "%%26" )
			else
				allergyValue = ""
			end
			local url = _WebLink.."place-order.php?ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&items="..tab.."&table_location=".._TableNumber.."&grand_total="..grandTotal.."&order_note="..noteTextBoxValue.."&allergies="..allergyValue
			local url2 = url:gsub( " ", "%%20" )
			placeOrderRequest1 = network.request( url2, "GET", placeOrdersNetworkListener )
			native.setActivityIndicator( true )
			
		end		
		
	else	
		timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		
		if(event.phase == "ended") then
		print("place order reponse is........."..event.response)
		if( event.response == "0" or event.response == 0 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("6Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				timer.performWithDelay( 200, function() 
    			native.setActivityIndicator( false )
				end )
		elseif( event.response == "1" or event.response == 1 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("6Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			timer.performWithDelay( 200, function() 
    			native.setActivityIndicator( false )
				end )
		elseif( event.response == "2" or event.response == 2 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			timer.performWithDelay( 200, function() 
    			native.setActivityIndicator( false )
				end )
		elseif( event.response == "3" or event.response == 3 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				timer.performWithDelay( 200, function() 
    			native.setActivityIndicator( false )
				end )
		elseif( event.response == "4" or event.response == 4 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Item1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				timer.performWithDelay( 200, function() 
    			native.setActivityIndicator( false )
				end )
		elseif( event.response == "5" or event.response == 5 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Item2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				timer.performWithDelay( 200, function() 
    			native.setActivityIndicator( false )
				end )
		elseif( event.response == "6" or event.response == 6 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Item3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				timer.performWithDelay( 200, function() 
    			native.setActivityIndicator( false )
				end )
		
		else
			changedData = json.decode( event.response )
			
			if(#changedData > 0) then
		
			changedProductIdArr = { }
			changedProductVarietyIdArr = { }
			changedProductPriceArr = { }
		--	local alert = native.showAlert( alertLabel, "Somthing went wrong, please try again later", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			print("price is changed with effect of discount ")
			
			print(event.response)
			
			local k = 1
			if(#changedData > 0) then
				for i = 1, #changedData do
					if(tonumber(changedData[i].item_amount) == tonumber(changedData[i].item_new_price)) then
						print("price NOT changed for the product id..."..changedData[i].item_id)
					else
						print("price changed for the product id >>>"..changedData[i].item_id)
						changedProductIdArr[k] = changedData[i].item_id
						changedProductVarietyIdArr[k] = changedData[i].item_variety_id
						changedProductPriceArr[k] = changedData[i].item_new_price
						
						k = k + 1
					end
				end
			end
			--[[str = ""
			if(#changedProductIdArr > 0) then
				for i = 1, #changedProductIdArr do
					for j = 1, #_CartArray do
						if(changedProductIdArr[i] == _CartArray[j].productID) then
							str = str.._CartArray[j].title.." ,"
						end
					end
				end
			end]]---
			
			
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("7Alert",_LanguageKey), { GBCLanguageCabinet.getText("reviewLabel",_LanguageKey),GBCLanguageCabinet.getText("continueLabel",_LanguageKey) }, onChnagedProductPrice )
		
		
			else
			print(" success response"..event.response)
			for i = 1, #_CartArray do
			
				--table.remove( _CartArray,(i - (i-1)) )
				--placeOrderTableView:deleteRow(i)
			
			end
			
			print("Order ID is................................")
			_OrderID = changedData.order_id
			print(_OrderID)
			
			--[[noteTextBox.isVisible = false
			
			local options = {
    		isModal = true,
    		effect = "fade",
    		time = 400,
    		params = {
        		sampleVar = "my sample variable"
    		}
			}
			--local alert = native.showAlert( alertLabel, "Your order has been placed successfully.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk )
			local function gotoShowOverlay()
			
			composer.showOverlay( "OrderPopUp", options )
			
			end
			timer.performWithDelay(200,gotoShowOverlay,1)]]--
			
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
		print("place order")
		
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
		
		print("items"..options_ID_Str)
		print("items total "..options_Total_Amount)
		 finalPrice = roundDigit( (tonumber(_CartArray[i].price) + tonumber(options_Total_Amount)* _CartArray[i].quantity))
		 itemAmount = roundDigit(tonumber(_CartArray[i].price))
		local discount = "0"
		local itemNote = ""
		itemNote = tostring(_CartArray[i].Note):gsub( "&", "%%26" )
		placeOrderArr[#placeOrderArr + 1] = { item_id = _CartArray[i].productID,kitchen_id = _CartArray[i].kitchenID ,item_options_id = options_ID_Str,item_variety_id = _CartArray[i].variety_id,item_quantity = _CartArray[i].quantity,item_amount = itemAmount,item_options_amount = options_Total_Amount,item_discount = discount,final_amount = finalPrice,item_note = itemNote  }
		
	end	
	
	local tab = json.encode(placeOrderArr)
	print("json data")
	print(tab)
	local noteTextBoxValue
	
	if(noteTextBox) then
		noteTextBoxValue = noteTextBox.text:gsub( "&", "%%26" )
	else
		noteTextBoxValue = ""
	end
		local allergyValue
		if( _Alleregy ) then
			allergyValue = _Alleregy:gsub( "&", "%%26" )
		else
			allergyValue = ""
		end
	
	_PlaceOrderBody = "ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&items="..tab.."&table_location=".._TableNumber.."&grand_total="..grandTotal.."&order_note="..noteTextBoxValue.."&allergies="..allergyValue
	_PlaceOrderTotal = grandTotal
	
	
local function BeaconDataForTableNetworkListener( event )
	if ( event.isError ) then
        print( "Network error! krs123" )
        networkReqCount2 = networkReqCount2 + 1
        
        if( networkReqCount2 > 3 ) then
        
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        else
        
        	local url = _WebLink.."table-find.php?beacon_major=".._majorBea.."&beacon_minor=".._minorBea
			local url2 = url:gsub( " ", "%%20" )
			tableNameGetRequest = network.request( url2, "GET", BeaconDataForTableNetworkListener )
        
        end
    else
        print ( "Beacon data RESPONSE:" .. event.response )
		
		if( event.response == 0 or event.response == "0" ) then
			print("Variables not set")
				timer.performWithDelay( 200, function() 
    			native.setActivityIndicator( false )
				end )
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        elseif( event.response == 1 or event.response == "1" ) then
        	--local alert
        		timer.performWithDelay( 200, function() 
    			native.setActivityIndicator( false )
				end )
        	print("Beacon can't be empty") 
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        elseif( event.response == 2 or event.response == "2" ) then
        	print("Something went wrong, Please try again")
        	timer.performWithDelay( 200, function() 
    			native.setActivityIndicator( false )
				end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        elseif( event.response == 3 or event.response == "3" ) then
        	print("Store Id doesn't found")
        	timer.performWithDelay( 200, function() 
    			native.setActivityIndicator( false )
				end )
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
		else
			tableData = json.decode( event.response )
			
			if(tableData) then
				
				print("send place order query")
				_TableNumber = tableData.table_name
				local allergyValue
				
				if( _Alleregy ) then
					allergyValue = _Alleregy:gsub( "&", "%%26" )
				else
					allergyValue = ""
				end
				
				local url = _WebLink.."place-order.php?ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&items="..tab.."&table_location=".._TableNumber.."&grand_total="..grandTotal.."&order_note="..noteTextBoxValue.."&allergies="..allergyValue
				local url2 = url:gsub( " ", "%%20" )
				placeOrderRequest2 = network.request( url2, "GET", placeOrdersNetworkListener )
				native.setActivityIndicator( true )
				
			else
				
			end
		end
	end
	return true
end      
        
local function fetchTabelNameFunc()	
	local url = _WebLink.."table-find.php?beacon_major=".._majorBea.."&beacon_minor=".._minorBea
	local url2 = url:gsub( " ", "%%20" )
	tableNameGetRequest = network.request( url2, "GET", BeaconDataForTableNetworkListener )
end

local function onGoBackfunc( )
	print("go back to main menu.....")
	composer.gotoScene( "menu" )
	return true
end

local function onChooseOrderTypeFunc( event )
	if event.action == "clicked" then
        local i = event.index
        if i == 2 then
			print( "take away order" )
			_TableNumber = "Takeaway"
			
			local allergyValue
			if( _Alleregy ) then
				allergyValue = _Alleregy:gsub( "&", "%%26" )
			else
				allergyValue = ""
			end
			
			local url = _WebLink.."place-order.php?ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&items="..tab.."&table_location=Takeaway&grand_total="..grandTotal.."&order_note="..noteTextBoxValue.."&allergies="..allergyValue
			local url2 = url:gsub( " ", "%%20" )
			
			placeOrderRequest2 = network.request( url2, "GET", placeOrdersNetworkListener )
			native.setActivityIndicator( true )
			
        elseif i == 1 then
        	
			timer.performWithDelay( 200, function()
				print("request init ibeacon plugin from corona")
				iBeacon.init( listener )
			end )
			
			timer.performWithDelay( 1000, function()
				if iBeaconRunning then
					print("request start scan from corona")
					iBeacon.scan( listener )
				else
					print("iBeacon not running")
				end				
			end )
			
			timer.performWithDelay( 3000, function()
				if iBeaconRunning then
					print("request stop scan from corona")
					iBeacon.stopscan( listener )
				else
					print("iBeacon not running")
				end
			end )
			
			timer.performWithDelay( 4000, function()
				if iBeaconRunning then
					print("request getBeacons from corona")
					iBeacon.getBeacons( listener )
				else
					print("iBeacon not running")
				end
				--library.show( "corona" )
			end )
			
			local function onSelectOrderType( event )
				if event.action == "clicked" then
					local i = event.index
					if i == 2 then
						print( "take away order" )
						_TableNumber = "Takeaway"
						
						local allergyValue
						if( _Alleregy ) then
							allergyValue = _Alleregy:gsub( "&", "%%26" )
						else
							allergyValue = ""
						end
						local url = _WebLink.."place-order.php?ws=1&user_id=".._UserID.."&store_id=".._StoreID.."&items="..tab.."&table_location=Takeaway&grand_total="..grandTotal.."&order_note="..noteTextBoxValue.."&allergies="..allergyValue
						local url2 = url:gsub( " ", "%%20" )
						placeOrderRequest2 = network.request( url2, "GET", placeOrdersNetworkListener )
						native.setActivityIndicator( true )
						
					elseif i == 1 then
						print( "table order" )
						
						native.setActivityIndicator( false )
						
						local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Order3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onGoBackfunc  )
						
					end
					
				end
				
				return true
			end
			
			timer.performWithDelay( 5000, function ()
				if(_majorBea == nil or _majorBea == "" or _minorBea == "" or _minorBea == nil ) then
					-- no beacon found
					print("no beacon found")
					timer.performWithDelay( 200, function() 
					native.setActivityIndicator( false )
					end )
					
					local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Order4Alert",_LanguageKey), { GBCLanguageCabinet.getText("NoLabel",_LanguageKey),GBCLanguageCabinet.getText("YesLabel",_LanguageKey) }, onSelectOrderType  )
					
				else
					
					--if( tableCount == totalBeaconFound ) then
--						local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Order4Alert",_LanguageKey), { GBCLanguageCabinet.getText("NoLabel",_LanguageKey),GBCLanguageCabinet.getText("YesLabel",_LanguageKey) }, onSelectOrderType  )
--					else
						print( _majorBea.."//".._minorBea.."//".." place order screen........." )
						fetchTabelNameFunc()
					--end
					
				end
			end)
			
        end
    end
	return true
end

local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Order4Alert",_LanguageKey), { GBCLanguageCabinet.getText("NoLabel",_LanguageKey),GBCLanguageCabinet.getText("YesLabel",_LanguageKey) }, onChooseOrderTypeFunc  )
	
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
		print(event.target.id.."decrement")
		_CartArray[event.target.id].quantity = tonumber(_CartArray[event.target.id].quantity) - 1
		
		
		local function onRemoveProduct( e ) 
			 if e.action == "clicked" then
        		local i = e.index
        		if i == 2 then
        			
            		placeOrderTableView:deleteRow(event.target.id)
					table.remove(_CartArray,event.target.id)
					--quantityArr[event.target.id].text = _CartArray[event.target.id].quantity
					
					
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
					
        		elseif i == 1 then
            		print("dont remove the product...")
            		_CartArray[event.target.id].quantity = tonumber(_CartArray[event.target.id].quantity) + 1
        		end
    		end
			return true
		end
		
		if(_CartArray[event.target.id].quantity == 0) then
		
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Item6Alert",_LanguageKey), { GBCLanguageCabinet.getText("NoLabel",_LanguageKey),GBCLanguageCabinet.getText("YesLabel",_LanguageKey) }, onRemoveProduct )
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
		print(event.target.id.."increment")
		_CartArray[event.target.id].quantity = tonumber(_CartArray[event.target.id].quantity) + 1
		quantityArr[event.target.id].text = _CartArray[event.target.id].quantity
		reloadPrice()
		placeOrderTableView:reloadData()
	end
	return true
end

function scene:resumeGame()
    --code to resume game
    if(noteTextBox) then
    	noteTextBox.isVisible = true
    end
    return true
end

local function onShowProductNote( event )
	if(event.phase == "began") then
		print("Show Notes of product ".._CartArray[event.target.id].title)
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

local function onRowRender( event )

    -- Get reference to the row group
    local row = event.row
	local i = row.index
    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth
	extraItemArr = { }
	extraItemPrice = { }
	print("kitchen Id for Item ".._CartArray[i].title.."is ".._CartArray[i].kitchenID)

    ordersBg[i] = display.newImageRect(imageDirectory2.."OrderRowBg.png",_W,rowHeight)
    ordersBg[i].x = _W/2
    ordersBg[i].y = rowHeight * 0.5
    row:insert(ordersBg[i])
    
    local s = _CartArray[i].title
    --[[if(s:len() > 27) then
        s = s:sub(1,27).."..."
    else]]--	
    	s = s
	--end
	
	local imagePath = system.pathForFile( "Product".._CartArray[i].productID..".png", system.TemporaryDirectory )
	--print("Path = "..imagePath)
	local imageFile = io.open( imagePath, "r" )
	defaultPhoto[i] = display.newImageRect(imageDirectory3.."ProductBg.png", _W/2.04, _H/4.86)
	defaultPhoto[i].x = _W/36 + defaultPhoto[i].width/2 --m*_W/3.98 + (_W/4.05*(m - 1))
	defaultPhoto[i].y = defaultPhoto[i].height/2 + _H/96 --n*_H/9.2 + (_H/10*(n - 1))
	row:insert( defaultPhoto[i] )
	
	if imageFile then
		print(imageFile)
		
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
    
    orderName[i] = display.newText("",_W/36, defaultPhoto[i].y + defaultPhoto[i].height/2 + _H/96,_W/2,_H/30,_FontArr[6],_H/30) --("",_W/36, _H/25,_W/2,_H/30,_FontArr[6],_H/30)
    orderName[i]:setTextColor( 83/255, 20/255, 111/255 )
    orderName[i].text = s
    orderName[i].anchorX = 0
    orderName[i].anchorY = 0
    row:insert(orderName[i])
        		
    quantityArr[i] = display.newText("",_W/2 + _W/6, _H/25,_FontArr[6],_H/30)
    quantityArr[i]:setTextColor( 83/255, 20/255, 111/255 )
    quantityArr[i].text = _CartArray[i].quantity
    quantityArr[i].y = rowHeight * 0.25
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
    
    print("qunatity and price...........".._CartArray[i].quantity.."//"..tostring(tonumber(_CartArray[i].price) - tonumber(_CartArray[i].discount)))
    
    roundDigit(tonumber(_CartArray[i].price))
    print( "%%%%%%%%%%%%%%%"..digValue3 )
    
    orderPrice[i] = display.newText(make2Digit(tonumber(_CartArray[i].quantity) * tonumber(digValue3)),_W - _W/36, rowHeight * 0.25,_FontArr[6],_H/30)
    orderPrice[i]:setTextColor( 206/255, 23/255, 100/255 )
    orderPrice[i].anchorX = 1
    row:insert(orderPrice[i])
    
    if(_CartArray[i].extraItems) then
    	print("got extra data for item"..i)
   		if(#_CartArray[i].extraItems > 0) then
    		print("extra data for item"..i.." is"..#_CartArray[i].extraItems)
    	for j = 1, #_CartArray[i].extraItems do
    
    	extraItemArr[j] = display.newText("",_W/36, _H/24.30,_FontArr[6],_H/40)
    	extraItemArr[j]:setTextColor( 0 )
    	extraItemArr[j].anchorX = 0
    	extraItemArr[j].anchorY = 0
    	row:insert(extraItemArr[j])
    	extraItemArr[j].text = _CartArray[i].extraItems[j].sub_name
    	if(j == 1) then
    		extraItemArr[j].y = orderName[j].y + orderName[j].height + _H/192
    		
    	else
    		extraItemArr[j].y = extraItemArr[j-1].y + extraItemArr[j-1].height + _H/192
    	
    	end
    	print("???????????????????????????????????????????????????")
    	print(_CartArray[i].extraItems[j].sub_name)
    	
    	roundDigit(_CartArray[i].extraItems[j].sub_amount)
    	print( "############"..digValue3 )
    	
    	extraItemPrice[j] = display.newText("$ "..make2Digit(_CartArray[i].quantity * tonumber(digValue3)),_W - _W/36, extraItemArr[j].y,_FontArr[6],_H/40)
    	extraItemPrice[j]:setTextColor( 0 )
    	extraItemPrice[j].anchorX = 1
    	extraItemPrice[j].anchorY = 0
    	row:insert(extraItemPrice[j])
    	
    	
   	 	end
    end
    
    end
       
    if(_CartArray[i].Note == "" or _CartArray[i].Note == nil or _CartArray[i].Note == " ") then
    	
    	print("no notes in row "..i)
    
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


--[[
local function onSwitchPress( event )
	if( radioButton1Img.isVisible == true ) then
		print("take away order method selected")
		radioButton1Img.isVisible = false
		radioButton1Img2.isVisible = true
		takeAwayOrderFlag = true
		
	
	elseif( radioButton1Img2.isVisible == true ) then
		print("NOT take away")
		radioButton1Img.isVisible = true
		radioButton1Img2.isVisible = false
		takeAwayOrderFlag = false


	end
	return true
end
]]--

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
        
        print("Place Order ........................................")
        
        print(#_CartArray)
        networkReqCount1 = 0
        networkReqCount2 = 0
        networkReqCount3 = 0
        networkReqCount4 = 0
        
        
        total = 0
        totalQuantity = 0
        grandTotal = 0
        s_tax = 0
        o_tax = 0
        
        header = display.newImageRect( imageDirectory.."f_Header.png", _W, _H/13.61 )
        header.x = _W/2
        header.y = _H/27
        sceneGroup:insert( header )
        
        heading = display.newText( GBCLanguageCabinet.getText("placeOrderLabel",_LanguageKey), header.x, header.y, _FontArr[30], _H/36.76 )
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
		
        placeOrderGroup = display.newGroup()
        sceneGroup:insert(placeOrderGroup)
        
        --[[placeOrderScrollView = widget.newScrollView
		{
    		top = _H/13.61,
    		left = 0,
   		 	width = _W,
    		height = _H - _H/13.61 - _H/4.48,
    		scrollWidth = _W,
    		scrollHeight = _H,
    		horizontalScrollDisabled = true,
    		hideBackground = true,
    		--backgroundColor = { 0.8, 0.8, 0.8 },
    		listener = scrollListener
		}
		placeOrderGroup:insert(placeOrderScrollView)]]--
		
		placeOrderTableView = widget.newTableView
		{
    		top = _H/13.61,
    		left = 0,
   		 	width = _W,
    		height = _H - _H/13.61 - _H/4.8,--_H/2.67,
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
        		print("only 2 item")
    			rowHeight = _H/2.95 --_H/8.06
    		else
    			print("more items")
    			
    			rowHeight = _H/2.95 + ((#_CartArray[i].extraItems - 1) * _H/20) --_H/8.06 + ((#_CartArray[i].extraItems - 1) * _H/20)
    		end
    		
    		placeOrderTableView:insertRow{
    		
    			rowHeight = rowHeight,
    			lineColor = { 1, 0, 0, 0 }
    			
    		}
    		
    		roundDigit(tonumber(_CartArray[i].price))
    		print( "::::::::::::::: "..digValue3 )
    		
    		total = total + (_CartArray[i].quantity * tonumber(digValue3))
    		
    		for j = 1, #_CartArray[i].extraItems do
    			
    			roundDigit(_CartArray[i].extraItems[j].sub_amount)
    			print( "-------------"..digValue3 )
    			
    			total = total + (_CartArray[i].quantity * tonumber(digValue3))
    			
    		end
    		
    		totalQuantity = totalQuantity + _CartArray[i].quantity
		end
		
		roundDigit(s_tax)
		print( "@@@@@@@@@"..digValue3 )
		s_tax2 = digValue3
		
		roundDigit(o_tax)
		print( "!!!!!!!!!!!"..digValue3 )
		o_tax2 = digValue3
		
		roundDigit(total)
		print( "&&&&&&&&&&"..digValue3 )
		total2 = digValue3
		
		local t = total2 + s_tax2 + o_tax2
		roundDigit(t)
		print( "grand total is ::::: "..digValue3 )
		grandTotal2 = digValue3
        
        grandTotal = grandTotal2
    	--[[if(#_CartArray > 0) then
        	for i = 1, #_CartArray do
        		ordersBg[i] = display.newImageRect(imageDirectory2.."OrderRowBg.png",_W,_H/8.06)
        		ordersBg[i].x = _W/2
        		ordersBg[i].y = ( (i - 1) * _H/8.06 )
        		ordersBg[i].anchorY = 0
        		placeOrderScrollView:insert(ordersBg[i])
        		
        		quantityArr[i] = display.newText("",_W/2 + _W/6, ordersBg[i].y + ordersBg[i].height/3,_FontArr[6],_H/35)
        		quantityArr[i]:setTextColor( 83/255, 20/255, 111/255 )
        		quantityArr[i].text = _CartArray[i].quantity
        		placeOrderScrollView:insert(quantityArr[i])
        		
        		decrementArr[i] = display.newImageRect(imageDirectory2.."descrement_Btn.png",_W/18.94,_H/33.68)
        		decrementArr[i].x = quantityArr[i].x - _W/12
        		decrementArr[i].y = quantityArr[i].y - quantityArr[i].height/2
        		decrementArr[i].anchorY = 0
        		decrementArr[i].id = i
        		decrementArr[i]:addEventListener("touch",onDecrementTouch)
        		placeOrderScrollView:insert(decrementArr[i])
        		
        		incrementArr[i] = display.newImageRect(imageDirectory2.."Increment_Btn.png",_W/18.94,_H/33.68)
        		incrementArr[i].x = quantityArr[i].x + _W/12
        		incrementArr[i].y = quantityArr[i].y - quantityArr[i].height/2
        		incrementArr[i].anchorY = 0
        		incrementArr[i].id = i
        		incrementArr[i]:addEventListener("touch",onIncrementTouch)
        		placeOrderScrollView:insert(incrementArr[i])
        		
        		
        	end
        end]]--
        
        orderSummaryDevider = display.newLine(0,placeOrderTableView.y + placeOrderTableView.height/2 + _H/384,_W,placeOrderTableView.y + placeOrderTableView.height/2+ _H/384)
        orderSummaryDevider:setStrokeColor( 0, 0, 0, 0.5 )
		orderSummaryDevider.strokeWidth = 3
        placeOrderGroup:insert(orderSummaryDevider)
        
        --[[orderSummaryBg = display.newImageRect(imageDirectory2.."OrderSummaryBg.png",_W,_H/6.62)
        orderSummaryBg.x = _W/2
        orderSummaryBg.y = placeOrderTableView.y + placeOrderTableView.height/2 + _H/384
        orderSummaryBg.anchorY = 0
        placeOrderGroup:insert(orderSummaryBg)
        
        orderSummaryLabel = display.newText(GBCLanguageCabinet.getText("OrderSummaryLabel",_LanguageKey),_W/36, orderSummaryBg.y + _H/96,_FontArr[6],_H/35)
        orderSummaryLabel.anchorX = 0
        orderSummaryLabel.anchorY = 0
        orderSummaryLabel:setTextColor( 83/255, 20/255, 111/255 )
        placeOrderGroup:insert(orderSummaryLabel)
        
        subtotalLabel = display.newText(GBCLanguageCabinet.getText("SubTotalLabel",_LanguageKey).." $ "..make2Digit(total),_W - _W/36, orderSummaryLabel.y + orderSummaryLabel.height + _H/96,_FontArr[6],_H/40)
        subtotalLabel.anchorX = 1
        subtotalLabel.anchorY = 0
        subtotalLabel:setTextColor( 206/255, 23/255, 100/255 )
        placeOrderGroup:insert(subtotalLabel)
        ]]--
       --[[ 
        totalItemLabel = display.newText("Total Items "..totalQuantity ,orderSummaryLabel.x, orderSummaryLabel.y + orderSummaryLabel.height + _H/384,_FontArr[6],_H/45)
        totalItemLabel.anchorX = orderSummaryLabel.anchorX
        totalItemLabel.anchorY = 0
        totalItemLabel:setTextColor( 0 )
        placeOrderGroup:insert(totalItemLabel)
        
        totalAddOnsLabel = display.newText("Total AddOns " ,orderSummaryLabel.x, totalItemLabel.y + totalItemLabel.height + _H/384,_FontArr[6],_H/45)
        totalAddOnsLabel.anchorX = orderSummaryLabel.anchorX
        totalAddOnsLabel.anchorY = 0
        totalAddOnsLabel:setTextColor( 0 )
        placeOrderGroup:insert(totalAddOnsLabel)]]--
        
        --[[serviceTaxLabel = display.newText("Service Tax(5%) $"..s_tax ,subtotalLabel.x, subtotalLabel.y + subtotalLabel.height + _H/384,_FontArr[6],_H/50)
        serviceTaxLabel.anchorX = subtotalLabel.anchorX
        serviceTaxLabel.anchorY = 0
        serviceTaxLabel:setTextColor( 0,0,0,0.5 )
        placeOrderGroup:insert(serviceTaxLabel)
        
        otherTaxLabel = display.newText("Other Tax(7%) $"..o_tax ,serviceTaxLabel.x, serviceTaxLabel.y + serviceTaxLabel.height + _H/384,_FontArr[6],_H/50)
        otherTaxLabel.anchorX = serviceTaxLabel.anchorX
        otherTaxLabel.anchorY = 0
        otherTaxLabel:setTextColor( 0,0,0,0.5 )
        placeOrderGroup:insert(otherTaxLabel)]]--
        
        grandTotalLabel = display.newText(GBCLanguageCabinet.getText("GrandTotalLabel",_LanguageKey).." $ "..make2Digit(grandTotal) ,_W - _W/36, placeOrderTableView.y + placeOrderTableView.height/2 + _H/48,_FontArr[6],_H/35)
        grandTotalLabel.anchorX = 1
        grandTotalLabel.anchorY = 0
        grandTotalLabel:setTextColor( 206/255, 23/255, 100/255 )
        placeOrderGroup:insert(grandTotalLabel)
        
       --[[ radioButton1Img = display.newImageRect(imageDirectory2.."checkBox_UnSelected.png",_W/18,_H/32)
		radioButton1Img.x = _W/1.8 + _W/12
		radioButton1Img.y = grandTotalLabel.y + grandTotalLabel.height + _H/48
		radioButton1Img.isVisible = true
		placeOrderGroup:insert(radioButton1Img) 

		radioButton1Img2 = display.newImageRect(imageDirectory2.."checkBox_Selected.png",_W/18,_H/32)
		radioButton1Img2.x = _W/1.8 + _W/12
		radioButton1Img2.y = radioButton1Img.y
		placeOrderGroup:insert(radioButton1Img2)  
		radioButton1Img2.isVisible = false

		radioButton1 = display.newText("Take away order",0,radioButton1Img.y + radioButton1Img.height/4,_FontArr[6],_H/35)  
		radioButton1.x = radioButton1Img2.x + _W/16
		radioButton1.anchorX = 0
		radioButton1:setFillColor( 0 )
		placeOrderGroup:insert(radioButton1)
		
		rect1 = display.newRect( _W/1.8 + _W/25 ,grandTotalLabel.y + grandTotalLabel.height + _H/48,radioButton1Img.width+radioButton1.width + _W/27,_H/24)
		rect1:setFillColor(1,1,1,0.01)
		rect1.anchorX = 0
		placeOrderGroup:insert(rect1) 
		rect1.id = "1"
		rect1:addEventListener("tap",onSwitchPress)  ]]--
        
        if(_isNotesVisible == "1") then
        
        noteBg = display.newImageRect(imageDirectory2.."NotesBg.png",_W,_H/8.64)
        noteBg.x = _W/2
        noteBg.y = _H - _H/9.45
        noteBg.anchorY = 1
        placeOrderGroup:insert(noteBg)
        
		noteTextBox = native.newTextBox( noteBg.x, noteBg.y - noteBg.height/2, noteBg.width - _W/54, noteBg.height - _H/48 )
		noteTextBox.placeholder = GBCLanguageCabinet.getText("addNotesLabel",_LanguageKey)
		noteTextBox.isEditable = true
		noteTextBox.font = native.newFont( _FontArr[41],_H/45  )
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
    		-- FONT AND FONT SIZE 
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
        
        --display.remove(subtotalLabel)
--        subtotalLabel = nil
        
        --display.remove(totalItemLabel)
       -- totalItemLabel = nil
        
        --display.remove(totalAddOnsLabel)
        --totalAddOnsLabel = nil
        
        --[[display.remove(serviceTaxLabel)
        serviceTaxLabel = nil
        
        display.remove(otherTaxLabel)
        otherTaxLabel = nil]]--
        
        display.remove(grandTotalLabel)
        grandTotalLabel = nil
        
        
        display.remove(placeOrderGroup)
        placeOrderGroup = nil
        
        
        --display.remove()
        --noteTextBox = nil
        
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
        
        if(tableNameGetRequest) then
        	network.cancel( tableNameGetRequest )
            tableNameGetRequest = nil
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