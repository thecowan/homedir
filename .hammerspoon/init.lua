local hyper = {"ctrl", "alt", "cmd", "shift"}
keyModal = hs.hotkey.modal.new({}, nil)

modalToHyperPassthrough = {
    -- don't need PAD* as that's done during binding
    -- don't need arrows as that's done using complex passthrough
    "C", "E", "F", "H", "J", "L", "M", "N", "S", "T", "W", "Z", "=", "'", "pageup", "pagedown", "space"
  } 

modalToHyperComplexPassthrough = {
    "up", "down", "right", "left",
  } 


keyModal.pressed = function() 
    keyModal:enter()
  end

keyModal.released = function() 
    keyModal:exit() 
end

hs.hotkey.bind({}, 'F19', keyModal.pressed, keyModal.released)

hs.loadSpoon("SpoonInstall")
Install=spoon.SpoonInstall

--[[

PrtSc/ScrLk/Pause map natively to f13/f14/f15; f14 and f15 are assigned to brightness up/down in OS X keyboard shortcuts; thought I needed to use scan code for PrtSc but works now
Can also disable F11 -> show desktop (Apple menu > System Settings, then click Keyboard)

To do:
 - absolute Rectangle-style layouts - maye add?
   - halves T B
   - 2/9ths L  M  R
   - 1/9ths L  M  R
Intercepted by something else (See 'avoid in-use keys' below): keypad-slash, keypad-dot, 
    W is supposed to be but seems to work:
]]

--[[
    Useful vacant keys:
                                      0x34   -- shows as blank char in keycodes (prob usable)
                                      0x36   -- doesn't show in keycodes; may not be usable?
                                      0x42   -- shows as blank char in keycodes (prob usable)
                                      0x44   -- no character shows in keycodes (maybe usable)
                                      0x46   -- shows as blank char in keycodes (prob usable)
      kVK_ANSI_KeypadClear          = 0x47,  -- shows character but doesn't type
                                      0x4D   -- shows as blank char in keycodes (prob usable)
      kVK_JIS_Yen                   = 0x5D,  -- shows character                     - international3 in karabiner
      kVK_JIS_Underscore            = 0x5E,  -- shows character                     - international1 in Karabiner
      kVK_JIS_KeypadComma           = 0x5F,  -- no character in Key Codes
      kVK_JIS_Eisu                  = 0x66,  -- blank character                     - lang2 in Karabiner - also 1st Japanese string?
      kVK_JIS_Kana                  = 0x68   -- blank character                     - lang1 in Karabiner - also 2nd Japanese string?
                                      0x6C   -- shows as blank char in keycodes (prob usable)
                                      0x6E   -- This is 'app key'? Not sure if this is usable
                                      0x70   -- shows as blank char in keycodes (prob usable)
      kVK_Help                      = 0x72,  -- shows character, but doesn't type
                                      0x7F+  -- don't work

]]
--[[
Spoons of interest:
TextClipboardHistory
BingRandom
UnssplashRandom
WindowGrid
WinWin?
PushToTalk?
MoveSpaces
HoldToQuit
ArrangeDesktop
PerApp
Idle reporting https://community.home-assistant.io/t/macos-idle-reporting-through-hammerspoon/130441
Amazing recursive search stuff: https://github.com/snowe2010/dotfiles/tree/master/hammerspoon/hammerspoon.symlink
https://gist.github.com/cmsj/986489fff6f3c1b96771
https://www.reddit.com/r/hammerspoon/comments/t2s6cn/awesomekeys_a_new_way_to_hack_your_key_shortcuts/
Using non-modifier hyper key: https://gist.github.com/ttscoff/cce98a711b5476166792d5e6f1ac5907
https://gist.github.com/dalemanthei/dde8bccb22c3a2d3487a6e7d77be33f5
https://github.com/evantravers/Hyper.spoon
https://apple.stackexchange.com/questions/317548/how-do-i-get-the-calculator-button-on-a-microsoft-sculpt-keyboard-working
Soma station: https://github.com/heptal/dotfiles/blob/master/roles/hammerspoon/files/mpd.lua
avoid in-use keys: https://github.com/snowe2010/dotfiles/blob/master/karabiner.config/karabiner.json
Turn off BT when locked to save battery: https://blog.krybot.com/a?ID=00950-accedada-7ebb-4010-857f-d1aaa9c7f293
URL dispatching: https://zzamboni.org/post/my-hammerspoon-configuration-with-commentary/
https://github.com/dbalatero/HyperKey.spoon
https://www.reddit.com/r/hammerspoon/comments/o289bq/how_to_remap_keys_for_a_specific_app/
custom palettes: https://tighten.com/blog/how-to-train-your-keyboard/
    ]]


