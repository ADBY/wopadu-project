--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

display.setStatusBar( display.HiddenStatusBar )

-- require libraries

composer = require "composer"
widget =  require "widget"
json = require "json"
facebook = require( "plugin.facebook.v4" )
GGTwitter = require( "GGTwitter" )
lfs = require( "lfs" )
notifications = require( "plugin.notifications" )
notifications.registerForPushNotifications()   -- request for the use of push notifications, prompting iOS to ask for permission

GBCLanguageCabinet = require ("GBCLanguageCabinet")

strip_api_key = "sk_test_uC1ksEtDoRv6izuAcdCQesap" --API Key for stripe Here

notificationFlag = false
notificationFlag2 = false

iBeaconRunning = false
iBeacon = require "plugin.ibeacon"

----------------- FACEBOOK -----------------
appId  = "290289701345335"
apiKey = nil	-- Not needed at this time
----------------- FACEBOOK -----------------

----------------- TWITTER -----------------
consumerKey  = "FNIXZ5fE8Y0Zv50nYLP6prznm"
consumerSecret = "CSufsBpGxPS25q46RWgOWt9BSoe775JvXFy4rmyJP57K9hMaDk"
----------------- TWITTER -----------------

-- global variables

_W = display.contentWidth
_H = display.contentHeight

local splashBackGround = display.newImageRect("Default-Portrait@2x.png",_W,_H)
splashBackGround.x = _W/2
splashBackGround.y = _H/2

local function loadData(name)
	 path = system.pathForFile(name, system.DocumentsDirectory )
	 local fhd = io.open( path )
	if(fhd) then
		local file = io.open( path, "r" )
		 var= file:read( "*a" )
		 io.close( file )
		file = nil
		return var	
	else
		return nil	
	end
end

GBCLanguageCabinet.addLanguage("English", "en")    -- english
GBCLanguageCabinet.addLanguage("富盈", "zh")		   -- Chinese
GBCLanguageCabinet.addLanguage("français", "fr")   -- French
GBCLanguageCabinet.addLanguage("Deutsche", "de")   -- german
GBCLanguageCabinet.addLanguage("हिंदी", "hi")        -- Hindi
GBCLanguageCabinet.addLanguage("italiano","it")    -- italian
GBCLanguageCabinet.addLanguage("日本語", "ja")      -- Japanese
GBCLanguageCabinet.addLanguage("한국어", "ko")       -- korean
GBCLanguageCabinet.addLanguage("русский", "ru")     -- Russian
GBCLanguageCabinet.addLanguage("Español", "es")     -- Spanish
GBCLanguageCabinet.addLanguage("ไทย", "th")        -- Thai
GBCLanguageCabinet.addLanguage("Türk", "tr")       -- Turkish
GBCLanguageCabinet.addLanguage("український", "uk")       -- ukranian
GBCLanguageCabinet.addLanguage("العربية", "ar")        -- Arabic
GBCLanguageCabinet.addLanguage("português", "pt")    -- Portuguese
GBCLanguageCabinet.addLanguage("Tiếng Việt", "vi")   -- Vietnamese

GBCLanguageCabinet.addTextFromFile("testfile.json", "json")

_LanguageKey = loadData( "Langauge" )

if( _LanguageKey == nil) then
	_LanguageKey = "en"
else

end

_Tutorial = loadData( "Tutorial" )

if _Tutorial == nil then
	_Tutorial = "0"
else
	
end

alertLabel = "Wopadu"
NetworkErrorMsg = "Please check your internet connection!!"
_WebLink = "http://wopadu.com/admin/ws/"
_majorBea = ""

_selectedMainCategoryID = nil   -- first selected Category Id from menu page
_selectedLastSubCategoryID = nil  -- last selected Category Id from menu page
_selectedProductID = nil  -- selected Product Id from menu page
_selectedProductListCategoryID = nil
_selectedProductListCategoryName = nil
_selectedOrderID = nil
_searchedString = nil -- string searched for product list
_previousScene = nil -- to use bck btn in proper way
_PreviousSceneforSetting = nil
_PreviousSceneforOrder = nil
_passwordPreviousScene = nil
--isStripeRegistered = nil --  to check , we have to update old account or have to create a new one
_PlaceOrderBody = nil -- not needed nw
_PlaceOrderTotal = nil --  used to send total amount to stripe for payment process
_OrderID = nil -- order id saved after placing order first on server (used to send it to server for payment web service)
stripeRegisterPreviousPage = nil

_productImageFlag = nil

_HotelName = ""
_HotelAddress = ""
_StoreID = nil
_TableNumber = ""
_isNotesVisible = false  -- whether to add notes or not??

beaconData = { }

_FontArr = { }
_CartArray = { }
productRequest = { }
menuImageRequest = { }
menuImageRequest2 = { }
menuImageRequest3 = { }
subMenuImageRequest = { }
subMenuImageRequest2 = { }
subMenuImageRequest3 = { }
productImageRequest = { }
count = 0
_EditFlag = false
_EditProductDetails = { }
_Flag = false
_StopTimerFlag = false
local deleteAccFlag = false

nearestBeacon = { }
beaconSearchCount = 0
nearAvailableArr = { }
immediateAvailableArr = { }

local function onLeaveApplication()
	os.exit()
	
	return true
end

function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

