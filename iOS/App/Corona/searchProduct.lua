local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


local imageDirectory = "images/MainMenu/"
local imageDirectory2 = "images/Navigation/"
local imageDirectory3 = "images/Login/"
local imageDirectory4 = "images/SubMenu/"
local imageDirectory5 = "images/SignUp/"

local displayGroup, url2, m, n, noItem
local navigationGroup, menuFlag
local count
local waterRequest
local VariableTable = { background, header, restaurantName, restaurantAdd, homeBtn, searchBtn, searchProductScrollView,
		noCategory, CategoryTitleBg, CategoryTitle, backBg, backBtn }
		
local beginX,endX,proList_OverRect		
	
local NavigationVariableTable_pList = { "sliderBg", "logo", "HeaderBG", "ChefImage", "ProfileBg", "Rect1", "Rect2", "Rect3",
"Rect4","Rect5","Rect6","Rect7","CartIcon", "OrderIcon", "FeedBackIcon", "SettingIcon", "RestaurantIcon", "TutorialIcon",
"LogOutIcon", "ProfilePicBg", "ProfileEditLabel", "ProfileEditBg", "CartLabel", "OrderLabel", "FeedBackLabel", "SettingLabel",
"RestaurantLabel", "TutorialLabel", "LogOutLabel", "UserName", "UserEmail", "HotelAddress", "HotelName" }

local ProductId = { }
local ProductName = { }
local defaultPhoto = { }
local image = { }
local nameBg = { }
local name = { }
local ProductStatusArr = { }
local newLabel = { }



local function onDoNothing( event )
	return true
end

local function onGotoProductPage( event )
	
	print("target id"..event.target.id)
	
	_selectedProductID = event.target.id
	
	composer.gotoScene( "Product" )

	return true
end

local function OnEditProfileTap( event )
	

	return true
end

local function OnEditProfileTouch( event )
	if(event.phase == "began") then
		
	
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


function openNavigationTap( event )
	if(composer.getSceneName("current") == "ProductListPage") then
	
	 VariableTable.MenuBg:removeEventListener("tap",openNavigationTap)
    -- VariableTable.MenuBg:removeEventListener("touch",openNavigationTouch)
     
     local function addEvents( event )

	 	VariableTable.MenuBg:addEventListener("tap",openNavigationTap)
    	--VariableTable.MenuBg:addEventListener("touch",openNavigationTouch)
		return true
	end
	
	if(menuFlag == 0) then
		
		--[[navigationGroup.x = navigationGroup.x + _W/1.28
		subMenuGroup.x = subMenuGroup.x + _W/1.28]]--
		menuFlag = 1
		transition.to( navigationGroup, { time=0, x=navigationGroup.x + _W/1.28,onComplete = addEvents } )
		transition.to( productGroup, { time=0, x=productGroup.x + _W/1.28 } )
		
	elseif(menuFlag == 1) then
		
		--navigationGroup.x = navigationGroup.x - _W/1.28
		--subMenuGroup.x = subMenuGroup.x - _W/1.28
		menuFlag = 0
		transition.to( navigationGroup, { time=0, x=navigationGroup.x - _W/1.28,onComplete = addEvents  } )
		transition.to( productGroup, { time=0, x=productGroup.x - _W/1.28 } )
		
	end
	
	end
	return true
end

function openNavigationTouch( event )
	if(event.phase == "began") then
		if(composer.getSceneName("current") == "ProductListPage") then
		 VariableTable.MenuBg:removeEventListener("tap",openNavigationTap)
     	VariableTable.MenuBg:removeEventListener("touch",openNavigationTouch)
     	
     	 local function addEvents( event )

	 		VariableTable.MenuBg:addEventListener("tap",openNavigationTap)
    		VariableTable.MenuBg:addEventListener("touch",openNavigationTouch)
			return true
		end
		if(menuFlag == 0) then
	
			--navigationGroup.x = navigationGroup.x + _W/1.28
			--subMenuGroup.x = subMenuGroup.x + _W/1.28
			menuFlag = 1
			transition.to( navigationGroup, { time=1000, x=navigationGroup.x + _W/1.28,onComplete = addEvents  } )
			transition.to( productGroup, { time=1000, x=productGroup.x + _W/1.28 } )
		elseif(menuFlag == 1) then
		
			--navigationGroup.x = navigationGroup.x - _W/1.28
			--subMenuGroup.x = subMenuGroup.x - _W/1.28
			menuFlag = 0
			transition.to( navigationGroup, { time=1000, x=navigationGroup.x - _W/1.28,onComplete = addEvents } )
			transition.to( productGroup, { time=1000, x=productGroup.x - _W/1.28 } )
		end
	end
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

