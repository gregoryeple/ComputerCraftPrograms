--[[

WeatherBot program
By Out-Feu

version 1.0.0

Free to distribute/alter
so long as proper credit to original
author is maintained.

This program must be used on a chatty turtle.

The turtle will place an item in the inventory in front of it.
This item must be used on a Teru Teru Bozu when the turtle emit a redstone signal.
Sunflowers and blue orchids must be placed inside the turtle inventory.

--]]

string.split = function(self)
 local tab = {}
 for str in self:gmatch("([^%s]+)") do
  table.insert(tab, str)
 end
 return tab
end

function isRainning()
 if env == nil then
  return nil
 end
 return env.isRaining() or env.isThunder()
end

function setClear()
 if isRainning() == false then
  sendText("Il ne pleut pas")
 elseif useItem("minecraft:sunflower") then
  sendText("La pluie va s'en aller")
 else
  sendText("Je suis à court de 'Sunflower' pour retirer la pluie")
 end
end

function setRain()
 if isRainning() == true then
  sendText("Il pleut déjà")
 else
  repeat
   if not useItem("minecraft:blue_orchid") then
    sendText("Je suis à court de 'Blue Orchid' pour mettre la pluie")
    return
   end
  until env == nil or isRainning() == true
  if env == nil then
   sendText("La pluie arrive peut-être (10% de chance)")
  else
   sendText("La pluie arrive")
  end
 end
end

function useItem(item)
 local slot = getItemSlot(item)
 if slot == nil then
  return false
 end
 turtle.select(slot)
 turtle.drop(1)
 setRedstoneSignal(true)
 sleep(1)
 setRedstoneSignal(false)
 sleep(1)
 return true
end

function getItemSlot(item)
 for slot = 1, 16 do
  data = turtle.getItemDetail(slot)
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

function isWhitelisted(player)
 for _, wlplayer in pairs(whitelist) do
  if wlplayer == player then
   return true
  end
 end
 return false 
end

function showWhitelist()
 if whitelist == nil or next(whitelist) == nil then
  sendText("La whitelist est vide.")
  return
 end
 list = "Whitelist:"
 for _, wlplayer in  pairs(whitelist) do
  list = list .. "\n - " .. wlplayer
 end
 sendText(list)
end

function showHelp(showItem)
 local help = "Utilisation: " .. cmdPrefix .. " [option]\n"
 help = help .. "Options:\n"
 if not showItem then
  help = help .. "'clear' - Retire la pluie\n"
  if env == nil then
   help = help .. "'rain' - 10% de chance de mettre la pluie\n"
  else
   help = help .. "'rain' - Met la pluie\n"
  end
 else
  help = help .. "'clear' - Utilise 1 'Sunflower'\n"
  if env == nil then
   help = help .. "'rain' - Utilise 1 'Blue Orchid'\n"
  else
   help = help .. "'rain' - Utilise en moyenne 10 'Blue Orchid'\n"
  end
 end
 if not showItem then
  if enableWhitelist then
   help = help .. "'whitelist' - Affiche les joueurs pouvant utilser la commande '" .. cmdPrefix .. "'\n"
  end
  help = help .. "'help' - Affiche cette aide\n"
  help = help .. "'help item' - Affiche les ressources utilisées par les commandes"
 else
  help = help:sub(1, -2)
 end
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
 elseif peripheral.getType(v) == "environmentDetector" then
  env = peripheral.wrap(v) 
 end
end
per = nil

if chat == nil then
 term.setTextColor(colors.red)
 print("Chat box not found")
 term.setTextColor(colors.white)
 return
end

name = "WeatherBot" -- Name displayed in chat
cmdPrefix = "!weather" -- Prefix for the commands
whitelist = {} -- Players who can use the command
enableWhitelist = false -- Restic the command to whitelisted players

--------------------------------------------------------------------------------
print("Hello, I am " .. name .. "!")
print("'" .. cmdPrefix .. " help' for more informations.")

repeat --main loop
 local event, player, message = os.pullEvent("chat")
 args = message:split()
 if table.getn(args) > 1 and args[1] == cmdPrefix then
  if enableWhitelist and not isWhitelisted(player) then
   sendText("Le joueur '" .. player .. "' n'a pas le droit d'utiliser la commande '" .. cmdPrefix .. "'.")
  elseif args[2] == "help" then
   showHelp(table.getn(args) > 2 and args[3] == "item")
  elseif args[2] == "whitelist" then
   showWhitelist()
  elseif args[2] == "clear" then
   setClear()
  elseif args[2] == "rain" then
   setRain()
  else
   sendText("Option invalide, '".. cmdPrefix .." help' pour plus d'informations.")
  end
 end
until false
