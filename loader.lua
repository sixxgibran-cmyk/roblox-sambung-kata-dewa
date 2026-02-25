-- AUTO SAMBUNG KATA | FIXED VERSION
-- WORKS ON MOST SAMBUNG KATA GAMES
-- DELTA ANDROID SAFE

local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer

-- ========= CONFIG =========
local DB_URL = "https://raw.githubusercontent.com/sixxgibran-cmyk/roblox-sambung-kata-dewa/main/kbbi.txt"
local ENABLED = false
local DELAY = 0.12

-- ========= LOAD DB =========
local DB = {}
pcall(function()
    local raw = game:HttpGet(DB_URL)
    for w in raw:gmatch("[^\r\n]+") do
        w = w:lower()
        if #w >= 2 then table.insert(DB, w) end
    end
end)

-- ========= UTIL =========
local function typeText(txt)
    for i = 1, #txt do
        VIM:SendTextEvent(txt:sub(i,i))
        task.wait(DELAY)
    end
    VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
end

local function findWord(letter)
    for _,w in ipairs(DB) do
        if w:sub(1,1) == letter then
            return w
        end
    end
end

-- ========= CORE LOOP =========
task.spawn(function()
    while true do
        task.wait(0.3)
        if not ENABLED then continue end

        local gui = LP:FindFirstChildOfClass("PlayerGui")
        if not gui then continue end

        for _,v in ipairs(gui:GetDescendants()) do
            if v:IsA("TextLabel") then
                local text = v.Text
                if text and #text >= 1 then
                    local last = text:sub(-1):lower()
                    if last:match("%a") then
                        local ans = findWord(last)
                        if ans then
                            task.wait(0.2)
                            typeText(ans)
                            task.wait(1.2) -- anti spam
                        end
                    end
                end
            end
        end
    end
end)

-- ========= GUI TOGGLE =========
local gui = Instance.new("ScreenGui", game.CoreGui)
local btn = Instance.new("TextButton", gui)

btn.Size = UDim2.new(0,180,0,46)
btn.Position = UDim2.new(0,20,0,200)
btn.Text = "AUTO : OFF"
btn.TextColor3 = Color3.new(1,1,1)
btn.BackgroundColor3 = Color3.fromRGB(200,50,50)

btn.MouseButton1Click:Connect(function()
    ENABLED = not ENABLED
    btn.Text = ENABLED and "AUTO : ON (FIXED)" or "AUTO : OFF"
    btn.BackgroundColor3 = ENABLED
        and Color3.fromRGB(50,200,50)
        or Color3.fromRGB(200,50,50)
end)
