local fd = io.popen("qdbus org.mpris.MediaPlayer2.clementine /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get org.mpris.MediaPlayer2.Player Metadata")
local metadata = fd:read("*all")
fd:close()
for s in metadata:gmatch("[^ ]+: .*$") do
    print (s)
end
