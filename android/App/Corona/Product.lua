local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------
local selectedProductDetails = { }

local imageDirectory = "images/Navigation/"
local imageDirectory2 = "images/SubMenu/"
local imageDirectory3 = "images/SignUp/"
local imageDirectory4 = "images/Product/"
local height = 0
local ShowArrowFlag

local navigationGroup,productGroup,headerGroup, homeBtn, subMenuGroup,menuFlag, scrollView, param, Background,selectedProductDetails, yPos, total
local downArrow, upArrow, sawAllOptionFlag,yPosScrollView,displayImageTimer
local downTrans1,downTrans2,upTrans1,upTrans2

local p_NavigationVariableTable = { "sliderBg", "logo", "HeaderBG", "ChefImage", "ProfileBg", "Rect1", "Rect2", "Rect3",
"Rect4","Rect5","Rect6", "Rect7", "CartIcon", "OrderIcon", "FeedBackIcon", "SettingIcon", "RestaurantIcon", "TutorialIcon",
"LogOutIcon", "ProfilePicBg", "ProfileEditLabel", "ProfileEditBg", "CartLabel", "OrderLabel", "FeedBackLabel", "SettingLabel",
"RestaurantLabel", "TutorialLabel", "LogOutLabel", "UserName", "UserEmail", "HotelAddress", "HotelName", "MenuProductImage" }

local VariableTable = { "HeaderBg", "MenuBtn", "Bg", "restaurantName", "restaurantAdd", "MenuTitle", "MenuTitleBg", "backBtn", "backBg" ,
"IncrementIcon", "DecrementIcon", "QuantityLabel", "ProductImage", "NoteBg", "NoteTextBox","BottomBg", "AddToCartBtn", "AddToCartBtn2",
"ProductDescriBG", "ProductDescriLabel", "ProductDescri", "OrderBtn", "productDetailsScrollView", "backRect", "NoteTextLabel" } 
 
local addOnsRow = { }
local addOnsTitle = { }
local addOnsCheckBtnSelected = { }
local addOnsCheckBtnUnSelected = { }
local addOnsPrice = { }
local extraItemsArr = { }
local addOnsScrollView = { }
local originalProductPrice,selected_variety_id,selected_variety_name,selected_variety_price,actualPrice
local product_OverRect,beginX,endX
local newLabel


local function onDoNothing( event )

	return true
end

