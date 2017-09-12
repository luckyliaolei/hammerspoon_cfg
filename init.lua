function down(mods, key) return hs.eventtap.event.newKeyEvent(mods, key, true) end
function up(mods, key) return hs.eventtap.event.newKeyEvent(mods, key, false) end

keymap = {
  {{}, 'help', {}, 'return'},
  {{'cmd'}, 'f13', {'cmd'}, 'f13'},
  {{'cmd'}, 'f14', {'cmd'}, 'f14'},
  {{}, 'f13', {'cmd', 'shift'}, '['},
  {{}, 'f14', {'cmd', 'shift'}, ']'},
  {{}, 'f15', {'cmd'}, 'w'},
  {{'cmd'}, 'home', {'cmd'}, 'up'},
  {{'cmd'}, 'end', {'cmd'}, 'down'},
  {{}, 'home', {'cmd'}, 'left'},
  {{}, 'end', {'cmd'}, 'right'},

  {{'ctrl'}, 'e', {}, 'up'},
  {{'ctrl'}, 's', {}, 'left'},
  {{'ctrl'}, 'd', {}, 'down'},
  {{'ctrl'}, 'f', {}, 'right'},

  {{'ctrl'}, 'j', {}, 'return'},
  {{'ctrl'}, ';', {}, 'delete'},

  {{'cmd', 'ctrl'}, 'i', {'cmd', 'ctrl'}, 'i'},
  {{'cmd', 'ctrl'}, 'o', {'cmd', 'ctrl'}, 'o'},
  {{'ctrl'}, 'i', {'cmd', 'shift'}, '['},
  {{'ctrl'}, 'o', {'cmd', 'shift'}, ']'},
  {{'ctrl'}, 'p', {'cmd'}, 'w'},
  
  {{'cmd', 'ctrl'}, 'k', {'cmd'}, 'up'},
  {{'cmd', 'ctrl'}, ',', {'cmd'}, 'down'},
  {{'ctrl'}, 'k', {'cmd'}, 'left'},
  {{'ctrl'}, ',', {'cmd'}, 'right'},

  {{'ctrl'}, '.', {'cmd'}, 'c'},
  {{'ctrl'}, '/', {'cmd'}, 'v'},

  {{'alt'}, 'space', {}, '0'},
  {{'alt'}, 'n', {}, '1'},
  {{'alt'}, 'm', {}, '2'},
  {{'alt'}, ',', {}, '3'},
  {{'alt'}, 'h', {}, '4'},
  {{'alt'}, 'j', {}, '5'},
  {{'alt'}, 'k', {}, '6'},
  {{'alt'}, 'y', {}, '7'},
  {{'alt'}, 'u', {}, '8'},
  {{'alt'}, 'i', {}, '9'},
  {{'alt'}, '.', {}, '.'},
  {{'alt'}, '7', {}, '/'},
  {{'alt'}, '8', {'shift'}, '8'},
  {{'alt'}, 't', {}, '-'},
  {{'alt'}, 'g', {'shift'}, '='},
  {{'alt'}, 'l', {}, 'delete'},
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
hs.hotkey.bind({'ctrl'}, '\'', function ()
  local c_scr = hs.mouse.getCurrentScreen()
  local front_w = hs.window.filter.new():setCurrentSpace(true):setScreens(c_scr:id()):getWindows()[1]
  if front_w then
    front_w:focus()
  end
end)
hs.hotkey.bind({'cmd', 'ctrl'}, '\'', function ()
  local c_scr = hs.mouse.getCurrentScreen()
  local n_scr = c_scr:next()
  hs.mouse.setAbsolutePosition(n_scr:fullFrame().center)
  -- hs.eventtap.leftClick(n_scr.center)
  local front_w = hs.window.filter.new():setCurrentSpace(true):setScreens(n_scr:id()):getWindows()[1]
  if front_w then
    front_w:focus()
  end
end)

last_press = nil
app_press = false
en_type = hs.eventtap.event.types
event = hs.eventtap.new({ en_type.flagsChanged, en_type.otherMouseDown, en_type.scrollWheel, en_type.keyDown, en_type.keyUp }, function(event)
  local eventType = en_type[event:getType()]

  if eventType == 'flagsChanged' then
    if event:getFlags()['ctrl'] and not event:getFlags()['cmd'] then
      return true
    else
      return false
    end
  end

  if eventType == 'otherMouseDown' then
    local button_num = event:getRawEventData().NSEventData.buttonNumber
    if button_num == 3 then
      return true, {down({'ctrl'}, 'right'), up({'ctrl'}, 'right')}
    elseif button_num == 4 then
      return true, {down({'ctrl'}, 'left'), up({'ctrl'}, 'left')}
    else
      return true, {down({'ctrl'}, 'up'), up({'ctrl'}, 'up')}
    end
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
        app_press = true
      else
        app_press = false
      end
      return true
    end
    if app_press then
      event:setFlags({cmd=true})
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
      for key, md in pairs(value[1]) do      
        match_md = match_md and en_flag[md]
        en_flag[md] = false
      end
      flags = event:getRawEventData().NSEventData.modifierFlags
      if (flags << 63 >> 63) == 1 and (flags << 50 >> 63) == 1 then
        en_flag['ctrl'] = true
      end
      local match_key = hs.keycodes.map[event:getKeyCode()] == value[2]
      if match_md and match_key then
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
events = hs.uielement.watcher

function handleGlobalAppEvent(name, event, app)
  if event == hs.application.watcher.launched then
    local watcher = app:newWatcher(win_open)
    watcher:start({events.windowCreated})
    for i, window in pairs(app:allWindows()) do
      win_open(window)
    end
  end
end

function win_open(element)
  if element._frame and element:frame() == element:screen():frame() then
    local f_scr = element:screen():fullFrame()
    element:setTopLeft(f_scr):setSize(f_scr)
  end
end

apps = hs.application.runningApplications()
for i = 1, #apps do
  local watcher = apps[i]:newWatcher(win_open)
  watcher:start({events.windowCreated})
end

app_event = hs.application.watcher.new(handleGlobalAppEvent):start()