-- *****************************************************************
-- Metadata
-- *****************************************************************
local screensavers = {
    {"Mandelbrot",     "/Users/cow/Library/Screen Savers/Mandelbrot.saver"},
    {"Hyperspace",     "/Users/cow/Library/Screen Savers/Hyperspace.saver"},
    {"MusaicFM",       "/Users/cow/Library/Screen Savers/MusaicFM.saver"},
    {"Skyrocket",      "/Users/cow/Library/Screen Savers/Skyrocket.saver"},
    {"Life Saver",     "/Users/cow/Library/Screen Savers/Life Saver.saver"},
    {"Helios",         "/Users/cow/Library/Screen Savers/Helios.saver"},
    {"Flux",           "/Users/cow/Library/Screen Savers/Flux.saver"},
    {"Ephemeral",      "/Users/cow/Library/Screen Savers/Ephemeral.saver"},
    {"Electric Sheep", "/Library/Screen Savers/Electric Sheep.saver"},
}

-- Stolen from https://gist.github.com/heptal/50998f66de5aba955c00
ampOnIcon = [[ASCII:
.....1a..........AC..........E
..............................
......4.......................
1..........aA..........CE.....
e.2......4.3...........h......
..............................
..............................
.......................h......
e.2......6.3..........t..q....
5..........c..........s.......
......6..................q....
......................s..t....
.....5c.......................
]]

ampOffIcon = [[ASCII:
.....1a.....x....AC.y.......zE
..............................
......4.......................
1..........aA..........CE.....
e.2......4.3...........h......
..............................
..............................
.......................h......
e.2......6.3..........t..q....
5..........c..........s.......
......6..................q....
......................s..t....
...x.5c....y.......z..........
]]

-- *****************************************************************
-- Shared functions
-- *****************************************************************
local function sendSystemKey(key)
    hs.eventtap.event.newSystemKeyEvent(key, true):post()
    hs.eventtap.event.newSystemKeyEvent(key, false):post()
