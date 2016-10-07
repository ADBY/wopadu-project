local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------
local imageDirectory = "images/SignUp/"
local imageDirectory2 = "images/Setting/"
local imageDirectory3 = "images/RateWopado/"


--local imageDirectory = "images/Login/"
--local imageDirectory2 = "images/Product Details/"
--local imageDirectory3 = "images/Home/"
local displayGroup, background, param, noOfRatings,heading
local VariableTable = { header, title, backBtn, noReview, reviewsTableView, reviewBg, reviewTf, submitBtn, line }
local viewReviewList = { }
local reviewImage = { }
local reviewImage1 = { }
local fillStar = { }
local emptyStar = { }
local textHeightGap = _H/96
local textFieldWidth = _W/32
local textFieldHeight = _H/64
local myOldReviewRequest,viewReviewRequest,addReviewRequest


local function handleBackButtonEvent( event )
	composer.gotoScene( "Setting" )

	return true
end

local function handleBackButtonEventTouch( event )
	if event.phase == "ended" then
		composer.gotoScene( "Setting" )
	end

	return true
end

local function onDoNothing()

	return true
end



local function onRowRender( event )
	local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth
    
    local rowName = display.newText( row, viewReviewList[row.index].first_name, _W/2, _H/24, _FontArr[26], _H/35 )
    rowName:setFillColor( 83/255, 20/255, 111/255 )
    rowName.anchorX = 0
    --rowName.anchorY = 0
    rowName.x = _W/36
    rowName.y = rowHeight * 0.15
    
    if tonumber(viewReviewList[row.index].rating) == 0 then
    	print( viewReviewList[row.index].rating )
		for i = 1, 5 do
			local rowImage = display.newImageRect( row, imageDirectory3.."Empty_Star.png", _W/21.17, _H/40  )
    		rowImage.anchorX = 0
    		rowImage.x = _W/2 + _W/12 + ((i- 1) * _H/30) 
    		rowImage.y = rowHeight * 0.15
		end
	
	else
   		print( viewReviewList[row.index].rating )
   		local no = 5 - viewReviewList[row.index].rating
   		print( no )
   		
   		for i = 1, 5 do
	   		reviewImage[i] = display.newImageRect( row, imageDirectory3.."Fill_Star.png", _W/21.17, _H/40  )
    		reviewImage[i].anchorX = 0
    		reviewImage[i].x = _W/2 + _W/12 + ((i- 1) * _H/30) 
	    	reviewImage[i].y = rowHeight * 0.15
    		reviewImage[i].id = i
    		reviewImage[i].isVisible = false
    	end
    	
    	for i = 1, 5 do
	   		reviewImage1[i] = display.newImageRect( row, imageDirectory3.."Empty_Star.png", _W/21.17, _H/40  )
    		reviewImage1[i].anchorX = 0
    		reviewImage1[i].x = _W/2 + _W/12 + ((i- 1) * _H/30) 
	    	reviewImage1[i].y = rowHeight * 0.15
    		reviewImage1[i].id = i
    		reviewImage1[i].isVisible = false
    	end
    	
    	for i = 1, tonumber(viewReviewList[row.index].rating) do
			reviewImage[i].isVisible = true
			reviewImage1[i].isVisible = false
		end
		
		for i = tonumber(viewReviewList[row.index].rating)+1, 5 do
			reviewImage1[i].isVisible = true
			reviewImage[i].isVisible = false
		end
    	
	end
    local rowReview = display.newText( row, viewReviewList[row.index].review, _W - _W/12, rowHeight * 0.4, _W - _W/27, 0, _FontArr[26], _H/50 )
    rowReview:setFillColor( 0 )
    rowReview.anchorX = 0
    rowReview.anchorY = 0
    rowReview.x = _W/54
    rowReview.y = rowHeight * 0.30
    
    print("review Lenght "..rowReview.text:len())
    
end

