Corona Advanced Logging
=====================

##Usage##

Used for error handling and logging events to console and a set of rolling text log files.
* Use it instead of print in your Corona project
* Your messages will be printed in console but also logged in text files 
* A set of rolling text files is used so you can retrace the steps that lead to a bug
* Runtime errors get logged automatically
* User gets prompt on runtime error and can report it via email
* Administrator receives device / platform info and log files in attachment


##Sample##

Check out the sample Corona project in this repository. Quick preview:

```lua
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

-- Simple logging, use it instead of print
log:log("Advanced logging module is now ready")

-- Here we make an intentional error to test error reporting
asd = asd .. "asd"

```

##Properties and default##

You can easily change any of log table / object properties. List of currenly used properties:

```lua
log.fileNamePrefix = "log"
log.directory = system.DocumentsDirectory
log.numberOfRollingFiles = 6
log.currentFileIndex = nil
log.debugCalls = true
log.debugCallDepth = 4
log.maxFileSizeInBytes = 20480
log.tableName = "log_params"
log.db = nil
log.alertErrors = true
log.alertTitle = "Oops, an error occurred"
log.alertText = "Please report this error to administrator on email:\n\n"
log.alertButtonReport = "Report on email"
log.alertButtonDismiss = "Dismiss"
log.alertEmail = ""
log.emailSubject = "Error report"
log.emailPreText = "Hi\n\nI want to report an error in application. Logs files are attached. Here is my device info: \n"
log.emailPostText = "\n\n Thank you."
```

##Log file contents## 

Note that the module / Lua script name and line number are only available in simulator.

![alt tag](https://raw.githubusercontent.com/promptcode/CoronaAdvancedLogging/master/Images/ss0.png)

##Error reporting##

Runtime errors get automaticly logged and user gets prompt to report error to administrator via email.

![alt tag](https://raw.githubusercontent.com/promptcode/CoronaAdvancedLogging/master/Images/ss1.png)

Administrator receives an email containing device / platform info and log files.

![alt tag](https://raw.githubusercontent.com/promptcode/CoronaAdvancedLogging/master/Images/ss2.png)