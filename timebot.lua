--[[

TimeBot program
By Out-Feu

version 0.0.1

Free to distribute/alter
so long as proper credit to original
author is maintained.

Simply connect a chat box in any way and start this program

--]]

function getCurrentText()
 if last_time ~= nil and time.hour ~= last_time.hour then
  if time.hour == 1 then
   return "Il est 1H, pensez à aller dormir"
  elseif time.hour == 6 then
   return "Il est 6H, qu'est-ce que tu fait de connecté à cette heure ?"
  elseif time.hour == 8 then
   return "Hello, World! Il est 8H"
  elseif time.hour == 11 then
   return "Il est 11H, le serveur redémarrera dans une heure, profitez en pour aller manger"
  elseif time.hour == 13 then
   return "Il est 13H, vous avez bien mangé ?"
  elseif time.hour == 16 then
   return "Il est 16H, l'heure du goûter"
  elseif time.hour == 23 then
   return "Il est 23H, le serveur redémmarrera dans une heure, une bonne occasion pour aller dormir"
  elseif not easterEgg or time.hour > 5 then
   return "Tic, toc, il est " .. time.hour .. "H"
  end
 elseif time.hour == 11 or time.hour == 23 then
  if time.min == 0 then
   return "Redémarrage dans 1 heure"
  elseif time.min == 30 then
   return "Redémarrage dans 30 minutes"
  elseif time.min == 45 then
   return "Redémarrage dans 15 minutes"
  elseif time.min == 55 then
   return "Redémarrage dans 5 minutes"
  elseif time.min == 59 then
   return "Redémarrage dans 1 minute, pensez à vous mettre dans un endroit sûr"
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

function sendText(text)
 chat.sendMessage(text, name)
end

-------------------------------------------------------------------------------

per = peripheral.getNames()
for k, v in pairs(per) do
 if peripheral.getType(v) == "chatBox" then
  chat = peripheral.wrap(v)
 end
end
per = nil

name = "TimeBot"
easterEgg = true
last_time = nil
time = nil

--------------------------------------------------------------------------------
time = os.date("*t", os.epoch("local") / 1000)
os.startTimer(60 - time.sec)
repeat --main loop
 os.pullEvent("timer")
 time = os.date("*t", os.epoch("local") / 1000)
 local text = getCurrentText()
 if text ~= nil then
  sendText(text)
 end
 os.startTimer(60 - time.sec)
 last_time = time
until false
