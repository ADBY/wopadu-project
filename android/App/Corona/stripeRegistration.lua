local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

local imageDirectory = "images/Stripe/"
local imageDirectory2 = "images/Bluetooth_Permission/"
local imageDirectory3 = "images/Login/"
local imageDirectory4 = "images/SignUp/"

local overlayBg,logo,emailBg,emailTf,cvcBg,cvcTf,cardBg,cardTf,expBg,expTf,submitBtn,heading
local stripRegiGroup,yPos,Pin
local orderEmailRequest,paymentRequest,stripePaymentRequest,sRegRequest,updateStripeAccountRequest,stripAccountRequest
sConnect = require("stripe")

local networkReqCount1,networkReqCount2,networkReqCount3
local paymentID

local shakeObject = function (object)    
transition.to(object, { time = 100, x =  5, y = 5 })   
for a = 1, 3, 1 do      
	transition.to(object, { delay = 0 + (120 * a), time = 40, x =  6, y =  6 })        
	transition.to(object, { delay = 40 + (120 * a), time = 40, x =  -6, y =  6 })        
	transition.to(object, { delay = 80 + (120 * a), time = 40, x =  0, y =  0 })    
end 
end

local function onDoNothing()

	return true
end

local function handleOk1( event )

	return true
end

local function handleOk2( event )

	expMnthTf.text = ""
	return true
end

local function handleOk3( event )
	
	expYrTf.text = ""
	return true
end

local function handleOk4( event )

	cvcTf.text = ""
	return true
end

local function onGoToProfile( event )

	composer.gotoScene( "editProfile" )
	return true
end

