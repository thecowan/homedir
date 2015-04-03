clementine_widget = widget({ type = "textbox", name = "clementine_playing", align = "right" })

function update_now_playing(widget)
    local fd = io.popen("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 PlaybackStatus")
    local status = fd:read("*all")
    fd:close()

    if status == '' then
	widget.text = 'Not running'
    elseif string.find(status, "Stopped", 1, true) then
        widget.text = status
    else
        local paused = string.find(status, "Paused", 1, true)
        fd = io.popen("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get org.mpris.MediaPlayer2.Player Metadata")
        local metadata = fd:read("*all")
        fd:close()
        widget.text = "Playing: " 
        -- widget.text = metadata
    end

    -- 9085  2012-12-04 13:40:53 DISPLAY=:0 
    -- 9086  2012-12-04 13:41:17 DISPLAY=:0 qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 
    -- 9087  2012-12-04 13:41:27 DISPLAY=:0 qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 GetMetadata
    -- 9088  2012-12-04 13:42:01 DISPLAY=:0 qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 
    -- 9089  2012-12-04 13:42:10 DISPLAY=:0 qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 GetMetadata
end

update_now_playing(clementine_widget)
awful.hooks.timer.register(1, function () update_now_playing(clementine_widget) end)
