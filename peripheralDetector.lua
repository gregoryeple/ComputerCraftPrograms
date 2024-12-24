--[[

PeripheralDetector program
By Out-Feu

version 2.0.0

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

--------------------------------------------------------------------------------

graphicInterface = true -- Should the program display its graphical interface instead of the standard output
displayMethods = true -- Should all peripherals' methods be printed
exportFile = "" -- If set, output will be exported to a file (override content)
sides = {...}
peripherals = {}

--------------------------------------------------------------------------------

findPeripherals()

if peripherals == nil or next(peripherals) == nil then
 return -- exit from the script if no peripherals were found
end

if exportFile ~= nil and exportFile ~= "" then
 local file = fs.open(exportFile, "w")
 for i, peripheral in pairs(peripherals) do
  printPeripheral(peripheral, file)
 end
 file.close()
 print("Exported " .. #peripherals .. " peripherals to " .. exportFile)
elseif not graphicInterface then
 for i, peripheral in pairs(peripherals) do
  printPeripheral(peripheral, nil)
 end
end

if graphicInterface then
 local width, height = term.getSize()
 local usableHeight = height - 5
 local currentSide = ""
 local currentMethods = nil
 local selectedIndex = 1
 local scrollIndex = 0
 repeat --main loop
  term.clear()

  -- Print title and help
  term.setCursorPos(1, 1)
  if currentSide == "" then
   term.write("Found " .. #peripherals .. " connected peripherals")
  else
   term.write(currentSide .. ": " .. peripheral.getType(currentSide) .. " (" .. #currentMethods .. " methods)")
  end
  term.setCursorPos(1, 2)
  term.write(string.rep("=", width))
  if currentSide == "" then
   term.setCursorPos(1, height - 2)
   term.write(string.rep("=", width))
   term.setCursorPos(1, height - 1)
   term.write("ARROW KEY to move")
   term.setCursorPos(1, height)
   term.write("ENTER or SPACE to select")
  elseif currentMethods ~= nil and #currentMethods > usableHeight then
   term.setCursorPos(1, height - 2)
   term.write(string.rep("=", width))
   term.setCursorPos(1, height - 1)
   term.write("ARROW KEY to move")
   term.setCursorPos(1, height)
   term.write("SHIFT or BACKPSPACE to go back")
  else
   term.setCursorPos(1, height - 1)
   term.write(string.rep("=", width))
   term.setCursorPos(1, height)
   term.write("SHIFT or BACKPSPACE to go back")
  end
  
  if currentSide == "" then
  -- Print peripherals
   for n = 1 + scrollIndex, usableHeight + scrollIndex do
    if n > #peripherals then
	 break
	end
    term.setCursorPos(1, 2 + n - scrollIndex)
	if n == selectedIndex then
     term.write(" > ")
    else
     term.write(" - ")
	end
	term.write(peripherals[n] .. ": " .. peripheral.getType(peripherals[n]))
   end
  else
  -- Print methods
   for n = 1 + scrollIndex, usableHeight + scrollIndex do
    if n > #currentMethods then
	 break
	end
    term.setCursorPos(1, 2 + n - scrollIndex)
	term.write(" - " .. currentMethods[n])
   end
  end

  -- Wait for key press
  local event, key = os.pullEvent("key")
  if key == keys.up or key == keys.pageUp then -- UP ARROW or PAGE UP was pressed
   if currentSide == "" then
    if selectedIndex > 1 then
     selectedIndex = selectedIndex - 1
	else
     selectedIndex = #peripherals
	end
   elseif currentSide ~= "" and currentMethods ~= nil and scrollIndex > 1 then
    scrollIndex = scrollIndex - 1
   end
  elseif key == keys.down or key == keys.pageDown then -- DOWN ARROW or PAGE DOWN was pressed
   if currentSide == "" then
    if selectedIndex < #peripherals then
     selectedIndex = selectedIndex + 1
	else
     selectedIndex = 1
	end
   elseif currentSide ~= "" and currentMethods ~= nil and (scrollIndex + usableHeight) < #currentMethods then
    scrollIndex = scrollIndex + 1
   end
  elseif (key == keys.enter or key == keys.space or key == keys.insert) and currentSide == "" then -- ENTER or SPACE or INSERT was pressed
   currentSide = peripherals[selectedIndex]
   currentMethods = peripheral.getMethods(currentSide)
   scrollIndex = 0
   usableHeight = height - 4
   if #currentMethods > usableHeight then
    usableHeight = height - 5
   end
  elseif (key == keys.leftShift or key == keys.rightShift or key == keys.backspace or key == keys.delete) and currentSide ~= "" then -- SHIFT or BACKSPACE or DELETE was pressed
   currentSide = ""
   currentMethods = nil
   scrollIndex = 0
   usableHeight = height - 5
  end

  -- Handle scrolling
  if currentSide == "" then
   if selectedIndex > usableHeight + scrollIndex then
    scrollIndex = selectedIndex - usableHeight
   elseif selectedIndex <= scrollIndex then
    scrollIndex = selectedIndex - 1
   end
  end
 until key == keys.t
 term.clear()
 term.setCursorPos(1, 1)
end
