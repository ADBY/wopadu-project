------------------------------------------------------------------------------------------------------------------

-- This is a basic Lua module for interacting with Stripe's API. The module has Corona SDK dependencies. 

-- Copyright (c) Will Summerlin 2014

--See Licence in README
------------------------------------------------------------------------------------------------------------------

module(..., package.seeall)
-- Function to register a new customer 


-- All of the following values are set for testing ONLY. ---

------------------------------------------------------------

StripeNewRegister = function () 
    local json = require "json"
    local resp1
    newCustomer = "email="..email.."&description="..description.."&card[number]="..cardNumber.."&card[exp_year]="..expYear.."&card[exp_month]="..expMonth.."&card[cvc]="..cvc--{["email"] = email, ["description"] = description}--, ["card"] = firstCard}
    
    local function networkListener( event )
        if ( event.isError ) then
            
        else
            local data1 = event.response
            resp1 = json.decode(data1)
            local error = resp1.error
            if error ~= nil then
                for i = 1, #resp1.error do
                    
                end 
            end
            
        end
    end
    
    local key = {["Bearer"] = strip_api_key}
    
    local headers = { 
        ["Authorization"] ="Bearer "..strip_api_key,
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
    
    
    local params = {}
    params.headers = headers
    params.body =  newCustomer 
    
    local naw = network.request("https://api.stripe.com/v1/customers", "POST", networkListener, params)
    
    return resp1
end

--StripeNewRegister()


------------------------------------------------------------------------------------------------------------------

--Function to create a charge object

-- All of the following values are set for testing ONLY. ---

------------------------------------------------------------



StripeNewCharge = function () 
    local json = require "json"
    newCharge = "amount="..amount.."&currency="..currency.."&customer="..customer.."&description="..description
    
    local resp1 
    local function networkListener( event )
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
               	
                return resp1
            end 
            
        end
    end
    
    local key = {["Bearer"] = strip_api_key}
    
    local headers = { 
        ["Authorization"] ="Bearer "..strip_api_key,
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
    
    
    local params = {}
    params.headers = headers
    params.body =  newCharge 
    
    local naw = network.request("https://api.stripe.com/v1/charges", "POST", networkListener, params)
    
    local function onCheckResponse()
    	if(resp1 == nil or resp1 == "" ) then
    	
    	else
    		timer.cancel(tmr)
    		return resp1
    	end
    end
    return resp1
end

------------------------------------------------------------------------------------------------------------------
limit = "18" --A number between 1 and 100 (Optional - Default is 10)

chargedIdTable={}
chargedAmountTable = {}
chargedCardIdTable = {}
chargedCardLastFourTable = {}
chargedTimeTable = {} --Unix time stamps (date and time)


-- Return a list of all charges for a specific customer

StripeGetCharges = function () 
    local json = require "json"
    getCharges = "customer="..customer.."&limit="..limit
    
    local function networkListener( event )
        if ( event.isError ) then
           	
        else
            local data1 = event.response
            local resp1 = json.decode(data1)
            local error = resp1.error
            if error ~= nil then
                for i = 1, #resp1.error do
                    
                end 
            end
            if error == nil then
                for j = 1, #resp1.data do
                    
                    table.insert(chargedIdTable, resp1.data[j].id)
                    table.insert(chargedAmountTable, resp1.data[j].amount)
                    table.insert(chargedCardIdTable, resp1.data[j].card.id)
                    table.insert(chargedCardLastFourTable, resp1.data[j].card.last4)
                    table.insert(chargedTimeTable, resp1.data[j].created)
                end
                
                
            end  
        end
    end
    
    local key = {["Bearer"] = strip_api_key}
    
    local headers = { 
        ["Authorization"] ="Bearer "..strip_api_key,
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
    
    
    local params = {}
    params.headers = headers
    params.body =  getCharges 
    
    local naw = network.request("https://api.stripe.com/v1/charges", "GET", networkListener, params)
    
end

------------------------------------------------------------------------------------------------------------------ 

--Update specific params on a customer (i.e. "email", "Description")

--NOTE - You must set the global "customer" variable to the id of the customer being modified 
--newEmail = "imnew@email.com"

StripeUpdateCustomer = function () 
    local json = require "json"
    updateCustomer = "email="..email.."&description="..description.."&card[number]="..cardNumber.."&card[exp_year]="..expYear.."&card[exp_month]="..expMonth.."&card[cvc]="..cvc
    
    local function networkListener( event )
        if ( event.isError ) then
            
        else
            local data1 = event.response
            local resp1 = json.decode(data1)
            local error = resp1.error
            if error ~= nil then
                for i = 1, #resp1.error do
                    
                end 
            end
            if error == nil then
                emailReturn = resp1.email
                
            end  
        end
    end
    
    local key = {["Bearer"] = strip_api_key}
    
    local headers = { 
        ["Authorization"] ="Bearer "..strip_api_key,
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
    
    
    local params = {}
    params.headers = headers
    params.body =  updateCustomer 
    
    customer = "cus_7SnxwGMDkQeFJh"
    local naw = network.request("https://api.stripe.com/v1/customers/"..customer, "POST", networkListener, params)
    
end

------------------------------------------------------------------------------------------------------------------ 

-- Return a customers information 

--NOTE - You must set the global "customer" variable to the id of the customer being requested 

StripeGetCustomer = function () 
    local json = require "json"    
    
    local function networkListener( event )
        if ( event.isError ) then
            
        else
            local data1 = event.response
            local resp1 = json.decode(data1)
            local error = resp1.error
            if error ~= nil then
                for i = 1, #resp1.error do
                    
                end 
            end
            if error == nil then
                emailReturn = resp1.email
                descriptionReturn = resp1.description
                defaultCard = resp1.default_card
                
            end  
        end
    end
    
    local key = {["Bearer"] = strip_api_key}
    
    local headers = { 
        ["Authorization"] ="Bearer "..strip_api_key,
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
    
    
    local params = {}
    params.headers = headers 
    
    
    local naw = network.request("https://api.stripe.com/v1/customers/"..customer, "GET", networkListener, params)
    
end

------------------------------------------------------------------------------------------------------------------

StripeNewToken = function () 
    local json = require "json"
    newCardToken = "card[number]="..cardNumber.."&card[exp_year]="..expYear.."&card[exp_month]="..expMonth.."&card[cvc]="..cvc
    
    local function networkListener( event )
        if ( event.isError ) then
            
        else
            local data1 = event.response
            local resp1 = json.decode(data1)
            local error = resp1.error
            if error ~= nil then
                for i = 1, #resp1.error do
                    
                end 
            end
            if error == nil then
                tokenId = resp1.id
                tokenCardId = resp1.card.id
                tokenCardLastFour = resp1.card.last4
                tokenCardFingerprint = resp1.card.fingerprint
                tokenCardFunding = resp1.card.funding
                tokenCardBrand = resp1.card.brand
                
            end  
        end
    end
    
    local key = {["Bearer"] = strip_api_key}
    
    local headers = { 
        ["Authorization"] ="Bearer "..strip_api_key,
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
    
    
    local params = {}
    params.headers = headers
    params.body =  newCardToken
    
    local naw = network.request("https://api.stripe.com/v1/tokens", "POST", networkListener, params)
    
end

------------------------------------------------------------------------------------------------------------------

--Charge a user with a token

--Below is an arbitrary and defunct token id (It will not work). The function above - "StripeNewToken()" - will generate a real single use token. 

tokenId = "tok_14HRJN4ZwoZsuAk4NbLdeGk5"


StripeTokenCharge = function () 
    local json = require "json"
    newCharge = "amount="..amount.."&currency="..currency.."&card="..tokenId.."&description="..description
    
    local function networkListener( event )
        if ( event.isError ) then
            
        else
            local data1 = event.response
            local resp1 = json.decode(data1)
            local error = resp1.error
            if error ~= nil then
                for i = 1, #resp1.error do
                    
                end 
            end
            if error == nil then
                chargeId = resp1.id
                chargedCard = resp1.card.id
                chargedCardLastFour = resp1.card.last4
                chargePaid = resp1.paid
                chargeFail = resp1.failure_message
                
            end  
        end
    end
    
    local key = {["Bearer"] = strip_api_key}
    
    local headers = { 
        ["Authorization"] ="Bearer "..strip_api_key,
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
    
    
    local params = {}
    params.headers = headers
    params.body =  newCharge 
    
    local naw = network.request("https://api.stripe.com/v1/charges", "POST", networkListener, params)
    
end

------------------------------------------------------------------------------------------------------------------


--Provide a refund

----Below is an arbitrary and defunct charge id (It will not work). You need to set "chargeId" to the id of the charge to be refunded 

chargeId = "ch_14HRca4ZwoZsuAk49Y0CMA65"

StripeRefundCharge = function () 
    local json = require "json"    
    
    local function networkListener( event )
        if ( event.isError ) then
            
        else
            local data1 = event.response
            local resp1 = json.decode(data1)
            local error = resp1.error
            if error ~= nil then
                for i = 1, #resp1.error do
                    
                end 
            end
            if error == nil then
                refundId = resp1.id
                refundAmount = resp1.amount
                refundTime = resp1.created
                
            end  
        end
    end
    
    local key = {["Bearer"] = strip_api_key}
    
    local headers = { 
        ["Authorization"] ="Bearer "..strip_api_key,
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
    
    
    local params = {}
    params.headers = headers
    
    
    local naw = network.request("https://api.stripe.com/v1/charges/"..chargeId.."/refunds", "POST", networkListener, params)
    
end