local function checkDirection()
	if(endX < beginX) then
		if((beginX - endX) > 10) then
			proList_OverRect.isVisible = false
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
    
    
    NavigationVariableTable_pList.sliderBg = display.newImageRect(imageDirectory2.."SliderBg.png",_W/1.17,_H/1.25)
    NavigationVariableTable_pList.sliderBg.x = -_W/1.28
    NavigationVariableTable_pList.sliderBg.y = _H
    NavigationVariableTable_pList.sliderBg.anchorX = 0 
    NavigationVariableTable_pList.sliderBg.anchorY = 1
   	navigationGroup:insert( NavigationVariableTable_pList.sliderBg )
        
    NavigationVariableTable_pList.logo = display.newImageRect("images/Wopadu_Logo.png",_W/3.66,_H/6.78)
    NavigationVariableTable_pList.logo.x = -_W/1.28 + _W/24 + NavigationVariableTable_pList.logo.width/2    
    NavigationVariableTable_pList.logo.y = _H/34.28 + NavigationVariableTable_pList.logo.height/2    
    navigationGroup:insert( NavigationVariableTable_pList.logo ) 
    
    NavigationVariableTable_pList.HeaderBG = display.newImageRect(imageDirectory2.."ShopDetailBg.png",_W/1.19,_H/9.14)
    NavigationVariableTable_pList.HeaderBG.x = -_W/1.28    
    NavigationVariableTable_pList.HeaderBG.y =  _H/5 + NavigationVariableTable_pList.HeaderBG.height/2 
    NavigationVariableTable_pList.HeaderBG.anchorX = 0 
    navigationGroup:insert( NavigationVariableTable_pList.HeaderBG ) 
    
    NavigationVariableTable_pList.ChefImage = display.newImageRect(imageDirectory2.."Chef_Icon.png",_W/10.48,_H/12.71)
    NavigationVariableTable_pList.ChefImage.x = -_W/1.28 + _W/15.88  
    NavigationVariableTable_pList.ChefImage.y =  NavigationVariableTable_pList.HeaderBG.y  
    NavigationVariableTable_pList.ChefImage.anchorX = 0 
    navigationGroup:insert( NavigationVariableTable_pList.ChefImage )
    
   
    if(_HotelName:len() > 25) then
    	HotelNameText = tostring(_HotelName:sub(1,15))..".."
    else
    	HotelNameText = _HotelName
    end
    
    if(_HotelAddress:len() > 60) then
    	HotelAddressText = tostring(_HotelAddress:sub(1,60))..".."
    else
    	HotelAddressText = _HotelAddress
    end
    
    
    NavigationVariableTable_pList.HotelName = display.newText(HotelNameText,-_W/1.28 + _W/4.9,_H/4.10,_FontArr[1],_H/36.76 )
    NavigationVariableTable_pList.HotelName.anchorX = 0
    NavigationVariableTable_pList.HotelName.anchorY = 1
    NavigationVariableTable_pList.HotelName:setTextColor( 1 )
    navigationGroup:insert( NavigationVariableTable_pList.HotelName )
    
    NavigationVariableTable_pList.HotelAddress = display.newText(HotelAddressText,-_W/1.28 + _W/4.9,_H/3.93,_W/2,0,_FontArr[30],_H/63.03 )
    NavigationVariableTable_pList.HotelAddress.anchorX = 0
    NavigationVariableTable_pList.HotelAddress.anchorY = 0
    NavigationVariableTable_pList.HotelAddress:setTextColor( 1 )
    navigationGroup:insert( NavigationVariableTable_pList.HotelAddress )
    
    
    --[[NavigationVariableTable_pList.ProfileBg = display.newImageRect(imageDirectory2.."ProfileBg.png",_W/1.19,_H/9.05)
    NavigationVariableTable_pList.ProfileBg.x = -_W/1.28  
    NavigationVariableTable_pList.ProfileBg.y =  _H/3.25 + NavigationVariableTable_pList.ProfileBg.height/2 
    NavigationVariableTable_pList.ProfileBg.anchorX = 0 
    navigationGroup:insert( NavigationVariableTable_pList.ProfileBg )
    
    NavigationVariableTable_pList.ProfilePicBg = display.newImageRect(imageDirectory2.."ProfilePicBg.png",_W/7.39,_H/13.06)
    NavigationVariableTable_pList.ProfilePicBg.x = -_W/1.28 + _W/27  
    NavigationVariableTable_pList.ProfilePicBg.y =  NavigationVariableTable_pList.ProfileBg.y
    NavigationVariableTable_pList.ProfilePicBg.anchorX = 0 
    navigationGroup:insert( NavigationVariableTable_pList.ProfilePicBg )]]--
    
    --_fName = "Krishna Maru"
   -- _UserID = "krishnamaru123@gmail.com"
    
    if(_fName:len() > 15) then
    	UserNameText = tostring(_fName:sub(1,15))..".."
    else
    	UserNameText = _fName
    end
    
    NavigationVariableTable_pList.UserName = display.newText(UserNameText,-_W/1.28 + _W/15.42,_H/2.74,_FontArr[6],_H/31.51 )
    NavigationVariableTable_pList.UserName.anchorX = 0
    NavigationVariableTable_pList.UserName.anchorY = 1
    NavigationVariableTable_pList.UserName:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable_pList.UserName )
    
    if(_UserName:len() > 25) then
    	UserMailText = tostring(_UserName:sub(1,25))..".."
    else
    	UserMailText = _UserName
    end
    
    NavigationVariableTable_pList.UserEmail = display.newText(UserMailText,-_W/1.28 + _W/15.42,_H/2.57,_FontArr[6],_H/55.15 )
    NavigationVariableTable_pList.UserEmail.anchorX = 0
    NavigationVariableTable_pList.UserEmail.anchorY = 1
    NavigationVariableTable_pList.UserEmail:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable_pList.UserEmail )
    
    NavigationVariableTable_pList.ProfileEditLabel = display.newText(GBCLanguageCabinet.getText("editProfileLabel",_LanguageKey),NavigationVariableTable_pList.sliderBg.x+ _W/1.28 - _W/108,_H/3.25  + _H/18.11,_FontArr[6],_H/45 )
    NavigationVariableTable_pList.ProfileEditLabel.anchorX = 1
    NavigationVariableTable_pList.ProfileEditLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable_pList.ProfileEditLabel )
    
    NavigationVariableTable_pList.ProfileEditBg = display.newRect(NavigationVariableTable_pList.sliderBg.x+ _W/1.28 - _W/108,NavigationVariableTable_pList.ProfileEditLabel.y - _H/192,NavigationVariableTable_pList.ProfileEditLabel.width + _W/54, NavigationVariableTable_pList.ProfileEditLabel.height + _H/96 )
    NavigationVariableTable_pList.ProfileEditBg.anchorX = 0
    NavigationVariableTable_pList.ProfileEditBg:setFillColor( 1, 1, 1, 0.1 )
    NavigationVariableTable_pList.ProfileEditBg:addEventListener("tap",OnEditProfileTap)
    NavigationVariableTable_pList.ProfileEditBg:addEventListener("touch",OnEditProfileTouch)
    navigationGroup:insert( NavigationVariableTable_pList.ProfileEditBg )
    
    NavigationVariableTable_pList.Rect1 = display.newImageRect(imageDirectory2.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable_pList.Rect1.x = -_W/1.28  
    NavigationVariableTable_pList.Rect1.y =  _H/2.4 + NavigationVariableTable_pList.Rect1.height/2 
    NavigationVariableTable_pList.Rect1.anchorX = 0 
    NavigationVariableTable_pList.Rect1.id = 1
    NavigationVariableTable_pList.Rect1:addEventListener("tap",onRectTap)
    NavigationVariableTable_pList.Rect1:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable_pList.Rect1 )
    
    NavigationVariableTable_pList.CartIcon = display.newImageRect(imageDirectory2.."Cart_Icon.png",_W/18.30,_H/48)
    NavigationVariableTable_pList.CartIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable_pList.CartIcon.y =  NavigationVariableTable_pList.Rect1.y  
    navigationGroup:insert( NavigationVariableTable_pList.CartIcon )
    
    NavigationVariableTable_pList.CartLabel = display.newText(tostring(GBCLanguageCabinet.getText("viewCartLabel",_LanguageKey)),-_W/1.28 + _W/7.2,NavigationVariableTable_pList.Rect1.y,_FontArr[6],_H/36.76)
    NavigationVariableTable_pList.CartLabel.anchorX = 0
    NavigationVariableTable_pList.CartLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable_pList.CartLabel )
    
    NavigationVariableTable_pList.Rect2 = display.newImageRect(imageDirectory2.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable_pList.Rect2.x = -_W/1.28  
    NavigationVariableTable_pList.Rect2.y =  NavigationVariableTable_pList.Rect1.y + _H/12.22 
    NavigationVariableTable_pList.Rect2.anchorX = 0 
    NavigationVariableTable_pList.Rect2.id = 2
    NavigationVariableTable_pList.Rect2:addEventListener("tap",onRectTap)
    NavigationVariableTable_pList.Rect2:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable_pList.Rect2 )
    
    NavigationVariableTable_pList.OrderIcon = display.newImageRect(imageDirectory2.."OrderHistory_Icon.png",_W/26.34,_H/32)
    NavigationVariableTable_pList.OrderIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable_pList.OrderIcon.y =  NavigationVariableTable_pList.Rect2.y  
    navigationGroup:insert( NavigationVariableTable_pList.OrderIcon )
    
    NavigationVariableTable_pList.OrderLabel = display.newText(tostring(GBCLanguageCabinet.getText("orderHistoryLabel", _LanguageKey)),-_W/1.28 + _W/7.2,NavigationVariableTable_pList.Rect2.y,_FontArr[6],_H/36.76)
    NavigationVariableTable_pList.OrderLabel.anchorX = 0
    NavigationVariableTable_pList.OrderLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable_pList.OrderLabel )
    
    NavigationVariableTable_pList.Rect3 = display.newImageRect(imageDirectory2.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable_pList.Rect3.x = -_W/1.28  
    NavigationVariableTable_pList.Rect3.y =  NavigationVariableTable_pList.Rect2.y + _H/12.22 
    NavigationVariableTable_pList.Rect3.anchorX = 0 
    NavigationVariableTable_pList.Rect3.id = 3
    NavigationVariableTable_pList.Rect3:addEventListener("tap",onRectTap)
    NavigationVariableTable_pList.Rect3:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable_pList.Rect3 )
    
    NavigationVariableTable_pList.FeedBackIcon = display.newImageRect(imageDirectory2.."FeedBack_Icon.png",_W/17.70,_H/31.47)
    NavigationVariableTable_pList.FeedBackIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable_pList.FeedBackIcon.y =  NavigationVariableTable_pList.Rect3.y  
    navigationGroup:insert( NavigationVariableTable_pList.FeedBackIcon )
    
    NavigationVariableTable_pList.FeedBackLabel = display.newText(tostring(GBCLanguageCabinet.getText("faqLabel", _LanguageKey)),-_W/1.28 + _W/7.2,NavigationVariableTable_pList.Rect3.y,_FontArr[6],_H/36.76)
    NavigationVariableTable_pList.FeedBackLabel.anchorX = 0
    NavigationVariableTable_pList.FeedBackLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable_pList.FeedBackLabel )
    
    NavigationVariableTable_pList.Rect4 = display.newImageRect(imageDirectory2.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable_pList.Rect4.x = -_W/1.28  
    NavigationVariableTable_pList.Rect4.y =  NavigationVariableTable_pList.Rect3.y + _H/12.22 
    NavigationVariableTable_pList.Rect4.anchorX = 0 
    NavigationVariableTable_pList.Rect4.id = 4
    NavigationVariableTable_pList.Rect4:addEventListener("tap",onRectTap)
    NavigationVariableTable_pList.Rect4:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable_pList.Rect4 )
    
    NavigationVariableTable_pList.SettingIcon = display.newImageRect(imageDirectory2.."Setting_Icon.png",_W/17.41,_H/30.96)
    NavigationVariableTable_pList.SettingIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable_pList.SettingIcon.y =  NavigationVariableTable_pList.Rect4.y  
    navigationGroup:insert( NavigationVariableTable_pList.SettingIcon )
    
    NavigationVariableTable_pList.SettingLabel = display.newText(tostring(GBCLanguageCabinet.getText("settingLabel", _LanguageKey)),-_W/1.28 + _W/7.2,NavigationVariableTable_pList.Rect4.y,_FontArr[6],_H/36.76)
    NavigationVariableTable_pList.SettingLabel.anchorX = 0
    NavigationVariableTable_pList.SettingLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable_pList.SettingLabel )
    
    NavigationVariableTable_pList.Rect6 = display.newImageRect(imageDirectory2.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable_pList.Rect6.x = -_W/1.28  
    NavigationVariableTable_pList.Rect6.y =  NavigationVariableTable_pList.Rect4.y + _H/12.22 
    NavigationVariableTable_pList.Rect6.anchorX = 0 
    NavigationVariableTable_pList.Rect6.id = 6
    NavigationVariableTable_pList.Rect6:addEventListener("tap",onRectTap)
    NavigationVariableTable_pList.Rect6:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable_pList.Rect6 )
    
    NavigationVariableTable_pList.RestaurantIcon = display.newImageRect(imageDirectory2.."restaurant_Icon.png",_W/17.41,_H/30.96)
    NavigationVariableTable_pList.RestaurantIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable_pList.RestaurantIcon.y =  NavigationVariableTable_pList.Rect6.y  
    navigationGroup:insert( NavigationVariableTable_pList.RestaurantIcon )
    
    NavigationVariableTable_pList.RestaurantLabel = display.newText(tostring(GBCLanguageCabinet.getText("restaurantLabel", _LanguageKey)),-_W/1.28 + _W/7.2,NavigationVariableTable_pList.Rect6.y,_FontArr[6],_H/36.76)
    NavigationVariableTable_pList.RestaurantLabel.anchorX = 0
    NavigationVariableTable_pList.RestaurantLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable_pList.RestaurantLabel )
    
    NavigationVariableTable_pList.Rect7 = display.newImageRect(imageDirectory2.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable_pList.Rect7.x = -_W/1.28  
    NavigationVariableTable_pList.Rect7.y =  NavigationVariableTable_pList.Rect6.y + _H/12.22 
    NavigationVariableTable_pList.Rect7.anchorX = 0 
    NavigationVariableTable_pList.Rect7.id = 7
    NavigationVariableTable_pList.Rect7:addEventListener("tap",onRectTap)
    NavigationVariableTable_pList.Rect7:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable_pList.Rect7 )
    
    NavigationVariableTable_pList.TutorialIcon = display.newImageRect(imageDirectory2.."tutorial_Icon.png",_W/17.41,_H/30.96)
    NavigationVariableTable_pList.TutorialIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable_pList.TutorialIcon.y =  NavigationVariableTable_pList.Rect7.y  
    navigationGroup:insert( NavigationVariableTable_pList.TutorialIcon )
    
    NavigationVariableTable_pList.TutorialLabel = display.newText(tostring(GBCLanguageCabinet.getText("tutorialLabel", _LanguageKey)),-_W/1.28 + _W/7.2,NavigationVariableTable_pList.Rect7.y,_FontArr[6],_H/36.76)
    NavigationVariableTable_pList.TutorialLabel.anchorX = 0
    NavigationVariableTable_pList.TutorialLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable_pList.TutorialLabel )
    
    NavigationVariableTable_pList.Rect5 = display.newImageRect(imageDirectory2.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable_pList.Rect5.x = -_W/1.28  
    NavigationVariableTable_pList.Rect5.y =  NavigationVariableTable_pList.Rect7.y + _H/12.22 
    NavigationVariableTable_pList.Rect5.anchorX = 0 
    NavigationVariableTable_pList.Rect5.id = 5
    NavigationVariableTable_pList.Rect5:addEventListener("tap",onRectTap)
    NavigationVariableTable_pList.Rect5:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable_pList.Rect5 )
    
    NavigationVariableTable_pList.LogOutIcon = display.newImageRect(imageDirectory2.."LogOut_Icon.png",_W/17.70,_H/38.4)
    NavigationVariableTable_pList.LogOutIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable_pList.LogOutIcon.y =  NavigationVariableTable_pList.Rect5.y  
    navigationGroup:insert( NavigationVariableTable_pList.LogOutIcon )
    
    NavigationVariableTable_pList.LogOutLabel = display.newText(tostring(GBCLanguageCabinet.getText("logoutLabel", _LanguageKey)),-_W/1.28 + _W/7.2,NavigationVariableTable_pList.Rect5.y,_FontArr[6],_H/36.76)
    NavigationVariableTable_pList.LogOutLabel.anchorX = 0
    NavigationVariableTable_pList.LogOutLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable_pList.LogOutLabel )
        
