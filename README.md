CoronaAdvancedLogging
=====================

Used for error handleing and logging events to console and a set of rolling text log files.

Module setup and logging events:

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
log:set(db, "danstrmecki@gmail.com")

-------------------------------------------------
-- TEST ADVANCED LOGGING MODULE
-------------------------------------------------
-- Simple logging, instead of print
log:log("Advanced logging module is now ready")
-- Here we make an intentional error to test Advanced logging module
asd = asd .. "asd"
```

How logging works (module name and line number are only avaliable in simulator):

![alt tag](https://raw.githubusercontent.com/promptcode/CoronaAdvancedLogging/master/Images/ss0.png)

How error reporting works:

Errors are automaticly logged and user gets prompt to report error to administrator.

![alt tag](https://raw.githubusercontent.com/promptcode/CoronaAdvancedLogging/master/Images/ss1.png)

Administrator will recieve an email containing log files.

![alt tag](https://raw.githubusercontent.com/promptcode/CoronaAdvancedLogging/master/Images/ss2.png)