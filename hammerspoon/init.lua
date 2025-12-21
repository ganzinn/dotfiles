-- Hello World
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  hs.alert.show("Hello World!")
end)


-- HOT KEY
local application = hs.application
local spaces = hs.spaces

local function registerShortcut(appName, mods, key)
  hs.hotkey.bind(mods, key, function()
    local app = application.find(appName)
    if app == nil then
      application.launchOrFocus(appName)
    elseif app:isFrontmost() then
      app:hide()
    else
      local active_space = spaces.focusedSpace()
      local wezterm_win = app:focusedWindow()
      spaces.moveWindowToSpace(wezterm_win:id(), active_space)
      app:setFrontmost()
    end
  end)
end

registerShortcut("WezTerm", {"ctrl"}, "return")
-- registerShortcut("com.google.Chrome", {"ctrl"}, "'")
-- registerShortcut("com.microsoft.VSCode", {"ctrl"}, "\\")