local function placeOrdersNetworkListener( event )
	if ( event.isError ) then
    	
				
    	timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
				
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				
	else	
		timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		
		
		if( event.response == "0" or event.response == 0 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("6Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		elseif( event.response == "1" or event.response == 1 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		elseif( event.response == "2" or event.response == 2 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		elseif( event.response == "3" or event.response == 3 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif( event.response == "4" or event.response == 4 ) then 
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Item1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif( event.response == "5" or event.response == 5 ) then 
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Item2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif( event.response == "6" or event.response == 6 ) then 
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Item3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif(event.response == "OK") then
			for i = 1, #_CartArray do
			
				table.remove( _CartArray,(i - (i-1)) )
			
			end
			
			_PlaceOrderBody = nil
			_PlaceOrderTotal = nil
			
			local options = {
    			isModal = true,
    			effect = "fade",
    			time = 400
			}
			
			local function gotoShowOverlay()
			
				composer.gotoScene( "OrderPopUp", options )
				
			end
			timer.performWithDelay(200,gotoShowOverlay,1)
			
		else
			
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		end
		
		
	end
	return true
end

local function OrderEmailNetworkListener( event )
	if ( event.isError ) then
    	
				
    	networkReqCount1 = networkReqCount1 + 1
    	native.setActivityIndicator( false )
		
		if( networkReqCount1 > 3 ) then		
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
			local options = {
    			isModal = true,
    			effect = "fade",
    			time = 400
			}
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
    	
				
    	 networkReqCount2 = networkReqCount2 + 1
    	native.setActivityIndicator( false )
		
		if( networkReqCount2 > 3 ) then
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
				local url = _WebLink.."email-receipt.php?ws=1&order_id=".._OrderID
				local url2 = url:gsub( " ", "%%20" )
				orderEmailRequest = network.request( url2, "GET", OrderEmailNetworkListener )
				native.setActivityIndicator( true )
						
		end
	end
	return true
end

local function paymentNetworkListener( event )
        if ( event.isError ) then
            
        else
            
            local data1 = event.response
            resp1 = json.decode(data1)
            
            local error = resp1.error
            if error ~= nil then
                for i = 1, #resp1.error do
                    
                end 
            end
           
          if error == nil then
                
				paymentID = resp1.id
				
				local url = _WebLink.."place-order-payment.php?user_id=".._UserID.."&store_id=".._StoreID.."&order_id=".._OrderID.."&transaction_id="..paymentID
				local url2 = url:gsub( " ", "%%20" )
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
	
	local newCharge = "amount="..amount.."&currency="..currency.."&customer="..customer.."&description="..description.."&application_fee="..appFees.."&destination="..desti 
	
	local key = {["Bearer"] = strip_api_key}
    
    local headers = { 
        ["Authorization"] ="Bearer "..strip_api_key,
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
    
    local params = {}
    params.headers = headers
    params.body =  newCharge 
    
    
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
        
        
        networkReqCount3 = networkReqCount3 + 1
    	native.setActivityIndicator( false )
		if( networkReqCount3 > 3 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		else
			local url = _WebLink.."stripe-register.php?user_id=".._UserID.."&stripe_id=".._StripeCustomerID.."&pin_number="..Pin
			local url2 = url:gsub( " ", "%%20" )
			sRegRequest = network.request( url2, "GET", StipeRegisterNetworkListener )
			native.setActivityIndicator( true )
		end
    else
        
        
        local frgtPinList = json.decode(event.response)
        
        if( event.response == 0 or event.response == "0") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        elseif( event.response == 1 or event.response == "1") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        elseif( event.response == 2 or event.response == "2") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end ) 
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Pin2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif( event.response == 3 or event.response == "3") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        elseif( event.response == 4 or event.response == "4") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end ) 
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("Email4Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        elseif( event.response == 5 or event.response == "5") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        else
        	storeData( "S_ID", _StripeCustomerID )
			
        
        	if( composer.getSceneName( "previous" ) == "editProfile" ) then 
        		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Stripe2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onGoToProfile )
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
            
        else
            
            timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
			
            local data1 = event.response
            resp1 = json.decode(data1)
            
            local error = resp1.error
            if error ~= nil then
                for i = 1, #resp1.error do
                    
                    
                end 
            else
            	
            end
           
          if error == nil then
          		
                _StripeCustomerID = resp1.id
                
                local url = _WebLink.."stripe-register.php?user_id=".._UserID.."&stripe_id=".._StripeCustomerID.."&pin_number="..Pin
				local url2 = url:gsub( " ", "%%20" )
				sRegRequest = network.request( url2, "GET", StipeRegisterNetworkListener )
				native.setActivityIndicator( true )
                
                return resp1
            else
            	local alert = native.showAlert( alertLabel,error.message, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
            end 
            
        end
end

local function stripeUpdationNetworkListener( event )
	if ( event.isError ) then
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
	else
	
		if( event.response == 0 or event.response == "0") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
		elseif( event.response == 1 or event.response == "1") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( event.response == 2 or event.response == "2") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 3 or event.response == "3") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end ) 
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("User1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 4 or event.response == "4") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("Pin3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 5 or event.response == "5") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 6 or event.response == "6") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end ) 
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Stripe1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 7 or event.response == "7") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 8 or event.response == "8") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )							
        
        else
        		_StripeCardNo = _StripeCardNo
				_StripeCVVNo = cvcTf.text
				_StripeExpMont = expMnthTf.text
				_StripeExpYear = expYrTf.text
				
				storeData( "S_CardNo", _StripeCardNo )
				storeData( "S_CVVNo", _StripeCVVNo )
				storeData( "S_ExpiryMonth", _StripeExpMont )
				storeData( "S_ExpiryYear", _StripeExpYear )
        		 
        		if( composer.getSceneName( "previous" ) == "editProfile" ) then 
                	local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("Stripe4Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onGoToProfile )
        			
        		else
        			doPaymentFunc()
        		end
        	
		end
	end
	return true
end

local function updateCustomerNetworkListener( event )
        if ( event.isError ) then
            
            timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        else
       		timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
            
            local data1 = event.response
            local resp1 = json.decode(data1)
            
            local error = resp1.error
            if error ~= nil then
                for i = 1, #resp1.error do
                    
                end 
            end
            
            if error == nil then
                emailReturn = resp1.email
               	local email = emailTf.text
				local description = ""
				local cardNumber = _StripeCardNo
				local expYear = expYrTf.text
				local expMonth = expMnthTf.text
				local cvc = cvcTf.text
				local fullName = ""
				
                local stripeUpdateUrl = _WebLink.."stripe-update.php?user_id=".._UserID.."&store_id=".._StoreID.."&stripe_acc_id=".._StripeCustomerID.."&cvv_number="..cvc.."&card_number="..cardNumber.."&exp_date_month="..expMonth.."&exp_date_year="..expYear.."&secret_key="..strip_api_key.."&publishable_key="..stripe_Public_key.."&pin_number=".._StripePin
				local stripeUpdateUrl2 = stripeUpdateUrl:gsub( " ", "%%20" )
				stripeDetailsRequest = network.request( stripeUpdateUrl2, "GET", stripeUpdationNetworkListener )
                native.setActivityIndicator( true )
                
            else
            
            	local function onHandleError( event )
            		if(error.param == "exp_year") then
            			expYrTf.text = ""
            		elseif(error.param == "exp_month") then
            			expMnthTf.text = ""
            		elseif(error.param == "number") then
            			cardTf.text = ""
            		elseif(error.param == "cvc") then
            			cvcTf.text = ""
            		end
            	end
            	
            	local alert = native.showAlert( alertLabel,error.message, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onHandleError )
            end  
        end
end

local function handleButtonEvent( event )
	if( event.phase == "ended" ) then
		if(_StripeCustomerID) then
			local date = os.date( "*t" )
			if(emailTf.text == "" or emailTf.text:len() == 0 or emailTf.text == " ") then
				
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Email1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk1 )
			elseif(cardTf.text == "" or cardTf.text:len() == 0 or cardTf.text == " ") then
	
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Enter8Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk1 )
			elseif(cvcTf.text == "" or cvcTf.text:len() == 0 or cvcTf.text == " ") then
		
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Enter7Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk1 )
			elseif(expMnthTf.text == "" or expMnthTf.text:len() == 0 or expMnthTf.text == " ") then
	
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Enter6Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk1 )
			elseif(expYrTf.text == "" or expYrTf.text:len() == 0 or expYrTf.text == " ") then
	
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Enter5Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk1 ) 
			
			elseif(tostring(expMnthTf.text):len() > 2) then
	
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Enter6Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk2 )
			elseif(tostring(expYrTf.text):len() > 4) then
	
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Enter5Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk2 )
			
			elseif(tonumber(date.month) > tonumber(expMnthTf.text) and tonumber(date.year) > tonumber(expYrTf.text)) then
	
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Enter6Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk2 )
			elseif(tonumber(date.year) > tonumber(expYrTf.text)) then
	
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Enter5Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk2 )
		
			else
				local email = emailTf.text
				local description = ""
				local cardNumber = _StripeCardNo
				local expYear = expYrTf.text
				local expMonth = expMnthTf.text
				local cvc = cvcTf.text
				local fullName = ""
				
				local updateCustomer = "email="..email.."&description="..description.."&card[number]="..cardNumber.."&card[exp_year]="..expYear.."&card[exp_month]="..expMonth.."&card[cvc]="..cvc
    
    
   				local key = {["Bearer"] = strip_api_key}
    
    			local headers = { 
        			["Authorization"] ="Bearer "..strip_api_key,
        			["Content-Type"] = "application/x-www-form-urlencoded"
    			}
    
    			local params = {}
    			params.headers = headers
    			params.body =  updateCustomer 
    
    			
    			
    			updateStripeAccountRequest = network.request("https://api.stripe.com/v1/customers/".._StripeCustomerID, "POST", updateCustomerNetworkListener, params)
				native.setActivityIndicator( true )    
   
			end
		
		else
		
			if( emailTf.text == "" or cardTf.text == "" or cvcTf.text == "" or Pin == nil or Pin == "" or expMnthTf.text == "" or expYrTf.text == "" ) then
				
			else
		
				local email = emailTf.text
				local description = ""
				local cardNumber = cardTf.text
				local expYear = expYrTf.text
				local expMonth = expMnthTf.text
				local cvc = cvcTf.text
				local fullName = ""
 
    				local newCustomer = "email="..email.."&description="..description.."&card[number]="..cardNumber.."&card[exp_year]="..expYear.."&card[exp_month]="..expMonth.."&card[cvc]="..cvc
    				
    				local key = {["Bearer"] = strip_api_key}
    
    				local headers = { 
        				["Authorization"] ="Bearer "..strip_api_key,
        				["Content-Type"] = "application/x-www-form-urlencoded"
    				}
    
    
    				local params = {}
    				params.headers = headers
    				params.body =  newCustomer 
    
    				
    
   					stripAccountRequest = network.request("https://api.stripe.com/v1/customers", "POST", registerNetworkListener, params)
					
    				native.setActivityIndicator( true )
			
					
			end
		end
	end
	return true
