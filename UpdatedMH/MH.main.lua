--Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
--GlobalVariables
local AutoRebirthEnabled = false
local isCalculated = false
local MoneyRequired = nil
local AutoPulseEnabled = false
local LocalPlayer = Players.LocalPlayer
local Factory = nil
local LifesSkipping
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

game:GetService("Players").LocalPlayer.Idled:Connect(function() --
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
end)

function MoneyRequired() --Getting the reuired money to rebirth
    local RebornString = Players.LocalPlayer.PlayerGui.GUI.Settings.Menu.PrimaryUtil.Rebirth.Reborn.Text
    if string.match(RebornString, "e+") then return tonumber(RebornString) end
    RebornString = RebornString:gsub('%s', " "):gsub('Reborn', " "):gsub('%$', " ")
    local RebornOperator = string.match(RebornString, "%a+")
    for i, v in pairs(Suffix) do
        if Suffix[v] == RebornOperator then
            return tonumber(string.match(RebornString, "%d+") .. string.rep("0", i * 3 + LifesSkipping))
        end
    end
end

function AutoRebirth()
    spawn(function()
        while wait(.5) do
            if not AutoRebirthEnabled then break end
            if not isCalculated then MoneyRequired = MoneyRequired() isCalculated = true end
            if MoneyRequired < Players.LocalPlayer.PlayerGui.GUI.Money.Value then
                game:GetService("ReplicatedStorage").Rebirth:InvokeServer(26)
                isCalculated = false
                if AutoPulseEnabled then  end
            end
        end
    end)
end
