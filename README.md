#Relay controlled via ESP8266

This is a simple software for ESP 8266 to control 2 relay module. On ESP we start an UDP server and listen to broadcasted packages.
 
Such package is an JSON message:
 
    {
        protocol: "iot:1",
        event: "channel1.on",
        node: "computer",
        targets: [
            "big-room-support-light"
        ]
    }
 
Supported events:

 - channel1.on
 - channel2.on
 - channel1.off
 - channel2.off
 
  
[Read more on blog](https://koscis.wordpress.com/2016/12/04/relay-and-esp8266-part-1/)

## files
- init.lua - run automatically
- parameters.lua - project configuration (AP login and password)
- parameters-device.lua - this unit configuration (like node name)
- wifi-init.lua - WiFi connection and keep alive timer
- main.lua - main code for app

More about [nodemcu boilerplate](https://github.com/bkosciow/nodemcu_boilerplate)

## setup
copy parameters.dist.lua to parameters.lua

copy parameters-device.dist.lua to parameters-device.lua

In parameters.lua set access point login. 

In parameters-device.lua set node name (see targets in JSON message).

## how to use
Proper client in progress, here is sample in python that can send broadcast packages. It send randomized message

    import socket
    import random
    import json
    import time
    
    address = ('<broadcast>', 5053)
    
    events = [
        "channel1.on",
        "channel1.off",
        "channel2.on",
        "channel2.off",
    ]
    
    packet = {
        "protocol": "iot:1",
        "node": "computer",
        "targets": [
            "big-room-support-light",
            "big-room-main-light"
        ]
    }
    
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
    
    while True:
        packet["event"] = random.choice(events)
        msg = json.dumps(packet)
        if random.randint(1,100) > 90:
            msg += "fault"
    
        print("send", msg)
        s.sendto(msg.encode(), address)
        time.sleep(3)


Read more on my blog
