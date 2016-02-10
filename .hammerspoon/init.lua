-- STOP! Hammerspoon Time!

-- Keybinding Index
--   Ctrl-Opt-Cmd - R - Reload Hammerspoon
--   Ctrl-Opt-Cmd - Y - Hide all windows
--   Ctrl-Opt-Cmd - \ - Lock screen
--   Ctrl-Opt-Cmd - P - 10 minutes of battery caffeination
--   Ctrl-Opt-Cmd - O - Application shortcut hints
--   Ctrl-Opt-Cmd - W - Open work applications and fix layout
--   Ctrl-Opt-Cmd - E - Fix layout of any running work applications
--   Ctrl-Opt-Cmd - Q - Close work applications
--
--   Ctrl-Opt-Cmd - vim-movement - Vim-like window movement

-- Printers {{{

--  Default printers changed with wifi network.

printers =  {
  ['default'] = 'Brother_MFC_9130CW',
  ['cswlan']  = 'BW_Tech_Storage',
}

-- }}}

-- Work Applications {{{

--  New screen positions can be determined using the following in the console
--    hs.application.find('Name'):mainWindow():frame()

workApps =  {
  ['Slack'] = {
    screen = 'right',
    position = {1701.0,71.0,1108.0,758.0},
    fallback = {180.0,125.0,1080.0,610.0},
    hide = false,
  },
  ['Messages'] = {
    screen = 'right',
    position = {1860.0,133.0,1080.0,658.0},
    fallback = {180.0,125.0,1080.0,610.0},
    hide = true
  },
  ['Microsoft Lync'] = {
    screen = 'right',
    position = false,
    fallback = false,
    hide = true
  },
  ['Twitter'] = {
    screen = 'left',
    position = {-441.0,94.0,424.0,859.0},
    fallback = {21.0,63.0,424.0,742.0},
    hide = true
  },
  ['Microsoft Outlook'] = {
    screen = 'left',
    position = {-1653.0,47.0,1337.0,956.0},
    fallback = {64.0,75.0,1216.0,731.0},
    hide = false
  },
}

-- }}}

-- Configurations {{{

hs.window.animationDuration = 0
hs.hints.style = 'vimperator'

-- }}}

-- Shortcut Modifiers {{{

local coc = { 'control', 'option', 'command' }
local cc  = { 'control', 'command'           }
local co  = { 'control', 'option'            }
local oc  = { 'option',  'command'           }

-- }}}

-- Reload - Ctrl-Opt-Cmd-R {{{

hs.hotkey.bind(coc, 'r', nil, function()
  hs.alert.show('Reloading Hammerspoon')
  hs.reload()
end)

--}}}

-- Lockscreen - Ctrl-Opt-Cmd-\ {{{

hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, '\\', function()
  hs.caffeinate.lockScreen()
end)

--}}}

-- Hide all windows - Ctrl-Opt-Cmd-Y {{{

hs.hotkey.bind(coc, 'y', nil, function()
  -- loop over all running applications
  local running = hs.application.runningApplications()
  for i, app in ipairs(running) do
    -- hide if not hidden
    if app:isHidden() == false then
      if app:name() ~= 'Finder' then
        app:hide()
      else
        -- except for Finder, for that, just close visible windows
        -- the 'Desktop' window will remain open
        for i,win in ipairs(app:visibleWindows()) do
          win:close()
        end
      end
    end
  end
end)

-- }}}

-- Invoke hints - Ctrl-Opt-Cmd-O {{{

hs.hotkey.bind(coc, 'o', nil, function()
  hs.hints.windowHints()
end)

-- }}}

-- Vim-like window navigation - Ctrl-Opt-Cmd-{hljk} {{{

hs.hotkey.bind(coc, 'h', function() if hs.window.focusedWindow() then hs.window.focusedWindow():focusWindowWest()  end end)
hs.hotkey.bind(coc, 'l', function() if hs.window.focusedWindow() then hs.window.focusedWindow():focusWindowEast()  end end)
hs.hotkey.bind(coc, 'j', function() if hs.window.focusedWindow() then hs.window.focusedWindow():focusWindowSouth() end end)
hs.hotkey.bind(coc, 'k', function() if hs.window.focusedWindow() then hs.window.focusedWindow():focusWindowNorth() end end)

-- }}}

