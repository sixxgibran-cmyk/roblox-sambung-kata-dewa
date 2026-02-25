-- AUTO SAMBUNG KATA | FINAL FIX DELTA ANDROID
-- TANPA firesignal | PASTI KIRIM

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- ===== CONFIG =====
local DB_URL = "https://raw.githubusercontent.com/sixxgibran-cmyk/roblox-sambung-kata-dewa/kbbi.txt"
local ENABLED = false
local COOLDOWN = 1.3

-- ===== LOAD DB =====
local DB = {}
pcall(function()
    local raw = game:HttpGet(https://raw.githubusercontent.com/sixxgibran-cmyk/roblox-sambung-kata-dewa/kbbi.txt)
    for w in raw:gmatch("[^\r\n]+") do
        w = w:lower()
        if #w >= 2 then
            table.insert(DB, w)
        end
    end
end)

local function findWord(letter)
    for _, w in ipairs(DB) do
        if w:sub(1,1) == letter then
            return w
        end
    end
end

-- ===== GET UI (SAFE) =====
local function getUI()
    local gui = LP:WaitForChild("PlayerGui")
    local main = gui:WaitForChild("MainUI", 5)
    if not main then return end

    return {
        question = main:WaitForChild("Question"):WaitForChild("Label"),
        input = main:WaitForChild("Input"),
        submit = main:WaitForChild("Submit")
    }
end

local lastSend = 0

-- ===== CORE LOOP =====
task.spawn(function()
    while task.wait(0.25) do
        if not ENABLED then continue end
        if tick() - lastSend < COOLDOWN then continue end

        local ui = getUI()
        if not ui then continue end

        local q = ui.question.Text
        if not q or #q == 0 then continue end

        local letter = q:sub(-1):lower()
        if not letter:match("%a") then continue end

        local answer = findWord(letter)
        if not answer then continue end

        -- isi textbox
        ui.input.Text = answer
        task.wait(0.1)

        -- KLIK TOMBOL RESMI (INI KUNCI)
        ui.submit:Activate()

        lastSend = tick()
    end
end)

-- ===== TOGGLE UI =====
local sg = Instance.new("ScreenGui", game.CoreGui)
local btn = Instance.new("TextButton", sg)

btn.Size = UDim2.new(0,200,0,46)
btn.Position = UDim2.new(0,20,0,220)
btn.Text = "AUTO : OFF"
btn.TextColor3 = Color3.new(1,1,1)
btn.BackgroundColor3 = Color3.fromRGB(200,50,50)

btn.MouseButton1Click:Connect(function()
    ENABLED = not ENABLED
    btn.Text = ENABLED and "AUTO : ON (DELTA FIX)" or "AUTO : OFF"
    btn.BackgroundColor3 = ENABLED
        and Color3.fromRGB(50,200,50)
        or Color3.fromRGB(200,50,50)
end)
