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
function up(mods, key, en_flag, down)
  local evt = hs.eventtap.event.newKeyEvent(mods, key, down or false)
  if en_flag then
    evt = evt:setFlags(en_flag)
  end
  if key == 'up' or key == 'down' or key == 'right' or key == 'left' then
    return evt:rawFlags(8388608 + evt:rawFlags())
  else
    return evt
  end
end
function down(mods, key, en_flag)
  return up(mods, key, en_flag, true)
end
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
  {{'r_ctrl'}, ';', {}, 'delete'},
  {{'cmd'}, ';', {}, ';'},
  {{'shift'}, ';', {'shift'}, ';'},
  {{}, ';', {}, '='},
  {{'fn'}, 'f13', {'cmd', 'shift'}, '['},
  {{'fn'}, 'f14', {'cmd', 'shift'}, ']'},
  {{'fn'}, 'f15', {'cmd'}, 'w'},
  -- {{'cmd'}, 'home', {'cmd'}, 'up'},
  -- {{'cmd'}, 'end', {'cmd'}, 'down'},
  -- {{'fn'}, 'home', {'cmd'}, 'left'},
  -- {{'fn'}, 'end', {'cmd'}, 'right'},
  {{'fn'}, 'forwarddelete', {'cmd'}, 'delete'},

  {{'l_ctrl'}, 'e', {}, 'up'},
  {{'l_ctrl'}, 's', {}, 'left'},
  {{'l_ctrl'}, 'd', {}, 'down'},
  {{'l_ctrl'}, 'f', {}, 'right'},

  {{'r_ctrl'}, 'l', {}, 'pageup'},
  {{'r_ctrl'}, '.', {}, 'pagedown'},
  {{'r_ctrl'}, 'j', {}, 'return'},
  {{'r_ctrl'}, 'm', {'cmd'}, 'delete'},

  {{'r_ctrl', 'cmd'}, 'i', {'cmd', 'ctrl'}, 'i'},
  {{'r_ctrl', 'cmd'}, 'o', {'cmd', 'ctrl'}, 'o'},
  {{'r_ctrl'}, 'i', {'cmd', 'shift'}, '['},
  {{'r_ctrl'}, 'o', {'cmd', 'shift'}, ']'},
  {{'r_ctrl'}, 'p', {'cmd'}, 'w'},

  {{'r_ctrl', 'cmd'}, 'k', {'cmd'}, 'up'},
  {{'r_ctrl', 'cmd'}, ',', {'cmd'}, 'down'},
  {{'r_ctrl'}, 'k', {}, 'home'},
  {{'r_ctrl'}, ',', {}, 'end'},

  {{'r_ctrl'}, '9', {'cmd'}, 'c'},
  {{'r_ctrl'}, '0', {'cmd'}, 'v'},
  {{}, 'f9', {'cmd'}, 'c'},
  {{}, 'f10', {'cmd'}, 'v'},

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
  if hs.window.frontmostWindow():frame().w == f_scr.w then
    hs.window.frontmostWindow():move({0.2, 0, 0.6, 1})
  else
    hs.window.frontmostWindow():setTopLeft(f_scr):setSize(f_scr)
  end
