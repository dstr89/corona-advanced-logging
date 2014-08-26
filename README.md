Corona Advanced Logging
=====================

##Usage##

Used for error handling and logging events to console and a set of rolling text log files.
* Use it instead of print in your Corona project
* Your messages will be printed in console but also logged in text files 
* Every message in log file contains time, log level and caller trace (module name and line number)
* A set of rolling text files is used so you can retrace the steps that lead to a bug
* Runtime errors get logged automatically (including stacktrace)
* Users get automatically prompt on runtime errors and can report them via email 
* Application administrator receives device / platform info and log files in attachment


##Sample##

###build.settings###

Set build property neverStripDebugInfo to true for better debugging on device. Remove this when going to production.

```lua
settings = {
	build = {
        neverStripDebugInfo = true
    }
}
```

###main.lua###

Check out the sample Corona project in this repository. Quick preview:

```lua
-------------------------------------------------
-- REQUIRE MODULES
-------------------------------------------------
local sqlite3 = require("sqlite3");
local log = require("log")
-------------------------------------------------
-- SETUP DATABASE CONNECTION
-- Required to use Advanced logging module
-------------------------------------------------
local path = system.pathForFile("sample.db", system.DocumentsDirectory)
db = sqlite3.open(path)  
-------------------------------------------------
-- SETUP ADVANCED LOGGING MODULE
-- This is the simple setup, see properties and defaults
-------------------------------------------------
log:set(db, "your_email_adress@gmail.com")
-------------------------------------------------
-- TEST ADVANCED LOGGING MODULE
-------------------------------------------------
-- Log your events, use log instead of print
log:log("Advanced logging module is now ready")
local variable = nil
log:log("Variable", variable)
-- Here we make an intentional error to test error reporting
asd = asd .. "asd"
```

##Properties and defaults##

You can easily change any of log table / object properties. List of currenly used properties:

```lua
-- Prefix for log files
log.fileNamePrefix = "log"
-- Directory where to save log files
log.directory = system.DocumentsDirectory
-- Maximum number of log files
log.numberOfRollingFiles = 6
-- Set to true if you want to trace module name and line number on each info message
log.debugCalls = true
-- Maximum depth for caller traceing
log.debugCallDepth = 4
-- Maximum log file size in Bytes
log.maxFileSizeInBytes = 20480
-- Database table name where to save log parameters
log.tableName = "log_params"
-- Set to true if you want an alert to popup on runtime errors
log.alertErrors = true
-- Title for runtime errors alert
log.alertTitle = "Oops, an error occurred"
-- Text for runtime errors alert
log.alertText = "Please report this error to administrator on email:\n\n"
-- 1st button for runtime errors alert label
log.alertButtonReport = "Report on email"
-- 2nd button for runtime errors alert label
log.alertButtonDismiss = "Dismiss"
-- Email adress on which to send error reports
log.alertEmail = ""
-- Erorr report email subject
log.emailSubject = "Error report"
-- Erorr report email text before device / platform into
log.emailPreText = "Hi\n\nI want to report an error in application. " ..
				   "Logs files are attached. Here is my device info: \n"
-- Erorr report email text after device / platform into
log.emailPostText = "\n\n Thank you."
-- Separator for multiple log messages, use \n to log each message separately
log.separator = ", "
```

##Log file contents##

Here is an example of log file contents.

![alt tag](https://raw.githubusercontent.com/promptcode/CoronaAdvancedLogging/master/Images/ss0.png)

##Error reporting##

Runtime errors get automaticly logged and user gets prompt to report error to administrator via email.

![alt tag](https://raw.githubusercontent.com/promptcode/CoronaAdvancedLogging/master/Images/ss1.png)

Administrator receives an email containing device / platform info and log files.

![alt tag](https://raw.githubusercontent.com/promptcode/CoronaAdvancedLogging/master/Images/ss2.png)

And thats it. Feel free to contact me with your suggestions (see email adress in image above).