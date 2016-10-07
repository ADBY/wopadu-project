local aspectRatio = display.pixelHeight / display.pixelWidth
application = {
   content = {
      width = aspectRatio > 1.5 and 800 or math.floor( 1200 / aspectRatio ),
      height = aspectRatio < 1.5 and 1200 or math.floor( 800 * aspectRatio ),
      scale = "letterBox",
      fps = 30,

   },
   
   notification = {
    google = {
     projectNumber = "849646382445" 
     },
     
     iphone = { 
     types = { "badge", "sound", "alert" } 
     }
      }
}