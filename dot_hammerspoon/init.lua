-- For hotkeys, you can use any of the following:
-- "cmd"   or "⌘" (U+2318)
-- "ctrl"  or "⌃" (U+2303)
-- "alt"   or "⌥" (U+2325)
-- "shift" or "⇧" (U+21e7)
-- And do them in the above order, for consistency.
-- (It's alphabetical on the macOS names of the keys: Command, Control, Option, Shift.)

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

-- ⁄⁄⁄⁄
-- Hide Zoom's "share" window so it doesn't pop up when pressing Esc elsewhere
-- Adapted from https://news.ycombinator.com/item?id=47369091
-- ⁄⁄⁄⁄

local zoomWindow = nil
local originalFrame = nil

hs.hotkey.bind({"⌘", "⌃", "⌥", "⇧"}, "z", function()
  print("Trying to hide Zoom")
  if not zoomWindow then
    print("> Looking for window")
    zoomWindow = hs.window.find("zoom share statusbar window")
  end

  if zoomWindow then
    print("> Found window")
    if originalFrame then
      print(">> Restoring")
      zoomWindow:setFrame(originalFrame)
      originalFrame = nil
      zoomWindow = nil
    else
      print(">> Hiding")
      originalFrame = zoomWindow:frame()
      local screen = zoomWindow:screen()
      local frame = zoomWindow:frame()
      frame.x = screen:frame().w + 99000
      frame.y = screen:frame().h + 99000
      zoomWindow:setFrame(frame)
    end
  else
    print("> Window not found")
  end
end)

-- ⁄⁄⁄⁄
-- Recursive bindings (leader key) setup
-- Adapted from https://blog.nethuml.xyz/posts/2022/04/hammerspoon-global-leader-key/
-- ⁄⁄⁄⁄

hs.loadSpoon("RecursiveBinder")

spoon.RecursiveBinder.escapeKey = {{}, 'escape'}

local singleKey = spoon.RecursiveBinder.singleKey
local launch = hs.application.launchOrFocusByBundleID

-- Use `osascript -e 'id of app "Firefox"'` to get an app's bundle ID
local keyMap = {
  [singleKey('b', 'Firefox')] = function() launch("org.mozilla.firefox") end,
  [singleKey('t', 'iTerm2')] = function() launch("com.googlecode.iterm2") end,
  [singleKey(',', 'System Settings')] = function() launch("com.apple.systempreferences") end,
  [singleKey('p', 'Bitwarden')] = function() launch("com.bitwarden.desktop") end,
  [singleKey('r', 'Raycast')] = function() launch("com.raycast.macos") end,
  [singleKey('h', 'Hammerspoon […]')] = {
    [singleKey('c', 'Open Hammerspoon console')] = hs.openConsole,
    [singleKey('r', 'Reload Hammerspoon config')] = hs.reload
  }
}

-- Leader key
hs.hotkey.bind({"⌘", "⌃", "⌥", "⇧"}, 'space', spoon.RecursiveBinder.recursiveBind(keyMap))

spoon.RecursiveBinder.helperEntryEachLine = 1
spoon.RecursiveBinder.helperEntryLengthInChar = 40

spoon.RecursiveBinder.helperFormat = {
    atScreenEdge = 0,
    radius = 16,
    fadeInDuration = 0.3,
    fadeOutDuration = 0.3,
    padding = 12,
    textColor = { hex = "#d9e0ee", alpha = 1 },
    fillColor = { hex = "#22242c", alpha = 0.75 },
    strokeColor = { hex = "#f5c000", alpha = 1 },
    strokeWidth = 4,
    textStyle = { -- An hs.styledtext object
      font = {
        name = "JetBrains Mono",
        size = 16
      }
    }
}