end

local function onEmailEdit( event )
	if ( event.phase == "began" ) then
		native.setKeyboardFocus( nil )
    elseif ( event.phase == "ended" ) then
    	native.setKeyboardFocus( nil )
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then
        native.setKeyboardFocus( nil )
    end
	return true
end

local function onCardEdit( event )
	if ( event.phase == "began" ) then
		
    elseif ( event.phase == "ended" ) then
    	native.setKeyboardFocus( nil )
    	
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( cvcTf )
    	_StripeCardNo = cardTf.text
		stripRegiGroup.y = yPos
    elseif ( event.phase == "editing" ) then
        
    end
	return true

end

local function onCvcEdit( event )
	if ( event.phase == "began" ) then
		
    elseif ( event.phase == "ended" ) then
    	native.setKeyboardFocus( nil )
		
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( expMnthTf )
		
    elseif ( event.phase == "editing" ) then
        
    end
	return true
end

local function onExpMonthEdit( event )
	if ( event.phase == "began" ) then
		
    elseif ( event.phase == "ended" ) then
    	native.setKeyboardFocus( nil )
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( expYrTf )

    elseif ( event.phase == "editing" ) then
        
    end
	return true
end

local function onExpYearEdit( event )
	if ( event.phase == "began" ) then
		
    elseif ( event.phase == "ended" ) then
    	native.setKeyboardFocus( nil )
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then
        
    end
	return true
