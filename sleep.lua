--[[

SleepBot program
By Out-Feu

version 0.0.1

Free to distribute/alter
so long as proper credit to original
author is maintained.

This program must be used on a chatty turtle.
The turtle must be placed in front of a ritual brazier.
The ritual brazier must be right clicked when the turtle emit a redstone signal.
Tablets of sunrise and tablets of moonfall must be placed inside the turtle inventory.

--]]

string.split = function(self)
 local tab = {}
 for str in self:gmatch("([^%s]+)") do
  table.insert(tab, str)
 end
 return tab
end

function setDay()
 if useItem("ars_nouveau:ritual_sunrise") then
  sendText("Le jour arrive dans quelques secondes")
  sleep(15)
 else
  sendText("Je suis à court d'item pour mettre le jour")
 end
end

function setNight()
 if useItem("ars_nouveau:ritual_moonfall") then
  sendText("La nuit arrive dans quelques secondes")
  sleep(15)
 else
  sendText("Je suis à court d'item pour mettre la nuit")
 end
end

function useItem(item)
 local slot = getItemSlot(item)
 if slot == nil then
  return false
 end
 turtle.select(slot)
 turtle.place()
 setRedstoneSignal(true)
 sleep(1)
 setRedstoneSignal(false)
 return true
end

function getItemSlot(item)
 for slot = 1, 16 do
  data =  turtle.getItemDetail(slot)
  if data and data.name == item then
   return slot
  end
 end
 return nil
end

function setRedstoneSignal(signal)
 sides = redstone.getSides()
 for k, side in pairs(sides) do
  redstone.setOutput(side, signal)
 end
end

function showHelp()
 local help = "Utilisation: " .. cmdPrefix .. " [option]\n"
 help = help .. "Options:\n"
 help = help .. "'day' - Met le jour\n"
 help = help .. "'night' - Met la nuit\n"
 help = help .. "'help' - Affiche cette aide"
 sendText(help)
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

if chat == nil then
 term.setTextColor(colors.red)
 print("Chat box not found")
 term.setTextColor(colors.white)
 return
end

name = "SleepBot" -- Name displayed in chat
cmdPrefix = "!sleep" -- Prefix for the commands

--------------------------------------------------------------------------------
repeat --main loop
 local event, player, message = os.pullEvent("chat")
 args = message:split()
 if table.getn(args) > 1 and args[1] == cmdPrefix then
  if args[2] == "help" then
   showHelp()
  elseif args[2] == "day" then
   setDay()
  elseif args[2] == "night" then
   setNight()
  else
   sendText("Option invalide, '".. cmdPrefix .." help' pour plus d'informations.")
  end
 end
until false