end
local function randomiseScreensaver()
    local saver = screensavers[math.random(#screensavers)]
    local command = 'defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName -string "' .. saver[1] .. '" path -string "' .. saver[2] .. '" type -int 0'
    print("Executing screensaver rotate command: " .. command)
    hs.execute(command)
end
function snapTo(xOffsetFraction, yOffsetFraction, widthFraction, heightFraction)
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w * xOffsetFraction)
    f.y = max.y + (max.h * yOffsetFraction)
    f.w = max.w * widthFraction
    f.h = max.h * heightFraction
    win:setFrame(f)

end

local function snapFunction(x, y, widthFraction, heightFraction)
    return function()
        snapTo(x, y, widthFraction, heightFraction)
    end
end

-- *****************************************************************
-- Common functionality
-- *****************************************************************
local actions = {
    hello_world = function() hs.alert.show("Hello World!") end,

    screen = {
      lock = function() hs.caffeinate.startScreensaver() end,
      randomise_screensaver = randomiseScreensaver,
    },
    window = {
      -- Just delegate this to existing window manager
      full = function() hs.eventtap.keyStroke(hyper, "f") end,

      half_left            = snapFunction(  0,   0, 1/2,   1),
      half_right           = snapFunction(1/2,   0, 1/2,   1),

      half_top             = snapFunction(  0,   0,   1, 1/2),
      half_bottom          = snapFunction(  0, 1/2,   1, 1/2),

      third_left           = snapFunction(  0,   0, 1/3,   1),
      third_middle         = snapFunction(1/3,   0, 1/3,   1),
      third_right          = snapFunction(2/3,   0, 1/3,   1),

      twothird_left        = snapFunction(  0,   0, 2/3,   1),
      twothird_right       = snapFunction(1/3,   0, 2/3,   1),

      sixth_topleft        = snapFunction(  0,   0, 1/3, 1/2),
      sixth_topmiddle      = snapFunction(1/3,   0, 1/3, 1/2),
      sixth_topright       = snapFunction(2/3,   0, 1/3, 1/2),
      sixth_bottomleft     = snapFunction(  0, 1/2, 1/3, 1/2),
      sixth_bottommiddle   = snapFunction(1/3, 1/2, 1/3, 1/2),
      sixth_bottomright    = snapFunction(2/3, 1/2, 1/3, 1/2),

      quarter_topleft      = snapFunction(  0,   0, 1/2, 1/2),
      quarter_topright     = snapFunction(1/2,   0, 1/2, 1/2),
      quarter_bottomleft   = snapFunction(  0, 1/2, 1/2, 1/2),
      quarter_bottomright  = snapFunction(1/2, 1/2, 1/2, 1/2),
    },
    volume_up   = function() sendSystemKey("SOUND_UP") end,
    volume_down = function() sendSystemKey("SOUND_DOWN") end,
    volume_mute = function() sendSystemKey("MUTE") end,
}


-- *****************************************************************
-- Window management
-- *****************************************************************
hs.loadSpoon("MiroWindowsManager")
  
hs.window.animationDuration = 0.3
spoon.MiroWindowsManager:bindHotkeys({
    up = {hyper, "up"},
    right = {hyper, "right"},
    down = {hyper, "down"},
    left = {hyper, "left"},
    fullscreen = {hyper, "f"},
    nextscreen = {hyper, "n"}
})



absWindowBindings = {
    -- Left and right halves
    {"pad0",     {},        21,   actions.window.half_left},
    {nil,        {},        22,   actions.window.full},
    -- pad. doesn't work. Already bound?
    {"padenter", {},        23,   actions.window.half_right},

    -- quarters/vertical halves - shifted = upper half
    {nil,        {"shift"}, 24,   actions.window.quarter_topleft},
    {nil,        {"shift"}, 25,   actions.window.half_top},
    {nil,        {"shift"}, 26,   actions.window.quarter_topright},
    {nil,        {}       , 24,   actions.window.quarter_bottomleft},
    {nil,        {}       , 25,   actions.window.half_bottom},
    {nil,        {}       , 26,   actions.window.quarter_bottomright},

     -- Left, middle, and right thirds, full-height
    {"pad1",     {},        27,   actions.window.third_left},
    {"pad2",     {},        28,   actions.window.third_middle},
    {"pad3",     {},        29,   actions.window.third_right},
    -- Left, and right two-thirds, full-height
    -- pad/ doesn't work. Bound?
    {"pad*",     {"shift"}, 27,   actions.window.twothird_left},
    {nil,        {"shift"}, 28,   actions.window.full},
    {"pad-",     {"shift"}, 29,   actions.window.twothird_right},

    -- 6ths of window - top half = top row (7-9), bottom half = bottom row (4-6). e.g. 4 = bottom-left, 8 = top-center♭
    {"pad7",     {"shift"}, 30,   actions.window.sixth_topleft},
    {"pad8",     {"shift"}, 31,   actions.window.sixth_topmiddle},
    {"pad9",     {"shift"}, 32,   actions.window.sixth_topright},
    {"pad4",     {}       , 30,   actions.window.sixth_bottomleft},
    {"pad5",     {}       , 31,   actions.window.sixth_bottommiddle},
    {"pad6",     {}       , 32,   actions.window.sixth_bottomright},
}

for i, b in ipairs(absWindowBindings) do
    if (b[1] ~= nil) then
      print(b[1])
      hs.hotkey.bind(hyper, b[1], b[4])
      keyModal:bind({}, b[1], nil, b[4])
    end
end

DEBUG_TAP = true
mousetap = hs.eventtap.new({hs.eventtap.event.types.otherMouseUp}, function(event)
    if DEBUG_TAP then
        print("mouse tap debug got event:")
        print(hs.inspect.inspect(event:getRawEventData()))
        print(hs.inspect.inspect(event:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber)))
        print(hs.inspect.inspect(event:getFlags()))
        print(hs.inspect.inspect(event:systemKey()))
    end
    local button = event:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber) + 1
    if (button >= 21) then
        for i, b in ipairs(absWindowBindings) do
            if (event:getProperty(hs.eventtap.event.properties.mouseEventButtonNumber) + 1 == b[3] and event:getFlags():containExactly(b[2])) then
                print("Matched event: " .. hs.inspect.inspect(b[2]) .. " + button" .. b[3] .. "  ->  " .. hs.inspect.inspect(b[4]))
	        b[4]()
                return true
            end
        end
    end
    return false
end)
mousetap:start()




-- *****************************************************************
-- Debugging/system
-- *****************************************************************

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()


