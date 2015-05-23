require "login"
require "menu"

http = require "socket.http"

function love.load()
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
	syncNode = 'http://ceriat.net/krist/'
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
		love.graphics.print("please login using your password",1,1)
		love.graphics.print(input,1,30)
	elseif page == 1 then -- overview
		love.graphics.print("Balance: " .. balance .. "kst",200,1)
		love.graphics.print("Address: " .. address,200,50)

	elseif page == 2 then --transactions
		love.graphics.print("Showing last 20 transactions for "..address,200,1)
		for i,v in ipairs(transactions) do
			love.graphics.print(v.date.." "..v.thing.." "..v.amount,xg,v.y)
		end
	elseif page == 3 then -- transfer
		love.graphics.print("Please enter the recipient.",200,1)
		love.graphics.print(input,200,50)
	elseif page == 3.1 then
		love.graphics.print("Please enter the amount to send.",200,1)
		love.graphics.print(input,200,50)
	elseif page == 4 then
		for i,v in ipairs(top) do
			love.graphics.print(v.tx.."   "..v.date.." "..v.peer.." "..v.amount,xg,v.y)
		end
	elseif page == 5 then
		for i,v in ipairs(names) do
			love.graphics.print(v.name,xg,v.y)
		end
	end
end

function love.mousepressed(x,y)
	button_click(x,y)
end