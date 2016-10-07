local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

local ImageDirectory = "images/PopUp/"
local createPinGroup,yPos,textFieldWidth,textFieldHeight,pin
local parent,param
local paymentRequest,stripePaymentRequest,stripeRegistrationRequest,sRegRequest
local VariableTable = { "textFieldBg1", "textFieldBg2" , "textFieldBg3" ,"textFieldBg4" , "popUpBg", "logo", "CancelButton" ,"CreateButton" , "Label2", "Label1", "Label3",
	"textField1" , "textField2" , "textField3" ,"textField4"}

local networkReqCount1 = 0
local networkReqCount2 = 0

local function handleOk( event )
	VariableTable.textField1.text = ""
	VariableTable.textField2.text = ""
	VariableTable.textField3.text = ""
	VariableTable.textField4.text = ""
	return true
end

local function onDoNothing()

	return true
end

local function onBackToProfile()
	composer.gotoScene( "editProfile" )
	return true
end


local function placeOrdersNetworkListener( event )
	if ( event.isError ) then
    	print( "Network error!" )
				
    	timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
				
		local alert = native.showAlert( alertLabel, NetworkErrorMsg, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				
	else	
		timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		
		
		if( event.response == "0" or event.response == 0 ) then
			local alert = native.showAlert( alertLabel, "All fields are mandatory.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		elseif( event.response == "1" or event.response == 1 ) then
			local alert = native.showAlert( alertLabel, "All fields are mandatory.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		elseif( event.response == "2" or event.response == 2 ) then
			local alert = native.showAlert( alertLabel, "Something went wrong, Query error", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		elseif( event.response == "3" or event.response == 3 ) then
			local alert = native.showAlert( alertLabel, "Something went wrong, Query error", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif( event.response == "4" or event.response == 4 ) then
			local alert = native.showAlert( alertLabel, "Invalid item id", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif( event.response == "5" or event.response == 5 ) then
			local alert = native.showAlert( alertLabel, "Item id not found", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif( event.response == "6" or event.response == 6 ) then
			local alert = native.showAlert( alertLabel, "item  variety not found", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif(event.response == "OK") then
			print(" success response"..event.response)
			for i = 1, #_CartArray do
			
				table.remove( _CartArray,(i - (i-1)) )
				--placeOrderTableView:deleteRow(i)
			
			end
			
			
			--noteTextBox.isVisible = false
			_PlaceOrderBody = nil
			_PlaceOrderTotal = nil
			
			local options = {
    			isModal = true,
    			effect = "fade",
    			time = 400
			}
			--local alert = native.showAlert( alertLabel, "Your order has been placed successfully.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk )
			local function gotoShowOverlay()
			
				composer.gotoScene( "OrderPopUp", options )
				--[[emailTf.isVisible = false
				cardTf.isVisible = false
				expMnthTf.isVisible = false
				expYrTf.isVisible = false
				cvcTf.isVisible = false
	
				createPinBg:removeEventListener( "tap",handleCreatePinEvent )]]--
			end
			timer.performWithDelay(200,gotoShowOverlay,1)
			
			
		else
		
			
			local alert = native.showAlert( alertLabel, "Something went wrong, Query error.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			print("price is changed with effect of discount ")
			
			print(event.response)
		
		end
		
		
	end
	return true
end

local function OrderPaymentNetworkListener( event )
	if ( event.isError ) then
    	print( "Network error!" )
				
		networkReqCount2 = networkReqCount2 + 1	
			
    	native.setActivityIndicator( false )
		
		if( networkReqCount2  > 3 ) then	
				
			local alert = native.showAlert( alertLabel, NetworkErrorMsg, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		else
			local url = _WebLink.."place-order-payment.php?user_id=".._UserID.."&store_id=".._StoreID.."&order_id=".._OrderID.."&transaction_id="..paymentID
			local url2 = url:gsub(" ", "%%20")
			paymentRequest = network.request( url2, "GET", OrderPaymentNetworkListener )
			native.setActivityIndicator( true )
		
		end		
	else	
		timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		
		print("Place order Response in card selection page.."..event.response)
		if( event.response == "0" or event.response == 0 ) then
			local alert = native.showAlert( alertLabel, "All fields are mandatory.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		elseif( event.response == "1" or event.response == 1 ) then
			local alert = native.showAlert( alertLabel, "All fields are mandatory.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif( event.response == "2" or event.response == 2 ) then
			local alert = native.showAlert( alertLabel, "Something went wrong, Query error", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif( event.response == "3" or event.response == 3 ) then
			local alert = native.showAlert( alertLabel, "Order does not found", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif( event.response == "4" or event.response == 4 ) then
			local alert = native.showAlert( alertLabel, "Something went wrong, Query Error", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif( event.response == "OK" ) then
			--local alert = native.showAlert( alertLabel, " Payment has been successful", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			for i = 1, #_CartArray do
			
				table.remove( _CartArray,(i - (i-1)) )
			
			end
			
			_OrderID = nil
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


local function paymentNetworkListener( event )
        if ( event.isError ) then
            print( "Network error!" )
        else
            print( "RESPONSE: "..event.response )
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
                --[[chargeId = resp1.id
                chargedCard = resp1.card.id
                chargedCardLastFour = resp1.card.last4
                chargePaid = resp1.paid --true/false
                chargeFail = resp1.failure_message
                print(chargeFail)
                print(chargeId)
                print(chargedCard)
                print(chargedCardLastFour)
                print(chargePaid)
                
                ]]--
                print("payment done successfully")
                
                
               --[[ local headers = {}
		
				headers["Content-Type"] = "application/x-www-form-urlencoded"
				headers["Accept-Language"] = "en-US"
		
				local body = _PlaceOrderBody
				local params = {}
				params.headers = headers
				params.body = body
				params.timeout = 180
		
				local url = _WebLink.."place-order.php?"
		
				network.request( url, "POST", placeOrdersNetworkListener, params )
				native.setActivityIndicator( true )
				print("order url////////")
				print( url..body )]]--
				
				local paymentID = resp1.id
				
				--[[local headers = {}
		
				headers["Content-Type"] = "application/x-www-form-urlencoded"
				headers["Accept-Language"] = "en-US"
		
				local body = "user_id=".._UserID.."&store_id=".._StoreID.."&order_id=".._OrderID.."&transaction_id="..paymentID
				local params = {}
				params.headers = headers
				params.body = body
				params.timeout = 180
		
				local url = _WebLink.."place-order-payment.php?
		
				paymentRequest = network.request( url, "POST", OrderPaymentNetworkListener, params )
				native.setActivityIndicator( true )]]--
				
				local url = _WebLink.."place-order-payment.php?user_id=".._UserID.."&store_id=".._StoreID.."&order_id=".._OrderID.."&transaction_id="..paymentID
				local url2 = url:gsub(" ", "%%20")
				paymentRequest = network.request( url2, "GET", OrderPaymentNetworkListener )
				native.setActivityIndicator( true )
				
				
				
				
            end 
            
        end
    end
    
local function doPaymentFunc()
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
	
	return true
end

local function storeData(name,data)
	local saveData = data
	local path = system.pathForFile( name, system.DocumentsDirectory )
	local file = io.open( path, "w" )
	file:write( saveData )
	io.close( file )
	file = nil
end

local function StipeRegisterNetworkListener( event )
	if ( event.isError ) then
        print( "Network error!" )
        
        networkReqCount1 = networkReqCount1 + 1
    	native.setActivityIndicator( false )
		
		
		if( networkReqCount1 > 3 ) then
			
			local alert = native.showAlert( alertLabel, NetworkErrorMsg, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
		else
		
			local url = _WebLink.."stripe-add.php?user_id=".._UserID.."&store_id=".._StoreID.."&stripe_acc_id=".._StripeCustomerID.."&cvv_number="..cvc.."&card_number="..cardNumber.."&exp_date_month="..expMonth.."&exp_date_year="..expYear.."&secret_key="..strip_api_key.."&publishable_key="..stripe_Public_key.."&pin_number="..pin
			local url2 = url:gsub(" ", "%%20")
			sRegRequest = network.request( url2, "GET", StipeRegisterNetworkListener )
			native.setActivityIndicator( true )
			
		end
    else
        print ( "RESPONSE:" .. event.response )
        	
        local frgtPinList = json.decode(event.response)
        
        if( event.response == 0 or event.response == "0") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "All fields are mandatory.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 1 or event.response == "1") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "All fields are mandatory.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( event.response == 2 or event.response == "2") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Something went wrong.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( event.response == 3 or event.response == "3") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "User id does not exists.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 4 or event.response == "4") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Invalid pin number.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 5 or event.response == "5") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Something went wrong.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( event.response == 6 or event.response == "6") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Something went wrong.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        					
        elseif( event.response == 7 or event.response == "7") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Stripe id already exists for this store.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        		
        elseif( event.response == 8 or event.response == "8") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Something went wrong.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
      	else
        		storeData( "S_ID", _StripeCustomerID )
        		
				storeData( "S_CardNo", param.cardNo )
				storeData( "S_CVVNo", param.CVCNo )
				storeData( "S_ExpiryMonth", param.e_Month )
				storeData( "S_ExpiryYear", param.e_Year )
				storeData( "S_Pin", pin )
				
				_StripeCardNo = param.cardNo
				_StripeCVVNo = param.CVCNo
				_StripeExpMont = param.e_Month
				_StripeExpYear =  param.e_Year 
				_StripePin = pin
				
        	
        	if(stripeRegisterPreviousPage == "editProfile") then
        		
        		local function onGoBack( event )
        			
        			composer.gotoScene( "editProfile" )
        			
        			return true
        		end
        		
        		timer.performWithDelay( 200, function() 
    			native.setActivityIndicator( false )
				end )
        		local alert = native.showAlert( alertLabel, "Stripe Registration Successful.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onGoBack )
        	else
        		doPaymentFunc()
        	end
        end
        
	end
	return true
end


local function registerNetworkListener( event )
        if ( event.isError ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
            print( "Network error!" )
        else
            print( "RESPONSE: "..event.response )
            timer.performWithDelay( 200, function() 
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
            else
            
            	--print("error has been occured while updaing/registraing account in stripe -- 1")

            end
           
          	if error == nil then
          		
                _StripeCustomerID = resp1.id
                
               --stripe-register.php?user_id=1&stripe_id=shirishmakwana&pin_number=1234
					--[[local headers = {}
			
					headers["Content-Type"] = "application/x-www-form-urlencoded"
					headers["Accept-Language"] = "en-US"

					local body = "user_id=".._UserID.."&stripe_id=".._StripeCustomerID.."&pin_number="..pin
					local params = {}
					params.headers = headers
					params.body = body
					params.timeout = 180
				
					local url = _WebLink.."stripe-register.php?"
					print( url..body )
					sRegRequest = network.request( url, "POST", StipeRegisterNetworkListener, params )]]--
					local email = param.email
					local description = ""
					local cardNumber = param.cardNo
					local expYear = param.e_Year
					local expMonth = param.e_Month
					local cvc = param.CVCNo
					local fullName = ""
					
					--local url = _WebLink.."stripe-register.php?user_id=".._UserID.."&stripe_id=".._StripeCustomerID.."&pin_number="..pin
					local url = _WebLink.."stripe-add.php?user_id=".._UserID.."&store_id=".._StoreID.."&stripe_acc_id=".._StripeCustomerID.."&cvv_number="..cvc.."&card_number="..cardNumber.."&exp_date_month="..expMonth.."&exp_date_year="..expYear.."&secret_key="..strip_api_key.."&publishable_key="..stripe_Public_key.."&pin_number="..pin
					local url2 = url:gsub(" ", "%%20")
					sRegRequest = network.request( url2, "GET", StipeRegisterNetworkListener )
					native.setActivityIndicator( true )
					
                	print( "webservice for add stripe"..url2 )
                	
                return resp1
            else
            
            	local function onHandleError( event )
            		local typ
            		if(error.param == "exp_year") then
            			typ = "exp_year"
            		elseif(error.param == "exp_month") then
            			typ = "exp_month"
            		elseif(error.param == "number") then
            			typ = "number"
            		elseif(error.param == "cvc") then
            			typ = "cvc"
            		else
            			typ = "NA"
            		end
            		
            		composer.setVariable( "ErrorType", typ )
            		
            		composer.hideOverlay( "fade" )
            	end
            	
            	local alert = native.showAlert( alertLabel,error.message, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onHandleError )
            	print(error.message)
            	
            end 
            
        end
    end


local function handleButtonEvent( event )
    if ( "ended" == event.phase ) then
        print( "Button was pressed and released" )
        if(event.target.id == "CANCEL") then
        	composer.setVariable( "ErrorType", "Cancel" )
        	composer.hideOverlay( "fade" )
        elseif(event.target.id == "CREATE") then
        	if(VariableTable.textField1.text == "" or VariableTable.textField2.text == "" or VariableTable.textField4.text == "" or VariableTable.textField4.text == "" ) then
        		
        		local alert = native.showAlert( alertLabel, "Please enter all 4 digits", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk )
        	
        	else
        	
        	--[[local t1 = VariableTable.textField1.text:sub(" ","%%20")
        	local t2 = VariableTable.textField2.text:sub(" ","%%20")
        	local t3 = VariableTable.textField3.text:sub(" ","%%20")
        	local t4 = VariableTable.textField4.text:sub(" ","%%20")
        	
        	if(t1 == "" or t2 == "" or t3 == "" or t4 == "") then
        		print("Please insert all 4 digits")
        		local alert = native.showAlert( alertLabel, "Please enter all 4 digits", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk )

        	else]]--
        		
        		pin = VariableTable.textField1.text..VariableTable.textField2.text..VariableTable.textField3.text..VariableTable.textField4.text
		
				local email = param.email
				local description = ""
				local cardNumber = param.cardNo
				local expYear = param.e_Year
				local expMonth = param.e_Month
				local cvc = param.CVCNo
				local fullName = ""
 
    				local newCustomer = "email="..email.."&description="..description.."&card[number]="..cardNumber.."&card[exp_year]="..expYear.."&card[exp_month]="..expMonth.."&card[cvc]="..cvc--{["email"] = email, ["description"] = description}--, ["card"] = firstCard}
    
    				print(newCharge)
    
    				local key = {["Bearer"] = strip_api_key}
    
    				local headers = { 
        				["Authorization"] ="Bearer "..strip_api_key,
        				["Content-Type"] = "application/x-www-form-urlencoded"
    				}
    
    
    				local params = {}
    				params.headers = headers
    				params.body =  newCustomer 
    
    				print( "params.body: "..params.body )
    
   					stripeRegistrationRequest = network.request("https://api.stripe.com/v1/customers", "POST", registerNetworkListener, params)
					
    				native.setActivityIndicator( true )
			
					
			
        	
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
    elseif ( event.phase == "submitted" ) then
		--native.setKeyboardFocus(nil)
		createPinGroup.y = yPos
    elseif ( event.phase == "editing" ) then
    	print( "new.."..event.newCharacters )
		if(event.target.text:len() > 0) then
			VariableTable.textField1.text = ""
			VariableTable.textField1.text = event.newCharacters
			native.setKeyboardFocus(VariableTable.textField2)
		else
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
			native.setKeyboardFocus(nil)
		else
		end	
		
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
    
    local Background = display.newImageRect(ImageDirectory.."Background.png",_W,_H)
    Background.x = _W/2
    Background.y = _H/2
    sceneGroup:insert(Background)
    
   
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
	param = event.params
    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        networkReqCount1 = 0
	 	networkReqCount2 = 0
        
        createPinGroup = display.newGroup()
        sceneGroup:insert(createPinGroup)
        
        
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
    	font = _FontArr[1],
    	fontSize = _H/27.55,
    	labelYOffset = -_H/192,
    	labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
    	onEvent = handleButtonEvent
	}

	-- Center the button
	VariableTable.CancelButton.x = _W/8.30 + VariableTable.CancelButton.width/2
	VariableTable.CancelButton.y = _H/1.52 - VariableTable.CancelButton.height/2
	createPinGroup:insert(VariableTable.CancelButton)
	
	VariableTable.CreateButton = widget.newButton
	{
    	width = _W/2.79,
    	height = _H/14.65,
    	defaultFile = ImageDirectory.."Create_Btn2.png",
    	overFile = ImageDirectory.."Create_Btn2.png",
    	label = GBCLanguageCabinet.getText("CreateLabel",_LanguageKey),
    	id = "CREATE",
    	font = _FontArr[1],
    	fontSize = _H/27.55,
    	labelYOffset = -_H/192,
    	labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
    	onEvent = handleButtonEvent
	}

	-- Center the button
	VariableTable.CreateButton.x = _W/1.92 + VariableTable.CreateButton.width/2
	VariableTable.CreateButton.y = VariableTable.CancelButton.y
	createPinGroup:insert(VariableTable.CreateButton)
	
	
	local option2 = {
		text = "",
		font = _FontArr[6],
		fontSize = _H/31.48,
		
	}
	
	VariableTable.Label2 = display.newText(option2)
	VariableTable.Label2.text = GBCLanguageCabinet.getText("CreatePinLabel",_LanguageKey)
	VariableTable.Label2.x = _W/3.6
	VariableTable.Label2.y = _H/2.37
	VariableTable.Label2.anchorX = 0
	VariableTable.Label2.anchorY = 0
	VariableTable.Label2:setFillColor( 83/255, 20/255, 111/255 )
	createPinGroup:insert(VariableTable.Label2)
	
	--[[local option = {
		text = "",
		font = _FontArr[7],
		fontSize = _H/31.48,
		
	}
	
	VariableTable.Label1 = display.newText(option)
	VariableTable.Label1.text = "4 digit"
	VariableTable.Label1.x =  VariableTable.Label2.x + VariableTable.Label2.width + _W/54--_W/2.55
	VariableTable.Label1.y = _H/2.37
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
    
    VariableTable.textFieldBg1 = display.newImageRect(ImageDirectory.."TextField1.png",_W/7.44,_H/13.24)
    VariableTable.textFieldBg1.x = _W/6.75 + VariableTable.textFieldBg1.width/2
    VariableTable.textFieldBg1.y = _H/2.14 + VariableTable.textFieldBg1.height/2
    createPinGroup:insert(VariableTable.textFieldBg1)
        
    VariableTable.textField1 = native.newTextField( VariableTable.textFieldBg1.x, VariableTable.textFieldBg1.y,textFieldWidth,textFieldHeight  )    
   	VariableTable.textField1.hasBackground = false
	VariableTable.textField1.inputType = "number"
	VariableTable.textField1.placeholder = "0"
	VariableTable.textField1.align = "center"
	VariableTable.textField1:addEventListener( "userInput", onFirstDigit )
	VariableTable.textField1.font = native.newFont( _FontArr[10], _H/36.80 )
	createPinGroup:insert( VariableTable.textField1 )  
	
	
	
	VariableTable.textFieldBg2 = display.newImageRect(ImageDirectory.."TextField1.png",_W/7.44,_H/13.24)
    VariableTable.textFieldBg2.x = _W/3 + VariableTable.textFieldBg2.width/2
    VariableTable.textFieldBg2.y = _H/2.14 + VariableTable.textFieldBg2.height/2
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
    VariableTable.textFieldBg3.y = _H/2.14 + VariableTable.textFieldBg3.height/2
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
    VariableTable.textFieldBg4.y = _H/2.14 + VariableTable.textFieldBg4.height/2
    createPinGroup:insert(VariableTable.textFieldBg4)
        
    VariableTable.textField4 = native.newTextField( VariableTable.textFieldBg4.x, VariableTable.textFieldBg4.y,textFieldWidth,textFieldHeight  )    
   	VariableTable.textField4.hasBackground = false
	VariableTable.textField4.inputType = "number"
	VariableTable.textField4.placeholder = "0"
	VariableTable.textField4.align = "center"
	VariableTable.textField4:addEventListener( "userInput", onFourthDigit )
	VariableTable.textField4.font = native.newFont( _FontArr[10], _H/36.80 )
	createPinGroup:insert( VariableTable.textField4 )       
        
    yPos = createPinGroup.y    
        
        
local function onKeyEvent( event )
    -- If the "back" key was pressed on Android, then prevent it from backing out of your app.
	if (event.keyName == "back") and (system.getInfo("platformName") == "Android") and event.phase == "up"  then
    	
    	composer.hideOverlay( "fade" )
		
	end

	return true
end
        
      
Runtime:addEventListener( "key", onKeyEvent )
           
    	native.setKeyboardFocus( VariableTable.textField1 )  
        
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
	parent = event.parent
    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
        
        textFieldWidth = nil
        textFieldHeight = nil
        
        for i = 1, #VariableTable do
        	display.remove(VariableTable[i])
        	VariableTable[i] = nil
        end
        
        VariableTable = {}
        
        display.remove(createPinGroup)
        createPinGroup = nil
        
        Runtime:removeEventListener( "key", onKeyEvent )
        
        if(stripeRegisterPreviousPage == "editProfile") then
        
        else
        	parent:resumeApp()
        end
        
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
        
        if(paymentRequest) then
        	network.cancel( paymentRequest )
        	paymentRequest = nil
        end
        
        if(stripeRegistrationRequest) then
        	network.cancel( stripeRegistrationRequest )
        	stripeRegistrationRequest = nil
        end
        
        if(sRegRequest) then
        	network.cancel( sRegRequest )
        	sRegRequest = nil
        end
        
        if(stripeRegistrationRequest) then
        	network.cancel( stripeRegistrationRequest )
        	stripeRegistrationRequest = nil
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