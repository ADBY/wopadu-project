local scene = composer.newScene()

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
local subCategoryTable2 = { }

local listItems = { } 
local subCateIDArray = { }
local subCateArray = { }
local subCateImage = { }
local scrollView = { }

local navigationGroup2,lastSubMenuGroup,menuFlag, scrollView, param


local NavigationVariableTable = { "sliderBg", "logo", "HeaderBG", "ChefImage", "ProfileBg", "Rect1", "Rect2", "Rect3", "Rect4","Rect5",
"CartIcon", "OrderIcon", "FeedBackIcon", "SettingIcon", "LogOutIcon", "ProfilePicBg", "ProfileEditLabel", "ProfileEditBg", "CartLabel", 
"OrderLabel", "FeedBackLabel", "SettingLabel", "LogOutLabel", "UserName", "UserEmail", "HotelAddress", "HotelName", "MenuProductImage" }
 
 
local VariableTable2 = { "HeaderBg", "MenuIcon2", "Bg", "restaurantName", "restaurantAdd", "MenuTitle", "MenuTitleBg", "backBtn", "backBg", "list2"  } 

local HeaderBg, MenuIcon2, Bg, restaurantName, restaurantAdd, MenuTitle, MenuTitleBg, backBtn, backBg, list2


local function onDoNothing( event )

	return true
end


local function handleBackButtonEvent( event )

	print("back to main menu")
	composer.gotoScene("SubMenu")
	
	return true
end

local function handleBackButtonEventTouch( event )
	if event.phase == "ended" then
		print("back to main menu")
		composer.gotoScene("SubMenu")
	end
	
	return true
end

function openNavigationTap2( event )
	if(composer.getSceneName("current") == "SubToSubMenu") then
	 MenuBg2:removeEventListener("tap",openNavigationTap2)
    -- MenuBg2:removeEventListener("touch",openNavigationTouch)
     
     local function addEvents( event )

	 	MenuBg2:addEventListener("tap",openNavigationTap2)
    	--MenuBg2:addEventListener("touch",openNavigationTouch)
		return true
	end
	
	if(menuFlag == 0) then
		
		--[[navigationGroup2.x = navigationGroup2.x + _W/1.28
		lastSubMenuGroup.x = lastSubMenuGroup.x + _W/1.28]]--
		menuFlag = 1
		transition.to( navigationGroup2, { time=0, x=navigationGroup2.x + _W/1.28,onComplete = addEvents } )
		transition.to( lastSubMenuGroup, { time=0, x=lastSubMenuGroup.x + _W/1.28 } )
		
	elseif(menuFlag == 1) then
		
		--navigationGroup2.x = navigationGroup2.x - _W/1.28
		--lastSubMenuGroup.x = lastSubMenuGroup.x - _W/1.28
		menuFlag = 0
		transition.to( navigationGroup2, { time=0, x=navigationGroup2.x - _W/1.28,onComplete = addEvents  } )
		transition.to( lastSubMenuGroup, { time=0, x=lastSubMenuGroup.x - _W/1.28 } )
		
	end
	end
	return true
end

function openNavigationTouch( event )
	if(event.phase == "began") then
		if(composer.getSceneName("current") == "SubToSubMenu") then
		 MenuBg2:removeEventListener("tap",openNavigationTap2)
     	MenuBg2:removeEventListener("touch",openNavigationTouch)
     	
     	 local function addEvents( event )

	 		MenuBg2:addEventListener("tap",openNavigationTap2)
    		MenuBg2:addEventListener("touch",openNavigationTouch)
			return true
		end
		if(menuFlag == 0) then
	
			--navigationGroup2.x = navigationGroup2.x + _W/1.28
			--lastSubMenuGroup.x = lastSubMenuGroup.x + _W/1.28
			menuFlag = 1
			transition.to( navigationGroup2, { time=1000, x=navigationGroup2.x + _W/1.28,onComplete = addEvents  } )
			transition.to( lastSubMenuGroup, { time=1000, x=lastSubMenuGroup.x + _W/1.28 } )
		elseif(menuFlag == 1) then
		
			--navigationGroup2.x = navigationGroup2.x - _W/1.28
			--lastSubMenuGroup.x = lastSubMenuGroup.x - _W/1.28
			menuFlag = 0
			transition.to( navigationGroup2, { time=1000, x=navigationGroup2.x - _W/1.28,onComplete = addEvents } )
			transition.to( lastSubMenuGroup, { time=1000, x=lastSubMenuGroup.x - _W/1.28 } )
		end
	end
	end
	return true
end

local function OnEditProfileTap( event )
		composer.getSceneName("editProfile")
	return true
end