end)
hs.hotkey.bind({'cmd', 'shift'}, '.', function ()
  local front_w = hs.window.frontmostWindow()
  local n_scr = front_w:screen():next():fullFrame()
  front_w:setTopLeft(n_scr):setSize(n_scr)
  hs.mouse.setAbsolutePosition(n_scr.center)
end)
hs.hotkey.bind({'cmd', 'ctrl'}, '.', function ()
  local front_w = hs.window.frontmostWindow()
  front_w:move({0, 0, 0.5, 1})
end)
hs.hotkey.bind({'cmd', 'ctrl'}, '/', function ()
  local front_w = hs.window.frontmostWindow()
  front_w:move({0.5, 0, 0.5, 1})
end)
hs.hotkey.bind({'cmd'}, 'j', function ()
  _ = not _
  hs.alert.closeAll()
  hs.alert.show(_ and 'ON' or 'OFF')
end)
hs.hotkey.bind({'cmd', 'ctrl'}, 'i', function ()
  switch_w(false)
end)
hs.hotkey.bind({'cmd', 'ctrl'}, 'o', function ()
  switch_w(true)
end)
hs.hotkey.bind({'cmd'}, 'f13', function ()
  switch_w(false)
end)
hs.hotkey.bind({'cmd'}, 'f14', function ()
  switch_w(true)
end)
hs.hotkey.bind({'ctrl'}, 'f', function ()
  local c_scr = hs.mouse.getCurrentScreen()
  focus(c_scr)
end)
hs.hotkey.bind({'cmd', 'ctrl'}, 'f', function ()
  local c_scr = hs.mouse.getCurrentScreen()
  local n_scr = c_scr:next()
  hs.mouse.setAbsolutePosition(n_scr:fullFrame().center)
  focus(n_scr)
end)

last_keydown = nil
_ = false
en_type = hs.eventtap.event.types
event = hs.eventtap.new({ en_type.flagsChanged, en_type.otherMouseDown, en_type.otherMouseUp, en_type.keyDown, en_type.keyUp, en_type.rightMouseDown, en_type.rightMouseUp }, function(event)
  local eventType = en_type[event:getType()]

  if eventType == 'flagsChanged' then
    if event:getFlags()['ctrl'] and not event:getFlags()['cmd'] then
      return true
    else
      return false
    end
  end

  if eventType == 'rightMouseDown' then
    if event:getFlags()['ctrl'] then
      return false
    end
    return true
  end
  if eventType == 'rightMouseUp' then
    if event:getFlags()['ctrl'] then
      return false
    end
    hs.eventtap.keyStroke({'cmd', 'ctrl'}, 'd', 100000)
    return true
  end

  if eventType == 'otherMouseDown' then
    local button_num = event:getRawEventData().NSEventData.buttonNumber
    if button_num == 3 then
      return true, {down({'ctrl'}, 'right')}
    elseif button_num == 4 then
      return true, {down({'ctrl'}, 'left')}
    else
      return true, {down({'ctrl'}, 'up')}
    end
  end
  if eventType == 'otherMouseUp' then
    local button_num = event:getRawEventData().NSEventData.buttonNumber
    if button_num == 3 then
      return true, {up({'ctrl'}, 'right')}
    elseif button_num == 4 then
      return true, {up({'ctrl'}, 'left')}
    else
      return true, {up({'ctrl'}, 'up')}
    end
  end

  if eventType == 'keyDown' or eventType == 'keyUp' then
    if event:getKeyCode() == 110 then
      return false
      -- return true, {event:setFlags({alt = true})}
    end
    
    if last_keydown then
      if hs.keycodes.map[event:getKeyCode()] == last_keydown[1][2] then
        if eventType == 'keyDown' then
          if next(event:getFlags()) == nil then
            return true, {down({}, last_keydown[1][4]):setFlags(last_keydown[2])}
          end
        else
          local evt = up({}, last_keydown[1][4]):setFlags(last_keydown[2])
          last_keydown = nil
          return true, {evt}
        end
      end
    else
      if eventType == 'keyUp' then
        return false
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
          last_cvt_keydown = last_keydown
          last_keydown = {value, en_flag}
          if last_cvt_keydown then
            if last_cvt_keydown[1][4] ~= value[4] then
              return true, {up({}, last_cvt_keydown[1][4], last_cvt_keydown[2]), down({}, value[4], en_flag)}
            end
          else
            if event:getProperty(hs.eventtap.event.properties['keyboardEventAutorepeat']) == 1 then
              return true, {event:setType(hs.eventtap.event.types['keyUp']), down({}, value[4], en_flag)}
            end
          end
          return true, {down({}, value[4], en_flag)}
        else
          return true, {up({}, value[4], en_flag)}
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
