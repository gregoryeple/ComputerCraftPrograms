--[[

ExplorerMusic program
By Out-Feu

Original midi song: https://bitmidi.com/pokemon-mystery-dungeon-bluered-rescue-team-title-screen-mid
Converted to note blocks using Minecraft Note Block Studio

version 0.0.1

Free to distribute/alter
so long as proper credit to original
author is maintained.

Simply connect a speaker in any way and start this program

--]]

function playMusic()
 speaker.playNote(instrument, volume, 13)
 speaker.playNote(instrument, volume, 1)
 tickSleep(13)
 speaker.playNote(instrument, volume, 20)
 speaker.playNote(instrument, volume, 1)
 speaker.playNote(instrument, volume, 8)
 tickSleep(12)
 speaker.playNote(instrument, volume, 18)
 speaker.playNote(instrument, volume, 1)
 speaker.playNote(instrument, volume, 6)
 tickSleep(12)
 speaker.playNote(instrument, volume, 23)
 speaker.playNote(instrument, volume, 1)
 speaker.playNote(instrument, volume, 11)
 tickSleep(11)
 speaker.playNote(instrument, volume, 20)
 speaker.playNote(instrument, volume, 1)
 speaker.playNote(instrument, volume, 8)
 tickSleep(13)
 speaker.playNote(instrument, volume, 1)
 tickSleep(8)
 speaker.playNote(instrument, volume, 17)
 speaker.playNote(instrument, volume, 5)
 tickSleep(4)
 speaker.playNote(instrument, volume, 18)
 speaker.playNote(instrument, volume, 1)
 speaker.playNote(instrument, volume, 6)
 tickSleep(7)
 speaker.playNote(instrument, volume, 5)
 tickSleep(2)
 speaker.playNote(instrument, volume, 6)
 tickSleep(1)
 speaker.playNote(instrument, volume, 5)
 tickSleep(2)
 speaker.playNote(instrument, volume, 15)
 speaker.playNote(instrument, volume, 1)
 speaker.playNote(instrument, volume, 3)
 tickSleep(11)
 speaker.playNote(instrument, volume, 17)
 speaker.playNote(instrument, volume, 1)
 speaker.playNote(instrument, volume, 5)
 tickSleep(13)
 speaker.playNote(instrument, volume, 1)
 tickSleep(8)
 speaker.playNote(instrument, volume, 13)
 speaker.playNote(instrument, volume, 1)
 tickSleep(4)
 speaker.playNote(instrument, volume, 15)
 speaker.playNote(instrument, volume, 1)
 speaker.playNote(instrument, volume, 3)
 tickSleep(7)
 speaker.playNote(instrument, volume, 1)
 tickSleep(2)
 speaker.playNote(instrument, volume, 3)
 tickSleep(1)
 speaker.playNote(instrument, volume, 1)
 tickSleep(2)
 speaker.playNote(instrument, volume, 11)
 speaker.playNote(instrument, volume, 23)
 speaker.playNote(instrument, volume, 1)
 tickSleep(11)
 speaker.playNote(instrument, volume, 13)
 speaker.playNote(instrument, volume, 1)
 tickSleep(13)
 speaker.playNote(instrument, volume, 8)
 speaker.playNote(instrument, volume, 20)
 speaker.playNote(instrument, volume, 1)
 tickSleep(12)
 speaker.playNote(instrument, volume, 11)
 speaker.playNote(instrument, volume, 23)
 speaker.playNote(instrument, volume, 1)
 tickSleep(12)
 speaker.playNote(instrument, volume, 15)
 speaker.playNote(instrument, volume, 1)
 speaker.playNote(instrument, volume, 3)
 tickSleep(11)
 speaker.playNote(instrument, volume, 13)
 speaker.playNote(instrument, volume, 1)
 tickSleep(13)
 speaker.playNote(instrument, volume, 20)
 speaker.playNote(instrument, volume, 1)
 speaker.playNote(instrument, volume, 8)
 tickSleep(12)
 speaker.playNote(instrument, volume, 18)
 speaker.playNote(instrument, volume, 1)
 speaker.playNote(instrument, volume, 6)
 tickSleep(12)
 speaker.playNote(instrument, volume, 23)
 speaker.playNote(instrument, volume, 1)
 speaker.playNote(instrument, volume, 11)
 tickSleep(11)
 speaker.playNote(instrument, volume, 20)
 speaker.playNote(instrument, volume, 1)
 speaker.playNote(instrument, volume, 8)
 tickSleep(13)
 speaker.playNote(instrument, volume, 1)
 tickSleep(8)
 speaker.playNote(instrument, volume, 17)
 speaker.playNote(instrument, volume, 5)
 tickSleep(4)
 speaker.playNote(instrument, volume, 18)
 speaker.playNote(instrument, volume, 1)
 speaker.playNote(instrument, volume, 6)
 tickSleep(7)
 speaker.playNote(instrument, volume, 5)
 tickSleep(2)
 speaker.playNote(instrument, volume, 6)
 tickSleep(1)
 speaker.playNote(instrument, volume, 5)
 tickSleep(2)
 speaker.playNote(instrument, volume, 15)
 speaker.playNote(instrument, volume, 1)
 speaker.playNote(instrument, volume, 3)
 tickSleep(11)
 speaker.playNote(instrument, volume, 17)
 speaker.playNote(instrument, volume, 1)
 speaker.playNote(instrument, volume, 5)
 tickSleep(13)
 speaker.playNote(instrument, volume, 1)
 tickSleep(8)
 speaker.playNote(instrument, volume, 13)
 speaker.playNote(instrument, volume, 1)
 tickSleep(4)
 speaker.playNote(instrument, volume, 15)
 speaker.playNote(instrument, volume, 1)
 speaker.playNote(instrument, volume, 3)
 tickSleep(7)
 speaker.playNote(instrument, volume, 1)
 tickSleep(2)
 speaker.playNote(instrument, volume, 3)
 tickSleep(1)
 speaker.playNote(instrument, volume, 1)
 tickSleep(2)
 speaker.playNote(instrument, volume, 11)
 speaker.playNote(instrument, volume, 1)
 tickSleep(11)
 speaker.playNote(instrument, volume, 13)
 speaker.playNote(instrument, volume, 1)
 tickSleep(13)
 speaker.playNote(instrument, volume, 8)
 speaker.playNote(instrument, volume, 20)
 speaker.playNote(instrument, volume, 1)
 tickSleep(12)
 speaker.playNote(instrument, volume, 11)
 speaker.playNote(instrument, volume, 23)
 speaker.playNote(instrument, volume, 1)
 tickSleep(12)
end

function tickSleep(ticks)
 os.sleep(0.05 * ticks)
end

function getRedstoneInput()
 sides = redstone.getSides()
 for k, v in pairs(sides) do
  if redstone.getInput(v) then
   return true
  end
 end
 return false
end

-------------------------------------------------------------------------------

per = peripheral.getNames()
for k, v in pairs(per) do
 if peripheral.getType(v) == "speaker" then
  speaker = peripheral.wrap(v)
 end
end
per = nil

redstoneMode = true
instrument = "harp"
volume = 3.0

--------------------------------------------------------------------------------

repeat --main loop
 if redstoneMode then
  if getRedstoneInput() then
   playMusic()
  else
   os.pullEvent("redstone")
  end
 else
  playMusic()
 end
until false
