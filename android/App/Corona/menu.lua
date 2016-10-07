local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


local imageDirectory = "images/MainMenu/"
local imageDirectory2 = "images/Navigation/"
local imageDirectory3 = "images/Login/"

local displayGroup, url2, m, n
local navigationGroup, menuFlag
local count
local waterRequest,networkReqCount
local VariableTable = { background, header, header2, restaurantName, restaurantAdd, homeBtn, searchBtn, menuScrollView,
		noCategory, searchTextField, placeOrderBtn,waterBtn, bgRect, searchBg }

local NavigationVariableTable = { "sliderBg", "logo", "HeaderBG", "ChefImage", "ProfileBg", "Rect1", "Rect2", "Rect3",
"Rect4","Rect5", "Ract6", "Rect7", "CartIcon", "OrderIcon", "FeedBackIcon", "SettingIcon", "RestaurantIcon", "TutorialIcon",
"LogOutIcon", "ProfilePicBg", "ProfileEditLabel", "ProfileEditBg", "CartLabel", "OrderLabel", "FeedBackLabel", "SettingLabel",
"RestaurantLabel", "TutorialLabel", "LogOutLabel", "UserName", "UserEmail", "HotelAddress", "HotelName", "OverRect" }

local categoryId = { }
local categoryName = { }
local categoryImage = { }
local defaultPhoto = { }
local image = { }
local nameBg = { }
local name = { }
local newLabel = { }
local OverRect,beginX,endX
local textFieldWidth = _W/32
local textFieldHeight = _H/64

local function onDoNothing( event )
	return true
end

local function onBgRect( event )
	native.setKeyboardFocus( nil )
	VariableTable.searchBg.isVisible = false
	VariableTable.searchTextField.isVisible = false
	VariableTable.restaurantName.isVisible = true
	VariableTable.restaurantAdd.isVisible = true
	
	return true
end

