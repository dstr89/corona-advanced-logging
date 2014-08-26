-------------------------------------------------
-- CORONA SDK - ADVANCED LOGGING MODULE - SAMPLE - MAIN
--
-- @Daniel 05.07.2014
-------------------------------------------------

-------------------------------------------------
-- REQUIRE MODULES
-------------------------------------------------
local composer = require("composer")
local sqlite3 = require ("sqlite3");
local log = require("log")

--Main function, called on applications first start
local function main()
	
	-------------------------------------------------
	-- SETUP DATABASE CONNECTION
	-- Required to use Advanced logging module
	-------------------------------------------------
	local path = system.pathForFile("sample.db", system.DocumentsDirectory)
	db = sqlite3.open(path)  

	-------------------------------------------------
	-- SETUP ADVANCED LOGGING MODULE
	-------------------------------------------------
	log:set(db, "your_email_adress@gmail.com")
	
	-------------------------------------------------
	-- TEST ADVANCED LOGGING MODULE
	-------------------------------------------------
	log:log("Advanced logging module is now ready", "Comment on: http://forums.coronalabs.com/topic/50004-corona-advanced-logging/")

	local variable = nil
	log:log("Variable", variable)

	-------------------------------------------------
	-- GO TO HOME SCENE (composer)
	-------------------------------------------------
	composer.gotoScene( "home" )

end

main();