local function viewReviewListNetworkListener( event )
    		if ( event.isError ) then
        		print( "Network error!" )
				
        		timer.performWithDelay( 200, function() 
    			native.setActivityIndicator( false )
				end )
				
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				
			else
				print ( "RESPONSE::::" .. event.response )
				
				if( event.response == 0 or event.response == "0" ) then
					timer.performWithDelay( 200, function() 
    				native.setActivityIndicator( false )
					end )
					
					if VariableTable.noReview then
						display.remove( VariableTable.noReview )
						VariableTable.noReview = nil
					end
					
					VariableTable.noReview = display.newText( GBCLanguageCabinet.getText("noReviewFoundLabel",_LanguageKey), _W/2, _H/1.5, _Font2, _W/18 )
        			VariableTable.noReview:setFillColor( 83/255, 20/255, 111/255 )
        			displayGroup:insert( VariableTable.noReview )
        			VariableTable.noReview:toFront()
				
				elseif( event.response == 1 or event.response == "1" or event.response == "EMPTY" ) then
					timer.performWithDelay( 200, function() 
    				native.setActivityIndicator( false )
					end )
					
					if VariableTable.noReview then
						display.remove( VariableTable.noReview )
						VariableTable.noReview = nil
					end
					
					VariableTable.noReview = display.newText( GBCLanguageCabinet.getText("noReviewFoundLabel",_LanguageKey), _W/2, _H/1.5, _Font2, _W/18 )
        			VariableTable.noReview:setFillColor( 83/255, 20/255, 111/255 )
        			displayGroup:insert( VariableTable.noReview )
        			VariableTable.noReview:toFront()
				
				else
				
					viewReviewList = json.decode(event.response)
					
					if VariableTable.noReview then
						display.remove( VariableTable.noReview )
						VariableTable.noReview = nil
					end
					
					VariableTable.reviewsTableView = widget.newTableView
					{
						left = 0,
		   				top = VariableTable.line.y + VariableTable.line.height/2 + _H/64,
 			   			height = _H - VariableTable.reviewTf.y + VariableTable.reviewTf.height/2 - VariableTable.line.height/2 - _H/64,
 		 	  			width = _W,
 		 	  			noLines = true,
  						onRowRender = onRowRender,
			   			bottomPadding = _H/8
					}
					displayGroup:insert( VariableTable.reviewsTableView )
					
					for i = 1, #viewReviewList do
				 		local rowHeight = _H/4.5
						local rowColor
						
						if i%2 == 0 then
							rowColor = { default={ 1, 1, 1 }, over = { 0, 0, 0, 0.4 } }
						else
							rowColor = { default={ 0, 0, 0, 0.1 }, over = { 0, 0, 0, 0.4 } }
						end
						
		        		VariableTable.reviewsTableView:insertRow{
    						rowHeight = rowHeight,
    						rowColor = rowColor
		    			}
		    			
        			end
        			
        			timer.performWithDelay( 200, function() 
    				native.setActivityIndicator( false )
					end )
				
				end
				
			end
    		
    		return true
    	end

local function getOtherReviews( event )
	local headers = {}
		
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		pageIndex = 1
		local body = "action=all&page="..pageIndex
		
		local params = {}
		params.headers = headers
		params.body = body
		params.timeout = 180
		
		local url = _WebLink.."app-rating.php?"
		print( url..body )
		viewReviewRequest = network.request( url, "POST", viewReviewListNetworkListener, params )
		native.setActivityIndicator( true )
   	
	
end

