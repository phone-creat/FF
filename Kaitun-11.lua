-- [[ SYSTEM SETTINGS ]]
getgenv().KaitunConfig = {
    AutoFarm = false,
    AutoShark = false,
    BringMob = true,
    FastAttack = true,
    AntiAfk = true
}

-- [[ 1. ANTI-BAN & BYPASS SYSTEM ]]
local function InitAntiCheatBypass()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" then
            local args = {...}
            -- Chặn các Remote check của Blox Fruit
            if tostring(self) == "AdminCheck" or tostring(self) == "Envy" or tostring(self) == "CheckStandard" then
                return nil
            end
        end
        return oldNamecall(self, ...)
    end)
    
    -- Chặn check tốc độ và nhảy
    local oldIndex = mt.__index
    mt.__index = newcclosure(function(t, k)
        if k == "WalkSpeed" then return 16 end
        if k == "JumpPower" then return 50 end
        return oldIndex(t, k)
    end)
    setreadonly(mt, true)
end

-- [[ 2. ANTI-AFK (Ngăn bị văng sau 20p) ]]
if getgenv().KaitunConfig.AntiAfk then
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end

InitAntiCheatBypass()

-- [[ 3. LÀM MENU GIAO DIỆN ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "🌊 GEMINI KAITUN - PRO VERSION",
   LoadingTitle = "Đang tối ưu hóa hệ thống...",
   ConfigurationSaving = {Enabled = true, FolderName = "GeminiKaitun"}
})

local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local RaceTab = Window:CreateTab("Auto Race", 4483362458)

-- [[ 4. LOGIC AUTO FARM (GOM QUÁI & ĐÁNH) ]]
spawn(function()
    while wait() do
        if getgenv().KaitunConfig.AutoFarm then
            pcall(function()
                local player = game.Players.LocalPlayer
                local character = player.Character
                -- Logic tìm quái gần nhất (Ví dụ cho đảo đầu)
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        repeat
                            -- Di chuyển tới quái và gom quái
                            character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                            -- Lệnh đánh (Cần Tool cụ thể)
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                            wait()
                        until not getgenv().KaitunConfig.AutoFarm or v.Humanoid.Health <= 0
                    end
                end
            end)
        end
    end
end)

-- [[ 5. LOGIC AUTO SHARK (ĐÃ TỐI ƯU) ]]
local function RunSharkRace()
    spawn(function()
        while getgenv().KaitunConfig.AutoShark do
            local p = game.Players.LocalPlayer
            local race = p.Data.Race.Value
            
            if race ~= "Fish" then
                if p.Data.Fragments.Value >= 3000 then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "1")
                end
            elseif not p.Data:FindFirstChild("RaceV3") then
                -- Nhận nhiệm vụ V3 tự động
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Arowe", "1")
            end
            wait(10)
        end
    end)
end

-- [[ 6. TẠO CÁC NÚT BẤM TRÊN MENU ]]
FarmTab:CreateToggle({
   Name = "Bật Auto Farm Level (Kaitun)",
   CurrentValue = false,
   Callback = function(Value) getgenv().KaitunConfig.AutoFarm = Value end,
})

RaceTab:CreateToggle({
   Name = "Auto Shark Race (Reroll + V3)",
   CurrentValue = false,
   Callback = function(Value) 
      getgenv().KaitunConfig.AutoShark = Value 
      if Value then RunSharkRace() end
   end,
})

Rayfield:Notify({Title = "Kaitun Loaded!", Content = "Hệ thống Anti-Ban đã sẵn sàng.", Duration = 5
})
