
local RS = game:GetService("ReplicatedStorage")
local classes = RS:WaitForChild("Classes")


local shakeableTrees = workspace:WaitForChild("ShakableTrees")

--[[
	You can change these variables to change how the trees act.
	
	If you want to change the settings of a SPECIFIC tree,
	you must do so when you initate the object.
]]

local treeCooldown = 10
local treeShakeAmount = 0.3
local fruitDropAmount = 3
local fruitType = "Apple" -- The only other fruit right now is "Banana"


-- This function is called whenever a new tree is set up.
function setupTree(model)
	local Tree = require(classes.Tree)
	
	local newTree = Tree.new(model, treeCooldown)
	
	-- This is what will run when the ProximityPrompt of the tree is triggered.
	newTree.Interact.Triggered:Connect(function(player)
		newTree:Disable(newTree.Interact) -- Disable prompt from being triggered during animation.
		
		newTree:Shake(newTree.Leaves, treeShakeAmount)
		newTree:DropFruit(fruitType, newTree.Trunk, fruitDropAmount)
		
		wait(newTree.MaxCooldown)
		newTree:Enable(newTree.Interact)
	end)
end


-- Iterates through all children in "ShakableTrees" folder.
-- If the function finds a tree with "HasBeenSetup" == false, then it will set up the tree.
function updateTrees()
	local tree = shakeableTrees:GetChildren()
	for i = 1, #tree do
		if tree[i]:FindFirstChild("Settings") then
			if tree[i].Settings.HasBeenSetup.Value == false then
				setupTree(tree[i])
			end
		end
	end
end


--[[
	Any trees added while game is running will be set up.
	
	If a tree is aded DURING a game, it MUST be cloned from REPLICATEDSTORAGE
	and NOT the Workspace.
]]

shakeableTrees.ChildAdded:Connect(updateTrees)

-- Run the function at the start of the game to setup trees.
updateTrees()