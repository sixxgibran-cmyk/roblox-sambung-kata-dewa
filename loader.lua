-- AUTO SAMBUNG KATA | FIX KHUSUS UI GAME
-- WORK 100% | DELTA ANDROID

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- ===== CONFIG =====
local DB_URL = "https://raw.githubusercontent.com/sixxgibran-cmyk/roblox-sambung-kata-dewa/main/kbbi.txt"
local ENABLED = false
local COOLDOWN = 1.2

-- ===== LOAD DB =====
local DB = {}
pcall(function()
    local raw = game:HttpGet(DB_URL)
    for w in raw:gmatch("[^\r\n]+") do
        w = w:lower()
        if #w >= 2 then table.insert(DB, w) end
    end
end)

local function findWord(letter)
    for _,w in ipairs(DB) do
        if w:sub(1,1) == letter then
            return w
        end
    end
end

-- ===== GET UI =====
local function getUI()
    local gui = LP:WaitForChild("PlayerGui")
    local main = gui:WaitForChild("MainUI")

    return {
        question = main.Question.Label,
        input = main.Input,
        submit = main.Submit
    }
end

local lastAnswer = 0

-- ===== CORE LOOP =====
task.spawn(function()
    while true do
        task.wait(0.25)
        if not ENABLED then continue end
        if tick() - lastAnswer < COOLDOWN then continue end

        local ui
        pcall(function()
            ui = getUI()
        end)
        if not ui then continue end

        local text = ui.question.Text
        if not text or #text == 0 then continue end

        local letter = text:sub(-1):lower()
        if not letter:match("%a") then continue end

        local ans = findWord(letter)
        if ans then
            ui.input.Text = ans
            task.wait(0.15)

            -- klik tombol Kirim
            pcall(function()
                firesignal(ui.submit.MouseButton1Click)
            end)

            lastAnswer = tick()
        end
    end
end)

-- ===== GUI TOGGLE =====
local gui = Instance.new("ScreenGui", game.CoreGui)
local btn = Instance.new("TextButton", gui)

btn.Size = UDim2.new(0,190,0,46)
btn.Position = UDim2.new(0,20,0,200)
btn.Text = "AUTO : OFF"
btn.TextColor3 = Color3.new(1,1,1)
btn.BackgroundColor3 = Color3.fromRGB(200,50,50)

btn.MouseButton1Click:Connect(function()
    ENABLED = not ENABLED
    btn.Text = ENABLED and "AUTO : ON (FIX UI)" or "AUTO : OFF"
    btn.BackgroundColor3 = ENABLED
        and Color3.fromRGB(50,200,50)
        or Color3.fromRGB(200,50,50)
end)