------------------------------------------------------------- Navigation Over  --------------------------------------------------------------

end

local function waterListNetworkListener( event )
	if ( event.isError ) then
        print( "Network error!" )
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		
		local alert = native.showAlert( alertLabel, NetworkErrorMsg, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
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
			if(composer.getSceneName("current") == "searchProduct") then
				print(event.target.id)
				print( composer.getSceneName("current") )
				print( "menu flag is ::: >>>>> "..menuFlag )
			if(menuFlag == 0) then
				proList_OverRect.isVisible = true
				navigationGroup.x = navigationGroup.x + _W/1.28
				displayGroup.x = displayGroup.x + _W/1.28
				menuFlag = 1
			elseif(menuFlag == 1) then
				proList_OverRect.isVisible = false
				navigationGroup.x = navigationGroup.x - _W/1.28
				displayGroup.x = displayGroup.x - _W/1.28
				menuFlag = 0
			end
			
			end
					
		elseif event.target.id == "PLACE ORDER" then
			print("gooooo")
			composer.gotoScene("PlaceOrder")
			
		elseif event.target.id == "WATER" then
			print( "water button is pressed......" )
			
			local headers = {}
			
			headers["Content-Type"] = "application/x-www-form-urlencoded"
			headers["Accept-Language"] = "en-US"
			
			local body = "user_id=".._UserID.."&store_id=1"
			local params = {}
			params.headers = headers
			params.body = body
			
			local url = _WebLink.."request-water.php?"
			print( url..body )
			waterRequest = network.request( url, "POST", waterListNetworkListener, params )
			native.setActivityIndicator( true )
			
		elseif event.target.id == "Language" then
			
			composer.gotoScene( "LanguageList" )
			
		end
		
	--end
	return true
end

local function menuListNetworkListener( event )
	
        	for i = 1,#search_productData do
				ProductId[i] = search_productData[i].id
        		ProductName[i] = search_productData[i].item_name
        		ProductStatusArr[i] = search_productData[i].is_new
        		
        		print( "^^^^^^^^^^"..ProductStatusArr[i] )
        		
        		m = 1
        		n = 1
        			
        	for i = 1, #search_productData do
        		local imagePath = system.pathForFile( "Product"..tostring(ProductId[i])..".png", system.TemporaryDirectory )
    			local imageFile = io.open( imagePath, "r" )
    			
    				defaultPhoto[i] = display.newImageRect(imageDirectory.."ProductBg.png", _W/2.04, _H/4.86)
					defaultPhoto[i].x = m*_W/3.98 + (_W/4.05*(m - 1))
        			defaultPhoto[i].y = n*_H/9.2 + (_H/10*(n - 1))
        			defaultPhoto[i].id = ProductId[i]
        			defaultPhoto[i]:addEventListener( "tap", onGotoProductPage )
        			VariableTable.searchProductScrollView:insert( defaultPhoto[i] )
    			
    			if imageFile then
    				print(imageFile)
    				
					image[i] = display.newImageRect( "Product"..ProductId[i]..".png", system.TemporaryDirectory, defaultPhoto[i].width, defaultPhoto[i].height)
					image[i].x = defaultPhoto[i].x
					image[i].y = defaultPhoto[i].y
					--image[i].id = id[i].."/"..name[i]
					image[i].id = ProductId[i]
					VariableTable.searchProductScrollView:insert( image[i] )
					
					image[i]:toFront()
					
				end
					print(tostring(ProductStatusArr[i]))
					if(tostring(ProductStatusArr[i]) == "1" ) then
						newLabel[i] = display.newImageRect(imageDirectory.."NewLabelBg1.png", _W/6.75, _H/12.15)
						newLabel[i].x = defaultPhoto[i].x - defaultPhoto[i].width/2 
        				newLabel[i].y = defaultPhoto[i].y - defaultPhoto[i].height/2
        				newLabel[i].anchorX = 0
        				newLabel[i].anchorY = 0
        				VariableTable.searchProductScrollView:insert( newLabel[i] )
					end
					
					nameBg[i] = display.newImageRect(imageDirectory.."ProductNameBG.png", defaultPhoto[i].width, _H/18.64)
					nameBg[i].anchorY = 1
					nameBg[i].x = defaultPhoto[i].x
        			nameBg[i].y = defaultPhoto[i].y + defaultPhoto[i].height/2
        			nameBg[i].alpha = 0.7
        			VariableTable.searchProductScrollView:insert( nameBg[i] )
					
					local nameValue
					
					if(tostring(ProductName[i]):len() > 20) then
						nameValue = tostring(ProductName[i]):sub(1,20)..".."
					else	
						nameValue = tostring(ProductName[i])
					end
					
					name[i] = display.newText( nameValue, nameBg[i].x, nameBg[i].y - nameBg[i].height/2, _FontArr[6], _H/32.47 )
    				name[i]:setFillColor( 1 )
    				VariableTable.searchProductScrollView:insert( name[i] )
    			
				
				if(i%2 == 0)then
					n = n + 1
					m = 1
				else
					m = m + 1
				end
			end
        		VariableTable.searchProductScrollView:setScrollHeight( (((#defaultPhoto/2) * defaultPhoto[1].height) + ((#defaultPhoto/2)* _H/96) + _W/2 ))
        	end
        	
        
        
end

local function handleBackButtonEvent( event )
	
	if(_previousScene == "SubMenu3") then
		composer.gotoScene("SubMenu3")
	else
		print("back to main menu")
		composer.gotoScene("menu")
	end
	return true
end

local function handleBackButtonEventTouch( event )
	if event.phase == "ended" then
		
		if(_previousScene == "SubMenu3") then
			composer.gotoScene("SubMenu3")
		else
			print("back to main menu")
			composer.gotoScene("menu")
		end
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
        
		
         print("In searchProduct page..........")
        
        menuFlag = 0
       	
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
        
        VariableTable.restaurantAdd = display.newText( option )
        VariableTable.restaurantAdd:setFillColor( 83/255, 20/255, 111/255 )
        displayGroup:insert( VariableTable.restaurantAdd )
        
        VariableTable.header2 = display.newImageRect( imageDirectory.."TabBg.png", _W, _H/20.21 )
        VariableTable.header2.x = _W/2
        VariableTable.header2.y = _H/11.85 + VariableTable.header2.height/2 + _H/96
        VariableTable.header2:setFillColor( 254/255, 246/255, 245/255 )
        displayGroup:insert( VariableTable.header2 )
        
        
        VariableTable.homeBtn = widget.newButton
		{
    		width = _W/13.5,
    		height = _H/24,
    		defaultFile = imageDirectory.."Home_Btn.png",
   			overFile = imageDirectory.."Home_Btn.png",
    		id = "home",
    		--onEvent = handleButtonEvent
		}
		VariableTable.homeBtn.x = _W/29.18 + VariableTable.homeBtn.width/2
		VariableTable.homeBtn.y = _H/41.73 + VariableTable.homeBtn.height/2
		VariableTable.homeBtn:addEventListener( "tap", handleButtonEvent )
		displayGroup:insert( VariableTable.homeBtn )
		--[[
		VariableTable.searchBtn = widget.newButton
		{
    		width = _W/23.47,
    		height = _H/24,
    		defaultFile = imageDirectory.."Search_Btn.png",
   			overFile = imageDirectory.."Search_Btn.png",
    		id = "search",
    		--onEvent = handleButtonEvent
		}
		VariableTable.searchBtn.x = _W - _W/15.42
		VariableTable.searchBtn.y = VariableTable.header.y - _H/192
		VariableTable.searchBtn:addEventListener( "tap", handleButtonEvent )
		displayGroup:insert( VariableTable.searchBtn )
		]]--
		
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
		VariableTable.placeOrderBtn:addEventListener( "tap", handleButtonEvent )
		displayGroup:insert( VariableTable.placeOrderBtn )
		
		VariableTable.Language = widget.newButton
		{
    		width = _W/5.51,
    		height = _H/24,
    		defaultFile = "images/language2.png",
   			overFile = "images/language2.png",
   			label = tostring(GBCLanguageCabinet.getText("languageLabel", _LanguageKey)),
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
		VariableTable.waterBtn:addEventListener( "tap", handleButtonEvent )
		displayGroup:insert( VariableTable.waterBtn )]]--
		
		VariableTable.CategoryTitleBg = display.newImageRect( imageDirectory4.."TitleBg.png", _W, _H/14.22 )
        VariableTable.CategoryTitleBg.x = _W/2
        VariableTable.CategoryTitleBg.y = VariableTable.header2.y + VariableTable.header2.height/2 + VariableTable.CategoryTitleBg.height/2 + _H/960
        displayGroup:insert( VariableTable.CategoryTitleBg )
        
        VariableTable.CategoryTitle = display.newText( tostring(search_productName), _W/6.75, VariableTable.CategoryTitleBg.y , _FontArr[6], _H/30 )
        VariableTable.CategoryTitle:setFillColor( 1 )
        VariableTable.CategoryTitle.anchorX = 0
        displayGroup:insert( VariableTable.CategoryTitle )
        
        --[[
        VariableTable.backBtn = display.newImageRect( imageDirectory5.."Back_Btn.png", _W/15.42, _H/33.10 )
     	VariableTable.backBtn.x = _W/36 + VariableTable.backBtn.width/2
     	VariableTable.backBtn.y = VariableTable.CategoryTitleBg.y
     	displayGroup:insert( VariableTable.backBtn )
       			
		VariableTable.backBg = display.newRect( VariableTable.backBtn.x, VariableTable.backBtn.y, VariableTable.backBtn.width + _W/21.6, VariableTable.backBtn.height + _H/38.4 )
		VariableTable.backBg:setFillColor( 83/255, 20/255, 111/255 , 0.01 )
	 	VariableTable.backBg:addEventListener( "tap", handleBackButtonEvent )
	 	VariableTable.backBg:addEventListener( "touch", handleBackButtonEventTouch )
	 	displayGroup:insert( VariableTable.backBg )
	 	VariableTable.backBtn:toFront()
	 	]]--
       
		VariableTable.backBtn = widget.newButton
		{
    		width = _W/9 , --_W/15.42,
    		height = _H/14.76 , --_H/33.10,
    		defaultFile = imageDirectory5.."Back_Btn1.png",
   			overFile = imageDirectory5.."Back_Btn1.png",
    		id = "back",
    		--[[label = "Back",
    		labelColor = { default={ 1, 1, 1 }, over={ 1,1,1 } },
    		fontSize = _H/35,
    		font = _FontArr[6],
    		labelYOffset = _H/275,
    		labelXOffset = 18,]]--
    		--onEvent = handleButtonEvent
		}
		VariableTable.backBtn.x = _W/36 + VariableTable.backBtn.width/2
		VariableTable.backBtn.y = VariableTable.CategoryTitleBg.y
		VariableTable.backBtn:addEventListener( "tap", handleBackButtonEvent )
		displayGroup:insert( VariableTable.backBtn )
		
		-- create scrollView
		
		VariableTable.searchProductScrollView = widget.newScrollView
		{
    		width = _W,
    		height = _H,
    		top = VariableTable.CategoryTitleBg.y + VariableTable.CategoryTitleBg.height/2,
    		--topPadding = _H/19.2,
	 	  	bottomPadding = _H/19.2,
    		hideBackground = true,
    		scrollHeight = _H*2,
    		horizontalScrollDisabled = true,
    		
		}
		displayGroup:insert( VariableTable.searchProductScrollView )
		
		-- Access Google over SSL:
         
       	if(#search_productData > 0) then
       	 print("Product available")
        	for i = 1, #search_productData do
        		if noItem then
        			display.remove( noItem )
        			noItem = nil
        		end
	        end
	        
	        menuListNetworkListener()
	        
        else
        	print("no product available")
        	noItem = display.newText( GBCLanguageCabinet.getText("noItemLabel",_LanguageKey), _W/2, _H/2, _FontArr[26], _H/35 )
        	noItem:setTextColor( 57/255 ,9/255 ,78/255  )
        	sceneGroup:insert(noItem)
        	noItem:toFront()
        	
        end
       
        proList_OverRect = display.newRect(_W/2,_H/2,_W,_H)
   		proList_OverRect:setFillColor( 0,0,0,0.01 )
   		proList_OverRect:addEventListener("touch",onTouchNavigationOverRect)
   		sceneGroup:insert( proList_OverRect )
    	proList_OverRect.isVisible = false
        
        
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
        if(menuFlag == 1) then
			navigationGroup.x = navigationGroup.x - _W/1.28
			displayGroup.x = displayGroup.x - _W/1.28
			menuFlag = 0
		end
        
        display.remove(proList_OverRect)
        proList_OverRect = nil
        
        beginX = nil
        endX = nil
        
        if(noItem) then
        	display.remove(noItem)
        	noItem = nil
        end
        
        for i = 1, #VariableTable do
        	display.remove( VariableTable[i] )
        	VariableTable[i] = nil
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
        
        for i = 1, #newLabel do
        	display.remove( newLabel[i] )
        	newLabel[i] = nil
        end
        
        VariableTable = { }
        ProductId = { }
        ProductName = { }
        ProductStatusArr = { }
        defaultPhoto = { }
        newLabel = { }
        image = { }
        nameBg = { }
        name = { }
        
        display.remove( displayGroup )
        displayGroup = nil
        
      
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        if(waterRequest) then
        	network.cancel( waterRequest )
        	waterRequest = nil
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