function down(mods, key) return hs.eventtap.event.newKeyEvent(mods, key, true) end
function up(mods, key) return hs.eventtap.event.newKeyEvent(mods, key, false) end
function focus(scr)
  -- local front_w = hs.window.filter.new():setCurrentSpace(true):setScreens(n_scr:id()):getWindows()[1]
  local front_w = hs.window.filter.new():setScreens(scr:id()):getWindows()[1]
  if front_w then
    front_w:focus()
  end
end

keymap = {
  {{'fn'}, 'help', {}, 'return'},
  {{'cmd'}, 'f13', {'cmd'}, 'f13'},
  {{'cmd'}, 'f14', {'cmd'}, 'f14'},
  {{'r_ctrl'}, ';', {}, 'pageup'},
  {{'cmd'}, ';', {}, ';'},
  {{'shift'}, ';', {'shift'}, ';'},
  {{}, ';', {}, '='},
  {{'fn'}, 'f13', {'cmd', 'shift'}, '['},
  {{'fn'}, 'f14', {'cmd', 'shift'}, ']'},
  {{'fn'}, 'f15', {'cmd'}, 'w'},
  {{'cmd'}, 'home', {'cmd'}, 'up'},
  {{'cmd'}, 'end', {'cmd'}, 'down'},
  {{'fn'}, 'home', {'cmd'}, 'left'},
  {{'fn'}, 'end', {'cmd'}, 'right'},
  {{'fn'}, 'forwarddelete', {'cmd'}, 'delete'},

  {{'l_ctrl'}, 'w', {}, 'up'},
  {{'l_ctrl'}, 'a', {}, 'left'},
  {{'l_ctrl'}, 's', {}, 'down'},
  {{'l_ctrl'}, 'd', {}, 'right'},

  {{'r_ctrl'}, '/', {}, 'pagedown'},
  {{'r_ctrl'}, 'k', {}, 'return'},
  {{'r_ctrl'}, '\'', {}, 'delete'},
  {{'r_ctrl'}, ',', {'cmd'}, 'delete'},

  {{'r_ctrl', 'cmd'}, 'o', {'cmd', 'ctrl'}, 'o'},
  {{'r_ctrl', 'cmd'}, 'p', {'cmd', 'ctrl'}, 'p'},
  {{'r_ctrl'}, 'o', {'cmd', 'shift'}, '['},
  {{'r_ctrl'}, 'p', {'cmd', 'shift'}, ']'},
  {{'r_ctrl'}, '[', {'cmd'}, 'w'},

  {{'r_ctrl', 'cmd'}, 'l', {'cmd'}, 'up'},
  {{'r_ctrl', 'cmd'}, '.', {'cmd'}, 'down'},
  {{'r_ctrl'}, 'l', {'cmd'}, 'left'},
  {{'r_ctrl'}, '.', {'cmd'}, 'right'},

  {{'r_ctrl'}, '0', {'cmd'}, 'c'},
  {{'r_ctrl'}, '-', {'cmd'}, 'v'},

  {{'_'}, 'space', {}, '0'},
  {{'_'}, 'n', {}, '1'},
  {{'_'}, 'm', {}, '2'},
  {{'_'}, ',', {}, '3'},
  {{'_'}, 'h', {}, '4'},
  {{'_'}, 'j', {}, '5'},
  {{'_'}, 'k', {}, '6'},
  {{'_'}, 'y', {}, '7'},
  {{'_'}, 'u', {}, '8'},
  {{'_'}, 'i', {}, '9'},
  {{'_'}, '7', {}, '/'},
  {{'_'}, '8', {'shift'}, '8'},
  {{'_'}, 't', {}, '-'},
  {{'_'}, 'g', {'shift'}, '='},
  {{'_'}, 'l', {}, 'delete'},
}

hs.hotkey.bind({'cmd'}, ',', function ()
  hs.window.frontmostWindow():toggleFullScreen()
end)
hs.hotkey.bind({'cmd'}, '.', function ()
  local f_scr = hs.window.frontmostWindow():screen():fullFrame()
  if hs.window.frontmostWindow():frame().x == f_scr.x then
    hs.window.frontmostWindow():move({0.1, 0.05, 0.8, 0.8}, 0)
  else
    hs.window.frontmostWindow():setTopLeft(f_scr):setSize(f_scr)
  end
end)
hs.hotkey.bind({'cmd', 'shift'}, ',', function ()
  local front_w = hs.window.frontmostWindow()
  local n_scr = front_w:screen():next():fullFrame()
  front_w:setTopLeft(n_scr):setSize(n_scr)
  hs.mouse.setAbsolutePosition(n_scr.center)
end)
hs.window.filter.setLogLevel(1)
function switch_w(forward)
  local front_app_name = hs.application.frontmostApplication():name()
  local front_w = hs.window.frontmostWindow()
  local sortby = forward and hs.window.filter.sortByCreated or hs.window.filter.sortByCreatedLast
  local all_w = hs.window.filter.new(false):setAppFilter(front_app_name, {}):getWindows(sortby)
  local count = 0
  for k, v in pairs(all_w) do
    count = count + 1;
    if v == front_w then
      break
    end
  end
  local next_w = all_w[count + 1] or all_w[1]
  if next_w then
    if next_w:isVisible() then
      next_w:focus()
    else
      next_w:unminimize()
    end
  end
