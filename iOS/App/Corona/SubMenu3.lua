local scene = composer.newScene()
local slideView = require("slideView")
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------
local imageDirectory = "images/Navigation/"
local imageDirectory2 = "images/SubMenu/"
local imageDirectory3 = "images/SignUp/"
local imageDirectory4 = "images/MainMenu/"
local rowTitles = {}
local sub_rowTitles = {}
local Rect = { }
local nameBg = { }
local subCategoryTable = { }
local RectOnTop = { }

local listItems = { } 
local subCateIDArray = { }
local subCateArray = { }
local subCateImage = { }
local newLabel = { }

local navigationGroup,subMenuGroup,menuFlag,param, Background, sldView
local scrollViewSubMenu = { }

local sub_OverRect
local beginX,endX
local MainCatValue ,MainCatID, new_item 
local waterRequest

local NavigationVariableTable = { "sliderBg", "logo", "HeaderBG", "ChefImage", "ProfileBg", "Rect1", "Rect2", "Rect3", "Rect4","Rect5",
"CartIcon", "OrderIcon", "FeedBackIcon", "SettingIcon", "LogOutIcon", "ProfilePicBg", "ProfileEditLabel", "ProfileEditBg", "CartLabel", 
"OrderLabel", "FeedBackLabel", "SettingLabel", "LogOutLabel", "UserName", "UserEmail", "HotelAddress", "HotelName", "MenuProductImage" }
 
local  header2, HeaderBg, MenuIcon, MenuBg, homeBtn, Bg, restaurantName, restaurantAdd, MenuTitle, MenuTitleBg, backBtn, backBg, list 


local function onDoNothing( event )
	return true
end


local function handleBackButtonEvent( event )
	composer.gotoScene("menu")
	
	return true
end

local function handleBackButtonEventTouch( event )
	if event.phase == "began" then
		composer.gotoScene("menu")
	end
	
	return true
end

function openNavigationTap( event )
	if(composer.getSceneName("current") == "SubMenu2") then
		local function addEvents( event )
			return true
		end
		
		if(menuFlag == 0) then
			navigationGroup.x = navigationGroup.x + _W/1.28
			subMenuGroup.x = subMenuGroup.x + _W/1.28
			menuFlag = 1			
		elseif(menuFlag == 1) then
			navigationGroup.x = navigationGroup.x - _W/1.28
			subMenuGroup.x = subMenuGroup.x - _W/1.28
			menuFlag = 0
		end
		
	end
	return true
end

function openNavigationTouch( event )
	if(event.phase == "began") then
		if(composer.getSceneName == "SubMenu2") then
		local function addEvents( event )
			
			return true
		end
		if(menuFlag == 0) then
			menuFlag = 1
			transition.to( navigationGroup, { time=1000, x=navigationGroup.x + _W/1.28,onComplete = addEvents  } )
			transition.to( subMenuGroup, { time=1000, x=subMenuGroup.x + _W/1.28 } )
		elseif(menuFlag == 1) then
			menuFlag = 0
			transition.to( navigationGroup, { time=1000, x=navigationGroup.x - _W/1.28,onComplete = addEvents } )
			transition.to( subMenuGroup, { time=1000, x=subMenuGroup.x - _W/1.28 } )
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
		
	end
	end
	return true
end


local function onCategoryTap(event)
    local row = event.target
    
    for k,v in pairs(rowTitles) do rowTitles[k]=nil end
    for k,v in pairs(sub_rowTitles) do sub_rowTitles[k]=nil end
    
    for i = 1,#listItems do
    	if(i == row.id) then
    	
    	else
    		listItems[i].collapsed = true
    	end
    end
    
    listItems[row.id].collapsed = not listItems[row.id].collapsed
    list:deleteAllRows()
    populateList()
end

