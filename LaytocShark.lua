-- [[ ANTI-BAN SYSTEM SƠ CẤP & NÂNG CAO ]]
local function ActivateAntiBan()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldIndex = mt.__index
    local oldNamecall = mt.__namecall

    -- Chặn các nỗ lực đọc thông số nhạy cảm của Server
    mt.__index = newcclosure(function(t, k)
        if not checkcaller() then
            if k == "WalkSpeed" then return 16 end
            if k == "JumpPower" then return 50 end
        end
        return oldIndex(t, k)
    end)

    -- Chặn các RemoteEvent kiểm tra Client (Anti-Cheat của Blox Fruit)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "FireServer" then
            if tostring(self) == "AdminCheck" or tostring(self) == "CheatCheck" or tostring(self) == "Kick" then
                return nil -- Chặn hoàn toàn lệnh gửi về server
            end
        end
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
    print("🛡️ Hệ thống Anti-Ban đã được kích hoạt thành công!")
end

ActivateAntiBan()

-- [[ KHỞI TẠO GIAO DIỆN RAYFIELD ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🌊 SHARK RACE AUTO - PRO MENU",
   LoadingTitle = "Đang kiểm tra dữ liệu...",
   LoadingSubtitle = "by Gemini AI",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "SharkPro", 
      FileName = "MainConfig"
   }
})

-- Tạo Tab Chính
local MainTab = Window:CreateTab("Chức năng chính", 4483362458)
local InfoTab = Window:CreateTab("Thông tin", 4483362458)

-- Biến điều khiển
getgenv().AutoShark = false
local player = game.Players.LocalPlayer

-- [[ LOGIC AUTO SHARK ]]
local function RunSharkLogic()
    spawn(function()
        while getgenv().AutoShark do
            pcall(function()
                local race = player.Data.Race.Value
                local fragments = player.Data.Fragments.Value
                local beli = player.Data.Beli.Value

                -- Bước 1: Reroll sang Tộc Cá (Cần 3000 Fragments)
                if race ~= "Fish" then
                    if fragments >= 3000 then
                        Rayfield:Notify({Title = "Hệ thống", Content = "Đang đổi tộc sang Cá...", Duration = 3})
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "1")
                    else
                        Rayfield:Notify({Title = "Lỗi", Content = "Bạn không đủ 3000 Fragments!", Duration = 3})
                        getgenv().AutoShark = false
                    end

                -- Bước 2: Nâng cấp V2 (Cần 500k Beli + Flower)
                elseif not player.Character:FindFirstChild("RaceV2") and not (player:FindFirstChild("Data") and player.Data:FindFirstChild("RaceV2")) then
                    if beli >= 500000 then
                        Rayfield:Notify({Title = "V2", Content = "Đang thực hiện chuỗi nhiệm vụ Alchemist...", Duration = 5})
                        -- Ghi chú: Logic tìm hoa tự động rất dài, nên sử dụng kèm các bản Hub tìm item.
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist", "1")
                    else
                        Rayfield:Notify({Title = "Lỗi", Content = "Thiếu 500k Beli để lên V2", Duration = 3})
                    end

                -- Bước 3: Nâng cấp V3 (Cần 2m Beli + Diệt Sea Beast)
                elseif race == "Fish" and not (player.Data:FindFirstChild("RaceV3")) then
                    if beli >= 2000000 then
                        Rayfield:Notify({Title = "V3", Content = "Đang nhận nhiệm vụ từ Arowe...", Duration = 5})
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Arowe", "1")
                    else
                        Rayfield:Notify({Title = "Lỗi", Content = "Thiếu 2m Beli để lên V3", Duration = 3})
                    end
                end
            end)
            wait(7) -- Nghỉ 7 giây mỗi chu kỳ để tránh bị kick do spam remote
        end
    end)
end

-- [[ GIAO DIỆN ĐIỀU KHIỂN ]]
MainTab:CreateSection("Điều khiển Tộc")

MainTab:CreateToggle({
   Name = "Bật Tự Động Lấy Tộc Cá (V1 -> V3)",
   CurrentValue = false,
   Flag = "SharkToggle",
   Callback = function(Value)
      getgenv().AutoShark = Value
      if Value then
          RunSharkLogic()
      end
   end,
})

MainTab:CreateSection("Tiện ích khác")

MainTab:CreateButton({
   Name = "Dịch chuyển tới NPC Arowe (Nhiệm vụ V3)",
   Callback = function()
       -- Tọa độ NPC Arowe tại Sea 2
       player.Character.HumanoidRootPart.CFrame = CFrame.new(-1868, 12, -3111)
   end,
})

InfoTab:CreateLabel("Tình trạng: " .. (g.AntiBan and "Đã bảo vệ" or "Chưa rõ"))
InfoTab:CreateLabel("Tộc hiện tại: " .. player.Data.Race.Value)
InfoTab:CreateLabel("Fragments: " .. player.Data.Fragments.Value)

Rayfield:Notify({
   Title = "🦈 Shark Race System",
   Content = "Menu đã sẵn sàng. Chúc bạn may mắn!",
   Duration = 5
})