-- Battery caffeination - Ctrl-Opt-Cmd-[ {{{

hs.hotkey.bind(coc, '[', nil, function()
  if caffeineTimer then
    caffeineTimer:stop()
  end
  if caffeineMenu then
    hs.caffeinate.set('system',false,false)
    caffeineMenu:delete()
    caffeineMenu = nil
  else
    caffeineMenu = hs.menubar.new()
    caffeineMenu:setTitle('Battery Caffineated')
    hs.caffeinate.set('system',true,true)
    caffeineTimer = hs.timer.doAfter(60*10, function()
      hs.caffeinate.set('system',false,false)
      caffeineMenu:delete()
      caffeineMenu = nil
    end)
  end
end)

-- Battery caffeination - Ctrl-Opt-Cmd-]
hs.hotkey.bind(coc, ']', nil, function()
  if caffeineTimer then
    caffeineTimer:stop()
  end
  if caffeineMenu then
    hs.caffeinate.set('system',false,false)
    caffeineMenu:delete()
    caffeineMenu = nil
  else
    caffeineMenu = hs.menubar.new()
    caffeineMenu:setTitle('Battery Caffineated')
    hs.caffeinate.set('system',true,true)
    caffeineTimer = hs.timer.doAfter(60*10, function()
      hs.caffeinate.set('system',false,false)
      caffeineMenu:delete()
      caffeineMenu = nil
    end)
  end
end)

-- }}}

-- Open and layout work applications - Ctrl-Opt-Cmd-W {{{

hs.hotkey.bind(coc, 'w', nil, function()

  -- this dealy will change based on how many applications get opened
  local layout_delay = 0

  -- open work applications
  for name,config in pairs(workApps) do
    if not hs.application.find(name) then
      hs.application.open(name,0,true)
      layout_delay = layout_delay + 1
    end
  end

  -- this must be down as another event
  --
  -- otherwise, after opening the applications up hs.application.find won't
  -- find newly launched applications
  hs.timer.doAfter(layout_delay, layout_apps)

end)

-- }}}

-- Layout any running work applications - Ctrl-Opt-Cmd-E {{{

hs.hotkey.bind(coc, 'e', nil, function()
  layout_apps()
end)

function layout_apps()
  -- layout work applications
  for name,config in pairs(workApps) do
    local app = hs.application.find(name)
    if app then

      -- unhide it if we are going to adjust it
      if config.position or config.screen then
        if app:isHidden() then
          app:unhide()
        end
      end

      local preferred_position = config.position

      if config.screen then
        s = scrn(config.screen)

        -- if we can't find our preferred screen
        -- use the fallback
        if not s then
          preferred_position = config.fallback
          s = scrn()
        end

        if s then
          hs.fnutils.each(app:visibleWindows(), function(w)
            if w:screen():id() ~= s:id() then
              w:moveToScreen(s)
            end
            w:setFrameInScreenBounds()
          end)
        end
      end

      if preferred_position then
        local win = app:mainWindow()
        if not app:isHidden() and win then
          win:setFrame(hs.geometry.rect(preferred_position))
        end
      end

      if config.hide then
        app:hide()
      end

    end
  end
end

-- }}}

-- Close work applications - Ctrl-Opt-Cmd-Q {{{

hs.hotkey.bind(coc, 'q', nil, function()
  for name,config in pairs(workApps) do
    local app = hs.application.get(name)
    if app then
      app:kill()
    end
  end
end)

-- }}}

-- Change default printer based on wifi SSID {{{

wifiPrinterWatcher = hs.wifi.watcher.new(function()
  local wifi = hs.wifi.currentNetwork()
  l.i("wifiPrinterWatcher invoked")
  if wifi then
    l.i("  SSID is " .. wifi)
    for network,printer in pairs(printers) do
      if wifi == network then
        setPrinter(printer)
        return
      end
    end
    if printers['default'] then
      setPrinter(printers['default'])
    end
  else
    l.i("  No SSID present")
  end
end)
wifiPrinterWatcher:start()

-- }}}

-- Utility functions {{{

-- Screen selector scrn(['left','right'])
function scrn(s)
  if s == 'left' then
    return hs.screen{x=-1,y=0}
  elseif s == 'right' then
    return hs.screen{x=1,y=0}
  else
    return hs.screen{x=0,y=0}
  end
end

-- Set default printer
function setPrinter(printer)
  local current = currentPrinter()
  if printer ~= current then
    hs.execute("/usr/bin/lpoptions -d '" .. printer .. "'");
    current = currentPrinter()
    hs.alert.show("Now using printer\n" .. current)
  end
end

-- Inspect default printer
function currentPrinter()
  local result, status = hs.execute('/usr/bin/lpstat -d')
  if status == true then
    return string.match(result, "estination: (.+)\n")
  end
  return 'Unknown'
end

-- }}}

-- Experiments {{{

l = hs.logger.new('byrne','debug')

-- hs.hotkey.bind(coc, 'a', nil, function()
-- end)

-- hs.hotkey.bind(coc, 'z', nil, function()
-- end)

-- }}}

-- Post loading message {{{

hs.alert.show('Hammerspoon Loaded')

-- }}}

-- vim: set foldmethod=marker :
