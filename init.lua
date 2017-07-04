function down(mods, key) return hs.eventtap.event.newKeyEvent(mods, key, true) end
function up(mods, key) return hs.eventtap.event.newKeyEvent(mods, key, false) end

keymap = {
  {{}, 'help', {}, 'return'},
  {{}, 'f13', {'cmd', 'shift'}, '['},
  {{}, 'f14', {'cmd', 'shift'}, ']'},
  {{}, 'home', {'cmd'}, 'left'},
  {{}, 'end', {'cmd'}, 'right'},

  {{'ctrl'}, 'e', {}, 'up'},
  {{'ctrl'}, 's', {}, 'left'},
  {{'ctrl'}, 'd', {}, 'down'},
  {{'ctrl'}, 'f', {}, 'right'},

  {{'ctrl'}, 'j', {}, 'return'},
  {{'ctrl'}, ';', {}, 'delete'},

  {{'ctrl'}, 'i', {'cmd', 'shift'}, '['},
  {{'ctrl'}, 'o', {'cmd', 'shift'}, ']'},

  {{'ctrl'}, 'k', {'cmd'}, 'left'},
  {{'ctrl'}, ',', {'cmd'}, 'right'},

  {{'ctrl'}, '.', {'cmd'}, 'c'},
  {{'ctrl'}, '/', {'cmd'}, 'v'},
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
hs.hotkey.bind({'cmd'}, '/', function ()
  local front_w = hs.window.frontmostWindow()
  front_w:moveToScreen(front_w:screen():next(), 0)
end)

last_press = ''
en_type = hs.eventtap.event.types
event = hs.eventtap.new({ en_type.flagsChanged, en_type.middleMouseDown, en_type.scrollWheel, en_type.keyDown, en_type.keyUp }, function(event)
  local eventType = en_type[event:getType()]

  if eventType == 'flagsChanged' then
    if event:getFlags()['ctrl'] and not event:getFlags()['cmd'] then
      return true
    else
      return false
    end
  end

  if eventType == 'middleMouseDown' then
    return true, {down({'ctrl'}, 'up'), up({'ctrl'}, 'up')}
  end

  if eventType == 'scrollWheel' then
    local en_prop = hs.eventtap.event.properties
    if event:getFlags()['ctrl'] and event:getProperty(en_prop.scrollWheelEventIsContinuous) == 0 then
      if event:getProperty(en_prop.scrollWheelEventDeltaAxis1) > 0 then
        return true, {down({'ctrl'}, 'left'), up({'ctrl'}, 'left')}
      elseif event:getProperty(en_prop.scrollWheelEventDeltaAxis1) < 0 then
        return true, {down({'ctrl'}, 'right'), up({'ctrl'}, 'right')}
      end
    else
      return false
    end
  end

  if eventType == 'keyDown' or eventType == 'keyUp' then
    if event:getKeyCode() == 110 then
      if eventType == 'keyDown' then
        return true, {down({}, 'escape')}
      else
        return true, {up({}, 'escape')}
      end
    end
    
    for key, value in pairs(keymap) do
      local match_md = true
      local en_flag = event:getFlags()
      for key, md in pairs(value[1]) do      
        match_md = match_md and en_flag[md]
        en_flag[md] = false
      end
      local match_key = hs.keycodes.map[event:getKeyCode()] == value[2]
      if (match_md or hs.keycodes.map[event:getKeyCode()] == last_press) and match_key then
        for key, md in pairs(value[3]) do      
          en_flag[md] = true
        end
        if eventType == 'keyDown' then
          last_press = value[2]
          return true, {down({}, value[4]):setFlags(en_flag)}
        else
          if value[2] == last_press then
            last_press = ''
          end
          return true, {up({}, value[4]):setFlags(en_flag)}
        end
      end
    end
  end
  
  return false
end):start()