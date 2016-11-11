local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------
sConnect = require("stripe")

local ImageDirectory = "images/PopUp/"
local createPinGroup,yPos,textFieldWidth,textFieldHeight
local parent,paymentRequest,stripePaymentRequest
local VariableTable = { "popUpBg", "logo", "CancelButton" ,"CreateButton" , "Label2", "Label3",}

local function onDoNothing()

	return true
	
end


local function placeOrdersNetworkListener( event )
	if ( event.isError ) then
				
    	timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
				
		local alert = native.showAlert( alertLabel, NetworkErrorMsg, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				
	else	
		timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		
		if( event.response == "0" or event.response == 0 ) then
			local alert = native.showAlert( alertLabel, "Variables missing", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		elseif( event.response == "1" or event.response == 1 ) then
			local alert = native.showAlert( alertLabel, "User id, Store id, table location, grand total can't be empty", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
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
		
			
			local alert = native.showAlert( alertLabel, "Somthing went wrong, please try again later", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
					
		end
		
		
	end
	return true
end

local function OrderPaymentNetworkListener( event )
	if ( event.isError ) then
		
    	timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
				
		local alert = native.showAlert( alertLabel, NetworkErrorMsg, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				
	else	
		timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		
		if( event.response == "0" or event.response == 0 ) then
			local alert = native.showAlert( alertLabel, "Variables missing", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		elseif( event.response == "1" or event.response == 1 ) then
			local alert = native.showAlert( alertLabel, "User id, Store id, order id, transaction id can't be empty", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif( event.response == "2" or event.response == 2 ) then
			local alert = native.showAlert( alertLabel, "Something went wrong, Query error", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif( event.response == "3" or event.response == 3 ) then
			local alert = native.showAlert( alertLabel, "Order does not found", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
		elseif( event.response == "4" or event.response == 4 ) then
			local alert = native.showAlert( alertLabel, "Something went wrong, Query Error", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			
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


local function paymentNetworkListener( event )
        if ( event.isError ) then
            timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        else
            
            timer.performWithDelay( 1000, function() 
    		native.setActivityIndicator( false )
			end )
			
            local data1 = event.response
            resp1 = json.decode(data1)
            local error = resp1.error
            if error ~= nil then
                for i = 1, #resp1.error do
                    
                end 
            end
           
          if error == nil then
                
                local paymentID = resp1.id
              	
				local headers = {}
		
				headers["Content-Type"] = "application/x-www-form-urlencoded"
				headers["Accept-Language"] = "en-US"
		
				local body = "user_id=".._UserID.."&store_id=".._StoreID.."&order_id=".._OrderID.."&transaction_id="..paymentID
				local params = {}
				params.headers = headers
				params.body = body
				params.timeout = 180
		
				local url = _WebLink.."place-order-payment.php?"
		
				paymentRequest = network.request( url, "POST", OrderPaymentNetworkListener, params )
				native.setActivityIndicator( true )		
				
			else
			
            	local alert = native.showAlert( alertLabel,error.message, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
               
            end 
            
        end
    end


local function handleButtonEvent( event )
	if( event.phase == "ended" ) then
		if( event.target.id == "OLD" ) then
		
			local chargeDescription = "TestCharge"
			local customer = _StripeCustomerID
			local currency = "usd" 
			local amount = tostring(tonumber(_PlaceOrderTotal) * 100 ) 
			local description = ""
			
			local newCharge = "amount="..amount.."&currency="..currency.."&customer="..customer.."&description="..description
			
			local key = {["Bearer"] = strip_api_key}
    
    		local headers = { 
        		["Authorization"] ="Bearer "..strip_api_key,
        		["Content-Type"] = "application/x-www-form-urlencoded"
    		}
    
    		local params = {}
    		params.headers = headers
    		params.body =  newCharge 
    
   		 	stripePaymentRequest = network.request("https://api.stripe.com/v1/charges", "POST", paymentNetworkListener, params)
    		
    		native.setActivityIndicator( true )
			
    
		elseif( event.target.id == "NEW" ) then
			composer.gotoScene( "stripeRegistration" )
			
		end
	end
	return true
end

local function onBgTap( event )
	composer.gotoScene( "PlaceOrder" )
	
	return true
end

local function onBgTouch( event )
	if( event.phase == "ended" ) then
		
		composer.gotoScene( "PlaceOrder" )
	
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
    Background:addEventListener("tap",onBgTap)
    Background:addEventListener("touch",onBgTouch)
    sceneGroup:insert(Background)
    
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
        
        createPinGroup = display.newGroup()
        sceneGroup:insert(createPinGroup)
        
        
	VariableTable.popUpBg = display.newImageRect(ImageDirectory.."PopUpBg.png",_W/1.15,_H/2.70)
    VariableTable.popUpBg.x = _W/2
    VariableTable.popUpBg.y = _H/3.07 + VariableTable.popUpBg.height/2
    createPinGroup:insert(VariableTable.popUpBg)
    
    VariableTable.logo = display.newImageRect(ImageDirectory.."Logo.png",_W/5.83,_H/10.37)
    VariableTable.logo.x = VariableTable.popUpBg.x
    VariableTable.logo.y = VariableTable.popUpBg.y - VariableTable.popUpBg.height/2.15	
    createPinGroup:insert(VariableTable.logo)
    
    textFieldWidth = _W/7.44 - _W/32
    textFieldHeight = _H/13.24 - _H/64
    
	VariableTable.CancelButton = widget.newButton
	{
    	width = _W/2.79,
    	height = _H/14.65,
    	defaultFile = ImageDirectory.."Cancel_Btn2.png",
    	overFile = ImageDirectory.."Cancel_Btn2.png",
    	label = "OLD",
    	id = "OLD",
    	font = _FontArr[6],
    	fontSize = _H/27.55,
    	labelYOffset = _H/192,
    	labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
    	onEvent = handleButtonEvent
	}

	VariableTable.CancelButton.x = _W/8.30 + VariableTable.CancelButton.width/2
	VariableTable.CancelButton.y = _H/2
	createPinGroup:insert(VariableTable.CancelButton)
	
	VariableTable.CreateButton = widget.newButton
	{
    	width = _W/2.79,
    	height = _H/14.65,
    	defaultFile = ImageDirectory.."Create_Btn2.png",
    	overFile = ImageDirectory.."Create_Btn2.png",
    	label = "NEW",
    	id = "NEW",
    	font = _FontArr[6],
    	fontSize = _H/27.55,
    	labelYOffset = _H/192,
    	labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
    	onEvent = handleButtonEvent
	}

	VariableTable.CreateButton.x = _W/1.92 + VariableTable.CreateButton.width/2
	VariableTable.CreateButton.y = VariableTable.CancelButton.y
	createPinGroup:insert(VariableTable.CreateButton)
	
	
	local option2 = {
		text = "",
		font = _FontArr[6],
		fontSize = _H/31.48,
		
	}
	
	VariableTable.Label2 = display.newText(option2)
	VariableTable.Label2.text = "Do payment using"
	VariableTable.Label2.x = _W/2
	VariableTable.Label2.y = _H/2.45
	VariableTable.Label2.anchorY = 0
	VariableTable.Label2:setFillColor( 83/255, 20/255, 111/255 )
	createPinGroup:insert(VariableTable.Label2)
	
	VariableTable.Label3 = display.newText(option2)
	VariableTable.Label3.text = "Card"
	VariableTable.Label3.x = _W/2
	VariableTable.Label3.y = VariableTable.CreateButton.y + VariableTable.CreateButton.height 
	VariableTable.Label3.anchorY = 0
	VariableTable.Label3:setFillColor( 83/255, 20/255, 111/255 )
	createPinGroup:insert(VariableTable.Label3)
    
    VariableTable.CancelButton:toFront()
    VariableTable.CreateButton:toFront()
        
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
        
        
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
        if(paymentRequest) then
        	network.cancel( paymentRequest )
        	paymentRequest = nil
        end
        
        if(stripePaymentRequest) then
        	network.cancel( stripePaymentRequest )
        	stripePaymentRequest = nil
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