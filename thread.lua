channel = love.thread.getChannel("action")
syncNode = 'http://ceriat.net/krist/'
http = require "socket.http"
repeat
	address = channel:pop()
until address ~= nil

while true do
	channel = love.thread.getChannel("action")
	action = channel:pop()
	if action ~= nil then
		if action == "balance" then
			channel = love.thread.getChannel("balance")
			url = syncNode .. '?getbalance=' .. address
			body,c,l,h = http.request(url)
			balance = tonumber(body)
			channel:supply(balance)
		elseif action == "transactions" then
			channel = love.thread.getChannel("transactions")
			url = syncNode .. '?listtx=' .. address
			body,c,l,h = http.request(url)
			channel:supply(body)
			body = nil
		elseif action == "names" then
			channel = love.thread.getChannel("names")
			url = "http://ceriat.net/krist/?listnames= .. address"
			body,c,l,h = http.request(url)
			if body == "Error4" then
				body = 0
			end
			channel:supply(body)
			body = nil
		end
	end
end
