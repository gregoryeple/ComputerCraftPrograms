--[[

AR Glasses program
By Out-Feu

version 0.0.1

Free to distribute/alter
so long as proper credit to original
author is maintained.

Simply connect a chat box in any way and start this program

--]]

-------------------------------------------------------------------------------

per = peripheral.getNames()
for k, v in pairs(per) do
 if peripheral.getType(v) == "arController" then
  ar = peripheral.wrap(v)
 elseif peripheral.getType(v) == "environmentDetector" then
  env = peripheral.wrap(v)
 end
end
per = nil

screenWidth = 1600
screenHeight = 900
textHeight = 10
textWidth = 5
width = screenWidth / 3
height = screenHeight / 3

--------------------------------------------------------------------------------

ar.clear()
ar.setRelativeMode(true, screenWidth, screenHeight)
repeat --main loop
 os.startTimer(1)
 os.pullEvent("timer")
 local time = os.time()
 local day
 if time < 5.5 or time > 18.5 then
  day = "Night "
 elseif time < 6.5 then
  day = "Dawn "
 elseif time > 18 then
  day = "Dusk "
 else
  day = "Day "
 end
 if env == nil then
  weatherItem = "minecraft:clock"
  weatherString = "Weather unavailable"
 elseif env.isRaining() then
  weatherItem = "minecraft:water_bucket"
  weatherString = "Rain"
 elseif env.isThunder() then
  weatherItem = "minecraft:lightning_rod"
  weatherString = "Thunderstorm"
 elseif time < 6 or time > 18.5 then
  weatherItem = "minecraft:snowball"
  weatherString = "Clear sky"
 -- weatherString = env.getMoonName()
 else
  weatherItem = "minecraft:sunflower"
  weatherString = "Clear sky"
 end
 ar.drawItemIconWithId("weatherItem", weatherItem, width - textWidth * 3, height - textHeight * 1.25)
 ar.drawRightboundStringWithId("weatherString", weatherString, width - textWidth * 3, height - textHeight, 0xffffff)
 ar.drawRightboundStringWithId("day",  day .. tostring(os.day()), width - textWidth, height - textHeight * 2, 0xffffff)
 ar.drawRightboundStringWithId("time", textutils.formatTime(time, true), width - textWidth, height - textHeight * 3, 0xffffff)
until false
