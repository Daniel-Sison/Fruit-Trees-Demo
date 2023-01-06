

local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local materials = RS:WaitForChild("Materials")


local Fruit = {}
Fruit.__index = Fruit


-- Allows the player to equip the fruit given
function Fruit:Equip(player, item)
	local tool = materials:FindFirstChild(item.Name)
	if tool then
		tool = tool:Clone()

		local sound = materials.EatingSound:Clone()
		sound.Parent = tool:WaitForChild("Handle")

		tool.Parent = player.Backpack

		-- This block of code runs when the player activates the tool
		tool.Activated:Connect(function()
			tool.Enabled = false
			if sound then
				sound:Play()
				sound.Ended:Connect(function()
					-- Destroys tool and removes fruit when sound is finished.
					tool:Destroy()
					player.leaderstats.Fruit.Value = player.leaderstats.Fruit.Value - 1
				end)
			end
		end)

		player.leaderstats.Fruit.Value = player.leaderstats.Fruit.Value + 1
	else
		warn("There is no tool of this fruit name.")
		return nil
	end

	if item then item:Destroy() end
end


-- Setup fruit
function Fruit.new(fruitName, leaves)
	local newFruit = {}
	setmetatable(newFruit, Fruit)

	local target = materials:FindFirstChild(fruitName)
	if target == nil then
		warn("No fruit of this name exists!")
		return
	end

	local fruit = target.Handle:Clone()
	fruit.Name = fruitName

	local interact = materials.ProximityPrompt:Clone()
	interact.ActionText = "Collect"
	interact.ObjectText = fruitName
	interact.Parent = fruit

	local x = leaves.Size.X / 2
	local y = leaves.Size.Y / 2
	local z = leaves.Size.Z / 2

	fruit.Position = leaves.Position + Vector3.new(math.random(-x, x), math.random(-y, y), math.random(-z, z))
	fruit.Parent = workspace

	newFruit.Body = fruit
	newFruit.Interact = interact

	return newFruit
end


return Fruit