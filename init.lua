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
function up(mods, key, md_flag, down)
  local evt = hs.eventtap.event.newKeyEvent(mods, key, down or false)
  if md_flag then
    evt = evt:setFlags(md_flag)
  end
  if key == 'up' or key == 'down' or key == 'right' or key == 'left' then
    return evt:rawFlags(8388608 + evt:rawFlags())
  else
    return evt
  end
end
function down(mods, key, md_flag)
  return up(mods, key, md_flag, true)
end
function focus(scr)
  -- local front_w = hs.window.filter.new():setCurrentSpace(true):setScreens(n_scr:id()):getWindows()[1]
  local front_w = hs.window.filter.new():setScreens(scr:id()):getWindows()[1]
  if front_w then
    front_w:focus()
  end
end
function ctrl_k(flags)
  ctrl = {}
  if (flags << 50 >> 63) == 1 then 
    ctrl['r_ctrl'] = true
  end
  if (flags << 63 >> 63) ~= 1 then
    ctrl['l_ctrl'] = true
  end
  return ctrl
end
function is_match(value, md_flag, key, flags)
  ctrl = ctrl_k(flags)
  local md_pure = {}
  for idx, val in pairs(value[1]) do
    if val == 'r_ctrl' or val == 'r_ctrl' then
      if not ctrl[val] then
        return false
      end
      table.insert(md_pure, 'ctrl')
    else
      table.insert(md_pure, val)
    end
  end
  return md_flag:containExactly(md_pure) and value[2] == key
end

function is_contain(value, md_flag, key, flags)
  ctrl = ctrl_k(flags)
  if value[2] ~= key then
    return false
  end

  for idx, val in pairs(value[1]) do
    if val == 'r_ctrl' or val == 'r_ctrl' then
      if not ctrl[val] then
        return false
      end
      if not (ctrl['r_ctrl'] and ctrl['l_ctrl']) then
        md_flag['ctrl'] = false
      end
    else
      if not md_flag[val] then
        return false
      end
      md_flag[val] = false
    end
  end
  return md_flag
end

keymap = {

  {{'cmd'}, 'f13', {'cmd'}, 'f13'},
  {{'cmd'}, 'f14', {'cmd'}, 'f14'},
  {{'cmd'}, ';', {}, ';'},
  {{}, ';', {}, '='},
  {{'fn'}, 'f13', {'cmd', 'shift'}, '['},
  {{'fn'}, 'f14', {'cmd', 'shift'}, ']'},
  {{'fn'}, 'f15', {'cmd'}, 'w'},
  -- {{'cmd'}, 'home', {'cmd'}, 'up'},
  -- {{'cmd'}, 'end', {'cmd'}, 'down'},
  -- {{'fn'}, 'home', {'cmd'}, 'left'},
  -- {{'fn'}, 'end', {'cmd'}, 'right'},
  {{'fn'}, 'forwarddelete', {'cmd'}, 'delete'},

  {{'r_ctrl'}, 'm', {'cmd'}, 'delete'},

  {{'r_ctrl', 'cmd'}, 'i', {'cmd', 'ctrl'}, 'i'},
  {{'r_ctrl', 'cmd'}, 'o', {'cmd', 'ctrl'}, 'o'},
  {{'r_ctrl'}, 'i', {'cmd', 'shift'}, '['},
  {{'r_ctrl'}, 'o', {'cmd', 'shift'}, ']'},
  {{'r_ctrl'}, 'p', {'cmd'}, 'w'},

  {{'r_ctrl', 'cmd'}, 'k', {'cmd'}, 'up'},
  {{'r_ctrl', 'cmd'}, ',', {'cmd'}, 'down'},
  {{'r_ctrl'}, '9', {'cmd'}, 'c'},
  {{'r_ctrl'}, '0', {'cmd'}, 'v'},
  {{'fn'}, 'f9', {'cmd'}, 'c'},
  {{'fn'}, 'f10', {'cmd'}, 'v'},

}

