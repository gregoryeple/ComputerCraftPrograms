--[[

SleepBot program
By Out-Feu

version 2.2.0

Free to distribute/alter
so long as proper credit to original
author is maintained.

This program must be used on a chatty turtle.

The turtle must be placed in front of a ritual brazier.
The ritual brazier must be right clicked when the turtle emit a redstone signal.
Tablets of sunrise and tablets of moonfall must be placed inside the turtle inventory.

A Teru Teru Bozu can be placed on top of the turtle to change the weather.
In that case, sunflowers and blue orchids must be placed inside the turtle inventory.

--]]

string.split = function(self)
 local tab = {}
 for str in self:gmatch("([^%s]+)") do
  table.insert(tab, str)
 end
 return tab
end

function canChangeTime()
 local success, data = turtle.inspect()
 return success and data.name == "ars_nouveau:ritual_brazier"
end

function isRainning()
 if env == nil then
  return nil
 end
 return env.isRaining() or env.isThunder()
end

function canChangeWeather()
 local success, data = turtle.inspectUp()
 return success and data.name == "botania:teru_teru_bozu"
end

function setDay()
 if useItem("ars_nouveau:ritual_sunrise") then
  sendText("Le jour arrive dans quelques secondes")
  sleep(15)
 else
  sendText("Je suis à court de 'Tablet of Sunrise' pour mettre le jour")
 end
end

function setNight()
 if useItem("ars_nouveau:ritual_moonfall") then
  sendText("La nuit arrive dans quelques secondes")
  sleep(15)
 else
  sendText("Je suis à court de 'Tablet of Moonfall' pour mettre la nuit")
 end
end

function setClearWeather()
 if isRainning() == false then
  sendText("Il ne pleut pas")
 elseif useItem("ars_nouveau:ritual_cloudshaping") then
  sendText("La pluie va s'en aller")
  sleep(15)
 else
  sendText("Je suis à court de 'Tablet of Cloudshaping' pour retirer la pluie")
 end
end

function setClear()
 if isRainning() == false then
  sendText("Il ne pleut pas")
 elseif useItemUp("minecraft:sunflower") then
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
   if not useItemUp("minecraft:blue_orchid") then
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
 turtle.place()
 setRedstoneSignal(true)
 sleep(1)
 setRedstoneSignal(false)
 return true
end

function useItemUp(item)
 local slot = getItemSlot(item)
 if slot == null then
  return false
 end
 turtle.select(slot)
 turtle.placeUp()
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
 if canChangeTime() then
  if not showItem then
   help = help .. "'day' - Met le jour\n"
   help = help .. "'night' - Met la nuit\n"
   help = help .. "'clear' - Retire la pluie\n"
  else
   help = help .. "'day' - Utilise 1 'Tablet of Sunrise'\n"
   help = help .. "'night' - Utilise 1 'Tablet of Moonfall'\n"
   help = help .. "'clear' - Utilise 1 'Tablet of Cloudshaping'\n"
  end
 end
 if canChangeWeather() then
  if not showItem then
   help = help .. "'weather clear' - Retire la pluie\n"
   if env == nil then
    help = help .. "'weather rain' - 10% de chance de mettre la pluie\n"
   else
    help = help .. "'weather rain' - Met la pluie\n"
   end
  else
   help = help .. "'weather clear' - Utilise 1 'Sunflower'\n"
   if env == nil then
    help = help .. "'weather rain' - Utilise 1 'Blue Orchid'\n"
   else
    help = help .. "'weather rain' - Utilise en moyenne 10 'Blue Orchid'\n"
   end
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

name = "SleepBot" -- Name displayed in chat
cmdPrefix = "!sleep" -- Prefix for the commands
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
  elseif canChangeTime() and args[2] == "day" then
   setDay()
  elseif canChangeTime() and args[2] == "night" then
   setNight()
  elseif canChangeTime() and args[2] == "clear" then
   setClearWeather()
  elseif canChangeWeather() and table.getn(args) > 2 and args[2] == "weather" and args[3] == "clear" then
   setClear()
  elseif canChangeWeather() and table.getn(args) > 2 and args[2] == "weather" and args[3] == "rain" then
   setRain()
  else
   sendText("Option invalide, '".. cmdPrefix .." help' pour plus d'informations.")
  end
 end
until false