local function onGotoSubMenu( event )
	
	print("target id"..event.target.id)
	
	local id = event.target.id:sub(1, string.find( event.target.id,"//" ) - 1 )
	
	local index = event.target.id:sub(string.find( event.target.id,"//" ) + 2,event.target.id:len())
	
	print(_menuList[tonumber(index)].id )
	print("//////////".. id)
	
	if(_menuList[tonumber(index)].sub_menu) then
		
	if( #_menuList[tonumber(index)].sub_menu > 0 ) then 
		_selectedMainCategoryID = id
		composer.gotoScene( "SubMenu3" )
		
	else
		_selectedProductListCategoryID = id
		_selectedProductListCategoryName = _menuList[tonumber(index)].category_name
		composer.gotoScene("ProductListPage")
	
	end
	else
	
		_selectedProductListCategoryID = id
		_selectedProductListCategoryName = _menuList[tonumber(index)].category_name
		composer.gotoScene("ProductListPage")
	
	end

	return true
end

local function OnEditProfileTap( event )
		
	composer.gotoScene("editProfile")
	return true
end

local function OnEditProfileTouch( event )
	if(event.phase == "began") then
		
		composer.gotoScene("editProfile")
	end
	return true
end


local function onRectTap( event )
	if(event.target.id == 1) then
		composer.gotoScene( "PlaceOrder" )
		
	elseif(event.target.id == 2) then
		composer.gotoScene( "OrderHistory" )
		
	elseif(event.target.id == 3) then
		composer.gotoScene( "support" )
		
	elseif(event.target.id == 4) then
		composer.gotoScene( "Setting" )
		
	elseif(event.target.id == 5) then
		logOutFunc()
		
	elseif(event.target.id == 6) then
		print( "restaurants..." )
		composer.gotoScene( "RestaurantsList" )
		
	elseif(event.target.id == 7) then
		print( "tutorial..." )
		composer.gotoScene( "tutorial" )
		
	end
	
	return true
end

local function onRectTouch( event )
	if(event.phase == "ended") then
		if(event.target.id == 1) then
			composer.gotoScene( "PlaceOrder" )
			
		elseif(event.target.id == 2) then
			composer.gotoScene( "OrderHistory" )
			
		elseif(event.target.id == 3) then
			composer.gotoScene( "support" )
			
		elseif(event.target.id == 4) then
			composer.gotoScene( "Setting" )
			
		elseif(event.target.id == 5) then
			logOutFunc()
			
		elseif(event.target.id == 6) then
			print( "restaurants..." )
			composer.gotoScene( "RestaurantsList" )
			
		elseif(event.target.id == 7) then
			print( "tutorial..." )
			composer.gotoScene( "tutorial" )
			
		end
	end
	return true
end

local function checkDirection()
	if(endX < beginX) then
		if((beginX - endX) > 10) then
			OverRect.isVisible = false
			navigationGroup.x = navigationGroup.x - _W/1.28
			displayGroup.x = displayGroup.x - _W/1.28
			menuFlag = 0
		end
	end
	return true
end

local function onTouchNavigationOverRect( event )
	if(event.phase == "began") then
		beginX = event.x
	elseif(event.phase == "moved") then
		endX = event.x
	elseif(event.phase == "ended") then
		if(beginX and endX) then
			checkDirection()
		end
	end
	return true
end

local function createNavigation()
	------------------------------------------------------------- Navigation start  --------------------------------------------------------------        
    
    
    NavigationVariableTable.sliderBg = display.newImageRect(imageDirectory2.."SliderBg.png",_W/1.17,_H/1.25)
    NavigationVariableTable.sliderBg.x = -_W/1.28
    NavigationVariableTable.sliderBg.y = _H
    NavigationVariableTable.sliderBg.anchorX = 0 
    NavigationVariableTable.sliderBg.anchorY = 1
   	navigationGroup:insert( NavigationVariableTable.sliderBg )
        
    NavigationVariableTable.logo = display.newImageRect("images/Wopadu_Logo.png",_W/3.66,_H/6.78)
    NavigationVariableTable.logo.x = -_W/1.28 + _W/24 + NavigationVariableTable.logo.width/2    
    NavigationVariableTable.logo.y = _H/34.28 + NavigationVariableTable.logo.height/2    
    navigationGroup:insert( NavigationVariableTable.logo ) 
    
    NavigationVariableTable.HeaderBG = display.newImageRect(imageDirectory2.."ShopDetailBg.png",_W/1.19,_H/9.14)
    NavigationVariableTable.HeaderBG.x = -_W/1.28    
    NavigationVariableTable.HeaderBG.y =  _H/5 + NavigationVariableTable.HeaderBG.height/2 
    NavigationVariableTable.HeaderBG.anchorX = 0 
    navigationGroup:insert( NavigationVariableTable.HeaderBG ) 
    
    NavigationVariableTable.ChefImage = display.newImageRect(imageDirectory2.."Chef_Icon.png",_W/10.48,_H/12.71)
    NavigationVariableTable.ChefImage.x = -_W/1.28 + _W/15.88  
    NavigationVariableTable.ChefImage.y =  NavigationVariableTable.HeaderBG.y  
    NavigationVariableTable.ChefImage.anchorX = 0 
    navigationGroup:insert( NavigationVariableTable.ChefImage )
    
    --_HotelName = "Jamie’s  Italaian"
    --_HotelAddress = "21st Street, New York \nZip Code 41108, United States"
    
    
    if(_HotelName:len() > 25) then
    	HotelNameText = tostring(_HotelName:sub(1,15))..".."
    else
    	HotelNameText = _HotelName
    end
    
    if(_HotelAddress:len() > 60) then
    	HotelAddressText =  tostring(_HotelAddress:sub(1,60))..".."
    else
    	HotelAddressText = _HotelAddress
    end
   
    
    NavigationVariableTable.HotelName = display.newText(HotelNameText,-_W/1.28 + _W/4.9,_H/4.10,_FontArr[1],_H/36.76 )
    NavigationVariableTable.HotelName.anchorX = 0
    NavigationVariableTable.HotelName.anchorY = 1
    NavigationVariableTable.HotelName:setTextColor( 1 )
    navigationGroup:insert( NavigationVariableTable.HotelName )
    
    NavigationVariableTable.HotelAddress = display.newText(HotelAddressText,-_W/1.28 + _W/4.9,_H/3.93,_W/2,0,_FontArr[30],_H/63.03 )
    NavigationVariableTable.HotelAddress.anchorX = 0
    NavigationVariableTable.HotelAddress.anchorY = 0
    NavigationVariableTable.HotelAddress:setTextColor( 1 )
    navigationGroup:insert( NavigationVariableTable.HotelAddress )
    
    
    --[[NavigationVariableTable.ProfileBg = display.newImageRect(imageDirectory2.."ProfileBg.png",_W/1.19,_H/9.05)
    NavigationVariableTable.ProfileBg.x = -_W/1.28  
    NavigationVariableTable.ProfileBg.y =  _H/3.25  + NavigationVariableTable.ProfileBg.height/2 
    NavigationVariableTable.ProfileBg.anchorX = 0 
    navigationGroup:insert( NavigationVariableTable.ProfileBg )
    
    NavigationVariableTable.ProfilePicBg = display.newImageRect(imageDirectory2.."ProfilePicBg.png",_W/7.39,_H/13.06)
    NavigationVariableTable.ProfilePicBg.x = -_W/1.28 + _W/27  
    NavigationVariableTable.ProfilePicBg.y =  NavigationVariableTable.ProfileBg.y
    NavigationVariableTable.ProfilePicBg.anchorX = 0 
    navigationGroup:insert( NavigationVariableTable.ProfilePicBg )]]--
    
    --_fName = "Krishna Maru"
    --_UserID = "krishnamaru123@gmail.com"
    
    if(_fName:len() > 15) then
    	UserNameText = tostring(_fName:sub(1,15))..".."
    else
    	UserNameText = _fName
    end
    --_W/1.28 + _W/7.2
    NavigationVariableTable.UserName = display.newText(UserNameText,-_W/1.28 + _W/15.42,_H/2.74,_FontArr[6],_H/31.51 )
    NavigationVariableTable.UserName.anchorX = 0
    NavigationVariableTable.UserName.anchorY = 1
    NavigationVariableTable.UserName:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.UserName )
    
    if(_UserName:len() > 25) then
    	UserMailText = tostring(_UserName:sub(1,25))..".."
    else
    	UserMailText = _UserName
    end
    
    NavigationVariableTable.UserEmail = display.newText(UserMailText,-_W/1.28 + _W/15.42,_H/2.57,_FontArr[6],_H/45 )
    NavigationVariableTable.UserEmail.anchorX = 0
    NavigationVariableTable.UserEmail.anchorY = 1
    NavigationVariableTable.UserEmail:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.UserEmail )
    
    NavigationVariableTable.ProfileEditLabel = display.newText(tostring(GBCLanguageCabinet.getText("editProfileLabel",_LanguageKey)),NavigationVariableTable.sliderBg.x+ _W/1.28 - _W/108,NavigationVariableTable.UserEmail.y + _H/96,_FontArr[6],_H/45)
    NavigationVariableTable.ProfileEditLabel.anchorX = 1
    NavigationVariableTable.ProfileEditLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.ProfileEditLabel )
    
    NavigationVariableTable.ProfileEditBg = display.newRect(NavigationVariableTable.sliderBg.x+ _W/1.28 - _W/108,NavigationVariableTable.ProfileEditLabel.y - _H/192,NavigationVariableTable.ProfileEditLabel.width + _W/54, NavigationVariableTable.ProfileEditLabel.height + _H/96 )
    NavigationVariableTable.ProfileEditBg.anchorX = 1
    NavigationVariableTable.ProfileEditBg:setFillColor( 1, 1, 1, 0.1 )
    NavigationVariableTable.ProfileEditBg:addEventListener("tap",OnEditProfileTap)
    NavigationVariableTable.ProfileEditBg:addEventListener("touch",OnEditProfileTouch)
    navigationGroup:insert( NavigationVariableTable.ProfileEditBg )
    
    NavigationVariableTable.Rect1 = display.newImageRect(imageDirectory2.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable.Rect1.x = -_W/1.28  
    NavigationVariableTable.Rect1.y =  _H/2.4 + NavigationVariableTable.Rect1.height/2 
    NavigationVariableTable.Rect1.anchorX = 0 
    NavigationVariableTable.Rect1.id = 1
    NavigationVariableTable.Rect1:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect1:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable.Rect1 )
    
    NavigationVariableTable.CartIcon = display.newImageRect(imageDirectory2.."Cart_Icon.png",_W/18.30,_H/48)
    NavigationVariableTable.CartIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.CartIcon.y =  NavigationVariableTable.Rect1.y  
    navigationGroup:insert( NavigationVariableTable.CartIcon )
    
    NavigationVariableTable.CartLabel = display.newText(GBCLanguageCabinet.getText("viewCartLabel",_LanguageKey),-_W/1.28 + _W/7.2,NavigationVariableTable.Rect1.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.CartLabel.anchorX = 0
    NavigationVariableTable.CartLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.CartLabel )
    
    NavigationVariableTable.Rect2 = display.newImageRect(imageDirectory2.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable.Rect2.x = -_W/1.28  
    NavigationVariableTable.Rect2.y =  NavigationVariableTable.Rect1.y + _H/12.22 
    NavigationVariableTable.Rect2.anchorX = 0 
    NavigationVariableTable.Rect2.id = 2
    NavigationVariableTable.Rect2:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect2:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable.Rect2 )
    
    NavigationVariableTable.OrderIcon = display.newImageRect(imageDirectory2.."OrderHistory_Icon.png",_W/26.34,_H/32)
    NavigationVariableTable.OrderIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.OrderIcon.y =  NavigationVariableTable.Rect2.y  
    navigationGroup:insert( NavigationVariableTable.OrderIcon )
    
    NavigationVariableTable.OrderLabel = display.newText(GBCLanguageCabinet.getText("orderHistoryLabel", _LanguageKey),-_W/1.28 + _W/7.2,NavigationVariableTable.Rect2.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.OrderLabel.anchorX = 0
    NavigationVariableTable.OrderLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.OrderLabel )
    
    NavigationVariableTable.Rect3 = display.newImageRect(imageDirectory2.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable.Rect3.x = -_W/1.28  
    NavigationVariableTable.Rect3.y =  NavigationVariableTable.Rect2.y + _H/12.22 
    NavigationVariableTable.Rect3.anchorX = 0 
    NavigationVariableTable.Rect3.id = 3
    NavigationVariableTable.Rect3:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect3:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable.Rect3 )
    
    NavigationVariableTable.FeedBackIcon = display.newImageRect(imageDirectory2.."FeedBack_Icon.png",_W/17.70,_H/31.47)
    NavigationVariableTable.FeedBackIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.FeedBackIcon.y =  NavigationVariableTable.Rect3.y  
    navigationGroup:insert( NavigationVariableTable.FeedBackIcon )
    
    NavigationVariableTable.FeedBackLabel = display.newText(GBCLanguageCabinet.getText("faqLabel", _LanguageKey),-_W/1.28 + _W/7.2,NavigationVariableTable.Rect3.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.FeedBackLabel.anchorX = 0
    NavigationVariableTable.FeedBackLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.FeedBackLabel )
    
    NavigationVariableTable.Rect4 = display.newImageRect(imageDirectory2.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable.Rect4.x = -_W/1.28  
    NavigationVariableTable.Rect4.y =  NavigationVariableTable.Rect3.y + _H/12.22 
    NavigationVariableTable.Rect4.anchorX = 0 
    NavigationVariableTable.Rect4.id = 4
    NavigationVariableTable.Rect4:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect4:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable.Rect4 )
    
    NavigationVariableTable.SettingIcon = display.newImageRect(imageDirectory2.."Setting_Icon.png",_W/17.41,_H/30.96)
    NavigationVariableTable.SettingIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.SettingIcon.y =  NavigationVariableTable.Rect4.y  
    navigationGroup:insert( NavigationVariableTable.SettingIcon )
    
    NavigationVariableTable.SettingLabel = display.newText(GBCLanguageCabinet.getText("settingLabel", _LanguageKey),-_W/1.28 + _W/7.2,NavigationVariableTable.Rect4.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.SettingLabel.anchorX = 0
    NavigationVariableTable.SettingLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.SettingLabel )
    
    NavigationVariableTable.Rect6 = display.newImageRect(imageDirectory2.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable.Rect6.x = -_W/1.28  
    NavigationVariableTable.Rect6.y =  NavigationVariableTable.Rect4.y + _H/12.22 
    NavigationVariableTable.Rect6.anchorX = 0 
    NavigationVariableTable.Rect6.id = 6
    NavigationVariableTable.Rect6:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect6:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable.Rect6 )
    
    NavigationVariableTable.RestaurantIcon = display.newImageRect(imageDirectory2.."restaurant_Icon.png",_W/17.41,_H/30.96)
    NavigationVariableTable.RestaurantIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.RestaurantIcon.y =  NavigationVariableTable.Rect6.y  
    navigationGroup:insert( NavigationVariableTable.RestaurantIcon )
    
    NavigationVariableTable.RestaurantLabel = display.newText(GBCLanguageCabinet.getText("restaurantLabel", _LanguageKey),-_W/1.28 + _W/7.2,NavigationVariableTable.Rect6.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.RestaurantLabel.anchorX = 0
    NavigationVariableTable.RestaurantLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.RestaurantLabel )
    
    NavigationVariableTable.Rect7 = display.newImageRect(imageDirectory2.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable.Rect7.x = -_W/1.28  
    NavigationVariableTable.Rect7.y =  NavigationVariableTable.Rect6.y + _H/12.22 
    NavigationVariableTable.Rect7.anchorX = 0 
    NavigationVariableTable.Rect7.id = 7
    NavigationVariableTable.Rect7:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect7:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable.Rect7 )
    
    NavigationVariableTable.TutorialIcon = display.newImageRect(imageDirectory2.."tutorial_Icon.png",_W/17.41,_H/30.96)
    NavigationVariableTable.TutorialIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.TutorialIcon.y =  NavigationVariableTable.Rect7.y  
    navigationGroup:insert( NavigationVariableTable.TutorialIcon )
    
    NavigationVariableTable.TutorialLabel = display.newText(GBCLanguageCabinet.getText("tutorialLabel", _LanguageKey),-_W/1.28 + _W/7.2,NavigationVariableTable.Rect7.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.TutorialLabel.anchorX = 0
    NavigationVariableTable.TutorialLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.TutorialLabel )
    
    NavigationVariableTable.Rect5 = display.newImageRect(imageDirectory2.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable.Rect5.x = -_W/1.28  
    NavigationVariableTable.Rect5.y =  NavigationVariableTable.Rect7.y + _H/12.22 
    NavigationVariableTable.Rect5.anchorX = 0 
    NavigationVariableTable.Rect5.id = 5
    NavigationVariableTable.Rect5:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect5:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable.Rect5 )
    
    NavigationVariableTable.LogOutIcon = display.newImageRect(imageDirectory2.."LogOut_Icon.png",_W/17.70,_H/38.4)
    NavigationVariableTable.LogOutIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.LogOutIcon.y =  NavigationVariableTable.Rect5.y  
    navigationGroup:insert( NavigationVariableTable.LogOutIcon )
    
    NavigationVariableTable.LogOutLabel = display.newText(GBCLanguageCabinet.getText("logoutLabel", _LanguageKey),-_W/1.28 + _W/7.2,NavigationVariableTable.Rect5.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.LogOutLabel.anchorX = 0
    NavigationVariableTable.LogOutLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.LogOutLabel )
    
