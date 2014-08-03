-------------------------------------------------
-- CORONA SDK - ADVANCED LOGGING MODULE - SAMPLE - HOME COMPOSER SCENE
--
-- @Daniel 05.07.2014
-------------------------------------------------

local composer = require("composer")
local widget = require("widget")
local log = require("log")
local scene = composer.newScene()

-- Function to handle button event
local function handleButtonEvent( event )
    if ( "ended" == event.phase ) then
         log:log( "Button was pressed and released" )
         -------------------------------------------------
         -- MAKE A ERROR   
         -- Here we make an intentional error to test Advanced logging module
         -------------------------------------------------
         asd = asd .. "asd"
    end
end

-- Called when scene is created
function scene:create( event )

   local sceneGroup = self.view
   log:log("Scene created: " .. composer.getSceneName( "current" ))

   -- Create the widget
   local sampleButton = widget.newButton
   {
       width = 200,
       left = display.contentWidth / 2 - 100,
       top = 100,
       id = "sampleButton",
       label = "Make an error",
       fontSize = 25,
       labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0 } },
       shape = "roundedRect",
       fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
       onEvent = handleButtonEvent
   }

end

-- Called when scene is on screen
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      log:log("Scene shown: " .. composer.getSceneName( "current" ) .. " (will phase)")

   elseif ( phase == "did" ) then
      log:log("Scene shown: " .. composer.getSceneName( "current" ) .. " (did phase)")
   end
end

-- Called when scene goes off screen
function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      log:log("Scene hidden: " .. composer.getSceneName( "current" ) .. " (will phase)")

   elseif ( phase == "did" ) then
      log:log("Scene hidden: " .. composer.getSceneName( "current" ) .. " (did phase)")
   end

end

-- Called when scene is destroyed
function scene:destroy( event )

   local sceneGroup = self.view
   log:log("Scene destroyed: " .. composer.getSceneName( "current" ))

end

---------------------------------------------------------------------------------
-- Listeners setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------

return scene