local function onCategoryRectTap( event )
	
	local targetId = event.target.id:sub(1,event.target.id:len() - 3)
	local targetType = event.target.id:sub(event.target.id:len() - 2,event.target.id:len())
	if(targetType == "Cat") then
		local flag = 0
		local name = ""
		for i = 1, #subCategoryTable do
			if(subCategoryTable[i].sub_menu) then
				for j = 1, #subCategoryTable[i].sub_menu do
					if(subCategoryTable[i].sub_menu[j].id == targetId) then
						if(subCategoryTable[i].sub_menu[j].sub_menu) then
							if(#subCategoryTable[i].sub_menu[j].sub_menu > 0) then
							else
								flag = 1
								name = subCategoryTable[i].sub_menu[j].category_name
							end
							
						else
							flag = 1
							name = subCategoryTable[i].sub_menu[j].category_name
						end
						break
					end
				end
			end
		end
		
		if( flag == 0 ) then
			local option = {
				time = 400,
				effect = "fade"
			}
	
			_selectedLastSubCategoryID = targetId
		 
			composer.gotoScene("SubToSubMenu")
		else
		
			_selectedProductListCategoryID = targetId
			_selectedProductListCategoryName = name
			composer.gotoScene("ProductListPage")
			
		end
		
	elseif(targetType == "Pro") then
		local option = {
			time = 400,
			effect = "fade"
		}
	
		_selectedProductID = targetId
		
		local pImagePath = system.pathForFile( "Product".._selectedProductID..".png", system.TemporaryDirectory )
    	local pImageFile = io.open( pImagePath, "r" )
   	 	if( pImageFile ) then
			_productImageFlag = true
		else
			_productImageFlag = false
		end
		
		composer.gotoScene("Product")
	end
	return false
end

local function onRowRender( event )
	local phase = event.phase
	local row = event.row
	local isCategory = row.isCategory
	local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth
	
	local groupContentHeight = row.contentHeight
	
	if isCategory then
            
            local categoryBtn = display.newImageRect( row,imageDirectory2.."RowBg.png", row.width, row.height )
            categoryBtn.anchorX, categoryBtn.anchorY = 0, 0
            categoryBtn:addEventListener ( "tap", onCategoryTap )
            categoryBtn.isHitTestable = true
            categoryBtn.id = row.id
            
            local rowTitle = display.newText( row, rowTitles[row.index].title, 0, 0, native.systemFontBold, _H/54 )
			rowTitle.x = _W/6.17
			rowTitle.anchorX = 0
			rowTitle.y = groupContentHeight * 0.5
			rowTitle:setTextColor( 0 )
	
			local rowIconBG = display.newImageRect(row, imageDirectory2.."SmallIcon_Bg.png",_W/10.8,_H/19.2)
			rowIconBG.x = _W/27
			rowIconBG.y = groupContentHeight * 0.5
			rowIconBG.anchorX = 0
			
			
			local rowIcon = display.newImageRect(row, "SubCategory"..rowTitles[row.index].id..".png",system.TemporaryDirectory,_W/10.8,_H/19.2)
			rowIcon.x = _W/27
			rowIcon.y = groupContentHeight * 0.5
			rowIcon.anchorX = 0
			
			local rowIconMask = display.newImageRect(row, imageDirectory2.."SmallIcon_BgMask.png",_W/10.8,_H/19.2)
			rowIconMask.x = _W/27
			rowIconMask.y = groupContentHeight * 0.5
			rowIconMask.anchorX = 0
            
            local catIndicator = nil 
            if listItems[row.id].collapsed then
                catIndicator = display.newImageRect( row, imageDirectory2.."ArrowBtn_Down.png", _W/18.64,_H/33.10 )
            else
                catIndicator = display.newImageRect( row, imageDirectory2.."ArrowBtn_Up.png", _W/18.64,_H/33.10 )
            end
            catIndicator.x = _W/1.10
            catIndicator.anchorX = 0
            catIndicator.y = groupContentHeight * 0.5
            
    else
		
		scrollViewSubMenu[i] = widget.newScrollView
		{
   		 	y = rowHeight * 0.5,
    		left = 0,
    		width = _W,
    		height = rowHeight,
    		scrollWidth = _W,
   			scrollHeight = rowHeight,
   			verticalScrollDisabled = true,
    		listener = scrollListener
		}
		row:insert(scrollViewSubMenu[i])
		
		local Rows = math.ceil( #sub_rowTitles[row.index].items/2 )
		Rect = { }
		nameBg = { }
		
		if(#sub_rowTitles[row.index].items <= 2) then
			j = 1
			
			for j = 1, #sub_rowTitles[row.index].items do
			if(j == 1) then
				Rect[1] = display.newImageRect(imageDirectory2.."TileBg.png",_W/2.04 ,_H/4.86)
				Rect[1].x = 0 + _W/155
				Rect[1].y = rowHeight * 0.010
				Rect[1].anchorX = 0
				Rect[1].anchorY = 0
				Rect[1].id = sub_rowTitles[row.index].ids[1]
				Rect[1]:addEventListener("tap",onCategoryRectTap)
				scrollViewSubMenu[i]:insert(Rect[1])
				
			elseif(j == 2) then
				Rect[j] = display.newImageRect(imageDirectory2.."TileBg.png",_W/2.04 ,_H/4.86)
				Rect[j].x = Rect[j-1].x + Rect[j-1].width + _W/155
				Rect[j].y = rowHeight * 0.010
				Rect[j].anchorX = 0
				Rect[j].anchorY = 0
				Rect[j].id = sub_rowTitles[row.index].ids[j]
				Rect[j]:addEventListener("tap",onCategoryRectTap)
				scrollViewSubMenu[i]:insert(Rect[j])
				
			end
			end
		else
		
			j = 1 
			
			for i = 1, Rows  do
				
				if i == 1 then
				Rect[j] = display.newImageRect(imageDirectory2.."TileBg.png",_W/2.04 ,_H/4.86)
				Rect[j].x = rowWidth * 0.005
				Rect[j].y = rowHeight * 0.010
				Rect[j].anchorX = 0
				Rect[j].anchorY = 0
				Rect[j].id = sub_rowTitles[row.index].ids[j]
				Rect[j]:addEventListener("tap",onCategoryRectTap)
				scrollViewSubMenu[i]:insert(Rect[j])

				if(sub_rowTitles[row.index].items[j+1]) then
				
					Rect[j + 1] = display.newImageRect(imageDirectory2.."TileBg.png",_W/2.04 ,_H/4.86)
					Rect[j + 1].x = rowWidth * 0.005
					Rect[j + 1].y = rowHeight * 0.990
					Rect[j + 1].anchorX = 0
					Rect[j + 1].anchorY = 1
					Rect[j + 1].id = sub_rowTitles[row.index].ids[j+1]
					Rect[j + 1]:addEventListener("tap",onCategoryRectTap)
					scrollViewSubMenu[i]:insert(Rect[j + 1])
					
				end
			
				else
				
					Rect[j] = display.newImageRect(imageDirectory2.."TileBg.png",_W/2.04 ,_H/4.86)
					Rect[j].x = Rect[j-1].x + Rect[j-1].width + _W/108
					Rect[j].y = rowHeight * 0.010 
					Rect[j].anchorX = 0
					Rect[j].anchorY = 0
					Rect[j].id = sub_rowTitles[row.index].ids[j]
					Rect[j]:addEventListener("tap",onCategoryRectTap)
					scrollViewSubMenu[i]:insert(Rect[j])
					
					if(sub_rowTitles[row.index].items[j+1]) then
				
						Rect[j + 1] = display.newImageRect(imageDirectory2.."TileBg.png",_W/2.04 ,_H/4.86)
						Rect[j + 1].x = Rect[j-1].x + Rect[j-1].width + _W/108
						Rect[j + 1].y = rowHeight * 0.990
						Rect[j + 1].anchorX = 0
						Rect[j + 1].anchorY = 1
						Rect[j + 1].id = sub_rowTitles[row.index].ids[j+1]
						Rect[j + 1]:addEventListener("tap",onCategoryRectTap)
						scrollViewSubMenu[i]:insert(Rect[j + 1])
						
					end
				
				end
				
				j = j + 2
			end
		
			for i = 1,#Rect do
			
				nameBg[i] = display.newImageRect(imageDirectory2.."DetailsBg.png", Rect[i].width, _H/10.26)
				nameBg[i].x = Rect[i].x
        		nameBg[i].y = Rect[i].y + Rect[i].height
        		nameBg[i].anchorX = 0
				nameBg[i].anchorY = 1
        		nameBg[i].alpha = 0.7
        		scrollViewSubMenu[i]:insert( nameBg[i] )
        		
        		
        		if(math.fmod(i,2) == 0) then
					nameBg[i].y = Rect[i].y 
				end
				
			end
		
		end
		
		for i = 1,#Rect do
		
				local itemType = sub_rowTitles[row.index].ids[i]:sub(sub_rowTitles[row.index].ids[i]:len() - 2,sub_rowTitles[row.index].ids[i]:len())
				local itemID = sub_rowTitles[row.index].ids[i]:sub(1,sub_rowTitles[row.index].ids[i]:len() - 3)
				if(itemType == "Cat") then
				
				 	imagePath = system.pathForFile( "SubToSubCategory"..itemID..".png", system.TemporaryDirectory )
    			 	imageFile = io.open( imagePath, "r" )
    				path = "SubToSubCategory"..itemID..".png"
    			elseif(itemType == "Pro") then
    				imagePath = system.pathForFile( "Product"..itemID..".png", system.TemporaryDirectory )
    			 	imageFile = io.open( imagePath, "r" )
    				path = "Product"..itemID..".png"
    			end
    			
    			if(imageFile) then
    			
				subCateImage[i] = display.newImage(path,system.TemporaryDirectory)
				subCateImage[i].x = Rect[i].x
				subCateImage[i].y = Rect[i].y
				subCateImage[i].width = _H/4.86 /(subCateImage[i].height/subCateImage[i].width )
				subCateImage[i].height = _H/4.86
				subCateImage[i].anchorX = Rect[i].anchorX
				subCateImage[i].anchorY = Rect[i].anchorY
				subCateImage[i].id = i
				scrollViewSubMenu[i]:insert(subCateImage[i])
				
				if(subCateImage[i].width > _W/2.04) then
					subCateImage[i].width = _W/2.04
				end	
				
				end
				
				
				
				subCateImageMask = display.newImageRect(imageDirectory2.."TileBgMask.png",_W/2.04 ,_H/4.86)
				subCateImageMask.x = Rect[i].x
				subCateImageMask.y = Rect[i].y
				subCateImageMask.anchorX = Rect[i].anchorX
				subCateImageMask.anchorY = Rect[i].anchorY
				subCateImageMask.id = i
				scrollViewSubMenu[i]:insert(subCateImageMask)
				
				
				if(itemType == "Cat") then
					ItemDescriBg = display.newImageRect(imageDirectory4.."ProductNameBG.png",_W/2.04 ,_H/18.64)
				
				elseif(itemType == "Pro") then
					ItemDescriBg = display.newImageRect(imageDirectory2.."DetailsBg.png",_W/2.045,_H/10.26)
				
				end
				
				
				ItemDescriBg.x = Rect[i].x
				ItemDescriBg.y = Rect[i].y + Rect[i].height
				if(Rect[i].anchorY == 1) then
					ItemDescriBg.y = Rect[i].y
				end
				ItemDescriBg.anchorX = Rect[i].anchorX
				ItemDescriBg.anchorY = 1
				ItemDescriBg.alpha = 0.8
				scrollViewSubMenu[i]:insert(ItemDescriBg)
				
				local titleValue 
				if(sub_rowTitles[row.index].items[i]:len() > 20) then
					titleValue = sub_rowTitles[row.index].items[i]:sub( 1,20 )..".."
				else
					titleValue = sub_rowTitles[row.index].items[i]
				end
				
				subCategoryName = display.newText(titleValue,Rect[i].x,ItemDescriBg.y - ItemDescriBg.height/1.3,_FontArr[6],_H/32.44)
				if(Rect[i].anchorX == 1) then
					subCategoryName.x = Rect[i].x - Rect[i].width/2
				elseif(Rect[i].anchorX == 0) then
					subCategoryName.x = Rect[i].x + Rect[i].width/2 
				end
				subCategoryName:setTextColor( 1 )
				scrollViewSubMenu[i]:insert(subCategoryName)
				
				
				if(itemType == "Cat") then
				
					subCategoryName.y = subCategoryName.y + _H/128
				elseif(itemType == "Pro") then
				
					ItemPriceBg = display.newImageRect(imageDirectory2.."PriceBg2.png",_W/4.57,_H/36.22)
					ItemPriceBg.y = ItemDescriBg.y - ItemDescriBg.height/4
					if(Rect[i].anchorX == 1) then
						ItemPriceBg.x = Rect[i].x - Rect[i].width/2
					elseif(Rect[i].anchorX == 0) then
						ItemPriceBg.x = Rect[i].x + Rect[i].width/2 
					end
					scrollViewSubMenu[i]:insert(ItemPriceBg)
					
					ItemPrice = display.newText("$"..sub_rowTitles[row.index].prices[i].." ADD",ItemPriceBg.x,ItemPriceBg.y,_FontArr[7],_H/62.07)
					ItemPrice:setTextColor( 1 )
					scrollViewSubMenu[i]:insert(ItemPrice)
					
				
				end
		end
		
		if(#Rect > 0) then
			scrollViewSubMenu[i]:setScrollWidth( Rect[#Rect].x + Rect[#Rect].width + _W/108 )
		end
		
		
		
		
		
	end
	
end

local function onRowTouch( event )
	local phase = event.phase
	local row = event.target
	
	if "press" == phase then

	elseif "release" == phase then
		
	end
end

function populateList()
    for i = 1, #listItems do
	itmes1 = { }
	id1 = { }
	price1 = { }
	rowTitles[ #rowTitles + 1 ] = {title = listItems[i].title ,id =listItems[i].id }
	
	list:insertRow{
    	id = i,
		rowHeight = _H/15,
		rowColor = 
		{ 
			default = { 150/255, 160/255, 180/255, 200/255 },
		},
		isCategory = true,
	}
        
        if not listItems[i].collapsed then           
            if( #listItems[i].items > 2 ) then
            	rowHeight = _H/2.35
            elseif( #listItems[i].items == 0 ) then
            	rowHeight = 0
            else
            	rowHeight = _H/4.07
            end
            
            	    for j = 1, #listItems[i].items do
                    	itmes1[j] = listItems[i].items[j]
                    	id1[j] = listItems[i].ids[j]
                    	price1[j] = listItems[i].price[j]
                    end
                    sub_rowTitles[#rowTitles + 1] = {items = itmes1,ids = id1, prices = price1 }
                   	
                   	rowTitles[ #rowTitles + 1 ] = {title = "Sub categories", id = "nil"}
					
                    list:insertRow{
                        rowHeight = rowHeight,
                        isCategory = false,
                        listener = onRowTouch
                    }
                    
        end
    end
    
end

local function checkDirection()
	if(endX < beginX) then
		if((beginX - endX) > 10) then
			sub_OverRect.isVisible = false
			navigationGroup.x = navigationGroup.x - _W/1.28
			subMenuGroup.x = subMenuGroup.x - _W/1.28
			menuFlag = 0
		end
	end
	return true
end

local function onTouchNavigationOverRect( event )
	if(event.phase == "began") then
		beginX = nil
		endX = nil
		
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



local function createNavigation2()
	------------------------------------------------------------- Navigation start  --------------------------------------------------------------        
    
    
    NavigationVariableTable.sliderBg = display.newImageRect(imageDirectory.."SliderBg.png",_W/1.17,_H/1.25)
    NavigationVariableTable.sliderBg.x = -_W/1.28
    NavigationVariableTable.sliderBg.y = _H
    NavigationVariableTable.sliderBg.anchorX = 0 
    NavigationVariableTable.sliderBg.anchorY = 1
   	navigationGroup:insert( NavigationVariableTable.sliderBg )
        
    NavigationVariableTable.logo = display.newImageRect("images/Wopadu_Logo.png",_W/3.66,_H/6.78)
    NavigationVariableTable.logo.x = -_W/1.28 + _W/24 + NavigationVariableTable.logo.width/2    
    NavigationVariableTable.logo.y = _H/34.28 + NavigationVariableTable.logo.height/2    
    navigationGroup:insert( NavigationVariableTable.logo ) 
    
    NavigationVariableTable.HeaderBG = display.newImageRect(imageDirectory.."ShopDetailBg.png",_W/1.19,_H/9.14)
    NavigationVariableTable.HeaderBG.x = -_W/1.28    
    NavigationVariableTable.HeaderBG.y =  _H/5 + NavigationVariableTable.HeaderBG.height/2 
    NavigationVariableTable.HeaderBG.anchorX = 0 
    navigationGroup:insert( NavigationVariableTable.HeaderBG ) 
    
    NavigationVariableTable.ChefImage = display.newImageRect(imageDirectory.."Chef_Icon.png",_W/10.48,_H/12.71)
    NavigationVariableTable.ChefImage.x = -_W/1.28 + _W/15.88  
    NavigationVariableTable.ChefImage.y =  NavigationVariableTable.HeaderBG.y  
    NavigationVariableTable.ChefImage.anchorX = 0 
    navigationGroup:insert( NavigationVariableTable.ChefImage )
    
  
    
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
    
    if(_fName:len() > 15) then
    	UserNameText = tostring(_fName:sub(1,15))..".."
    else
    	UserNameText = _fName
    end
    
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
    
    NavigationVariableTable.ProfileEditLabel = display.newText(GBCLanguageCabinet.getText("editProfileLabel",_LanguageKey),NavigationVariableTable.sliderBg.x+ _W/1.28 - _W/108,_H/3.25  + _H/18.11,_FontArr[6],_H/45)
    NavigationVariableTable.ProfileEditLabel.anchorX = 1
    NavigationVariableTable.ProfileEditLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.ProfileEditLabel )
    
    NavigationVariableTable.ProfileEditBg = display.newRect(NavigationVariableTable.sliderBg.x+ _W/1.28  - _W/108,NavigationVariableTable.ProfileEditLabel.y - _H/192,NavigationVariableTable.ProfileEditLabel.width + _W/54, NavigationVariableTable.ProfileEditLabel.height + _H/96 )
    NavigationVariableTable.ProfileEditBg.anchorX = 1
    NavigationVariableTable.ProfileEditBg:setFillColor( 1, 1, 1, 0.1 )
    NavigationVariableTable.ProfileEditBg:addEventListener("tap",OnEditProfileTap)
    NavigationVariableTable.ProfileEditBg:addEventListener("touch",OnEditProfileTouch)
    navigationGroup:insert( NavigationVariableTable.ProfileEditBg )
    
    NavigationVariableTable.Rect1 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable.Rect1.x = -_W/1.28  
    NavigationVariableTable.Rect1.y =  _H/2.4 + NavigationVariableTable.Rect1.height/2 
    NavigationVariableTable.Rect1.anchorX = 0 
    NavigationVariableTable.Rect1.id = 1
    NavigationVariableTable.Rect1:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect1:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable.Rect1 )
    
    NavigationVariableTable.CartIcon = display.newImageRect(imageDirectory.."Cart_Icon.png",_W/18.30,_H/48)
    NavigationVariableTable.CartIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.CartIcon.y =  NavigationVariableTable.Rect1.y  
    navigationGroup:insert( NavigationVariableTable.CartIcon )
    
    NavigationVariableTable.CartLabel = display.newText(GBCLanguageCabinet.getText("viewCartLabel",_LanguageKey),-_W/1.28 + _W/7.2,NavigationVariableTable.Rect1.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.CartLabel.anchorX = 0
    NavigationVariableTable.CartLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.CartLabel )
    
    NavigationVariableTable.Rect2 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable.Rect2.x = -_W/1.28  
    NavigationVariableTable.Rect2.y =  NavigationVariableTable.Rect1.y + _H/12.22 
    NavigationVariableTable.Rect2.anchorX = 0 
    NavigationVariableTable.Rect2.id = 2
    NavigationVariableTable.Rect2:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect2:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable.Rect2 )
    
    NavigationVariableTable.OrderIcon = display.newImageRect(imageDirectory.."OrderHistory_Icon.png",_W/26.34,_H/32)
    NavigationVariableTable.OrderIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.OrderIcon.y =  NavigationVariableTable.Rect2.y  
    navigationGroup:insert( NavigationVariableTable.OrderIcon )
    
    NavigationVariableTable.OrderLabel = display.newText(GBCLanguageCabinet.getText("orderHistoryLabel", _LanguageKey),-_W/1.28 + _W/7.2,NavigationVariableTable.Rect2.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.OrderLabel.anchorX = 0
    NavigationVariableTable.OrderLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.OrderLabel )
    
    NavigationVariableTable.Rect3 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable.Rect3.x = -_W/1.28  
    NavigationVariableTable.Rect3.y =  NavigationVariableTable.Rect2.y + _H/12.22 
    NavigationVariableTable.Rect3.anchorX = 0 
    NavigationVariableTable.Rect3.id = 3
    NavigationVariableTable.Rect3:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect3:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable.Rect3 )
    
    NavigationVariableTable.FeedBackIcon = display.newImageRect(imageDirectory.."FeedBack_Icon.png",_W/17.70,_H/31.47)
    NavigationVariableTable.FeedBackIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.FeedBackIcon.y =  NavigationVariableTable.Rect3.y  
    navigationGroup:insert( NavigationVariableTable.FeedBackIcon )
    
    NavigationVariableTable.FeedBackLabel = display.newText(GBCLanguageCabinet.getText("faqLabel", _LanguageKey),-_W/1.28 + _W/7.2,NavigationVariableTable.Rect3.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.FeedBackLabel.anchorX = 0
    NavigationVariableTable.FeedBackLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.FeedBackLabel )
    
    NavigationVariableTable.Rect4 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable.Rect4.x = -_W/1.28  
    NavigationVariableTable.Rect4.y =  NavigationVariableTable.Rect3.y + _H/12.22 
    NavigationVariableTable.Rect4.anchorX = 0 
    NavigationVariableTable.Rect4.id = 4
    NavigationVariableTable.Rect4:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect4:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable.Rect4 )
    
    NavigationVariableTable.SettingIcon = display.newImageRect(imageDirectory.."Setting_Icon.png",_W/17.41,_H/30.96)
    NavigationVariableTable.SettingIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.SettingIcon.y =  NavigationVariableTable.Rect4.y  
    navigationGroup:insert( NavigationVariableTable.SettingIcon )
    
    NavigationVariableTable.SettingLabel = display.newText(GBCLanguageCabinet.getText("settingLabel", _LanguageKey),-_W/1.28 + _W/7.2,NavigationVariableTable.Rect4.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.SettingLabel.anchorX = 0
    NavigationVariableTable.SettingLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.SettingLabel )
    
    NavigationVariableTable.Rect6 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable.Rect6.x = -_W/1.28  
    NavigationVariableTable.Rect6.y =  NavigationVariableTable.Rect4.y + _H/12.22 
    NavigationVariableTable.Rect6.anchorX = 0 
    NavigationVariableTable.Rect6.id = 6
    NavigationVariableTable.Rect6:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect6:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable.Rect6 )
    
    NavigationVariableTable.RestaurantIcon = display.newImageRect(imageDirectory.."restaurant_Icon.png",_W/17.41,_H/30.96)
    NavigationVariableTable.RestaurantIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.RestaurantIcon.y =  NavigationVariableTable.Rect6.y  
    navigationGroup:insert( NavigationVariableTable.RestaurantIcon )
    
    NavigationVariableTable.RestaurantLabel = display.newText(GBCLanguageCabinet.getText("restaurantLabel", _LanguageKey),-_W/1.28 + _W/7.2,NavigationVariableTable.Rect6.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.RestaurantLabel.anchorX = 0
    NavigationVariableTable.RestaurantLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.RestaurantLabel )
    
    NavigationVariableTable.Rect5 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable.Rect5.x = -_W/1.28  
    NavigationVariableTable.Rect5.y =  NavigationVariableTable.Rect6.y + _H/12.22 
    NavigationVariableTable.Rect5.anchorX = 0 
    NavigationVariableTable.Rect5.id = 5
    NavigationVariableTable.Rect5:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect5:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable.Rect5 )
    
    NavigationVariableTable.LogOutIcon = display.newImageRect(imageDirectory.."LogOut_Icon.png",_W/17.70,_H/38.4)
    NavigationVariableTable.LogOutIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.LogOutIcon.y =  NavigationVariableTable.Rect5.y  
    navigationGroup:insert( NavigationVariableTable.LogOutIcon )
    
    NavigationVariableTable.LogOutLabel = display.newText(GBCLanguageCabinet.getText("logoutLabel", _LanguageKey),-_W/1.28 + _W/7.2,NavigationVariableTable.Rect5.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.LogOutLabel.anchorX = 0
    NavigationVariableTable.LogOutLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.LogOutLabel )
        
------------------------------------------------------------- Navigation Over  --------------------------------------------------------------        
     
end

local function createNavigation()
	------------------------------------------------------------- Navigation start  --------------------------------------------------------------        
    
    
    NavigationVariableTable.sliderBg = display.newImageRect(imageDirectory.."SliderBg.png",_W/1.17,_H/1.25)
    NavigationVariableTable.sliderBg.x = -_W/1.28
    NavigationVariableTable.sliderBg.y = _H
    NavigationVariableTable.sliderBg.anchorX = 0 
    NavigationVariableTable.sliderBg.anchorY = 1
   	navigationGroup:insert( NavigationVariableTable.sliderBg )
        
    NavigationVariableTable.logo = display.newImageRect("images/Wopadu_Logo.png",_W/3.66,_H/6.78)
    NavigationVariableTable.logo.x = -_W/1.28 + _W/24 + NavigationVariableTable.logo.width/2    
    NavigationVariableTable.logo.y = _H/34.28 + NavigationVariableTable.logo.height/2    
    navigationGroup:insert( NavigationVariableTable.logo ) 
    
    NavigationVariableTable.HeaderBG = display.newImageRect(imageDirectory.."ShopDetailBg.png",_W/1.19,_H/9.14)
    NavigationVariableTable.HeaderBG.x = -_W/1.28    
    NavigationVariableTable.HeaderBG.y =  _H/5 + NavigationVariableTable.HeaderBG.height/2 
    NavigationVariableTable.HeaderBG.anchorX = 0 
    navigationGroup:insert( NavigationVariableTable.HeaderBG ) 
    
    NavigationVariableTable.ChefImage = display.newImageRect(imageDirectory.."Chef_Icon.png",_W/10.48,_H/12.71)
    NavigationVariableTable.ChefImage.x = -_W/1.28 + _W/15.88  
    NavigationVariableTable.ChefImage.y =  NavigationVariableTable.HeaderBG.y  
    NavigationVariableTable.ChefImage.anchorX = 0 
    navigationGroup:insert( NavigationVariableTable.ChefImage )
    
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
    
    if(_fName:len() > 15) then
    	UserNameText = tostring(_fName:sub(1,15))..".."
    else
    	UserNameText = _fName
    end
    
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
    
    NavigationVariableTable.Rect1 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable.Rect1.x = -_W/1.28  
    NavigationVariableTable.Rect1.y =  _H/2.4 + NavigationVariableTable.Rect1.height/2 
    NavigationVariableTable.Rect1.anchorX = 0 
    NavigationVariableTable.Rect1.id = 1
    NavigationVariableTable.Rect1:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect1:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable.Rect1 )
    
    NavigationVariableTable.CartIcon = display.newImageRect(imageDirectory.."Cart_Icon.png",_W/18.30,_H/48)
    NavigationVariableTable.CartIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.CartIcon.y =  NavigationVariableTable.Rect1.y  
    navigationGroup:insert( NavigationVariableTable.CartIcon )
    
    NavigationVariableTable.CartLabel = display.newText(GBCLanguageCabinet.getText("viewCartLabel",_LanguageKey),-_W/1.28 + _W/7.2,NavigationVariableTable.Rect1.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.CartLabel.anchorX = 0
    NavigationVariableTable.CartLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.CartLabel )
    
    NavigationVariableTable.Rect2 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable.Rect2.x = -_W/1.28  
    NavigationVariableTable.Rect2.y =  NavigationVariableTable.Rect1.y + _H/12.22 
    NavigationVariableTable.Rect2.anchorX = 0 
    NavigationVariableTable.Rect2.id = 2
    NavigationVariableTable.Rect2:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect2:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable.Rect2 )
    
    NavigationVariableTable.OrderIcon = display.newImageRect(imageDirectory.."OrderHistory_Icon.png",_W/26.34,_H/32)
    NavigationVariableTable.OrderIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.OrderIcon.y =  NavigationVariableTable.Rect2.y  
    navigationGroup:insert( NavigationVariableTable.OrderIcon )
    
    NavigationVariableTable.OrderLabel = display.newText(GBCLanguageCabinet.getText("orderHistoryLabel", _LanguageKey),-_W/1.28 + _W/7.2,NavigationVariableTable.Rect2.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.OrderLabel.anchorX = 0
    NavigationVariableTable.OrderLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.OrderLabel )
    
    NavigationVariableTable.Rect3 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable.Rect3.x = -_W/1.28  
    NavigationVariableTable.Rect3.y =  NavigationVariableTable.Rect2.y + _H/12.22 
    NavigationVariableTable.Rect3.anchorX = 0 
    NavigationVariableTable.Rect3.id = 3
    NavigationVariableTable.Rect3:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect3:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable.Rect3 )
    
    NavigationVariableTable.FeedBackIcon = display.newImageRect(imageDirectory.."FeedBack_Icon.png",_W/17.70,_H/31.47)
    NavigationVariableTable.FeedBackIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.FeedBackIcon.y =  NavigationVariableTable.Rect3.y  
    navigationGroup:insert( NavigationVariableTable.FeedBackIcon )
    
    NavigationVariableTable.FeedBackLabel = display.newText(GBCLanguageCabinet.getText("faqLabel", _LanguageKey),-_W/1.28 + _W/7.2,NavigationVariableTable.Rect3.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.FeedBackLabel.anchorX = 0
    NavigationVariableTable.FeedBackLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.FeedBackLabel )
    
    NavigationVariableTable.Rect4 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable.Rect4.x = -_W/1.28  
    NavigationVariableTable.Rect4.y =  NavigationVariableTable.Rect3.y + _H/12.22 
    NavigationVariableTable.Rect4.anchorX = 0 
    NavigationVariableTable.Rect4.id = 4
    NavigationVariableTable.Rect4:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect4:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable.Rect4 )
    
    NavigationVariableTable.SettingIcon = display.newImageRect(imageDirectory.."Setting_Icon.png",_W/17.41,_H/30.96)
    NavigationVariableTable.SettingIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.SettingIcon.y =  NavigationVariableTable.Rect4.y  
    navigationGroup:insert( NavigationVariableTable.SettingIcon )
    
    NavigationVariableTable.SettingLabel = display.newText(GBCLanguageCabinet.getText("settingLabel", _LanguageKey),-_W/1.28 + _W/7.2,NavigationVariableTable.Rect4.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.SettingLabel.anchorX = 0
    NavigationVariableTable.SettingLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.SettingLabel )
    
    NavigationVariableTable.Rect6 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable.Rect6.x = -_W/1.28  
    NavigationVariableTable.Rect6.y =  NavigationVariableTable.Rect4.y + _H/12.22 
    NavigationVariableTable.Rect6.anchorX = 0 
    NavigationVariableTable.Rect6.id = 6
    NavigationVariableTable.Rect6:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect6:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable.Rect6 )
    
    NavigationVariableTable.RestaurantIcon = display.newImageRect(imageDirectory.."restaurant_Icon.png",_W/17.41,_H/30.96)
    NavigationVariableTable.RestaurantIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.RestaurantIcon.y =  NavigationVariableTable.Rect6.y  
    navigationGroup:insert( NavigationVariableTable.RestaurantIcon )
    
    NavigationVariableTable.RestaurantLabel = display.newText(GBCLanguageCabinet.getText("restaurantLabel", _LanguageKey),-_W/1.28 + _W/7.2,NavigationVariableTable.Rect6.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.RestaurantLabel.anchorX = 0
    NavigationVariableTable.RestaurantLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup:insert( NavigationVariableTable.RestaurantLabel )
    
    
    NavigationVariableTable.Rect5 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.28,_H/12.22)
    NavigationVariableTable.Rect5.x = -_W/1.28  
    NavigationVariableTable.Rect5.y =  NavigationVariableTable.Rect6.y + _H/12.22 
    NavigationVariableTable.Rect5.anchorX = 0 
    NavigationVariableTable.Rect5.id = 5
    NavigationVariableTable.Rect5:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect5:addEventListener("touch",onRectTouch)
    navigationGroup:insert( NavigationVariableTable.Rect5 )
    
    NavigationVariableTable.LogOutIcon = display.newImageRect(imageDirectory.."LogOut_Icon.png",_W/17.70,_H/38.4)
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
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		
		local alert = native.showAlert( alertLabel, NetworkErrorMsg, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
    else
        
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
        	
        	local alert = native.showAlert( alertLabel, "Your water request has been placed successfully.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	
        end
        
    end

	return true
end



local function handleButtonEvent( event )
		if(event.target.id == "PLACE ORDER") then
			composer.gotoScene("PlaceOrder")
		elseif( event.target.id == "WATER" ) then
			
			local headers = {}
			
			headers["Content-Type"] = "application/x-www-form-urlencoded"
			headers["Accept-Language"] = "en-US"
			
			local body = "user_id=".._UserID.."&store_id=1"
			local params = {}
			params.headers = headers
			params.body = body
			
			local url = _WebLink.."request-water.php?"
			waterRequest = network.request( url, "POST", waterListNetworkListener, params )
			native.setActivityIndicator( true )
		
		elseif( event.target.id == "home" ) then
			if(composer.getSceneName("current") == "SubMenu3") then
				if(menuFlag == 0) then
					sub_OverRect.isVisible = true
					navigationGroup.x = navigationGroup.x + _W/1.28
					subMenuGroup.x = subMenuGroup.x + _W/1.28
					menuFlag = 1
					
					
				elseif(menuFlag == 1) then
					sub_OverRect.isVisible = false
					navigationGroup.x = navigationGroup.x - _W/1.28
					subMenuGroup.x = subMenuGroup.x - _W/1.28
					menuFlag = 0
				
				end
			end
		
		elseif(event.target.id == "Language" ) then
			composer.gotoScene( "LanguageList" )	
			
		end
	return true
end

categoryId = { }
categoryName = { }
defaultPhoto = { }
image = { }
nameBg = { }
name = { }

local function onGotoSubMenu( event )
	
	local id = event.target.id:sub(1, string.find( event.target.id,"//" ) - 1 )
	
	local index = event.target.id:sub(string.find( event.target.id,"//" ) + 2,event.target.id:len())
	
	_selectedProductListCategoryID = id
	_selectedProductListCategoryName = listItems[tonumber(index)].title
	composer.gotoScene("ProductListPage")
	
	return true
end


local function subMenuListNetworkListener( event )
				m = 1
        		n = 1
        	if( #listItems > 0 ) then
        	
        	else
        		
        		noItem = display.newText( GBCLanguageCabinet.getText("NoItemsLabel",_LanguageKey), _W/2,_H/2,_FontArr[26],_H/35 )
        		noItem:setTextColor( 57/255 ,9/255 ,78/255  )
        		subMenuGroup:insert(noItem)
        		noItem:toFront()
        		
        			timer.performWithDelay( 250, function()
        			native.setActivityIndicator( false )
        			end,1)
        		
        	end		
        		
        	for i = 1,#listItems do
				categoryId[i] = listItems[i].id
        		categoryName[i] = listItems[i].title
        		
        		local imagePath = system.pathForFile( "SubCategory"..listItems[i].id..".png", system.TemporaryDirectory )
    			local imageFile = io.open( imagePath, "r" )
    				defaultPhoto[i] = display.newImageRect(imageDirectory4.."ProductBg.png", _W/2.04, _H/4.86)
					defaultPhoto[i].x = m*_W/3.98 + (_W/4.05*(m - 1))
        			defaultPhoto[i].y = n*_H/9.2 + (_H/10*(n - 1))
        			defaultPhoto[i].id = categoryId[i].."//"..i
        			defaultPhoto[i]:addEventListener( "tap", onGotoSubMenu )
        			subMenuScrollView:insert( defaultPhoto[i] )
        			
    			if imageFile then
    				
					image[i] = display.newImage("SubCategory"..listItems[i].id..".png", system.TemporaryDirectory)
					image[i].x = defaultPhoto[i].x
					image[i].y = defaultPhoto[i].y
					image[i].width = defaultPhoto[i].height/(image[i].height/image[i].width)
					image[i].height = defaultPhoto[i].height
					
					if( image[i].width > defaultPhoto[i].width ) then
						image[i].width = defaultPhoto[i].width
					else
					
					end
					subMenuScrollView:insert( image[i] )
					
					image[i]:toFront()
				end
					if(tostring(listItems[i].new_items) == "YES" ) then
						newLabel[i] = display.newImageRect(imageDirectory4.."NewLabelBg1.png", _W/6.75, _H/12.15)
						newLabel[i].x = defaultPhoto[i].x - defaultPhoto[i].width/2 
        				newLabel[i].y = defaultPhoto[i].y - defaultPhoto[i].height/2
        				newLabel[i].anchorX = 0
        				newLabel[i].anchorY = 0
        				subMenuScrollView:insert( newLabel[i] )
					end
					
					nameBg[i] = display.newImageRect(imageDirectory4.."ProductNameBG.png", defaultPhoto[i].width, _H/18.64)
					nameBg[i].anchorY = 1
					nameBg[i].x = defaultPhoto[i].x
        			nameBg[i].y = defaultPhoto[i].y + defaultPhoto[i].height/2
        			nameBg[i].alpha = 0.7
        			subMenuScrollView:insert( nameBg[i] )
					
					local option = {
						text = listItems[i].title,
						x = nameBg[i].x,
						y =  nameBg[i].y - nameBg[i].height/2 - _H/96,
						width = _W/2.25,
						height = _H/32.47,
						font = _FontArr[6],
						fontSize =  _H/32.47,
						align = "center"
					}
					
					
					name[i] = display.newText( option )
					name[i].anchorY = 0
    				name[i]:setFillColor( 1 )
    				subMenuScrollView:insert( name[i] )
    			
				
				if(i%2 == 0)then
					n = n + 1
					m = 1
				else
					m = m + 1
				end
				
				if( i == #listItems ) then
        		
        		timer.performWithDelay( 250,function() 
        			native.setActivityIndicator( false )
        		
        		for i = 1, #image do
        			if( image[i] ) then
        			
        				image[i]:toFront()
        				nameBg[i]:toFront()
        				name[i]:toFront()
        				if( newLabel[i] ) then
        					newLabel[i]:toFront()
        				end
        			end
        		end
        		
        		end, 1)
        		
        		end
				
        	end
end

local function onShowDisplay()

 	myImages = { }
    for i = 1, #_menuList do
     	if(_menuList[i].id == _selectedMainCategoryID) then
     		if(_menuList[i].images.image_1 == "" or _menuList[i].images.image_1 == " " or _menuList[i].images.image_1 == nil) then
     			
     		else
     			local imagePath = system.pathForFile( "MainCategory".._selectedMainCategoryID..".png", system.TemporaryDirectory )
    			local imageFile = io.open( imagePath, "r" )
    			if(imageFile == nil) then
    			
    			else
     				table.insert(myImages,"MainCategory".._selectedMainCategoryID..".png")
     			end
     		end
     		
     		if(_menuList[i].images.image_2 == "" or _menuList[i].images.image_2 == " " or _menuList[i].images.image_2 == nil) then
     		
     		else
     			local imagePath = system.pathForFile( "MainCategory".._selectedMainCategoryID.."_2.png", system.TemporaryDirectory )
    			local imageFile = io.open( imagePath, "r" )
    			if(imageFile == nil) then
    			
    			else
     				table.insert(myImages,"MainCategory".._selectedMainCategoryID.."_2.png")
     			end
     			
     		end
     		
     		if(_menuList[i].images.image_3 == "" or _menuList[i].images.image_3 == " " or _menuList[i].images.image_3 == nil) then
     		
     		else
     			local imagePath = system.pathForFile( "MainCategory".._selectedMainCategoryID.."_3.png", system.TemporaryDirectory )
    			local imageFile = io.open( imagePath, "r" )
    			if(imageFile == nil) then
    			
    			else
     				table.insert(myImages,"MainCategory".._selectedMainCategoryID.."_3.png")
     			end
     			
     		end
     		
     	end
     end
     
     
     homeBtn:toFront()
   
    subCategoryTable = { }
    
    for i = 1, #_menuList do
    
     	if( _selectedMainCategoryID == _menuList[i].id ) then
      		subCategoryTable = _menuList[i].sub_menu
      		local MenuTitleValue = _menuList[i].category_name
      		MenuTitle.text = MenuTitleValue
      		
      		
      		break
		end
	end
	
	MainCategory = { }
	for i = 1 , #subCategoryTable do
        	if(i == 1) then
        	else
        		listItems[#listItems + 1] = { title = MainCatValue, id = MainCatID, new_items = new_item, collapsed = true, items = subCateArray, ids = subCateIDArray , price = subCatePriceArray }
        	end
        	
        		subCateArray = { }
        		subCateIDArray = { }
        		subCatePriceArray = { }
        		MainCatValue = subCategoryTable[i].category_name
        		MainCatID = subCategoryTable[i].id
        		new_item = subCategoryTable[i].new_items
        		k = #subCategoryTable[i].sub_menu
        		
        		if(k > 0) then
        			for  j = 1, k do
        				table.insert( subCateArray,subCategoryTable[i].sub_menu[j].category_name)
        				table.insert( subCateIDArray,subCategoryTable[i].sub_menu[j].id.."Cat")
        				table.insert( subCatePriceArray,"NA")
        			end
        			
        		else
        			if(#productData > 0) then
        				for j = 1, #productData do
        					
        					if(subCategoryTable[i].id == productData[j].categoryID) then
        							
        						if(productData[j].productDetail) then
        							
        							table.insert( subCateArray,productData[j].productDetail.item_name)
        							table.insert( subCateIDArray,productData[j].productDetail.id.."Pro")
        							table.insert( subCatePriceArray,productData[j].productDetail.price)
        							
        						end
        					
        					end
        				end
        			end
        		end
        		
        
        	if(i == #subCategoryTable) then
        		listItems[#listItems + 1] = { title = MainCatValue, id = MainCatID,new_items = new_item, collapsed = true, items = subCateArray, ids = subCateIDArray, price = subCatePriceArray }
        	end
    end
	
	subMenuListNetworkListener() 


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
	param = event.params
	
    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
     menuFlag = 0
     
     if( #listItems > 0 ) then
     	native.setActivityIndicator( true )
     end
     
     _previousScene = composer.getSceneName( "current" )
     
    _PreviousSceneforSetting = composer.getSceneName( "current" )
    
    _PreviousSceneforOrder = composer.getSceneName( "current" )
     
     Background = display.newImageRect(imageDirectory.."Background.png",_W,_H)
     Background.x = _W/2
     Background.y = _H/2
     sceneGroup:insert(Background)
     
     navigationGroup = display.newGroup()
     sceneGroup:insert(navigationGroup)
     
     createNavigation()
     
     subMenuGroup = display.newGroup()
     sceneGroup:insert(subMenuGroup)
     
     
     Bg = display.newImageRect("images/MainMenu/Background.png",_W,_H)
     Bg.x = _W/2
     Bg.y = _H/2
     subMenuGroup:insert(Bg)
     
     HeaderBg = display.newImageRect(imageDirectory4.."Header.png",_W,_H/9.18)
     HeaderBg.x = _W/2
     HeaderBg.y = 0
     HeaderBg.anchorY = 0
     subMenuGroup:insert(HeaderBg)
     
     
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
	homeBtn:addEventListener("tap",handleButtonEvent)
	subMenuGroup:insert( homeBtn )
     
     restaurantName = display.newText(_HotelName:upper(), HeaderBg.x, HeaderBg.y + _H/27.42, _FontArr[6], _H/30 )
     restaurantName:setFillColor( 83/255, 20/255, 111/255 )
     subMenuGroup:insert( restaurantName )
        
      local option = {
        	text = tostring(_HotelAddress),
        	x = restaurantName.x,
        	y =  restaurantName.y + restaurantName.height/2 + _H/96,
        	width = _W/2,
        	height = _H/54.85,
        	font = _FontArr[30],
        	fontSize = _H/57.66,
        	align = "center"
        }    
        
        
        
     restaurantAdd = display.newText( option )
     restaurantAdd:setFillColor( 83/255, 20/255, 111/255 )
     subMenuGroup:insert( restaurantAdd )
    
     header2 = display.newImageRect( imageDirectory4.."TabBg.png", _W, _H/20.21 )
     header2.x = _W/2
     header2.y = _H/11.85 + header2.height/2 + _H/96
     header2:setFillColor( 254/255, 246/255, 245/255 )
     subMenuGroup:insert( header2 )
    
    
     	placeOrderBtn = widget.newButton
		{
    		width = _W/5.51,
    		height = _H/24,
    		defaultFile = "images/language2.png",
   			overFile = "images/language2.png",
   			label = GBCLanguageCabinet.getText("cartLabel2",_LanguageKey),
   			labelYOffset = -3,
   			labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
   			font = _FontArr[1],
   			fontSize = _H/60,
    		id = "PLACE ORDER",
		}
		placeOrderBtn.x = _W - _W/36
		placeOrderBtn.y = header2.y
		placeOrderBtn.anchorX = 1
		placeOrderBtn:addEventListener("tap",handleButtonEvent)
		subMenuGroup:insert( placeOrderBtn )
		
		Language = widget.newButton
		{
    		width = _W/5.51,
    		height = _H/24,
    		defaultFile = "images/language2.png",
   			overFile = "images/language2.png",
   			label = GBCLanguageCabinet.getText("languageLabel", _LanguageKey),
   			labelYOffset = -3,
   			labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
   			font = _FontArr[1],
   			fontSize = _H/60,
    		id = "Language",
		}
		Language.x = _W/36
		Language.y = header2.y
		Language.anchorX = 0
		Language:addEventListener("tap",handleButtonEvent)
		subMenuGroup:insert( Language )
		
     MenuTitleBg = display.newImageRect(imageDirectory2.."TitleBg.png",_W,_H/14.22)
     MenuTitleBg.x = _W/2
     MenuTitleBg.y = _H/7.5 + MenuTitleBg.height/2 +_H/96
     subMenuGroup:insert(MenuTitleBg)
     
     MenuTitle = display.newText( "", _W/7.2, MenuTitleBg.y, MenuTitleBg.width - _W/54, 0, _FontArr[6], _H/27.42 )
     MenuTitle.anchorX = 0
     MenuTitle:setFillColor( 1 )
     subMenuGroup:insert( MenuTitle )
    
	backBtn = widget.newButton
	{
    	width = _W/9,
    	height = _H/14.76,
    	defaultFile = imageDirectory3.."Back_Btn1.png",
   		overFile = imageDirectory3.."Back_Btn1.png",
    	id = "back",
	}
	backBtn.x = _W/36 + backBtn.width/2
	backBtn.y = MenuTitleBg.y
	subMenuGroup:insert( backBtn )
	 	 
   local yPos = MenuTitleBg.y + MenuTitleBg.height/2 + _H/960 
	
	local function scrollListener( event )
		
		return true
	end
	
subMenuScrollView = widget.newScrollView
{
    top = yPos + _H/960 ,
    left = 0,
    width = _W,
    height = _H - MenuTitleBg.height/2,
    scrollWidth = _W,
    scrollHeight = _H * 2,
    hideBackground = true,
    horizontalScrollDisabled = true
}
subMenuGroup:insert(subMenuScrollView)   


categoryBtn = { }

	local function onTouchRect(e)
		if( e.phase == "moved" ) then
			
			local dy = math.abs( ( e.y - e.yStart ) )
        	if ( dy > 10 ) then
            	subMenuScrollView:takeFocus( e )
        	else
        		
        	end
        	
        	local dx = math.abs( ( e.x - e.xStart ) )
        	if ( dx > 10 ) then
            	scrollViewSubMenu[e.target.id]:takeFocus( e )
        	else
        		
        	end
			
		end
		return true
	end
	
   
    sub_OverRect = display.newRect(_W/2,_H/2,_W,_H)
   	sub_OverRect:setFillColor( 0,0,0,0.1 )
   	sub_OverRect:addEventListener("touch",onTouchNavigationOverRect)
   	sceneGroup:insert( sub_OverRect )
    sub_OverRect.isVisible = false
  
  	homeBtn:toFront()
  
    
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
      	local function onShow()
      		if(backBtn) then
        		backBtn:addEventListener("tap",handleBackButtonEvent)
        	end
        	
        	createNavigation()
        	onShowDisplay()
        	
    	end
        
        timer.performWithDelay( 250 , onShow)
        composer.removeScene("previous")
        
        
        
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
			menuFlag = 0
			transition.to( navigationGroup, { time=0, x=navigationGroup.x - _W/1.28,onComplete = addEvents  } )
			transition.to( subMenuGroup, { time=0, x=subMenuGroup.x - _W/1.28 } )
		end
        
        display.remove(sub_OverRect)
        sub_OverRect = nil
      
      	beginX = nil
      	endX = nil
      
        for i = 1, #NavigationVariableTable do
        
        	display.remove(NavigationVariableTable[i])
        	NavigationVariableTable[i] = nil
        	
        end
        
      if(rowTitles) then
        for k,v in pairs(rowTitles) do rowTitles[k]=nil end
        end
        if(sub_rowTitles) then
   	 	for k,v in pairs(sub_rowTitles) do sub_rowTitles[k]=nil end
      end
        
        display.remove(navigationGroup)
        navigationGroup = nil
        
	 	
	 	display.remove(HeaderBg)
	 	HeaderBg = nil
	 	
	 	display.remove(Bg)
	 	Bg = nil
	 	
	 	display.remove(restaurantName)
	 	restaurantName = nil
	 	
	 	display.remove(restaurantAdd)
	 	restaurantAdd = nil
	 	
	 	display.remove(MenuTitle)
	 	MenuTitle = nil
	 	
	 	display.remove(MenuTitleBg)
	 	MenuTitleBg = nil
	 	
	 	display.remove(backBtn)
	 	backBtn = nil
	 	
	 	display.remove(backBg)
	 	backBg = nil
	 	
	 	rowTitles = {}
 		sub_rowTitles = {}
 		Rect = { }
 		nameBg = { }
 		subCategoryTable = { }

 		listItems = { } 
 		subCateIDArray = { }
 		subCateArray = { }
		subCateImage = { }
		newLabel = { }
		
	 	display.remove(Background)
	 	Background = nil
	 	
	 	display.remove( homeBtn )
	 	homeBtn = nil
	 	
	 	if sldView then
	 		display.remove( sldView )
	 		sldView = nil
	 	end
	 	
	 	for i = 1, #scrollViewSubMenu do
	 		if(scrollViewSubMenu[i]) then
	 			display.remove(scrollViewSubMenu[i])
	 			scrollViewSubMenu[i] = nil
	 		end
	 	end
	 
	 	display.remove(list)
        list = nil
        
        display.remove(subMenuGroup)
	 	subMenuGroup = nil
        
        
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