if system.getInfo("platformName") == "Android" then
	table.insert(_FontArr,"BEBAS.TTF")
	table.insert(_FontArr,"FUTURASTD-BOLD_1.OTF")
	table.insert(_FontArr,"FUTURASTD-BOLDOBLIQUE_1.OTF")
	table.insert(_FontArr,"FUTURASTD-BOOK_1.OTF")
	table.insert(_FontArr,"FUTURASTD-BOOKOBLIQUE_1.OTF") 
	table.insert(_FontArr,"FUTURASTD-CONDENSED_1.OTF") 
	table.insert(_FontArr,"FUTURASTD-CONDENSEDBOLD_1.OTF") 
	table.insert(_FontArr,"FUTURASTD-CONDENSEDBOLDOBL_1.OTF") 
	table.insert(_FontArr,"FUTURASTD-CONDENSEDEXTRABD_1.OTF") -- 9
	table.insert(_FontArr,"FUTURASTD-CONDENSEDLIGHT_1.OTF") -- 10
	
	table.insert(_FontArr,"FUTURASTD-CONDENSEDLIGHTOBL_1.OTF") -- 11
	table.insert(_FontArr,"FUTURASTD-CONDENSEDOBLIQUE_1.OTF") -- 12
	table.insert(_FontArr,"FUTURASTD-CONDEXTRABOLDOBL_1.OTF") -- 13
	table.insert(_FontArr,"FUTURASTD-EXTRABOLD_1.OTF") -- 14
	table.insert(_FontArr,"FUTURASTD-EXTRABOLDOBLIQUE_1.OTF") -- 15
	table.insert(_FontArr,"FUTURASTD-HEAVY_1.OTF") -- 16
	table.insert(_FontArr,"FUTURASTD-HEAVYOBLIQUE_1.OTF") -- 17
	table.insert(_FontArr,"FUTURASTD-LIGHT_1.OTF") -- 18
	table.insert(_FontArr,"FUTURASTD-LIGHTOBLIQUE_1.OTF") -- 19
	table.insert(_FontArr,"FUTURASTD-MEDIUM_1.OTF") -- 20
	
	table.insert(_FontArr,"FUTURASTD-MEDIUMOBLIQUE_1.OTF") -- 21
	table.insert(_FontArr,"GOTHAM-BLACK.OTF") -- 22
	table.insert(_FontArr,"GOTHAM-BLACKITALIC.OTF") -- 23
	table.insert(_FontArr,"GOTHAM-BOLD.OTF") -- 24
	table.insert(_FontArr,"GOTHAM-BOLDITALIC.OTF") -- 25
	table.insert(_FontArr,"GOTHAM-BOOK.OTF") -- 26
	table.insert(_FontArr,"GOTHAM-BOOKITALIC.OTF") -- 27
	table.insert(_FontArr,"GOTHAM-LIGHT.OTF") -- 28
	table.insert(_FontArr,"GOTHAM-LIGHTITALIC.OTF") -- 29
	table.insert(_FontArr,"GOTHAM-MEDIUM.OTF") -- 30
	
	table.insert(_FontArr,"GOTHAM-MEDIUMITALIC.OTF") -- 31
	table.insert(_FontArr,"GOTHAM-THINITALIC.OTF") -- 32
	table.insert(_FontArr,"GOTHAM-ULTRA.OTF") -- 33
	table.insert(_FontArr,"GOTHAM-ULTRAITALIC.OTF") -- 34
	table.insert(_FontArr,"GOTHAM-XLIGHT.OTF") -- 35
	table.insert(_FontArr,"GOTHAM-XLIGHTITALIC.OTF") -- 36
	table.insert(_FontArr,"GOTHAMNARROW-BLACK.TTF") -- 37
	table.insert(_FontArr,"GOTHAMNARROW-BLACKITALIC.TTF") -- 38
	table.insert(_FontArr,"GOTHAMNARROW-BOLD.TTF") -- 39
	table.insert(_FontArr,"GOTHAMNARROW-BOLDITALIC.TTF") -- 40
	
	table.insert(_FontArr,"GOTHAMNARROW-BOOK.TTF") -- 41
	table.insert(_FontArr,"GOTHAMNARROW-BOOKITALIC.TTF") -- 42
	table.insert(_FontArr,"GOTHAMNARROW-LIGHT.TTF") -- 43
	table.insert(_FontArr,"GOTHAMNARROW-LIGHTITALIC.TTF") -- 44
	table.insert(_FontArr,"GOTHAMNARROW-MEDIUM.TTF") -- 45
	table.insert(_FontArr,"GOTHAMNARROW-MEDIUMITALIC.TTF") -- 46
	table.insert(_FontArr,"GOTHAMNARROW-THIN.TTF") -- 47
	table.insert(_FontArr,"GOTHAMNARROW-THINITALIC.TTF") -- 48
	table.insert(_FontArr,"GOTHAMNARROW-ULTRA.TTF") -- 49
	table.insert(_FontArr,"GOTHAMNARROW-ULTRAITALIC.TTF") -- 50
	
	table.insert(_FontArr,"GOTHAMNARROW-XLIGHT.TTF") -- 51
	table.insert(_FontArr,"GOTHAMNARROW-XLIGHTITALIC.TTF") -- 52
	
else
	table.insert(_FontArr,"Bebas")
	table.insert(_FontArr,"FuturaStd-Bold") 
	table.insert(_FontArr,"FuturaStd-BoldOblique")
	table.insert(_FontArr,"FuturaStd-Book")
	table.insert(_FontArr,"FuturaStd-BookOblique") 
	table.insert(_FontArr,"FuturaStd-Condensed") 
	table.insert(_FontArr,"FuturaStd-CondensedBold") 
	table.insert(_FontArr,"FuturaStd-CondensedBoldObl") 
	table.insert(_FontArr,"FuturaStd-CondensedExtraBd") -- 9
	table.insert(_FontArr,"FuturaStd-CondensedLight") -- 10
	
	table.insert(_FontArr,"FuturaStd-CondensedLightObl") -- 11
	table.insert(_FontArr,"FuturaStd-CondensedOblique") -- 12
	table.insert(_FontArr,"FuturaStd-CondensedBoldObl") -- 13
	table.insert(_FontArr,"FuturaStd-ExtraBold") -- 14
	table.insert(_FontArr,"FuturaStd-ExtraBoldOblique") -- 15
	table.insert(_FontArr,"FuturaStd-Heavy") -- 16
	table.insert(_FontArr,"FuturaStd-HeavyOblique") -- 17
	table.insert(_FontArr,"FuturaStd-Light") -- 18
	table.insert(_FontArr,"FuturaStd-LightOblique") -- 19
	table.insert(_FontArr,"FuturaStd-Medium") -- 20
	
	table.insert(_FontArr,"FuturaStd-MediumOblique") -- 21
	table.insert(_FontArr,"Gotham-Black") -- 22
	table.insert(_FontArr,"Gotham-BlackItalic") -- 23
	table.insert(_FontArr,"Gotham-Bold") -- 24
	table.insert(_FontArr,"Gotham-BoldItalic") -- 25
	table.insert(_FontArr,"Gotham-Book") -- 26
	table.insert(_FontArr,"Gotham-BookItalic") -- 27
	table.insert(_FontArr,"Gotham-Light") -- 28
	table.insert(_FontArr,"Gotham-LightItalic") -- 29
	table.insert(_FontArr,"Gotham-Medium") -- 30
	
	table.insert(_FontArr,"Gotham-MediumItalic") -- 31
	table.insert(_FontArr,"Gotham-ThinItalic") -- 32
	table.insert(_FontArr,"Gotham-Ultra") -- 33
	table.insert(_FontArr,"Gotham-UltraItalic") -- 34
	table.insert(_FontArr,"Gotham-ExtraLight") -- 35
	table.insert(_FontArr,"Gotham-ExtraLightItalic") -- 36
	table.insert(_FontArr,"GothamNarrow-Black") -- 37
	table.insert(_FontArr,"GothamNarrow-BlackItalic") -- 38
	table.insert(_FontArr,"GothamNarrow-Bold") -- 39
	table.insert(_FontArr,"GothamNarrow-BoldItalic") -- 40
	
	table.insert(_FontArr,"GothamNarrow-Book") -- 41
	table.insert(_FontArr,"GothamNarrow-BookItalic") -- 42
	table.insert(_FontArr,"GothamNarrow-Light") -- 43
	table.insert(_FontArr,"GothamNarrow-LightItalic") -- 44
	table.insert(_FontArr,"GothamNarrow-Medium") -- 45
	table.insert(_FontArr,"GothamNarrow-MediumItalic") -- 46
	table.insert(_FontArr,"GothamNarrow-Thin") -- 47
	table.insert(_FontArr,"GothamNarrow-ThinItalic") -- 48
	table.insert(_FontArr,"GothamNarrow-Ultra") -- 49
	table.insert(_FontArr,"GothamNarrow-UltraItalic") -- 50
	
	table.insert(_FontArr,"GothamNarrow-XLight") -- 51
	table.insert(_FontArr,"GothamNarrow-XLightItalic") -- 52