------------------------------------------------------------- Navigation Over  --------------------------------------------------------------

end

local function waterListNetworkListener( event )
	if ( event.isError ) then
        print( "Network error!" )
        
        networkReqCount = networkReqCount + 1
        
    	native.setActivityIndicator( false )
		
		if( networkReqCount > 3 ) then
				
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
		else
			
			local url = _WebLink.."request-water.php?user_id=".._UserID.."&store_id=".._StoreID.."&table_number=".._TableNumber
			local url2 = url:gsub( " " , "%%20" )
			waterRequest = network.request( url2, "GET", waterListNetworkListener )
			native.setActivityIndicator( true )
			
		end
    else
        print ( "RESPONSE:" .. event.response )
        
        if( event.response == 0 or event.response == "0" ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Something went wrong, Please try again.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 1 or event.response == "1" ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Something went wrong, Please try again.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( event.response == 2 or event.response == "2" ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, "Something went wrong, Please try again.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == "OK" ) then
        	
        	print( "response is ok..." )
        	local alert = native.showAlert( alertLabel, "Your water request has been placed successfully.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	
        end
        
    end

	return true
end

local function handleButtonEvent( event )
	--if event.phase == "ended" then

		if event.target.id == "home" then
			if(composer.getSceneName("current") == "menu") then
			if(menuFlag == 0) then
				OverRect.isVisible = true
				VariableTable.homeBtn:toFront()
				navigationGroup.x = navigationGroup.x + _W/1.28
				displayGroup.x = displayGroup.x + _W/1.28
				menuFlag = 1
				
			elseif(menuFlag == 1) then
				OverRect.isVisible = false
				navigationGroup.x = navigationGroup.x - _W/1.28
				displayGroup.x = displayGroup.x - _W/1.28
				menuFlag = 0
			end
			end
		elseif event.target.id == "search" then
			print("search")
			VariableTable.restaurantName.isVisible = false
			VariableTable.restaurantAdd.isVisible = false
			VariableTable.searchTextField.isVisible = true
			VariableTable.searchBg.isVisible = true
			
		elseif event.target.id == "PLACE ORDER" then
			composer.gotoScene("PlaceOrder")
			
		elseif event.target.id == "WATER" then
			print( "water button is pressed......" )
			
			--[[local headers = {}
			
			headers["Content-Type"] = "application/x-www-form-urlencoded"
			headers["Accept-Language"] = "en-US"
			
			local body = "user_id=".._UserID.."&store_id=".._StoreID.."&table_number=".._TableNumber
			local params = {}
			params.headers = headers
			params.body = body
			
			local url = _WebLink.."request-water.php?"
			print( url..body )
			waterRequest = network.request( url, "POST", waterListNetworkListener, params )]]--
			
			local url = _WebLink.."request-water.php?user_id=".._UserID.."&store_id=".._StoreID.."&table_number=".._TableNumber
			local url2 = url:gsub( " " , "%%20" )
			waterRequest = network.request( url2, "GET", waterListNetworkListener )
			native.setActivityIndicator( true )
		
		elseif event.target.id == "Language" then
		
			composer.gotoScene( "LanguageList" )
			
		end
		
	--end
	return true
end

--[[local function networkListener( event )
	if ( event.isError ) then
		print( "Network error - download failed" )
		count = count + 1
		
		if count == #categoryImage then
			for i = 1, #categoryImage do
        		local imagePath = system.pathForFile( categoryName[i]..".png", system.TemporaryDirectory )
				print("Path = "..imagePath)
    			local imageFile = io.open( imagePath, "r" )
    			
    			if imageFile then
    				print(imageFile)
    				
    				defaultPhoto[i] = display.newImageRect(imageDirectory.."ProductBg.png", _W/2.04, _H/4.86)
					defaultPhoto[i].x = m*_W/3.66 + (_W/5.4*(m - 1))
        			defaultPhoto[i].y = n*_H/6.85 + (_H/6.4*(n - 1))
        			VariableTable.menuScrollView:insert( defaultPhoto[i] )
					
					image[i] = display.newImageRect(categoryName[i]..".png", system.TemporaryDirectory, defaultPhoto[i].width, defaultPhoto[i].height)
					image[i].x = defaultPhoto[i].x
					image[i].y = defaultPhoto[i].y
					--image[i].id = id[i].."/"..name[i]
					VariableTable.menuScrollView:insert( image[i] )
					image[i]:addEventListener( "tap", onGotoSubMenu )
					image[i]:toFront()
					
					nameBg[i] = display.newImageRect(imageDirectory.."ProductNameBG.png", defaultPhoto[i].width, _H/18.64)
					nameBg[i].anchorY = 1
					nameBg[i].x = defaultPhoto[i].x
        			nameBg[i].y = defaultPhoto[i].y + defaultPhoto[i].height/2
        			nameBg[i].alpha = 0.7
        			VariableTable.menuScrollView:insert( nameBg[i] )
					
					name[i] = display.newText( categoryName[i], nameBg[i].x, nameBg[i].y - nameBg[i].height/2, _FontArr[6], _H/32.47 )
    				name[i]:setFillColor( 1 )
    				VariableTable.menuScrollView:insert( name[i] )
    			end
				
				if(i%2 == 0)then
					n = n + 1
					m = 1
				else
					m = m + 1
				end
			end
			
			timer.performWithDelay( 200, function() 
			native.setActivityIndicator( false )
			end )
        end
        
    elseif ( event.phase == "began" ) then
		print( "Progress Phase: began" )
		
    elseif ( event.phase == "ended" ) then
		print( "Displaying response image file" )
		
		count = count + 1
		
		if count == #categoryImage then
			for i = 1, #categoryImage do
        		local imagePath = system.pathForFile( categoryName[i]..".png", system.TemporaryDirectory )
				print("Path = "..imagePath)
    			local imageFile = io.open( imagePath, "r" )
    			
    			if imageFile then
    				print(imageFile)
    				
    				defaultPhoto[i] = display.newImageRect(imageDirectory.."ProductBg.png", _W/2.04, _H/4.86)
					defaultPhoto[i].x = m*_W/3.98 + (_W/4.05*(m - 1))
        			defaultPhoto[i].y = n*_H/9.4 + (_H/10*(n - 1))
        			VariableTable.menuScrollView:insert( defaultPhoto[i] )
					
					image[i] = display.newImageRect(categoryName[i]..".png", system.TemporaryDirectory, defaultPhoto[i].width, defaultPhoto[i].height)
					image[i].x = defaultPhoto[i].x
					image[i].y = defaultPhoto[i].y
					--image[i].id = id[i].."/"..name[i]
					VariableTable.menuScrollView:insert( image[i] )
					--image[i]:addEventListener("tap", openImage)
					image[i]:toFront()
					
					nameBg[i] = display.newImageRect(imageDirectory.."ProductNameBG.png", defaultPhoto[i].width, _H/18.64)
					nameBg[i].anchorY = 1
					nameBg[i].x = defaultPhoto[i].x
        			nameBg[i].y = defaultPhoto[i].y + defaultPhoto[i].height/2
        			nameBg[i].alpha = 0.7
        			VariableTable.menuScrollView:insert( nameBg[i] )
					
					name[i] = display.newText( categoryName[i], nameBg[i].x, nameBg[i].y - nameBg[i].height/2, _FontArr[6], _H/32.47 )
    				name[i]:setFillColor( 1 )
    				VariableTable.menuScrollView:insert( name[i] )
    				
    			end
				
				if(i%2 == 0)then
					n = n + 1
					m = 1
				else
					m = m + 1
				end
			end
			
			timer.performWithDelay( 200, function() 
			native.setActivityIndicator( false )
			end )
        end
        
    end
end]]--
--i = 0
local function menuListNetworkListener( event )
	print("menu")
	--[[if ( event.isError ) then
        print( "Network error!" )
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		
		local alert = native.showAlert( alertLabel, NetworkErrorMsg, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
    else
        print ( "RESPONSE:" .. event.response )
        
        local _menuList = json.decode(event.response)
		
		if( _menuList == 0 ) then
        	local alert = native.showAlert( alertLabel, "All fields are mandatory.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( _menuList == 1 ) then
        	local alert = native.showAlert( alertLabel, "Store id can't be empty.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( _menuList == 2 ) then
        	local alert = native.showAlert( alertLabel, "Something went wrong, Please try again.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( _menuList == 3 ) then
        
        	VariableTable.noCategory = display.newText( "There are no categories in this store", _W/2, _H/2, _FontArr[30], _H/40 )
        	VariableTable.noCategory:setFillColor( 0 )
        	menuScrollView:insert( VariableTable.noCategory )
        	VariableTable.noCategory:toFront()
		
        else
        	]]--
        	--i = i + 1
        	for i = 1,#_menuList do
				categoryId[i] = _menuList[i].id
        		categoryName[i] = _menuList[i].category_name
        		categoryImage[i] = _menuList[i].images
        		
        		m = 1
        		n = 1
        			print(#categoryImage)
        	for i = 1, #categoryImage do
        	
        		
        		
        		local imagePath = system.pathForFile( "MainCategory".._menuList[i].id..".png", system.TemporaryDirectory )
				--print("Path = "..imagePath)
    			local imageFile = io.open( imagePath, "r" )
    				defaultPhoto[i] = display.newImageRect(imageDirectory.."ProductBg.png", _W/2.04, _H/4.86)
					defaultPhoto[i].x = m*_W/3.98 + (_W/4.05*(m - 1))
        			defaultPhoto[i].y = n*_H/9.2 + (_H/10*(n - 1))
        			defaultPhoto[i].id = categoryId[i].."//"..i
        			defaultPhoto[i]:addEventListener( "tap", onGotoSubMenu )
        			VariableTable.menuScrollView:insert( defaultPhoto[i] )
        			
        		--function callFunc()
        			
    			if imageFile then
    				print(imageFile)
    				
					image[i] = display.newImage("MainCategory".._menuList[i].id..".png", system.TemporaryDirectory)--, defaultPhoto[i].width, defaultPhoto[i].height)
					image[i].x = defaultPhoto[i].x
					image[i].y = defaultPhoto[i].y
					--image[i].id = id[i].."/"..name[i]
					image[i].width = defaultPhoto[i].height/(image[i].height/image[i].width)
					image[i].height = defaultPhoto[i].height
					
					if( image[i].width > defaultPhoto[i].width ) then
						image[i].width = defaultPhoto[i].width
					else
					
					end
					VariableTable.menuScrollView:insert( image[i] )
					
					image[i]:toFront()
				end
				
					if(_menuList[i].new_items == "YES") then
						newLabel[i] = display.newImageRect(imageDirectory.."NewLabelBg1.png", _W/6.75, _H/12.15)
						newLabel[i].x = defaultPhoto[i].x - defaultPhoto[i].width/2 
        				newLabel[i].y = defaultPhoto[i].y - defaultPhoto[i].height/2
        				newLabel[i].anchorX = 0
        				newLabel[i].anchorY = 0
        				VariableTable.menuScrollView:insert( newLabel[i] )
					end
					
					nameBg[i] = display.newImageRect(imageDirectory.."ProductNameBG.png", defaultPhoto[i].width, _H/18.64)
					nameBg[i].anchorY = 1
					nameBg[i].x = defaultPhoto[i].x
        			nameBg[i].y = defaultPhoto[i].y + defaultPhoto[i].height/2
        			nameBg[i].alpha = 0.7
        			VariableTable.menuScrollView:insert( nameBg[i] )
					
					local option = {
						text = categoryName[i],
						x = nameBg[i].x,
						y = nameBg[i].y - nameBg[i].height/2 - _H/96,
						width = _W/2.25,
						height = _H/32.47,
						font = _FontArr[6],
						fontSize =  _H/32.47,
						align = "center"
					}
					
					name[i] = display.newText( option )
					name[i].anchorY = 0
    				name[i]:setFillColor( 1 )
    				VariableTable.menuScrollView:insert( name[i] )
    			
				
				if(i%2 == 0)then
					n = n + 1
					m = 1
				else
					m = m + 1
				end
				--menuListNetworkListener()
				
				
				--end
				
				--timer.performWithDelay(200,callFunc,1)
				
			end
        	if( i == #_menuList ) then
        		
        		timer.performWithDelay( 500,function() 
        			if( #image ) then
        				if( image[i] ) then
        					image[i]:toFront()
        					nameBg[i]:toFront()
        					name[i]:toFront()
        					
        					if( newLabel[i] ) then
        					
        						newLabel[i]:toFront()
        						
        					end
        				end
        			end
        		end,1 )
        		
        		end
        	end
        	
end

local function onSearchEdit( event )
	if ( event.phase == "began" ) then
        print( event.text )
        search_productCatId = { }
        search_productData = { }
	
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( nil )
    	print( "In submitted phase..........." )
    	print( "size of product data array ::: "..#productData )
    	search_productName = event.target.text
    	
    if event.target.text == "" or event.target.text == " " or event.target.text == nil then
    	print( "empty string...." )
    	VariableTable.searchBg.isVisible = false
		VariableTable.searchTextField.isVisible = false
    	VariableTable.restaurantName.isVisible = true
		VariableTable.restaurantAdd.isVisible = true
		
    else
    	for i = 1, #productData do
    		local a = string.find(string.lower(tostring(productData[i].productDetail.item_name)),string.lower(tostring(event.target.text)))
			if a == nil then
				--print( "nothing....." )
			else
				print( "Entered text :::: "..event.target.text )
				print( "Matching text is ::::: "..productData[i].productDetail.item_name )
				table.insert( search_productCatId, productData[i].categoryID )
				table.insert( search_productData,productData[i].productDetail )
				--break
			end
		end
		--print( "loop break" )
		
		print( "size of search cat id array ::: "..#search_productCatId )
		print( "size of search product data array ::: "..#search_productData )
		composer.gotoScene( "searchProduct" )
		
	end

    elseif ( event.phase == "editing" ) then
    	print( event.text )
        
    end

	return true
end



-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    
    local Background = display.newImageRect(imageDirectory3.."Background.png",_W,_H)
    Background.x = _W/2
    Background.y = _H/2
    sceneGroup:insert(Background)
    
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
        --NewLabelBg.png
		
        print( "In menu screen........" )
        _previousScene = composer.getSceneName( "current" )
        menuFlag = 0
        networkReqCount = 0
        
        _PreviousSceneforSetting = composer.getSceneName( "current" )
        print( "previous scene name for seetings :::>>>>".._PreviousSceneforSetting )
        
        _PreviousSceneforOrder = composer.getSceneName( "current" )
    	print( "previous scene name for order :::>>>>".._PreviousSceneforOrder )
        
        navigationGroup = display.newGroup()
        sceneGroup:insert( navigationGroup )
        
        createNavigation()
        
        displayGroup = display.newGroup()
        sceneGroup:insert( displayGroup )
        displayGroup:toFront()
        
        count = 0
        
        VariableTable.bgRect = display.newRect( _W/2, _H/2, _W, _H )
        VariableTable.bgRect:setFillColor( 1, 1, 1, 0.01 )
        VariableTable.bgRect:addEventListener( "tap", onBgRect )
        displayGroup:insert( VariableTable.bgRect )
        
        VariableTable.background = display.newImageRect( imageDirectory.."Background.png", _W, _H )
        VariableTable.background.x = _W/2
        VariableTable.background.y = _H/2
        displayGroup:insert( VariableTable.background )
        
        VariableTable.header = display.newImageRect( imageDirectory.."Header.png", _W, _H/9.18 )
        VariableTable.header.x = _W/2
        VariableTable.header.y = _H/18
        displayGroup:insert( VariableTable.header )
        
        
        VariableTable.restaurantName = display.newText( _HotelName:upper(), VariableTable.header.x, VariableTable.header.y - VariableTable.header.height/2 + _H/27.42, _FontArr[6], _H/30 )
        VariableTable.restaurantName:setFillColor( 83/255, 20/255, 111/255 )
        displayGroup:insert( VariableTable.restaurantName )
        
        local option = {
        	text = tostring(_HotelAddress),
        	x = VariableTable.restaurantName.x,
        	y = VariableTable.restaurantName.y + VariableTable.restaurantName.height/2 + _H/96,
        	width = _W/2,
        	height = _H/54.85,
        	font = _FontArr[30],
        	fontSize = _H/57.66,
        	align = "center"
        }
        
        
        VariableTable.restaurantAdd = display.newText( option  )
        VariableTable.restaurantAdd:setFillColor( 83/255, 20/255, 111/255 )
        displayGroup:insert( VariableTable.restaurantAdd )
        
        VariableTable.searchBg = display.newImageRect( imageDirectory3.."Email_Bg2.png", _W/1.5, _H/13.33 )
        VariableTable.searchBg.x = _W/2
        VariableTable.searchBg.y = _H/23.13
        displayGroup:insert( VariableTable.searchBg )
        VariableTable.searchBg.isVisible = false
        --_W/2, _H/23.13, _W/1.5, _H/19.2
        VariableTable.searchTextField = native.newTextField( VariableTable.searchBg.x, VariableTable.searchBg.y, VariableTable.searchBg.width - textFieldWidth, VariableTable.searchBg.height - textFieldHeight )
        VariableTable.searchTextField.hasBackground = false
        VariableTable.searchTextField.placeholder = GBCLanguageCabinet.getText("searchByProductNameLabel",_LanguageKey)
        VariableTable.searchTextField:addEventListener( "userInput", onSearchEdit )
		VariableTable.searchTextField.font = native.newFont( _FontArr[10], _H/35 )
        displayGroup:insert( VariableTable.searchTextField )
        VariableTable.searchTextField.isVisible = false
        
        VariableTable.header2 = display.newImageRect( imageDirectory.."TabBg.png", _W, _H/20.21 )
        VariableTable.header2.x = _W/2
        VariableTable.header2.y = _H/11.85 + VariableTable.header2.height/2 + _H/96
        VariableTable.header2:setFillColor( 254/255, 246/255, 245/255 )
        displayGroup:insert( VariableTable.header2 )
        
        VariableTable.homeBtn = widget.newButton
		{
    		width = _W/13.5, --_W/16.11,
    		height = _H/24,  --_H/28.65,
    		defaultFile = imageDirectory.."Home_Btn.png",
   			overFile = imageDirectory.."Home_Btn.png",
    		id = "home",
    		--onEvent = handleButtonEvent
		}
		VariableTable.homeBtn.x = _W/29.18 + VariableTable.homeBtn.width/2
		VariableTable.homeBtn.y = _H/41.73 + VariableTable.homeBtn.height/2
		VariableTable.homeBtn:addEventListener("tap",handleButtonEvent)
		displayGroup:insert( VariableTable.homeBtn )
		
		VariableTable.searchBtn = widget.newButton
		{
    		width = _W/23.47,  --_W/27.69,
    		height = _H/24,  --_H/28.65,
    		defaultFile = imageDirectory.."Search_Btn.png",
   			overFile = imageDirectory.."Search_Btn.png",
    		id = "search",
    		--onEvent = handleButtonEvent
		}
		VariableTable.searchBtn.x = _W - _W/15.42
		VariableTable.searchBtn.y = VariableTable.header.y - _H/192
		VariableTable.searchBtn:addEventListener("tap",handleButtonEvent)
		displayGroup:insert( VariableTable.searchBtn )
		
		local buttonSize ,labelyOff
		
		if( _LanguageKey == "ar" or _LanguageKey == "zh" or _LanguageKey == "hi" or _LanguageKey == "ja" or _LanguageKey == "ko" ) then
			buttonSize = _H/40
			labelyOff = -8
		else
			buttonSize = _H/60
			labelyOff = -3
		end
		
		
		VariableTable.placeOrderBtn = widget.newButton
		{
    		width = _W/5.51,
    		height = _H/24,
    		defaultFile = "images/cartBtn2.png",
   			overFile = "images/cartBtn2.png",
   			label = GBCLanguageCabinet.getText("cartLabel",_LanguageKey),
   			labelXOffset = 20,
   			labelYOffset = labelyOff,
   			labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
   			font = _FontArr[1],
   			fontSize = buttonSize,
    		id = "PLACE ORDER",
    		--onEvent = handleButtonEvent
		}
		VariableTable.placeOrderBtn.x = _W - _W/36
		VariableTable.placeOrderBtn.y = VariableTable.header2.y
		VariableTable.placeOrderBtn.anchorX = 1
		VariableTable.placeOrderBtn:addEventListener("tap",handleButtonEvent)
		displayGroup:insert( VariableTable.placeOrderBtn )
		
		VariableTable.Language = widget.newButton
		{
    		width = _W/5.51,
    		height = _H/24,
    		defaultFile = "images/language2.png",
   			overFile = "images/language2.png",
   			label = GBCLanguageCabinet.getText("languageLabel", _LanguageKey),
   			labelYOffset = labelyOff,
   			labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
   			font = _FontArr[1],
   			fontSize = buttonSize,
    		id = "Language",
    		--onEvent = handleButtonEvent
		}
		VariableTable.Language.x = _W/36
		VariableTable.Language.y = VariableTable.header2.y
		VariableTable.Language.anchorX = 0
		VariableTable.Language:addEventListener("tap",handleButtonEvent)
		displayGroup:insert( VariableTable.Language )
		
		--[[VariableTable.waterBtn = widget.newButton
		{
    		width = _W/5.51,
    		height = _H/24,
    		defaultFile = "images/waterBtn2.png",
   			overFile = "images/waterBtn2.png",
    		label = "WATER",
   			labelXOffset = 20,
   			labelYOffset = -3,
   			labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
   			font = _FontArr[1],
   			fontSize = _H/60,
    		id = "WATER",
    		--onEvent = handleButtonEvent
		}
		VariableTable.waterBtn.x = _W/36
		VariableTable.waterBtn.y = VariableTable.header2.y
		VariableTable.waterBtn.anchorX = 0
		VariableTable.waterBtn:addEventListener("tap",handleButtonEvent)
		displayGroup:insert( VariableTable.waterBtn )]]--
		
		-- create scrollView
		
		VariableTable.menuScrollView = widget.newScrollView
		{
    		width = _W,
    		height = _H,
    		top =  VariableTable.header2.y + VariableTable.header2.height/2 + _H/384,
    		--topPadding = _H/19.2,
	 	  	bottomPadding = _H/19.2,
    		hideBackground = true,
    		scrollHeight = _H*2,
    		horizontalScrollDisabled = true
		}
		displayGroup:insert( VariableTable.menuScrollView )
		
		-- Access Google over SSL:
		
		--[[local headers = {}
		
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		
		local body = "ws=1&store_id=1"
		local params = {}
		params.headers = headers
		params.body = body
		
		local url = _WebLink.."store-categories.php?"
		print( url..body )
		network.request( url, "POST", menuListNetworkListener, params )
		native.setActivityIndicator( true )]]--
        
        
    OverRect = display.newRect(_W/2,_H/2,_W,_H)
   	OverRect:setFillColor( 0,0,0,0.01 )
   	OverRect:addEventListener("touch",onTouchNavigationOverRect)
   	sceneGroup:insert( OverRect )
    OverRect.isVisible = false
        
        
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        
        
        local function showDisplayFunc()
        
        	menuListNetworkListener()
        
        end
        
        timer.performWithDelay( 250, showDisplayFunc,1 )
        
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
         if(menuFlag == 1) then
			navigationGroup.x = navigationGroup.x - _W/1.28
			displayGroup.x = displayGroup.x - _W/1.28
			menuFlag = 0
		 end
        
        display.remove(OverRect)
        OverRect = nil
        
        beginX = nil
      	endX = nil
        
        for i = 1, #VariableTable do
        	if( VariableTable[i] ) then
        		display.remove( VariableTable[i] )
        		VariableTable[i] = nil
        	end
        end
        
        for i = 1, #NavigationVariableTable do
        	if( NavigationVariableTable[i] ) then
        		display.remove( NavigationVariableTable[i] )
        		NavigationVariableTable[i] = nil
        	end
        end
        
        
        for i = 1, #defaultPhoto do
        	display.remove( defaultPhoto[i] )
        	defaultPhoto[i] = nil
        end
        
        for i = 1, #image do
        	display.remove( image[i] )
        	image[i] = nil
        end
        
        for i = 1, #nameBg do
        	display.remove( nameBg[i] )
        	nameBg[i] = nil
        end
        
        for i = 1, #name do
        	display.remove( name[i] )
        	name[i] = nil
        end
        
        VariableTable = { }
        categoryId = { }
        categoryName = { }
        categoryImage =  { }
        defaultPhoto = { }
        image = { }
        nameBg = { }
        name = { }
        
        
        display.remove( navigationGroup )
        navigationGroup = nil
        
        display.remove( displayGroup )
        displayGroup = nil
        
        
        native.setKeyboardFocus( nil )
        
        
        
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
        if(waterRequest) then
        	network.cancel( waterRequest )
        	waterRequest = nil
        end
        
        composer.removeScene( "current" ) 
        
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