local function OnEditProfileTouch( event )
	if(event.phase == "began") then
		composer.getSceneName("editProfile")
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
			--[[_UserName = nil
			_Password = nil
			_UserID = nil
			_Varified = nil

			os.remove( system.pathForFile( "Password", system.DocumentsDirectory ) )
			os.remove( system.pathForFile( "UserID", system.DocumentsDirectory ) )
			os.remove( system.pathForFile( "UserName", system.DocumentsDirectory ) )
			os.remove( system.pathForFile( "Varified", system.DocumentsDirectory ) )
			
			
			_selectedMainCategoryID = nil
			
			composer.gotoScene( "login" )]]--
		logOutFunc()	
			
		
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
		
		end
	end
	return true
end


local function onCategoryTap(event)
    local row = event.target
    print("tapped Category", row.id)
    
    for k,v in pairs(rowTitles) do rowTitles[k]=nil end
    for k,v in pairs(sub_rowTitles) do sub_rowTitles[k]=nil end
    
    for i = 1, #listItems do
    	if(i == 1) then
    	
    	else
    		listItems[i].collapsed = true
    	
    	end
    end
    
    listItems[row.id].collapsed = not listItems[row.id].collapsed
    list2:deleteAllRows()
    populateList2()
end

local function onCategoryRectTap( event )
	
	print("rect of category tapped/////////////")
	print(event.target.id)
	
	local targetId = event.target.id:sub(1,event.target.id:len() - 3)
	local targetType = event.target.id:sub(event.target.id:len() - 2,event.target.id:len())
	if(targetType == "Cat") then
		local option = {
			time = 400,
			effect = "fade"
		}
	
		--_selectedLastSubCategoryID = event.target.id
		--composer.gotoScene("SubToSubMenu")
		
		
	elseif(targetType == "Pro") then
		local option = {
			time = 400,
			effect = "fade"
		}
	
		_selectedProductID = event.target.id
		composer.gotoScene("Product")
	end
	return true
end


