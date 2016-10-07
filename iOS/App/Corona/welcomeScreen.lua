local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
-- tabel name api
-- http://ec2-54-206-55-249.ap-southeast-2.compute.amazonaws.com/ws/store-table-find.php?beacon_major=1&beacon_minor=3
-- -------------------------------------------------------------------------------
local imageDirectory = "images/Login/"

local appStatusText,beaconDetectCount

local function onDoNothing( event )

	return true
end

local function onCloseApp( event )
	os.exit()
	return true
end

local function handleRestaurantAlertEvent( event )
	if ( event.action == "clicked" ) then
        local i = event.index
        if ( i == 2 ) then
            print( "yes" )
            composer.gotoScene( "RestaurantsList" )
        elseif ( i == 1 ) then
            print( "no" )
            --native.requestExit()
            os.exit()
        end
    end
	
	return true
end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    
    local background = display.newImageRect( imageDirectory.."Background.png", _W, _H )
    background.x = _W/2
    background.y = _H/2
    sceneGroup:insert( background )
    
    
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        _majorBea = ""
        _minorBea = ""
        beaconDetectCount = 0
        
        local options = {
        	text = "",
        	x = _W/2,
        	y = _H/2,
        	width = _W - _W/21.6,
        	height = 0,
        	font = _FontArr[6],
        	fontSize = _H/30 ,
        	align = "center"
        }
        
        appStatusText = display.newText( options )
		appStatusText:setFillColor( 1 )
		sceneGroup:insert( appStatusText )
		
		appStatusText.text = GBCLanguageCabinet.getText("SearchingForVenueLabel",_LanguageKey)
		
		
