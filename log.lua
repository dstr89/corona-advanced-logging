-------------------------------------------------
-- CORONA SDK - ADVANCED LOGGING MODULE
-- Version: 1.0.0
-- Used for error handleing and logging events to console and a set of rolling text log files
--
-- Revised BSD License:
--
-- Copyright (c) 2014, Daniel Strmečki <email: daniel.strmecki@gmail.com, web: promptcode.com>
-- All rights reserved.

-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--   * Redistributions of source code must retain the above copyright
--     notice, this list of conditions and the following disclaimer.
--   * Redistributions in binary form must reproduce the above copyright
--     notice, this list of conditions and the following disclaimer in the
--     documentation and/or other materials provided with the distribution.
--   * Neither the name of the <organization> nor the
--     names of its contributors may be used to endorse or promote products
--     derived from this software without specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-------------------------------------------------

local log = {}
local lfs = require ("lfs")

-------------------------------------------------
-- STATIC PROPERTIES
-------------------------------------------------

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

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------

-- Write log messages in file 
local function logInFile(message, level, callerInfo, stackTrace )
	-- Get last used log file index from database
	if (log.currentFileIndex == nil) then
		-- Check if referece to DB object is set
		if (log.db == nil) then
			print("ADVANCED LOGGING MODULE - internal error - no referece to database set")
			return;
		end

		-- Create table if it does not exist
		local q1 = [[CREATE TABLE IF NOT EXISTS ]] .. log.tableName .. [[ (id INTEGER PRIMARY KEY autoincrement, name, value);]]
		log.db:exec(q1)

		-- Insert default value if no values are present, else get value from database
		local value = nil
		for row in db:nrows("SELECT * FROM " .. log.tableName .. " WHERE name = 'lastFileIndex'") do
			value = row.value
		end
		if (value == nil) then
			local q2 = [[INSERT INTO ]] .. log.tableName  .. [[ VALUES (NULL, 'lastFileIndex', '1');]]
			log.db:exec(q2)
			log.currentFileIndex = 1
		else
			log.currentFileIndex = value
		end
	end

	local fileName = log.fileNamePrefix .. "_" .. log.currentFileIndex .. ".txt"
	local path = system.pathForFile( fileName, log.directory )
	local size = lfs.attributes (path, "size") -- file size in bytes

	--Swich to next rolling file
	if (size ~= nil and size > log.maxFileSizeInBytes) then
		log.currentFileIndex = log.currentFileIndex + 1
		if (log.currentFileIndex > log.numberOfRollingFiles) then
			log.currentFileIndex = 1
		end
		-- Save last used log file index in database
		local q3 = [[UPDATE ]] .. log.tableName  .. [[ SET value = ']] .. log.currentFileIndex .. [[' WHERE name = 'lastFileIndex';]]
		log.db:exec(q3)

		fileName = log.fileNamePrefix .. "_" .. log.currentFileIndex .. ".txt"
		path = system.pathForFile( fileName, log.directory )
		os.remove( path )
	end

	local now = os.date( "%d.%m.%Y. %H:%M:%S" )
	local file = io.open( path, "a" )
	local text = now .. " - " .. level .. " - " .. message
	if (callerInfo ~= nil and callerInfo ~= "") then
		text = text .. "\n\t" .. callerInfo
	end
	if (stackTrace ~= nil and stackTrace ~= "") then
		text = text .. stackTrace 
	end
	file:write( text .. "\n" )

	io.close( file )
	file = nil
end

-- Check if file exits
local function fileExists(fileName, base)
	  local base = base or system.DocumentsDirectory
	  local filePath = system.pathForFile( fileName, base )
	  local exists = false

	  if (filePath) then 
		    local fileHandle = io.open( filePath, "r" )
		    if (fileHandle) then -- nil if no file found
		      	exists = true
		      	io.close(fileHandle)
		    end
	  end
	 
	  return exists
end

