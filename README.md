CoronaAdvancedLogging
=====================

Used for error handleing and logging events to console and a set of rolling text log files.

Module setup and logging events:

```sh
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

![alt tag](https://raw.github.com/username/projectname/branch/path/to/img.png)