end
hs.hotkey.bind({'cmd'}, 'j', function ()
  _ = not _
  hs.alert.closeAll()
  hs.alert.show(_ and 'ON' or 'OFF')
end)
hs.hotkey.bind({'cmd', 'ctrl'}, 'o', function ()
  switch_w(false)
end)
hs.hotkey.bind({'cmd', 'ctrl'}, 'p', function ()
  switch_w(true)
end)
hs.hotkey.bind({'cmd'}, 'f13', function ()
  switch_w(false)
end)
hs.hotkey.bind({'cmd'}, 'f14', function ()
  switch_w(true)
end)
hs.hotkey.bind({'ctrl'}, ']', function ()
  local c_scr = hs.mouse.getCurrentScreen()
  focus(c_scr)
end)
hs.hotkey.bind({'cmd', 'ctrl'}, ']', function ()
  local c_scr = hs.mouse.getCurrentScreen()
  local n_scr = c_scr:next()
  hs.mouse.setAbsolutePosition(n_scr:fullFrame().center)
  focus(n_scr)
end)

last_press = nil
_ = false
en_type = hs.eventtap.event.types
event = hs.eventtap.new({ en_type.flagsChanged, en_type.otherMouseDown, en_type.keyDown, en_type.keyUp }, function(event)
  local eventType = en_type[event:getType()]

  if eventType == 'flagsChanged' then
    if event:getFlags()['ctrl'] and not event:getFlags()['cmd'] then
      return true
    else
      return false
    end
  end

  -- if eventType == 'otherMouseDown' then
  --   local button_num = event:getRawEventData().NSEventData.buttonNumber
  --   if button_num == 3 then
  --     return true, {down({'ctrl'}, 'right'), up({'ctrl'}, 'right')}
  --   elseif button_num == 4 then
  --     return true, {down({'ctrl'}, 'left'), up({'ctrl'}, 'left')}
  --   else
  --     return true, {down({'ctrl'}, 'up'), up({'ctrl'}, 'up')}
  --   end
  -- end

  if eventType == 'keyDown' or eventType == 'keyUp' then
    if event:getKeyCode() == 110 then
      return false
      -- return true, {event:setFlags({alt = true})}
    end

    if last_press and hs.keycodes.map[event:getKeyCode()] == last_press[1][2] then
      if eventType == 'keyDown' then
        return true, {down({}, last_press[1][4]):setFlags(last_press[2])}
      else
        local evt = up({}, last_press[1][4]):setFlags(last_press[2])
        last_press = nil
        return true, {evt}
      end
    end

    for key, value in pairs(keymap) do
      local match_md = true
      local en_flag = event:getFlags()
      flags = event:getRawEventData().NSEventData.modifierFlags
      for key, md in pairs(value[1]) do
        if md == 'r_ctrl'  then
          match_md =  (flags << 50 >> 63) == 1
          md = 'ctrl'
        elseif md == 'l_ctrl' then
          match_md = (flags << 63 >> 63) == 1
          md = 'ctrl'
        elseif md == '_' and flags == 256 then
          match_md = _
        else
          match_md = match_md and en_flag[md]
        end
        en_flag[md] = false
      end
      local match_key = hs.keycodes.map[event:getKeyCode()] == value[2]
      if match_md and match_key then
        if (flags << 63 >> 63) == 1 and (flags << 50 >> 63) == 1 then
          en_flag['ctrl'] = true
        end
        for key, md in pairs(value[3]) do
          en_flag[md] = true
        end
        if eventType == 'keyDown' then
          last_press = {value, en_flag}
          return true, {down({}, value[4]):setFlags(en_flag)}
        else
          return true, {up({}, value[4]):setFlags(en_flag)}
        end
      end
    end
  end

  return false
end):start()

-- Window event listen
-- events = hs.uielement.watcher

-- function handleGlobalAppEvent(name, event, app)
--   if event == hs.application.watcher.launched then
--     app:newWatcher(win_open):start({events.windowCreated})
--     for i, window in pairs(app:allWindows()) do
--       win_open(window)
--     end
--   end
-- end
-- app_event = hs.application.watcher.new(handleGlobalAppEvent):start()

-- function win_open(element)
--   element:newWatcher(win_close):start({events.windowMinimized, events.elementDestroyed})
--   if element._frame and element:frame() == element:screen():frame() then
--     local f_scr = element:screen():fullFrame()
--     element:setTopLeft(f_scr):setSize(f_scr)
--   end
-- end

-- function win_close(element, event, watcher)
--   if not hs.window.focusedWindow() then
--     local front_w = hs.window.filter.new():setScreens(element:screen():id()):getWindows()[1]
--     if front_w and front_w ~= element then
--       front_w:focus()
--     end
--   end
-- end

-- apps = hs.application.runningApplications()
-- for i = 1, #apps do
--   local watcher = apps[i]:newWatcher(win_open)
--   watcher:start({events.windowCreated, events.windowMinimized})
-- end