local function ViewMyOldReviewNetworkListener( event )
	if ( event.isError ) then
        print( "Network error!" )
				
        timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
				
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				
	else
		print ( "RESPONSE:" .. event.response )
		getOtherReviews()	
		if( event.response == 0 or event.response == "0" ) then
			timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("6Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing ) 
			
		elseif( event.response == 1 or event.response == "1" ) then
			timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
			local alert = native.showAlert( alertLabel,  GBCLanguageCabinet.getText("User3Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing ) 
			
		elseif( event.response == 2 or event.response == "2" ) then
			timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
						
		elseif( event.response == "NOT_REVIEWED" ) then
			timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
			--local alert = native.showAlert( alertLabel, "User has not reviewed yet", { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
					
		else
			timer.performWithDelay( 200, function() 
    		native.setActivityIndicator( false )
			end )
				local reviewData = json.decode(event.response)
				
				--[[local no = reviewData.rating
				print( "No of star is : " ..no )
				noOfRatings = no
	
				for i = 1, no do
					emptyStar[i].isVisible = false
					fillStar[i].isVisible = true
				end
	
				for i = no+1, 5 do
					emptyStar[i].isVisible = true
					fillStar[i].isVisible = false
				end]]--
				
				--VariableTable.reviewTf.text = reviewData.review
		end			
	end
	return true
end

local function handleFillStarImgEvent( event )
	local no = event.target.id
	print( "No of star is : " ..no )
	noOfRatings = no
	
	for i = 1, no do
		emptyStar[i].isVisible = false
		fillStar[i].isVisible = true
	end
	
	for i = no+1, 5 do
		emptyStar[i].isVisible = true
		fillStar[i].isVisible = false
	end

	return true
end

local function onReviewEdit( event )
    if ( event.phase == "began" ) then
        print( event.text )

    elseif ( event.phase == "ended" ) then
        print( event.target.text )
    
    elseif ( event.phase == "submitted" ) then
    	native.setKeyboardFocus( nil )

    elseif ( event.phase == "editing" ) then
    	print( event.text )
        
    end

	return true
end

local function handleOk( event )
	
		for i = 1, 5 do
			
			emptyStar[i].isVisible = true
			fillStar[i].isVisible = false
			
		end
		VariableTable.reviewTf.text = ""
			
		if VariableTable.reviewsTableView then
			VariableTable.reviewsTableView:deleteAllRows()
			display.remove( VariableTable.reviewsTableView )
			VariableTable.reviewsTableView = nil
		end
		
		getOtherReviews()

	return true
end

local function addReviewListNetworkListener( event )
	if ( event.isError ) then
    	print( "Network error!" )
				
    	timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
				
		local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("networkErrorAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
				
	else	
		timer.performWithDelay( 200, function() 
    	native.setActivityIndicator( false )
		end )
			print("add/update rating resposne: "..event.response)
		if(event.response == "0" or event.response == 0) then
		
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("6Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing ) 
		elseif(event.response == "1" or event.response == 1) then
		
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("AllFieldsMandatoryAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif(event.response == "2" or event.response == 2) then
		
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif(event.response == "3" or event.response == 3) then	
			
			local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("somethingWentWrongAlert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
		elseif( event.response == "OK" ) then			
		
			local alert = native.showAlert( alertLabel,GBCLanguageCabinet.getText("10Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, handleOk )
		end
	end			
	return true
end


local function handleSubmitButtonEvent( event )
	if(event.phase == "ended") then
		if VariableTable.reviewTf.text ~= "" or noOfRatings > 0 then
				print( "Review : "..VariableTable.reviewTf.text )
				print( "no of ratings : "..noOfRatings )
				
				local headers = {}
				
				headers["Content-Type"] = "application/x-www-form-urlencoded"
				headers["Accept-Language"] = "en-US"
				
				local reviewTfValue = VariableTable.reviewTf.text:gsub( "&", "%%26" )
				
				local body = "action=add_update&user_id=".._UserID.."&rating="..noOfRatings.."&review="..reviewTfValue
				
				local params = {}
				params.headers = headers
				params.body = body
				params.timeout = 180
				
				local url = _WebLink.."app-rating.php?"
				print( url..body )
				addReviewRequest = network.request( url, "POST", addReviewListNetworkListener, params )
				native.setActivityIndicator( true )
				

			else
				local alert = native.showAlert( alertLabel, GBCLanguageCabinet.getText("11Alert",_LanguageKey), { GBCLanguageCabinet.getText("okLabel",_LanguageKey) }, onDoNothing )
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
        
        local header = display.newImageRect( imageDirectory.."f_Header.png", _W, _H/13.61 )
        header.x = _W/2
        header.y = _H/27
        sceneGroup:insert( header )
        
        heading = display.newText( GBCLanguageCabinet.getText("RateWopaduLabel",_LanguageKey), header.x, header.y, _FontArr[30], _H/36.76 ) 
        heading:setFillColor( 1 )
        sceneGroup:insert( heading )
        --[[
        local backBtn = display.newImageRect( imageDirectory.."Back_Btn.png", _W/15.42, _H/33.10 )
        backBtn.x = _W/13.5
        backBtn.y = header.y
        sceneGroup:insert( backBtn )
       			
		local backBg = display.newRect( backBtn.x, backBtn.y, backBtn.width + _W/21.6, backBtn.height + _H/38.4 )
		backBg:setFillColor( 83/255, 20/255, 111/255 )
		backBg:addEventListener( "tap", handleBackButtonEvent )
		backBg:addEventListener( "touch", handleBackButtonEventTouch )
		sceneGroup:insert( backBg )
		backBtn:toFront()    
		]]--
		
	local backBtn = widget.newButton
	{
    	width = _W/9,
    	height = _H/14.76,
    	defaultFile = imageDirectory.."Back_Btn2.png",
   		overFile = imageDirectory.."Back_Btn2.png",
    	id = "back",
    	--onEvent = handleButtonEvent
	}
	backBtn.x = _W/13.5
	backBtn.y = header.y
	backBtn:addEventListener("tap",handleBackButtonEvent)
	sceneGroup:insert( backBtn )
    
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
        noOfRatings = 0
        heading.text = GBCLanguageCabinet.getText("RateWopaduLabel",_LanguageKey)
        
        displayGroup = display.newGroup()
        sceneGroup:insert( displayGroup )
        
		
    	
    	for i = 1, 5 do
        	if i == 1 then
				emptyStar[i] = display.newImageRect( imageDirectory3.."Empty_Star.png", _W/18, _H/32 )
				emptyStar[i].anchorX = 0
        		emptyStar[i].x = _W/36  --_W/21.6
        		emptyStar[i].y = _H/13 + _H/38.4
        		emptyStar[i].id = i
        		emptyStar[i]:addEventListener( "tap", handleFillStarImgEvent )
        		displayGroup:insert( emptyStar[i] )
        	else
        		emptyStar[i] = display.newImageRect( imageDirectory3.."Empty_Star.png", _W/18, _H/32 )
				emptyStar[i].anchorX = 0
        		emptyStar[i].x = emptyStar[i-1].x + emptyStar[i].width + _W/27
        		emptyStar[i].y = emptyStar[i-1].y
        		emptyStar[i].id = i
        		emptyStar[i]:addEventListener( "tap", handleFillStarImgEvent )
        		displayGroup:insert( emptyStar[i] )
        	end
        end
        
        for i = 1, 5 do
        	if i == 1 then
				fillStar[i] = display.newImageRect( imageDirectory3.."Fill_Star.png", _W/18, _H/32 )
				fillStar[i].anchorX = 0
        		fillStar[i].x = _W/36
        		fillStar[i].y = _H/13 + _H/38.4
        		fillStar[i].id = i
        		fillStar[i]:addEventListener( "tap", handleFillStarImgEvent )
        		displayGroup:insert( fillStar[i] )
        		fillStar[i].isVisible = false
        	else
        		fillStar[i] = display.newImageRect( imageDirectory3.."Fill_Star.png", _W/18, _H/32 )
				fillStar[i].anchorX = 0
        		fillStar[i].x = fillStar[i-1].x + fillStar[i].width + _W/27
        		fillStar[i].y = fillStar[i-1].y
        		fillStar[i].id = i
        		fillStar[i]:addEventListener( "tap", handleFillStarImgEvent )
        		displayGroup:insert( fillStar[i] )
        		fillStar[i].isVisible = false
        	end
        end
        
        VariableTable.reviewBg = display.newImageRect( imageDirectory3.."TextBox Bg.png", _W, _H/6.4 )
        VariableTable.reviewBg.x = _W/2
        --VariableTable.reviewBg.anchorX = 0
        VariableTable.reviewBg.y = _H/12 + VariableTable.reviewBg.height/2 + _H/19.2
        displayGroup:insert( VariableTable.reviewBg )
        
        VariableTable.reviewTf = native.newTextBox( VariableTable.reviewBg.x, VariableTable.reviewBg.y, VariableTable.reviewBg.width - textFieldWidth, VariableTable.reviewBg.height - textFieldHeight )
		VariableTable.reviewTf.hasBackground = false
		VariableTable.reviewTf.isEditable = true
		--VariableTable.reviewTf.anchorX = 0
		VariableTable.reviewTf.placeholder = GBCLanguageCabinet.getText("addReviewsLabel",_LanguageKey)
		--VariableTable.reviewTf:addEventListener( "userInput", onReviewEdit )
		VariableTable.reviewTf.font = native.newFont( _Font2, _H/38.4 )
		VariableTable.reviewTf:setTextColor( 57/255, 9/255 ,78/255 )
		displayGroup:insert( VariableTable.reviewTf )
		
		
		
		VariableTable.submitBtn = widget.newButton
		{
    		width = _W/1.08,
    		height = _H/16.27,
    		defaultFile = imageDirectory.."SinUp_Btn.png",
   			overFile = imageDirectory.."SinUp_Btn.png",
    		label = GBCLanguageCabinet.getText("SubmitLabel",_LanguageKey),
    		labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } },
    		fontSize = _H/32,
    		font = _FontArr[10],
    		labelYOffset = _H/275,
    		id = "submit",
    		onEvent = handleSubmitButtonEvent
		}
		VariableTable.submitBtn.x = _W/2
		VariableTable.submitBtn.y = VariableTable.reviewBg.y + VariableTable.reviewBg.height/2 + VariableTable.submitBtn.height/2 + _H/64 
		displayGroup:insert( VariableTable.submitBtn )
		
		VariableTable.line = display.newImageRect( imageDirectory3.."Line2.png", _W/1.08, _H/640 )
        VariableTable.line.x = _W/2
        VariableTable.line.y = VariableTable.submitBtn.y + VariableTable.submitBtn.height/2 + _H/64
        displayGroup:insert( VariableTable.line )
    	
    	
    	local headers = {}
		
		headers["Content-Type"] = "application/x-www-form-urlencoded"
		headers["Accept-Language"] = "en-US"
		
		local body = "action=view&user_id=".._UserID
		
		local params = {}
		params.headers = headers
		params.body = body
		params.timeout = 180
		
		local url = _WebLink.."app-rating.php?"
		print( url..body )
		myOldReviewRequest = network.request( url, "POST", ViewMyOldReviewNetworkListener, params )
		native.setActivityIndicator( true )
		
    	
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
        
        display.remove(VariableTable.reviewTf)
        VariableTable.reviewTf = nil
        
        for i = 1, #VariableTable do
        	if(VariableTable[i]) then
        		display.remove(VariableTable[i])
        		VariableTable[i] = nil
        	end
        end
        
        
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        if(viewReviewRequest) then
        	network.cancel( viewReviewRequest )
        	viewReviewRequest = nil
        end
        
        if(addReviewRequest) then
        	network.cancel( addReviewRequest )
        	addReviewRequest = nil
        end
        
        if(myOldReviewRequest) then
        	network.cancel( myOldReviewRequest )
        	myOldReviewRequest = nil
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