end

local beaconArr = {}

function listener( event )
	if event.phase == "getBeacons" then
		if _Flag == false then
			response = ""
			tableCount = 0
			totalBeaconFound = 0
			
			if #event.data >= 1 then
				print_r( event.data )
				beaconArr[#beaconArr + 1] = event.data
				for i=1, #event.data, 1 do
					if( tostring(event.data[i].UUID) == "C0F2E240-836A-489B-A4B1-A0E87FD355BA" ) then
						totalBeaconFound = totalBeaconFound + 160
						
						if( tonumber(event.data[i].Accuracy) > 1 ) then
							tableCount = tableCount + 1
						end
						
						BeaconUUID = event.data[i].UUID
						
						if(i == 1) then
							_minorBea = event.data[i].Minor
							_majorBea = event.data[i].Major
							distanceBea = event.data[i].Accuracy
						else
							if(tonumber(distanceBea) > tonumber(event.data[i].Accuracy)) then
								_minorBea = event.data[i].Minor
								_majorBea = event.data[i].Major
								distanceBea = event.data[i].Accuracy
								
								sameBeaconFlag = false
								
								for i = 1, #nearestBeacon do
									if( nearestBeacon[i].Major == _majorBea and nearestBeacon[i].Minoir == _minorBea or nearestBeacon[i].Accuracy == distanceBea ) then
										sameBeaconFlag = true
										local var = nearestBeacon[i].appearance + 1
										nearestBeacon[i] = { Major = _majorBea, Minoir = _minorBea, Distance = distanceBea , appearance = var }
									else
										
									end
								end
								
								if( sameBeaconFlag == false ) then
									nearestBeacon[#nearestBeacon + 1] = { Major = _majorBea, Minoir = _minorBea, Distance = distanceBea , appearance = 1 }
								else
									
								end
								
							else
								
							end
						end
						
					end
					
				end
				
				beaconSearchCount = beaconSearchCount + 1
			else
				
			end
			
			if( beaconSearchCount == 1 ) then
				for i = 1, #beaconArr do
					for j = 1,#beaconArr[i] do
						
					end
				end
				
				if( #nearestBeacon == 0 ) then
					
				else
					for i = 1, #nearestBeacon do
						if( i == 1 ) then
							_minorBea = nearestBeacon[i].Minoir
							_majorBea = nearestBeacon[i].Major
							distanceBea = nearestBeacon[i].Distance
							apearanceValue = nearestBeacon[i].appearance
						else
							if( apearanceValue < nearestBeacon[i].appearance ) then
								_minorBea = nearestBeacon[i].Minoir
								_majorBea = nearestBeacon[i].Major
								distanceBea = nearestBeacon[i].Distance
							end
						end
					end
				end
				
			else
				
				timer.performWithDelay( 4000, function()
					if( beaconSearchCount == 5 ) then
						
					else
						
					end
				end,1)
				
			end
			
		else
			response = ""
			tableCount = 0
			totalBeaconFound = 0
			local oldMajorBea = _majorBea
			local oldMinorBea = _minorBea
			
			local function onGoBack( event )
				composer.gotoScene( "welcomeScreen" )
				for i = 1, #_CartArray do				
					table.remove( _CartArray,(i - (i-1)) )
				end
				
				_OrderID = nil
				_PlaceOrderTotal = nil
				
				return true
			end
						
			if #event.data >= 1 then
				print_r( event.data )
				beaconArr[#beaconArr + 1] = event.data
				for i=1, #event.data, 1 do
					if( event.data[i].UUID == "C0F2E240-836A-489B-A4B1-A0E87FD355BA" ) then
						if event.data[i].Distance == "Immediate" then
							_minorBea = event.data[i].Minor
							_majorBea = event.data[i].Major
							distanceBea = event.data[i].Distance
							break
							
						else
							if i == #event.data then
								_majorBea = oldMajorBea
								_minorBea = oldMinorBea
								_StopTimerFlag = true
								local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Order3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onLeaveApplication  )
							else
								
							end
						end
						
					end
					
				end
				
				beaconSearchCount = beaconSearchCount + 1
			else
				
			end
			
			if( beaconSearchCount == 1 ) then
				for i = 1, #beaconArr do
					for j = 1,#beaconArr[i] do
						
					end
				end
				
			else
				
			end
			
		end
		
	elseif event.phase == "scan" then
		if event.message then
			
		end
		if event.scanning then
			
		end
		
		nearestBeacon = { }
		beaconSearchCount = 0
		
	elseif event.phase == "stopscan" then
		if event.message then
			
		end
		if not event.scanning then
			
		end
	elseif event.phase == "init" then
		if event.message then
			
		end
		if event.initialised then
			iBeaconRunning = true
		end
	elseif event.phase == "initBluetooth" then
		local function checkBluetoothStatus()
			if event.BluetoothStatus == nil then
				iBeacon.getBluetoothStatues( listener )
				if timerForBluetooth then
					timer.cancel( timerForBluetooth )
					timerForBluetooth = nil
				end
				
			elseif event.BluetoothStatus == "1" then
				if timerForBluetooth then
					timer.cancel( timerForBluetooth )
					timerForBluetooth = nil
				end
				
				iBeacon.init( listener )
				
				timer.performWithDelay( 3000, function()
					if iBeaconRunning then
						iBeacon.scan( listener )
					else
						
					end
				end )
				
				timer.performWithDelay( 5000, function()
					if iBeaconRunning then
						iBeacon.getBeacons( listener )
					else
						
					end
					
				end )
				
			else
				if timerForBluetooth then
					timer.cancel( timerForBluetooth )
					timerForBluetooth = nil
				end
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("19Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onLeaveApplication )
				
			end
		end
		
		if event.BluetoothStatus == nil then
			timerForBluetooth = timer.performWithDelay( 1, checkBluetoothStatus, -1 )
			
		elseif event.BluetoothStatus == "0" then
			if timerForBluetooth then
				timer.cancel( timerForBluetooth )
				timerForBluetooth = nil
			end
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("19Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onLeaveApplication )
			
		elseif event.BluetoothStatus == "1" then
			if timerForBluetooth then
				timer.cancel( timerForBluetooth )
				timerForBluetooth = nil
			end
			
			iBeacon.init( listener )
			
			timer.performWithDelay( 3000, function()
				if iBeaconRunning then
					iBeacon.scan( listener )
				else
					
				end
			end )
			
			timer.performWithDelay( 5000, function()
				if iBeaconRunning then
					iBeacon.getBeacons( listener )
				else
					
				end
			end )
			
		else
			if timerForBluetooth then
				timer.cancel( timerForBluetooth )
				timerForBluetooth = nil
			end
			
		end
		
	else 
		if event.message then
			
		end
	end
end

local function storeData(name,data)
	local saveData = data
	local path = system.pathForFile( name, system.DocumentsDirectory )
	local file = io.open( path, "w" )
	file:write( saveData )
	io.close( file )
	file = nil
end

_UserName = loadData( "UserName" )
_Password = loadData( "Password" )
_UserID = loadData( "UserID" )
_Varified = loadData( "Varified" )
_fName = loadData( "F_Name" )
_lName = loadData( "L_Name" )
_StripeCustomerID = loadData( "S_ID" )
_Alleregy = loadData( "Allergies" )

local function onDoNothing()
	return true
end

local function onDoNothing2()
	if( splashBackGround ) then
		display.remove(splashBackGround)
		splashBackGround = nil
	end
	
	deleteAccFlag = true
	
	composer.gotoScene("LanguageList")
	
	return true
end

local function onDoNothing3()
	timer.performWithDelay( 2000, function()
		if( splashBackGround ) then
			display.remove(splashBackGround)
			splashBackGround = nil
		end
		composer.gotoScene( "verifiedAcc" )
	end,1)
	
	return true
end

local function onDoNothing4()
	timer.performWithDelay( 2000, function()
		if( splashBackGround ) then
			display.remove(splashBackGround)
			splashBackGround = nil
		end
		composer.gotoScene( "LanguageList" )
	end,1)
	
	return true
end

local function deviceIdNetworkListener( event )
	native.setActivityIndicator( false )
	if( notificationFlag2 == false ) then
		timer.performWithDelay( 2000, function()
			if( splashBackGround ) then
				display.remove(splashBackGround)
				splashBackGround = nil
			end
			if _Tutorial == "0" then
				composer.gotoScene("welcomeTutorialScreen")
			else
				composer.gotoScene("welcomeScreen")
			end
   	 	end,1)
   	else
   	
   	end
	
end

local function registerDeviceFunc( event )
	
	local deviceID = system.getInfo( "deviceID" )
    
    local platformName
        		
    if system.getInfo( "platformName" ) == "Android" then
        platformName = 2
    elseif system.getInfo( "platformName" ) == "iPhone OS" then
        platformName = 1
    else
        platformName = 1
    end
		if(RegistrationId == "") then
			
		else
	
		end					
		
		local headers = {}
			
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
			
		local body = "user_id=".._UserID.."&device_id="..deviceID.."&notif_id="..RegistrationId.."&type="..platformName.."&action=login"
			
		local params = {}
		params.headers = headers
		params.body = body
		params.timeout = 180
			
		local url = _WebLink.."reg-device.php?"
		deviceRequest = network.request( url, "POST", deviceIdNetworkListener, params )
		native.setActivityIndicator( true )


	
	return true
end

local function signInListNetworkListener( event )

	if ( event.isError ) then
        
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
    else
        
        
        local signInList = json.decode(event.response)
        
        if( signInList == 0 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( signInList == 1 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( signInList == 2 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Email2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
        	
        elseif( signInList == 3 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("Password4Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
		
        elseif( signInList == 4 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( signInList == 5 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Password7Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
        	
        elseif( signInList == 6 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Password2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing2 )
        	
        elseif( signInList == 7 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Account2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing3 )
			        	
        elseif( signInList == 8 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Account3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing4 )
        	
        else
        	storeData( "UserID", signInList.id )
        	storeData( "UserName", _UserName )
			storeData( "Password", _Password )
			storeData( "Varified", signInList.verif_account )
			storeData( "F_Name", signInList.first_name )
			storeData( "L_Name", signInList.last_name )
			storeData( "Allergies", signInList.allergies )
			
			if(signInList.card_number == nil or signInList.card_number == "" or signInList.card_number == " ") then
				
			else
				storeData( "S_CardNo", signInList.card_number )
				storeData( "S_CVVNo", signInList.cvv_number )
				storeData( "S_ExpiryMonth", signInList.expiry_date_month )
				storeData( "S_ExpiryYear", signInList.expiry_date_year )
				storeData( "S_Pin", signInList.pin_number )
				_StripeCardNo = signInList.card_number
				_StripeCVVNo = signInList.cvv_number
				_StripeExpMont = signInList.expiry_date_month
				_StripeExpYear = signInList.expiry_date_year
				_StripePin = signInList.pin_number
			end
			
			_UserName = _UserName
			_fName = signInList.first_name
			_lName = signInList.last_name
			_Password = _Password
			_UserID = signInList.id
			_Varified = signInList.verif_account
			_Alleregy = signInList.allergies
			
			
			registerDeviceFunc()
        	
        end
      	
        
    end
	return true
end

local function signInUsingTwitterNetworkListener( event )
	if ( event.isError ) then
		
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		local alert = native.showAlert( alertLabel, NetworkErrorMsg, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
    else
        
        
        local twitterSignInList = json.decode(event.response)
        
        if( twitterSignInList == 0 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "All fields are mandatory.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( twitterSignInList == 1 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "All fields are mandatory.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( twitterSignInList == 2 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Invalid connection variable.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( twitterSignInList == 3 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Something went wrong, Query Error.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
        elseif( twitterSignInList == 4 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Something went wrong, Query Error.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        else
        	_UserID = twitterSignInList.id
			storeData( "UserID", twitterSignInList.id )
        	storeData( "UserName", twitterSignInList.email )
			storeData( "Password", "" )
			storeData( "Varified", "1" )
			storeData( "F_Name", twitterSignInList.first_name )
			storeData( "twitter", "1" )
			storeData( "L_Name", twitterSignInList.last_name )
			storeData( "Allergies", twitterSignInList.allergies )
			
			if(twitterSignInList.card_number == nil or twitterSignInList.card_number == "" or twitterSignInList.card_number == " ") then
				
			else
				storeData( "S_CardNo", twitterSignInList.card_number )
				storeData( "S_CVVNo", twitterSignInList.cvv_number )
				storeData( "S_ExpiryMonth", twitterSignInList.expiry_date_month )
				storeData( "S_ExpiryYear", twitterSignInList.expiry_date_year )
				storeData( "S_Pin", twitterSignInList.pin_number )
				_StripeCardNo = twitterSignInList.card_number
				_StripeCVVNo = twitterSignInList.cvv_number
				_StripeExpMont = twitterSignInList.expiry_date_month
				_StripeExpYear = twitterSignInList.expiry_date_year
				_StripePin = twitterSignInList.pin_number
			end
			
			_UserName = twitterSignInList.email
			_fName = twitterSignInList.first_name
			_lName = twitterSignInList.last_name
			_Password = ""
			_UserID = twitterSignInList.id
			_Varified = "1"
			_Alleregy = twitterSignInList.allergies
			
			registerDeviceFunc()
        	
        end
     
    end
	return true
	
end

local function signInUsingFBNetworkListener( event )
	if ( event.isError ) then
        
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		local alert = native.showAlert( alertLabel, NetworkErrorMsg, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
    else
        
        
        local fbSignInList = json.decode(event.response)
        
        if( fbSignInList == 0 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "All fields are mandatory.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( fbSignInList == 1 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "All fields are mandatory.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( fbSignInList == 2 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Invalid connection variable.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( fbSignInList == 3 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Something went wrong, Query Error.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
        elseif( fbSignInList == 4 ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Something went wrong, Query Error.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        else
        	_UserID = fbSignInList.id
			storeData( "UserID", fbSignInList.id )
        	storeData( "UserName", fbSignInList.email )
			storeData( "Password", "" )
			storeData( "Varified", "1" )
			storeData( "F_Name", fbSignInList.first_name )
			storeData( "fb", "1" )
			storeData( "L_Name", fbSignInList.last_name )
			storeData( "Allergies", fbSignInList.allergies )
			
			if(fbSignInList.card_number == nil or fbSignInList.card_number == "" or fbSignInList.card_number == " ") then
				
			else
				storeData( "S_CardNo", fbSignInList.card_number )
				storeData( "S_CVVNo", fbSignInList.cvv_number )
				storeData( "S_ExpiryMonth", fbSignInList.expiry_date_month )
				storeData( "S_ExpiryYear", fbSignInList.expiry_date_year )
				storeData( "S_Pin", fbSignInList.pin_number )
				_StripeCardNo = fbSignInList.card_number
				_StripeCVVNo = fbSignInList.cvv_number
				_StripeExpMont = fbSignInList.expiry_date_month
				_StripeExpYear = fbSignInList.expiry_date_year
				_StripePin = fbSignInList.pin_number
			end
			
			_UserName = fbSignInList.email
			_fName = fbSignInList.first_name
			_lName = fbSignInList.last_name
			_Password = ""
			_UserID = fbSignInList.id
			_Varified = "1"
			_Alleregy = fbSignInList.allergies
			
			registerDeviceFunc()
        	
        end
     
    end
	return true
	
end

function twitterCancel()
	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
end

function twitterSuccess( requestType, name, response )
	local results = ""
	
	if "users" == requestType then
		results = response.name .. ", count: " ..
			response.statuses_count
	end
	
	local n = response.name
	local fName = string.sub(n,0,(string.find(n," ")-1))
	local lName = string.sub(n,(string.find(n," ")+1),string.len(n))
	
	local headers = {}
	
	headers["Content-Type"] = "application/x-www-form-urlencoded"
	headers["Accept-Language"] = "en-US"
	
	local body = "first_name="..fName.."&last_name="..lName.."&email="..response.email.."&connect=t"
	local params = {}
	params.headers = headers
	params.body = body
	params.timeout = 180
	
	local url = _WebLink.."fb-g-connect.php?"
	signInRequest = network.request( url, "POST", signInUsingTwitterNetworkListener, params )
	native.setActivityIndicator( true )
	
end

function twitterFailed()
	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
end

----------------------------- BEACON SCANNING STARTS HERE ----------------------------
 
timer.performWithDelay( 2000, function()
	iBeacon.allocateBluetoothInstance( listener )
	iBeacon.getBluetoothStatues( listener )
end )

----------------------------- BEACON SCANNING STARTS HERE ----------------------------

if _UserID == nil then
	timer.performWithDelay( 2000, function()
		if( splashBackGround ) then
			display.remove(splashBackGround)
			splashBackGround = nil
		end
		
		composer.gotoScene("LanguageList")
		
	end,1)
else
	
	local ifFbLogin = loadData( "fb" )
	local ifTwitterLogin = loadData( "twitter" )
	
	if(ifFbLogin == "1") then
		local url = _WebLink.."fb-g-connect.php?first_name=".._fName.."&last_name=".._lName.."&email=".._UserName.."&connect=fb"
		local url2 = url:gsub(" ", "%%20")
		network.request( url, "GET", signInUsingFBNetworkListener )
		native.setActivityIndicator( true )
		
	elseif (ifTwitterLogin == "1") then
		local listener = function( event )
			if event.phase == "authorised" then
				local postMessage = {"users", "account/verify_credentials.json", "GET",
					{"screen_name", "SELF"}, {"skip_status", "true"},
					{"include_entities", "false"}, {"include_email", "true"} }
				twitter:getInfo( postMessage )
			end
		end
		
		twitter = GGTwitter:new( consumerKey, consumerSecret, listener )
		twitter:authorise()		
		
	else
		local emailTfValue = _UserName:gsub( "&", "%%26" )
		local pswdTfValue = _Password:gsub( "&", "%%26" )
		
		local headers = {}
		
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		
		local body = "ws=1&email=".._UserName.."&password=".._Password
		local params = {}
		params.headers = headers
		params.body = body
		params.timeout = 180
		
		local url = _WebLink.."login.php?"
		signInRequest = network.request( url, "POST", signInListNetworkListener, params )
		native.setActivityIndicator( true )
		
	end
	
end

local function deviceIdNetworkListener( event )
	if ( event.isError ) then
        
        
        local alert = native.showAlert( alertLabel, NetworkErrorMsg, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) } , onLeaveApplication )
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
    else
       if( event.response == 0 ) then
        	local alert = native.showAlert( alertLabel, "All fields are mandatory123.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) } , onDoNothing)
        	
        elseif( event.response == 1 or deviceIdList == "1") then
        	local alert = native.showAlert( alertLabel, "All fields are mandatory.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) } , onDoNothing)
        
        elseif( event.response == 2  or deviceIdList == "2") then
        	local alert = native.showAlert( alertLabel, "Something went wrong, Query Error.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) } , onDoNothing )
        	
        elseif( event.response == 3 or deviceIdList == "3" ) then
        	local alert = native.showAlert( alertLabel, "Something went wrong, Query Error.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) } , onDoNothing )
       
        elseif( event.response == "DELETED" or event.response == "NOT-FOUND" ) then
        	
    _UserName = nil
	_Password = nil
	_UserID = nil
	_Varified = nil
	_fName = nil
	_lName = nil
	_StripeCustomerID = nil
	_Alleregy = nil
	_StripeCardNo = nil
	_StripeCVVNo = nil
	_StripeExpMont = nil
	_StripeExpYear = nil
	_StripePin = nil
	
	_selectedMainCategoryID = nil   
	_selectedLastSubCategoryID = nil  
	_selectedProductID = nil  
	_selectedProductListCategoryID = nil  
	_selectedProductListCategoryName = nil
	_selectedOrderID = nil
	_searchedString = nil
	_previousScene = nil
	_PreviousSceneforSetting = nil
	_PreviousSceneforOrder = nil
	
	local ifFbLogin = loadData( "fb" )
	
	if(ifFbLogin == "1") then
		local fbCommand
		local LOGOUT = 1
		fbCommand = LOGOUT
		
		os.remove( system.pathForFile( "fb", system.DocumentsDirectory ) )

	else
	
	end
	
	local ifTwitterLogin = loadData( "twitter" )
	
	if(ifTwitterLogin == "1") then
		twitter:destroy()
		twitter = nil
		
		os.remove( system.pathForFile( "twitter", system.DocumentsDirectory ) )
		
	else
	
	end
	
	for i = 1, #productRequest do
		if productRequest[i] then
			network.cancel( )
			productRequest[i] = nil
		end
	end
	
	-- Empty cart
	for i = 1, #_CartArray do
	
		table.remove( _CartArray,(i - (i-1)) )
			
	end
	
	if menuRequest then
		network.cancel( menuRequest )
		menuRequest = nil
	end
	
	for i = 1, #menuImageRequest do
		if menuImageRequest[i] then
			network.cancel( menuImageRequest[i] )
			menuImageRequest[i] = nil
		end
	end
	
	for i = 1, #menuImageRequest2 do
		if menuImageRequest2[i] then
			network.cancel( menuImageRequest2[i] )
			menuImageRequest2[i] = nil
		end
	end
	
	for i = 1, #menuImageRequest3 do
		if menuImageRequest3[i] then
			network.cancel( menuImageRequest3[i] )
			menuImageRequest3[i] = nil
		end
	end
	
	for i = 1, #productImageRequest do
		if productImageRequest[i] then
			network.cancel( productImageRequest[i] )
			productImageRequest[i] = nil
		end
	end
	
	for i = 1, #subMenuImageRequest do
		if subMenuImageRequest[i] then
			network.cancel( subMenuImageRequest[i] )
			subMenuImageRequest[i] = nil
		end
	end
	
	for i = 1, #subMenuImageRequest2 do
		if subMenuImageRequest2[i] then
			network.cancel( subMenuImageRequest2[i] )
			subMenuImageRequest2[i] = nil
		end
	end
	
	for i = 1, #subMenuImageRequest3 do
		if subMenuImageRequest3[i] then
			network.cancel( subMenuImageRequest3[i] )
			subMenuImageRequest3[i] = nil
		end
	end
	
	os.remove( system.pathForFile( "UserID", system.DocumentsDirectory ) )
	os.remove( system.pathForFile( "UserName", system.DocumentsDirectory ) )
	os.remove( system.pathForFile( "Password", system.DocumentsDirectory ) )
	os.remove( system.pathForFile( "Varified", system.DocumentsDirectory ) )
	os.remove( system.pathForFile( "F_Name", system.DocumentsDirectory ) )
	os.remove( system.pathForFile( "L_Name", system.DocumentsDirectory ) )
	os.remove( system.pathForFile( "Varified", system.DocumentsDirectory ) )
	os.remove( system.pathForFile( "S_ID", system.DocumentsDirectory ) )
	os.remove( system.pathForFile( "Allergies", system.DocumentsDirectory ) )
	
	os.remove( system.pathForFile( "S_CardNo", system.DocumentsDirectory ) )
	os.remove( system.pathForFile( "S_CVVNo", system.DocumentsDirectory ) )
	os.remove( system.pathForFile( "S_ExpiryMonth", system.DocumentsDirectory ) )
	os.remove( system.pathForFile( "S_ExpiryYear", system.DocumentsDirectory ) )
	os.remove( system.pathForFile( "S_Pin", system.DocumentsDirectory ) )
	
	local doc_path = system.pathForFile( "", system.TemporaryDirectory )
	
	for file in lfs.dir( doc_path ) do
	    os.remove( system.pathForFile( file, system.TemporaryDirectory ) )
	end
		composer.gotoScene("login")
        	
		end

        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
        
    end
	
end

function logOutFunc()
	
	local deviceID = system.getInfo( "deviceID" )
    local platformName
        		
    if system.getInfo( "platformName" ) == "Android" then
        platformName = 2
    elseif system.getInfo( "platformName" ) == "iPhone OS" then
        platformName = 1
    else
        platformName = 1
    end
	
	if(RegistrationId == "") then
		
	else
	
	end						
							
	local headers = {}
			
	headers["Content-Type"] = "application/x-www-form-urlencoded"
	headers["Accept-Language"] = "en-US"
	local body = "user_id=".._UserID.."&device_id="..deviceID.."&notif_id="..RegistrationId.."&type="..platformName.."&action=logout"
			
	local params = {}
	params.headers = headers
	params.body = body
	params.timeout = 180
			
	local url = _WebLink.."reg-device.php?"
			
	deviceRequest = network.request( url, "POST", deviceIdNetworkListener, params )
	native.setActivityIndicator( true )
    
end

function roundDigit(value)
	local digValue	
	if(string.find(tostring(value),"%.")) then
		digValue1 = tostring(value):sub(1,string.find(tostring(value),"%.") + 3)
		if(tonumber(digValue1:sub(digValue1:len(),digValue1:len())) > 5 ) then
			digValue2 = digValue1:sub(1,string.find(tostring(value),"%.") + 2)
			digValue3 = tonumber(digValue2)
		else
			digValue3 = digValue1:sub(1,string.find(tostring(value),"%.") + 2)
		end
	else
		digValue3 = value
	end
	
	return digValue3
end

function make2Digit( value )
	local d_value 
	local d_value1 
	
	if(string.find(tostring(value),"%.")) then
		d_value1 = tostring(value):sub(1,string.find(tostring(value),"%.") + 3)
		if( tostring(d_value1:sub(string.find(tostring(d_value1),"%.") + 1),d_value1:len()):len() < 2 ) then
			d_value = tostring(d_value1).."0"
		else
			d_value = d_value1:sub(1,string.find(tostring(d_value1),"%.") + 2)
		end
	else
		d_value = value..".00"
	end
	return d_value
end

local function onKeyEvent( event )
if (event.keyName == "back") and (system.getInfo("platformName") == "Android") and event.phase == "up"  then
    
    if composer.getSceneName("current") == "menu" then
	    native.requestExit()
	elseif composer.getSceneName("current") == "welcomeScreen" then
	    native.requestExit()
	elseif composer.getSceneName("current") == "login" then
	    native.requestExit()
	elseif composer.getSceneName("current") == "FrontPage" then
	    native.requestExit()
	elseif composer.getSceneName("current") == "tutorial" then
	    if composer.getSceneName("previous") == "welcomeTutorialScreen" then
	    	composer.gotoScene( "welcomeTutorialScreen" )
	    elseif composer.getSceneName("previous") == "menu" then
	    	composer.gotoScene( "menu" )
	    elseif composer.getSceneName("previous") == "searchProduct" then
	    	composer.gotoScene( "searchProduct" )
	    elseif composer.getSceneName("previous") == "ProductListPage" then
	    	composer.gotoScene( "ProductListPage" )
	    elseif composer.getSceneName("previous") == "Product" then
	    	composer.gotoScene( "Product" )
	    end
	elseif composer.getSceneName("current") == "welcomeTutorialScreen" then
	   	native.requestExit()
	elseif composer.getSceneName("current") == "LanguageList" then
		if composer.getSceneName("previous") == nil then
	    	native.requestExit()
			deleteAccFlag = false
		else
			if deleteAccFlag == true then
				deleteAccFlag = false
			    native.requestExit()
			else
				deleteAccFlag = false
				composer.gotoScene( "menu" )
			end
		end
		
	elseif composer.getSceneName( "current" ) == "aboutUs" then
		composer.gotoScene( "Setting" )
		
	elseif composer.getSceneName( "current" ) == "changePassword" then
		composer.gotoScene( "Setting" )
		
	elseif composer.getSceneName( "current" ) == "changePassword2" then
		composer.gotoScene( "forgotPassword" )
		
	elseif composer.getSceneName( "current" ) == "editProfile" then
		composer.gotoScene( "menu" )
		
	elseif composer.getSceneName( "current" ) == "forgotPassword" then
		local previous = composer.getSceneName( "previous" )
		if(_passwordPreviousScene) then
			composer.gotoScene( _passwordPreviousScene )
		else
			composer.gotoScene( previous )
		end
		
	elseif composer.getSceneName( "current" ) == "OrderDetailsPage" then
		composer.gotoScene( "OrderHistory" )	
			
	elseif composer.getSceneName( "current" ) == "OrderHistory" then
		local previous = composer.getSceneName("previous") 
		if previous == "OrderDetailsPage" then
			composer.gotoScene( _PreviousSceneforOrder )
		elseif( previous == "PlaceOrder" or previous == "OrderPopUp" ) then
			composer.gotoScene( "menu" )
		else
			composer.gotoScene( composer.getSceneName("previous") )
		end
		
	elseif composer.getSceneName( "current" ) == "PlaceOrder" then
		local previous = composer.getSceneName( "previous" )
		if(composer.getSceneName( "previous" ) == "stripeRegistration" or composer.getSceneName( "previous" ) == "ProvidePin" ) then
			composer.gotoScene( "menu" )
		else
			composer.gotoScene( previous )
		end
				
	elseif composer.getSceneName( "current" ) == "policy" then
		if( composer.getSceneName( "previous" ) == "login" ) then
			composer.gotoScene( "login" )
		elseif( composer.getSceneName( "previous" ) == "signUp" ) then
			composer.gotoScene( "signUp" )
		else
			composer.gotoScene( "login" )
		end
		
	elseif composer.getSceneName( "current" ) == "Product" then
		if(composer.getSceneName( "previous" ) == "ProductListPage") then
			composer.gotoScene( "ProductListPage" )
		else
			composer.gotoScene( _previousScene )
		end
		 
	elseif composer.getSceneName( "current" ) == "ProductListPage" then
		if(_previousScene == "SubMenu3") then
			composer.gotoScene("SubMenu3")
		else
			composer.gotoScene("menu")
		end
	
	elseif composer.getSceneName( "current" ) == "RatePage" then
		composer.gotoScene( "Setting" )
		
	elseif composer.getSceneName( "current" ) == "Setting" then
		local previous = composer.getSceneName( "previous" )
		if previous == "changePassword" or previous == "terms" or previous == "aboutUs" or previous == "RatePage" or previous == "ShareWopado_Overlay" then
			composer.gotoScene( _PreviousSceneforSetting )
		else
			composer.gotoScene( previous )
		end
		
	elseif composer.getSceneName( "current" ) == "ShareWopado_Overlay" then
		composer.gotoScene( composer.getSceneName( "previous" ) )
	
	elseif composer.getSceneName( "current" ) == "signUp" then
		composer.gotoScene( "login" )
	
	elseif composer.getSceneName( "current" ) == "SubMenu3" then
		composer.gotoScene("menu")
		
	elseif composer.getSceneName( "current" ) == "support" then
		local previous = composer.getSceneName( "previous" )
		composer.gotoScene( previous )
		
	elseif composer.getSceneName( "current" ) == "terms" then
		if( composer.getSceneName( "previous" ) == "login" ) then
			composer.gotoScene( "login" )
		elseif( composer.getSceneName( "previous" ) == "signUp" ) then
			composer.gotoScene( "signUp" )
		else
			composer.gotoScene( "Setting" )
		end	
	
	elseif composer.getSceneName( "current" ) == "verifiedAcc" then
	
	elseif composer.getSceneName( "current" ) == "OrderPopUp" then
		composer.gotoScene( "menu" )
		
	elseif composer.getSceneName( "current" ) == "stripeRegistration" then
		local previous = composer.getSceneName( "previous" )
		composer.gotoScene( previous )
		
	elseif composer.getSceneName( "current" ) == "searchProduct" then
		
		if(composer.getSceneName( "previous" ) == "SubMenu3") then
			composer.gotoScene("SubMenu3")
		else
			composer.gotoScene("menu")
		end
		
	elseif composer.getSceneName( "current" ) == "ProvidePin" then
		composer.gotoScene("PlaceOrder")
	elseif composer.getSceneName( "current" ) == "cardSelection" then
		composer.gotoScene( "PlaceOrder" )
    else
    	composer.gotoScene("menu")
    end
   	
end

return true
end

-- Add the key event listener.
Runtime:addEventListener( "key", onKeyEvent)
 
local launchArgs = ...
RegistrationId = ""
local function onNotification(event)
	if event.type == "remoteRegistration" then
		RegistrationId = event.token
	else
		notificationFlag = true
		notificationFlag2 = false
		
		local notificationTable
		if system.getInfo("platformName") == "Android" then
			notificationTable = event.custom
		else
			notificationTable = event.custom
		end
		
		local function onReceiveNotification( event )
			if event.action == "clicked" then
       	 	local i = event.index
        	if i == 1 then
        			local option = {
						params = {
							orderTable = notificationTable
						}
					}
					if( splashBackGround ) then
						display.remove(splashBackGround)
						splashBackGround = nil
					end
					composer.gotoScene("blankPage",option)
			
				
				
        	elseif i == 2 then
            	
        	end
   	  		end
			
		end
		
		local function showNotificationAlert( e )
			if(_UserID == nil) then
				
			else
				notifications.cancelNotification()
    			native.showAlert( alertLabel, GBCLanguageCabinet.getText("OrderIsReadyLabel",_LanguageKey) , { GBCLanguageCabinet.getText("showLabel",_LanguageKey), GBCLanguageCabinet.getText("CancelLabel",_LanguageKey) }, onReceiveNotification )
			end
		end   
		
		timer.performWithDelay( 3000, showNotificationAlert )
		native.setProperty( "applicationIconBadgeNumber", 0 )
		
		
	end
end

if launchArgs and launchArgs.notification then

local function onComplete123(e)
	
	if "clicked" == e.action then
		
	end
end
	notificationFlag = true
	notificationFlag2 = true
	local notificationTable 
	
		if system.getInfo("platformName") == "Android" then
			notificationTable = launchArgs.notification.custom
		else
			notificationTable = launchArgs.notification.custom
		end
				
		local function onReceiveNotification( event )
			local option = {
				params = {
					orderTable = notificationTable
				}
			}
			
			if( splashBackGround ) then
				display.remove(splashBackGround)
				splashBackGround = nil
			end
			
			composer.gotoScene("blankPage",option)
			launchArgs = nil
        	
		end
		
		local function showNotificationAlert( event )
			if(_UserID == nil) then
				
			else
				onReceiveNotification()
			end
			
		end
	
		
		timer.performWithDelay( 3000, showNotificationAlert )
		native.setProperty( "applicationIconBadgeNumber", 0 )
end

-- Set up a notification listener.
Runtime:addEventListener("notification", onNotification)

system.setIdleTimer( false )

local function onSystemEvent( event )
    
    if (event.type == "applicationStart") then
		
    elseif (event.type == "applicationExit") then 
    	_majorBea = nil
        _minorBea = nil
         _menuList = { }
        categoryName = { }
		categoryImage1 = { }
		categoryImage2 = { }
		categoryImage3 = { }

		subMenuImages = { }
		subMenuID = { }
		subToSubMenuImages = { }
		subToSubMenuID = { }
		ProductCategoryID = { }
		productData = { }
		productImages = { }
		subToSub2MenuImages = { }
		subToSub2MenuID = { }
		search_productCatId = { }
		search_productData = { }
		search_productName = ""

		count = 0
		sub_count = 0
		subToSub_count = 0
		subToSub2_count = 0
		
		local doc_path = system.pathForFile( "", system.TemporaryDirectory )
	
		for file in lfs.dir( doc_path ) do
    		os.remove( system.pathForFile( file, system.TemporaryDirectory ) )
		end
        
    elseif ( event.type == "applicationSuspend" ) then
        _majorBea = nil
        _minorBea = nil
        _menuList = { }

		categoryName = { }
		categoryImage1 = { }
		categoryImage2 = { }
		categoryImage3 = { }

		subMenuImages = { }
		subMenuID = { }
		subToSubMenuImages = { }
		subToSubMenuID = { }
		ProductCategoryID = { }
		productData = { }
		productImages = { }
		subToSub2MenuImages = { }
		subToSub2MenuID = { }
		search_productCatId = { }
		search_productData = { }
		search_productName = ""

		count = 0
		sub_count = 0
		subToSub_count = 0
		subToSub2_count = 0
		
		local doc_path = system.pathForFile( "", system.TemporaryDirectory )
	
		for file in lfs.dir( doc_path ) do
    		os.remove( system.pathForFile( file, system.TemporaryDirectory ) )
		end
        
        if _UserID == nil then
         	if( composer.getSceneName( "current" ) == "LanguageList" ) then
         		
         	else
				composer.gotoScene("FrontPage")
			end
		
    	else
    		if( notificationFlag == true or notificationFlag2 == true ) then
    		
    		else
    			if _Tutorial == "0" then
					composer.gotoScene("welcomeTutorialScreen")
				else
					composer.gotoScene("welcomeScreen")
				end
    		end
   	 	end
    
    elseif event.type == "applicationResume" then
        iBeacon.stopscan( listener )
        _Flag = false
        timer.performWithDelay( 500, function()
			iBeacon.allocateBluetoothInstance( listener )
			iBeacon.getBluetoothStatues( listener )
		end )
		
	end
	
end

--setup the system listener to catch applicationExit etc
Runtime:addEventListener( "system", onSystemEvent )