local function countTotal(  )
	if(composer.getSceneName("current") == "Product") then
	roundDigit(actualPrice)
	total = 0
	total = tonumber(VariableTable.QuantityLabel.text) * tonumber(digValue3)
	if(tonumber(selectedProductDetails.no_of_option) > 0) then
		if(#selectedProductDetails.options > 0) then
			for i = 1, #selectedProductDetails.options do
				if #selectedProductDetails.options[i].options > 0 then
					for k = 1, #selectedProductDetails.options[i].options do
						if(addOnsCheckBtnSelected[i][k].isVisible == true) then
							roundDigit(selectedProductDetails.options[i].options[k].sub_amount)
							total = total + (tonumber(digValue3) * tonumber(VariableTable.QuantityLabel.text))
						else
							
						end
					end
				end
			end
		else
			
		end
	end	
	
	if( sawAllOptionFlag == true ) then
		
		VariableTable.AddToCartBtn.isVisible = false
		VariableTable.AddToCartBtn2.isVisible = true
		VariableTable.AddToCartBtn2:setLabel( "$"..make2Digit(total).." "..GBCLanguageCabinet.getText("AddToCartLabel",_LanguageKey) )
		
	else
		
		VariableTable.AddToCartBtn.isVisible = true
		VariableTable.AddToCartBtn2.isVisible = false
		VariableTable.AddToCartBtn.text = "Price : $"..make2Digit(total)
		
	end
	
	
	end
	return true
end

local function onGotoCartPage( event )
	if event.action == "clicked" then
        local i = event.index
        if i == 2 then
            composer.gotoScene("menu")
        elseif i == 1 then
            composer.gotoScene("PlaceOrder")
        end
    end
	return true
end

local function handleAddToCartButtonEvent( event )
	if( event.phase == "ended" ) then
		if #_CartArray > 0 then
			for i = 1,#_CartArray do
				if( _CartArray[i].productID == _selectedProductID ) then
					if(_CartArray[i].variety_id == selected_variety_id) then
						if(#_CartArray[i].extraItems > 0) then
							for m = 1,#_CartArray[i].extraItems do
								flag = 0
								for n = 1,#extraItemsArr do
									if(_CartArray[i].extraItems[m].item_option_sub_id == extraItemsArr[n].item_option_sub_id) then
										flag = 1
										local q
										if _EditFlag == false then
											q = tonumber(VariableTable.QuantityLabel.text) + _CartArray[i].quantity
										else
											q = tonumber(VariableTable.QuantityLabel.text)
										end
										_CartArray[i] = { kitchenID = selectedProductDetails.kitchen_id,title = selectedProductDetails.item_name ,productID = _selectedProductID,price = actualPrice,discount = discountValue,variety_id = selected_variety_id, variety_name = selected_variety_name, variety_price = selected_variety_price, quantity = q, extraItems = extraItemsArr, Note = noteTextBoxValue}
										break
									else
										flag = 0
									end
								end
								if flag == 1 then
									break
								end
							end
							if(flag == 0) then
								if _EditFlag == true then
									_CartArray[i] = { kitchenID = selectedProductDetails.kitchen_id,title = selectedProductDetails.item_name ,productID = _selectedProductID,price = actualPrice,discount = discountValue,variety_id = selected_variety_id, variety_name = selected_variety_name, variety_price = selected_variety_price, quantity = VariableTable.QuantityLabel.text, extraItems = extraItemsArr, Note = noteTextBoxValue}
									break
								else
									_CartArray[#_CartArray+1] = { kitchenID = selectedProductDetails.kitchen_id,title = selectedProductDetails.item_name ,productID = _selectedProductID,price = actualPrice,discount = discountValue,variety_id = selected_variety_id, variety_name = selected_variety_name, variety_price = selected_variety_price, quantity = VariableTable.QuantityLabel.text, extraItems = extraItemsArr, Note = noteTextBoxValue}
									break
								end
							else
								break
							end
						else
							local q
							if _EditFlag == false then
								q = tonumber(VariableTable.QuantityLabel.text) + _CartArray[i].quantity
							else
								q = tonumber(VariableTable.QuantityLabel.text)
							end
							_CartArray[i] = { kitchenID = selectedProductDetails.kitchen_id,title = selectedProductDetails.item_name ,productID = _selectedProductID,price = actualPrice,discount = discountValue,variety_id = selected_variety_id, variety_name = selected_variety_name, variety_price = selected_variety_price, quantity = q, extraItems = extraItemsArr, Note = noteTextBoxValue}
							break
						end
					else
						if _EditFlag == false then
							_CartArray[#_CartArray+1] = { kitchenID = selectedProductDetails.kitchen_id,title = selectedProductDetails.item_name ,productID = _selectedProductID,price = actualPrice,discount = discountValue,variety_id = selected_variety_id, variety_name = selected_variety_name, variety_price = selected_variety_price, quantity = VariableTable.QuantityLabel.text, extraItems = extraItemsArr, Note = noteTextBoxValue}
						else
							_CartArray[i] = { kitchenID = selectedProductDetails.kitchen_id,title = selectedProductDetails.item_name ,productID = _selectedProductID,price = actualPrice,discount = discountValue,variety_id = selected_variety_id, variety_name = selected_variety_name, variety_price = selected_variety_price, quantity = VariableTable.QuantityLabel.text, extraItems = extraItemsArr, Note = noteTextBoxValue}
						end
						break
					end
				else
					if _EditFlag == false then
						_CartArray[#_CartArray+1] = { kitchenID = selectedProductDetails.kitchen_id,title = selectedProductDetails.item_name ,productID = _selectedProductID,price = actualPrice,discount = discountValue,variety_id = selected_variety_id, variety_name = selected_variety_name, variety_price = selected_variety_price, quantity = VariableTable.QuantityLabel.text, extraItems = extraItemsArr, Note = noteTextBoxValue}
						break
					else
						
					end
				end
			end
		else
			discountValue = 0
			if(VariableTable.NoteTextBox) then
				noteTextBoxValue = VariableTable.NoteTextBox.text
			else
				noteTextBoxValue = ""
			end
			_CartArray[#_CartArray+1] = { kitchenID = selectedProductDetails.kitchen_id,title = selectedProductDetails.item_name ,productID = _selectedProductID,price = actualPrice,discount = discountValue,variety_id = selected_variety_id, variety_name = selected_variety_name, variety_price = selected_variety_price, quantity = VariableTable.QuantityLabel.text, extraItems = extraItemsArr, Note = noteTextBoxValue}
		end
		
		local alert = native.showAlert( "Order added", GBCLanguageCabinet.getText("9Alert",_LanguageKey), { "NO" ,"YES"}, onGotoCartPage )
		
	end
	return true
end

local function onShowTextBox( event )
		
		native.setKeyboardFocus( VariableTable.NoteTextBox )
		VariableTable.NoteTextBox.isVisible = true
		VariableTable.NoteTextBox.isEditable = true
		VariableTable.NoteTextLabel.isVisible = false
		
	return true
end

local function inputListener( event )
    if event.phase == "began" then
        yPosScrollView = VariableTable.productNewScrollView.y 
		VariableTable.productNewScrollView.y = VariableTable.productNewScrollView.y - _H/4
    elseif event.phase == "ended" or event.phase == "submitted" then
        VariableTable.productNewScrollView.y = yPosScrollView
        native.setKeyboardFocus( nil )
        VariableTable.NoteTextBox.isVisible = false
		VariableTable.NoteTextBox.isEditable = false
		VariableTable.NoteTextLabel.text = VariableTable.NoteTextBox.text
		VariableTable.NoteTextLabel.isVisible = true
		
		if(VariableTable.NoteTextLabel.text == "") then
		
			VariableTable.NoteTextLabel.text = GBCLanguageCabinet.getText("addNotesLabel",_LanguageKey)
		end
		
    elseif event.phase == "editing" then
        
    end
end

local function handleBackButtonEvent( event )
	
	if(composer.getSceneName("current") == "Product") then
	if(composer.getSceneName( "previous" ) == "ProductListPage") then
		composer.gotoScene( "ProductListPage" )
	else
		composer.gotoScene( _previousScene )
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
		composer.gotoScene( "RestaurantsList" )
		
	elseif(event.target.id == 7) then
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
			composer.gotoScene( "RestaurantsList" )
			
		elseif(event.target.id == 7) then
			composer.gotoScene( "tutorial" )
			
		end
	end
	
	return true
end

local function checkDirection()
	if(endX < beginX) then
		if((beginX - endX) > 10) then
			product_OverRect.isVisible = false
			navigationGroup.x = navigationGroup.x - _W/1.28
			productGroup.x = productGroup.x - _W/1.28
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
    
    
    p_NavigationVariableTable.sliderBg = display.newImageRect(imageDirectory.."SliderBg.png",_W/1.17,_H/1.25)
    p_NavigationVariableTable.sliderBg.x = -_W/1.28
    p_NavigationVariableTable.sliderBg.y = _H
    p_NavigationVariableTable.sliderBg.anchorX = 0 
    p_NavigationVariableTable.sliderBg.anchorY = 1
   	navigationGroup:insert( p_NavigationVariableTable.sliderBg )
        
    p_NavigationVariableTable.logo = display.newImageRect("images/Wopadu_Logo.png",_W/3.66,_H/6.78)
    p_NavigationVariableTable.logo.x = -_W/1.28 + _W/24 + p_NavigationVariableTable.logo.width/2    
    p_NavigationVariableTable.logo.y = _H/34.28 + p_NavigationVariableTable.logo.height/2    
    navigationGroup:insert( p_NavigationVariableTable.logo ) 
    
    p_NavigationVariableTable.HeaderBG = display.newImageRect(imageDirectory.."ShopDetailBg.png",_W/1.19,_H/9.14)
    p_NavigationVariableTable.HeaderBG.x = -_W/1.28    
    p_NavigationVariableTable.HeaderBG.y =  _H/5 + p_NavigationVariableTable.HeaderBG.height/2 
    p_NavigationVariableTable.HeaderBG.anchorX = 0 
    navigationGroup:insert( p_NavigationVariableTable.HeaderBG ) 
    
    p_NavigationVariableTable.ChefImage = display.newImageRect(imageDirectory.."Chef_Icon.png",_W/10.48,_H/12.71)
    p_NavigationVariableTable.ChefImage.x = -_W/1.28 + _W/15.88  
    p_NavigationVariableTable.ChefImage.y =  p_NavigationVariableTable.HeaderBG.y  
    p_NavigationVariableTable.ChefImage.anchorX = 0 
    navigationGroup:insert( p_NavigationVariableTable.ChefImage )
    
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
    
    
    p_NavigationVariableTable.HotelName = display.newText(HotelNameText,-_W/1.28 + _W/4.9,_H/4.10,_FontArr[1],_H/36.76 )
    p_NavigationVariableTable.HotelName.anchorX = 0
    p_NavigationVariableTable.HotelName.anchorY = 1
    p_NavigationVariableTable.HotelName:setTextColor( 1 )
    navigationGroup:insert( p_NavigationVariableTable.HotelName )
    
    p_NavigationVariableTable.HotelAddress = display.newText(HotelAddressText,-_W/1.28 + _W/4.9,_H/3.93,_W/2,0,_FontArr[30],_H/63.03 )
    p_NavigationVariableTable.HotelAddress.anchorX = 0
    p_NavigationVariableTable.HotelAddress.anchorY = 0
    p_NavigationVariableTable.HotelAddress:setTextColor( 1 )
    navigationGroup:insert( p_NavigationVariableTable.HotelAddress )
    
    if(_fName:len() > 15) then
    	UserNameText = tostring(_fName:sub(1,15))..".."
    else
    	UserNameText = _fName
    end
    
    p_NavigationVariableTable.UserName = display.newText(UserNameText,-_W/1.28 + _W/15.42,_H/2.74,_FontArr[6],_H/31.51 )
    p_NavigationVariableTable.UserName.anchorX = 0
    p_NavigationVariableTable.UserName.anchorY = 1
    p_NavigationVariableTable.UserName:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( p_NavigationVariableTable.UserName )
    
    if(_UserName:len() > 25) then
    	UserMailText = tostring(_UserName:sub(1,25))..".."
    else
    	UserMailText = _UserName
    end
    
    p_NavigationVariableTable.UserEmail = display.newText(UserMailText,-_W/1.28 + _W/15.42,_H/2.57,_FontArr[6],_H/45 )
    p_NavigationVariableTable.UserEmail.anchorX = 0
    p_NavigationVariableTable.UserEmail.anchorY = 1
    p_NavigationVariableTable.UserEmail:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( p_NavigationVariableTable.UserEmail )
    
    p_NavigationVariableTable.ProfileEditLabel = display.newText(GBCLanguageCabinet.getText("editProfileLabel",_LanguageKey),p_NavigationVariableTable.sliderBg.x+ _W/1.28 - _W/108,_H/3.25  + _H/18.11,_FontArr[6],_H/45 )
    p_NavigationVariableTable.ProfileEditLabel.anchorX = 1
    p_NavigationVariableTable.ProfileEditLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( p_NavigationVariableTable.ProfileEditLabel )
    
    p_NavigationVariableTable.ProfileEditBg = display.newRect(p_NavigationVariableTable.sliderBg.x+ _W/1.28 - _W/108,p_NavigationVariableTable.ProfileEditLabel.y - _H/192,p_NavigationVariableTable.ProfileEditLabel.width + _W/54, p_NavigationVariableTable.ProfileEditLabel.height + _H/96 )
    p_NavigationVariableTable.ProfileEditBg.anchorX = 1
    p_NavigationVariableTable.ProfileEditBg:setFillColor( 1, 1, 1, 0.1 )
    p_NavigationVariableTable.ProfileEditBg:addEventListener("tap",OnEditProfileTap)
    p_NavigationVariableTable.ProfileEditBg:addEventListener("touch",OnEditProfileTouch)
    navigationGroup:insert( p_NavigationVariableTable.ProfileEditBg )
    
    p_NavigationVariableTable.Rect1 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    p_NavigationVariableTable.Rect1.x = -_W/1.28  
    p_NavigationVariableTable.Rect1.y =  _H/2.4 + p_NavigationVariableTable.Rect1.height/2 
    p_NavigationVariableTable.Rect1.anchorX = 0 
    p_NavigationVariableTable.Rect1.id = 1
    p_NavigationVariableTable.Rect1:addEventListener("tap",onRectTap)
    p_NavigationVariableTable.Rect1:addEventListener("touch",onRectTouch)
    navigationGroup:insert( p_NavigationVariableTable.Rect1 )
    
    p_NavigationVariableTable.CartIcon = display.newImageRect(imageDirectory.."Cart_Icon.png",_W/18.30,_H/48)
    p_NavigationVariableTable.CartIcon.x = -_W/1.28 + _W/15.42  
    p_NavigationVariableTable.CartIcon.y =  p_NavigationVariableTable.Rect1.y  
    navigationGroup:insert( p_NavigationVariableTable.CartIcon )
    
    p_NavigationVariableTable.CartLabel = display.newText(GBCLanguageCabinet.getText("viewCartLabel",_LanguageKey),-_W/1.28 + _W/7.2,p_NavigationVariableTable.Rect1.y,_FontArr[6],_H/36.76)
    p_NavigationVariableTable.CartLabel.anchorX = 0
    p_NavigationVariableTable.CartLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( p_NavigationVariableTable.CartLabel )
    
    p_NavigationVariableTable.Rect2 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    p_NavigationVariableTable.Rect2.x = -_W/1.28  
    p_NavigationVariableTable.Rect2.y =  p_NavigationVariableTable.Rect1.y + _H/12.22 
    p_NavigationVariableTable.Rect2.anchorX = 0 
    p_NavigationVariableTable.Rect2.id = 2
    p_NavigationVariableTable.Rect2:addEventListener("tap",onRectTap)
    p_NavigationVariableTable.Rect2:addEventListener("touch",onRectTouch)
    navigationGroup:insert( p_NavigationVariableTable.Rect2 )
    
    p_NavigationVariableTable.OrderIcon = display.newImageRect(imageDirectory.."OrderHistory_Icon.png",_W/26.34,_H/32)
    p_NavigationVariableTable.OrderIcon.x = -_W/1.28 + _W/15.42  
    p_NavigationVariableTable.OrderIcon.y =  p_NavigationVariableTable.Rect2.y  
    navigationGroup:insert( p_NavigationVariableTable.OrderIcon )
    
    p_NavigationVariableTable.OrderLabel = display.newText(GBCLanguageCabinet.getText("orderHistoryLabel", _LanguageKey),-_W/1.28 + _W/7.2,p_NavigationVariableTable.Rect2.y,_FontArr[6],_H/36.76)
    p_NavigationVariableTable.OrderLabel.anchorX = 0
    p_NavigationVariableTable.OrderLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( p_NavigationVariableTable.OrderLabel )
    
    p_NavigationVariableTable.Rect3 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    p_NavigationVariableTable.Rect3.x = -_W/1.28  
    p_NavigationVariableTable.Rect3.y =  p_NavigationVariableTable.Rect2.y + _H/12.22 
    p_NavigationVariableTable.Rect3.anchorX = 0 
    p_NavigationVariableTable.Rect3.id = 3
    p_NavigationVariableTable.Rect3:addEventListener("tap",onRectTap)
    p_NavigationVariableTable.Rect3:addEventListener("touch",onRectTouch)
    navigationGroup:insert( p_NavigationVariableTable.Rect3 )
    
    p_NavigationVariableTable.FeedBackIcon = display.newImageRect(imageDirectory.."FeedBack_Icon.png",_W/17.70,_H/31.47)
    p_NavigationVariableTable.FeedBackIcon.x = -_W/1.28 + _W/15.42  
    p_NavigationVariableTable.FeedBackIcon.y =  p_NavigationVariableTable.Rect3.y  
    navigationGroup:insert( p_NavigationVariableTable.FeedBackIcon )
    
    p_NavigationVariableTable.FeedBackLabel = display.newText(GBCLanguageCabinet.getText("faqLabel", _LanguageKey),-_W/1.28 + _W/7.2,p_NavigationVariableTable.Rect3.y,_FontArr[6],_H/36.76)
    p_NavigationVariableTable.FeedBackLabel.anchorX = 0
    p_NavigationVariableTable.FeedBackLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( p_NavigationVariableTable.FeedBackLabel )
    
    p_NavigationVariableTable.Rect4 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    p_NavigationVariableTable.Rect4.x = -_W/1.28  
    p_NavigationVariableTable.Rect4.y =  p_NavigationVariableTable.Rect3.y + _H/12.22 
    p_NavigationVariableTable.Rect4.anchorX = 0 
    p_NavigationVariableTable.Rect4.id = 4
    p_NavigationVariableTable.Rect4:addEventListener("tap",onRectTap)
    p_NavigationVariableTable.Rect4:addEventListener("touch",onRectTouch)
    navigationGroup:insert( p_NavigationVariableTable.Rect4 )
    
    p_NavigationVariableTable.SettingIcon = display.newImageRect(imageDirectory.."Setting_Icon.png",_W/17.41,_H/30.96)
    p_NavigationVariableTable.SettingIcon.x = -_W/1.28 + _W/15.42  
    p_NavigationVariableTable.SettingIcon.y =  p_NavigationVariableTable.Rect4.y  
    navigationGroup:insert( p_NavigationVariableTable.SettingIcon )
    
    p_NavigationVariableTable.SettingLabel = display.newText(GBCLanguageCabinet.getText("settingLabel", _LanguageKey),-_W/1.28 + _W/7.2,p_NavigationVariableTable.Rect4.y,_FontArr[6],_H/36.76)
    p_NavigationVariableTable.SettingLabel.anchorX = 0
    p_NavigationVariableTable.SettingLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( p_NavigationVariableTable.SettingLabel )
    
    p_NavigationVariableTable.Rect6 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    p_NavigationVariableTable.Rect6.x = -_W/1.28  
    p_NavigationVariableTable.Rect6.y =  p_NavigationVariableTable.Rect4.y + _H/12.22 
    p_NavigationVariableTable.Rect6.anchorX = 0 
    p_NavigationVariableTable.Rect6.id = 6
    p_NavigationVariableTable.Rect6:addEventListener("tap",onRectTap)
    p_NavigationVariableTable.Rect6:addEventListener("touch",onRectTouch)
    navigationGroup:insert( p_NavigationVariableTable.Rect6 )
    
    p_NavigationVariableTable.RestaurantIcon = display.newImageRect(imageDirectory.."restaurant_Icon.png",_W/17.41,_H/30.96)
    p_NavigationVariableTable.RestaurantIcon.x = -_W/1.28 + _W/15.42  
    p_NavigationVariableTable.RestaurantIcon.y =  p_NavigationVariableTable.Rect6.y  
    navigationGroup:insert( p_NavigationVariableTable.RestaurantIcon )
    
    p_NavigationVariableTable.RestaurantLabel = display.newText(GBCLanguageCabinet.getText("restaurantLabel", _LanguageKey),-_W/1.28 + _W/7.2,p_NavigationVariableTable.Rect6.y,_FontArr[6],_H/36.76)
    p_NavigationVariableTable.RestaurantLabel.anchorX = 0
    p_NavigationVariableTable.RestaurantLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( p_NavigationVariableTable.RestaurantLabel )
    
    p_NavigationVariableTable.Rect7 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    p_NavigationVariableTable.Rect7.x = -_W/1.28  
    p_NavigationVariableTable.Rect7.y =  p_NavigationVariableTable.Rect6.y + _H/12.22 
    p_NavigationVariableTable.Rect7.anchorX = 0 
    p_NavigationVariableTable.Rect7.id = 7
    p_NavigationVariableTable.Rect7:addEventListener("tap",onRectTap)
    p_NavigationVariableTable.Rect7:addEventListener("touch",onRectTouch)
    navigationGroup:insert( p_NavigationVariableTable.Rect7 )
    
    p_NavigationVariableTable.TutorialIcon = display.newImageRect(imageDirectory.."tutorial_Icon.png",_W/17.41,_H/30.96)
    p_NavigationVariableTable.TutorialIcon.x = -_W/1.28 + _W/15.42  
    p_NavigationVariableTable.TutorialIcon.y =  p_NavigationVariableTable.Rect7.y  
    navigationGroup:insert( p_NavigationVariableTable.TutorialIcon )
    
    p_NavigationVariableTable.TutorialLabel = display.newText(GBCLanguageCabinet.getText("tutorialLabel", _LanguageKey),-_W/1.28 + _W/7.2,p_NavigationVariableTable.Rect7.y,_FontArr[6],_H/36.76)
    p_NavigationVariableTable.TutorialLabel.anchorX = 0
    p_NavigationVariableTable.TutorialLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( p_NavigationVariableTable.TutorialLabel )
    
    p_NavigationVariableTable.Rect5 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    p_NavigationVariableTable.Rect5.x = -_W/1.28  
    p_NavigationVariableTable.Rect5.y =  p_NavigationVariableTable.Rect7.y + _H/12.22 
    p_NavigationVariableTable.Rect5.anchorX = 0 
    p_NavigationVariableTable.Rect5.id = 5
    p_NavigationVariableTable.Rect5:addEventListener("tap",onRectTap)
    p_NavigationVariableTable.Rect5:addEventListener("touch",onRectTouch)
    navigationGroup:insert( p_NavigationVariableTable.Rect5 )
    
    p_NavigationVariableTable.LogOutIcon = display.newImageRect(imageDirectory.."LogOut_Icon.png",_W/17.70,_H/38.4)
    p_NavigationVariableTable.LogOutIcon.x = -_W/1.28 + _W/15.42  
    p_NavigationVariableTable.LogOutIcon.y =  p_NavigationVariableTable.Rect5.y  
    navigationGroup:insert( p_NavigationVariableTable.LogOutIcon )
    
    p_NavigationVariableTable.LogOutLabel = display.newText(GBCLanguageCabinet.getText("logoutLabel", _LanguageKey),-_W/1.28 + _W/7.2,p_NavigationVariableTable.Rect5.y,_FontArr[6],_H/36.76)
    p_NavigationVariableTable.LogOutLabel.anchorX = 0
    p_NavigationVariableTable.LogOutLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( p_NavigationVariableTable.LogOutLabel )
        
------------------------------------------------------------- Navigation Over  --------------------------------------------------------------        
     

end	

local function onSelectAddOns( event )
		local i = event.target.id:sub(1,string.find( event.target.id, "//" ) - 1)
		local j = event.target.id:sub(string.find( event.target.id, "//" ) + 2,event.target.id:len())
		
		addOnsCheckBtnSelected[tonumber(i)][tonumber(j)].isVisible = false
		addOnsCheckBtnUnSelected[tonumber(i)][tonumber(j)].isVisible = true
		
		if #extraItemsArr > 0 then
			for k = 1, #extraItemsArr do
				if(extraItemsArr[k].id == selectedProductDetails.options[tonumber(i)].options[tonumber(j)].id) then
					
					table.remove(extraItemsArr,i)
					break
				end
			end
		end
		
		countTotal()
		
	return true
end

local function onUNSelectAddOns( event )
		local i = event.target.id:sub(1,string.find( event.target.id, "//" ) - 1)
		local j = event.target.id:sub(string.find( event.target.id, "//" ) + 2,event.target.id:len())
		
		if #addOnsCheckBtnSelected[tonumber(i)] > 0 then
			for k = 1, #addOnsCheckBtnSelected[tonumber(i)] do
				addOnsCheckBtnSelected[tonumber(i)][tonumber(k)].isVisible = false
				addOnsCheckBtnUnSelected[tonumber(i)][tonumber(k)].isVisible = true
				
				if #extraItemsArr > 0 then
					for n = 1,#extraItemsArr do
						if( extraItemsArr[n] == selectedProductDetails.options[tonumber(i)].options[tonumber(k)]) then
						
							table.remove(extraItemsArr,i)
							break
							
						end
					end
				end
				
			end
		end
		
		addOnsCheckBtnSelected[tonumber(i)][tonumber(j)].isVisible = true
		addOnsCheckBtnUnSelected[tonumber(i)][tonumber(j)].isVisible = false
			
		extraItemsArr[ #extraItemsArr + 1 ] = selectedProductDetails.options[tonumber(i)].options[tonumber(j)]
		
		countTotal()
		
	return true
end

local function onSelectVariety( event )
	local i = event.target.id:sub(1,string.find( event.target.id, "//" ) - 1)
	local j = event.target.id:sub(string.find( event.target.id, "//" ) + 2,event.target.id:len())
	
	addOnsCheckBtnSelected[tonumber(i)][tonumber(j)].isVisible = false
	addOnsCheckBtnUnSelected[tonumber(i)][tonumber(j)].isVisible = true
	
	local count = 0
	
	if #addOnsCheckBtnSelected[tonumber(i)] > 0 then
		for k = 1, #addOnsCheckBtnSelected[tonumber(i)] do
			addOnsCheckBtnSelected[tonumber(i)][tonumber(k)].isVisible = false
			count = count + 1
		end
	end
	
	if(count == #addOnsCheckBtnSelected[tonumber(i)]) then
		addOnsCheckBtnSelected[tonumber(i)][1].isVisible = true
		addOnsCheckBtnUnSelected[tonumber(i)][1].isVisible = false
		
		if(selectedProductDetails.discount_applicable == "NO") then
			actualPrice = selectedProductDetails.varieties[1].variety_price
		else
			actualPrice = selectedProductDetails.varieties[1].discounted_variety_price
		end
		
		selected_variety_id = selectedProductDetails.varieties[1].id
		selected_variety_name = selectedProductDetails.varieties[1].variety_name
		selected_variety_price = actualPrice
		
	else
		if(selectedProductDetails.discount_applicable == "NO") then
			actualPrice = selectedProductDetails.varieties[tonumber(j)].variety_price
		else
			actualPrice = selectedProductDetails.varieties[tonumber(j)].discounted_variety_price
		end
		
		selected_variety_id = selectedProductDetails.varieties[tonumber(j)].id
		selected_variety_name = selectedProductDetails.varieties[tonumber(j)].variety_name
		selected_variety_price = actualPrice
		
	end
	
	countTotal()
	
	return true
end

local function onUNSelectVariety( event )
	local i = event.target.id:sub(1,string.find( event.target.id, "//" ) - 1)
	local j = event.target.id:sub(string.find( event.target.id, "//" ) + 2,event.target.id:len())
	
	if #addOnsCheckBtnSelected[tonumber(i)] > 0 then
		for k = 1, #addOnsCheckBtnSelected[tonumber(i)] do
			addOnsCheckBtnSelected[tonumber(i)][tonumber(k)].isVisible = false
			addOnsCheckBtnUnSelected[tonumber(i)][tonumber(k)].isVisible = true
		end
	end
	
	addOnsCheckBtnSelected[tonumber(i)][tonumber(j)].isVisible = true
	addOnsCheckBtnUnSelected[tonumber(i)][tonumber(j)].isVisible = false
	
	if(selectedProductDetails.discount_applicable == "NO") then
		actualPrice = selectedProductDetails.varieties[tonumber(j)].variety_price
	else
		actualPrice = selectedProductDetails.varieties[tonumber(j)].discounted_variety_price
	end
	
	selected_variety_id = selectedProductDetails.varieties[tonumber(j)].id
	selected_variety_name = selectedProductDetails.varieties[tonumber(j)].variety_name
	selected_variety_price = actualPrice
	
	countTotal()
	
	return true
end

local function onAddOnsRowRender( event )
	 local row = event.row

    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth
	
	i = row.index
	
    addOnsRow[i] = display.newImageRect(imageDirectory4.."AddOnsBg.png",_W,_H/13.15)
    addOnsRow[i].x = _W/2
    addOnsRow[i].y = rowHeight * 0.5
    row:insert( addOnsRow[i] )
    
   	addOnsTitle[i] = display.newText(tostring(selectedProductDetails.options[i].option_name) ,_W/10.90,rowHeight * 0.4,_FontArr[6], _H/31.53)
    addOnsTitle[i].anchorY = 0.5
    addOnsTitle[i].anchorX = 0
    addOnsTitle[i]:setTextColor( 83/255, 20/255, 111/255 )
    row:insert(addOnsTitle[i]) 
    
    addOnsCheckBtnUnSelected[i] = display.newImageRect(row, imageDirectory4.."unSelected_CheckBox2.png",_W/13.5,_H/24)
	addOnsCheckBtnUnSelected[i].x = _W/1.05
	addOnsCheckBtnUnSelected[i].id = i
	addOnsCheckBtnUnSelected[i]:addEventListener( "touch", onUNSelectAddOns  )
	addOnsCheckBtnUnSelected[i].y = rowHeight * 0.5
	
	addOnsCheckBtnSelected[i] = display.newImageRect(row, imageDirectory4.."Selected_CheckBox2.png",_W/13.5,_H/24)
	addOnsCheckBtnSelected[i].x = _W/1.05
	addOnsCheckBtnSelected[i].id = i
	addOnsCheckBtnSelected[i]:addEventListener( "touch", onSelectAddOns )
	addOnsCheckBtnSelected[i].y = rowHeight * 0.5
	addOnsCheckBtnSelected[i].isVisible = false
	
	local priceValue = "+$ 0"
	addOnsPrice[i] = display.newText( priceValue,_W/1.16,rowHeight * 0.5,_FontArr[7], _H/49.06)
    addOnsPrice[i].anchorY = 0.5
    addOnsPrice[i].anchorX = 1
    addOnsPrice[i]:setTextColor( 0 ) 
    row:insert(addOnsPrice[i]) 
	
	local descriValue 
	if(tostring(selectedProductDetails.options[i].description):len() > 20) then
		descriValue = tostring(selectedProductDetails.options[i].description):sub(0,20)..".."
	else
		descriValue = tostring(selectedProductDetails.options[i].description)
	end
	
    addOnsDescri = display.newText(row,descriValue,addOnsTitle[i].x,addOnsTitle[i].y + addOnsTitle[i].height/2 + _H/384,_FontArr[6],_H/49.06)
    addOnsDescri.anchorX = addOnsTitle[i].anchorX
    addOnsDescri:setTextColor( 0,0,0,0.5 )
    
	
end

local function onDecrementProductQuantity( event )
	if(event.phase == "began") then
		if(VariableTable.QuantityLabel.text == "1" or VariableTable.QuantityLabel.text == 1) then
			
		else
			VariableTable.QuantityLabel.text = tonumber(VariableTable.QuantityLabel.text) - 1
			local m
			if(tonumber(selectedProductDetails.no_of_option) > 0) then
				m = #selectedProductDetails.options + 1
				if(#selectedProductDetails.options > 0) then
					for i = 1, #selectedProductDetails.options do
						if #selectedProductDetails.options[i].options > 0 then
							for k = 1, #selectedProductDetails.options[i].options do 		
								addOnsPrice[i][k].text = "+$ "..make2Digit(tostring(tonumber(selectedProductDetails.options[i].options[k].sub_amount) * tonumber(VariableTable.QuantityLabel.text)))
							end
						end
					end
				else
					
				end
			else
				m = 1
			end
			
			if(tonumber(selectedProductDetails.has_variety) > 0) then
				if(#selectedProductDetails.varieties > 0) then
					for i = 1, #selectedProductDetails.varieties do
						addOnsPrice[m][i].text = "+$ "..make2Digit(tostring(tonumber(selectedProductDetails.varieties[i].variety_price) * tonumber(VariableTable.QuantityLabel.text)))
					end
				end
			else
				
			end
			
		end
	
		countTotal()
	end
	return true
end

local function onIncrementProductQuantity( event )
	if(event.phase == "began") then
		VariableTable.QuantityLabel.text = tonumber(VariableTable.QuantityLabel.text) + 1
		
		local m
		if(tonumber(selectedProductDetails.no_of_option) > 0) then
			m = #selectedProductDetails.options + 1
			if(#selectedProductDetails.options > 0) then
				for i = 1, #selectedProductDetails.options do
					if #selectedProductDetails.options[i].options > 0 then
						for k = 1, #selectedProductDetails.options[i].options do 
							addOnsPrice[i][k].text = "+$ "..make2Digit(tostring(tonumber(selectedProductDetails.options[i].options[k].sub_amount) * tonumber(VariableTable.QuantityLabel.text)))
						end
					end
				end
			else
				
			end
		else
			m = 1
		end
		
		if(tonumber(selectedProductDetails.has_variety) > 0) then
			if(#selectedProductDetails.varieties > 0) then
				for i = 1, #selectedProductDetails.varieties do
					addOnsPrice[m][i].text = "+$ "..make2Digit(tostring(tonumber(selectedProductDetails.varieties[i].variety_price) * tonumber(VariableTable.QuantityLabel.text)))
				end
			end
		else
			
		end
		
		countTotal()
	end
	return true
end

local function handleOrdersButtonEvent( event )
	if( event.phase == "ended" ) then
		composer.gotoScene( "PlaceOrder" )
	end	
	return true
end

local function handleButtonEvent( event )
	if( event.target.id == "home" ) then
		if(composer.getSceneName("current") == "Product") then
			if(menuFlag == 0) then
				product_OverRect.isVisible = true
				navigationGroup.x = navigationGroup.x + _W/1.28
				productGroup.x = productGroup.x + _W/1.28
				menuFlag = 1
				
			elseif(menuFlag == 1) then
				product_OverRect.isVisible = false
				navigationGroup.x = navigationGroup.x - _W/1.28
				productGroup.x = productGroup.x - _W/1.28
				menuFlag = 0
			
			end
		end
		
	end
	
	return true
end

local function onBgTap( event )
	native.setKeyboardFocus( nil )
	subMenuGroup.y = yPos
end

local function onBgTouch( event )
	if( event.phase == "ended" ) then
		native.setKeyboardFocus( nil )
		subMenuGroup.y = yPos
	end
	return true
end

local function onMoveDown( event )
     
    local function onScrollComplete()
   	 	
	end
	
	timer.performWithDelay( 100, function()
   	VariableTable.productNewScrollView:scrollToPosition
   	{ y=(VariableTable.productNewScrollView._view.height-VariableTable.productNewScrollView.height+50)*-1, time=100 }
	end )
		
	if( ShowArrowFlag == true ) then
		downArrow.isVisible = false
		upArrow.isVisible = true
	end
    return true		
end

local function onMoveUp( event )

	local function onScrollComplete()
   	 	
	end
	
	VariableTable.productNewScrollView:scrollToPosition
	{
    	x = xView,
    	y =  yView,
    	time = 100,
    	onComplete = onScrollComplete
	}
	
	if( ShowArrowFlag == true ) then
		downArrow.isVisible = true
		upArrow.isVisible = false
	end
	return true
end

local function productNewScrollListner( event )
	if ( event.direction == "up" ) then 
		
    elseif ( event.direction == "down" ) then 
    	if(VariableTable.ProductDescri.height + yPosToPlaceNote > _H/1.25) then
        	downArrow.isVisible = true
        	upArrow.isVisible = false
        else
        	downArrow.isVisible = false
        	upArrow.isVisible = false
        end
    	
    end
    if ( event.limitReached ) then
        if ( event.direction == "up" ) then 
        	
        	if(VariableTable.ProductDescri.height + yPosToPlaceNote > _H/1.25) then
        		downArrow.isVisible = false
        		upArrow.isVisible = true
        	else
        		downArrow.isVisible = false
        		upArrow.isVisible = false
        	end
        elseif ( event.direction == "down" ) then 
       		
       		if(VariableTable.ProductDescri.height + yPosToPlaceNote > _H/1.25) then
        		downArrow.isVisible = true
        		upArrow.isVisible = false
        	else
        		downArrow.isVisible = false
        		upArrow.isVisible = false
        	end
        end
    end
    
	return true
end


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
       	
        _PreviousSceneforSetting = composer.getSceneName( "current" )
     	
     	_PreviousSceneforOrder = composer.getSceneName( "current" )
        
    selected_variety_id = ""
    selected_variety_name = ""
    selected_variety_price = ""
    menuFlag = 0
    extraItemsArr = { }
    originalProductPrice = 0
    actualPrice = 0
    discountValue = 0
    sawAllOptionFlag = false
    
    addOnsScrollView = { }
    
    if #productData > 0 then
		for i = 1, #productData do
			if(productData[i].productDetail.id == _selectedProductID) then
				
				selectedProductDetails = productData[i].productDetail
				
				break
			end
			
		end
    end
    
     Background = display.newImageRect(imageDirectory.."Background.png",_W,_H)
     Background.x = _W/2
     Background.y = _H/2
     Background:addEventListener("tap",onBgTap)
     Background:addEventListener("touch",onBgTouch)
     sceneGroup:insert(Background)
     
     navigationGroup = display.newGroup()
     sceneGroup:insert(navigationGroup)
     
     createNavigation()
     
     productGroup = display.newGroup()
     sceneGroup:insert(productGroup)
     
     subMenuGroup = display.newGroup()
     productGroup:insert(subMenuGroup)
     
     headerGroup = display.newGroup()
     productGroup:insert(headerGroup)
     
     VariableTable.Bg = display.newImageRect("images/MainMenu/Background.png",_W,_H)
     VariableTable.Bg.x = _W/2
     VariableTable.Bg.y = _H/2
     productGroup:insert(VariableTable.Bg)
     VariableTable.Bg:toBack()
     
     VariableTable.HeaderBg = display.newImageRect(imageDirectory2.."TopBg.png",_W,_H/7.27)
     VariableTable.HeaderBg.x = _W/2
     VariableTable.HeaderBg.y = 0
     VariableTable.HeaderBg.anchorY = 0
     headerGroup:insert(VariableTable.HeaderBg)
     
    homeBtn = widget.newButton
	{
    	width = _W/13.5,
    	height = _H/24,
    	defaultFile = imageDirectory2.."Home_Btn.png",
   		overFile = imageDirectory2.."Home_Btn.png",
    	id = "home",
	}
	homeBtn.x = _W/29.18 + homeBtn.width/2
	homeBtn.y = _H/41.73 + homeBtn.height/2
	homeBtn:addEventListener( "tap", handleButtonEvent )
	headerGroup:insert( homeBtn )
     
     VariableTable.restaurantName = display.newText( _HotelName:upper(), VariableTable.HeaderBg.x, VariableTable.HeaderBg.y + _H/27.42, _FontArr[6], _H/30 )
     VariableTable.restaurantName:setFillColor( 83/255, 20/255, 111/255 )
     headerGroup:insert( VariableTable.restaurantName )
        
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
     headerGroup:insert( VariableTable.restaurantAdd )
    
     VariableTable.MenuTitleBg = display.newImageRect(imageDirectory2.."TitleBg.png",_W,_H/14.22)
     VariableTable.MenuTitleBg.x = _W/2
     VariableTable.MenuTitleBg.y = _H/10.97 + VariableTable.MenuTitleBg.height/2
     headerGroup:insert(VariableTable.MenuTitleBg)
     
     VariableTable.MenuTitle = display.newText( "", _W/7.2, VariableTable.MenuTitleBg.y , _FontArr[6], _H/27.25 )
     VariableTable.MenuTitle.anchorX = 0  
     VariableTable.MenuTitle:setFillColor( 0 )
     headerGroup:insert( VariableTable.MenuTitle )
     
	 VariableTable.backBtn = widget.newButton
	{
    	width = _W/9,
    	height = _H/14.76,
    	defaultFile = imageDirectory3.."Back_Btn1.png",
   		overFile = imageDirectory3.."Back_Btn1.png",
    	id = "back",
	}
	VariableTable.backBtn.x = _W/36 + VariableTable.backBtn.width/2
	VariableTable.backBtn.y = VariableTable.MenuTitleBg.y
	VariableTable.backBtn:addEventListener( "tap", handleBackButtonEvent )
	headerGroup:insert( VariableTable.backBtn )
	 
	 VariableTable.productNewScrollView = widget.newScrollView
	{
   		top = VariableTable.MenuTitleBg.y + VariableTable.MenuTitleBg.height/2,
    	left = 0,
    	width = _W,
    	height = _H - VariableTable.MenuTitleBg.y + VariableTable.MenuTitleBg.height/2 - _H/4,
    	scrollWidth = _W,
    	scrollHeight = _H/2,
    	hideBackground = true,
    	horizontalScrollDisabled = true,
    	backgroundColor = { 1, 0, 0, 1 }, 
    	bottomPadding = _H/38.4,
    	listener = productNewScrollListner
	}
	subMenuGroup:insert( VariableTable.productNewScrollView )
	 
	 local function onDisplayProductImage()
	 
    local imagePath = system.pathForFile( "Product".._selectedProductID..".png", system.TemporaryDirectory )
    local imageFile = io.open( imagePath, "r" )
    
    if(imageFile == nil) then
    
    	if( VariableTable.ProductImage ) then
    		display.remove( VariableTable.ProductImage )
    		VariableTable.ProductImage = nil
    	end
    	
    	VariableTable.ProductImage = display.newRect( 0,0, _W, _H/3.14 )
     	VariableTable.ProductImage.x = _W/2
     	VariableTable.ProductImage.y = _H/192
     	VariableTable.ProductImage.anchorY = 0
     	VariableTable.productNewScrollView:insert( VariableTable.ProductImage )	
    	
    else
    
    	if( VariableTable.backRect ) then
    		display.remove( VariableTable.backRect ) 
    		VariableTable.backRect = nil
    	end
    	if( VariableTable.ProductImage ) then
    		display.remove( VariableTable.ProductImage )
    		VariableTable.ProductImage = nil
    	end
    	
    	VariableTable.backRect = display.newRect( 0,0, _W, _H/3.14 )
     	VariableTable.backRect.x = _W/2
     	VariableTable.backRect.y = _H/192 
     	VariableTable.backRect.anchorY = 0
     	VariableTable.backRect:setFillColor( 1 )
     	VariableTable.productNewScrollView:insert( VariableTable.backRect )
    	
     	VariableTable.ProductImage = display.newImage( "Product".._selectedProductID..".png", system.TemporaryDirectory )
     	VariableTable.ProductImage.x = _W/2
     	VariableTable.ProductImage.y = _H/192 
     	VariableTable.ProductImage.anchorY = 0
     	VariableTable.productNewScrollView:insert( VariableTable.ProductImage )
     	VariableTable.ProductImage.width = _H/3.14/(VariableTable.ProductImage.height/VariableTable.ProductImage.width)
     	VariableTable.ProductImage.height = _H/3.14
     	
     	if(VariableTable.ProductImage.width > _W) then
     		VariableTable.ProductImage.width = _W
     	end
     		
     end
     
    end 
     onDisplayProductImage()
     
     displayImageTimer = timer.performWithDelay( 1000, onDisplayProductImage ,1 )
     
     if(tostring(selectedProductDetails.is_new) == "1") then
     
     	newLabel = display.newImageRect(imageDirectory4.."NewLabelBg.png", _W/3.28, _H/6)
	 	newLabel.x = VariableTable.backRect.x - VariableTable.backRect.width/2 
     	newLabel.y = VariableTable.backRect.y - _H/96
     	newLabel.anchorX = 0
     	newLabel.anchorY = 0
     	VariableTable.productNewScrollView:insert( newLabel )
     	
     	discountLabel_txt = display.newText("$"..make2Digit(tonumber(selectedProductDetails.price) - tonumber(selectedProductDetails.discounted_price)).." off",0,0,_FontArr[6],_H/30)
	 	discountLabel_txt.x = VariableTable.backRect.x - VariableTable.backRect.width/2 + _W/216
     	discountLabel_txt.y = VariableTable.backRect.y + VariableTable.backRect.height*0.30
     	discountLabel_txt.anchorX = 0
     	discountLabel_txt.anchorY = 0
     	discountLabel_txt:setFillColor( 1 )
     	VariableTable.productNewScrollView:insert( discountLabel_txt )
     	
     	if(system.getInfo("model") == "iPad") then
     	
     		discountLabel_txt:rotate( -35 )
     		discountLabel_txt.x = VariableTable.backRect.x - VariableTable.backRect.width/2 
     	else
     		discountLabel_txt:rotate( -45 )
     	end
     
     else
     
     end
     
     local descriptionValue
     if(selectedProductDetails.item_description) then
   		
     	descriptionValue = selectedProductDetails.item_description
     	
     else
     	descriptionValue = "NA"
     end
     
     VariableTable.ProductDescri = display.newText( descriptionValue, _W/27,VariableTable.ProductImage.y + VariableTable.ProductImage.height + _H/48 ,_W/1.08,0, _FontArr[26], _H/40 ) 
     VariableTable.ProductDescri.anchorX = 0  
     VariableTable.ProductDescri.anchorY = 0  
     VariableTable.ProductDescri:setFillColor( 83/255, 20/255, 111/255 )
     VariableTable.productNewScrollView:insert( VariableTable.ProductDescri )
     
     VariableTable.QuantityLabel2 = display.newText( GBCLanguageCabinet.getText("QuantityLabel",_LanguageKey), _W/54, _H - _H/5.5 - _H/17.28 +  _H/9 , _FontArr[6], _H/38.4 )
     VariableTable.QuantityLabel2.anchorX = 0  
     VariableTable.QuantityLabel2:setTextColor( 83/255, 20/255, 111/255 )
     subMenuGroup:insert( VariableTable.QuantityLabel2 )
    
     VariableTable.IncrementIcon = display.newImageRect( imageDirectory4.."IncrementBtn.png",  _W/5.4, _H/9.6 )
     VariableTable.IncrementIcon.x = _W/2 + _W/6 
     VariableTable.IncrementIcon.y = VariableTable.QuantityLabel2.y
     VariableTable.IncrementIcon.id = ""
     VariableTable.IncrementIcon:addEventListener("touch",onIncrementProductQuantity)
     subMenuGroup:insert(VariableTable.IncrementIcon)
     
     VariableTable.QuantityLabel = display.newText( "1", _W/2, VariableTable.IncrementIcon.y , _FontArr[6], _H/30 )
     VariableTable.QuantityLabel.anchorX = 0  
     VariableTable.QuantityLabel:setFillColor( 0 )
     subMenuGroup:insert( VariableTable.QuantityLabel )
     
     if _EditFlag == true then
     	VariableTable.QuantityLabel.text = _EditProductDetails.quantity
     	extraItemsArr = _EditProductDetails.extraItems
     end
     
     VariableTable.DecrementIcon = display.newImageRect( imageDirectory4.."DecrementBtn.png", _W/7.2, _H/12.8 )
     VariableTable.DecrementIcon.x = _W/2 - _W/8 
     VariableTable.DecrementIcon.y = VariableTable.IncrementIcon.y
     VariableTable.DecrementIcon.id = ""
     VariableTable.DecrementIcon:addEventListener("touch",onDecrementProductQuantity)
     subMenuGroup:insert(VariableTable.DecrementIcon)
    
    downArrow = display.newImageRect(imageDirectory4.."DownArrow1.png",_W/10.8,_H/18.64)
    downArrow.x = _W - _W/36
    downArrow.y = VariableTable.IncrementIcon.y
    downArrow.anchorX = 1
    downArrow:addEventListener("tap",onMoveDown)
    subMenuGroup:insert( downArrow )
    
    function shake1()
		
		downTrans1 = transition.to(downArrow,{time = 500, xScale = 0.75, yScale = 0.75, onComplete = normal1})
		
	end
	
 	function normal1()
	 
		downTrans2 = transition.to(downArrow,{time = 500, xScale = 1, yScale = 1, onComplete = shake1})
	 
	end
	
	shake1()
    
    upArrow = display.newImageRect(imageDirectory4.."UpArrow1.png",_W/10.8,_H/18.64)
    upArrow.x = _W - _W/36
    upArrow.y = VariableTable.IncrementIcon.y
    upArrow.anchorX = 1
    upArrow:addEventListener("tap",onMoveUp)
    subMenuGroup:insert( upArrow )
    upArrow.isVisible = false
    
     function shake2()
		
		upTrans1 = transition.to(upArrow,{time = 500, xScale = 0.75, yScale = 0.75, onComplete = normal2})
		
	end
	
 	function normal2()
	 
		upTrans2 = transition.to(upArrow,{time = 500, xScale = 1, yScale = 1, onComplete = shake2})
	 
	end
	
	shake2()
    
     VariableTable.BottomBg = display.newImageRect( imageDirectory4.."BottomBg.png",  _W, _H/12 ) 
     VariableTable.BottomBg.x = _W/2
     VariableTable.BottomBg.y = _H
     VariableTable.BottomBg.anchorY = 1
     subMenuGroup:insert( VariableTable.BottomBg )
     
        VariableTable.AddToCartBtn = display.newText( "", _W/2, _H - _H/96 - _H/64, 0, _H/16.13, _FontArr[6], _H/30 )
        VariableTable.AddToCartBtn:setTextColor( 0 )
        subMenuGroup:insert( VariableTable.AddToCartBtn )
        
        VariableTable.AddToCartBtn2 = widget.newButton
		{
   	 		width = _W/1.08,
    		height = _H/16.13,
    		defaultFile = imageDirectory3.."SinUp_Btn2.png",
    		overFile = imageDirectory3.."SinUp_Btn2.png",
    		label = "",
    		labelColor = { default={ 1, 1, 1 }, over={ 1,1,1 } },
    		fontSize = _H/30,
    		font = _FontArr[6],
    		labelYOffset = _H/275,
    		onEvent = handleAddToCartButtonEvent
		}
		VariableTable.AddToCartBtn2.x = _W/2
		VariableTable.AddToCartBtn2.y = _H - _H/96 - VariableTable.AddToCartBtn2.height/2
        subMenuGroup:insert(VariableTable.AddToCartBtn2)
        VariableTable.AddToCartBtn2.isVisible = false
     
     	local function optionsScrollListener( event )
     		
     		if ( event.phase == "began" ) then
     			i = event.target.id
     		end
     		if ( event.direction == "up" ) then
     			
       	 	elseif ( event.direction == "down" ) then
       	 		
       	 	end
     		
     		if ( event.limitReached ) then
    
     		if ( event.direction == "up" ) then
     			
       	 	elseif ( event.direction == "down" ) then
       	 		
        	elseif ( event.direction == "left" ) then
        		if(addOnsScrollView[tonumber(i) + 1] ~= nil) then
        			addOnsScrollView[i].isVisible = false
        			addOnsScrollView[i + 1].isVisible = true
        			RectOnTop[i].isVisible = false
        			RectOnTop[i+1].isVisible = true
        				
        				if i + 1 == #addOnsScrollView then
        					sawAllOptionFlag = true
        					countTotal()
        				end
        				
        		end
        	elseif ( event.direction == "right" ) then
        		if(addOnsScrollView[tonumber(i) - 1] ~= nil) then
        			addOnsScrollView[i].isVisible = false
        			addOnsScrollView[i - 1].isVisible = true
        			RectOnTop[i].isVisible = false
        			RectOnTop[i-1].isVisible = true
        			
        		end
       	 	end
       	 	end
     		return true
     	end
     	
     	local function onMoveForward( event )
     		i = event.target.id
     		if(addOnsScrollView[tonumber(i) + 1] ~= nil) then
        		addOnsScrollView[i].isVisible = false
        		addOnsScrollView[i + 1].isVisible = true
        		RectOnTop[i].isVisible = false
        		RectOnTop[i+1].isVisible = true
        		
        		if i + 1 == #addOnsScrollView then
        			sawAllOptionFlag = true
        			countTotal()
        		end
        		
        	end
     		return true
     	end
     	
     	local function onMoveBack( event )
     		i = event.target.id
     		if(addOnsScrollView[tonumber(i) - 1] ~= nil) then
        		addOnsScrollView[i].isVisible = false
        		addOnsScrollView[i - 1].isVisible = true
        		RectOnTop[i].isVisible = false
        		RectOnTop[i-1].isVisible = true
        	end
     		return true
     	end
     	
     	local function onTouchRect(e)
		if( e.phase == "moved" ) then
			
			local dy = math.abs( ( e.y - e.yStart ) )
        	if ( dy > 10 ) then
            	VariableTable.productNewScrollView:takeFocus( e )
        	else
        		
        	end
        	
        	local dx = math.abs( ( e.x - e.xStart ) )
        	if ( dx > 10 ) then
            	addOnsScrollView[e.target.id]:takeFocus( e )
        	else
        		
        	end
			
		end
		return true
		end
     	
     	yPosToPlaceNote = VariableTable.ProductDescri.y + VariableTable.ProductDescri.height + _H/192
     	
     	function addNotesTextBox()
         
         
     	if(height) then
     		if(height > yPosToPlaceNote) then
				yPosToPlaceNote = height
			else
						
			end
		end
         
         if(_isNotesVisible ==  "1") then
     
     		VariableTable.NoteBg = display.newImageRect( imageDirectory4.."AddOnsNoteBg.png", _W, _H/8.64 )
     		VariableTable.NoteBg.x = _W/2
     		VariableTable.NoteBg.y = yPosToPlaceNote + _H/192 
     		VariableTable.NoteBg.anchorY = 0
     		VariableTable.NoteBg:addEventListener( "tap", onShowTextBox )
     		VariableTable.productNewScrollView:insert( VariableTable.NoteBg )
     		
     		
   			VariableTable.NoteTextBox = native.newTextBox( VariableTable.NoteBg.x, VariableTable.NoteBg.y + VariableTable.NoteBg.height/2, VariableTable.NoteBg.width - _W/54, VariableTable.NoteBg.height - _H/48 )
			VariableTable.NoteTextBox.placeholder = GBCLanguageCabinet.getText("addNotesLabel",_LanguageKey) 
			VariableTable.NoteTextBox.isEditable = false
			VariableTable.NoteTextBox.font = native.newFont( _FontArr[41],_H/40  )
			VariableTable.NoteTextBox:addEventListener( "userInput", inputListener )
			VariableTable.NoteTextBox.hasBackground = false
			VariableTable.NoteTextBox.isVisible = false
			VariableTable.NoteTextBox:setReturnKey( "done" )
    		VariableTable.productNewScrollView:insert(VariableTable.NoteTextBox)
    		
    		VariableTable.NoteTextLabel = display.newText( GBCLanguageCabinet.getText("addNotesLabel",_LanguageKey) ,VariableTable.NoteTextBox.x - VariableTable.NoteTextBox.width/2 + _W/108, VariableTable.NoteTextBox.y - VariableTable.NoteTextBox.height/2 + _H/76.8 ,_FontArr[41],_H/40 )
    		VariableTable.NoteTextLabel.anchorX = 0
    		VariableTable.NoteTextLabel:setTextColor( 0.5,0.5,0.5,0.5 )
    		VariableTable.productNewScrollView:insert(VariableTable.NoteTextLabel)
    		
    		
    	 else
    		
    	end
    	
    end
    	
		local function showAddOns()
			addOnsRow = { }
			addOnsTitle = { }
			addOnsCheckBtnUnSelected = { }
			addOnsCheckBtnSelected = { }
			addOnsPrice = { }
			RectOnTop = { }
			
			if(tonumber(selectedProductDetails.no_of_option) > 0) then	
				
				local n
				n = 1
				
				for i = n, #selectedProductDetails.options  do
					addOnsScrollView[i] = widget.newScrollView
					{
						top = VariableTable.ProductDescri.y + VariableTable.ProductDescri.height + _H/96 ,
						left = 0,
						width = _W,
						height = _H/4.6,
						scrollWidth = _W,
						id = i,
						listener = optionsScrollListener
					}
					VariableTable.productNewScrollView:insert(addOnsScrollView[i])
					addOnsScrollView[i].isVisible = false
					
					addOnsRow[i] = { }
					addOnsTitle[i] = { }
					addOnsCheckBtnUnSelected[i] = { }
					addOnsCheckBtnSelected[i] = { }
					addOnsPrice[i] = { }
					
					if(#selectedProductDetails.options[i].options > 0) then
						
						for j = 1, #selectedProductDetails.options[i].options do
							if(j == 1) then
								addOnsRow_first = display.newImageRect(imageDirectory4.."AddOnsBg.png",_W,_H/13.15)
								addOnsRow_first.x = _W/2
								addOnsRow_first.y = _H/192 + addOnsRow_first.height/2
								addOnsScrollView[i]:insert( addOnsRow_first )
								
								local option = {
									text = tostring(selectedProductDetails.options[i].item_option_main_name) ,
									x = _W/2,
									y = addOnsRow_first.y,
									width = _W/2,
									height = _H/19.2,
									font = _FontArr[6],
									fontSize =  _H/36.79,
									align = "center"
								}
								addOnsTitle_first = display.newText( option )
								addOnsTitle_first.anchorY = 0.5
								addOnsTitle_first:setTextColor( 206/255, 23/255, 100/255 )
								addOnsScrollView[i]:insert(addOnsTitle_first) 
								
								if( _LanguageKey == "ru" or _LanguageKey == "uk" ) then
									forwardBtnTextSize = _H/50
									forwardButtonSize = _H/7.5
									backButtonSize = _H/7.5
								elseif( _LanguageKey == "ar" ) then
									forwardBtnTextSize = _H/60
									forwardButtonSize = _H/10
									backButtonSize = _H/10
								elseif( _LanguageKey == "it" ) then
									forwardBtnTextSize = _H/45
									forwardButtonSize = _H/10
									backButtonSize = _H/12
								else
									forwardBtnTextSize = _H/45
									forwardButtonSize = _H/12
									backButtonSize = _H/12
								end
								
								if(i == 1) then
									if(i == #selectedProductDetails.options and tonumber(selectedProductDetails.has_variety) == 0) then
										
									else
										
										ForwardArrow = widget.newButton(
										{
											width = (_W/5.5)*2,
											height = (_H/28.23)*2,
											defaultFile = imageDirectory4.."unSelected_CheckBox1.png",
											overFile = imageDirectory4.."unSelected_CheckBox1.png",
											label = GBCLanguageCabinet.getText("NextLabel",_LanguageKey),
											font = _FontArr[6],
											fontSize = _H/21.33,
											labelYOffset = 5,
											labelColor = { default={1,1,1,1}, over={1,1,1,1} },
											id = i
										}
										)
										ForwardArrow.x = _W - ForwardArrow.width/2 - _W/216
										ForwardArrow.y = addOnsRow_first.y
										ForwardArrow:addEventListener( "tap", onMoveForward  )
										addOnsScrollView[i]:insert(ForwardArrow)
										
									end
								else
									if(tonumber(selectedProductDetails.has_variety) > 0 or #selectedProductDetails.options > i) then
										
										ForwardArrow = widget.newButton(
										{
											width = (_W/5.5)*2,
											height = (_H/28.23)*2,
											defaultFile = imageDirectory4.."unSelected_CheckBox1.png",
											overFile = imageDirectory4.."unSelected_CheckBox1.png",
											label = GBCLanguageCabinet.getText("NextLabel",_LanguageKey),
											font = _FontArr[6],
											fontSize = _H/21.33,
											labelYOffset = 5,
											labelColor = { default={1,1,1,1}, over={1,1,1,1} },
											id = i
										}
										)
										ForwardArrow.x = _W - ForwardArrow.width/2 - _W/216
										ForwardArrow.y = addOnsRow_first.y
										ForwardArrow:addEventListener( "tap", onMoveForward  )
										addOnsScrollView[i]:insert(ForwardArrow)
										
									else
										
									end
									
									BackArrow = widget.newButton(
									{
										width = _W/5.5,
										height = _H/28.23,
										defaultFile = imageDirectory4.."Back_Unselected_CheckBox.png",
										overFile = imageDirectory4.."Back_Unselected_CheckBox.png",
										label = GBCLanguageCabinet.getText("BackLabel",_LanguageKey),
										font = _FontArr[6],
										fontSize = _H/50,
										labelColor = { default={1,1,1,1}, over={1,1,1,1} },
										id = i
									}
									)
									BackArrow.x = BackArrow.width/2 + _W/216
									BackArrow.y = addOnsRow_first.y
									BackArrow:addEventListener( "tap", onMoveBack  )
									addOnsScrollView[i]:insert(BackArrow)
									
								end
							end
							
							addOnsRow[i][j] = display.newImageRect(imageDirectory4.."AddOnsBg.png",_W,_H/13.15)
							addOnsRow[i][j].x = _W/2
							addOnsRow[i][j].y = _H/192 + (j) * addOnsRow[i][j].height +  addOnsRow[i][j].height/2
							addOnsScrollView[i]:insert( addOnsRow[i][j] )
							
							local addOnTitleValue = ""
							if(tostring(selectedProductDetails.options[i].options[j].sub_name):len() > 25) then
								addOnTitleValue = tostring(selectedProductDetails.options[i].options[j].sub_name):sub(1,25)..".."
							else    						
								addOnTitleValue = tostring(selectedProductDetails.options[i].options[j].sub_name)
							end
							
							addOnsTitle[i][j] = display.newText( addOnTitleValue,_W/96,addOnsRow[i][j].y - _H/96,_FontArr[6], _H/36.79)
							addOnsTitle[i][j].anchorY = 0.5
							addOnsTitle[i][j].anchorX = 0
							addOnsTitle[i][j]:setTextColor( 83/255, 20/255, 111/255 )
							addOnsScrollView[i]:insert(addOnsTitle[i][j]) 
							
							addOnsCheckBtnUnSelected[i][j] = widget.newButton(
							{
								width = _W/5.5,
								height = _H/28.23,
								defaultFile = imageDirectory4.."unSelected_CheckBox1.png",
								overFile = imageDirectory4.."unSelected_CheckBox1.png",
								label = GBCLanguageCabinet.getText("AddLabel",_LanguageKey),
								font = _FontArr[6],
								fontSize = _H/50,
								labelColor = { default={1,1,1,1}, over={1,1,1,1} },
							}
							)
							addOnsCheckBtnUnSelected[i][j].x = _W/1.15
							addOnsCheckBtnUnSelected[i][j].id = i.."//"..j
							addOnsCheckBtnUnSelected[i][j]:addEventListener( "tap", onUNSelectAddOns  )
							addOnsCheckBtnUnSelected[i][j].y = addOnsRow[i][j].y
							addOnsScrollView[i]:insert(addOnsCheckBtnUnSelected[i][j])
							
							addOnsCheckBtnSelected[i][j] = widget.newButton(
							{
								width = _W/5.5,
								height = _H/28.23,
								defaultFile = imageDirectory4.."Selected_CheckBox2.png",
								overFile = imageDirectory4.."Selected_CheckBox2.png",
								label = GBCLanguageCabinet.getText("RemoveLabel",_LanguageKey),
								font = _FontArr[6],
								fontSize = _H/50,
								labelColor = { default={1,1,1,1}, over={1,1,1,1} },
							}
							)
							addOnsCheckBtnSelected[i][j].x = _W/1.15
							addOnsCheckBtnSelected[i][j].id = i.."//"..j
							addOnsCheckBtnSelected[i][j]:addEventListener( "tap", onSelectAddOns )
							addOnsCheckBtnSelected[i][j].y = addOnsRow[i][j].y
							addOnsCheckBtnSelected[i][j].isVisible = false
							addOnsScrollView[i]:insert(addOnsCheckBtnSelected[i][j])
							
							roundDigit(selectedProductDetails.options[i].options[j].sub_amount)
							
							local priceValue = "+$ "..make2Digit(tonumber(digValue3) )
							addOnsPrice[i][j] = display.newText( priceValue,addOnsCheckBtnUnSelected[i][j].x - addOnsCheckBtnUnSelected[i][j].width/2 - _W/108,addOnsRow[i][j].y,_FontArr[7], _H/36.79)
							addOnsPrice[i][j].anchorY = 0.5
							addOnsPrice[i][j].anchorX = 1
							addOnsPrice[i][j]:setTextColor( 0 )
							addOnsScrollView[i]:insert(addOnsPrice[i][j]) 
							
						end
						
						addOnsScrollView[i].height = (#selectedProductDetails.options[i].options *2 ) * _H/9.6
						
						abc = 0
						abc = yPosToPlaceNote + ((#selectedProductDetails.options[i].options) * _H/13.15) + ((#selectedProductDetails.options[i].options) * _H/13.15)/4
						
						if(height > abc) then
							
						else
							height = abc
						end
						
						if( #selectedProductDetails.options == 1 and tonumber(selectedProductDetails.has_variety) < 1 ) then
							
							if(height > yPosToPlaceNote) then
								yPosToPlaceNote = height + _H/12
							else
							
							end
							
						end
						
					end
					
					RectOnTop[i] = display.newRect(_W/2,addOnsScrollView[i].y ,_W,addOnsScrollView[i].height)
					RectOnTop[i].id = i
					RectOnTop[i]:setFillColor( 1,1,1,0.01 )
					RectOnTop[i]:addEventListener("touch",onTouchRect)
					RectOnTop[i].isVisible = false
					VariableTable.productNewScrollView:insert(RectOnTop[i])
					
					if _EditFlag == true then
						if #_EditProductDetails.extraItems > 0 then
							if #selectedProductDetails.options[i].options > 0 then
								for j = 1, #selectedProductDetails.options[i].options do
									if _EditProductDetails.extraItems[i].sub_name == addOnsTitle[i][j].text then
										roundDigit((tonumber(_EditProductDetails.extraItems[i].sub_amount)*tonumber(VariableTable.QuantityLabel.text)))
										local priceValue = "+$ "..make2Digit(tonumber(digValue3) )
										addOnsPrice[i][j].text = priceValue
										addOnsCheckBtnUnSelected[i][j].isVisible = false
										addOnsCheckBtnSelected[i][j].isVisible = true
										break
									end
								end
							end
						end
					end
					
				end
				
			end
			
			local m
			if(tonumber(selectedProductDetails.no_of_option) > 0) then
				 m = #selectedProductDetails.options + 1
			else
				m = 1
				sawAllOptionFlag = true
			end
			
			if(tonumber(selectedProductDetails.has_variety) > 0) then
				if(#selectedProductDetails.varieties > 0) then
					
					addOnsScrollView[m] = widget.newScrollView
					{
						top = VariableTable.ProductDescri.y + VariableTable.ProductDescri.height + _H/96,
						left = 0,
						width = _W,
						height = _H/4.6,
						scrollWidth = _W,
						id = m,
						backgroundColor = { 0,0,0,0},
						listener = optionsScrollListener
					}
					VariableTable.productNewScrollView:insert(addOnsScrollView[m])
					addOnsScrollView[m].isVisible = false
					
					addOnsRow[m] = { }
					addOnsTitle[m] = { }
					addOnsCheckBtnUnSelected[m] = { }
					addOnsCheckBtnSelected[m] = { }
					addOnsPrice[m] = { }
					
					if(tonumber(selectedProductDetails.has_variety) > 0) then
						
						for j = 1, selectedProductDetails.has_variety do
							if(j == 1) then
								addOnsRow_first = display.newImageRect(imageDirectory4.."AddOnsBg.png",_W,_H/13.15)
								addOnsRow_first.x = _W/2
								addOnsRow_first.y = _H/192 + addOnsRow_first.height/2
								addOnsScrollView[m]:insert( addOnsRow_first )
								
								addOnsTitle_first = display.newText(GBCLanguageCabinet.getText("SizeLabel",_LanguageKey),_W/2,addOnsRow_first.y,_FontArr[6], _H/36.79)
								addOnsTitle_first.anchorY = 0.5
								addOnsTitle_first:setTextColor( 206/255, 23/255, 100/255 )
								addOnsScrollView[m]:insert(addOnsTitle_first) 
								
								if( _LanguageKey == "ru" or _LanguageKey == "uk") then
									forwardBtnTextSize = _H/50
									forwardButtonSize = _H/7.5
									backButtonSize = _H/7.5
								elseif( _LanguageKey == "ar" ) then
									forwardBtnTextSize = _H/60
									forwardButtonSize = _H/10
									backButtonSize = _H/10
								elseif( _LanguageKey == "it" ) then
									forwardBtnTextSize = _H/45
									forwardButtonSize = _H/10
									backButtonSize = _H/12
								else
									forwardBtnTextSize = _H/45
									forwardButtonSize = _H/12
									backButtonSize = _H/12
								end
								
								if( m == 1 ) then
									
								else
									
									BackArrow = widget.newButton(
									{
										width = _W/5.5,
										height = _H/28.23,
										defaultFile = imageDirectory4.."Back_Unselected_CheckBox.png",
										overFile = imageDirectory4.."Back_Unselected_CheckBox.png",
										label = GBCLanguageCabinet.getText("BackLabel",_LanguageKey),
										font = _FontArr[6],
										fontSize = _H/50,
										labelColor = { default={1,1,1,1}, over={1,1,1,1} },
										id = m
									}
									)
									BackArrow.x = BackArrow.width/2 + _W/216
									BackArrow.y = addOnsRow_first.y
									BackArrow:addEventListener( "tap", onMoveBack  )
									addOnsScrollView[m]:insert(BackArrow)
									
								end
								
							end
							
							addOnsRow[m][j] = display.newImageRect(imageDirectory4.."AddOnsBg.png",_W,_H/13.15)
							addOnsRow[m][j].x = _W/2
							addOnsRow[m][j].y = _H/192 + (j) * addOnsRow[m][j].height +  addOnsRow[m][j].height/2
							addOnsScrollView[m]:insert( addOnsRow[m][j] )
							
							local addOnTitleValue = ""
							if(tostring(selectedProductDetails.varieties[j].variety_name):len() > 25) then
								addOnTitleValue = tostring(selectedProductDetails.varieties[j].variety_name):sub(1,25)..".."
							else						
								addOnTitleValue = tostring(selectedProductDetails.varieties[j].variety_name)
							end
							
							addOnsTitle[m][j] = display.newText( addOnTitleValue,_W/96,addOnsRow[m][j].y - _H/96,_FontArr[6], _H/36.79)
							addOnsTitle[m][j].anchorY = 0.5
							addOnsTitle[m][j].anchorX = 0
							addOnsTitle[m][j]:setTextColor( 83/255, 20/255, 111/255 )
							addOnsScrollView[m]:insert(addOnsTitle[m][j]) 
							
							addOnsCheckBtnUnSelected[m][j] = widget.newButton(
							{
								width = _W/5.5,
								height = _H/28.23,
								defaultFile = imageDirectory4.."unSelected_CheckBox1.png",
								overFile = imageDirectory4.."unSelected_CheckBox1.png",
								label = GBCLanguageCabinet.getText("AddLabel",_LanguageKey),
								font = _FontArr[6],
								fontSize = _H/50,
								labelColor = { default={1,1,1,1}, over={1,1,1,1} },
							}
							)
							addOnsCheckBtnUnSelected[m][j].x = _W/1.15
							addOnsCheckBtnUnSelected[m][j].id = m.."//"..j
							addOnsCheckBtnUnSelected[m][j]:addEventListener( "tap", onUNSelectVariety )
							addOnsCheckBtnUnSelected[m][j].y = addOnsRow[m][j].y
							addOnsCheckBtnUnSelected[m][j].isVisible = false
							addOnsScrollView[m]:insert(addOnsCheckBtnUnSelected[m][j])
							
							addOnsCheckBtnSelected[m][j] = widget.newButton(
							{
								width = _W/5.5,
								height = _H/28.23,
								defaultFile = imageDirectory4.."Selected_CheckBox2.png",
								overFile = imageDirectory4.."Selected_CheckBox2.png",
								label = GBCLanguageCabinet.getText("RemoveLabel",_LanguageKey),
								font = _FontArr[6],
								fontSize = _H/50,
								labelColor = { default={1,1,1,1}, over={1,1,1,1} },
							}
							)
							addOnsCheckBtnSelected[m][j].x = _W/1.15
							addOnsCheckBtnSelected[m][j].id = m.."//"..j
							addOnsCheckBtnSelected[m][j]:addEventListener( "tap", onSelectVariety )
							addOnsCheckBtnSelected[m][j].y = addOnsRow[m][j].y
							addOnsCheckBtnSelected[m][j].isVisible = false
							addOnsScrollView[m]:insert(addOnsCheckBtnSelected[m][j])
							
							if(selectedProductDetails.discount_applicable == "NO") then
								roundDigit(selectedProductDetails.varieties[j].variety_price)
							else
								roundDigit(selectedProductDetails.varieties[j].discounted_variety_price)
							end
							
							local priceValue = "$ "..make2Digit(tonumber(digValue3) )
							addOnsPrice[m][j] = display.newText( priceValue,addOnsCheckBtnUnSelected[m][j].x - addOnsCheckBtnUnSelected[m][j].width/2 - _W/108 ,addOnsRow[m][j].y,_FontArr[7], _H/36.79)
							addOnsPrice[m][j].anchorY = 0.5
							addOnsPrice[m][j].anchorX = 1
							addOnsPrice[m][j]:setTextColor( 0 )
							addOnsScrollView[m]:insert(addOnsPrice[m][j])
							
							if(j == 1) then
								addOnsCheckBtnUnSelected[m][j].isVisible = false
								addOnsCheckBtnSelected[m][j].isVisible = true
								if(selectedProductDetails.discount_applicable == "NO") then
									if _EditFlag == true then
										actualPrice = _EditProductDetails.variety_price
									else
										actualPrice = selectedProductDetails.varieties[j].variety_price
									end
								else
									if _EditFlag == true then
										actualPrice = _EditProductDetails.variety_price
									else
										actualPrice = selectedProductDetails.varieties[j].discounted_variety_price
									end
								end
								
								if _EditFlag == true then
									selected_variety_id = _EditProductDetails.variety_id
									selected_variety_name = _EditProductDetails.variety_name
									selected_variety_price = actualPrice
								else
									selected_variety_id = selectedProductDetails.varieties[j].id
									selected_variety_name = selectedProductDetails.varieties[j].variety_name
									selected_variety_price = actualPrice
								end
								
							else
								addOnsCheckBtnUnSelected[m][j].isVisible = true
								addOnsCheckBtnSelected[m][j].isVisible = false	
								
							end
							
						end
						
						addOnsScrollView[m].height = (tonumber(selectedProductDetails.has_variety) + 3) * _H/13.15
						
						abc = 0
						abc = yPosToPlaceNote + ((tonumber(selectedProductDetails.has_variety) + 2) * _H/13.15)
						
						if(height > abc) then
							
						else
							height = abc
						end
						
						if(height > yPosToPlaceNote) then
							yPosToPlaceNote = height
						else
							
						end
						
						if _EditFlag == true then
							if #selectedProductDetails.varieties > 0 then
								for j = 1, #selectedProductDetails.varieties do
									if _EditProductDetails.variety_name == addOnsTitle[m][j].text then
										roundDigit((tonumber(_EditProductDetails.variety_price)*tonumber(VariableTable.QuantityLabel.text)))
										local priceValue = "+$ "..make2Digit(tonumber(digValue3) )
										addOnsPrice[m][j].text = priceValue
										addOnsCheckBtnUnSelected[m][j].isVisible = false
										addOnsCheckBtnSelected[m][j].isVisible = true
										if j ~= 1 then
											addOnsCheckBtnUnSelected[m][1].isVisible = true
											addOnsCheckBtnSelected[m][1].isVisible = false
										end
										break
									elseif j == #selectedProductDetails.varieties then
										addOnsCheckBtnUnSelected[m][1].isVisible = true
										addOnsCheckBtnSelected[m][1].isVisible = false
									end
								end
							end
						end
						
					end
					
					RectOnTop[m] = display.newRect(_W/2,addOnsScrollView[m].y ,_W,addOnsScrollView[m].height)
					RectOnTop[m].id = m
					RectOnTop[m]:setFillColor( 0,0,0,0.01 )
					RectOnTop[m]:addEventListener("touch",onTouchRect)
					RectOnTop[m].isVisible = false
					VariableTable.productNewScrollView:insert(RectOnTop[m])
					
				end	
			end
			
			if(#addOnsScrollView > 0) then
				addOnsScrollView[1].isVisible = true
			end
			
			RectOnTop[1].isVisible = true
			addNotesTextBox()
			
			if( #addOnsScrollView == 1 ) then
				sawAllOptionFlag = true
				countTotal() 
			end
			
			return true
		end
    	
        if(selectedProductDetails) then
        	if(selectedProductDetails.item_name:len() > 35) then
        		titleValue = selectedProductDetails.item_name:sub(1,35)..".."
        	else	
        		titleValue = selectedProductDetails.item_name
        	end
        	VariableTable.MenuTitle.text = titleValue
        
        	if(selectedProductDetails.discount_applicable == "NO") then
        		actualPrice = selectedProductDetails.price
        		discountValue = 0
        	else
        		discountValue =  0
        		actualPrice =  tonumber(selectedProductDetails.discounted_price)
        	end
        	
        	if(tonumber(selectedProductDetails.no_of_option) > 0 or tonumber(selectedProductDetails.has_variety) > 0) then
        		
        		showAddOns()
        	else
        		addNotesTextBox()
        		sawAllOptionFlag = true
        	end
        	
        end
        
        yPos = subMenuGroup.y
        
        product_OverRect = display.newRect(_W/2,_H/2,_W,_H)
   		product_OverRect:setFillColor( 0,0,0,0.01 )
   		product_OverRect:addEventListener("touch",onTouchNavigationOverRect)
   		sceneGroup:insert( product_OverRect )
    	product_OverRect.isVisible = false
		
		local function onProductKeyEvent( event )
			if (event.keyName == "back") and (system.getInfo("platformName") == "Android") and event.phase == "up"  then
				if( composer.getSceneName( "current" ) == "Product" ) then
					subMenuGroup.y = yPos
					VariableTable.productNewScrollView.y = yPosScrollView
					native.setKeyboardFocus( nil )
					if( VariableTable.NoteTextBox ) then
						VariableTable.NoteTextBox.isVisible = false
						VariableTable.NoteTextBox.isEditable = false
						VariableTable.NoteTextLabel.text = VariableTable.NoteTextBox.text
						VariableTable.NoteTextLabel.isVisible = true
					end
				end
			end
			return true
		end
		Runtime:addEventListener( "key", onProductKeyEvent)
        
        
        
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        
        if(VariableTable.ProductDescri.height + yPosToPlaceNote > _H/1.25) then
        	ShowArrowFlag = true
        else
        	downArrow.isVisible = false
        	upArrow.isVisible = false
        	ShowArrowFlag = false
        end
        
        local function onCheckAmount()
        	countTotal()
        end
        
        timer.performWithDelay(1000,onCheckAmount)
        
        xView, yView = VariableTable.productNewScrollView:getContentPosition()
        
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
        
        Runtime:removeEventListener( "key", onProductKeyEvent)
        
        if( displayImageTimer ) then
        	timer.cancel( displayImageTimer )
        end
        
        if( downTrans1 ) then
        	transition.cancel( downTrans1 )
        end
        
        if( downTrans2 ) then
        	transition.cancel( downTrans2 )
        end
        
        if( upTrans1 ) then
        	transition.cancel( upTrans1 )
        end
        
        if( upTrans2 ) then
        	transition.cancel( upTrans2 )
        end
        
        
        if(newLabel) then
        	display.remove(newLabel)
        	newLabel = nil
        end
        
        if(menuFlag == 1) then
			menuFlag = 0
			transition.to( navigationGroup, { time=0, x=navigationGroup.x - _W/1.28 } )
			transition.to( productGroup, { time=0, x=productGroup.x - _W/1.28 } )
		end
		
		display.remove(product_OverRect)
		product_OverRect = nil
		
		for i = 1, #addOnsCheckBtnSelected do
			if( addOnsCheckBtnSelected[i] ) then
				display.remove( addOnsCheckBtnSelected[i] )
				addOnsCheckBtnSelected[i] = nil
			end
			if( addOnsCheckBtnUnSelected[i] ) then
				display.remove( addOnsCheckBtnUnSelected[i] )
				addOnsCheckBtnUnSelected[i] = nil
			end
		end
		
		for i = 1, #addOnsScrollView do
			if( addOnsScrollView[i] ) then
				display.remove( addOnsScrollView[i] )
				addOnsScrollView[i] = nil
			end
		end
		
		beginX = nil
		endX = nil
        addOnsRow = { }
 		addOnsTitle = { }
 		addOnsCheckBtnSelected = { }
 		addOnsCheckBtnUnSelected = { }
 		addOnsPrice = { }
 		
 		VariableTable.restaurantAdd.text = ""
        VariableTable.restaurantName.text = ""
        
        if( VariableTable.NoteTextBox ) then
        	VariableTable.NoteTextBox.text = ""
        	display.remove( VariableTable.NoteTextBox )
        	VariableTable.NoteTextBox = nil
        end
        
        
        for i = 1, #VariableTable do
        	if(VariableTable[i]) then
        		display.remove(VariableTable[i])
        		VariableTable[i] = nil
        	end
        end
        
        for i = 1, #p_NavigationVariableTable do
        	if(p_NavigationVariableTable[i]) then
        		display.remove(p_NavigationVariableTable[i])
        		p_NavigationVariableTable[i] = nil
        	end
        end
        
        display.remove(headerGroup)
        headerGroup = nil
        
        yPosToPlaceNote = 0
        height = 0
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
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

-- --------------------------------------------------------------------

return scene