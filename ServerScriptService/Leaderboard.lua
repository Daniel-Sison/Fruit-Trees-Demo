

-- This function runs when a player joins.
local function onPlayerJoin(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
 
	local stat = Instance.new("IntValue")
	stat.Name = "Fruit"
	stat.Value = 0
	stat.Parent = leaderstats
end

game.Players.PlayerAdded:Connect(onPlayerJoin)
