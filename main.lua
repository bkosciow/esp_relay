gpio.mode(CHANNEL_0, gpio.OUTPUT, gpio.PULLUP)
gpio.mode(CHANNEL_1, gpio.OUTPUT, gpio.PULLUP)

svr = net.createServer(net.UDP)

svr:on("receive", function(socket, message)

    function validateMessage(json)                
        if json == nil or json['protocol'] ~= PROTOCOL or type(json['targets']) ~= 'table' then
            return false
         end    

         isTarget = false
         for k,v in pairs(json['targets']) do
            if v == NODE_ID then isTarget = true end
         end
    
        return isTarget
    end
    
    function decodeMessage(message)        
        ok, json = pcall(cjson.decode, message)
        if not ok or not validateMessage(json) then
            json = nil
        end
        
        return json
    end
    
    message = decodeMessage(message)

    if message['event'] ~= nil then
        print(message['event'])
        if message['event'] == "channel1.on" then
            gpio.write(CHANNEL_0, gpio.LOW)
        elseif message['event'] == "channel2.on" then
            gpio.write(CHANNEL_1, gpio.LOW)
        elseif message['event'] == "channel1.off" then
            gpio.write(CHANNEL_0, gpio.HIGH)
        elseif message['event'] == "channel2.off" then
            gpio.write(CHANNEL_1, gpio.HIGH)
        end
    end
    
end)

svr:listen(5053)    

