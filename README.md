# telegram-offloarder
A small ruby script to offload files from saved messages in telegram

## usage

Launch `telegram-cli` with number mode and an open socket:
```
telegram-cli -N -S /tmp/tg1
```

Launch the offloader in a seperate terminal:
```
ruby main.rb
```

The ruby script will identify the current user (you) and will download messages from that user (your messages to yourself). Input any number - that amount of messages will be offloaded, starting from latest. Offloading occures in the `/home/.telegram-cli/downloads` folder and will include photos and videos. Audio messages usually don't work as well as older files (this is due to `telegram-cli` using an outdated API). After download starts you may immidiatly delete the messages from the chat - the download will finish regardless.
