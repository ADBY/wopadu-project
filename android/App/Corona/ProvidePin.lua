local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------
sConnect = require("stripe")

local ImageDirectory = "images/PopUp/"
local createPinGroup,yPos,textFieldWidth,textFieldHeight
local firstPinChar,secondPinChar,thirdPinChar,fourthPinChar

local VariableTable = { "textFieldBg1", "textFieldBg2" , "textFieldBg3" ,"textFieldBg4" , "popUpBg", "logo", "CancelButton" ,"ConfirmButton" , "Label2", "Label1", "Label3",
	"textField1" , "textField2" , "textField3" ,"textField4"}

local forgetPinRequest,checkPinRequest,orderEmailRequest,stripePaymentRequest,paymentRequest
local networkReqCount1,networkReqCount2,networkReqCount3,networkReqCount4
local paymentID

local function onDoNothing()

	return true
end


local function OrderEmailNetworkListener( event )
	if ( event.isError ) then
    	print( "Network error!" )
		networkReqCount4 = networkReqCount4 + 1		
    	native.setActivityIndicator( false )
				
		if( networkReqCount4 > 3 ) then		
				
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		else
			
			local url = _WebLink.."email-receipt.php?ws=1&order_id=".._OrderID
			local url2 = url:gsub( " ", "%%20" )
			orderEmailRequest = network.request( url2, "GET", OrderEmailNetworkListener )
			native.setActivityIndicator( true )
			
		end
	else	
		if( event.response == "0" or event.response == 0 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("6Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif( event.response == "1" or event.response == 1 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif( event.response == "2" or event.response == 2 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Order1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif( event.response == "3" or event.response == 3 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif( event.response == "4" or event.response == 4 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Order5Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif( event.response == "5" or event.response == 5 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Email8Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif( event.response == "OK" ) then	
			for i = 1, #_CartArray do
			
				table.remove( _CartArray,(i - (i-1)) )
			
			end
			
			_OrderID = nil
			_PlaceOrderTotal = nil
			local options = {
    			isModal = true,
    			effect = "fade",
    			time = 400
			}
			--local alert = native.showAlert( alertLabel, "Your order has been placed successfully.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk )
			local function gotoShowOverlay()
			
				composer.gotoScene( "OrderPopUp", options )
			
			end
			timer.performWithDelay(200,gotoShowOverlay,1)
		end
	end
	return true
end

local function OrderPaymentNetworkListener( event )
	if ( event.isError ) then
    	print( "Network error!" )
				
    	networkReqCount3 = networkReqCount3 + 1
    	native.setActivityIndicator( false )
		
		if( networkReqCount3 > 3) then 
				
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		else
			
			local url = _WebLink.."place-order-payment.php?user_id=".._UserID.."&store_id=".._StoreID.."&order_id=".._OrderID.."&transaction_id="..paymentID
			local url2 = url:gsub( " ", "%%20" )
			paymentRequest = network.request( url2, "GET", OrderPaymentNetworkListener )
			native.setActivityIndicator( true )
			
		end		
	else	
		timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		
		print("Place order Response in card selection page.."..event.response)
		if( event.response == "0" or event.response == 0 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("6Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		elseif( event.response == "1" or event.response == 1 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif( event.response == "2" or event.response == 2 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif( event.response == "3" or event.response == 3 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Order1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif( event.response == "4" or event.response == 4 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif( event.response == "OK" ) then
			--local alert = native.showAlert( alertLabel, " Payment has been successful", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				--[[local headers = {}
		
				headers["Content-Type"] = "application/x-www-form-urlencoded"
				headers["Accept-Language"] = "en-US"
		
				local body = "ws=1&order_id=".._OrderID
				local params = {}
				params.headers = headers
				params.body = body
				params.timeout = 180
		
				local url = _WebLink.."email-receipt.php?"
		
				orderEmailRequest = network.request( url, "POST", OrderEmailNetworkListener, params )
				]]--
				
				local url = _WebLink.."email-receipt.php?ws=1&order_id=".._OrderID
				local url2 = url:gsub( " ", "%%20" )
				print( url2 )
				orderEmailRequest = network.request( url2, "GET", OrderEmailNetworkListener )
				native.setActivityIndicator( true )
				
			
		end
	end
	return true
end


local function paymentNetworkListener( event )
        if ( event.isError ) then
            print( "Network error!" )
            timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
			local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )

        else
            print( "RESPONSE: "..event.response )
            
            timer.performWithDelay( 1000, function() 
    		native.setActivityIndicator( false )
			end )
			
            local data1 = event.response
            resp1 = json.decode(data1)
            print(data1)
            local error = resp1.error
            if error ~= nil then
                for i = 1, #resp1.error do
                    print(resp1.error[i].type)
                    print(resp1.error[i].message)
                end 
            end
           
            if error == nil then
                
                paymentID = resp1.id
				
				--[[local headers = {}
		
				headers["Content-Type"] = "application/x-www-form-urlencoded"
				headers["Accept-Language"] = "en-US"
		
				local body = "user_id=".._UserID.."&store_id=".._StoreID.."&order_id=".._OrderID.."&transaction_id="..paymentID
				local params = {}
				params.headers = headers
				params.body = body
				params.timeout = 180
		
				local url = _WebLink.."place-order-payment.php?"
		
				paymentRequest = network.request( url, "POST", OrderPaymentNetworkListener, params )]]--
				
				local url = _WebLink.."place-order-payment.php?user_id=".._UserID.."&store_id=".._StoreID.."&order_id=".._OrderID.."&transaction_id="..paymentID
				local url2 = url:gsub( " ", "%%20" )
				paymentRequest = network.request( url2, "GET", OrderPaymentNetworkListener )
				native.setActivityIndicator( true )
				
				
				
			else
			
				print(error.message)	
            	local alert = native.showAlert( alertLabel,error.message, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
               
            end 
            
        end
    end
    
local function onDoNothing2( event )
	VariableTable.textField1.text = ""
	firstPinChar = ""
end    
    

local function checkPinNetworkListener( event )
	if ( event.isError ) then
        print( "Network error!" )
        networkReqCount2 = networkReqCount2 + 1
        
    	native.setActivityIndicator( false )
		
		if(networkReqCount2 > 3) then
		
			local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		else
		
			--local PinValue = VariableTable.textField1.text..VariableTable.textField2.text..VariableTable.textField3.text..VariableTable.textField4.text
        	local PinValue = firstPinChar
        	
			local url = _WebLink.."stripe-check.php?user_id=".._UserID.."&store_id=".._StoreID.."&stripe_id=".._StripeCustomerID.."&pin_number="..PinValue
			local url2 = url:gsub( " ", "%%20" )
			checkPinRequest = network.request( url2, "GET", checkPinNetworkListener )
			native.setActivityIndicator( true )
		
		end
    else
        print ( "Provide Pin RESPONSE:" .. event.response )
        
        local frgtPinList = json.decode(event.response)
        
        if( event.response == 0 or event.response == "0") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
        
        elseif( event.response == 1 or event.response == "1") then
    		timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
        
        elseif( event.response == 2 or event.response == "2") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Pin2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
        
        elseif( event.response == 3 or event.response == "3") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
        
        elseif( event.response == 4 or event.response == "4") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("User2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
        
        elseif( event.response == 5 or event.response == "5") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("Pin1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
        
        elseif( event.response == 6 or event.response == "6") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
			
        	local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("Pin3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
        
        elseif( event.response == 6 or event.response == "7") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
			
        	local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("Pin5Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
        
        elseif( event.response == 6 or event.response == "8") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
			
        	local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("Pin6Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
        
        elseif( event.response == "OK" ) then
        	print("successfully enterd pin")
        	
        	local chargeDescription = "TestCharge"
			local customer = _StripeCustomerID
			local currency = "usd" 
			local amount = tostring(tonumber(_PlaceOrderTotal) * 100 ) 
			local description = ""
			
			local appFees = ((tonumber(amount) * _AppFee) / 100)		
			print( "total amout is  .. "..amount.. " & app fees is 10% so actual app fee is .."..appFees )
	
			local newCharge = "amount="..amount.."&currency="..currency.."&customer="..customer.."&description="..description.."&application_fee="..appFees.."&destination="..desti 
	
			
			--local newCharge = "amount="..amount.."&currency="..currency.."&customer="..customer.."&description="..description
			
			local key = {["Bearer"] = strip_api_key}
    
    		local headers = { 
        		["Authorization"] ="Bearer "..strip_api_key,
        		["Content-Type"] = "application/x-www-form-urlencoded"
    		}
    
    		local params = {}
    		params.headers = headers
    		params.body =  newCharge 
    
    		print( "params.body: "..params.body )
   		 	stripePaymentRequest = network.request("https://api.stripe.com/v1/charges", "POST", paymentNetworkListener, params)
    		
    		native.setActivityIndicator( true )
        	
        end
	end
	return true
end

local function handleButtonEvent( event )
    if ( "ended" == event.phase ) then
        print( "Button was pressed and released" )
        if(event.target.id == "CANCEL") then
        	--composer.hideOverlay( "fade" )
        	composer.gotoScene("PlaceOrder")
        elseif(event.target.id == "CONFIRM") then
        	if( VariableTable.textField1.text == "" ) then
        			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Pin4Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        		
        	else
        		--composer.gotoScene( "cardSelection" )
        		--stripe-check.php?user_id=1&stripe_id=shirishmakwana&pin_number=1234
        			--local PinValue = VariableTable.textField1.text..VariableTable.textField2.text..VariableTable.textField3.text..VariableTable.textField4.text
        			local PinValue = firstPinChar
        			
					--[[local headers = {}
			
					headers["Content-Type"] = "application/x-www-form-urlencoded"
					headers["Accept-Language"] = "en-US"

					local body = "user_id=".._UserID.."&stripe_id=".._StripeCustomerID.."&pin_number="..PinValue
					local params = {}
					params.headers = headers
					params.body = body
					params.timeout = 180
				
					local url = _WebLink.."stripe-check.php?"
					print( url..body )
					checkPinRequest = network.request( url, "POST", checkPinNetworkListener, params )]]--
					

					local url = _WebLink.."stripe-check.php?user_id=".._UserID.."&store_id=".._StoreID.."&stripe_id=".._StripeCustomerID.."&pin_number="..PinValue
					local url2 = url:gsub( " ", "%%20" )
					checkPinRequest = network.request( url2, "GET", checkPinNetworkListener )
					native.setActivityIndicator( true )
					
					print( url2 )

        	end
        end
    end
    return true
end


local function onFirstDigit( event )
	if ( event.phase == "began" ) then
		createPinGroup.y = createPinGroup.y - _H/8
		
    elseif ( event.phase == "ended" ) then
    	--native.setKeyboardFocus(nil)
    	createPinGroup.y = yPos
    	if( VariableTable.textField1.text == "" or VariableTable.textField1.text == nil ) then
			firstPinChar = ""
		end
    elseif ( event.phase == "submitted" ) then
		--native.setKeyboardFocus(nil)
		createPinGroup.y = yPos
		if( VariableTable.textField1.text == "" or VariableTable.textField1.text == nil ) then
			firstPinChar = ""
		end
    elseif ( event.phase == "editing" ) then
    	print( "new.."..event.newCharacters )
    	if( VariableTable.textField1.text == "" or VariableTable.textField1.text == nil ) then
			firstPinChar = ""
		end
    	if( event.newCharacters == "" or event.newCharacters == nil ) then
    	
    	else
    		firstPinChar = firstPinChar .. event.newCharacters
    		VariableTable.textField1.text = VariableTable.textField1.text:gsub( event.newCharacters,"*" )
    	end
    	
		
    end
	return true
end

local function onSecondDigit( event )
	if ( event.phase == "began" ) then
		createPinGroup.y = createPinGroup.y - _H/8
    elseif ( event.phase == "ended" ) then
    	--native.setKeyboardFocus(nil)
    	createPinGroup.y = yPos
    elseif ( event.phase == "submitted" ) then
		--native.setKeyboardFocus(nil)
		createPinGroup.y = yPos
    elseif ( event.phase == "editing" ) then
    	print( "new.."..event.newCharacters )
		if(event.target.text:len() > 0) then
			VariableTable.textField2.text = ""
			VariableTable.textField2.text = event.newCharacters
			secondPinChar = VariableTable.textField2.text
			VariableTable.textField2.text = "*"
			native.setKeyboardFocus(VariableTable.textField3)
		else
		end	
		
    end

	return true
end

local function onThirdDigit( event )
	if ( event.phase == "began" ) then
		createPinGroup.y = createPinGroup.y - _H/8
    elseif ( event.phase == "ended" ) then
    	--native.setKeyboardFocus(nil)
    	createPinGroup.y = yPos
    elseif ( event.phase == "submitted" ) then
		--native.setKeyboardFocus(nil)
		createPinGroup.y = yPos
    elseif ( event.phase == "editing" ) then
    	print( "new.."..event.newCharacters )
    	
		if(event.target.text:len() > 0) then
			VariableTable.textField3.text = ""
			VariableTable.textField3.text = event.newCharacters
			thirdPinChar = VariableTable.textField3.text
			VariableTable.textField3.text = "*"
			native.setKeyboardFocus(VariableTable.textField4)
		else
		end	
		
    end
	return true
end

local function onFourthDigit( event )
	if ( event.phase == "began" ) then
		createPinGroup.y = createPinGroup.y - _H/8
    elseif ( event.phase == "ended" ) then
    	native.setKeyboardFocus(nil)
    	createPinGroup.y = yPos
    elseif ( event.phase == "submitted" ) then
		native.setKeyboardFocus(nil)
		createPinGroup.y = yPos
    elseif ( event.phase == "editing" ) then
    	print( "new.."..event.newCharacters )
		if(event.target.text:len() > 0) then
			VariableTable.textField4.text = ""
			VariableTable.textField4.text = event.newCharacters
			fourthPinChar = VariableTable.textField4.text
			VariableTable.textField4.text = "*"
			native.setKeyboardFocus(nil)
		else
		end	
		
    end

	return true
end



local function forgetPinNetworkListener( event )
	
	if ( event.isError ) then
        print( "Network error!" )
        
        networkReqCount1 = networkReqCount1 + 1
        
    	native.setActivityIndicator( false )
		
		if( networkReqCount1 > 3 ) then
		
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		else
		
			local url = _WebLink.."forgot-pin.php?ws=1&email=".._UserName
			local url2 = url:gsub( " ", "%%20" )
			forgetPinRequest = network.request( url2, "GET", forgetPinNetworkListener )
			native.setActivityIndicator( true )
		
		end	
    else
        print ( "RESPONSE:" .. event.response )
        
        local frgtPinList = json.decode(event.response)
        
        if( event.response == 0 or event.response == "0") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( event.response == "1" or event.response == 1 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Email5Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == "2" or event.response == 2 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Email3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( event.response == "3" or event.response == 3 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( event.response == "4" or event.response == 4 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("Email4Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( event.response == "OK" ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Email7Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        end
        

	end
	--Background:addEventListener("touch",onBgTouch)
	return true
end


local function handleForgetPinEvent( event )
	print("forget pin func............................")
	--forgot-pin.php?email=shirishm.makwana@gmail.com
	--Background:removeEventListener("touch",onBgTouch)
	--[[local headers = {}
			
	headers["Content-Type"] = "application/x-www-form-urlencoded"
	headers["Accept-Language"] = "en-US"

	local body = "ws=1&email=".._UserName
	local params = {}
	params.headers = headers
	params.body = body
	params.timeout = 180
				
	local url = _WebLink.."forgot-pin.php?"
	print( url..body )
	forgetPinRequest = network.request( url, "POST", forgetPinNetworkListener, params )
	]]--
	
	local url = _WebLink.."forgot-pin.php?ws=1&email=".._UserName
	local url2 = url:gsub( " ", "%%20" )
	forgetPinRequest = network.request( url2, "GET", forgetPinNetworkListener )
	native.setActivityIndicator( true )
	
	return true
end

local function onBgTap( event )
	composer.gotoScene("PlaceOrder")
	return true
end

local function onBgTouch( event )
	if( event.phase == "ended" ) then
		print("bg touch func................................")
		composer.gotoScene("PlaceOrder")
	end
	return true
end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    
    local whiteBg = display.newImageRect( "images/Login/White_Background.png", _W, _H )
    whiteBg.x = _W/2
    whiteBg.y = _H/2
    sceneGroup:insert( whiteBg )
    
    Background = display.newImageRect(ImageDirectory.."Background.png",_W,_H)
    Background.x = _W/2
    Background.y = _H/2
   -- Background:addEventListener("tap",onBgTap)
   -- Background:addEventListener("touch",onBgTouch)
    sceneGroup:insert(Background)
    
   
	
    
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
        firstPinChar = ""
        
        createPinGroup = display.newGroup()
        sceneGroup:insert(createPinGroup)
        networkReqCount1 = 0
        networkReqCount2 = 0
        networkReqCount3 = 0 
        networkReqCount4 = 0
        
	VariableTable.popUpBg = display.newImageRect(ImageDirectory.."PopUpBg.png",_W/1.15,_H/2.70)
    VariableTable.popUpBg.x = _W/2
    VariableTable.popUpBg.y = _H/3.07 + VariableTable.popUpBg.height/2
    createPinGroup:insert(VariableTable.popUpBg)
    
    VariableTable.logo = display.newImageRect("images/Wopadu_Logo.png",_W/5.83,_H/10.37)
    VariableTable.logo.x = VariableTable.popUpBg.x
    VariableTable.logo.y = VariableTable.popUpBg.y - VariableTable.popUpBg.height/2.15	
    createPinGroup:insert(VariableTable.logo)
    
    --130,1120
    
    textFieldWidth = _W/7.44 - _W/32
    textFieldHeight = _H/13.24 - _H/64
    

	VariableTable.CancelButton = widget.newButton
	{
    	width = _W/2.79,
    	height = _H/14.65,
    	defaultFile = ImageDirectory.."Cancel_Btn2.png",
    	overFile = ImageDirectory.."Cancel_Btn2.png",
    	label = GBCLanguageCabinet.getText("CancelLabel",_LanguageKey),
    	id = "CANCEL",
    	font = _FontArr[6],
    	fontSize = _H/27.55,
    	labelYOffset = _H/192,
    	labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
    	onEvent = handleButtonEvent
	}

	-- Center the button
	VariableTable.CancelButton.x = _W/8.30 + VariableTable.CancelButton.width/2
	VariableTable.CancelButton.y = _H/1.48 - VariableTable.CancelButton.height/2
	createPinGroup:insert(VariableTable.CancelButton)
	
	VariableTable.ConfirmButton = widget.newButton
	{
    	width = _W/2.79,
    	height = _H/14.65,
    	defaultFile = ImageDirectory.."Create_Btn2.png",
    	overFile = ImageDirectory.."Create_Btn2.png",
    	label = GBCLanguageCabinet.getText("ConfirmLabel",_LanguageKey),
    	id = "CONFIRM",
    	font = _FontArr[6],
    	fontSize = _H/27.55,
    	labelYOffset = _H/192,
    	labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
    	onEvent = handleButtonEvent
	}

	-- Center the button
	VariableTable.ConfirmButton.x = _W/1.92 + VariableTable.ConfirmButton.width/2
	VariableTable.ConfirmButton.y = VariableTable.CancelButton.y
	createPinGroup:insert(VariableTable.ConfirmButton)
	
	
	local option2 = {
		text = "",
		font = _FontArr[6],
		fontSize = _H/31.48,
		
	}
	
	VariableTable.Label2 = display.newText(option2)
	VariableTable.Label2.text = GBCLanguageCabinet.getText("ProvidePinLabel",_LanguageKey) 
	VariableTable.Label2.x = _W/3.6
	VariableTable.Label2.y = _H/2.55   --_H/2.37
	VariableTable.Label2.anchorX = 0
	VariableTable.Label2.anchorY = 0
	VariableTable.Label2:setFillColor( 83/255, 20/255, 111/255 )
	createPinGroup:insert(VariableTable.Label2)
	
	local option = {
		text = "",
		font = _FontArr[7],
		fontSize = _H/31.48,
		
	}
	
	--[[VariableTable.Label1 = display.newText(option)
	VariableTable.Label1.text = "4 digit"
	VariableTable.Label1.x =  VariableTable.Label2.x + VariableTable.Label2.width + _W/54--_W/2.55
	VariableTable.Label1.y = VariableTable.Label2.y
	VariableTable.Label1.anchorX = 0
	VariableTable.Label1.anchorY = 0
	VariableTable.Label1:setFillColor( 83/255, 20/255, 111/255 )
	createPinGroup:insert(VariableTable.Label1)
	
	VariableTable.Label3 = display.newText(option2)
	VariableTable.Label3.text = "pin"
	VariableTable.Label3.x = VariableTable.Label1.x + VariableTable.Label1.width + _W/54
	VariableTable.Label3.y = VariableTable.Label1.y 
	VariableTable.Label3.anchorX = 0
	VariableTable.Label3.anchorY = 0
	VariableTable.Label3:setFillColor( 83/255, 20/255, 111/255 )
	createPinGroup:insert(VariableTable.Label3)]]--
    
    VariableTable.textFieldBg1 = display.newImageRect("images/SignUp/f_TextField.png",VariableTable.popUpBg.width - _W/10.8,_H/13.24)
    VariableTable.textFieldBg1.x = _W/2 -- _W/6.75 + VariableTable.textFieldBg1.width/2
    VariableTable.textFieldBg1.y = _H/2.25 + VariableTable.textFieldBg1.height/2
    createPinGroup:insert(VariableTable.textFieldBg1)
        
    VariableTable.textField1 = native.newTextField( VariableTable.textFieldBg1.x, VariableTable.textFieldBg1.y,VariableTable.textFieldBg1.width - _W/27,textFieldHeight  )    
   	VariableTable.textField1.hasBackground = false
	VariableTable.textField1.placeholder = ""
	VariableTable.textField1.inputType = "number"
	VariableTable.textField1:addEventListener( "userInput", onFirstDigit )
	VariableTable.textField1.font = native.newFont( _FontArr[10], _H/36.80 )
	createPinGroup:insert( VariableTable.textField1 )  
	
	
	--[[VariableTable.textFieldBg2 = display.newImageRect(ImageDirectory.."TextField1.png",_W/7.44,_H/13.24)
    VariableTable.textFieldBg2.x = _W/3 + VariableTable.textFieldBg2.width/2
    VariableTable.textFieldBg2.y = _H/2.25 + VariableTable.textFieldBg2.height/2
    createPinGroup:insert(VariableTable.textFieldBg2)
        
    VariableTable.textField2 = native.newTextField( VariableTable.textFieldBg2.x, VariableTable.textFieldBg2.y,textFieldWidth,textFieldHeight  )    
   	VariableTable.textField2.hasBackground = false
    VariableTable.textField2.inputType = "number"
	VariableTable.textField2.placeholder = "0"
	VariableTable.textField2.align = "center"
	VariableTable.textField2:addEventListener( "userInput", onSecondDigit )
	VariableTable.textField2.font = native.newFont( _FontArr[10], _H/36.80 )
	createPinGroup:insert( VariableTable.textField2 )  
	
	VariableTable.textFieldBg3 = display.newImageRect(ImageDirectory.."TextField1.png",_W/7.44,_H/13.24)
    VariableTable.textFieldBg3.x = _W/1.89 + VariableTable.textFieldBg3.width/2
    VariableTable.textFieldBg3.y = _H/2.25 + VariableTable.textFieldBg3.height/2
    createPinGroup:insert(VariableTable.textFieldBg3)
        
    VariableTable.textField3 = native.newTextField( VariableTable.textFieldBg3.x, VariableTable.textFieldBg3.y,textFieldWidth,textFieldHeight  )    
   	VariableTable.textField3.hasBackground = false
	VariableTable.textField3.inputType = "number"
	VariableTable.textField3.placeholder = "0"
	VariableTable.textField3.align = "center"
	VariableTable.textField3:addEventListener( "userInput", onThirdDigit )
	VariableTable.textField3.font = native.newFont( _FontArr[10], _H/36.80 )
	createPinGroup:insert( VariableTable.textField3 ) 
	
	VariableTable.textFieldBg4 = display.newImageRect(ImageDirectory.."TextField1.png",_W/7.44,_H/13.24)
    VariableTable.textFieldBg4.x = _W/1.40 + VariableTable.textFieldBg4.width/2
    VariableTable.textFieldBg4.y = _H/2.25 + VariableTable.textFieldBg4.height/2
    createPinGroup:insert(VariableTable.textFieldBg4)
        
    VariableTable.textField4 = native.newTextField( VariableTable.textFieldBg4.x, VariableTable.textFieldBg4.y,textFieldWidth,textFieldHeight  )    
   	VariableTable.textField4.hasBackground = false
	VariableTable.textField4.inputType = "number"
	VariableTable.textField4.placeholder = "0"
	VariableTable.textField4.align = "center"
	VariableTable.textField4:addEventListener( "userInput", onFourthDigit )
	VariableTable.textField4.font = native.newFont( _FontArr[10], _H/36.80 )
	createPinGroup:insert( VariableTable.textField4 )       
        ]]--
        
    forgotPin = display.newText( GBCLanguageCabinet.getText("ForgetPinLabel",_LanguageKey).."?", VariableTable.textFieldBg1.x + VariableTable.textFieldBg1.width/2, VariableTable.textFieldBg1.y + VariableTable.textFieldBg1.height/2 + _H/38.4, _FontArr[6], _H/32 )
	forgotPin.anchorX = 1
	forgotPin.anchorY = 0
    forgotPin:setFillColor( 206/255 ,23/255 ,100/255 )
    createPinGroup:insert( forgotPin )
        
    forgotPinBg = display.newRect( forgotPin.x, forgotPin.y, forgotPin.width + _W/36, forgotPin.height + _H/96 )
    forgotPinBg.anchorX = 1
    forgotPinBg.anchorY = 0
    forgotPinBg:setFillColor( 0, 0, 0, 0.01 )
    forgotPinBg:addEventListener( "tap", handleForgetPinEvent )
    createPinGroup:insert( forgotPinBg )    
    
    forgotPinBg:toFront()
    
    
    yPos = createPinGroup.y    
    print("abc")
        
     native.setKeyboardFocus( VariableTable.textField1 )   
        
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        
        native.setKeyboardFocus(VariableTable.textField1)
        
        
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
        
        textFieldWidth = nil
        textFieldHeight = nil
        VariableTable.textField1.text = ""
        --[[VariableTable.textField2.text = ""
        VariableTable.textField3.text = ""
        VariableTable.textField4.text = ""]]--
        
        
        
        for i = 1, #VariableTable do
        	display.remove(VariableTable[i])
        	VariableTable[i] = nil
        end
        
        if(VariableTable.textField1) then
        	display.remove(VariableTable.textField1)
        	VariableTable.textField1 = nil
        end
        
      --[[  if(VariableTable.textField2) then
        	display.remove(VariableTable.textField2) 
        	VariableTable.textField2 = nil
        end
        
        if(VariableTable.textField3) then
        	display.remove(VariableTable.textField3)
        	VariableTable.textField3 = nil
        end
        
        if(VariableTable.textField4) then
        	display.remove(VariableTable.textField4) 
        	VariableTable.textField4 = nil
        end
        ]]--
        VariableTable = {}
        
        display.remove(createPinGroup)
        createPinGroup = nil
        
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
        if(forgetPinRequest) then
        	network.cancel( forgetPinRequest )
        	forgetPinRequest = nil
        end
        
        if(checkPinRequest) then
        	network.cancel( checkPinRequest )
        	checkPinRequest = nil
        end
        
        if(stripePaymentRequest) then
        	network.cancel( stripePaymentRequest )
        	stripePaymentRequest = nil
        end
        
        if(paymentRequest) then
        	network.cancel( paymentRequest )
        	paymentRequest = nil
        end
        
        if(orderEmailRequest) then
        	network.cancel( orderEmailRequest )
        	orderEmailRequest = nil
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