-- slideView.lua
-- 
-- Version 1.0 
--
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.

module(..., package.seeall)

local screenW, screenH = display.contentWidth, display.contentHeight
local viewableScreenW, viewableScreenH = display.viewableContentWidth, display.viewableContentHeight
local screenOffsetW, screenOffsetH = display.contentWidth -  display.viewableContentWidth, display.contentHeight - display.viewableContentHeight

local imgNum = nil
local images = nil
local touchListener, nextImage, prevImage, cancelMove, initImage
local background
local imageNumberText, imageNumberTextShadow

function new( ypos, imageSet, slideBackground, top, bottom )	
	local pad = 20
	local top = top or 0 
	local bottom = bottom or 0
	
	local g = display.newGroup()
		
	if slideBackground then
		background = display.newImage(slideBackground, 0, 0, true)
	else
		background = display.newRect( _W/2, _H/2 - 400,_W, _H/3.84 )

		background.x = _W/2
		background.y = ypos
		background:toBack()
		background.anchorX = 0.5
		background.anchorY = 0
		background:setFillColor( 1,1,1,0.1 )
		
	end
	g:insert(background)
	
	images = {}
	for i = 1,#imageSet do
		local p = display.newImage(imageSet[i],system.TemporaryDirectory)
		local h = background.height 
		p.width = _W
		p.height = _W,_W/(p.width/p.height)
		
		if(p.height > _H/3.84) then
			p.height = _H/3.84
			p.width = _H/3.84,_H/3.84/(p.height/p.width)
			if(p.width > _W) then
				p.width = _W
			end
		end
		g:insert(p)
	    
		if (i > 1) then
			p.x = screenW*1.5 + pad 
		else 
			p.x = screenW*.5
		end
		
		p.y =  background.y + background.height/2

		images[i] = p
	end
	
	local defaultString = "1 of " .. #images

	local navBar = display.newGroup()
	g:insert(navBar)
	
	imgNum = 1
	
	g.x = 0
	g.y = top + display.screenOriginY
			
	function touchListener (self, touch) 
		local phase = touch.phase
		if ( phase == "began" ) then
            -- Subsequent touch events will target button even if they are outside the contentBounds of button
            display.getCurrentStage():setFocus( self )
            self.isFocus = true

			startPos = touch.x
			prevPos = touch.x
			
			transition.to( navBar,  { time=200, alpha=math.abs(navBar.alpha-1) } )
									
        elseif( self.isFocus ) then
        
			if ( phase == "moved" ) then
			
				transition.to(navBar,  { time=400, alpha=0 } )
						
				if tween then transition.cancel(tween) end
					
				local delta = touch.x - prevPos
				prevPos = touch.x
				
				images[imgNum].x = images[imgNum].x + delta
				
				if (images[imgNum-1]) then
					images[imgNum-1].x = images[imgNum-1].x + delta
				end
				
				if (images[imgNum+1]) then
					images[imgNum+1].x = images[imgNum+1].x + delta
				end

			elseif ( phase == "ended" or phase == "cancelled" ) then
				
				dragDistance = touch.x - startPos
				
				if (dragDistance < -40 and imgNum < #images) then
					nextImage()
				elseif (dragDistance > 40 and imgNum > 1) then
					prevImage()
				else
					cancelMove()
				end
									
				if ( phase == "cancelled" ) then		
					cancelMove()
				end

                -- Allow touch events to be sent normally to the objects they "hit"
                display.getCurrentStage():setFocus( nil )
                self.isFocus = false
														
			end
		end
					
		return true
		
	end
	
	function setSlideNumber()
		for i = 1,#imageSet do
			dot2[i].isVisible = false
			dot[i].isVisible = true
		end
		dot2[imgNum].isVisible = true
		
	end
	
	function cancelTween()
		if prevTween then 
			transition.cancel(prevTween)
		end
		prevTween = tween 
	end
	
	function nextImage()
		tween = transition.to( images[imgNum], {time=400, x=(screenW*.5 + pad)*-1, transition=easing.outExpo } )
		tween = transition.to( images[imgNum+1], {time=400, x=screenW*.5, transition=easing.outExpo } )
		imgNum = imgNum + 1
		initImage(imgNum)
	end
	
	function prevImage()
		tween = transition.to( images[imgNum], {time=400, x=screenW*1.5+pad, transition=easing.outExpo } )
		tween = transition.to( images[imgNum-1], {time=400, x=screenW*.5, transition=easing.outExpo } )
		imgNum = imgNum - 1
		initImage(imgNum)
	end
	
	function cancelMove()
		tween = transition.to( images[imgNum], {time=400, x=screenW*.5, transition=easing.outExpo } )
		tween = transition.to( images[imgNum-1], {time=400, x=(screenW*.5 + pad)*-1, transition=easing.outExpo } )
		tween = transition.to( images[imgNum+1], {time=400, x=screenW*1.5+pad, transition=easing.outExpo } )
	end
	
	function initImage(num)
		if (num < #images) then
			images[num+1].x = screenW*1.5 + pad			
		end
		if (num > 1) then
			images[num-1].x = (screenW*.5 + pad)*-1
		end
	end

	background.touch = touchListener
	background:addEventListener( "touch", background )

	------------------------
	-- Define public methods
	
	function g:jumpToImage(num)
		local i
		for i = 1, #images do
			if i < num then
				images[i].x = -screenW*.5;
			
			elseif i > num then
				images[i].x = screenW*1.5 + pad
				
			else
				images[i].x = screenW*.5 - pad
				
			end
		end
		imgNum = num
		initImage(imgNum)
	end

	function g:cleanUp()
		background:removeEventListener("touch", touchListener)
	end

	return g	
end