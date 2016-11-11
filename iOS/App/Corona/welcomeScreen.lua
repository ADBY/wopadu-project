local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

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
            composer.gotoScene( "RestaurantsList" )
        elseif ( i == 1 ) then
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
        _Flag = false
        _StopTimerFlag = false
        
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
		appStatusText:setFillColor( 0 )
		sceneGroup:insert( appStatusText )
		
		appStatusText.text = GBCLanguageCabinet.getText("SearchingForVenueLabel",_LanguageKey)
		
		local function productListNetworkListener( event )
			if ( event.isError ) then
				timer.performWithDelay( 200, function() 
				native.setActivityIndicator( false )
				end )
				
			else
				product_count = 0
				
				if( event.response == 0 or event.response == "0" ) then
					local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
					
				elseif( event.response == 1 or event.response == "1" ) then
					local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("12Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				
				elseif( event.response == 2 or event.response == "2" ) then
					local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				
				elseif( event.response == 3 or event.response == "3" ) then
					
				else
				
					local function networkListenerProductImage( event )
							
					 if ( event.isError ) then
							
							product_count = product_count + 1
							if product_count == #productImages then
								
							end
				
					 elseif ( event.phase == "began" ) then
							
					 elseif ( event.phase == "ended" ) then
							
							product_count = product_count + 1
							
							if product_count == #productImages then
								
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
												
												product_count = product_count + 1
												if product_count == #productImages then
													
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
			
			local function menuListNetworkListener( event )
				if ( event.isError ) then
					
					timer.performWithDelay( 200, function() 
					native.setActivityIndicator( false )
					end )
					
					local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
					
				else
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
								count = count + 1
								
								if count == (#categoryImage3 + #categoryImage1 + #categoryImage2) then
									
									onDownloandSubCategoryImage()
									
								end
								
							elseif ( event.phase == "began" ) then
								
							elseif ( event.phase == "ended" ) then
								
								count = count + 1
								
								if count == (#categoryImage3 + #categoryImage1 + #categoryImage2) then
									
									onDownloandSubCategoryImage()
								end
								
							end
							
						end
						
						local function networkListenerSubImage( event )
							if ( event.isError ) then
								
								sub_count = sub_count + 1
								
								if sub_count == #subMenuImages then
									
									onDownloandSubToSubCategoryImage()
									
								end
								
							elseif ( event.phase == "began" ) then
								
							elseif ( event.phase == "ended" ) then
								
								sub_count = sub_count + 1
								
								if sub_count == #subMenuImages then
									
									onDownloandSubToSubCategoryImage()
									
								end
								
							end
							
						end
						
						local function networkListenerSubToSubImage( event )
							if ( event.isError ) then
								
								subToSub_count = subToSub_count + 1
								if subToSub_count == #subToSubMenuImages then
									
									onDownloandSubToSubCategory2Image()
									
								end
								
							elseif ( event.phase == "began" ) then
								
							elseif ( event.phase == "ended" ) then
								
								subToSub_count = subToSub_count + 1
								if subToSub_count == #subToSubMenuImages then
									
									onDownloandSubToSubCategory2Image()
									
								end
								
							end
							
						end
						
						local function networkListenerSubToSub2Image( event )
							if ( event.isError ) then
								
								subToSub2_count = subToSub2_count + 1
								if subToSub2_count == #subToSub2MenuImages then
									
									downloadProductData()
									
								end
								
							elseif ( event.phase == "began" ) then
								
							elseif ( event.phase == "ended" ) then
								
								subToSub2_count = subToSub2_count + 1
								if subToSub2_count == #subToSub2MenuImages then
									
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
									count = count + 1
									if count == (#categoryImage3 + #categoryImage1 + #categoryImage2) then
										
										timer.performWithDelay( 200, function() 
										native.setActivityIndicator( false )
										end )
										
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
									count = count + 1
									if count == (#categoryImage3 + #categoryImage1 + #categoryImage2) then
										
										timer.performWithDelay( 200, function() 
										native.setActivityIndicator( false )
										end )
										
										onDownloandSubCategoryImage()
										
									end
									
								end
								
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
									count = count + 1
									if count == (#categoryImage3 + #categoryImage1 + #categoryImage2) then
										
										timer.performWithDelay( 200, function() 
										native.setActivityIndicator( false )
										end )
										
										onDownloandSubCategoryImage()
										
									end
									
								end
								
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
										sub_count = sub_count + 1
										if sub_count == #subMenuImages then        				
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
										subToSub_count = subToSub_count + 1
										if subToSub_count == #subToSubMenuImages then								
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
										subToSub2_count = subToSub2_count + 1
										if subToSub2_count == #subToSub2MenuImages then
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
									productRequest[i] = network.request( url, "POST", productListNetworkListener, params )
									
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
			menuRequest = network.request( url, "POST", menuListNetworkListener, params )
			
		end
		
		local function stripeUpdationNetworkListener( event )
			if ( event.isError ) then
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
				timer.performWithDelay( 200, function() 
				native.setActivityIndicator( false )
				end )
				
			else
				timer.performWithDelay( 200, function() 
				native.setActivityIndicator( false )
				end )
				
				local data1 = event.response
				local resp1 = json.decode(data1)
				local error = resp1.error
				if error ~= nil then
					for i = 1, #resp1.error do
						
					end 
				end
				
				if error == nil then
					emailReturn = resp1.email
					
					local headers = {}
			
					headers["Content-Type"] = "application/x-www-form-urlencoded"
					headers["Accept-Language"] = "en-US"
			
					local body = "user_id=".._UserID.."&store_id=".._StoreID.."&stripe_acc_id=".._StripeCustomerID.."&cvv_number=".._StripeCVVNo.."&card_number=".._StripeCardNo.."&exp_date_month=".._StripeExpMont.."&exp_date_year=".._StripeExpYear.."&secret_key="..strip_api_key.."&publishable_key="..stripe_Public_key.."&pin_number=".._StripePin
					local params = {}
					params.headers = headers
					params.body = body
					params.timeout = 180
			
					local url = _WebLink.."stripe-update.php?"
					stripeUpdateRequest2 = network.request( url, "POST", stripeUpdationNetworkListener, params )
					
				else
					local alert = native.showAlert( alertLabel,error.message, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) } )
				end  
			end
		end
		
		local function updateStripeAccount( event )
			
			local description = ""
			local updateCustomer = "email=".._UserName.."&description="..description.."&card[number]=".._StripeCardNo.."&card[exp_year]=".._StripeExpYear.."&card[exp_month]=".._StripeExpMont.."&card[cvc]=".._StripeCVVNo
			
			local key = {["Bearer"] = strip_api_key}
			
			local headers = { 
				["Authorization"] ="Bearer "..strip_api_key,
				["Content-Type"] = "application/x-www-form-urlencoded"
			}
			
			local params = {}
			params.headers = headers
			params.body =  updateCustomer 
			
			updateStripeAccountRequest = network.request("https://api.stripe.com/v1/customers/".._StripeCustomerID, "POST", updateCustomerNetworkListener, params)
			native.setActivityIndicator( true ) 
			
		end
		
		local function registerAndUpdateNetworkListener( event )
			if ( event.isError ) then
				timer.performWithDelay( 200, function() 
				native.setActivityIndicator( false )
				end )
				
			else
				
				timer.performWithDelay( 200, function() 
				native.setActivityIndicator( false )
				end )
				
				local data1 = event.response
				resp1 = json.decode(data1)
				local error = resp1.error
				if error ~= nil then
					for i = 1, #resp1.error do
						
					end 
				else
					
				end
			   
				if error == nil then
					
					_StripeCustomerID = resp1.id
					
					local headers = {}
			
					headers["Content-Type"] = "application/x-www-form-urlencoded"
					headers["Accept-Language"] = "en-US"
				
					local body = "user_id=".._UserID.."&store_id=".._StoreID.."&stripe_acc_id=".._StripeCustomerID.."&cvv_number=".._StripeCVVNo.."&card_number=".._StripeCardNo.."&exp_date_month=".._StripeExpMont.."&exp_date_year=".._StripeExpYear.."&secret_key="..strip_api_key.."&publishable_key="..stripe_Public_key.."&pin_number=".._StripePin
					local params = {}
					params.headers = headers
					params.body = body
					params.timeout = 180
			
					local url = _WebLink.."stripe-update.php?"
					stripeUpdateRequest = network.request( url, "POST", stripeUpdationNetworkListener, params )
					
					return resp1
				else
					local alert = native.showAlert( alertLabel,error.message, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				end
				
			end
			return true
		end
		
		local function createAndUpdateStripeAccount( event )
			local description = ""
			local newCustomer = "email=".._UserName.."&description="..description.."&card[number]=".._StripeCardNo.."&card[exp_year]=".._StripeExpYear.."&card[exp_month]=".._StripeExpMont.."&card[cvc]=".._StripeCVVNo
			
			local key = {["Bearer"] = strip_api_key}
			
			local headers = { 
				["Authorization"] ="Bearer "..strip_api_key,
				["Content-Type"] = "application/x-www-form-urlencoded"
			}
			
			local params = {}
			params.headers = headers
			params.body =  newCustomer 
			
			stripAccountRequest = network.request("https://api.stripe.com/v1/customers", "POST", registerAndUpdateNetworkListener, params)
			return true
		end
		
		local function stripeRegistrationNetworkListener( event )
			if ( event.isError ) then
				
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
				
			else
				
				timer.performWithDelay( 200, function() 
				native.setActivityIndicator( false )
				end )
				
				local data1 = event.response
				resp1 = json.decode(data1)
				local error = resp1.error
				if error ~= nil then
					for i = 1, #resp1.error do
						
					end 
				else
					
				end
			   
				if error == nil then
					_StripeCustomerID = resp1.id
					
					local headers = {}
					
					headers["Content-Type"] = "application/x-www-form-urlencoded"
					headers["Accept-Language"] = "en-US"
					
					local body = "user_id=".._UserID.."&store_id=".._StoreID.."&stripe_acc_id=".._StripeCustomerID.."&cvv_number=".._StripeCVVNo.."&card_number=".._StripeCardNo.."&exp_date_month=".._StripeExpMont.."&exp_date_year=".._StripeExpYear.."&secret_key="..strip_api_key.."&publishable_key="..stripe_Public_key.."&pin_number=".._StripePin
					local params = {}
					params.headers = headers
					params.body = body
					params.timeout = 180
					
					local url = _WebLink.."stripe-add.php?"
					stripeAppRequest = network.request( url, "POST", stripeRegistrationNetworkListener, params )
					
					return resp1
					
				else
					local alert = native.showAlert( alertLabel,error.message, { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				end
				
			end
		end
		
		local function createNewStripeAccount( event )
			
			local description = ""
			local newCustomer = "email=".._UserName.."&description="..description.."&card[number]=".._StripeCardNo.."&card[exp_year]=".._StripeExpYear.."&card[exp_month]=".._StripeExpMont.."&card[cvc]=".._StripeCVVNo
			
			local key = {["Bearer"] = strip_api_key}
			
			local headers = { 
				["Authorization"] ="Bearer "..strip_api_key,
				["Content-Type"] = "application/x-www-form-urlencoded"
			}
			
			local params = {}
			params.headers = headers
			params.body =  newCustomer 
			
			stripAccountRequest = network.request("https://api.stripe.com/v1/customers", "POST", registerNetworkListener, params)
			
		end
		
		local function stripeDataNetworkListener( event )
			if ( event.isError ) then
				
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onCloseApp )
				
			else
				if( event.response == 0 or event.response == "0" ) then
					
				elseif( event.response == 1 or event.response == "1" ) then
					
				elseif( event.response == 2 or event.response == "2" ) then
					
				elseif( event.response == 3 or event.response == "3" ) then
					if( _StripeCardNo == nil ) then
						downloadMenuImage()
					else
						createNewStripeAccount()
						
					end
				else
					
					stripeDataForStore = json.decode( event.response )
					
					_StripeCustomerID = stripeDataForStore.stripe_account_id
					_StripeCardNo = stripeDataForStore.card_number
					_StripeCVVNo = stripeDataForStore.cvv_number
					_StripeExpMont = stripeDataForStore.expiry_date_month
					_StripeExpYear = stripeDataForStore.expiry_date_year
					
					if( stripeDataForStore.publishable_key == stripe_Public_key and stripeDataForStore.secret_key == strip_api_key ) then
						
						if( stripeDataForStore.stripe_account_id == _StripeCustomerID and stripeDataForStore.card_number == _StripeCardNo and stripeDataForStore.cvv_number == _StripeCVVNo and stripeDataForStore.expiry_date_month == _StripeExpMont and stripeDataForStore.expiry_date_year == _StripeExpYear )  then
							
							downloadMenuImage()
							
						else
							updateStripeAccount()
							
						end
						
					else
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
			checkStripeRequest = network.request( url, "POST", stripeDataNetworkListener, params )
			
		end	
		
		local function BeaconDataNetworkListener( event )
			if ( event.isError ) then
				
				timer.performWithDelay( 200, function() 
				native.setActivityIndicator( false )
				end )
				
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onCloseApp )
				
			else        
				
				if( event.response == 0 or event.response == "0" ) then
					local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				elseif( event.response == 1 or event.response == "1" ) then
					local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("17Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				elseif( event.response == 2 or event.response == "2" ) then
					local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				elseif( event.response == 3 or event.response == "3" ) then
					local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("RestaurantListingAlert",_LanguageKey), {  GBCLanguageCabinet.getText("NoLabel",_LanguageKey),GBCLanguageCabinet.getText("YesLabel",_LanguageKey) }, handleRestaurantAlertEvent )
				elseif( event.response == 4 or event.response == "4" ) then
					local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				elseif( event.response == 5 or event.response == "5" ) then
					local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("RestaurantListingAlert",_LanguageKey), {  GBCLanguageCabinet.getText("NoLabel",_LanguageKey),GBCLanguageCabinet.getText("YesLabel",_LanguageKey) }, handleRestaurantAlertEvent )
				else
					if(event.response) then
						beaconData = json.decode( event.response )
						_HotelName = beaconData.store_name
						_HotelAddress = beaconData.address
						_StoreID = beaconData.id
						_TableNumber = ""
						_isNotesVisible = beaconData.display_note
						_AppFee = beaconData.stripe_discount_percentage
						desti = beaconData.stripe_user_id
						
						appStatusText.text = GBCLanguageCabinet.getText("welcomeLabel",_LanguageKey).." \n "..GBCLanguageCabinet.getText("toLabel",_LanguageKey).."\n".._HotelName.."\n\n"..GBCLanguageCabinet.getText("welcomeScreenStrLabel",_LanguageKey)
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
			menuRequest = network.request( url, "POST", BeaconDataNetworkListener, params )
			
		end
		
		function findBeaconFunc()
			
			timer.performWithDelay( 5000, function()
				iBeacon.allocateBluetoothInstance( listener )
				iBeacon.getBluetoothStatues( listener )
				
			end )
			
			timer.performWithDelay( 12000, function ()
				
				local function checkForBeacons()
					if(_majorBea == nil or _majorBea == "" ) then
						beaconDetectCount = beaconDetectCount + 1
						
						if( beaconDetectCount > 4 ) then
							
							if iBeaconRunning then
								iBeacon.stopscan( listener )
							else
								
							end
							
							local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("RestaurantListingAlert",_LanguageKey), {  GBCLanguageCabinet.getText("NoLabel",_LanguageKey),GBCLanguageCabinet.getText("YesLabel",_LanguageKey) }, handleRestaurantAlertEvent )
							
						else
							
							fetchBeaconTimer = timer.performWithDelay(5100,checkForBeacons,1)
							 
						end
						
					else
						iBeacon.stopscan( listener )
						
						if( fetchBeaconTimer ) then
							timer.cancel( fetchBeaconTimer )
							fetchBeaconTimer = nil
						end
						
						fetchDataFromBeacon()
					end
				end
				
				checkForBeacons()
				
			end)
			
		end
		
		local function stripeKeyNetworkListener( event )
			if ( event.isError ) then
				
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