-- Handler that gets notified when the alert closes
local function onAlertComplete( event )
    if "clicked" == event.action then
        local i = event.index
        if 1 == i then
            -- Get device info
            local deviceInfo = 	"Platform: " .. system.getInfo("platformName") .. " " .. system.getInfo("platformVersion") .. 
            					", Device: " .. system.getInfo("name") .. " - " .. system.getInfo("model") .. 
            					", Arhitecure: " .. system.getInfo("architectureInfo")
            
            local prevLogIndex = log.currentFileIndex - 1
			if (prevLogIndex < 1) then
				prevLogIndex = log.numberOfRollingFiles
			end
			local fileName1 = log.fileNamePrefix .. "_" .. log.currentFileIndex .. ".txt"
			local fileName2 = log.fileNamePrefix .. "_" .. prevLogIndex .. ".txt"

			-- Add log files as attachments
			local attachments = nil;
			if (fileExists(fileName2, log.directory)) then
				attachments = {
							      { baseDir=log.directory, filename=fileName1, type="text/plain" },
							      { baseDir=log.directory, filename=fileName2, type="text/plain" },
							  }
			else
				attachments = {
							      { baseDir=log.directory, filename=fileName1, type="text/plain" },
							  }
			end

			-- Send email to administrator
            local options =
				{
				   to = { log.alertEmail },
				   subject = log.emailSubject .. " - " .. system.getInfo("appName"),
				   isBodyHtml = false,
				   body = log.emailPreText .. deviceInfo .. log.emailPostText,
				   attachment = attachments,
				}
			native.showPopup("mail", options)
        end
    end
end

-- Unhandled errors listener
local function unhandledErrorListener( event )
	-- Log in file
	logInFile(event.errorMessage, "ERROR", nil, event.stackTrace)

    -- Show alert
	if (log.alertErrors == true) then
    	native.showAlert( log.alertTitle, log.alertText .. event.errorMessage, { log.alertButtonReport, log.alertButtonDismiss}, onAlertComplete)
    end

    return true
end

-- Get first index of char in string
local function strIndexOf(s1, s2)
    return string.find(s1, s2)
end

-- Get last index of char in string
local function strLastIndexOf(haystack, needle)
    --Set the third arg to false to allow pattern matching
    local found = haystack:reverse():find(needle:reverse(), nil, true)
    if found then
        return haystack:len() - needle:len() - found + 2 
    else
        return found
    end
end

-- Substring
local function strSubstring(s, from, to)
    return string.sub(s, from, to) 
end

-- Length
local function strLength(s)
    return string.len(s)
end
	
-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

-- Setter for log properties
-- db is the only required parameter
function log:set(db, alertEmail, alertErrors, fileNamePrefix, directory, numberOfRollingFiles, debugCalls, debugCallDepth, maxFileSizeInBytes)
	log.db = db or nil
	log.alertEmail = alertEmail or ""
	log.alertErrors = alertErrors or true
	log.fileNamePrefix = fileNamePrefix or "log"
	log.directory = directory or system.DocumentsDirectory
	log.numberOfRollingFiles = numberOfRollingFiles or 4
	log.debugCalls = debugCalls or true
	log.debugCallDepth = debugCallDepth or 3
	log.maxFileSizeInBytes = maxFileSizeInBytes or 5120
	print("Mail:" .. log.alertEmail)
end

-- Log info messages
function log:log(message)
	local callerInfo = ""
	if (log.debugCalls == true and system.getInfo("environment") == "simulator") then -- This only works in simulator
		-- Get function and line number that called this function
		for i = 2, self.debugCallDepth + 1, 1 do 
			local debugInfo = debug.getinfo(i)
			--table.foreach (debugInfo, print)

			if (debugInfo == nil or (debugInfo.name == nil and debugInfo.source == nil)) then
				break
			else
				-- If name is not set then get the name from source attribute
				if (debugInfo.name == nil) then
					local name = debugInfo.source
					local index = strLastIndexOf(name, "\\")
					if (index == nil or index == -1) then
						break
					else
						name = strSubstring(name, index + 1, strLength(name))
					end
					debugInfo.name = name
				end

				if (callerInfo ~= "") then
					callerInfo = callerInfo .. " -> "
				end
				-- Get line number
				callerInfo = callerInfo .. debugInfo.name
				if (debugInfo.currentline ~= nil) then
					callerInfo = callerInfo .. " (line " .. debugInfo.currentline .. ")"
				end
			end
		end
	end
	-- Log in file
	logInFile(message, "INFO", callerInfo, nil)
	
	-- Log in console
	print(message)
end

-- Attach event listener to catch and log errors
Runtime:addEventListener("unhandledError", unhandledErrorListener)

return log