--[[

SpyBot program
By Out-Feu

version 1.0.2

Free to distribute/alter
so long as proper credit to original
author is maintained.

Simply connect a player detector in any way and start this program

--]]

string.splitLine = function(self)
 local tab = {}
 for str in self:gmatch("([^\n]*)\n?") do
  table.insert(tab, str)
 end
 return tab
end

table.find = function(self, search)
 for index, value in ipairs(self) do
  if value == search then
   return index
  end
 end
 return nil
end

function updateTempFile()
 if tempFile == '' then
  return
 end
 if next(players) == nil then
  fs.delete(tempFile)
 else
  file = fs.open(tempFile, "w")
  for index, value in ipairs(players) do
   file.writeLine(value)
  end
  file.close()
 end
end

function getLogText(join, player)
 local logTime = os.date("%x %X", os.epoch("local") / 1000)
 local logText
 if join then
  logText = "[" .. logTime .. "] " .. player .. " joined"
 else
  logText = "[" .. logTime .. "] " .. player .. " left"
 end
 return logText
end

function updatePlayerFile(join, player)
 if player == '' then
  return
 end
 local file
 if singleFile then
  file = fs.open(playerFile, "a")
 else
  file = fs.open(playerFile .. "/" .. player .. ".txt" , "a")
 end
 local logText = getLogText(join, player)
 file.writeLine(logText)
 print(logText)
 file.close()
end

function updatePlayerList(addPlayer, player)
 local index = table.find(players, player)
 updatePlayerFile(addPlayer, player)
 if addPlayer and index == nil then
  table.insert(players, player)
  updateTempFile()
 elseif not addPlayer and index ~= nil then
  table.remove(players, index)
  updateTempFile()
 end
end

function initPlayers()
 local onlinePlayers = detector.getOnlinePlayers()
 for index, value in ipairs(onlinePlayers) do
  updatePlayerList(true, value)
 end
end

function removeTempPlayers()
 if not fs.exists(tempFile) then
  return
 end
 local file = fs.open(tempFile, "r")
 local fileContent = file.readAll()
 local tempPlayers = fileContent:splitLine()
 for index, value in ipairs(tempPlayers) do
  updatePlayerFile(false, value)
 end
 file.close()
 updateTempFile()
end

per = peripheral.getNames()
for k, v in pairs(per) do
 if peripheral.getType(v) == "playerDetector" then
  detector = peripheral.wrap(v)
 end
end
per = nil

singleFile = false -- Store the data inside a single file instead of using a file for each player
playerFile = "players" -- Name of the file or directory in which the data in stored
tempFile = "currentPlayers.txt" -- Name of the file in which are stored the names of the currently connected players

--------------------------------------------------------------------------------

if detector == nil then
 printError("Player detector not found")
 return
end

players = {}

removeTempPlayers()
initPlayers()

repeat --main loop

 -- Wait for a player to join or leave
 local event, user, dim
 repeat
  event, player, dim = os.pullEvent()
 until event == "playerJoin" or event == "playerLeave"

 if event == "playerJoin" then
  updatePlayerList(true, player)
 elseif event == "playerLeave" then
  updatePlayerList(false, player)
 end

until false