hs.hotkey.bind(hyper, "W", actions.hello_world)
-- Not working?
hs.hotkey.bind(hyper, "pad/", function()
  hs.alert.show("Hello pad/")
end)
-- Not working?
hs.hotkey.bind(hyper, "/", function()
  hs.alert.show("Hello /")
end)
-- Not working? Why?
hs.hotkey.bind(hyper, "[", function()
  hs.alert.show("Hello [")
end)




-- *****************************************************************
-- Screen/display management
-- *****************************************************************

hs.hotkey.bind(hyper, "L", actions.screen.lock)


function caffeinateCallback(eventType)
    if (eventType == hs.caffeinate.watcher.screensDidSleep) then
      print("screensDidSleep")
    elseif (eventType == hs.caffeinate.watcher.screensDidWake) then
      print("screensDidWake")
    elseif (eventType == hs.caffeinate.watcher.screensDidLock) then
      print("screensDidLock")
      --bluetoothSwitch(0)
    elseif (eventType == hs.caffeinate.watcher.screensDidUnlock) then
      print("screensDidUnlock")
      randomiseScreensaver()
      --bluetoothSwitch(1)
    end
end
caffeinateWatcher = hs.caffeinate.watcher.new(caffeinateCallback)
caffeinateWatcher:start()




-- caffeine replacement
local caffeine = hs.menubar.new()

function setCaffeineDisplay(state)
    if state then
        caffeine:setIcon(ampOnIcon)
    else
        caffeine:setIcon(ampOffIcon)
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

hs.hotkey.bind(hyper, "Z", function()
    caffeineClicked()
  end)











-- *****************************************************************
-- Unsorted
-- *****************************************************************


hs.hotkey.bind({}, "f14", actions.screen.randomise_screensaver)



hs.hotkey.bind({}, "F20", actions.volume_mute)

  hs.hotkey.bind({"ctrl"}, "F20", function()
    hs.alert.show("shift-mute!")
  end)


  --[[
k = hs.hotkey.modal.new({})
k:bind({}, 'f', nil, function() hs.eventtap.keyStroke(hyper, 'f') end)

pressedModalHyper = function()
    k.triggered = false
    k:enter()
end
  
  -- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
  --   send ESCAPE if no other keys are pressed.
  releasedModelHyper = function()
    k:exit()
    if not k.triggered then
      hs.eventtap.keyStroke({}, 'ESCAPE')
    end
  end
  
  -- Bind the Hyper key
  f17 = hs.hotkey.bind({}, 'F18', pressedModalHyper, releasedModalHyper)
]]
  

  hs.hotkey.bind(hyper, "5", function()
    hs.eventtap.keyStroke({}, 0x5d)
  end)
  hs.hotkey.bind(hyper, "6", function()
    hs.eventtap.keyStroke({}, 0x5e)
  end)
  hs.hotkey.bind(hyper, "7", function()
    hs.eventtap.keyStroke({}, 0x5f)
  end)




hs.hotkey.bind(hyper, "M", function()
    local a, b, c = hs.http.doRequest("http://localhost:8249/toggle-mute", "POST", nil, {
        ["x-mutesync-api-version"] = "1",
        ["Authorization"] = "Token JHSKISRHJFKRQAIU",
        }) 
    local j = hs.json.decode(b)
    if j["data"]["in_meeting"] then
        if j["data"]["muted"] then
            hs.alert.show("Microphone MUTED", {textColor = { red = 1 }})
        else
            hs.alert.show("Microphone LIVE", {textColor = { green = 1 }})
        end
    else
        hs.alert.show("Not in meeting")
    end
end)  
            
  --[[
caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
    if state then
        caffeine:setTitle("AWAKE")
    else
        caffeine:setTitle("SLEEPY")
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end
]]



  hs.loadSpoon("Emojis")
  
  hs.window.animationDuration = 0.3
  spoon.Emojis:bindHotkeys({
    toggle = {hyper, "j"},
  })




-- From https://github.com/heptal/dotfiles/blob/master/roles/hammerspoon/files/init.lua
  hs.fnutils.each({
    { key = "t", app = "iTerm" },
    { key = "e", app = "Sublime Text" },
    { key = "c", app = "Google Chrome" },
    { key = "s", app = "Slack" },
    { key = "=", app = "Google Meet" },
    { key = "a", app = "Home Assistant" },
  }, function(item)

    local appActivation = function()
      hs.application.launchOrFocus(item.app)

      local app = hs.appfinder.appFromName(item.app)
      if app then
        app:activate()
        app:unhide()
      end
    end

    hs.hotkey.bind(hyper, item.key, appActivation)
  end)

    
