

local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")


local classes = RS:WaitForChild("Classes")
local materials = RS:WaitForChild("Materials")


local Tree = {}
Tree.__index = Tree

-- Disables the prompt
function Tree:Disable(interact)
	interact.Enabled = false
end

-- Enables the prompt
function Tree:Enable(interact)
	interact.Enabled = true
end


-- Drops fruit
function Tree:DropFruit(fruitName, leaves, amount)
	local Fruit = require(classes.Fruit)

	for i = 1, amount do
		local newFruit = Fruit.new(fruitName, leaves)
		newFruit.Interact.Triggered:Connect(function(player)
			newFruit:Equip(player, newFruit.Body)
		end)
		wait(0.2)
	end
end


-- Give the function the leaves and the tiltAmount as parameters.
-- 0.12 is a small tilt, while 0.3 is a larger tilt.
function Tree:Shake(leaves, tiltAmount)
	local savedCFrame = leaves.CFrame
	local position = leaves.Position
	local halfHeight = leaves.Size.Y / 2

	local x = 0
	local z = 0
	local tilt = -99999

	for i = 1, 80 do
		x = position.x + (math.sin(tilt + (position.x/5)) * math.sin(tilt/9))/3
		z = position.z + (math.sin(tilt + (position.z/6)) * math.sin(tilt/12))/4
		local targetCFrame = CFrame.new(x, position.y, z) * CFrame.Angles((z-position.z)/halfHeight, 0, (x-position.x)/-halfHeight)
		
		leaves.CFrame = targetCFrame
		task.wait()
		tilt = tilt + tiltAmount
	end
	
	-- After tree is done shaking, this tween allows the tree to move back to 
	-- the same position it originally was in.
	
	local tweenInfo = TweenInfo.new(
		1, -- Time
		Enum.EasingStyle.Quad, -- EasingStyle
		Enum.EasingDirection.Out, -- EasingDirection
		0, -- RepeatCount (when less than zero the tween will loop indefinitely)
		false, -- Reverses (tween will reverse once reaching it's goal)
		0 -- DelayTime
	)

	local tween = TweenService:Create(leaves, tweenInfo, {CFrame = savedCFrame})
end


-- Setup tree. 
-- To use, insert the model as a parameter and the script will set it up.
-- Define the cooldown time of the tree in the second parameter.
function Tree.new(model, coolDownTime)
	local newTree = {}
	setmetatable(newTree, Tree)

	newTree.Model = model
	newTree.Trunk = model.Structure:FindFirstChild("Trunk")
	newTree.Leaves = model.Structure:FindFirstChild("Leaves")
	newTree.Settings = model:FindFirstChild("Settings")

	newTree.Cooldown = newTree.Settings:FindFirstChild("Cooldown")
	newTree.Cooldown.Value = coolDownTime
	newTree.MaxCooldown = coolDownTime

	local interact = materials.ProximityPrompt:Clone()
	interact.Parent = newTree.Trunk
	newTree.Interact = interact

	newTree.Settings.HasBeenSetup.Value = true

	return newTree
end


return Tree