end

local function handleCreatePinEvent( event )
	if(event.phase == "ended") then

	local date = os.date( "*t" )
	
	if(emailTf.text == "" or emailTf.text:len() == 0 or emailTf.text == " ") then
	
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Email1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk1 ) 
	elseif(cardTf.text == "" or cardTf.text:len() == 0 or cardTf.text == " ") then
	
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Enter8Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk1 )
	elseif(expMnthTf.text == "" or expMnthTf.text:len() == 0 or expMnthTf.text == " ") then
	
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Enter6Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk1 )
	elseif(expYrTf.text == "" or expYrTf.text:len() == 0 or expYrTf.text == " ") then
	
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Enter5Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk1 )
	elseif(cvcTf.text == "" or cvcTf.text:len() == 0 or cvcTf.text == " ") then
		
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Enter7Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk1 )
	elseif(tostring(expMnthTf.text):len() > 2) then
	
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Enter6Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk2 )
	elseif(tostring(expYrTf.text):len() > 4) then
	
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Enter5Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk2 )
	elseif(tonumber(date.month) > tonumber(expMnthTf.text) and tonumber(date.year) > tonumber(expYrTf.text)) then
	
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Enter6Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk2 )
	elseif(tonumber(date.year) > tonumber(expYrTf.text)) then
	
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Enter5Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk3 )
	else
	emailTf.isVisible = false
	cardTf.isVisible = false
	expMnthTf.isVisible = false
	expYrTf.isVisible = false
	cvcTf.isVisible = false
	
	local options = {
		params = {
			email = emailTf.text,
			cardNo = _StripeCardNo,
			e_Month = expMnthTf.text,
			e_Year = expYrTf.text,
			CVCNo = cvcTf.text
		}
	}
	
	composer.showOverlay( "CreatePin",options )
	
	end
	
	end
	return true
end


function scene:resumeApp()    
    emailTf.isVisible = true
	cardTf.isVisible = true
	expMnthTf.isVisible = true
	expYrTf.isVisible = true
	cvcTf.isVisible = true
	
	if(composer.getVariable( "ErrorType" ) == "Cancel" ) then
	
	elseif(composer.getVariable( "ErrorType" ) == "NA" ) then
	
	elseif(composer.getVariable( "ErrorType" ) == "exp_year" ) then
		expYrTf.text = ""
	elseif(composer.getVariable( "ErrorType" ) == "exp_month" ) then
		expMnthTf.text = ""
	elseif(composer.getVariable( "ErrorType" ) == "number" ) then
		cardTf.text = ""
	elseif(composer.getVariable( "ErrorType" ) == "cvc" ) then
		cvcTf.text = ""
	else
		
	end
	
end

local function handleBackButtonEvent( event )
	
		composer.gotoScene( composer.getSceneName("previous") )
		
	return true