Install:andUse("WindowScreenLeftAndRight",
{
  config = {
    animationDuration = 0.3
  },
  hotkeys = {
     screen_left = { hyper, "pageup" },
     screen_right= { hyper, "pagedown" },
  },
--                 loglevel = 'debug'
}
) 

Install:andUse("KSheet",
               {
                 hotkeys = {
                   toggle = { hyper, "'" }
}})

Install:andUse("Seal",
               {
                 hotkeys = { show = { hyper, "space" } },
                 fn = function(s)
                   s:loadPlugins({"apps", "calc",
                                  "screencapture", "useractions"})
--[[                   s.plugins.safari_bookmarks.always_open_with_safari = false
                   s.plugins.useractions.actions =
                     {
                         <<useraction-definitions>>
                     }]]
                   s:refreshAllCommands()
                 end,
                 start = true,
               }
)

 
-- All stolen from https://github.com/snowe2010/dotfiles
Install:andUse("RecursiveBinder", {
    fn = function(s)
        -- Curried function so it isn't called immediately
        id = function(id) return function () hs.application.launchOrFocusByBundleID(id) end end

        app_keymap = {
            [s.singleKey('s', 'Slack')] = id('com.tinyspeck.slackmacgap'),
            [s.singleKey('c', 'Google Chrome')] = id('com.google.Chrome'),
            [s.singleKey('d', 'Discord')] = id('com.hnc.Discord'),
            [s.singleKey('t', 'iTerm')] = id('com.googlecode.iterm2'),
            [s.singleKey('l', 'Sublime Text')] = id('com.sublimetext.3'),
--    { key = "=", app = "Google Meet" },

        }
        --hs.hotkey.bind('alt', 'f', s.recursiveBind(app_keymap))

        resize_keymap = {
            [s.singleKey('f', 'fullscreen')] = function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("fullscreen") end,
            [s.singleKey('h', 'Lefthalf of Screen')] = function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfleft") end,
            [s.singleKey('l', 'Righthalf of Screen')] = function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfright") end,
            [s.singleKey('space', 'super fulls creen')] = function() 
                local win = window.focusedWindow()
                -- println(win)
                if win ~= nil then
                    win:setFullScreen(not win:isFullScreen())
                end
            end,
        }
        --hs.hotkey.bind('alt', 'r', s.recursiveBind(resize_keymap))

        tools_keymap = {
            [s.singleKey('h', 'hammerspoon console')] = function() hs.toggleConsole() end,
            [s.singleKey('v', 'paste unblocker')] = function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end,
            --[s.singleKey('s', 'spotify song')] = function() hs.spotify.displayCurrentTrack() end,
            --[s.singleKey('p', 'pastebin')] = function() spoon.Pastebin:paste() end,
            --[s.singleKey('h', 'hotspot')] = function() spoon.PersonalHotspot:toggle() end,
            --[s.singleKey('u', 'trigger notification')] = function() hs.notify.new({title = 'Break Time', informativeText = "TAKE A BREAK!!!", autoWithdraw = false, withdrawAfter = 0}):send() end,
            [s.singleKey('g', 'email signature')] = function() 
                sig = [[
Paul Cowan
paul@mailcow.com]] 
                hs.pasteboard.writeObjects(sig)
                hs.eventtap.keyStroke("cmd", "v")
            end,
            [s.singleKey('n', 'notifications')] = {
                [s.singleKey('a', 'dismiss all')] = function() 
                hs.osascript.applescript(
                    string.format(
                    [[
                    tell application "System Events" to tell process "Notification Center"
                        click button 1 in every window
                    end tell
                    ]]
                    )
                )
                end,
                [s.singleKey('s', 'click secondary')] = function()
                    hs.osascript.applescript(
                        string.format(
                            [[
                            tell application "System Events" to tell process "Notification Center"
                                try
                                    click button 2 of last item of windows
                                end try
                            end tell
                        ]]
                        )
                    )
                end
            }
        }
        --hs.hotkey.bind('alt', 't', s.recursiveBind(tools_keymap))
        
        bookmarks_keymap = {}
        --hs.hotkey.bind('alt', 'b', s.recursiveBind(bookmarks_keymap))

        keymap = {
            [s.singleKey('b')] = bookmarks_keymap,
            [s.singleKey('q', 'find+')] = {
                [s.singleKey('D', 'Desktop')] = function() openWithFinder('~/Desktop') end,
                [s.singleKey('d', 'Download')] = function() openWithFinder('~/Downloads') end,
                [s.singleKey('a', 'Application')] = function() openWithFinder('~/Applications') end,
                [s.singleKey('h', 'home')] = function() openWithFinder('~') end,
            },
            [s.singleKey('t', 'tools+')] = tools_keymap,
            [s.singleKey('a', 'apps+')] = app_keymap,
            [s.singleKey('r', 'resize+')] = resize_keymap,
        }

        hs.hotkey.bind('alt', 'q', s.recursiveBind(keymap))
    end
})

