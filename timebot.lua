--[[

TimeBot program
By Out-Feu

version 1.1.0

Free to distribute/alter
so long as proper credit to original
author is maintained.

Simply connect a chat box in any way and start this program
You can also connect monitors to display the current time

--]]

function getCurrentText()
 if isRebootTime(time.hour) then
  if time.min == 0 then
   return "Il est " .. time.hour .. "H, le serveur redémarrera dans 1 heure, profitez en pour faire une pause"
  elseif time.min == 30 then
   return "Redémarrage dans 30 minutes"
  elseif time.min == 45 then
   return "Redémarrage dans 15 minutes"
  elseif time.min == 55 then
   return "Redémarrage dans 5 minutes"
  elseif time.min == 59 then
   return "Redémarrage dans 1 minute, pensez à vous mettre dans un endroit sûr"
  end
 elseif last_time ~= nil and time.hour ~= last_time.hour then
  if customHours[time.hour] ~= nil then
   return customHours[time.hour]
  elseif not easterEgg or time.hour > 5 then
   return "Tic, toc, il est " .. time.hour .. "H"
  end
 elseif easterEgg then
  if time.hour == 2 and time.min == 22 then
   chat.sendMessage("Hello ?", "*")
  elseif time.hour == 3 and time.min == 33 then
    chat.sendMessage("BEHIND YOU", "Herobrine")
  elseif time.hour == 4 and time.min == 44 then
   chat.sendMessage("I CAN SEE YOU", "???")
  end
 end
 return nil
end

function isRebootTime(hour)
 hour = (hour + 1) % 24
 for k, v in pairs(reboots) do
  if hour == v then
   return true
  end
 end
 return false
end

function changeResolution()
 for k, v in pairs(monitors) do
  v.setTextScale(1) -- set resolution back to initial value
  local w, h = v.getSize()
  v.setTextScale(0.5 * math.min(math.floor((w / 5 / 0.5) + 0.5), math.floor((h / 0.5) + 0.5), 10))
 end
end

function displayTime()
 if table.getn(monitors) == 0 then
  return
 end
 local text = ""
 if time.hour < 10 then
  text = "0" .. time.hour
 else
  text = "" .. time.hour
 end
 if time.min < 10 then
  text = text .. ":0" .. time.min
 else
  text = text .. ":" .. time.min
 end
 for k,v in pairs(monitors) do
  local w, h = v.getSize()
  v.setTextColor(colors.white)
  v.setBackgroundColor(colors.black)
  v.clear()
  v.setCursorPos(w / 2 - string.len(text) / 2 + 1, h / 2 + 1)
  v.write(text)
 end
end

function sendText(text)
 chat.sendMessage(text, name)
end

-------------------------------------------------------------------------------

customHours = {} -- Custom messages to display for some hours
customHours[0] = "Il est 0H, le bon moment pour penser à aller dormir"
customHours[1] = "Il est 1H, passez une bonne nuit"
customHours[6] = "Il est 6H, qu'est-ce que tu fait de connecté à cette heure ?"
customHours[8] = "Hello, World! Il est 8H"
customHours[11] = "Il est 11H, c'est bientôt l'heure d'aller manger"
customHours[13] = "Il est 13H, vous avez bien mangé ?"
customHours[16] = "Il est 16H, l'heure du goûter"
customHours[18] = "Il est 18H, c'est l'heure de l'apéro !"

monitors = {}
per = peripheral.getNames()
for k, v in pairs(per) do
 if peripheral.getType(v) == "chatBox" then
  chat = peripheral.wrap(v)
 elseif peripheral.getType(v) == "monitor" then
  table.insert(monitors, peripheral.wrap(v))
 end
end
per = nil

if chat == nil then
 term.setTextColor(colors.red)
 print("Chat box not found")
 term.setTextColor(colors.white)
else
 print("Chat box found")
end
print(table.getn(monitors) .. " monitor(s) found")

name = "TimeBot" -- Name displayed in chat
reboots = {0, 12} -- Hours at which the server reboot
easterEgg = false -- Disable TimeBot at night to display special messages instead

last_time = nil
time = nil

--------------------------------------------------------------------------------
changeResolution()
time = os.date("*t", os.epoch("local") / 1000)
displayTime()
os.startTimer(60 - time.sec)
repeat --main loop
 os.pullEvent("timer")
 time = os.date("*t", os.epoch("local") / 1000)
 displayTime()
 if chat ~= nil then
  local text = getCurrentText()
  if text ~= nil then
   sendText(text)
  end
 end
 os.startTimer(60 - time.sec)
 last_time = time
until false