-- Handle row rendering
local function onRowRender( event )
	local phase = event.phase
	local row = event.row
	local isCategory = row.isCategory
	local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth
	print("row rende")
	-- in graphics 2.0, the group contentWidth / contentHeight are initially 0, and expand once elements are inserted into the group.
	-- in order to use contentHeight properly, we cache the variable before inserting objects into the group

	local groupContentHeight = row.contentHeight
	
	
	if isCategory then
            
            local categoryBtn = display.newImageRect( row,imageDirectory2.."RowBg.png", row.width, row.height )
            categoryBtn.anchorX, categoryBtn.anchorY = 0, 0
            categoryBtn:addEventListener ( "tap", onCategoryTap )
            --categoryBtn.alpha = 0
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
			
			
			local rowIcon = display.newImageRect(row, "SubToSub2Category"..rowTitles[row.index].id..".png",system.TemporaryDirectory,_W/10.8,_H/19.2)
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
		
		
		scrollView = widget.newScrollView
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
		row:insert(scrollView)
		
		
				
				
		
		print("$$$$$$$")
		local Rows = math.ceil( #sub_rowTitles[row.index].items/2 )
		Rect = { }
		nameBg = { }
		
		if(#sub_rowTitles[row.index].items <= 2) then
			j = 1
			print("less then two sub category available")
			
			for j = 1, #sub_rowTitles[row.index].items do
			print(j)
			if(j == 1) then
				print("first category")
				Rect[1] = display.newImageRect(imageDirectory2.."TileBg.png",_W/2.04 ,_H/4.86)
				Rect[1].x = 0 + _W/155 --rowWidth * 0.0065
				Rect[1].y = rowHeight * 0.010
				Rect[1].anchorX = 0
				Rect[1].anchorY = 0
				Rect[1].id = sub_rowTitles[row.index].ids[1]
				Rect[1]:addEventListener("tap",onCategoryRectTap)
				scrollView:insert(Rect[1])
				
			elseif(j == 2) then
				print("second category")
				Rect[j] = display.newImageRect(imageDirectory2.."TileBg.png",_W/2.04 ,_H/4.86)
				Rect[j].x = Rect[j-1].x + Rect[j-1].width + _W/155
				Rect[j].y = rowHeight * 0.010
				Rect[j].anchorX = 0
				Rect[j].anchorY = 0
				Rect[j].id = sub_rowTitles[row.index].ids[j]
				Rect[j]:addEventListener("tap",onCategoryRectTap)
				scrollView:insert(Rect[j])
				
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
				scrollView:insert(Rect[j])

				if(sub_rowTitles[row.index].items[j+1]) then
				
					Rect[j + 1] = display.newImageRect(imageDirectory2.."TileBg.png",_W/2.04 ,_H/4.86)
					Rect[j + 1].x = rowWidth * 0.005
					Rect[j + 1].y = rowHeight * 0.990
					Rect[j + 1].anchorX = 0
					Rect[j + 1].anchorY = 1
					Rect[j + 1].id = sub_rowTitles[row.index].ids[j+1]
					Rect[j + 1]:addEventListener("tap",onCategoryRectTap)
					scrollView:insert(Rect[j + 1])
					
				end
			
				else
				
					Rect[j] = display.newImageRect(imageDirectory2.."TileBg.png",_W/2.04 ,_H/4.86)
					Rect[j].x = Rect[j-1].x + Rect[j-1].width + _W/108
					Rect[j].y = rowHeight * 0.010 
					Rect[j].anchorX = 0
					Rect[j].anchorY = 0
					Rect[j].id = sub_rowTitles[row.index].ids[j]
					Rect[j]:addEventListener("tap",onCategoryRectTap)
					scrollView:insert(Rect[j])
					
					if(sub_rowTitles[row.index].items[j+1]) then
				
						Rect[j + 1] = display.newImageRect(imageDirectory2.."TileBg.png",_W/2.04 ,_H/4.86)
						Rect[j + 1].x = Rect[j-1].x + Rect[j-1].width + _W/108--Rect[j + 1].x 
						Rect[j + 1].y = rowHeight * 0.990
						Rect[j + 1].anchorX = 0
						Rect[j + 1].anchorY = 1
						Rect[j + 1].id = sub_rowTitles[row.index].ids[j+1]
						Rect[j + 1]:addEventListener("tap",onCategoryRectTap)
						scrollView:insert(Rect[j + 1])
						
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
        		scrollView:insert( nameBg[i] )
        		
        		
        		if(math.fmod(i,2) == 0) then
					nameBg[i].y = Rect[i].y 
				end
				
			end
		
		end
		
		print("sub to sub category")
		print(#sub_rowTitles[row.index].ids)
		
		--sub_rowTitles[#rowTitles + 1] = {items = itmes1,ids = id1}
		
		for i = 1,#Rect do
		
				local itemType = sub_rowTitles[row.index].ids[i]:sub(sub_rowTitles[row.index].ids[i]:len() - 2,sub_rowTitles[row.index].ids[i]:len())
				local itemID = sub_rowTitles[row.index].ids[i]:sub(1,sub_rowTitles[row.index].ids[i]:len() - 3)
				print(sub_rowTitles[row.index].ids[i])
				print(itemType)
				print(itemID)
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
				subCateImage[i].width = _H/4.86 /(subCateImage[i].height/subCateImage[i].width )--_W/2.04 
				subCateImage[i].height = _H/4.86
				subCateImage[i].anchorX = Rect[i].anchorX
				subCateImage[i].anchorY = Rect[i].anchorY
				subCateImage[i].id = i
				--subCateImage[i]:addEventListener("tap",onCategoryRectTap)
				scrollView:insert(subCateImage[i])
				
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
				scrollView:insert(subCateImageMask)
				
				
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
				scrollView:insert(ItemDescriBg)
				
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
				scrollView:insert(subCategoryName)
				
				
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
					scrollView:insert(ItemPriceBg)
					
					ItemPrice = display.newText("$"..sub_rowTitles[row.index].prices[i].." ADD",ItemPriceBg.x,ItemPriceBg.y,_FontArr[7],_H/62.07)
					ItemPrice:setTextColor( 1 )
					scrollView:insert(ItemPrice)
					
				
				end
		end
		
		if(#Rect > 0) then
			scrollView:setScrollWidth( Rect[#Rect].x + Rect[#Rect].width + _W/108 )
		end
		
		
		--[[RectOnTop = display.newRect(rowWidth * 0.5,rowHeight * 0.5,_W,rowHeight)
		RectOnTop:setFillColor( 1,0,0,0.1 )
		row:insert(RectOnTop)
		RectOnTop:toFront()]]--
		
		
	end
	
	
	--rowTitle:toFront()
	
	
end

-- Hande row touch events
local function onRowTouch( event )
	local phase = event.phase
	local row = event.target
	
	if "press" == phase then
		print( "Pressed row: " .. row.index )

	elseif "release" == phase then
		-- Update the item selected text
		print("You selected: " .. rowTitles[row.index])
	
		print( "Tapped and/or Released row: " .. row.index )
		
		print(#subCategoryTable2.sub_menu[event.row.index].sub_menu)
		
	end
end

function populateList2()
	print("inside populate func")
    for i = 1, #listItems do
	--Add the rows category title
	itmes1 = { }
	id1 = { }
	price1 = { }
	rowTitles[ #rowTitles + 1 ] = {title = listItems[i].title ,id =listItems[i].id }
	
	--Insert the category
	list2:insertRow{
    	id = i,
		rowHeight = _H/15,
		rowColor = 
		{ 
			default = { 150/255, 160/255, 180/255, 200/255 },
		},
		isCategory = true,
	}
        
        if not listItems[i].collapsed then
            --Insert the item
           
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
                    print("sub categoryID "..#id1)
                    sub_rowTitles[#rowTitles + 1] = {items = itmes1,ids = id1, prices = price1 }
                   
                    
            --for j = 1, #listItems[i].items do
                    --Add the rows item title
                    rowTitles[ #rowTitles + 1 ] = {title = "Sub categories", id = "nil"}
					
                    --Insert the item
                    list2:insertRow{
                        rowHeight = rowHeight,
                        isCategory = false,
                        listener = onRowTouch
                    }
                    
                    
            --end            
        end
    end
    
end


local function createNavigation()
	------------------------------------------------------------- Navigation start  --------------------------------------------------------------        
    
    
    NavigationVariableTable.sliderBg = display.newImageRect(imageDirectory.."SliderBg.png",_W/1.17,_H/1.25)
    NavigationVariableTable.sliderBg.x = -_W/1.28
    NavigationVariableTable.sliderBg.y = _H
    NavigationVariableTable.sliderBg.anchorX = 0 
    NavigationVariableTable.sliderBg.anchorY = 1
   	navigationGroup2:insert( NavigationVariableTable.sliderBg )
        
    NavigationVariableTable.logo = display.newImageRect(imageDirectory.."Logo.png",_W/3.66,_H/6.78)
    NavigationVariableTable.logo.x = -_W/1.28 + _W/24 + NavigationVariableTable.logo.width/2    
    NavigationVariableTable.logo.y = _H/34.28 + NavigationVariableTable.logo.height/2    
    navigationGroup2:insert( NavigationVariableTable.logo ) 
    
    NavigationVariableTable.HeaderBG = display.newImageRect(imageDirectory.."ShopDetailBg.png",_W/1.19,_H/9.14)
    NavigationVariableTable.HeaderBG.x = -_W/1.28    
    NavigationVariableTable.HeaderBG.y =  _H/5 + NavigationVariableTable.HeaderBG.height/2 
    NavigationVariableTable.HeaderBG.anchorX = 0 
    navigationGroup2:insert( NavigationVariableTable.HeaderBG ) 
    
    NavigationVariableTable.ChefImage = display.newImageRect(imageDirectory.."Chef_Icon.png",_W/10.48,_H/12.71)
    NavigationVariableTable.ChefImage.x = -_W/1.28 + _W/15.88  
    NavigationVariableTable.ChefImage.y =  NavigationVariableTable.HeaderBG.y  
    NavigationVariableTable.ChefImage.anchorX = 0 
    navigationGroup2:insert( NavigationVariableTable.ChefImage )
    
    
    
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
    navigationGroup2:insert( NavigationVariableTable.HotelName )
    
    NavigationVariableTable.HotelAddress = display.newText(HotelAddressText,-_W/1.28 + _W/4.9,_H/3.93,_W/2,0,_FontArr[30],_H/63.03 )
    NavigationVariableTable.HotelAddress.anchorX = 0
    NavigationVariableTable.HotelAddress.anchorY = 0
    NavigationVariableTable.HotelAddress:setTextColor( 1 )
    navigationGroup2:insert( NavigationVariableTable.HotelAddress )
    
    
    NavigationVariableTable.ProfileBg = display.newImageRect(imageDirectory.."ProfileBg.png",_W/1.19,_H/9.05)
    NavigationVariableTable.ProfileBg.x = -_W/1.28  
    NavigationVariableTable.ProfileBg.y =  _H/3.25 + NavigationVariableTable.ProfileBg.height/2 
    NavigationVariableTable.ProfileBg.anchorX = 0 
    navigationGroup2:insert( NavigationVariableTable.ProfileBg )
    
    NavigationVariableTable.ProfilePicBg = display.newImageRect(imageDirectory.."ProfilePicBg.png",_W/7.39,_H/13.06)
    NavigationVariableTable.ProfilePicBg.x = -_W/1.28 + _W/27  
    NavigationVariableTable.ProfilePicBg.y =  NavigationVariableTable.ProfileBg.y
    NavigationVariableTable.ProfilePicBg.anchorX = 0 
    navigationGroup2:insert( NavigationVariableTable.ProfilePicBg )
    
    _Name = "Krishna Maru"
    _UserName = "krishnamaru123@gmail.com"
    
    if(_Name:len() > 15) then
    	UserNameText = tostring(_Name:sub(1,15))..".."
    else
    	UserNameText = _Name
    end
    
    NavigationVariableTable.UserName = display.newText(UserNameText,-_W/1.28 + _W/4.9,_H/2.74,_FontArr[6],_H/31.51 )
    NavigationVariableTable.UserName.anchorX = 0
    NavigationVariableTable.UserName.anchorY = 1
    NavigationVariableTable.UserName:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup2:insert( NavigationVariableTable.UserName )
    
    if(_UserName:len() > 25) then
    	UserMailText = tostring(_UserName:sub(1,25))..".."
    else
    	UserMailText = _UserName
    end
    
    NavigationVariableTable.UserEmail = display.newText(UserMailText,-_W/1.28 + _W/4.9,_H/2.57,_FontArr[6],_H/55.15 )
    NavigationVariableTable.UserEmail.anchorX = 0
    NavigationVariableTable.UserEmail.anchorY = 1
    NavigationVariableTable.UserEmail:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup2:insert( NavigationVariableTable.UserEmail )
    
    NavigationVariableTable.ProfileEditLabel = display.newText("Edit Profile",-_W/1.28 + _W/1.59,NavigationVariableTable.ProfilePicBg.y,_FontArr[6],_H/50 )
    NavigationVariableTable.ProfileEditLabel.anchorX = 0
    NavigationVariableTable.ProfileEditLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup2:insert( NavigationVariableTable.ProfileEditLabel )
    
    NavigationVariableTable.ProfileEditBg = display.newRect(-_W/1.28 + _W/1.59 - _W/108,NavigationVariableTable.ProfileEditLabel.y - _H/192,NavigationVariableTable.ProfileEditLabel.width + _W/54, NavigationVariableTable.ProfileEditLabel.height + _H/96 )
    NavigationVariableTable.ProfileEditBg.anchorX = 0
    NavigationVariableTable.ProfileEditBg:setFillColor( 1, 1, 1, 0.1 )
    NavigationVariableTable.ProfileEditBg:addEventListener("tap",OnEditProfileTap)
    NavigationVariableTable.ProfileEditBg:addEventListener("touch",OnEditProfileTouch)
    navigationGroup2:insert( NavigationVariableTable.ProfileEditBg )
    
    NavigationVariableTable.Rect1 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.19,_H/12.22)
    NavigationVariableTable.Rect1.x = -_W/1.28  
    NavigationVariableTable.Rect1.y =  _H/2.4 + NavigationVariableTable.Rect1.height/2 
    NavigationVariableTable.Rect1.anchorX = 0 
    NavigationVariableTable.Rect1.id = 1
    NavigationVariableTable.Rect1:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect1:addEventListener("touch",onRectTouch)
    navigationGroup2:insert( NavigationVariableTable.Rect1 )
    
    NavigationVariableTable.CartIcon = display.newImageRect(imageDirectory.."Cart_Icon.png",_W/18.30,_H/48)
    NavigationVariableTable.CartIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.CartIcon.y =  NavigationVariableTable.Rect1.y  
    navigationGroup2:insert( NavigationVariableTable.CartIcon )
    
    NavigationVariableTable.CartLabel = display.newText("View Cart",-_W/1.28 + _W/7.2,NavigationVariableTable.Rect1.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.CartLabel.anchorX = 0
    NavigationVariableTable.CartLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup2:insert( NavigationVariableTable.CartLabel )
    
    NavigationVariableTable.Rect2 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.19,_H/12.22)
    NavigationVariableTable.Rect2.x = -_W/1.28  
    NavigationVariableTable.Rect2.y =  NavigationVariableTable.Rect1.y + _H/12.22 
    NavigationVariableTable.Rect2.anchorX = 0 
    NavigationVariableTable.Rect2.id = 2
    NavigationVariableTable.Rect2:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect2:addEventListener("touch",onRectTouch)
    navigationGroup2:insert( NavigationVariableTable.Rect2 )
    
    NavigationVariableTable.OrderIcon = display.newImageRect(imageDirectory.."OrderHistory_Icon.png",_W/26.34,_H/32)
    NavigationVariableTable.OrderIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.OrderIcon.y =  NavigationVariableTable.Rect2.y  
    navigationGroup2:insert( NavigationVariableTable.OrderIcon )
    
    NavigationVariableTable.OrderLabel = display.newText("Order History",-_W/1.28 + _W/7.2,NavigationVariableTable.Rect2.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.OrderLabel.anchorX = 0
    NavigationVariableTable.OrderLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup2:insert( NavigationVariableTable.OrderLabel )
    
    NavigationVariableTable.Rect3 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.19,_H/12.22)
    NavigationVariableTable.Rect3.x = -_W/1.28  
    NavigationVariableTable.Rect3.y =  NavigationVariableTable.Rect2.y + _H/12.22 
    NavigationVariableTable.Rect3.anchorX = 0 
    NavigationVariableTable.Rect3.id = 3
    NavigationVariableTable.Rect3:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect3:addEventListener("touch",onRectTouch)
    navigationGroup2:insert( NavigationVariableTable.Rect3 )
    
    NavigationVariableTable.FeedBackIcon = display.newImageRect(imageDirectory.."FeedBack_Icon.png",_W/17.70,_H/31.47)
    NavigationVariableTable.FeedBackIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.FeedBackIcon.y =  NavigationVariableTable.Rect3.y  
    navigationGroup2:insert( NavigationVariableTable.FeedBackIcon )
    
    NavigationVariableTable.FeedBackLabel = display.newText("FAQ",-_W/1.28 + _W/7.2,NavigationVariableTable.Rect3.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.FeedBackLabel.anchorX = 0
    NavigationVariableTable.FeedBackLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup2:insert( NavigationVariableTable.FeedBackLabel )
    
    NavigationVariableTable.Rect4 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.19,_H/12.22)
    NavigationVariableTable.Rect4.x = -_W/1.28  
    NavigationVariableTable.Rect4.y =  NavigationVariableTable.Rect3.y + _H/12.22 
    NavigationVariableTable.Rect4.anchorX = 0 
    NavigationVariableTable.Rect4.id = 4
    NavigationVariableTable.Rect4:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect4:addEventListener("touch",onRectTouch)
    navigationGroup2:insert( NavigationVariableTable.Rect4 )
    
    NavigationVariableTable.SettingIcon = display.newImageRect(imageDirectory.."Setting_Icon.png",_W/17.41,_H/30.96)
    NavigationVariableTable.SettingIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.SettingIcon.y =  NavigationVariableTable.Rect4.y  
    navigationGroup2:insert( NavigationVariableTable.SettingIcon )
    
    NavigationVariableTable.SettingLabel = display.newText("Settings",-_W/1.28 + _W/7.2,NavigationVariableTable.Rect4.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.SettingLabel.anchorX = 0
    NavigationVariableTable.SettingLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup2:insert( NavigationVariableTable.SettingLabel )
    
    NavigationVariableTable.Rect5 = display.newImageRect(imageDirectory.."OrderHistoryBg.png",_W/1.19,_H/12.22)
    NavigationVariableTable.Rect5.x = -_W/1.28  
    NavigationVariableTable.Rect5.y =  NavigationVariableTable.Rect4.y + _H/12.22 
    NavigationVariableTable.Rect5.anchorX = 0 
    NavigationVariableTable.Rect5.id = 5
    NavigationVariableTable.Rect5:addEventListener("tap",onRectTap)
    NavigationVariableTable.Rect5:addEventListener("touch",onRectTouch)
    navigationGroup2:insert( NavigationVariableTable.Rect5 )
    
    NavigationVariableTable.LogOutIcon = display.newImageRect(imageDirectory.."LogOut_Icon.png",_W/17.70,_H/38.4)
    NavigationVariableTable.LogOutIcon.x = -_W/1.28 + _W/15.42  
    NavigationVariableTable.LogOutIcon.y =  NavigationVariableTable.Rect5.y  
    navigationGroup2:insert( NavigationVariableTable.LogOutIcon )
    
    NavigationVariableTable.LogOutLabel = display.newText("Logout",-_W/1.28 + _W/7.2,NavigationVariableTable.Rect5.y,_FontArr[6],_H/36.76)
    NavigationVariableTable.LogOutLabel.anchorX = 0
    NavigationVariableTable.LogOutLabel:setTextColor( 83/255, 20/255, 111/255 )
    navigationGroup2:insert( NavigationVariableTable.LogOutLabel )
        
------------------------------------------------------------- Navigation Over  --------------------------------------------------------------        
     
     
	

end	

local function subMenuNetworkListener( event )
	if ( event.isError ) then
        print( "Network error!" )
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		
		local alert = native.showAlert( alertLabel, NetworkErrorMsg, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
    else
        print ( "sub Menu RESPONSE:" .. event.response )
       if( event.response == 0  or event.response == "0") then
        	local alert = native.showAlert( alertLabel, "Variables not set.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        elseif( event.response == 1 or event.response == "1") then
        	local alert = native.showAlert( alertLabel, "Category id can't be empty.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        elseif( event.response == 2 or event.response == "2") then
        	local alert = native.showAlert( alertLabel, "Something went wrong, Please try again.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        elseif( event.response == 3 or event.response == "3") then
    		local alert = native.showAlert( alertLabel, "No Items Available.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
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
    
    
    
    
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
	param = event.params
	
    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
     menuFlag = 0
     
      print("SECOND Sub Menu........................................")
     
    Background = display.newImageRect(imageDirectory.."Background.png",_W,_H)
    Background.x = _W/2
    Background.y = _H/2
    sceneGroup:insert(Background)
     navigationGroup2 = display.newGroup()
     sceneGroup:insert(navigationGroup2)
     
     createNavigation()
     
     lastSubMenuGroup = display.newGroup()
     sceneGroup:insert(lastSubMenuGroup)
     
     Bg = display.newImageRect("images/MainMenu/Background.png",_W,_H)
     Bg.x = _W/2
     Bg.y = _H/2
     lastSubMenuGroup:insert(Bg)
     
     HeaderBg = display.newImageRect(imageDirectory2.."TopBg.png",_W,_H/7.27)
     HeaderBg.x = _W/2
     HeaderBg.y = 0
     HeaderBg.anchorY = 0
     lastSubMenuGroup:insert(HeaderBg)
     
     MenuIcon2 = display.newImageRect(imageDirectory2.."Home_Btn.png",_W/16.11,_H/28.65)
     MenuIcon2.x = _W/29.18 + MenuIcon2.width/2
     MenuIcon2.y = _H/41.73 + MenuIcon2.height/2
     lastSubMenuGroup:insert(MenuIcon2)
    
     MenuBg2 = display.newRect(MenuIcon2.x, MenuIcon2.y, _W/16.11 + _W/54,_H/28.65 + _H/96)
     MenuBg2:setFillColor( 1,1,1,0.01 )
     MenuBg2:addEventListener("tap",openNavigationTap2)
     --MenuBg2:addEventListener("touch",openNavigationTouch)
     lastSubMenuGroup:insert(MenuBg2)
     
     restaurantName = display.newText( _HotelName:upper(), HeaderBg.x, HeaderBg.y + _H/27.42, _FontArr[6], _H/30 )
     restaurantName:setFillColor( 83/255, 20/255, 111/255 )
     lastSubMenuGroup:insert( restaurantName )
        
     local option = {
        	text = tostring(_HotelAddress),
        	x = restaurantName.x,
        	y = restaurantName.y + restaurantName.height/2 + _H/96,
        	width = _W/2,
        	height = _H/54.85,
        	font = _FontArr[30],
        	fontSize = _H/57.66,
        	align = "center"
        }       
        
     restaurantAdd = display.newText( option )
     restaurantAdd:setFillColor( 83/255, 20/255, 111/255 )
     lastSubMenuGroup:insert( restaurantAdd )
    
     MenuTitleBg = display.newImageRect(imageDirectory2.."TitleBg.png",_W,_H/14.22)
     MenuTitleBg.x = _W/2
     MenuTitleBg.y = _H/10.97 + MenuTitleBg.height/2
     lastSubMenuGroup:insert(MenuTitleBg)
     
     
     MenuTitle = display.newText( "", _W/7.2, MenuTitleBg.y , _FontArr[6], _H/27.25 )
     MenuTitle.anchorX = 0  
     MenuTitle:setFillColor( 1 )
     lastSubMenuGroup:insert( MenuTitle )
     
     
     backBtn = display.newImageRect( imageDirectory3.."Back_Btn1.png", _W/9, _H/24 )
     backBtn.x = _W/36 + backBtn.width/2
     backBtn.y = MenuTitleBg.y
     lastSubMenuGroup:insert( backBtn )
       			
	 backBg = display.newRect( backBtn.x, backBtn.y, backBtn.width + _W/21.6, backBtn.height + _H/38.4 )
	 backBg:setFillColor( 83/255, 20/255, 111/255 , 0.01 )
	 backBg:addEventListener( "tap", handleBackButtonEvent )
	 backBg:addEventListener( "touch", handleBackButtonEventTouch )
	 lastSubMenuGroup:insert( backBg )
	 backBtn:toFront() 
     
     
     MenuProductImage = display.newImageRect( "SubToSubCategory".._selectedLastSubCategoryID..".png", system.TemporaryDirectory, _W/1.2, _H/3.84 )
     MenuProductImage.x = _W/2
     MenuProductImage.y = MenuTitleBg.y + MenuTitleBg.height/2 + _H/960
     MenuProductImage.anchorY = 0
     lastSubMenuGroup:insert( MenuProductImage )
     
     list2 = widget.newTableView
	{
		top = MenuProductImage.y + MenuProductImage.height + _H/960,
		width = _W,
		hideBackground = true, 
		--backgroundColor = { 1, 0, 0 },
		height = _H - MenuTitleBg.height/2,
		onRowRender = onRowRender,
		onRowTouch = onRowTouch,
		bottomPadding = _H/96
	}
	lastSubMenuGroup:insert( list2 )
	
	
	
	MenuIcon2:toFront()
     
local function categoryProductNetworkListener( event )  
    if ( event.isError ) then
        print( "Network error!" )
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		local alert = native.showAlert( alertLabel, NetworkErrorMsg, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
    else
        print ( "RESPONSE:" .. event.response )
        
        if( event.response == 0 or event.response == "0" ) then
        	local alert = native.showAlert( alertLabel, "All fields are mandatory.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 1 or event.response == "1" ) then
        	local alert = native.showAlert( alertLabel, "Category id can't be empty", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 2 or event.response == "2" ) then
        	local alert = native.showAlert( alertLabel, "Something went wrong, Please try again", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
       
        elseif( event.response == 3 or event.response == "3" ) then
        	--local alert = native.showAlert( alertLabel, "No items Found", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        else
        					
        					
        					
        end
    end
     return true
end  
     
local function networkListener( event )
	if ( event.isError ) then
		print( "Network error - download failed" )
		count = count + 1
		
		if count == #categoryImage then
		
			timer.performWithDelay( 200, function() 
			native.setActivityIndicator( false )
			end )
			
			composer.gotoScene( "menu" )
        
        end
        
    elseif ( event.phase == "began" ) then
		print( "Progress Phase: began" )
		
    elseif ( event.phase == "ended" ) then
		print( "Displaying response image file" )
		
		count = count + 1
		
		if count == #categoryImage then
			
			timer.performWithDelay( 200, function() 
			native.setActivityIndicator( false )
			end )
			
			composer.gotoScene( "menu" )
			
        end
        
    end

   	  
end     
     
    subCategoryTable2 = { }
    
    for i = 1, #_menuList do
    	for j = 1, #_menuList[i].sub_menu do
    		for m = 1, #_menuList[i].sub_menu[j].sub_menu do
    			print(_selectedLastSubCategoryID.."///".._menuList[i].sub_menu[j].sub_menu[m].id)
     		if( _selectedLastSubCategoryID == _menuList[i].sub_menu[j].sub_menu[m].id ) then
      			subCategoryTable2 = _menuList[i].sub_menu[j].sub_menu[m].sub_menu
      			local MenuTitleValue = _menuList[i].sub_menu[j].sub_menu[m].category_name
      			if(MenuTitleValue:len() > 40) then
     
     				MenuTitleValue = MenuTitleValue:sub(1,40)..".."
     				MenuTitle.text = MenuTitleValue
     			
     			else
     
     				MenuTitleValue = MenuTitleValue
     				MenuTitle.text = MenuTitleValue
     			
    		 	end
    		 	break
			end
			end
		end
	end
	
	MainCategory = { }
	for i = 1 , #subCategoryTable2 do
		print("sub category table......")
        	if(i == 1) then
        	else
        		listItems[#listItems + 1] = { title = MainCatValue, id = MainCatID, collapsed = true, items = subCateArray, ids = subCateIDArray , price = subCatePriceArray }
        	end
        	
        		subCateArray = { }
        		subCateIDArray = { }
        		subCatePriceArray = { }
        		MainCatValue = subCategoryTable2[i].category_name
        		MainCatID = subCategoryTable2[i].id
        		
        		k = #subCategoryTable2[i].sub_menu
        		
        		print("k is ..."..k)
        		if(k > 0) then
        			for  j = 1, k do
        				table.insert( subCateArray,subCategoryTable2[i].sub_menu[j].category_name)
        				table.insert( subCateIDArray,subCategoryTable2[i].sub_menu[j].id.."Cat")
        				table.insert( subCatePriceArray,"NA")
        				print("kkkkkkkkkk123 "..j)
        			end
        			
        		else
        			if(#productData > 0) then
        				print("Product data available")
        				for j = 1, #productData do
        					
        					if(subCategoryTable2[i].id == productData[j].categoryID) then
        							print("same category product data found")
        						if(productData[j].productDetail) then
        							--local n = #productData[j].productDetail
        								--print("products found"..n)
        							--for  a = 1, n do
        								
        								print("products")
        								table.insert( subCateArray,productData[j].productDetail.item_name)
        								table.insert( subCateIDArray,productData[j].productDetail.id.."Pro")
        								table.insert( subCatePriceArray,productData[j].productDetail.price)
        							--end
        							
        						end
        					
        					end
        				end
        			end
        		end
        		
        
        	if(i == #subCategoryTable2) then
        		listItems[#listItems + 1] = { title = MainCatValue, id = MainCatID, collapsed = true, items = subCateArray, ids = subCateIDArray, price = subCatePriceArray }
        	end
    end
	
	  
    print("sub menu table length".. #subCategoryTable2)    
        
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
      	local function onShow()
        	populateList2()
    	end
        
        timer.performWithDelay( 500 , onShow)
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
        	
        	display.remove(Background)
        	Background = nil
       
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
        
        display.remove(navigationGroup2)
        navigationGroup2 = nil
        
        
        Rect = { }
        
        
		nameBg = { }
		
		listItems = { } 
		
	 	subCateIDArray = { }
	 	
	 	subCateArray = { }
	 	subCategoryTable2 = { }
	 	
	 	
        
	 	
        display.remove(list2)
        list2 = nil
        
	 	--[[if(Rect) then
        for i = 1, #Rect do
        	if(Rect[i]) then
        		display.remove(Rect[i])
        		Rect[i] = nil
        	end
        end
        end]]--
        
        --[[for i = 1, #nameBg do
        	display.remove(nameBg[i])
        	nameBg[i] = nil
        end
	 	]]---
       	display.remove( HeaderBg ) 
       	HeaderBg = nil
       	
       	display.remove( MenuIcon2 ) 
       	MenuIcon2 = nil
       	
       	display.remove( Bg ) 
       	Bg = nil
       	
       	display.remove( restaurantName )
       	restaurantName = nil
       	
       	display.remove( restaurantAdd )
       	restaurantAdd = nil
       	
       	display.remove( MenuTitle )
       	MenuTitle = nil
       	
       	display.remove( MenuTitleBg )
       	MenuTitleBg = nil
       	
       	display.remove(MenuBg2)
       	MenuBg2 = nil
       	
       	display.remove( backBtn )
       	backBtn = nil
       	
       	display.remove( backBg )
       	backBg = nil
       	
       	if(scrollView) then
       		display.remove( scrollView )
       		scrollView = nil
       	end
       	
       	display.remove( list2 )
       	list2 = nil
       	
       	display.remove(lastSubMenuGroup)
       	lastSubMenuGroup = nil
       	
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
        --
        
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