one_key = {

  {{'fn'}, 'help', {}, 'return'},
  {{'r_ctrl'}, ';', {}, 'delete'},

  {{'l_ctrl'}, 'e', {}, 'up'},
  {{'l_ctrl'}, 's', {}, 'left'},
  {{'l_ctrl'}, 'd', {}, 'down'},
  {{'l_ctrl'}, 'f', {}, 'right'},

  {{'r_ctrl'}, 'l', {}, 'pageup'},
  {{'r_ctrl'}, '.', {}, 'pagedown'},
  {{'r_ctrl'}, 'j', {}, 'return'},
  {{'r_ctrl'}, 'k', {}, 'home'},
  {{'r_ctrl'}, ',', {}, 'end'},

}

pad = {
  ['spce'] = {{}, '0'},
  ['n'] = {{}, '1'},
  ['m'] = {{}, '2'},
  [','] = {{}, '3'},
  ['h'] = {{}, '4'},
  ['j'] = {{}, '5'},
  ['k'] = {{}, '6'},
  ['y'] = {{}, '7'},
  ['u'] = {{}, '8'},
  ['i'] = {{}, '9'},
  ['7'] = {{}, '/'},
  ['8'] = {{'shift'}, '8'},
  ['t'] = {{}, '-'},
  ['g'] = {{'shift'}, '='},
  ['l'] = {{}, 'delete'},
}


hs.hotkey.bind({'cmd'}, ',', function ()
  hs.window.frontmostWindow():toggleFullScreen()
end)
hs.hotkey.bind({'cmd'}, '.', function ()
  local f_scr = hs.window.frontmostWindow():screen():fullFrame()
  if hs.window.frontmostWindow():frame().w == f_scr.w then
    hs.window.frontmostWindow():move({0.25, 0, 0.5, 1})
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

-- volume control
local function sendSystemKey(key)
  hs.eventtap.event.newSystemKeyEvent(key, true):post()
  hs.eventtap.event.newSystemKeyEvent(key, false):post()
end

local volume = {
  up   = function() sendSystemKey("SOUND_UP") end,
  down = function() sendSystemKey("SOUND_DOWN") end,
  mute = function() sendSystemKey("MUTE") end,
}
hs.hotkey.bind({}, "f1", volume.mute)
hs.hotkey.bind({}, "f2", volume.down, nil, volume.down)
hs.hotkey.bind({}, "f3", volume.up, nil, volume.up)

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
      -- return false
      return true, {hs.eventtap.event.newKeyEvent('alt', eventType == 'keyDown')}
    end
    
    local md_flag = event:getFlags()
    flags = event:getRawEventData().NSEventData.modifierFlags
    key = hs.keycodes.map[event:getKeyCode()]

    if _ then
      if pad[key] then
        return true, {hs.eventtap.event.newKeyEvent(pad[key][1], pad[key][2], eventType == 'keyDown')}
      end
    end

    for idx, value in pairs(keymap) do
      if is_match(value, md_flag, key, flags) then
        return true, {hs.eventtap.event.newKeyEvent(value[3], value[4], eventType == 'keyDown')}
      end
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

    for idx, value in pairs(one_key) do
      new_flag = is_contain(value, event:getFlags(), key, flags)
      if new_flag then
        for idx, md in pairs(value[3]) do
          new_flag[md] = true
        end
        if eventType == 'keyDown' then
          last_cvt_keydown = last_keydown
          last_keydown = {value, new_flag}
          if last_cvt_keydown then
            if last_cvt_keydown[1][4] ~= value[4] then
              return true, {up({}, last_cvt_keydown[1][4], last_cvt_keydown[2]), down({}, value[4], new_flag)}
            end
          else
            if event:getProperty(hs.eventtap.event.properties['keyboardEventAutorepeat']) == 1 then
              return true, {event:setType(hs.eventtap.event.types['keyUp']), down({}, value[4], new_flag)}
            end
          end
          return true, {down({}, value[4], new_flag)}
        else
          return true, {up({}, value[4], new_flag)}
        end
      end
    end
  end

  return false
end):start()