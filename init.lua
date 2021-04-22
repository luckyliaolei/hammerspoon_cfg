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

function key_event(key_md, key, down)
  local evt = hs.eventtap.event.newKeyEvent({}, key, down or false):setFlags(key_md)
  if key == 'up' or key == 'down' or key == 'right' or key == 'left' then
    return evt:rawFlags(8388608 + evt:rawFlags())
  else
    return evt
  end
end

function focus(scr)
  -- local front_w = hs.window.filter.new():setCurrentSpace(true):setScreens(n_scr:id()):getWindows()[1]
  local front_w = hs.window.filter.new():setScreens(scr:id()):getWindows()[1]
  if front_w then
    front_w:focus()
  end
end

function ctrl_k(md_flag, flags)
  md_flag['ctrl'] = false
  if (flags << 50 >> 63) == 1 then 
    md_flag['r_ctrl'] = true
  end
  if (flags << 63 >> 63) == 1 then
    md_flag['l_ctrl'] = true
  end
  return md_flag
end

function copy(t)
  local u = { }
  for k, v in pairs(t) do u[k] = v end
  return setmetatable(u, getmetatable(t))
end

function containExactly(md_flag, md_map)
  local new_md = copy(md_flag)
  for k, md in pairs(md_map) do
    if not new_md[md] then
      return false
    end
    new_md[md] = false
  end
  for md, bool in pairs(new_md) do
    if bool then
      return false
    end
  end
  return true
end

function contain(md_flag, md_map)
  for k, md in pairs(md_map) do
    if not md_flag[md] then
      return false
    end
  end
  return true
end

function is_match(values, md_flag, key, flags)
  for idx, value in pairs(values) do
    if containExactly(md_flag, value[1]) and value[2] == key then
      return value
    end
  end
  return false
end

function is_contain(values, md_flag, key, flags)
  for idx, value in pairs(values) do
    if contain(md_flag, value[1]) and value[2] == key then
      return value
    end
  end
  return false
end

keymap = {

  {{'cmd'}, 'f13', {'cmd'}, 'f13'},
  {{'cmd'}, 'f14', {'cmd'}, 'f14'},
  {{'fn'}, 'f13', {'cmd', 'shift'}, '['},
  {{'fn'}, 'f14', {'cmd', 'shift'}, ']'},
  {{'fn'}, 'f15', {'cmd'}, 'w'},
  -- {{'cmd'}, 'home', {'cmd'}, 'up'},
  -- {{'cmd'}, 'end', {'cmd'}, 'down'},
  -- {{'fn'}, 'home', {'cmd'}, 'left'},
  -- {{'fn'}, 'end', {'cmd'}, 'right'},
  {{'fn'}, 'forwarddelete', {'cmd'}, 'delete'},

  {{'r_ctrl'}, 'm', {'cmd'}, 'delete'},
  {{'r_ctrl'}, '/', {'cmd', 'ctrl'}, 'd'},

  {{'r_ctrl', 'cmd'}, 'i', {'cmd', 'ctrl'}, 'i'},
  {{'r_ctrl', 'cmd'}, 'o', {'cmd', 'ctrl'}, 'o'},
  {{'r_ctrl'}, 'i', {'cmd', 'shift'}, '['},
  {{'r_ctrl'}, 'o', {'cmd', 'shift'}, ']'},
  {{'r_ctrl'}, 'p', {'cmd'}, 'w'},

  {{'r_ctrl'}, '9', {'cmd'}, 'c'},
  {{'r_ctrl'}, '0', {'cmd'}, 'v'},
  {{'fn'}, 'f9', {'cmd'}, 'c'},
  {{'fn'}, 'f10', {'cmd'}, 'v'},
  {{'cmd'}, ';', {}, '='},
}

one_key = {

  {{'fn'}, 'help', 'return'},
  {{'r_ctrl'}, ';', 'delete'},

  {{'l_ctrl'}, 'e', 'up'},
  {{'l_ctrl'}, 's', 'left'},
  {{'l_ctrl'}, 'd', 'down'},
  {{'l_ctrl'}, 'f', 'right'},

  {{'r_ctrl'}, 'l', 'pageup'},
  {{'r_ctrl'}, '.', 'pagedown'},
  {{'r_ctrl'}, 'j', 'return'},
  {{'r_ctrl'}, 'k', 'home'},
  {{'r_ctrl'}, ',', 'end'},

}

pad = {
  ['space'] = {{}, '0'},
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

one_key_md = {}
keymap_key = {}
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

  -- if eventType == 'rightMouseDown' then
  --   if event:getFlags()['ctrl'] then
  --     return true
  --   end
  -- end
  -- if eventType == 'rightMouseUp' then
  --   if event:getFlags()['ctrl'] then
  --     hs.eventtap.keyStroke({'cmd', 'ctrl'}, 'd', 100000)
  --     return true
  --   end
  -- end

  if eventType == 'otherMouseDown' then
    local button_num = event:getRawEventData().NSEventData.buttonNumber
    if button_num == 3 then
      return true, {key_event({['ctrl']=true}, 'right', true)}
    elseif button_num == 4 then
      return true, {key_event({['ctrl']=true}, 'left', true)}
    else
      return true, {key_event({['ctrl']=true}, 'up', true)}
    end
  end
  if eventType == 'otherMouseUp' then
    local button_num = event:getRawEventData().NSEventData.buttonNumber
    if button_num == 3 then
      return true, {key_event({['ctrl']=true}, 'right', false)}
    elseif button_num == 4 then
      return true, {key_event({['ctrl']=true}, 'left', false)}
    else
      return true, {key_event({['ctrl']=true}, 'up', false)}
    end
  end

  if eventType == 'keyDown' or eventType == 'keyUp' then
    if event:getKeyCode() == 110 then
      -- return false
      return true, {event:setKeyCode(hs.keycodes.map['\\'])}
    end
    
    flags = event:getRawEventData().NSEventData.modifierFlags
    md_flag = ctrl_k(event:getFlags(), flags)
    key = hs.keycodes.map[event:getKeyCode()]
    autorepeat = event:getProperty(hs.eventtap.event.properties['keyboardEventAutorepeat']) == 1

    if _ and flags == 256 then
      if pad[key] then
        return true, {hs.eventtap.event.newKeyEvent(pad[key][1], pad[key][2], eventType == 'keyDown')}
      end
    end

    if keymap_key[key] then
      local last_map_event = keymap_key[key]
      if eventType == 'keyUp' then
        keymap_key[key] = false
        return true, {last_map_event:setType(en_type.keyUp)}
      else
        return true, {last_map_event}
      end
    elseif not autorepeat and eventType == 'keyDown' then
      value = is_match(keymap, md_flag, key, flags)
      if value then
        local map_event = hs.eventtap.event.newKeyEvent(value[3], value[4], true)
        keymap_key[key] = map_event
        return true, {map_event}
      end
    end

    if one_key_md[key] then
      for idx, md in pairs(one_key_md[key]) do
        md_flag[md] = true
      end
    elseif autorepeat or eventType == 'keyUp' then
      return false
    end
    value = is_contain(one_key, md_flag, key, flags)
    if value then
      for idx, md in pairs(value[1]) do
        md_flag[md] = false
      end
      if md_flag['r_ctrl'] or md_flag['l_ctrl'] then
        md_flag['ctrl'] = true
      end
      if eventType == 'keyDown' then
        one_key_md[key] = value[1]
      else
        one_key_md[key] = false
      end
      return true, {key_event(md_flag, value[3], eventType == 'keyDown')}
    end

  end

  return false
end):start()