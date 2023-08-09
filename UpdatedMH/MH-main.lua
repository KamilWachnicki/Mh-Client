--Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--GlobalVariables
local AutoRebirthEnabled = false
local isCalculated = false
local MoneyRequired
local AutoPulseEnabled = false
local MoneyLayout
local BoxAutoFarm = false
local MainLayout = "Layout1"
local MainLayoutDelay = 3
local LocalPlayer = Players.LocalPlayer
local HumanoidRootPart = Workspace[LocalPlayer.Name].HumanoidRootPart
local Factory
local LifesSkipping = 0
Suffix = { "Qn", "sx", "Sp", "O", "N", "de", "Ud", "DD", "tdD", "qdD", "QnD", "sxD", "SpD", "OcD", "NvD", "Vgn", "UVg",
    "DVg", "TVg", "qtV", "QnV", "SeV", "SPG", "OVG", "NVG", "TGN", "UTG", "DTG", "tsTG", "qtTG", "QnTG", "ssTG", "SpTG",
    "OcTG", "NoTG", "QdDR", "uQDR", "dQDR", "tQDR", "qdQDR", "QnQDR", "sxQDR", "SpQDR", "OQDDr", "NQDDr", "qQGNT",
    "uQGNT", "dQGNT", "tQGNT", "qdQGNT", "QnQGNT", "sxQGNT", "SpQGNT", "OQQGNT", "NQQGNT", "SXGNTL", "USXGNTL",
    "DSXGNTL", "TSXGNTL", "QTSXGNTL", "QNSXGNTL", "SXSXGNTL", "SPSXGNTL", "OSXGNTL", "NVSXGNTL", "SPTGNTL", "USPTGNTL",
    "DSPTGNTL", "TSPTGNTL", "QTSPTGNTL", "QNSPTGNTL", "SXSPTGNTL", "SPSPTGNTL", "OSPTGNTL", "NVSPTGNTL" }
--
for i, v in pairs(Workspace.Tycoons:GetChildren()) do --Getting the LocalPlayers Factory
    if v:FindFirstChild("Owner") and v:FindFirstChild("Owner").Value == game.Players.LocalPlayer.Name then
        Factory = v
    end
end

LocalPlayer.Idled:Connect(function() --AntiAfk
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
end)

function MoneyRequired() --Getting the reqired money to rebirth
    local RebornString = Players.LocalPlayer.PlayerGui.GUI.Settings.Menu.PrimaryUtil.Rebirth.Reborn.Text
    if string.find(RebornString,"e+") then return tonumber(RebornString) end
    RebornString = RebornString:gsub('%s', " "):gsub('Reborn', " "):gsub('%$', "")
    local RebornOperator = string.match(RebornString, "%a+")
    for i, v in pairs(Suffix) do
        if RebornOperator ~= v then continue end
            return tonumber(string.match(RebornString, "%d+") .. string.rep("0", i * 3 + LifesSkipping))
    end
    print("Failed to convert")
end
function AutoLayout()
    spawn(function()
        while task.wait() do
            if not AutoRebirthEnabled then break end
            if Factory:FindFirstChildWhichIsA("Model") then
                if MoneyLayout then ReplicatedStorage.Layouts:InvokeServer("Load",MoneyLayout); wait(MainLayoutDelay); end
                game:GetService("ReplicatedStorage").Layouts:InvokeServer("Load",MainLayout)
                if AutoPulseEnabled then end
            end
        end
    end)
end
function AutoRebirth()
    spawn(function()
        while wait(.5) do
            if not AutoRebirthEnabled then break end
            if not isCalculated then MoneyRequired = MoneyRequired(); isCalculated = true; end
            if MoneyRequired < Players.LocalPlayer.PlayerGui.GUI.Money.Value then
                ReplicatedStorage.Rebirth:InvokeServer(26)
                isCalculated = false
            end
        end
    end)
end

function BoxTp()
    spawn(function()
        while wait(0.1) do
            if not BoxAutoFarm then break end
            local Boxes = Workspace.Boxes:GetChildren()
            if #Boxes > 0 then
            for _,v in pairs(Boxes) do
                local SavedPos = HumanoidRootPart.Position
                HumanoidRootPart.Position = v.Position
                HumanoidRootPart.Position = SavedPos
            end
            end
       end
    end)
end

local Players = Players:GetChildren() --Dynamic Player Table Handling

Players.PlayerAdded:Connect(function(Name)
Players[Name] = Name
end)

Players.PlayerRemoving:Connect(function(Name)
Players[Name] = nil
end)
