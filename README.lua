local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local BanData = DataStoreService:GetDataStore("BanList")

local function isBanned(userId)
	local success, result = pcall(function()
		return BanData:GetAsync(tostring(userId))
	end)
	if success then
		return result == true
	else
		warn("Banチェック失敗:", result)
		return false
	end
end

local function setBan(userId, state)
	pcall(function()
		BanData:SetAsync(tostring(userId), state)
	end)
end

Players.PlayerAdded:Connect(function(player)
	if isBanned(player.UserId) then
		player:Kick("You are banned from this game.")
		return
	end

	player.Chatted:Connect(function(message)
		local msg = message:lower()

		-- kick all
		if msg == "!kick all" then
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= player then
					p:Kick("You have been kicked.")
				end
			end

		-- kick 名前
		elseif msg:sub(1,6) == "!kick " then
			local name = message:sub(7)
			for _, p in pairs(Players:GetPlayers()) do
				if p.Name:lower() == name:lower() and p ~= player then
					p:Kick("You have been kicked.")
					break
				end
			end

		-- ban all
		elseif msg == "!ban all" then
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= player then
					setBan(p.UserId, true)
					p:Kick("You have been banned.")
				end
			end

		-- ban 名前
		elseif msg:sub(1,5) == "!ban " then
			local name = message:sub(6)
			for _, p in pairs(Players:GetPlayers()) do
				if p.Name:lower() == name:lower() and p ~= player then
					setBan(p.UserId, true)
					p:Kick("You have been banned.")
					break
				end
			end

		-- unban all
		elseif msg == "!unban all" then
			local pages
			local success, err = pcall(function()
				pages = BanData:ListKeysAsync()
			end)
			if success then
				while true do
					for _, keyInfo in pairs(pages:GetCurrentPage()) do
						setBan(keyInfo.KeyName, false)
					end
					if pages.IsFinished then break end
					pages:AdvanceToNextPageAsync()
				end
			else
				warn("unban all失敗:", err)
			end

		-- unban 名前
		elseif msg:sub(1,7) == "!unban " then
			local name = message:sub(8)
			for _, p in pairs(Players:GetPlayers()) do
				if p.Name:lower() == name:lower() then
					setBan(p.UserId, false)
					break
				end
			end

		-- kill all
		elseif msg == "!kill all" then
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= player then
					local char = p.Character
					if char and char:FindFirstChild("Humanoid") then
						char.Humanoid.Health = 0
					end
				end
			end

		-- kill 名前
		elseif msg:sub(1,6) == "!kill " then
			local name = message:sub(7)
			for _, p in pairs(Players:GetPlayers()) do
				if p.Name:lower() == name:lower() and p ~= player then
					local char = p.Character
					if char and char:FindFirstChild("Humanoid") then
						char.Humanoid.Health = 0
					end
					break
				end
			end

		-- freeze all
		elseif msg == "!freeze all" then
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= player then
					local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
					if hrp then
						hrp.Anchored = true
					end
				end
			end

		-- freeze 名前
		elseif msg:sub(1,8) == "!freeze " then
			local name = message:sub(9)
			for _, p in pairs(Players:GetPlayers()) do
				if p.Name:lower() == name:lower() and p ~= player then
					local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
					if hrp then
						hrp.Anchored = true
					end
					break
				end
			end

		-- unfreeze all
		elseif msg == "!unfreeze all" then
			for _, p in pairs(Players:GetPlayers()) do
				local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
				if hrp then
					hrp.Anchored = false
				end
			end

		-- unfreeze 名前
		elseif msg:sub(1,10) == "!unfreeze " then
			local name = message:sub(11)
			for _, p in pairs(Players:GetPlayers()) do
				if p.Name:lower() == name:lower() then
					local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
					if hrp then
						hrp.Anchored = false
					end
					break
				end
			end

		-- speed all 数字
		elseif msg:sub(1,10) == "!speed all" then
			local speed = tonumber(message:sub(12))
			if speed then
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= player then
						local hum = p.Character and p.Character:FindFirstChild("Humanoid")
						if hum then
							hum.WalkSpeed = speed
						end
					end
				end
			end

		-- speed 名前 数字
		elseif msg:sub(1,7) == "!speed " then
			local args = message:split(" ")
			local name = args[2]
			local speed = tonumber(args[3])
			if name and speed then
				for _, p in pairs(Players:GetPlayers()) do
					if p.Name:lower() == name:lower() and p ~= player then
						local hum = p.Character and p.Character:FindFirstChild("Humanoid")
						if hum then
							hum.WalkSpeed = speed
						end
						break
					end
				end
			end
		end
	end)
end)