end


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    	
    	
        local background = display.newImageRect( imageDirectory4.."Background.png", _W, _H )
        background.x = _W/2
        background.y = _H/2
        sceneGroup:insert( background )
        
        local header = display.newImageRect( imageDirectory4.."f_Header.png", _W, _H/13.61 )
        header.x = _W/2
        header.y = _H/27
        sceneGroup:insert( header )
        
        heading = display.newText( GBCLanguageCabinet.getText("paymentGatewayLabel",_LanguageKey), header.x, header.y, _FontArr[30], _H/36.76 )
        heading:setFillColor( 1 )
        sceneGroup:insert( heading )
        
        
        local backBtn = widget.newButton
		{
    	width = _W/9,
    	height = _H/14.76,
    	defaultFile = imageDirectory4.."Back_Btn2.png",
   		overFile = imageDirectory4.."Back_Btn2.png",
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
        
        
        
	    heading.text = GBCLanguageCabinet.getText("paymentGatewayLabel",_LanguageKey)
        
        stripRegiGroup = display.newGroup()
        sceneGroup:insert(stripRegiGroup)
        
        networkReqCount1 = 0
        networkReqCount2 = 0
        networkReqCount3 = 0
        
        stripeRegisterPreviousPage = composer.getSceneName( "previous" )
        
    	local textFieldWidth = _W - _W/4 
    	local textFieldHeight = _H/19.2
    	
        emailBg = display.newImageRect( imageDirectory.."textBox.png", textFieldWidth, _H/13.33 )
        emailBg.x = _W/2.01
        emailBg.y = _H/6
        stripRegiGroup:insert( emailBg )
        
        emailTf = native.newTextField( emailBg.x, emailBg.y, emailBg.width - _W/27, emailBg.height - _H/96 )
		emailTf.hasBackground = false
		emailTf.inputType = "email"
		emailTf.text = _UserName
		emailTf:addEventListener( "userInput", onEmailEdit )
		emailTf.font = native.newFont( _FontArr[10], _H/28 )
		stripRegiGroup:insert( emailTf )
        
        cardBg = display.newImageRect( imageDirectory.."textBox.png", textFieldWidth, _H/13.33 )
        cardBg.x = _W/2.01
        cardBg.y = emailTf.y + _H/38.4 + emailTf.height
        stripRegiGroup:insert( cardBg )
        
        cardTf = native.newTextField( cardBg.x, cardBg.y, cardBg.width - _W/27, cardBg.height - _H/96 )
		cardTf.hasBackground = false
		cardTf.inputType = "number"
		cardTf.placeholder = "Card Number"
		cardTf:addEventListener( "userInput", onCardEdit )
		cardTf.font = native.newFont( _FontArr[10], _H/28 )
		stripRegiGroup:insert( cardTf )
		
		cvcBg = display.newImageRect( imageDirectory.."textBox.png", textFieldWidth , _H/13.33 )
        cvcBg.x = cardBg.x
        cvcBg.y = cardTf.y + cardTf.height + _H/38.4
        stripRegiGroup:insert( cvcBg )
        
        cvcTf = native.newTextField( cvcBg.x , cvcBg.y, cvcBg.width - _W/27, cvcBg.height - _H/96 )
		cvcTf.hasBackground = false
		cvcTf.inputType = "number"
		cvcTf.placeholder = "CVC"
		cvcTf:addEventListener( "userInput", onCvcEdit )
		cvcTf.font = native.newFont( _FontArr[10], _H/28 )
		stripRegiGroup:insert( cvcTf )
		
		
		expMnthBg = display.newImageRect( imageDirectory.."MonthDateTextBox.png", textFieldWidth/2 , _H/13.33 )
        expMnthBg.x = cvcBg.x - cvcBg.width/2
        expMnthBg.y = cvcTf.y + cvcTf.height + _H/38.4
        expMnthBg.anchorX = 0
        stripRegiGroup:insert( expMnthBg )
        
        expMnthTf = native.newTextField( expMnthBg.x + _W/54, expMnthBg.y, expMnthBg.width - _W/27, expMnthBg.height - _H/96 )
		expMnthTf.hasBackground = false
		expMnthTf.inputType = "number"
		expMnthTf.placeholder = "MM"
		expMnthTf:addEventListener( "userInput", onExpMonthEdit )
		expMnthTf.font = native.newFont( _FontArr[10], _H/28 )
		expMnthTf.anchorX = 0
		stripRegiGroup:insert( expMnthTf )
		
		expYrBg = display.newImageRect( imageDirectory.."CVCTextBox.png", textFieldWidth/2 , _H/13.33 )
        expYrBg.x = cvcBg.x + cvcBg.width/2
        expYrBg.y = cvcTf.y + cvcTf.height + _H/38.4
        expYrBg.anchorX = 1
        stripRegiGroup:insert( expYrBg )
        
        expYrTf = native.newTextField( expYrBg.x - _W/54, expYrBg.y, expYrBg.width - _W/27, expYrBg.height - _H/96 )
		expYrTf.hasBackground = false
		expYrTf.inputType = "number"
		expYrTf.placeholder = "YYYY"
		expYrTf:addEventListener( "userInput", onExpYearEdit )
		expYrTf.font = native.newFont( _FontArr[10], _H/28 )
		expYrTf.anchorX = 1
		stripRegiGroup:insert( expYrTf )
		
        if(_StripeCustomerID) then
        	
			if( _StripeCardNo == nil ) then
				
				submitBtn = widget.newButton
				{
					width = textFieldWidth,
					height = _H/16.27,
					defaultFile = imageDirectory3.."SinIn_Btn3.png",
					overFile = imageDirectory3.."SinIn_Btn3.png",
					label = GBCLanguageCabinet.getText("createPinLabel",_LanguageKey),
					labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
					labelYOffset = _H/275,
					fontSize = _H/30,
					font = _FontArr[6],
					onEvent = handleCreatePinEvent
				}
				submitBtn.x = _W/2
				submitBtn.y = expYrBg.y + expYrBg.height/2 + _H/24 + submitBtn.height
				stripRegiGroup:insert( submitBtn )
				
				cardTf.text = ""
				
			else
				
				local s = string.sub(_StripeCardNo,0,string.len(_StripeCardNo)-4)
				local s2 = string.sub(_StripeCardNo,string.len(_StripeCardNo)-3,string.len(_StripeCardNo))
				
				local function displayData( )
					local temp = ""
					for i = 1, string.len(s) do
						temp = temp.."*"
					end
					
					cardTf.text = temp..s2
					
				end
				
				displayData()
				
				submitBtn = widget.newButton
				{
					width = textFieldWidth,
					height = _H/16.27,
					defaultFile = imageDirectory3.."SinIn_Btn3.png",
					overFile = imageDirectory3.."SinIn_Btn3.png",
					label = GBCLanguageCabinet.getText("updateLabel",_LanguageKey),
					labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
					labelYOffset = _H/275,
					fontSize = _H/30,
					font = _FontArr[6],
					onEvent = handleButtonEvent
				}
				submitBtn.x = _W/2
				submitBtn.y = expYrBg.y + expYrBg.height/2 + _H/24 + submitBtn.height
				stripRegiGroup:insert( submitBtn )
				
			end
			
        else
        	
        	submitBtn = widget.newButton
			{
				width = textFieldWidth,
				height = _H/16.27,
				defaultFile = imageDirectory3.."SinIn_Btn3.png",
				overFile = imageDirectory3.."SinIn_Btn3.png",
				label = GBCLanguageCabinet.getText("createPinLabel",_LanguageKey),
				labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
				labelYOffset = _H/275,
				fontSize = _H/30,
				font = _FontArr[6],
				onEvent = handleCreatePinEvent
			}
			submitBtn.x = _W/2
			submitBtn.y = expYrBg.y + expYrBg.height/2 + _H/24 + submitBtn.height
			stripRegiGroup:insert( submitBtn )
        	
        	cardTf.text = ""
        
        end
        
		yPos = stripRegiGroup.y
		
        
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
        
        display.remove(overlayBg)
        overlayBg = nil
        
        
         display.remove(logo)
         logo = nil
         
         display.remove(emailBg)
         emailBg = nil
         
         display.remove(emailTf)
         emailTf = nil
         
         display.remove(cardBg)
         cardBg = nil
         
         display.remove(cardTf)
         cardTf = nil
         
         display.remove(expMnthBg)
         expMnthBg = nil
         
         display.remove(expMnthTf)
         expMnthTf = nil
         
         display.remove(expYrBg)
         expYrBg = nil
         
         display.remove(expYrBg)
         expYrBg = nil
         
         display.remove(cvcBg)
         cvcBg = nil
         
         display.remove(cvcTf)
         cvcTf = nil
         
         display.remove(submitBtn)
         submitBtn = nil
          
         yPos = nil 
         
         display.remove(stripRegiGroup)
         stripRegiGroup = nil
        
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
        
        if(orderEmailRequest) then
        	network.cancel( orderEmailRequest )
        	orderEmailRequest = nil
        end
        
        if(paymentRequest) then
        	network.cancel( paymentRequest )
        	paymentRequest = nil
        end
        
        if(stripePaymentRequest) then
        	network.cancel( stripePaymentRequest )
        	stripePaymentRequest = nil
        end
        
        if(updateStripeAccountRequest) then
        	network.cancel( updateStripeAccountRequest )
        	updateStripeAccountRequest = nil
        end
        
        if(sRegRequest) then
        	network.cancel( sRegRequest )
        	sRegRequest = nil
        end
        
        if(stripAccountRequest) then
        	network.cancel( stripAccountRequest )
        	stripAccountRequest = nil
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