-- Stolen from https://tighten.com/blog/how-to-train-your-keyboard/
--[[hs.loadSpoon('Hyper')
hs.loadSpoon('Helpers')
 
slack = 'com.tinyspeck.slackmacgap'
 
hyper:app(slack)
    :action('open', {
        default = combo({'cmd'}, 'k'),
    })
 
hyper:app('fallback')
    :action('open', {
        default = combo({'cmd'}, 'p'),
    })
]]

hs.loadSpoon("AppBindings")
spoon.AppBindings:bind('Slack', {
--  |----FROM----| |------TO------|
--  |meta  ,  key| |meta   ,  key |
  { hyper, '\\', {'cmd'}, 'k' },
})
spoon.AppBindings:bind('Sublime Text', {
  { hyper, '\\', {'cmd'}, 'p' },
})
spoon.AppBindings:bind('Discord', {
  { hyper, '\\', {'cmd'}, 'k' },
})



-- MPD_COMMANDS = {PLAY = "toggle"; FAST = "next"; REWIND = "prev"}
-- AIRFOIL_EVENTS = {SOUND_UP = "+", SOUND_DOWN = "-"}
tap = hs.eventtap.new({hs.eventtap.event.types.NSSystemDefined}, function(event)
    print("event tap debug got event!")
    if DEBUG_TAP then
        print("event tap debug got event:")
        print(hs.inspect.inspect(event:getRawEventData()))
        print(hs.inspect.inspect(event:getFlags()))
        print(hs.inspect.inspect(event:systemKey()))
    end
    local sys_key_event = event:systemKey()
    local delete_event = false
    if not sys_key_event or not sys_key_event.down then
        return false
    end
--[[    elseif MPD_COMMANDS[sys_key_event.key] and not sys_key_event['repeat']
    then
        print("received media event, calling as-mpc")
        hs.execute("~/bin/as-mpc " .. MPD_COMMANDS[sys_key_event.key])
    elseif AIRFOIL_EVENTS[sys_key_event.key] and event:getFlags().ctrl then
        hs.osascript.applescript(script)
        delete_event = true
    end
    return delete_event
    ]]--
end)
tap:start()

keytap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    --print("key tap debug got event!")
    local key = event:getKeyCode()
    if (key == 176) then
      print("Dictation Key")
      return true
    elseif (key == 160) then
      print("Expose Key")
      return true
    elseif (key == 129) then
      print("Search Key")
      return true
    elseif (key == 179) then
      print("Emoji Key")
      return false
    end
    keymap = hs.keycodes.map[key]
    if keymap ~= nil then
      -- print("Got key " .. keymap)
      return false
    end
    print("Unknown key with keycode: " .. key)
    return false
end)
keytap:start()


for i, b in ipairs(modalToHyperPassthrough) do
    print(b)
    keyModal:bind({}, b, nil, function()
            hs.eventtap.keyStroke(hyper, b)
    end)
end

for i, b in ipairs(modalToHyperComplexPassthrough) do
    keyModal:bind({}, b, function()
        hs.eventtap.event.newKeyEvent(hs.keycodes.map.shift, true):post()
        hs.eventtap.event.newKeyEvent(hs.keycodes.map.alt, true):post()
        hs.eventtap.event.newKeyEvent(hs.keycodes.map.ctrl, true):post()
        hs.eventtap.event.newKeyEvent(hs.keycodes.map.cmd, true):post()
        hs.eventtap.event.newKeyEvent(b, true):post()
      end, function()
        hs.eventtap.event.newKeyEvent(b, false):post()
        hs.eventtap.event.newKeyEvent(hs.keycodes.map.shift, false):post()
        hs.eventtap.event.newKeyEvent(hs.keycodes.map.alt, false):post()
        hs.eventtap.event.newKeyEvent(hs.keycodes.map.ctrl, false):post()
        hs.eventtap.event.newKeyEvent(hs.keycodes.map.cmd, false):post()
      end)
end

