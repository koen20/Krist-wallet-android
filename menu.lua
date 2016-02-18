button = {}

function button_spawn(x,y,text,action)
	table.insert(button, {x = x,y = y,text = text,action = action})
end

function button_draw()
	for i,v in ipairs(button) do
		if page ~= 0 then
			love.graphics.setFont(large)
			love.graphics.print(v.text,v.x,v.y)
		end
	end
end
function button_click(x,y)
	for i,v in ipairs(button) do
		if x > v.x and 
		x < v.x + large:getWidth(v.text) and
		y > v.y and
		y < v.y + large:getHeight(v.text) then
			if page ~= 0 then
				if v.action == "transactions" then
					page = 2
				elseif v.action == "overview" then
					page = 1
				elseif v.action == "transfer" then
					page = 3
					love.keyboard.setTextInput(true)
				elseif v.action == "refresh" then
					tim = 2000
				elseif v.action == "economicon" then
					page = 4
				elseif v.action == "domain" then
					page = 5
				end
			end
		end
	end
end
