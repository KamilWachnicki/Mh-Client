--Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--GlobalVariables
local AutoRebirthEnabled = false
local BoxAutoFarm = false
local PlayerSelected
local LocalPlayer = Players.LocalPlayer
local HumanoidRootPart = Workspace[LocalPlayer.Name].HumanoidRootPart
Suffix = { "Qn", "sx", "Sp", "O", "N", "de", "Ud", "DD", "tdD", "qdD", "QnD", "sxD", "SpD", "OcD", "NvD", "Vgn", "UVg",
    "DVg", "TVg", "qtV", "QnV", "SeV", "SPG", "OVG", "NVG", "TGN", "UTG", "DTG", "tsTG", "qtTG", "QnTG", "ssTG", "SpTG",
    "OcTG", "NoTG", "QdDR", "uQDR", "dQDR", "tQDR", "qdQDR", "QnQDR", "sxQDR", "SpQDR", "OQDDr", "NQDDr", "qQGNT",
    "uQGNT", "dQGNT", "tQGNT", "qdQGNT", "QnQGNT", "sxQGNT", "SpQGNT", "OQQGNT", "NQQGNT", "SXGNTL", "USXGNTL",
    "DSXGNTL", "TSXGNTL", "QTSXGNTL", "QNSXGNTL", "SXSXGNTL", "SPSXGNTL", "OSXGNTL", "NVSXGNTL", "SPTGNTL", "USPTGNTL",
    "DSPTGNTL", "TSPTGNTL", "QTSPTGNTL", "QNSPTGNTL", "SXSPTGNTL", "SPSPTGNTL", "OSPTGNTL", "NVSPTGNTL" }
--

LocalPlayer.Idled:Connect(function() --AntiAfk
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
end)

local MoneyRequired
local LifesSkipping = 0

function MoneyRequired()
    local RebornString = Players.LocalPlayer.PlayerGui.GUI.Settings.Menu.PrimaryUtil.Rebirth.Reborn.Text
    if tonumber(RebornString) then return tonumber(RebornString) end
    RebornString = RebornString:gsub('%s', " "):gsub('Reborn', " "):gsub('%$', "")
    local RebornOperator = string.match(RebornString, "   %a+")
    for i, v in ipairs(Suffix) do
        if RebornOperator ~= v then continue end
            return tonumber(string.match(RebornString, "%d+")) * math.pow(1000,5+i+LifesSkipping) --the 5 represents the 5th suffix(Qd),neccesary for proper calculation
    end
    print("Failed to convert")
    return nil
end

local isCalculated = false
local AutoPulseEnabled = false
local MoneyLayout = "None"
local MainLayout = "Layout1"
local MainLayoutDelay = 3
local Factory
local AutoPulseEnabled
for _, v in pairs(Workspace.Tycoons:GetChildren()) do if v:FindFirstChild("Owner") and v:FindFirstChild("Owner").Value == game.Players.LocalPlayer.Name then Factory = v end end
function AutoLayout()
    spawn(function()
        while task.wait(1) do
            if not AutoRebirthEnabled then break end
            if Factory:FindFirstChildWhichIsA("Model") then
                if MoneyLayout ~= "None" then ReplicatedStorage.Layouts:InvokeServer("Load",MoneyLayout); task.wait(MainLayoutDelay); end
                ReplicatedStorage.Layouts:InvokeServer("Load",MainLayout)
                print(MoneyLayout)
                if AutoPulseEnabled then end
            end
        end
    end)
end
function AutoRebirth()
    spawn(function()
        while task.wait(.5) do
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
        while task.wait(1) do
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

local Players = {}
local SelectedPlayer = nil
for i,v in pairs(Players:GetChildren()) do
    local DisplayName = v.DisplayName or v.Name
    Players[i] = string.format("%s(@%s)",DisplayName,v.Name)
end

-- Ui
local ArrayField = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source.lua'))()

local MHClient = ArrayField:CreateWindow({
    Name = "Miner's Haven Client",
    LoadingTitle = "Loading Client",
    LoadingSubtitle = "by wert",
    ConfigurationSaving = {Enabled = false,FolderName = "MhClient",FileName = "Configuration"},
    Discord = {Enabled = false,Invite = "noinvitelink", RememberJoins = true },
    KeySystem = false, 
    KeySettings = {Title = "Untitled",Subtitle = "Key System",Note = "No method of obtaining the key is provided",FileName = "Key",SaveKey = false, GrabKeyFromSite = false, 
       Actions = {
             [1] = {
                 Text = 'Click here to copy the key link <--',
                 OnPress = function()
                     print('Pressed')
                 end,
                 }
             },
       Key = {"wert"}
    }
 })

 local Automation = MHClient:CreateTab("Automation", 4483362458)
 local AutoRebirthSettings = Automation:CreateSection("Auto Rebirth Settings",true)
 local AutoRebirthToggle = Automation:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Flag = "AutoRebirthState", 
    Callback = function(Value)
    AutoRebirthEnabled = Value
    AutoRebirth()
    AutoLayout()
    end,
 })

 local MainLayoutDropdown = Automation:CreateDropdown({
    Name = "Main Layout",
    Options = {"Layout1","Layout2","Layout3"},
    CurrentOption = "Layout1",
    MultiSelection = false, 
    Flag = "MainLayoutState", 
    Callback = function(Option)
    MainLayout = Option
    end,
 })

 local MoneyLayoutDropdown = Automation:CreateDropdown({
    Name = "Main Layout",
    Options = {"None","Layout1","Layout2","Layout3"},
    CurrentOption = "None",
    MultiSelection = false, 
    Flag = "MoneyLayoutState", 
    Callback = function(Option)
    MoneyLayout = Option
    end,
 })

 local MainLayoutDelayInput = Automation:CreateInput({
    Name = "Main Layout Delay",
    PlaceholderText = "Delay",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
    if tonumber(Text) then 
        MainLayoutDelay = tonumber(Text) 
    else
        ArrayField:Notify({
        Title = "Error",
        Content = "You didnt enter a number,are you dumb?",
        Duration = 9999,
        Image = 4483362458,
        Actions={Ignore = {Name = "Yes",Callback = function() print("You are dumb!") end},},})
        end
    end,
 })

 local BaseTweaks = MHClient:CreateTab("Base Tweaks", 4483362458)

 local DynamicPlayerDropdown = BaseTweaks:CreateDropdown({
    Name = "Select Player",
    Options = Players,
    CurrentOption = nil,
    MultiSelection = false, 
    Flag = "DynamicPlayerDropdownState", 
    Callback = function(Option)
    SelectedPlayer = string.sub(Option,1,string.find(Option,"%(")-1)
    end,
 })

 Players.PlayerAdded:Connect(function(Player) --Player Handling
    local DisplayName  = Player.DisplayName or Player.Name
    DynamicPlayerDropdown:Add(string.format("%s(@%s)",DisplayName,Player.Name))
end)

Players.PlayerRemoving:Connect(function(Player)
    local DisplayName  = Player.DisplayName or Player.Name
    DynamicPlayerDropdown:Add(string.format("%s(@%s)",DisplayName,Player.Name))
end)

















