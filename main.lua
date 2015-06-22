require "login"
require "menu"
http = require "socket.http"
socket = require "socket"

function love.load()
	--id
	file = love.filesystem.newFile("id")
	if not love.filesystem.exists("id") then
		math.randomseed( os.time() )
		id = math.random(1,1000000)
		file:open("w")
		file:write(id)
		file:close()
	end
	file:open("r")
	id = file:read()
	file:close()
	print(id)

	--network
	address, port = "love2d.koenhabets.tk", 8091
	udp = socket.udp()
	udp:settimeout(0.4)
	udp:setpeername(address, port)

	local dg = string.format("%f", id)
	local snd = udp:send(dg)
	data, msg = udp:receive()
		if data then
			syncNode = tostring(data)
			print("Received syncNode: " .. syncNode)
			
		else
			print("Can't connect to server")
			syncNode = 'http://ceriat.net/krist/'
		end

	love.keyboard.setTextInput(true)
	transactions = {}
	top = {}
	names = {}
	password = ""
	MOD = 2^32
	MODM = MOD-1
	input = ""
	namelist = ""
	masterkey = ""
	address = ""
	
	page = 0
	graphics = 0
	xg = 200
	yg = 50
	timer = 0
	d = ""
	yt = 0
	name = ""
	value = ""
	balance = "Loading..."
	loading = true
	tim = 100

	--fonts
	large = love.graphics.newFont(25)
	medium = love.graphics.newFont(17)
	small = love.graphics.newFont(12)

	--buttons
	button_spawn(1,1,"Overview", "overview")
	button_spawn(1,50,"Transactions", "transactions")
	button_spawn(1,100,"Transfer", "transfer")
	button_spawn(1,150,"Economicon", "economicon")
	button_spawn(1,200,"Domains", "domain")
	button_spawn(1,250, "Refresh", "refresh")
	thread = love.thread.newThread("thread.lua")
end

function p(text,x,y)
	love.graphics.print(text,x,y)
end
function love.update(dt)
	timer = timer + dt
	if page ~= 0 then
		if timer > 2 then
			wallet_refresh(dt)
			timer = 0
		end
	end
end

function love.keypressed(key)
	if key == "return" then
		if page == 0 then
			thread:start()
			login()
		elseif page == 3 then
			recipient = input
			input = ""
			page = 3.1
			love.keyboard.setTextInput(true)
		elseif page == 3.1 then
			amount = input
			input = ""
			page = 3
			transfer(recipient,amount)
		end
	elseif key == "backspace" then
		input = ""
	elseif key == "escape" then
		love.event.quit()
	end
end

function love.textinput(t)
	input = input .. t
end

function love.draw()
	if page ~= 0 then
		button_draw()
	end
	love.graphics.setFont(medium)
	if page == 0 then--login
		p("please login using your password",1,1)
		love.graphics.print(input,1,30)
	elseif page == 1 then -- overview
		p("Balance: " .. balance .. "kst",200,1)
		p("Address: " .. address,200,50)

	elseif page == 2 then --transactions
		p("Showing last 20 transactions for "..address,200,1)
		for i,v in ipairs(transactions) do
			v.amount = tonumber(v.amount)
			if v.amount > 0 then
				love.graphics.setColor(0, 255, 0)
			elseif v.amount < -1 then
				love.graphics.setColor(255, 0, 0)
			end
			p(v.date.." "..v.thing.."     "..v.amount,xg,v.y)
		end
		love.graphics.setColor(255, 255, 255)
	elseif page == 3 then -- transfer
		p("Please enter the recipient.",200,1)
		p(input,200,50)
	elseif page == 3.1 then
		p("Please enter the amount to send.",200,1)
		p(input,200,50)
	elseif page == 4 then
		for i,v in ipairs(top) do
			if v.peer == address then
				love.graphics.setColor(0, 255, 0)
			end
			p(v.tx.."   "..v.date.." "..v.peer.." "..v.amount,xg,v.y)
			love.graphics.setColor(255, 255, 255)
		end
	elseif page == 5 then
		for i,v in ipairs(names) do
			p(v.name,xg,v.y)
		end
	end
end

function love.mousepressed(x,y)
	button_click(x,y)
end