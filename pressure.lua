--[[
Pressure program
By Out-Feu
version 0.0.1
Free to distribute/alter
so long as proper credit to original
author is maintained.
Simply connect a pressured block in any way and start this program
--]]


function hasMethod(side, method)
 for i, name in pairs(peripheral.getMethods(side)) do
  if name == method then
   return true
  end
 end
 return false
end

function setRedstoneSignal(signal)
 if (restoneSide == nil or restoneSide == "all" or redstoneSide == "") then
  sides = redstone.getSides()
  for k, side in pairs(sides) do
   redstone.setOutput(side, signal)
  end
 else
  redstone.setOutput(redstoneSide, signal)
 end
end

-------------------------------------------------------------------------------

per = peripheral.getNames()
for k, side in pairs(per) do
 if hasMethod(side, "getPressure") and (pressure == nil or pressure.getDangerPressure() > peripheral.wrap(side).getDangerPressure()) then
  pressure = peripheral.wrap(side)
 end
end
per = nil

if pressure == nil then
 printError("No pressured block found")
 return
else
 print("Danger pressure: " .. pressure.getDangerPressure() .. " bar")
end

dangerTimer = 10 -- How often the program must check the pressure when pressure > dangerPressure (in seconds)
pressureTimer = 1 -- How often the program must check the pressure when pressure < dangerPressure (in seconds)
pressureMargin = 0.5 -- Margin before reaching the danger pressure at which the computer must emit a redstone signal
dangerPressure = pressure.getDangerPressure() - pressureMargin -- Pressure at which the computer emit a redstone signal
inverted = false -- If true, emit redstone signal while pressure < dangerPressure
restoneSide = "all" -- Side on which the redstone signal is emitted ('all' to emit on all sides)

--------------------------------------------------------------------------------

os.startTimer(0)
repeat --main loop
 os.pullEvent("timer")
 if pressure.getPressure() < dangerPressure then
	setRedstoneSignal(inverted)
	os.startTimer(pressureTimer)
 else
	setRedstoneSignal(not inverted)
	os.startTimer(dangerTimer)
 end
until false
