--[[

PeripheralDetector program
By Out-Feu

version 1.1.0

Free to distribute/alter
so long as proper credit to original
author is maintained.

This program will display the available methods of all the connected peripherals.
A side can be provided when launching the program to only display the methods of the associated peripheral.

--]]

function printPeripheral(side, file)
 local per = peripheral.getType(side)
 if file == nil then
  print(side .. ": " .. per)
 else
  file.writeLine(side .. ": " .. per)
 end
 if displayMethods then
  printMethods(side, file)
 end
end

function printMethods(side, file)
 local methods = peripheral.getMethods(side)
 for i, method in pairs(methods) do
  if file == nil then
   print(" " .. i .. " - " .. method)
  else
   file.writeLine(" " .. i .. " - " .. method)
  end
 end
end

function findPeripherals()
 if sides == nil or next(sides) == nil then
  local foundPeripheral = false
  local per = peripheral.getNames()
  for i, side in pairs(per) do
   table.insert(peripherals, side)
   foundPeripheral = true
  end
  if not foundPeripheral then
   printError("No peripheral was found.")
  end
 else
  for i, side in pairs(sides) do
   if peripheral.isPresent(side) then
    table.insert(peripherals, side)
   else
    printError("No peripheral was found for the side: " .. side)
   end
  end
 end
end

displayMethods = true -- Should all peripherals' methods be printed
exportFile = "" -- If set, output will be exported to a file (override content)
sides = {...}
peripherals = {}

findPeripherals()

if peripherals == nil or next(peripherals) == nil then
 return -- exit from the script if no peripherals were found
end

if exportFile == nil or exportFile == '' then
 for i, peripheral in pairs(peripherals) do
  printPeripheral(peripheral, nil)
 end
else
 local file = fs.open(exportFile, "w")
 for i, peripheral in pairs(peripherals) do
  printPeripheral(peripheral, file)
 end
 file.close()
  print("Exported " .. #peripherals .. " peripherals to " .. exportFile)
end
