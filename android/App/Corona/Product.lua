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

local originalProductPrice,selected_variety_id,actualPrice
local product_OverRect,beginX,endX
local newLabel


local function onDoNothing( event )

	return true
end

local function countTotal(  )
	if(composer.getSceneName("current") == "Product") then
	print( "actual price ::::>>>> "..actualPrice )
	print( "original product price ::::>>>> "..originalProductPrice )
	roundDigit(actualPrice)
	print( "value is ::::"..digValue3 )
	total = 0
	total = tonumber(VariableTable.QuantityLabel.text) * tonumber(digValue3)
	print(total..">>>>>>>>>>")
	if(tonumber(selectedProductDetails.no_of_option) > 0) then
		--print( "******************" )
		if(#selectedProductDetails.options > 0) then
			--print(#selectedProductDetails.options)
			--print(#addOnsCheckBtnSelected)
			
			for i = 1, #selectedProductDetails.options do
				--print("krishna .. "..i)
				for k = 1, #selectedProductDetails.options[i].options do
					--print("for loop "..k)
					if(addOnsCheckBtnSelected[i][k].isVisible == true) then
						print("got selected oiption...."..k)
						print( selectedProductDetails.options[i].options[k].sub_amount )
						roundDigit(selectedProductDetails.options[i].options[k].sub_amount)
						print( "value frm function is ::: "..digValue3 )
						total = total + (tonumber(digValue3) * tonumber(VariableTable.QuantityLabel.text))
					else
						
					end
				end
			end
		else
			--no Addons available
		end
	end
	print("last total calculated"..total)
	
	
	if( sawAllOptionFlag == true ) then
		
		--VariableTable.AddToCartBtn:setLabel( "$"..make2Digit(total).." "..GBCLanguageCabinet.getText("AddToCartLabel",_LanguageKey) )
		--VariableTable.AddToCartBtn:setEnabled( true )
		VariableTable.AddToCartBtn.isVisible = false
		VariableTable.AddToCartBtn2.isVisible = true
		VariableTable.AddToCartBtn2:setLabel( "$"..make2Digit(total).." "..GBCLanguageCabinet.getText("AddToCartLabel",_LanguageKey) )
		--VariableTable.AddToCartBtn2:setEnabled( true )
		
	else
		
		VariableTable.AddToCartBtn.isVisible = true
		VariableTable.AddToCartBtn2.isVisible = false
		--VariableTable.AddToCartBtn:setLabel( "$"..make2Digit(total) )
		VariableTable.AddToCartBtn.text = "Price : $"..make2Digit(total)
		
	end
	
	
	end
	return true
end

local function onGotoCartPage( event )
	if event.action == "clicked" then
        local i = event.index
        if i == 2 then
            --composer.gotoScene("PlaceOrder")
            composer.gotoScene("menu")
        elseif i == 1 then
            --composer.gotoScene("ProductListPage")
            composer.gotoScene("PlaceOrder")
        end
    end
	return true
end

local function handleAddToCartButtonEvent( event )
	if( event.phase == "ended" ) then
		--print("add item to cart")
		local CartRepeatFlag = 0
		for i = 1,#_CartArray do
			if(_CartArray[i].productID == _selectedProductID and _CartArray[i].variety_id == selected_variety_id) then
				CartRepeatFlag = CartRepeatFlag - 1
			else
				CartRepeatFlag = CartRepeatFlag + 1
			end
		end		
		
		--print(CartRepeatFlag.."//"..#_CartArray)
		if(CartRepeatFlag == #_CartArray) then
			discountValue = 0
			if(VariableTable.NoteTextBox) then
				noteTextBoxValue = VariableTable.NoteTextBox.text
			else
				noteTextBoxValue = ""
			end
			
    		_CartArray[#_CartArray + 1] = { kitchenID = selectedProductDetails.kitchen_id,title = selectedProductDetails.item_name ,productID = _selectedProductID,price = actualPrice,discount = discountValue,variety_id = selected_variety_id ,quantity = VariableTable.QuantityLabel.text, extraItems = extraItemsArr, Note = noteTextBoxValue}
    		--print(#_CartArray)
		else
					
			for i = 1,#_CartArray do
				if(_CartArray[i].productID == _selectedProductID and _CartArray[i].variety_id == selected_variety_id) then
					local q = tonumber(VariableTable.QuantityLabel.text) + _CartArray[i].quantity
					--_CartArray[i] = { id = id, quantity = q}
					
					if(#_CartArray[i].extraItems > 0) then
						for m = 1,#_CartArray[i].extraItems do
							for n = 1,#extraItemsArr do
								if(_CartArray[i].extraItems[m].id == extraItemsArr[n].id) then
									--print("repeat option")
									flag = 1
									break
								else
									flag = 0
								end
							end
							if(flag == 0) then
								--print("new option")
								extraItemsArr[#extraItemsArr + 1] = _CartArray[i].extraItems[m]
							end
						end
					else
					
					end
					discountValue = 0
					if(VariableTable.NoteTextBox) then
						noteTextBoxValue = VariableTable.NoteTextBox.text
					else
						noteTextBoxValue = ""
					end
					
					_CartArray[i] = { kitchenID = selectedProductDetails.kitchen_id,title = selectedProductDetails.item_name ,productID = _selectedProductID,price = actualPrice,discount = discountValue,variety_id = selected_variety_id, quantity = q, extraItems = extraItemsArr, Note = noteTextBoxValue}

					--print(#_CartArray..q)
				end
			end
			
		end
		
		local alert = native.showAlert( "Order added", GBCLanguageCabinet.getText("9Alert",_LanguageKey), { "NO" ,"YES"}, onGotoCartPage )

	end
	return true
end

local function onShowTextBox( event )
	print("show textBox.")
	--if( event.phase == "began" ) then
		
		native.setKeyboardFocus( VariableTable.NoteTextBox )
		VariableTable.NoteTextBox.isVisible = true
		VariableTable.NoteTextBox.isEditable = true
		VariableTable.NoteTextLabel.isVisible = false
	--[[elseif( event.phase == "moved" ) then
		local dy = math.abs( ( event.y - event.yStart ) )
        -- If the touch on the button has moved more than 10 pixels,
        -- pass focus back to the scroll view so it can continue scrolling
        if ( dy > 20 ) then
            VariableTable.productNewScrollView:takeFocus( event )
        end	
		
	end]]--
	return true
end

local function inputListener( event )
    if event.phase == "began" then
        -- user begins editing textBox
        --print( event.text )
       --VariableTable.productNewScrollView.y = VariableTable.productNewScrollView.y - _H/2
	   --headerGroup:toFront()	
	  -- VariableTable.productNewScrollView:scrollTo( "bottom" )
		--subMenuGroup.y =  -_H/2.8
		yPosScrollView = VariableTable.productNewScrollView.y 
		VariableTable.productNewScrollView.y = VariableTable.productNewScrollView.y - _H/4
    elseif event.phase == "ended" or event.phase == "submitted" then
        -- do something with textBox text
        --subMenuGroup.y = yPos
        VariableTable.productNewScrollView.y = yPosScrollView
        native.setKeyboardFocus( nil )
        VariableTable.NoteTextBox.isVisible = false
		VariableTable.NoteTextBox.isEditable = false
		VariableTable.NoteTextLabel.text = VariableTable.NoteTextBox.text
		VariableTable.NoteTextLabel.isVisible = true
		
		if(VariableTable.NoteTextLabel.text == "") then
		
			VariableTable.NoteTextLabel.text = GBCLanguageCabinet.getText("addNotesLabel",_LanguageKey)
		end
		
       -- VariableTable.productNewScrollView:scrollTo( "top" )
    elseif event.phase == "editing" then
        
    end
end

local function handleBackButtonEvent( event )
	
	print(" product Page backBtnis preseddd...................>>> ???".._previousScene)
	if(composer.getSceneName("current") == "Product") then
	if(composer.getSceneName( "previous" ) == "ProductListPage") then
		print("previous scene is product list")
		composer.gotoScene( "ProductListPage" )
	else
		print("previous scene is sub menu")
		composer.gotoScene( _previousScene )
	end
	end
	
	return true
end

--[[
local function handleBackButtonEventTouch( event )
	if event.phase == "began" then
		--print("back to main menu")
		print(" product Page backBtnis preseddd...................>>> ???")
		if(composer.getSceneName("current") == "Product") then
			if(composer.gotoScene( composer.getSceneName( "previous" ) ) == "ProductListPage") then
				print("previous scene is product list")
				composer.gotoScene( "ProductListPage" )
			else
				print("previous scene is sub menu")
				composer.gotoScene( _previousScene )
			end
		end
		--composer.gotoScene( composer.getSceneName( "previous" ) )
	end
	
	return true
end
]]--
--[[
function openNavigationTap( event )
	if(composer.getSceneName("current") == "Product") then
	--print("sdkljasdlkjh alsdlasld6666666666666666")
	 VariableTable.MenuBg:removeEventListener("tap",openNavigationTap)
    -- VariableTable.MenuBg:removeEventListener("touch",openNavigationTouch)
     
     local function addEvents( event )

	 	VariableTable.MenuBg:addEventListener("tap",openNavigationTap)
    	--VariableTable.MenuBg:addEventListener("touch",openNavigationTouch)
    	
		return true
	end
	
	if(menuFlag == 0) then
		
		navigationGroup.x = navigationGroup.x + _W/1.28
		subMenuGroup.x = subMenuGroup.x + _W/1.28
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
		--print("sdkljasdlkjh alsdlasld6666666666666666")
		if(composer.getSceneName("current") == "Product") then
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
end]]--

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
    
   -- _HotelName = "Jamie’s  Italaian"
   -- _HotelAddress = "21st Street, New York \nZip Code 41108, United States"
    
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
    
    
    --[[p_NavigationVariableTable.ProfileBg = display.newImageRect(imageDirectory.."ProfileBg.png",_W/1.19,_H/9.05)
    p_NavigationVariableTable.ProfileBg.x = -_W/1.28  
    p_NavigationVariableTable.ProfileBg.y =  _H/3.25 + p_NavigationVariableTable.ProfileBg.height/2 
    p_NavigationVariableTable.ProfileBg.anchorX = 0 
    navigationGroup:insert( p_NavigationVariableTable.ProfileBg )
    
    p_NavigationVariableTable.ProfilePicBg = display.newImageRect(imageDirectory.."ProfilePicBg.png",_W/7.39,_H/13.06)
    p_NavigationVariableTable.ProfilePicBg.x = -_W/1.28 + _W/27  
    p_NavigationVariableTable.ProfilePicBg.y =  p_NavigationVariableTable.ProfileBg.y
    p_NavigationVariableTable.ProfilePicBg.anchorX = 0 
    navigationGroup:insert( p_NavigationVariableTable.ProfilePicBg )]]--
    
    --_fName = "Krishna Maru"
   -- _UserID = "krishnamaru123@gmail.com"
    
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
	--if(event.phase == "began") then
		--print("UNselect product addon")
		--i.."//"..j
		local i = event.target.id:sub(1,string.find( event.target.id, "//" ) - 1)
		--print(i)
		local j = event.target.id:sub(string.find( event.target.id, "//" ) + 2,event.target.id:len())
		--print(j)
		
		addOnsCheckBtnSelected[tonumber(i)][tonumber(j)].isVisible = false
		addOnsCheckBtnUnSelected[tonumber(i)][tonumber(j)].isVisible = true
		--addOnsPrice[tonumber(i)][tonumber(j)]:setTextColor( 0,0,0,0.5 )
		--addOnsPrice[tonumber(i)][tonumber(j)]:setTextColor( 57/255, 181/255, 74/255 )
		
		for k = 1, #extraItemsArr do
			if(extraItemsArr[k].id == selectedProductDetails.options[tonumber(i)].options[tonumber(j)].id) then
				
				table.remove(extraItemsArr,i)
				--print(#extraItemsArr)
				break
			end
		end
		
		countTotal()
		
		
	--end
	return true
end

local function onUNSelectAddOns( event )
	--if(event.phase == "began") then
		print("select product addon")
		local i = event.target.id:sub(1,string.find( event.target.id, "//" ) - 1)
		--print(i)
		local j = event.target.id:sub(string.find( event.target.id, "//" ) + 2,event.target.id:len())
		--print(j)
		
		--print(addOnsCheckBtnSelected[tonumber(i)][tonumber(j)].id)
		
		for k = 1, #addOnsCheckBtnSelected[tonumber(i)] do
			addOnsCheckBtnSelected[tonumber(i)][tonumber(k)].isVisible = false
			addOnsCheckBtnUnSelected[tonumber(i)][tonumber(k)].isVisible = true
			--addOnsPrice[tonumber(i)][tonumber(k)]:setTextColor( 0,0,0,0.5 )
			--addOnsPrice[tonumber(i)][tonumber(k)]:setTextColor( 57/255, 181/255, 74/255 )
			
			-- remove all options from this slider first
			for n = 1,#extraItemsArr do
				if( extraItemsArr[n] == selectedProductDetails.options[tonumber(i)].options[tonumber(k)]) then
				
					table.remove(extraItemsArr,i)
					break
					
				end
			end
			
		end
		
		addOnsCheckBtnSelected[tonumber(i)][tonumber(j)].isVisible = true
		addOnsCheckBtnUnSelected[tonumber(i)][tonumber(j)].isVisible = false
		--addOnsPrice[tonumber(i)][tonumber(j)]:setTextColor( 206/255 ,23/255 ,100/255 )
		--addOnsPrice[tonumber(i)][tonumber(j)]:setTextColor( 57/255 ,181/255 ,74/255 )
			
		extraItemsArr[ #extraItemsArr + 1 ] = selectedProductDetails.options[tonumber(i)].options[tonumber(j)]
		--print(#extraItemsArr)
		
		countTotal()
		
	
	--end
	return true
end

local function onSelectVariety( event )
	--if(event.phase == "began") then
		--print("UNselect product addon")
		--i.."//"..j
		local i = event.target.id:sub(1,string.find( event.target.id, "//" ) - 1)
		--print(i)
		local j = event.target.id:sub(string.find( event.target.id, "//" ) + 2,event.target.id:len())
		--print(j)
		
		addOnsCheckBtnSelected[tonumber(i)][tonumber(j)].isVisible = false
		addOnsCheckBtnUnSelected[tonumber(i)][tonumber(j)].isVisible = true
		--addOnsPrice[tonumber(i)][tonumber(j)]:setTextColor( 0,0,0,0.5 )
		--addOnsPrice[tonumber(i)][tonumber(j)]:setTextColor( 57/255 ,181/255 ,74/255 )
		local count = 0
		for k = 1, #addOnsCheckBtnSelected[tonumber(i)] do
			addOnsCheckBtnSelected[tonumber(i)][tonumber(k)].isVisible = false
			count = count + 1
		end
		if(count == #addOnsCheckBtnSelected[tonumber(i)]) then
			addOnsCheckBtnSelected[tonumber(i)][1].isVisible = true
			addOnsCheckBtnUnSelected[tonumber(i)][1].isVisible = false
			--addOnsPrice[tonumber(i)][1]:setTextColor( 206/255 ,23/255 ,100/255 )
			--addOnsPrice[tonumber(i)][1]:setTextColor( 57/255 ,181/255 ,74/255 )
			
			if(selectedProductDetails.discount_applicable == "NO") then
				actualPrice = selectedProductDetails.varieties[1].variety_price
			else
				actualPrice = selectedProductDetails.varieties[1].discounted_variety_price
			end
			--originalProductPrice = selectedProductDetails.varieties[1].variety_price
			selected_variety_id = selectedProductDetails.varieties[1].id
		else
			print("product prize changed....")
			if(selectedProductDetails.discount_applicable == "NO") then
				actualPrice = selectedProductDetails.varieties[tonumber(j)].variety_price
			else
				actualPrice = selectedProductDetails.varieties[tonumber(j)].discounted_variety_price
			end
			--originalProductPrice = selectedProductDetails.varieties[tonumber(j)].variety_price
			selected_variety_id = selectedProductDetails.varieties[tonumber(j)].id
			--print("original product prize.."..originalProductPrice)
		end
		
		
		countTotal()
		
		
	--end
	return true
end

local function onUNSelectVariety( event )
	--if(event.phase == "began") then
		print("select product variety ....................")
		local i = event.target.id:sub(1,string.find( event.target.id, "//" ) - 1)
		--print(i)
		local j = event.target.id:sub(string.find( event.target.id, "//" ) + 2,event.target.id:len())
		--print(j)
		
		--print(addOnsCheckBtnSelected[tonumber(i)][tonumber(j)].id)
		
		for k = 1, #addOnsCheckBtnSelected[tonumber(i)] do
			addOnsCheckBtnSelected[tonumber(i)][tonumber(k)].isVisible = false
			addOnsCheckBtnUnSelected[tonumber(i)][tonumber(k)].isVisible = true
			--addOnsPrice[tonumber(i)][tonumber(k)]:setTextColor( 0,0,0,0.5 )
			--addOnsPrice[tonumber(i)][tonumber(k)]:setTextColor( 57/255 ,181/255 ,74/255 )
		end
		
		addOnsCheckBtnSelected[tonumber(i)][tonumber(j)].isVisible = true
		addOnsCheckBtnUnSelected[tonumber(i)][tonumber(j)].isVisible = false
		--addOnsPrice[tonumber(i)][tonumber(j)]:setTextColor( 206/255 ,23/255 ,100/255 )
		--addOnsPrice[tonumber(i)][tonumber(j)]:setTextColor( 57/255 ,181/255 ,74/255 )
		
		if(selectedProductDetails.discount_applicable == "NO") then
			actualPrice = selectedProductDetails.varieties[tonumber(j)].variety_price
		else
			actualPrice = selectedProductDetails.varieties[tonumber(j)].discounted_variety_price
		end
		--actualPrice = originalProductPrice - discountValue
		selected_variety_id = selectedProductDetails.varieties[tonumber(j)].id
		
		countTotal()
		
	
	--end
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
    
    --[[local rowIconBG = display.newImageRect(row, imageDirectory4.."Icon_Bg.png",_W/9.15,_H/16.27)
	rowIconBG.x = _W/10.90
	rowIconBG.y = rowHeight * 0.5
	]]--
			
	--[[local rowIcon = display.newImageRect(row, "SubCategory"..rowTitles[row.index].id..".png",system.TemporaryDirectory,_W/10.8,_H/19.2)
	rowIcon.x = _W/27
	rowIcon.y = groupContentHeight * 0.5
	rowIcon.anchorX = 0
    ]]--
    
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
	
	--local priceValue = "+$ "..tostring(tonumber(selectedProductDetails.options[i].amount) * tonumber(VariableTable.QuantityLabel.text))
	local priceValue = "+$ 0"
	addOnsPrice[i] = display.newText( priceValue,_W/1.16,rowHeight * 0.5,_FontArr[7], _H/49.06)
    addOnsPrice[i].anchorY = 0.5
    addOnsPrice[i].anchorX = 1
    addOnsPrice[i]:setTextColor( 0 ) --57/255 ,181/255 ,74/255 ) --0,0,0,0.5 )
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
		
		--print("decrement quantity")
		if(VariableTable.QuantityLabel.text == "1" or VariableTable.QuantityLabel.text == 1) then
			--print("quantity is 1")
		
		else
			VariableTable.QuantityLabel.text = tonumber(VariableTable.QuantityLabel.text) - 1
			if(tonumber(selectedProductDetails.no_of_option) > 0) then
				if(#selectedProductDetails.options > 0) then
					for i = 1, #selectedProductDetails.options do
						--if(addOnsCheckBtnSelected[i].isVisible == true) then
						for k = 1, #selectedProductDetails.options[i].options do 		
							addOnsPrice[i][k].text = "+$ "..make2Digit(tostring(tonumber(selectedProductDetails.options[i].options[k].sub_amount) * tonumber(VariableTable.QuantityLabel.text)))
						--else
						
						
						--end
						end
					end
				else
			
			
				end
			end
		end
	
		countTotal()
	end
	return true
end


local function onIncrementProductQuantity( event )
	if(event.phase == "began") then
		
		--print("increment quantity")
		VariableTable.QuantityLabel.text = tonumber(VariableTable.QuantityLabel.text) + 1
		if(tonumber(selectedProductDetails.no_of_option) > 0) then
				if(#selectedProductDetails.options > 0) then
					--print(" OPTIONS ARE AVAILABLE")
					for i = 1, #selectedProductDetails.options do
						--print("FOR LOOP FOR Main OPTIONS")
						for k = 1, #selectedProductDetails.options[i].options do 
							--print(" FOR LOOP FOR SUB OPTIONS")		
							addOnsPrice[i][k].text = "+$ "..make2Digit(tostring(tonumber(selectedProductDetails.options[i].options[k].sub_amount) * tonumber(VariableTable.QuantityLabel.text)))
						end
					end
				else
			
			
				end
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
	--if( event.phase == "ended" ) then
		if( event.target.id == "home" ) then
			--print( "Home button is pressed..........." )
			--print("a")
			--print( composer.getSceneName("current") )
			--print( menuFlag.."%%%%%%%%%%" )
			if(composer.getSceneName("current") == "Product") then
				--print("b")
				if(menuFlag == 0) then
					--print("c")
					product_OverRect.isVisible = true
					navigationGroup.x = navigationGroup.x + _W/1.28
					productGroup.x = productGroup.x + _W/1.28
					menuFlag = 1
					
				elseif(menuFlag == 1) then
					--print("d")
					product_OverRect.isVisible = false
					navigationGroup.x = navigationGroup.x - _W/1.28
					productGroup.x = productGroup.x - _W/1.28
					menuFlag = 0
				
				end
			end
			
		end
		
	--end
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
   	 	print( "Scroll complete!" )
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
   	 	print( "Scroll complete!" )
	end
	
	--[[timer.performWithDelay( 500, function()
   	VariableTable.productNewScrollView:scrollToPosition
   	{ y=(VariableTable.productNewScrollView._view.height-VariableTable.productNewScrollView.height+50)*-1, time=200 }
	end )	]]--
	
	VariableTable.productNewScrollView:scrollToPosition
	{
    	x = xView,--0,
    	y =  yView  ,--VariableTable.MenuTitleBg.y + VariableTable.MenuTitleBg.height/2 ,
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
	if ( event.direction == "up" ) then print( "Reached bottom limit" )
		--downArrow.isVisible = false
    elseif ( event.direction == "down" ) then print( "Reached top limit" )
    	if(VariableTable.ProductDescri.height + yPosToPlaceNote > _H/1.25) then
        	downArrow.isVisible = true
        	upArrow.isVisible = false
        else
        	downArrow.isVisible = false
        	upArrow.isVisible = false
        end
    	
    end
    if ( event.limitReached ) then
        if ( event.direction == "up" ) then print( "Reached bottom limit" )
        	
        	if(VariableTable.ProductDescri.height + yPosToPlaceNote > _H/1.25) then
        		downArrow.isVisible = false
        		upArrow.isVisible = true
        	else
        		downArrow.isVisible = false
        		upArrow.isVisible = false
        	end
        elseif ( event.direction == "down" ) then print( "Reached top limit" )
       		
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
        --print(#productData)
        print("Product Page........................................")
        
        
        _PreviousSceneforSetting = composer.getSceneName( "current" )
    	--print( "previous scene name for seetings :::>>>>".._PreviousSceneforSetting )
     	
     	_PreviousSceneforOrder = composer.getSceneName( "current" )
    	--print( "previous scene name for order :::>>>>".._PreviousSceneforOrder )
        
    selected_variety_id = ""    
    menuFlag = 0
    extraItemsArr = { }
    originalProductPrice = 0
    actualPrice = 0
    discountValue = 0
    sawAllOptionFlag = false
    
    addOnsScrollView = { }
    
    for i = 1, #productData do
        	--print(productData[i].productDetail)
        	
    		--for j = 1, #productData[i].productDetail do
        		--print(productData[i].productDetail.id.."//".._selectedProductID)
        		if(productData[i].productDetail.id == _selectedProductID) then
        			--print("got same data")
        			selectedProductDetails = productData[i].productDetail
        			
        			break
        		end
        	--end
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
     
     --[[
     VariableTable.MenuBtn = display.newImageRect(imageDirectory2.."Home_Btn.png",_W/16.11,_H/28.65)
     VariableTable.MenuBtn.x = _W/29.18 + VariableTable.MenuBtn.width/2
     VariableTable.MenuBtn.y = _H/41.73 + VariableTable.MenuBtn.height/2
     VariableTable.MenuBtn:addEventListener("tap",openNavigationTap)
     -- VariableTable.MenuBtn:addEventListener("touch",openNavigationTouch)
     headerGroup:insert(VariableTable.MenuBtn)
    
     VariableTable.MenuBg = display.newRect(VariableTable.MenuBtn.x, VariableTable.MenuBtn.y, _W/16.11 + _W/54,_H/28.65 + _H/96)
     VariableTable.MenuBg:setFillColor( 1,1,1,0.01 )
     VariableTable.MenuBg:addEventListener("tap",openNavigationTap)
     VariableTable.MenuBg:addEventListener("touch",openNavigationTouch)
     headerGroup:insert(VariableTable.MenuBg)
     ]]--
     
    homeBtn = widget.newButton
	{
    	width = _W/13.5,
    	height = _H/24,
    	defaultFile = imageDirectory2.."Home_Btn.png",
   		overFile = imageDirectory2.."Home_Btn.png",
    	id = "home",
    	--onEvent = handleButtonEvent
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
     VariableTable.MenuTitle:setFillColor( 1 )
     headerGroup:insert( VariableTable.MenuTitle )
     
     --[[
     VariableTable.backBtn = display.newImageRect( imageDirectory3.."Back_Btn.png", _W/15.42, _H/33.10 )
     VariableTable.backBtn.x = _W/36 + VariableTable.backBtn.width/2
     VariableTable.backBtn.y = VariableTable.MenuTitleBg.y
     headerGroup:insert( VariableTable.backBtn )
       			
	 VariableTable.backBg = display.newRect( VariableTable.backBtn.x, VariableTable.backBtn.y, VariableTable.backBtn.width + _W/21.6, VariableTable.backBtn.height + _H/38.4 )
	 VariableTable.backBg:setFillColor( 83/255, 20/255, 111/255 , 0.01 )
	 VariableTable.backBg:addEventListener( "tap", handleBackButtonEvent )
	 VariableTable.backBg:addEventListener( "touch", handleBackButtonEventTouch )
	 headerGroup:insert( VariableTable.backBg )
	 VariableTable.backBtn:toFront() 
	 ]]--
	 
	 VariableTable.backBtn = widget.newButton
	{
    	width = _W/9,
    	height = _H/14.76,
    	defaultFile = imageDirectory3.."Back_Btn1.png",
   		overFile = imageDirectory3.."Back_Btn1.png",
    	id = "back",
    	--onEvent = handleButtonEvent
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
    	backgroundColor = { 1, 0, 0, 1 }, --{ 1, 0.5, 0.8, 0.2 },
    	bottomPadding = _H/38.4,
    	listener = productNewScrollListner
	}
	subMenuGroup:insert( VariableTable.productNewScrollView )
	 
	 
	 --[[ VariableTable.OrderBtn = widget.newButton
		{
    		width = _W/5.51,
    		height = _H/24,
    		defaultFile = "images/cartBtn2.png",
   			overFile = "images/cartBtn2.png",
   			label = "CART",
   			labelXOffset = 20,
   			labelYOffset = -3,
   			labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
   			font = _FontArr[1],
   			fontSize = _H/60,
    		id = "PLACE ORDER",
    		onEvent = handleOrdersButtonEvent
		}
		VariableTable.OrderBtn.x = _W - _W/72
		VariableTable.OrderBtn.y = VariableTable.backBg.y
		VariableTable.OrderBtn.anchorX = 1
		headerGroup:insert( VariableTable.OrderBtn )]]--
	 
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
     	VariableTable.ProductImage.y = _H/192  --VariableTable.MenuTitleBg.y + VariableTable.MenuTitleBg.height/2 + _H/960
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
     	VariableTable.backRect.y = _H/192 -- VariableTable.MenuTitleBg.y + VariableTable.MenuTitleBg.height/2 + _H/960
     	VariableTable.backRect.anchorY = 0
     	VariableTable.backRect:setFillColor( 1 )
     	VariableTable.productNewScrollView:insert( VariableTable.backRect )
    	
     	VariableTable.ProductImage = display.newImage( "Product".._selectedProductID..".png", system.TemporaryDirectory )
     	VariableTable.ProductImage.x = _W/2
     	VariableTable.ProductImage.y = _H/192 -- VariableTable.MenuTitleBg.y + VariableTable.MenuTitleBg.height/2 + _H/960
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
     
     	--newLabel = display.newImageRect(imageDirectory4.."NewLabelBg2.png", _W/6.75, _H/12.15)
     	newLabel = display.newImageRect(imageDirectory4.."NewLabelBg.png", _W/3.28, _H/6)
	 	newLabel.x = VariableTable.backRect.x - VariableTable.backRect.width/2 
     	newLabel.y = VariableTable.backRect.y - _H/96
     	newLabel.anchorX = 0
     	newLabel.anchorY = 0
     	VariableTable.productNewScrollView:insert( newLabel )
     	
     	--[[discountLabel = display.newImageRect(imageDirectory4.."discountLabel.png",_W/6.75, _H/9.64)
	 	discountLabel.x = VariableTable.backRect.x - VariableTable.backRect.width/2  --VariableTable.backRect.x - VariableTable.backRect.width/2
     	discountLabel.y = VariableTable.backRect.y 
     	discountLabel.anchorX = 0
     	discountLabel.anchorY = 0
     	--discountLabel:setFillColor( 57/255, 181/255, 74/255 )
     	subMenuGroup:insert( discountLabel )]]--
     	print("first make2Digit func called")
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
     
     --[[VariableTable.productDetailsScrollView = widget.newScrollView
	{
   		top = _H/2 - _H/6.5,
    	left = 0,
    	width = _W,
    	height = _H/8,
    	scrollWidth = 600,
    	scrollHeight = 800,
    	hideBackground = true,
    	horizontalScrollDisabled = true,
    	backgroundColor = { 1, 0.5, 0.8, 0.2 },
    	bottomPadding = _H/96
    	
	}
	VariableTable.productNewScrollView:insert( VariableTable.productDetailsScrollView )
     ]]--
     
     --[[VariableTable.ProductDescriBG = display.newRect( _W/2, _H/2, _W, _H/7.11 )
     VariableTable.ProductDescriBG.y =  VariableTable.MenuTitleBg.y + VariableTable.MenuTitleBg.height/2 + _H/960 + _H/3.14 
     VariableTable.ProductDescriBG.anchorY = 1
     VariableTable.ProductDescriBG:setFillColor( 0,0,0,0.5 )
     VariableTable.productNewScrollView:insert( VariableTable.ProductDescriBG )]]--
     
     --[[VariableTable.ProductDescriLabel = display.newText( "Product Descripation" , _W/27, _H/2 - VariableTable.ProductDescriBG.height * 0.98 , _FontArr[6], _H/36.79 )
     VariableTable.ProductDescriLabel.anchorX = 0  
     VariableTable.ProductDescriLabel:setFillColor( 1 )
     subMenuGroup:insert( VariableTable.ProductDescriLabel )]]--
     
     local descriptionValue
     if(selectedProductDetails.item_description) then
    --[[ if(selectedProductDetails.item_description:len() > 200) then
     	descriptionValue = selectedProductDetails.item_description:sub(1,200)..".."
     
     else]]--
     	descriptionValue = selectedProductDetails.item_description
     
    -- end
     else
     	descriptionValue = "NA"
     end
     
     VariableTable.ProductDescri = display.newText( descriptionValue, _W/27,VariableTable.ProductImage.y + VariableTable.ProductImage.height + _H/48 ,_W/1.08,0, _FontArr[26], _H/40 ) -- _H/36.79
     VariableTable.ProductDescri.anchorX = 0  
     VariableTable.ProductDescri.anchorY = 0  
     VariableTable.ProductDescri:setFillColor( 83/255, 20/255, 111/255 )
     VariableTable.productNewScrollView:insert( VariableTable.ProductDescri )
     --VariableTable.productDetailsScrollView:toFront()
     
     VariableTable.QuantityLabel2 = display.newText( GBCLanguageCabinet.getText("QuantityLabel",_LanguageKey), _W/54, _H - _H/5.5 - _H/17.28 +  _H/9 , _FontArr[6], _H/38.4 )
     VariableTable.QuantityLabel2.anchorX = 0  
     VariableTable.QuantityLabel2:setTextColor( 83/255, 20/255, 111/255 )
     subMenuGroup:insert( VariableTable.QuantityLabel2 )
    
     VariableTable.IncrementIcon = display.newImageRect( imageDirectory4.."IncrementBtn.png",  _W/5.4, _H/9.6 )
     VariableTable.IncrementIcon.x = _W/2 + _W/6 --_W/2 - _W/8
     VariableTable.IncrementIcon.y = VariableTable.QuantityLabel2.y
     VariableTable.IncrementIcon.id = ""
     VariableTable.IncrementIcon:addEventListener("touch",onIncrementProductQuantity)
     subMenuGroup:insert(VariableTable.IncrementIcon)
     
     VariableTable.QuantityLabel = display.newText( "1", _W/2, VariableTable.IncrementIcon.y , _FontArr[6], _H/30 )
     VariableTable.QuantityLabel.anchorX = 0  
     VariableTable.QuantityLabel:setFillColor( 0 )
     subMenuGroup:insert( VariableTable.QuantityLabel )
     
     VariableTable.DecrementIcon = display.newImageRect( imageDirectory4.."DecrementBtn.png", _W/7.2, _H/12.8 )
     VariableTable.DecrementIcon.x = _W/2 - _W/8 --_W/2 + _W/6
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
    
     VariableTable.BottomBg = display.newImageRect( imageDirectory4.."BottomBg.png",  _W, _H/12 ) --_H/9.32
     VariableTable.BottomBg.x = _W/2
     VariableTable.BottomBg.y = _H
     VariableTable.BottomBg.anchorY = 1
     subMenuGroup:insert( VariableTable.BottomBg )
     
     	--VariableTable.AddToCartBtn = widget.newButton
--		{
--   	 		width = _W/1.08,
--    		height = _H/16.13,
--    		defaultFile = imageDirectory3.."SinUp_Btn.png",
--    		overFile = imageDirectory3.."SinUp_Btn.png",
--    		label = "",
--    		labelColor = { default={ 1, 1, 1 }, over={ 1,1,1 } },
--    		fontSize = _H/30,
--    		font = _FontArr[6],
--    		labelYOffset = _H/275,
--    		-- FONT AND FONT SIZE 
--    		--onEvent = handleAddToCartButtonEvent
--		}
--		VariableTable.AddToCartBtn.x = _W/2
--		VariableTable.AddToCartBtn.y = _H - _H/96 - VariableTable.AddToCartBtn.height/2
--        subMenuGroup:insert(VariableTable.AddToCartBtn)
        
        --VariableTable.AddToCartBtn:setEnabled( false )
        
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
    		-- FONT AND FONT SIZE 
    		onEvent = handleAddToCartButtonEvent
		}
		VariableTable.AddToCartBtn2.x = _W/2
		VariableTable.AddToCartBtn2.y = _H - _H/96 - VariableTable.AddToCartBtn2.height/2
        subMenuGroup:insert(VariableTable.AddToCartBtn2)
        
        --VariableTable.AddToCartBtn2:setEnabled( false )
        VariableTable.AddToCartBtn2.isVisible = false
     
     	local function optionsScrollListener( event )
     		----print(event.target.id)
     		----print(#addOnsScrollView)
     		
     		if ( event.phase == "began" ) then --print( "Scroll view was touched" )
     			i = event.target.id
     			--print(i)
     		end
     		if ( event.direction == "up" ) then --print( "Reached top limit" )
     			--VariableTable.productNewScrollView:takeFocus( event )
     			
       	 	elseif ( event.direction == "down" ) then --print( "Reached bottom limit" )
       	 		--VariableTable.productNewScrollView:takeFocus( event )
       	 		
       	 	end
     		
     		if ( event.limitReached ) then
    
     		if ( event.direction == "up" ) then --print( "Reached top limit" )
     			--VariableTable.productNewScrollView:takeFocus( event )
     			
       	 	elseif ( event.direction == "down" ) then --print( "Reached bottom limit" )
       	 		--VariableTable.productNewScrollView:takeFocus( event )
        	elseif ( event.direction == "left" ) then --print( "Reached left limit" )
        		if(addOnsScrollView[tonumber(i) + 1] ~= nil) then
        			--print("moved left")
        			addOnsScrollView[i].isVisible = false
        			addOnsScrollView[i + 1].isVisible = true
        			RectOnTop[i].isVisible = false
        			RectOnTop[i+1].isVisible = true
        				
        				print( tostring(i + 1)..".......>>>>"..tostring(#addOnsScrollView) )
        				if i + 1 == #addOnsScrollView then
        					sawAllOptionFlag = true
        					countTotal()
        				end
        				
        		end
        	elseif ( event.direction == "right" ) then --print( "Reached right limit" )
        		if(addOnsScrollView[tonumber(i) - 1] ~= nil) then
        			--print("moved right")
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
        		--print("moved left")
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
        		--print("moved right")
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
        	-- If the touch on the button has moved more than 10 pixels,
       	 	-- pass focus back to the scroll view so it can continue scrolling
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
         
         
         print("height is......................................................"..height)
     	if(height) then
     		print("height available")
     		if(height > yPosToPlaceNote) then
				yPosToPlaceNote = height
			else
						
			end
		end
         
         if(_isNotesVisible ==  "1") then
     
     		VariableTable.NoteBg = display.newImageRect( imageDirectory4.."AddOnsNoteBg.png", _W, _H/8.64 )
     		VariableTable.NoteBg.x = _W/2
     		VariableTable.NoteBg.y = yPosToPlaceNote + _H/192 --_H - _H/5.5 --_H/9.32
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
    		
    		--quantityYpos = VariableTable.NoteBg.y + VariableTable.NoteBg.height + _H/19.2
    		
    	 else
    		
    		--quantityYpos = yPosToPlaceNote + _H/9.6
    		
    	end
    	
    	--[[ print( "ypos for quantity"..tostring(quantityYpos) )
    	 
    	 if( quantityYpos < _H - _H/5.5 - _H/8 ) then
    	 	print("no data {{{{{{{{{{{{{{{{{{{{{{{{{{{")
    	 	quantityYpos = _H - _H/5.5 - _H/8
    	 end
    	
    	VariableTable.QuantityLabel2 = display.newText( "Quantity ", _W/27, quantityYpos, _FontArr[6], _H/27.25 )
     	VariableTable.QuantityLabel2.anchorX = 0  
     	VariableTable.QuantityLabel2:setTextColor( 83/255, 20/255, 111/255 )
     	VariableTable.productNewScrollView:insert( VariableTable.QuantityLabel2 )
    
     	VariableTable.IncrementIcon = display.newImageRect( imageDirectory4.."IncrementBtn.png",  _W/5.4, _H/9.6 )
     	VariableTable.IncrementIcon.x = _W/2 - _W/8
    	VariableTable.IncrementIcon.y = VariableTable.QuantityLabel2.y --+VariableTable.NoteTextBox.height+  _H/192 --VariableTable.MenuTitle.y
     	VariableTable.IncrementIcon.id = ""
     	VariableTable.IncrementIcon:addEventListener("touch",onIncrementProductQuantity)
     	VariableTable.productNewScrollView:insert(VariableTable.IncrementIcon)
     
     	VariableTable.QuantityLabel = display.newText( "1", _W/2, VariableTable.IncrementIcon.y , _FontArr[6], _H/30 )
     	VariableTable.QuantityLabel.anchorX = 0  
     	VariableTable.QuantityLabel:setFillColor( 0 )
     	VariableTable.productNewScrollView:insert( VariableTable.QuantityLabel )
     
     	VariableTable.DecrementIcon = display.newImageRect( imageDirectory4.."DecrementBtn.png", _W/7.2, _H/12.8 )
     	VariableTable.DecrementIcon.x = _W/2 + _W/6
     	VariableTable.DecrementIcon.y = VariableTable.IncrementIcon.y
     	VariableTable.DecrementIcon.id = ""
     	VariableTable.DecrementIcon:addEventListener("touch",onDecrementProductQuantity)
     	VariableTable.productNewScrollView:insert(VariableTable.DecrementIcon)
    
    	
    
     	VariableTable.BottomBg = display.newImageRect( imageDirectory4.."BottomBg.png",  _W, _H/12 ) --_H/9.32
     	VariableTable.BottomBg.x = _W/2
     	VariableTable.BottomBg.y = VariableTable.DecrementIcon.y + _H/9.6 
     	--VariableTable.BottomBg.anchorY = 1
     	VariableTable.productNewScrollView:insert( VariableTable.BottomBg )
     
     	VariableTable.AddToCartBtn = widget.newButton
		{
   	 		width = _W/1.08,
    		height = _H/16.13,
    		defaultFile = imageDirectory3.."SinUp_Btn.png",
    		overFile = imageDirectory3.."SinUp_Btn.png",
    		label = "",
    		labelColor = { default={ 1, 1, 1 }, over={ 1,1,1 } },
    		fontSize = _H/30,
    		font = _FontArr[6],
    		labelYOffset = _H/275,
    		-- FONT AND FONT SIZE 
    		onEvent = handleAddToCartButtonEvent
		}
		VariableTable.AddToCartBtn.x = _W/2
		VariableTable.AddToCartBtn.y = VariableTable.DecrementIcon.y + _H/9.6
        VariableTable.productNewScrollView:insert(VariableTable.AddToCartBtn)
     	VariableTable.AddToCartBtn:setEnabled( false )
     
    	
    	--]]--
    	
    end
    
    
    
    
     --[[	
     	local function showAddOns()
     		
     			addOnsRow = { }
				addOnsTitle = { }
				addOnsCheckBtnUnSelected = { }
				addOnsCheckBtnSelected = { }
				addOnsPrice = { }
				RectOnTop = { }
     		
     		if(tonumber(selectedProductDetails.no_of_option) > 0) then
     		
			
			local n
			
				--print("varity not available")
				
				n = 1
			
			
			for i = n, #selectedProductDetails.options  do
				--print(i.."////")
				addOnsScrollView[i] = widget.newScrollView
				{
    				top = VariableTable.ProductDescri.y + VariableTable.ProductDescri.height + _H/96 ,--VariableTable.ProductImage.y + VariableTable.ProductImage.height,
    				left = 0, --( i-1 ) * _W,
    				width = _W,
    				height = _H/4.6,
    				scrollWidth = _W,
    				--scrollHeight = 800,
    				id = i,
    				--verticalScrollDisabled = true,
    				--backgroundColor = { 0, 0,0,(i-1) },
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
						--print("got category Values : "..i..".."..j)
						--print(addOnsScrollView[i].x)
						if(j == 1) then
							addOnsRow_first = display.newImageRect(imageDirectory4.."AddOnsBg.png",_W,_H/13.15)
    						addOnsRow_first.x = _W/2
    						addOnsRow_first.y = _H/192 + addOnsRow_first.height/2
    						addOnsScrollView[i]:insert( addOnsRow_first )
							
							addOnsTitle_first = display.newText(tostring(selectedProductDetails.options[i].item_option_main_name) ,_W/2,addOnsRow_first.y,_FontArr[6], _H/36.79)
    						addOnsTitle_first.anchorY = 0.5
    						--addOnsTitle_first.anchorX = 0
    						addOnsTitle_first:setTextColor( 206/255, 23/255, 100/255 )
    						addOnsScrollView[i]:insert(addOnsTitle_first) 
    						
    						if(i == 1) then
    							--print("j and options and variety"..j.."//"..tostring(#selectedProductDetails.options[i].options).."//"..tostring(selectedProductDetails.has_variety))
    							if(i == #selectedProductDetails.options and tonumber(selectedProductDetails.has_variety) == 0) then
    							
    							else
    								ForwardArrow = display.newRect(0,0,_W/8,_H/20)
    								ForwardArrow.x = _W - _W/13.5
    								ForwardArrow.y = addOnsRow_first.y
    								ForwardArrow.id = i
    								ForwardArrow:setFillColor( 83/255,20/255,111/255 )
    								ForwardArrow:addEventListener("tap",onMoveForward)
    								addOnsScrollView[i]:insert( ForwardArrow )
    								
    								forwardText = display.newText(GBCLanguageCabinet.getText("NextLabel",_LanguageKey),ForwardArrow.x,ForwardArrow.y,_FontArr[6], _H/36.79)
    								forwardText:setTextColor( 1 )
    								addOnsScrollView[i]:insert(forwardText)
    								
    							end
    						else
    							if(tonumber(selectedProductDetails.has_variety) > 0 or #selectedProductDetails.options > i) then
    								ForwardArrow = display.newRect(0,0,_W/8,_H/20)
    								ForwardArrow.x = _W - _W/13.5
    								ForwardArrow.y = addOnsRow_first.y
    								ForwardArrow.id = i
    								ForwardArrow:setFillColor( 83/255,20/255,111/255 )
    								ForwardArrow:addEventListener("tap",onMoveForward)
    								addOnsScrollView[i]:insert( ForwardArrow )
    								
    								forwardText = display.newText(GBCLanguageCabinet.getText("NextLabel",_LanguageKey),ForwardArrow.x,ForwardArrow.y,_FontArr[6], _H/36.79)
    								forwardText:setTextColor( 1 )
    								addOnsScrollView[i]:insert(forwardText)
    								
    							else
    								
    							end
    							
    							
    							
    							BackArrow = display.newRect(0,0,_W/8,_H/20)
    							BackArrow.x = _W/13.5
    							BackArrow.y = addOnsRow_first.y
    							BackArrow.id = i
    							BackArrow:setFillColor(  83/255,20/255,111/255  )
    							BackArrow:addEventListener("tap",onMoveBack)
    							addOnsScrollView[i]:insert( BackArrow )
    							
    							backText = display.newText(GBCLanguageCabinet.getText("BackLabel",_LanguageKey),BackArrow.x,BackArrow.y,_FontArr[6], _H/36.79)
    							backText:setTextColor( 1 )
    							addOnsScrollView[i]:insert(backText)
    							
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
        					--onEvent = handleButtonEvent
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
        					--onEvent = handleButtonEvent
    					}
						)
						addOnsCheckBtnSelected[i][j].x = _W/1.15
						addOnsCheckBtnSelected[i][j].id = i.."//"..j
						addOnsCheckBtnSelected[i][j]:addEventListener( "tap", onSelectAddOns )
						addOnsCheckBtnSelected[i][j].y = addOnsRow[i][j].y
						addOnsCheckBtnSelected[i][j].isVisible = false
						addOnsScrollView[i]:insert(addOnsCheckBtnSelected[i][j])
						
					
						
						roundDigit(selectedProductDetails.options[i].options[j].sub_amount)
						--print( "///////////////"..digValue3 )
						print("second make2Digit func called")
						local priceValue = "+$ "..make2Digit(tonumber(digValue3) )--* tonumber(VariableTable.QuantityLabel.text))
						--local priceValue = "+$ 0"
						addOnsPrice[i][j] = display.newText( priceValue,addOnsCheckBtnUnSelected[i][j].x - addOnsCheckBtnUnSelected[i][j].width/2 - _W/108,addOnsRow[i][j].y,_FontArr[7], _H/36.79)
   	 					addOnsPrice[i][j].anchorY = 0.5
    					addOnsPrice[i][j].anchorX = 1
    					addOnsPrice[i][j]:setTextColor( 0 ) --57/255 ,181/255 ,74/255 ) --0,0,0,0.5 )
    					addOnsScrollView[i]:insert(addOnsPrice[i][j]) 
	
						
    
						
						
					end
					print( "total option"..tonumber(#selectedProductDetails.options[i].options ))
					addOnsScrollView[i].height = (#selectedProductDetails.options[i].options *2 ) * _H/13.15  
					
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
				--RectOnTop[i].anchorY = 0
				RectOnTop[i].id = i
				RectOnTop[i]:setFillColor( 0,0,0,0.01 )
				RectOnTop[i]:addEventListener("touch",onTouchRect)
				RectOnTop[i].isVisible = false
				VariableTable.productNewScrollView:insert(RectOnTop[i])
			end
			end
			
			local m
			if(tonumber(selectedProductDetails.no_of_option) > 0) then
				 m = #selectedProductDetails.options + 1
			else
				m = 1
				sawAllOptionFlag = true
			end
			--print("...................."..m)
			if(tonumber(selectedProductDetails.has_variety) > 0) then
				if(#selectedProductDetails.varieties > 0) then
					
				addOnsScrollView[m] = widget.newScrollView
				{
    				top = VariableTable.ProductDescri.y + VariableTable.ProductDescri.height + _H/96 , --VariableTable.ProductImage.y + VariableTable.ProductImage.height,
    				left = 0, --( i-1 ) * _W,
    				width = _W,
    				height = _H/4.6,
    				scrollWidth = _W,
    				--scrollHeight = 800,
    				--verticalScrollDisabled = true,
    				id = m,
    				backgroundColor = { 0, 0,0,0 },
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
						----print("got category Values : "..i..".."..j)
						--print(addOnsScrollView[m].x)
						if(j == 1) then
							addOnsRow_first = display.newImageRect(imageDirectory4.."AddOnsBg.png",_W,_H/13.15)
    						addOnsRow_first.x = _W/2
    						addOnsRow_first.y = _H/192 + addOnsRow_first.height/2
    						addOnsScrollView[m]:insert( addOnsRow_first )
							
							addOnsTitle_first = display.newText(GBCLanguageCabinet.getText("SizeLabel",_LanguageKey),_W/2,addOnsRow_first.y,_FontArr[6], _H/36.79)
    						addOnsTitle_first.anchorY = 0.5
    						--addOnsTitle_first.anchorX = 0
    						addOnsTitle_first:setTextColor( 206/255, 23/255, 100/255 )
    						addOnsScrollView[m]:insert(addOnsTitle_first) 
    						
    							if( m == 1 ) then
    							
    							else
    							
    							BackArrow = display.newRect(0,0,_W/8,_H/20)
    							BackArrow.x = _W/13.5
    							BackArrow.y = addOnsRow_first.y
    							BackArrow.id = m
    							BackArrow:setFillColor(  83/255,20/255,111/255  )
    							BackArrow:addEventListener("tap",onMoveBack)
    							addOnsScrollView[m]:insert( BackArrow )
    							
    							backText = display.newText(GBCLanguageCabinet.getText("BackLabel",_LanguageKey),BackArrow.x,BackArrow.y,_FontArr[6], _H/36.79)
    							backText:setTextColor( 1 )
    							addOnsScrollView[m]:insert(backText)
    							
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
        					defaultFile = imageDirectory4.."Selected_CheckBox2.png",
        					overFile = imageDirectory4.."Selected_CheckBox2.png",
        					label = GBCLanguageCabinet.getText("RemoveLabel",_LanguageKey),
        					font = _FontArr[6],
        					fontSize = _H/50,
        					labelColor = { default={1,1,1,1}, over={1,1,1,1} },
        					--onEvent = handleButtonEvent
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
        					--onEvent = handleButtonEvent
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
						--print( "????????????????"..digValue3 )
						print("third make2Digit func called")
						local priceValue = "$ "..make2Digit(tonumber(digValue3) )--* tonumber(VariableTable.QuantityLabel.text))
						addOnsPrice[m][j] = display.newText( priceValue,addOnsCheckBtnUnSelected[m][j].x - addOnsCheckBtnUnSelected[m][j].width/2 - _W/108 ,addOnsRow[m][j].y,_FontArr[7], _H/36.79)
   	 					addOnsPrice[m][j].anchorY = 0.5
    					addOnsPrice[m][j].anchorX = 1
    					addOnsPrice[m][j]:setTextColor( 0 ) --57/255 ,181/255 ,74/255 ) --0,0,0,0.5 )
    					addOnsScrollView[m]:insert(addOnsPrice[m][j]) 
    					if(j == 1) then
    						addOnsCheckBtnUnSelected[m][j].isVisible = false
    						addOnsCheckBtnSelected[m][j].isVisible = true
    						--addOnsPrice[m][j]:setTextColor( 206/255 ,23/255 ,100/255 )
    						--addOnsPrice[m][j]:setTextColor( 57/255 ,181/255 ,74/255 )
    						if(selectedProductDetails.discount_applicable == "NO") then
    							actualPrice = selectedProductDetails.varieties[j].variety_price
    						else
    							actualPrice = selectedProductDetails.varieties[j].discounted_variety_price
    						end
    						
    						
    						
    						selected_variety_id = selectedProductDetails.varieties[j].id
    						
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
					
					
				end
				
				--addOnsScrollView[m].isVisible = true
				
				RectOnTop[m] = display.newRect(_W/2,addOnsScrollView[m].y ,_W,addOnsScrollView[m].height)
				--RectOnTop[m].anchorY = 0
				RectOnTop[m].id = i
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
			print( "total addons are............................................"..tostring(#addOnsScrollView) )
			if( #addOnsScrollView == 1 ) then
				print( "sawAllOptionFlag true")
				sawAllOptionFlag = true
				countTotal() 
			end
			
			return true
		end
		]]--
		
	local function showAddOns()
     		
     			addOnsRow = { }
				addOnsTitle = { }
				addOnsCheckBtnUnSelected = { }
				addOnsCheckBtnSelected = { }
				addOnsPrice = { }
				RectOnTop = { }
     		
     		if(tonumber(selectedProductDetails.no_of_option) > 0) then
     		
			
			local n
			
				--print("varity not available")
				
				n = 1
			
			
			for i = n, #selectedProductDetails.options  do
				--print(i.."////")
				addOnsScrollView[i] = widget.newScrollView
				{
    				top = VariableTable.ProductDescri.y + VariableTable.ProductDescri.height + _H/96 ,--VariableTable.ProductImage.y + VariableTable.ProductImage.height,
    				left = 0, --( i-1 ) * _W,
    				width = _W,
    				height = _H/4.6,
    				scrollWidth = _W,
    				--scrollHeight = 800,
    				id = i,
    				--verticalScrollDisabled = true,
    				--backgroundColor = { 0, 0,0,(i-1) },
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
						--print("got category Values : "..i..".."..j)
						--print(addOnsScrollView[i].x)
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
								align = "center",
								
								
							}
							
							addOnsTitle_first = display.newText( option )
    						addOnsTitle_first.anchorY = 0.5
    						--addOnsTitle_first.anchorX = 0
    						addOnsTitle_first:setTextColor( 206/255, 23/255, 100/255 )
    						addOnsScrollView[i]:insert(addOnsTitle_first) 
    						
    						if( _LanguageKey == "ru" or _LanguageKey == "uk" ) then
    							forwardBtnTextSize = _H/50
    							forwardButtonSize = _H/7.5
    							backButtonSize = _H/7.5
    							print("big font")
    						elseif( _LanguageKey == "ar" ) then
    							forwardBtnTextSize = _H/60
    							forwardButtonSize = _H/10
    							backButtonSize = _H/10
    							print("big font")
    						elseif( _LanguageKey == "it" ) then
    							forwardBtnTextSize = _H/45
    							forwardButtonSize = _H/10
    							backButtonSize = _H/12
    							print("big font")
    						else
    							forwardBtnTextSize = _H/45
    							forwardButtonSize = _H/12
    							backButtonSize = _H/12
    							print("small font")
    						end
    						
    						if(i == 1) then
    							--print("j and options and variety"..j.."//"..tostring(#selectedProductDetails.options[i].options).."//"..tostring(selectedProductDetails.has_variety))
    							if(i == #selectedProductDetails.options and tonumber(selectedProductDetails.has_variety) == 0) then
    								
    							else
    								--ForwardArrow = display.newRect(0,0,forwardButtonSize,_H/20)
--    								ForwardArrow.x = _W - ForwardArrow.width/2 - _W/216
--    								ForwardArrow.y = addOnsRow_first.y
--    								ForwardArrow.id = i
--    								ForwardArrow:setFillColor( 51/255, 181/255, 74/255 )--83/255,20/255,111/255 )
--    								ForwardArrow:addEventListener("tap",onMoveForward)
--    								addOnsScrollView[i]:insert( ForwardArrow )
--    								
--    								forwardText = display.newText(GBCLanguageCabinet.getText("NextLabel",_LanguageKey),ForwardArrow.x,ForwardArrow.y,_FontArr[6],forwardBtnTextSize)
--    								forwardText:setTextColor( 1 )
--    								addOnsScrollView[i]:insert(forwardText)
    								
    								ForwardArrow = widget.newButton(
									{
										width = (_W/5.5)*2,
										height = (_H/28.23)*2,
										defaultFile = imageDirectory4.."unSelected_CheckBox1.png",
										overFile = imageDirectory4.."unSelected_CheckBox1.png",
										label = GBCLanguageCabinet.getText("NextLabel",_LanguageKey),
										font = _FontArr[6],
										fontSize = _H/21.33,--forwardBtnTextSize
										labelYOffset = 5,
										labelColor = { default={1,1,1,1}, over={1,1,1,1} },
										--onEvent = handleButtonEvent,
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
    								--ForwardArrow = display.newRect(0,0,forwardButtonSize,_H/20)
--    								ForwardArrow.x = _W - ForwardArrow.width/2 - _W/216
--    								ForwardArrow.y = addOnsRow_first.y
--    								ForwardArrow.id = i
--    								ForwardArrow:setFillColor( 51/255, 181/255, 74/255 )--83/255,20/255,111/255 )
--    								ForwardArrow:addEventListener("tap",onMoveForward)
--    								addOnsScrollView[i]:insert( ForwardArrow )
--    								
--    								forwardText = display.newText(GBCLanguageCabinet.getText("NextLabel",_LanguageKey),ForwardArrow.x,ForwardArrow.y,_FontArr[6], forwardBtnTextSize)
--    								forwardText:setTextColor( 1 )
--    								addOnsScrollView[i]:insert(forwardText)
    								
    								ForwardArrow = widget.newButton(
									{
										width = (_W/5.5)*2,
										height = (_H/28.23)*2,
										defaultFile = imageDirectory4.."unSelected_CheckBox1.png",
										overFile = imageDirectory4.."unSelected_CheckBox1.png",
										label = GBCLanguageCabinet.getText("NextLabel",_LanguageKey),
										font = _FontArr[6],
										fontSize = _H/21.33,--forwardBtnTextSize
										labelYOffset = 5,
										labelColor = { default={1,1,1,1}, over={1,1,1,1} },
										--onEvent = handleButtonEvent,
										id = i
									}
									)
									ForwardArrow.x = _W - ForwardArrow.width/2 - _W/216
									ForwardArrow.y = addOnsRow_first.y
									ForwardArrow:addEventListener( "tap", onMoveForward  )
									addOnsScrollView[i]:insert(ForwardArrow)
    								
    							else
    								
    							end
    							
    							--BackArrow = display.newRect(0,0,backButtonSize,_H/20)
--    							BackArrow.x = BackArrow.width/2 + _W/216
--    							BackArrow.y = addOnsRow_first.y
--    							BackArrow.id = i
--    							BackArrow:setFillColor(  83/255,20/255,111/255  )
--    							BackArrow:addEventListener("tap",onMoveBack)
--    							addOnsScrollView[i]:insert( BackArrow )
--    							
--    							backText = display.newText(GBCLanguageCabinet.getText("BackLabel",_LanguageKey),BackArrow.x,BackArrow.y,_FontArr[6], forwardBtnTextSize)
--    							backText:setTextColor( 1 )
--    							addOnsScrollView[i]:insert(backText)
    							
    							BackArrow = widget.newButton(
								{
									width = _W/5.5,
									height = _H/28.23,
									defaultFile = imageDirectory4.."Back_Unselected_CheckBox.png",
									overFile = imageDirectory4.."Back_Unselected_CheckBox.png",
									label = GBCLanguageCabinet.getText("BackLabel",_LanguageKey),
									font = _FontArr[6],
									fontSize = _H/50,--forwardBtnTextSize
									labelColor = { default={1,1,1,1}, over={1,1,1,1} },
									--onEvent = handleButtonEvent,
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
        					--onEvent = handleButtonEvent
   	 					}
						)
						addOnsCheckBtnUnSelected[i][j].x = _W/1.15
						addOnsCheckBtnUnSelected[i][j].id = i.."//"..j
						addOnsCheckBtnUnSelected[i][j]:addEventListener( "tap", onUNSelectAddOns  )
						addOnsCheckBtnUnSelected[i][j].y = addOnsRow[i][j].y
    					addOnsScrollView[i]:insert(addOnsCheckBtnUnSelected[i][j])
    					
    					--[[addOnsCheckBtnUnSelected[i][j] = display.newImageRect( imageDirectory4.."Selected_CheckBox2.png",_W/5.5,_H/28.23)--_W/13.5,_H/24
						addOnsCheckBtnUnSelected[i][j].x = _W/1.15
						addOnsCheckBtnUnSelected[i][j].id = i.."//"..j
						addOnsCheckBtnUnSelected[i][j]:addEventListener( "tap", onUNSelectAddOns  )
						addOnsCheckBtnUnSelected[i][j].y = addOnsRow[i][j].y
						addOnsScrollView[i]:insert(addOnsCheckBtnUnSelected[i][j])
						]]--
						
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
        					--onEvent = handleButtonEvent
    					}
						)
						addOnsCheckBtnSelected[i][j].x = _W/1.15
						addOnsCheckBtnSelected[i][j].id = i.."//"..j
						addOnsCheckBtnSelected[i][j]:addEventListener( "tap", onSelectAddOns )
						addOnsCheckBtnSelected[i][j].y = addOnsRow[i][j].y
						addOnsCheckBtnSelected[i][j].isVisible = false
						addOnsScrollView[i]:insert(addOnsCheckBtnSelected[i][j])
						
						--[[
						addOnsCheckBtnSelected[i][j] = display.newImageRect(imageDirectory4.."unSelected_CheckBox1.png",_W/5.5,_H/28.23)
						addOnsCheckBtnSelected[i][j].x = _W/1.15
						addOnsCheckBtnSelected[i][j].id = i.."//"..j
						addOnsCheckBtnSelected[i][j]:addEventListener( "tap", onSelectAddOns )
						addOnsCheckBtnSelected[i][j].y = addOnsRow[i][j].y
						addOnsCheckBtnSelected[i][j].isVisible = false
						addOnsScrollView[i]:insert(addOnsCheckBtnSelected[i][j])]]--
						
						roundDigit(selectedProductDetails.options[i].options[j].sub_amount)
						--print( "///////////////"..digValue3 )
						print("second make2Digit func called")
						local priceValue = "+$ "..make2Digit(tonumber(digValue3) )--* tonumber(VariableTable.QuantityLabel.text))
						--local priceValue = "+$ 0"
						addOnsPrice[i][j] = display.newText( priceValue,addOnsCheckBtnUnSelected[i][j].x - addOnsCheckBtnUnSelected[i][j].width/2 - _W/108,addOnsRow[i][j].y,_FontArr[7], _H/36.79)
   	 					addOnsPrice[i][j].anchorY = 0.5
    					addOnsPrice[i][j].anchorX = 1
    					addOnsPrice[i][j]:setTextColor( 0 ) --57/255 ,181/255 ,74/255 ) --0,0,0,0.5 )
    					addOnsScrollView[i]:insert(addOnsPrice[i][j]) 
	
						--[[local descriValue 
							if(tostring(selectedProductDetails.options[i].options[j].description):len() > 20) then
								descriValue = tostring(selectedProductDetails.options[i].options[j].description):sub(0,20)..".."
							else
								descriValue = tostring(selectedProductDetails.options[i].options[j].description)
							end
	
    					addOnsDescri = display.newText(addOnsScrollView[i],descriValue,addOnsTitle[j].x,addOnsTitle[j].y + addOnsTitle[j].height/2 + _H/384,_FontArr[6],_H/49.06)
    					addOnsDescri.anchorX = addOnsTitle[j].anchorX
    					addOnsDescri:setTextColor( 1,0,0,1 )]]--
    
						
						
					end
					print( "total option"..tonumber(#selectedProductDetails.options[i].options ))
					addOnsScrollView[i].height = (#selectedProductDetails.options[i].options *2 ) * _H/13.15  
					
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
				--RectOnTop[i].anchorY = 0
				RectOnTop[i].id = i
				RectOnTop[i]:setFillColor( 1,1,1,0.01 )
				RectOnTop[i]:addEventListener("touch",onTouchRect)
				RectOnTop[i].isVisible = false
				VariableTable.productNewScrollView:insert(RectOnTop[i])
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
    				top = VariableTable.ProductDescri.y + VariableTable.ProductDescri.height + _H/96 , --VariableTable.ProductImage.y + VariableTable.ProductImage.height,
    				left = 0, --( i-1 ) * _W,
    				width = _W,
    				height = _H/4.6,
    				scrollWidth = _W,
    				--scrollHeight = 800,
    				--verticalScrollDisabled = true,
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
						----print("got category Values : "..i..".."..j)
						--print(addOnsScrollView[m].x)
						if(j == 1) then
							addOnsRow_first = display.newImageRect(imageDirectory4.."AddOnsBg.png",_W,_H/13.15)
    						addOnsRow_first.x = _W/2
    						addOnsRow_first.y = _H/192 + addOnsRow_first.height/2
    						addOnsScrollView[m]:insert( addOnsRow_first )
							
							addOnsTitle_first = display.newText(GBCLanguageCabinet.getText("SizeLabel",_LanguageKey),_W/2,addOnsRow_first.y,_FontArr[6], _H/36.79)
    						addOnsTitle_first.anchorY = 0.5
    						--addOnsTitle_first.anchorX = 0
    						addOnsTitle_first:setTextColor( 206/255, 23/255, 100/255 )
    						addOnsScrollView[m]:insert(addOnsTitle_first) 
    						
    						if( _LanguageKey == "ru" or _LanguageKey == "uk") then
    								forwardBtnTextSize = _H/50
    								forwardButtonSize = _H/7.5
    								backButtonSize = _H/7.5
    								print("big font")
    							elseif( _LanguageKey == "ar" ) then
    								forwardBtnTextSize = _H/60
    								forwardButtonSize = _H/10
    								backButtonSize = _H/10
    								print("big font")
    							elseif( _LanguageKey == "it" ) then
    								forwardBtnTextSize = _H/45
    								forwardButtonSize = _H/10
    								backButtonSize = _H/12
    								print("big font")
    							else
    								forwardBtnTextSize = _H/45
    								forwardButtonSize = _H/12
    								backButtonSize = _H/12
    								print("small font")
    							end
    						
    							if( m == 1 ) then
    							
    							else
    							
    							--BackArrow = display.newRect(0,0,backButtonSize,_H/20)
--    							BackArrow.x = BackArrow.width/2 + _W/216
--    							BackArrow.y = addOnsRow_first.y
--    							BackArrow.id = m
--    							BackArrow:setFillColor(  83/255,20/255,111/255  )
--    							BackArrow:addEventListener("tap",onMoveBack)
--    							addOnsScrollView[m]:insert( BackArrow )
--    							
--    							backText = display.newText(GBCLanguageCabinet.getText("BackLabel",_LanguageKey),BackArrow.x,BackArrow.y,_FontArr[6], forwardBtnTextSize)
--    							backText:setTextColor( 1 )
--    							addOnsScrollView[m]:insert(backText)
    							
    							BackArrow = widget.newButton(
								{
									width = _W/5.5,
									height = _H/28.23,
									defaultFile = imageDirectory4.."Back_Unselected_CheckBox.png",
									overFile = imageDirectory4.."Back_Unselected_CheckBox.png",
									label = GBCLanguageCabinet.getText("BackLabel",_LanguageKey),
									font = _FontArr[6],
									fontSize = _H/50,--forwardBtnTextSize
									labelColor = { default={1,1,1,1}, over={1,1,1,1} },
									--onEvent = handleButtonEvent,
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
        					--onEvent = handleButtonEvent
    					}
						)
						addOnsCheckBtnUnSelected[m][j].x = _W/1.15
						addOnsCheckBtnUnSelected[m][j].id = m.."//"..j
						addOnsCheckBtnUnSelected[m][j]:addEventListener( "tap", onUNSelectVariety )
						addOnsCheckBtnUnSelected[m][j].y = addOnsRow[m][j].y
						addOnsCheckBtnUnSelected[m][j].isVisible = false
						addOnsScrollView[m]:insert(addOnsCheckBtnUnSelected[m][j])
    					
    					--[[addOnsCheckBtnUnSelected[m][j] = display.newImageRect( imageDirectory4.."Selected_CheckBox2.png",_W/5.5,_H/28.23)
						addOnsCheckBtnUnSelected[m][j].x = _W/1.15
						addOnsCheckBtnUnSelected[m][j].id = m.."//"..j
						addOnsCheckBtnUnSelected[m][j]:addEventListener( "tap", onUNSelectVariety  )
						addOnsCheckBtnUnSelected[m][j].y = addOnsRow[m][j].y
						addOnsScrollView[m]:insert(addOnsCheckBtnUnSelected[m][j])]]--
						
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
        					--onEvent = handleButtonEvent
    					}
						)
						addOnsCheckBtnSelected[m][j].x = _W/1.15
						addOnsCheckBtnSelected[m][j].id = m.."//"..j
						addOnsCheckBtnSelected[m][j]:addEventListener( "tap", onSelectVariety )
						addOnsCheckBtnSelected[m][j].y = addOnsRow[m][j].y
						addOnsCheckBtnSelected[m][j].isVisible = false
						addOnsScrollView[m]:insert(addOnsCheckBtnSelected[m][j])
						
						--[[
						addOnsCheckBtnSelected[m][j] = display.newImageRect(imageDirectory4.."unSelected_CheckBox1.png",_W/5.5,_H/28.23)
						addOnsCheckBtnSelected[m][j].x = _W/1.15
						addOnsCheckBtnSelected[m][j].id = m.."//"..j
						addOnsCheckBtnSelected[m][j]:addEventListener( "tap", onSelectVariety )
						addOnsCheckBtnSelected[m][j].y = addOnsRow[m][j].y
						addOnsCheckBtnSelected[m][j].isVisible = false
						addOnsScrollView[m]:insert(addOnsCheckBtnSelected[m][j])]]--
						
						if(selectedProductDetails.discount_applicable == "NO") then
							roundDigit(selectedProductDetails.varieties[j].variety_price)
						else
							roundDigit(selectedProductDetails.varieties[j].discounted_variety_price)
						end
						--print( "????????????????"..digValue3 )
						print("third make2Digit func called")
						local priceValue = "$ "..make2Digit(tonumber(digValue3) )--* tonumber(VariableTable.QuantityLabel.text))
						addOnsPrice[m][j] = display.newText( priceValue,addOnsCheckBtnUnSelected[m][j].x - addOnsCheckBtnUnSelected[m][j].width/2 - _W/108 ,addOnsRow[m][j].y,_FontArr[7], _H/36.79)
   	 					addOnsPrice[m][j].anchorY = 0.5
    					addOnsPrice[m][j].anchorX = 1
    					addOnsPrice[m][j]:setTextColor( 0 ) --57/255 ,181/255 ,74/255 ) --0,0,0,0.5 )
    					addOnsScrollView[m]:insert(addOnsPrice[m][j]) 
    					if(j == 1) then
    						addOnsCheckBtnUnSelected[m][j].isVisible = false
    						addOnsCheckBtnSelected[m][j].isVisible = true
    						--addOnsPrice[m][j]:setTextColor( 206/255 ,23/255 ,100/255 )
    						--addOnsPrice[m][j]:setTextColor( 57/255 ,181/255 ,74/255 )
    						if(selectedProductDetails.discount_applicable == "NO") then
    							actualPrice = selectedProductDetails.varieties[j].variety_price
    						else
    							actualPrice = selectedProductDetails.varieties[j].discounted_variety_price
    						end
    						
    						--[[if(selectedProductDetails.discount_applicable == "NO") then
        						actualPrice = originalProductPrice
        						discountValue = 0
        					else
        						discountValue = tonumber(originalProductPrice) - tonumber(selectedProductDetails.discounted_price)
        						actualPrice =  originalProductPrice - discountValue
        					end]]--
    						
    						selected_variety_id = selectedProductDetails.varieties[j].id
    					
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
					
					
				end
				
				--addOnsScrollView[m].isVisible = true
				
				RectOnTop[m] = display.newRect(_W/2,addOnsScrollView[m].y ,_W,addOnsScrollView[m].height)
				--RectOnTop[m].anchorY = 0
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
				print( "sawAllOptionFlag true")
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
        		print("No discount")
        		actualPrice = selectedProductDetails.price
        		discountValue = 0
        		print("so original price and actual price in begiging is same")
        		print(actualPrice)
        	else
        		print("discount available..."..selectedProductDetails.discounted_price)
        		discountValue =  0
        		actualPrice =  tonumber(selectedProductDetails.discounted_price)
        		print("after discount price is..."..actualPrice)
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
    -- If the "back" key was pressed on Android, then prevent it from backing out of your app.
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
        print("Scroll height is ..........????????????????????")
        print(VariableTable.productNewScrollView._scrollHeight)
        
        
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
        
        --display.remove(productGroup)
        --productGroup = nil
        
        display.remove(headerGroup)
        headerGroup = nil
        
        --display.remove(subMenuGroup)
        --subMenuGroup = nil
        
        yPosToPlaceNote = 0
        height = 0
        
        --composer.removeScene( "Product" )
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