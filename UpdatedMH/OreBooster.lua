--[[
    Dear person who is reading this,at the time i was making this code
    only god and i knew what it does.
    Now only god knows,good luck.
]]


local Resetters = {
    ["Daestrophe"] = true,
    ["The Final Upgrader"] = true,
    ["Tesla Refuter"] = true,
    ["Void Star"] = true,
    ["Black Dwarf"] = true,
    ["Tesla Resetter"] = true,
    ["The Ultimate Sacrifice"] = true,
    ["⭐ Paranormal Tesla Refuter ⭐"] = true,
    ["⭐ Paranormal Tesla Resetter ⭐"] = true,
    ["⭐ Stargazed Void Star ⭐"] = true,
    ["⭐ Stargazed Black Dwarf ⭐"] = true
}
local ConnectionManager = {
["OreBooster"] = {}
}

local Workspace = game:GetService("Workspace")
local Factory
local ChosenFurnace = nil
for _, v in pairs(Workspace.Tycoons:GetChildren()) do
    if v:FindFirstChild("Owner") and v:FindFirstChild("Owner").Value ==
        game.Players.LocalPlayer.Name then Factory = v end
end
local FactoryMaster = Workspace.Tycoons[Factory.Name]
local EligibleUpgraders = {}
function UpdateFurnace(Text) -- This will be implemented into a GUI callback function
    table.foreach(FactoryMaster:GetChildren(),function(i, v) 
        if string.find(v, Text) and v:FindFirstChild("Model"):FindFirstChild("Lava") then return v end 
    end)
end

function FireTouch(Touched,Touching)
firetouchinterest(Touched,Touching,0)
firetouchinterest(Touched,Touching,1)
end

function Boost(Ore)
    local ResettersPlaced = {}
    table.foreach(Resetters,function(i)
        if FactoryMaster:FindFirstChild(i) then
            table.insert(ResettersPlaced,i)
        end
    end)
    for l = 0, #ResettersPlaced do
        for _, Upgrader in pairs(EligibleUpgraders) do
            if not FactoryMaster[Upgrader].Model:FindFirstChild("Upgrade2") then
                FireTouch(FactoryMaster[Upgrader].Model.Upgrade, Ore)
            else
                for v = 1, 3 do
                    FireTouch(FactoryMaster[Upgrader].Model["Upgrade" .. tostring(v)],Ore)
                end
            end
        end
        if l > 0 then FireTouch(FactoryMaster[ResettersPlaced[l]].Model.Upgrade,Ore) end
    end
    if ChosenFurnace and FactoryMaster:FindFirstChild(ChosenFurnace) then
        FireTouch(FactoryMaster[ChosenFurnace].Model.Lava,Ore)
    else
        for _,v in pairs(FactoryMaster:GetChildren()) do
            if v:FindFirstChild("Model"):FindFirstChild("Lava") then
                FireTouch(v.Model.Lava,Ore)
            end
        end
    end
end

local FactoryMasterConnectionA = FactoryMaster.ChildAdded:Connect(function(Child) 
if not Resetters[Child] and Child:FindFirstChild("Model"):FindFirstChild("Upgrade") then 
    table.insert(EligibleUpgraders,Child.Name)
end
end)
table.insert(ConnectionManager.OreBooster,FactoryMasterConnectionA)
local FactoryMasterConnectionR = FactoryMaster.ChildRemoved:Connect(function(Child) 
    if not Resetters[Child] and Child:FindFirstChild("Model"):FindFirstChild("Upgrade") then 
        table.remove(EligibleUpgraders,table.find(EligibleUpgraders,Child,1))
    end
    end)
table.insert(ConnectionManager.OreBooster,FactoryMasterConnectionR)

local FactoryDroppedParts = Workspace.DroppedParts.ChildAdded:Connect(function(DroppedOre) 
    Boost(DroppedOre) 
end)
table.insert(ConnectionManager.OreBooster,FactoryDroppedParts)