local function productListNetworkListener( event )
	if ( event.isError ) then
        print( "Network error!" )
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		
		--local alert = native.showAlert( alertLabel, NetworkErrorMsg, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
    else
        print ( "Product List RESPONSE:" .. event.response )
        product_count = 0
        
		
		if( event.response == 0 or event.response == "0" ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 1 or event.response == "1" ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("12Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( event.response == 2 or event.response == "2" ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( event.response == 3 or event.response == "3" ) then
        	--local alert = native.showAlert( alertLabel, "No items Found.", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        else
        
        	local function networkListenerProductImage( event )
        			
        		if ( event.isError ) then
					print( "Network error - download failed" )
					product_count = product_count + 1
        			if product_count == #productImages then
		
						--[[timer.performWithDelay( 200, function() 
						native.setActivityIndicator( false )
						end )]]--
			
						--composer.gotoScene( "menu" )
						--onDownloandSubCategoryImage()
        
        			end
        
    		 elseif ( event.phase == "began" ) then
					print( "Progress Phase: began" )
		
   			 elseif ( event.phase == "ended" ) then
				print( "Displaying response image file" )
		
				product_count = product_count + 1
				
        			if product_count == #productImages then
			
						--[[timer.performWithDelay( 200, function() 
						native.setActivityIndicator( false )
						end )]]--
			
						--composer.gotoScene( "menu" )
						--onDownloandSubCategoryImage()
        			end
        
    			end
        
        	end
        
        	local data = json.decode( event.response )
        	if(data) then
        	if(#data > 0) then
        	
        		for i = 1, #data do
        			
        			productData[#productData + 1] = { categoryID = data[i].category_id, productDetail = data[i] }
					productImages[#productImages + 1] = { imagePath = data[i].images , imageID = data[i].id } 
					
				end
				
				if(#productImages > 0) then
				
					for i = 1, #productImages do
					if _UserID then
					
					
					if productImages[i].imagePath ~= nil and productImages[i].imagePath ~= "" and productImages[i].imagePath ~= " " then
        				local url = productImages[i].imagePath
						local url2 = url:gsub( " ","%%20" )
        				
        				local params = {}
						params.timeout = 180
        				
        				productImageRequest[i] = network.download(
        					url2,
    						"GET",
   							networkListenerProductImage,
    						params,
    						"Product"..productImages[i].imageID..".png",
    						system.TemporaryDirectory
							)
        		
        			else
        					print( "Image not found......" )
        					product_count = product_count + 1
        					if product_count == #productImages then
        			
								--[[timer.performWithDelay( 200, function() 
								native.setActivityIndicator( false )
								end )]]--
								--composer.gotoScene( "menu" )
								
								
							end
        			
        			end
        			
        			end
        			end
					
				else
				
					
				
				end
				
			end
			end
		end
		
	end
	return true
end

function downloadMenuImage()
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

print( "wait until images got downloaded...." )


local function menuListNetworkListener( event )

	if ( event.isError ) then
        print( "Network error!" )
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
    else
        print ( "Main Menu RESPONSE:" .. event.response )
        
		
		if( event.response == 0 or event.response == "0") then
			timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 1 or event.response == "1") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Store1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( event.response == 2 or event.response == "2") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 3 or event.response == "3") then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
    		local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("18Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		
        else
        
        	_menuList = json.decode(event.response)
        	
local function networkListener( event )
	if ( event.isError ) then
		print( "Network error - download failed" )
		count = count + 1
		
		if count == (#categoryImage3 + #categoryImage1 + #categoryImage2) then
		
			--[[timer.performWithDelay( 200, function() 
			native.setActivityIndicator( false )
			end )]]--
			
			--composer.gotoScene( "menu" )
			onDownloandSubCategoryImage()
        
        end
        
    elseif ( event.phase == "began" ) then
		print( "Progress Phase: began" )
		
    elseif ( event.phase == "ended" ) then
		print( "Displaying response image file" )
		
		count = count + 1
		
		if count == (#categoryImage3 + #categoryImage1 + #categoryImage2) then
			
			--[[timer.performWithDelay( 200, function() 
			native.setActivityIndicator( false )
			end )]]--
			
			--composer.gotoScene( "menu" )
			onDownloandSubCategoryImage()
        end
        
    end
	
end

local function networkListenerSubImage( event )
	
	if ( event.isError ) then
		print( "Network error - download failed" )
		sub_count = sub_count + 1
		
		if sub_count == #subMenuImages then
		
			--[[timer.performWithDelay( 200, function() 
			native.setActivityIndicator( false )
			end )]]--
			
			--composer.gotoScene( "menu" )
			onDownloandSubToSubCategoryImage()
        
        end
        
    elseif ( event.phase == "began" ) then
		print( "Progress Phase: began" )
		
    elseif ( event.phase == "ended" ) then
		print( "Displaying response image file" )
		
		sub_count = sub_count + 1
		
		if sub_count == #subMenuImages then
		
			--[[timer.performWithDelay( 200, function() 
			native.setActivityIndicator( false )
			end )]]--
			
			--composer.gotoScene( "menu" )
			onDownloandSubToSubCategoryImage()
        end
        
    end

end

local function networkListenerSubToSubImage( event )

	if ( event.isError ) then
		print( "Network error - download failed" )
		subToSub_count = subToSub_count + 1
        if subToSub_count == #subToSubMenuImages then
		
			--[[timer.performWithDelay( 200, function() 
			native.setActivityIndicator( false )
			end )]]--
			
			--composer.gotoScene( "menu" )
			onDownloandSubToSubCategory2Image()
        
        end
        
    elseif ( event.phase == "began" ) then
		print( "Progress Phase: began" )
		
    elseif ( event.phase == "ended" ) then
		print( "Displaying response image file" )
		
		subToSub_count = subToSub_count + 1
        if subToSub_count == #subToSubMenuImages then
        
			--[[timer.performWithDelay( 200, function() 
			native.setActivityIndicator( false )
			end )]]--
			
			--composer.gotoScene( "menu" )
			onDownloandSubToSubCategory2Image()
        end
        
    end

end

local function networkListenerSubToSub2Image( event )

	if ( event.isError ) then
		print( "Network error - download failed" )
		subToSub2_count = subToSub2_count + 1
        if subToSub2_count == #subToSub2MenuImages then
		
			--[[timer.performWithDelay( 200, function() 
			native.setActivityIndicator( false )
			end )]]--
			
			--composer.gotoScene( "menu" )
			downloadProductData()
        
        end
        
    elseif ( event.phase == "began" ) then
		print( "Progress Phase: began" )
		
    elseif ( event.phase == "ended" ) then
		print( "Displaying response image file" )
		
		subToSub2_count = subToSub2_count + 1
        if subToSub2_count == #subToSub2MenuImages then
        
			--[[timer.performWithDelay( 200, function() 
			native.setActivityIndicator( false )
			end )]]--
			
			--composer.gotoScene( "menu" )
			downloadProductData()
        end
        
    end

end
        	
        	if(_menuList)then
        	
        	for i = 1,#_menuList do
        		categoryName[i] = _menuList[i].category_name
				categoryImage1[i] = _menuList[i].images.image_1
        		categoryImage2[i] = _menuList[i].images.image_2
        		categoryImage3[i] = _menuList[i].images.image_3
        		
        		local subMenuCount = #_menuList[i].sub_menu
        		
        		if(#_menuList[i].sub_menu > 0) then
        		
        		
        			for j = 1, #_menuList[i].sub_menu do
        		
        				table.insert(subMenuImages, _menuList[i].sub_menu[j].images)
        				table.insert(subMenuID, _menuList[i].sub_menu[j].id)
        			
        				if(#_menuList[i].sub_menu[j].sub_menu > 0) then
        					for k = 1,#_menuList[i].sub_menu[j].sub_menu do
        						table.insert(subToSubMenuImages, _menuList[i].sub_menu[j].sub_menu[k].images)
        						table.insert(subToSubMenuID, _menuList[i].sub_menu[j].sub_menu[k].id)
        						
        						if(#_menuList[i].sub_menu[j].sub_menu[k].sub_menu > 0) then
        						
        							for m = 1, #_menuList[i].sub_menu[j].sub_menu[k].sub_menu do
        									table.insert(subToSub2MenuImages, _menuList[i].sub_menu[j].sub_menu[k].sub_menu[m].images)
        									table.insert(subToSub2MenuID, _menuList[i].sub_menu[j].sub_menu[k].sub_menu[m].id)
        									
        									if(#_menuList[i].sub_menu[j].sub_menu[k].sub_menu[m].sub_menu > 0) then
        									
        									
        									else
        								
        										table.insert(ProductCategoryID, _menuList[i].sub_menu[j].sub_menu[k].sub_menu[m].id)
        									
        									end
        							end
        							
        						else
        							
        							table.insert(ProductCategoryID, _menuList[i].sub_menu[j].sub_menu[k].id)
        							
        						end
        					end
        				else
        				
        					table.insert(ProductCategoryID, _menuList[i].sub_menu[j].id)
        				
        				end
        			end
        		
        		else
        			
        			table.insert(ProductCategoryID, _menuList[i].id)
        			
        		
        		end
        		
        		
 				
        		if categoryImage1[i] == nil and categoryImage1[i] == "" and categoryImage1[i] == " "  then
        			print( "Image not found......" )
        			count = count + 1
        			if count == (#categoryImage3 + #categoryImage1 + #categoryImage2) then
        			
						timer.performWithDelay( 200, function() 
						native.setActivityIndicator( false )
						end )
						--composer.gotoScene( "menu" )
						onDownloandSubCategoryImage()
						
        			
        			end
        		else
        			local url = categoryImage1[i]
 					url2 = url:gsub(" ", "%%20")
 					local params = {}
					params.timeout = 180
        			menuImageRequest[i] = network.download(
        				url2,
    					"GET",
   						networkListener,
    					params,
    					"MainCategory".._menuList[i].id..".png",
    					system.TemporaryDirectory
					)
        		
        		
        		end
        		
        		--function downloadSecondMainImages()
        			
 				
        			if categoryImage2[i] ~= nil and categoryImage2[i] ~= "" and categoryImage2[i] ~= " " then
        				local url3 = categoryImage2[i]
 						url4 = url3:gsub(" ", "%%20")
        				local params = {}
						params.timeout = 180
        				menuImageRequest2[i] = network.download(
        					url4,
    						"GET",
   							networkListener,
    						params,
    						"MainCategory".._menuList[i].id.."_2.png",
    						system.TemporaryDirectory
						)
        		
        			else
        				print( "Image not found......" )
        				
        				count = count + 1
        				if count == (#categoryImage3 + #categoryImage1 + #categoryImage2) then
        			
							timer.performWithDelay( 200, function() 
							native.setActivityIndicator( false )
							end )
							--composer.gotoScene( "menu" )
							onDownloandSubCategoryImage()
						
        			
        				end
        			
        			end
        		--end
        		
        		--function downloadThirdMainImages()
        			local url5 = categoryImage3[i]
 					url6 = url5:gsub(" ", "%%20")
 				
        			if categoryImage3[i] ~= nil and categoryImage3[i] ~= "" and categoryImage3[i] ~= " " then
        				
        				local params = {}
						params.timeout = 180
        				menuImageRequest3[i] = network.download(
        					url6,
    						"GET",
   							networkListener,
    						params,
    						"MainCategory".._menuList[i].id.."_3.png",
    						system.TemporaryDirectory
						)
        		
        			else
        				print( "Image not found......" )
        				count = count + 1
        				if count == (#categoryImage3 + #categoryImage1 + #categoryImage2) then
        			
							timer.performWithDelay( 200, function() 
							native.setActivityIndicator( false )
							end )
							--composer.gotoScene( "menu" )
							onDownloandSubCategoryImage()
						
        			
        				end
        			
        			end
        	--	end
        	end
        	
        	end
        	
        	function onDownloandSubCategoryImage( event ) 
        		
        		if(#subMenuImages > 0) then
        		
        		for i = 1, #subMenuID do
        		
        		local sub_url = subMenuImages[i]
 				sub_url2 = sub_url:gsub(" ", "%%20")
 				
        		if subMenuImages[i] ~= nil and subMenuImages[i] ~= "" and subMenuImages[i] ~= " " then
        			local params = {}
					params.timeout = 180
        			subMenuImageRequest[i] = network.download(
        				sub_url2,
    					"GET",
   						networkListenerSubImage,
    					params,
    					"SubCategory"..subMenuID[i]..".png",
    					system.TemporaryDirectory
					)
        		
        		else
        			print( "Image not found......" )
        			sub_count = sub_count + 1
        			if sub_count == #subMenuImages then
        			
						--[[timer.performWithDelay( 200, function() 
						native.setActivityIndicator( false )
						end )]]--
						--composer.gotoScene( "menu" )
						onDownloandSubToSubCategoryImage()
						
        			
        			end
        			
        		end
        		
        		end
        		
        		else
        			onDownloandSubToSubCategoryImage()
        		end
        		
        	end
        	
        	function onDownloandSubToSubCategoryImage( event )
        		if(#subToSubMenuImages > 0) then
        		
        		for i = 1, #subToSubMenuID do
        		
        		local subToSub_url = subToSubMenuImages[i]
 				subToSub_url2 = subToSub_url:gsub(" ", "%%20")
 				
        		if subToSubMenuImages[i] ~= nil and subToSubMenuImages[i] ~= "" and subToSubMenuImages[i] ~= " " then
        			local params = {}
						params.timeout = 180
        			subMenuImageRequest2[i] = network.download(
        				subToSub_url2,
    					"GET",
   						networkListenerSubToSubImage,
    					params,
    					"SubToSubCategory"..subToSubMenuID[i]..".png",
    					system.TemporaryDirectory
					)
        		
        		else
        			print( "Image not found......" )
        			subToSub_count = subToSub_count + 1
        			if subToSub_count == #subToSubMenuImages then
        			
						--[[timer.performWithDelay( 200, function() 
						native.setActivityIndicator( false )
						end )]]--
						--composer.gotoScene( "menu" )
						downloadProductData()	
        			
        			end
        			
        		end
        		
        		end
        		
        		else
        			onDownloandSubToSubCategory2Image()
        		end
        	
        	
        	end
        	
        	function onDownloandSubToSubCategory2Image( event )
        		if(#subToSub2MenuImages > 0) then
        		
        		for i = 1, #subToSub2MenuID do
        		
        		local subToSub2_url = subToSub2MenuImages[i]
 				subToSub2_url2 = subToSub2_url:gsub(" ", "%%20")
 				
        		if subToSub2MenuImages[i] ~= nil and subToSub2MenuImages[i] ~= "" and subToSub2MenuImages[i] ~= " " then
        			local params = {}
						params.timeout = 180
        			subMenuImageRequest3[i] = network.download(
        				subToSub2_url2,
    					"GET",
   						networkListenerSubToSub2Image,
    					params,
    					"SubToSub2Category"..subToSub2MenuID[i]..".png",
    					system.TemporaryDirectory
					)
        		
        		else
        			print( "Image not found......" )
        			subToSub2_count = subToSub2_count + 1
        			if subToSub2_count == #subToSub2MenuImages then
        			
						--[[timer.performWithDelay( 200, function() 
						native.setActivityIndicator( false )
						end )]]--
						--composer.gotoScene( "menu" )
						downloadProductData()	
        			
        			end
        			
        		end
        		
        		end
        		
        		else
        			downloadProductData()
        		end
        	
        	end
        	
        	function downloadProductData( event )
        		
        		if(#ProductCategoryID > 0) then
        		
        			for i = 1, #ProductCategoryID do
        			
        				local headers = {}
		
						headers["Content-Type"] = "application/x-www-form-urlencoded"
						headers["Accept-Language"] = "en-US"
						local body
						if( _LanguageKey == "en" ) then
							body = "ws=1&category_id="..ProductCategoryID[i]
						else
							body = "ws=1&category_id="..ProductCategoryID[i].."&lang=".._LanguageKey
						end
						local params = {}
						params.headers = headers
						params.body = body
						params.timeout = 180
		
						local url = _WebLink.."store-items.php?"
						print( url..body )
						productRequest[i] = network.request( url, "POST", productListNetworkListener, params )
						--native.setActivityIndicator( true )
        				 

        				
        			end
        			
        		end
        		timer.performWithDelay( 2000, function() 
				native.setActivityIndicator( false )
				end )
				if(notificationFlag == false) then
        			composer.gotoScene( "menu" )
        			if(loaderTimer) then
        				timer.cancel( loaderTimer )
        				loaderTimer = nil
        			end
        		else
        		
        		end
        	
        	end
        	
        end
     
    end
		
end

		-- Access Google over SSL:
		
		local headers = {}
		
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		local body
		if( _LanguageKey == "en" ) then
			body = "ws=1&store_id=".._StoreID
		else
			body = "ws=1&store_id=".._StoreID.."&lang=".._LanguageKey
		end
		local params = {}
		params.headers = headers
		params.body = body
		params.timeout = 180
		
		local url = _WebLink.."store-categories.php?"
		print( url..body )
		menuRequest = network.request( url, "POST", menuListNetworkListener, params )
		--native.setActivityIndicator( true )

end

local function stripeUpdationNetworkListener( event )
	if ( event.isError ) then
        print( "Network error!" )
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
	else
	
		if( event.response == 0 or event.response == "0") then
        	
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
		elseif( event.response == 1 or event.response == "1") then
        	
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( event.response == 2 or event.response == "2") then
        	
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 3 or event.response == "3") then
        	
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("User1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 4 or event.response == "4") then
        	
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Pin3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 5 or event.response == "5") then
        	
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 6 or event.response == "6") then
        	
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Stripe1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 7 or event.response == "7") then
        	
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 8 or event.response == "8") then
        	
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )							
        
        else
        	downloadMenuImage()	
        	
		end
	end
	return true
end

local function updateCustomerNetworkListener( event )
        if ( event.isError ) then
            print( "Network error!" )
            timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
        else
       		timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
            print( "RESPONSE: "..event.response )
            local data1 = event.response
            local resp1 = json.decode(data1)
            print(resp1)
            local error = resp1.error
            if error ~= nil then
                for i = 1, #resp1.error do
                    print(resp1.error[i].type)
                    print(resp1.error[i].message)
                end 
            end
            
            if error == nil then
                emailReturn = resp1.email
                print(emailReturn)
                print("Stripe Account Details Updated Successful. ..... ????????")
                print( _StripePin )
                
				--[[
				local stripeUpdateUrl = _WebLink.."stripe-update.php?user_id=".._UserID.."&store_id=".._StoreID.."&stripe_acc_id=".._StripeCustomerID.."&cvv_number=".._StripeCVVNo.."&card_number=".._StripeCardNo.."&exp_date_month=".._StripeExpMont.."&exp_date_year=".._StripeExpYear.."&secret_key="..strip_api_key.."&publishable_key="..stripe_Public_key.."&pin_number=".._StripePin
				local stripeUpdateUrl2 = stripeUpdateUrl:gsub( " ", "%%20" )
				stripeDetailsRequest = network.request( stripeUpdateUrl2, "GET", stripeUpdationNetworkListener )
                ]]--
                
                local headers = {}
		
				headers["Content-Type"] = "application/x-www-form-urlencoded"
				headers["Accept-Language"] = "en-US"
		
				local body = "user_id=".._UserID.."&store_id=".._StoreID.."&stripe_acc_id=".._StripeCustomerID.."&cvv_number=".._StripeCVVNo.."&card_number=".._StripeCardNo.."&exp_date_month=".._StripeExpMont.."&exp_date_year=".._StripeExpYear.."&secret_key="..strip_api_key.."&publishable_key="..stripe_Public_key.."&pin_number=".._StripePin
				local params = {}
				params.headers = headers
				params.body = body
				params.timeout = 180
		
				local url = _WebLink.."stripe-update.php?"
				print( url..body )
				stripeUpdateRequest2 = network.request( url, "POST", stripeUpdationNetworkListener, params )
                
                
            else
            
            	
            	
            	local alert = native.showAlert( alertLabel,error.message, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) } )
            	print(error.message)
            end  
        end
end

local function updateStripeAccount( event )
	
	
	local description = ""
	local updateCustomer = "email=".._UserName.."&description="..description.."&card[number]=".._StripeCardNo.."&card[exp_year]=".._StripeExpYear.."&card[exp_month]=".._StripeExpMont.."&card[cvc]=".._StripeCVVNo--{["email"] = email, ["description"] = description}--, ["card"] = firstCard}
    
    
   	local key = {["Bearer"] = strip_api_key}
    
    local headers = { 
        ["Authorization"] ="Bearer "..strip_api_key,
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
    
    local params = {}
    params.headers = headers
    params.body =  updateCustomer 
    
    print( "params.body: "..params.body )
    			
    updateStripeAccountRequest = network.request("https://api.stripe.com/v1/customers/".._StripeCustomerID, "POST", updateCustomerNetworkListener, params)
	native.setActivityIndicator( true ) 
	
	
end

local function registerAndUpdateNetworkListener( event )
	 if ( event.isError ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
            print( "Network error!" )
        else
            print( "RESPONSE: "..event.response )
            timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
			
            local data1 = event.response
            resp1 = json.decode(data1)
            print(data1)
            local error = resp1.error
            if error ~= nil then
                for i = 1, #resp1.error do
                    print(resp1.error[i].type)
                    print(resp1.error[i].message)
                    
                end 
            else
            
            	--print("error has been occured while updaing/registraing account in stripe -- 1")

            end
           
          if error == nil then
          		
                _StripeCustomerID = resp1.id
              	print( _StripePin )
              	print( "+++++++++++++++++++++++++++++++++++++++" )
              	
				--[[local stripeUpdateUrl = _WebLink.."stripe-update.php?user_id=".._UserID.."&store_id=".._StoreID.."&stripe_acc_id=".._StripeCustomerID.."&cvv_number=".._StripeCVVNo.."&card_number=".._StripeCardNo.."&exp_date_month=".._StripeExpMont.."&exp_date_year=".._StripeExpYear.."&secret_key="..strip_api_key.."&publishable_key="..stripe_Public_key.."&pin_number=".._StripePin
				local stripeUpdateUrl2 = stripeUpdateUrl:gsub( " ", "%%20" )
				stripeDetailsRequest = network.request( stripeUpdateUrl2, "GET", stripeUpdationNetworkListener )
                ]]--
                
                local headers = {}
		
				headers["Content-Type"] = "application/x-www-form-urlencoded"
				headers["Accept-Language"] = "en-US"
			
				local body = "user_id=".._UserID.."&store_id=".._StoreID.."&stripe_acc_id=".._StripeCustomerID.."&cvv_number=".._StripeCVVNo.."&card_number=".._StripeCardNo.."&exp_date_month=".._StripeExpMont.."&exp_date_year=".._StripeExpYear.."&secret_key="..strip_api_key.."&publishable_key="..stripe_Public_key.."&pin_number=".._StripePin
				local params = {}
				params.headers = headers
				params.body = body
				params.timeout = 180
		
				local url = _WebLink.."stripe-update.php?"
				print( url..body )
				stripeUpdateRequest = network.request( url, "POST", stripeUpdationNetworkListener, params )
                
                return resp1
            else
            	local alert = native.showAlert( alertLabel,error.message, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
            	print(error.message)
            end 
            
        end
	return true
end

local function createAndUpdateStripeAccount( event )
	local description = ""
	local newCustomer = "email=".._UserName.."&description="..description.."&card[number]=".._StripeCardNo.."&card[exp_year]=".._StripeExpYear.."&card[exp_month]=".._StripeExpMont.."&card[cvc]=".._StripeCVVNo  --{["email"] = email, ["description"] = description}--, ["card"] = firstCard}
    
    print(newCharge)
    
    local key = {["Bearer"] = strip_api_key}
    
    local headers = { 
        ["Authorization"] ="Bearer "..strip_api_key,
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
    
    local params = {}
    params.headers = headers
    params.body =  newCustomer 
    
   	stripAccountRequest = network.request("https://api.stripe.com/v1/customers", "POST", registerAndUpdateNetworkListener, params)
	print( "params.body: ".."https://api.stripe.com/v1/customers"..params.body )
	return true
end

local function stripeRegistrationNetworkListener( event )
	if ( event.isError ) then
        print( "Network error!" )
        
       local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
    	native.setActivityIndicator( false )
		
    else
    	if( event.response == 0 or event.response == "0") then
        	
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 1 or event.response == "1") then
        	
        	local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( event.response == 2 or event.response == "2") then
        	
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( event.response == 3 or event.response == "3") then
        	
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("User1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 4 or event.response == "4") then
        	
        	local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("Pin3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        	
        elseif( event.response == 5 or event.response == "5") then
        	
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        
        elseif( event.response == 6 or event.response == "6") then
        	
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        					
        elseif( event.response == 7 or event.response == "7") then
        	
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("Stripe1Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        		
       elseif( event.response == 8 or event.response == "8") then
        	
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        		 				
      else
      	  downloadMenuImage()
      end	
    	
    end
	return true
end

local function registerNetworkListener( event )
        if ( event.isError ) then
        	timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
            print( "Network error!" )
        else
            print( "RESPONSE: "..event.response )
            timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
			
            local data1 = event.response
            resp1 = json.decode(data1)
            print(data1)
            local error = resp1.error
            if error ~= nil then
                for i = 1, #resp1.error do
                    print(resp1.error[i].type)
                    print(resp1.error[i].message)
                    
                end 
            else
            
            	print("error has been occured while updaing/registraing account in stripe -- 1")

            end
           
          if error == nil then
          		
                _StripeCustomerID = resp1.id
                print( "******************************************" )
              	print( _StripePin )
              	
              --[[
				local stripeUrl = _WebLink.."stripe-add.php?user_id=".._UserID.."&store_id=".._StoreID.."&stripe_acc_id=".._StripeCustomerID.."&cvv_number=".._StripeCVVNo.."&card_number=".._StripeCardNo.."&exp_date_month=".._StripeExpMont.."&exp_date_year=".._StripeExpYear.."&secret_key="..strip_api_key.."&publishable_key="..stripe_Public_key.."&pin_number=".._StripePin
				local stripeUrl2 = stripeUrl:gsub( " ", "%%20" )
				stripeDetailsRequest = network.request( stripeUrl2, "GET", stripeRegistrationNetworkListener )
				]]--
				
				local headers = {}
		
				headers["Content-Type"] = "application/x-www-form-urlencoded"
				headers["Accept-Language"] = "en-US"
		
				local body = "user_id=".._UserID.."&store_id=".._StoreID.."&stripe_acc_id=".._StripeCustomerID.."&cvv_number=".._StripeCVVNo.."&card_number=".._StripeCardNo.."&exp_date_month=".._StripeExpMont.."&exp_date_year=".._StripeExpYear.."&secret_key="..strip_api_key.."&publishable_key="..stripe_Public_key.."&pin_number=".._StripePin
				local params = {}
				params.headers = headers
				params.body = body
				params.timeout = 180
		
				local url = _WebLink.."stripe-add.php?"
				print( url..body )
				stripeAppRequest = network.request( url, "POST", stripeRegistrationNetworkListener, params )
				--native.setActivityIndicator( true )
                
                return resp1
            else
            	local alert = native.showAlert( alertLabel,error.message, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
            	print(error.message)
            end 
            
        end
end

local function createNewStripeAccount( event )

	local description = ""
	local newCustomer = "email=".._UserName.."&description="..description.."&card[number]=".._StripeCardNo.."&card[exp_year]=".._StripeExpYear.."&card[exp_month]=".._StripeExpMont.."&card[cvc]=".._StripeCVVNo  --{["email"] = email, ["description"] = description}--, ["card"] = firstCard}
    
    print(newCharge)
    
    local key = {["Bearer"] = strip_api_key}
    
    local headers = { 
        ["Authorization"] ="Bearer "..strip_api_key,
        ["Content-Type"] = "application/x-www-form-urlencoded"
    }
    
    local params = {}
    params.headers = headers
    params.body =  newCustomer 
    
   	stripAccountRequest = network.request("https://api.stripe.com/v1/customers", "POST", registerNetworkListener, params)
	print( "params.body: ".."https://api.stripe.com/v1/customers"..params.body )	
   --native.setActivityIndicator( true )
	
end

local function stripeDataNetworkListener( event )
	if ( event.isError ) then
        print( "Network error!" )
        
        --[[timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )]]--
		
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onCloseApp )
		
    else
        print ( "user's particular store's stripe account details RESPONSE:" .. event.response )
        if( event.response == 0 or event.response == "0" ) then
        	print( "Variables not set" )
        elseif( event.response == 1 or event.response == "1" ) then
        	print( "User id and Store id can't be empty" )
        elseif( event.response == 2 or event.response == "2" ) then
        	print( "Something went wrong, Please try again" )
        elseif( event.response == 3 or event.response == "3" ) then
			print( "Stripe Account Id doesn't found" )
			if( _StripeCardNo == nil ) then
				print("This User is new to this app, he/she havent created any stripe account before")
				downloadMenuImage()
			else
				print("this user is new in this owner's store. need to create a new stripe for this user in this owner's stripe account.")
				createNewStripeAccount()
				
			end
		else
			
			print( "Stripe data RESPONSE : " .. event.response )
			stripeDataForStore = json.decode( event.response )
			print("got response")
			print( stripeDataForStore.publishable_key.." // "..stripe_Public_key )
			print( stripeDataForStore.secret_key.." // "..strip_api_key )
			
			print("got response")
			
			_StripeCustomerID = stripeDataForStore.stripe_account_id
			_StripeCardNo = stripeDataForStore.card_number
			_StripeCVVNo = stripeDataForStore.cvv_number
			_StripeExpMont = stripeDataForStore.expiry_date_month
			_StripeExpYear = stripeDataForStore.expiry_date_year
			--_StripePin = stripeDataForStore.expiry_date_year
			
			if( stripeDataForStore.publishable_key == stripe_Public_key and stripeDataForStore.secret_key == strip_api_key ) then
				print("store owner's stripe account is Same")
				print( stripeDataForStore.stripe_account_id.." = ".._StripeCustomerID )
				print(stripeDataForStore.card_number.." = ".._StripeCardNo )
				print( stripeDataForStore.cvv_number.." = ".._StripeCVVNo )
				print( stripeDataForStore.expiry_date_month.." = ".._StripeExpMont )
				print(stripeDataForStore.expiry_date_year.." = ".._StripeExpYear )
				
				if( stripeDataForStore.stripe_account_id == _StripeCustomerID and stripeDataForStore.card_number == _StripeCardNo and stripeDataForStore.cvv_number == _StripeCVVNo and stripeDataForStore.expiry_date_month == _StripeExpMont and stripeDataForStore.expiry_date_year == _StripeExpYear )  then
					
					print("user's stripe account is same for this owner's stripe account. NO NEED TO UPDATE")
					downloadMenuImage()
					
				else
					print("user's stripe account is CHANGED for this owner's stripe account. NEED TO UPDATE")
					updateStripeAccount()
					
				end
				
			else
				print("store owner's stripe account chnaged. NEED TO UPDATE")
				createAndUpdateStripeAccount()
			end
			
		
		end
	end
	return true
end

local function checkStripeAccount()
	
		local headers = {}
		
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		
		local body = "user_id=".._UserID.."&store_id=".._StoreID
		local params = {}
		params.headers = headers
		params.body = body
		params.timeout = 180
		
		local url = _WebLink.."stripe-view.php?"
		print( url..body )
		checkStripeRequest = network.request( url, "POST", stripeDataNetworkListener, params )
	

end	

local function BeaconDataNetworkListener( event )
	if ( event.isError ) then
        print( "Network error!" )
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onCloseApp )
		
    else
        print ( "Beacon data RESPONSE:" .. event.response )
        
		
		if( event.response == 0 or event.response == "0" ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        elseif( event.response == 1 or event.response == "1" ) then
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("17Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        elseif( event.response == 2 or event.response == "2" ) then
        	local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        elseif( event.response == 3 or event.response == "3" ) then
        	--local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Store2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onCloseApp )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("RestaurantListingAlert",_LanguageKey), {  GBCLanguageCabinet.getText("NoLabel",_LanguageKey),GBCLanguageCabinet.getText("YesLabel",_LanguageKey) }, handleRestaurantAlertEvent )
        elseif( event.response == 4 or event.response == "4" ) then
        	local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
        elseif( event.response == 5 or event.response == "5" ) then
        	--local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Store2Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onCloseApp )
        	local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("RestaurantListingAlert",_LanguageKey), {  GBCLanguageCabinet.getText("NoLabel",_LanguageKey),GBCLanguageCabinet.getText("YesLabel",_LanguageKey) }, handleRestaurantAlertEvent )
        else
        	if(event.response) then
				beaconData = json.decode( event.response )
				_HotelName = beaconData.store_name
				_HotelAddress = beaconData.address
				_StoreID = beaconData.id
				_TableNumber = ""
				_isNotesVisible = beaconData.display_note  -- whether to add notes or not??
				--strip_api_key = beaconData.secret_key
				--stripe_Public_key = beaconData.publishable_key
				_AppFee = beaconData.stripe_discount_percentage
				desti = beaconData.stripe_user_id
				
				appStatusText.text = GBCLanguageCabinet.getText("welcomeLabel",_LanguageKey).." \n "..GBCLanguageCabinet.getText("toLabel",_LanguageKey).."\n".._HotelName.."\n\n"..GBCLanguageCabinet.getText("welcomeScreenStrLabel",_LanguageKey)
				--downloadMenuImage()
				checkStripeAccount()
				
			else
        		local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
			end
		end
	
	end
	return true
end

function fetchDataFromBeacon()
		
		local headers = {}
		
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		local body
		
		if( _LanguageKey == "en" ) then
			body = "beacon_major=".._majorBea
		else
			body = "beacon_major=".._majorBea.."&lang=".._LanguageKey
		end
		local params = {}
		params.headers = headers
		params.body = body
		params.timeout = 180
		
		local url = _WebLink.."store-find.php?"
		print( url..body )
		menuRequest = network.request( url, "POST", BeaconDataNetworkListener, params )
		--native.setActivityIndicator( true )
	
end

function findBeaconFunc()

timer.performWithDelay( 5000, function()
	if iBeaconRunning then
		print("request stop scan from corona")
		--iBeacon.stopscan( listener )
	else
		print("iBeacon not running")
	end
end )

timer.performWithDelay( 8000, function()
	
	if iBeaconRunning then
		print("request getBeacons from corona")
		iBeacon.getBeacons( listener )
	else
		print("iBeacon not running")
	end
	--library.show( "corona" )
end )

timer.performWithDelay( 12000, function ()
	
	local function checkForBeacons()
	
	if(_majorBea == nil or _majorBea == "" ) then
		-- no beacon found
		print("no beacon found")
		beaconDetectCount = beaconDetectCount + 1
		
		if( beaconDetectCount > 4 ) then
			if iBeaconRunning then
				print("request stop scan from corona")
				iBeacon.stopscan( listener )
			else
				print("iBeacon not running")
			end
			
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("19Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onCloseApp )
			--local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("RestaurantListingAlert",_LanguageKey), {  GBCLanguageCabinet.getText("NoLabel",_LanguageKey),GBCLanguageCabinet.getText("YesLabel",_LanguageKey) }, handleRestaurantAlertEvent )
			
		else
		
			print("beacon find try ......"..beaconDetectCount)
			fetchBeaconTimer = timer.performWithDelay(5100,checkForBeacons,1)
			 
		end
		
	else
		iBeacon.stopscan( listener )
		if( fetchBeaconTimer ) then
			timer.cancel( fetchBeaconTimer )
			fetchBeaconTimer = nil
		end
		fetchDataFromBeacon() -- got major and minor 
	end
	
	
	end
	
	checkForBeacons()
	
	
end)

end

local function stripeKeyNetworkListener( event )
	if ( event.isError ) then
        print( "Network error!" )
        
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
		
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onCloseApp )
		
    else
    	stripeKeyData = json.decode( event.response )
    	if( event.response == "0" or event.response == 0 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onCloseApp )
    	elseif( event.response == "1" or event.response == 1 ) then
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("Stripe3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onCloseApp )
    	else
    		strip_api_key = stripeKeyData.stripe_secret_key
			stripe_Public_key = stripeKeyData.stripe_publishable_key
			
			findBeaconFunc()
			
    	end
    end
	return true
	
end

local function getStripeKeysFunc()

		local headers = {}
		
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		
		local body = ""
		local params = {}
		params.headers = headers
		params.body = body
		params.timeout = 180
		
		local url = _WebLink.."stripe-key.php"
		print( url..body )
		s_keyRequest = network.request( url, "POST", stripeKeyNetworkListener, params )

end

getStripeKeysFunc()

loader_White = { }
loader_Pin = { }
for i = 1, 3 do

	loader_White[i] = display.newImageRect( "images/WelcomePage/2.png",_W/36,_H/64)
    loader_White[i].x = _W/2 + ( i-2 ) * _W/20
    loader_White[i].y = _H/2 + _H/8
    sceneGroup:insert( loader_White[i] )
    loader_White[i].isVisible = false
    
    loader_Pin[i] = display.newImageRect( "images/WelcomePage/1.png",_W/36,_H/64)
    loader_Pin[i].x = _W/2 + ( i-2 ) * _W/20
    loader_Pin[i].y = _H/2 + _H/8
    sceneGroup:insert( loader_Pin[i] )
    loader_Pin[i].isVisible = false
    
end

k = 1
local function loaderAnimFunc( event )

	for i = 1, 3 do
		loader_White[i].isVisible = true
		loader_Pin[i].isVisible = false
	end
		loader_Pin[k].isVisible = true
	if(k == 3) then
		k = 1
	else
		k = k + 1
	end
	
end
loaderAnimFunc()
loaderTimer = timer.performWithDelay( 500,loaderAnimFunc,-1 )

        
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
       --[[ mySpinner:pause()
        
        display.remove(mySpinner)
        mySpinner = nil]]--
        
        appStatusText.text = ""
        
        if(loaderTimer) then
        	timer.cancel(loaderTimer)
        	loaderTimer = nil
        end
        
        display.remove(appStatusText)
        appStatusText = nil
        
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

-- -------------------------------------------------------------------------------

return scene