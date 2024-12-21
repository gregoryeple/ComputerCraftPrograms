--[[

PeripheralDetector program
By Out-Feu

version 1.0.0

Free to distribute/alter
so long as proper credit to original
author is maintained.

This program will display the available methods of all the connected peripherals.
A side can be provided when launching the program to only display the methods of the associated peripheral.

--]]

function printPeripheral(side)
 local per = peripheral.getType(side)
 print(side .. ": " .. per)
 if displayMethods then
  printMethods(side)
 end
end

function printMethods(side)
 local methods = peripheral.getMethods(side)
 for i, method in pairs(methods) do
  print(" " .. i .. " - " .. method)
 end
end

displayMethods = true -- Should all peripherals' methods be printed
sides = {...}

if sides == nil or next(sides) == nil then
 local foundPeripheral = false
 local per = peripheral.getNames()
 for i, side in pairs(per) do
  printPeripheral(side)
  foundPeripheral = true
 end
 if not foundPeripheral then
  printError("No peripheral was found.")
 end
else
 for i, side in pairs(sides) do
  if peripheral.isPresent(side) then
   printPeripheral(side)
  else
   printError("No peripheral was found for the side: " .. side)
  end
 end
end