-- AUTO SAMBUNG KATA | MODE DEWA ABSOLUT
-- Delta Android | Ultra Stealth | UI Turn Detector

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- ================= CONFIG =================
local DB_URL = "https://raw.githubusercontent.com/sixxgibran-cmyk/roblox-sambung-kata-dewa/main/kbbi.txt"
local ENABLED = false
local KEY_TOGGLE = Enum.KeyCode.F8
local delayMin, delayMax = 0.05, 0.12

local rareScore = {q=6,x=6,z=6,v=5,f=5,j=5,y=4,k=4,w=4}
local blacklistNext = {a=true,i=true,u=true,e=true,o=true}

-- ================= LOAD DB =================
local INDEX = {}
pcall(function()
    local raw = game:HttpGet(DB_URL)
    for w in raw:gmatch("[^\r\n]+") do
        w = w:lower()
        if #w >= 2 then
            local c = w:sub(1,1)
            INDEX[c] = INDEX[c] or {}
            table.insert(INDEX[c], w)
        end
    end
end)

local USED = {}

-- ================= UTIL =================
local function humanDelay()
    task.wait(math.random() * (delayMax - delayMin) + delayMin)
end

local function typeText(txt)
    for i = 1, #txt do
        VIM:SendTextEvent(txt:sub(i,i))
        humanDelay()
    end
    VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
end

local function scoreWord(w)
    local s = 0
    for i=1,#w do s += (rareScore[w:sub(i,i)] or 0) end
    if blacklistNext[w:sub(-1)] then s -= 3 end
    return s
end

local function pickBest(letter)
    local list = INDEX[letter]
    if not list then return end
    local best, bs
    for _,w in ipairs(list) do
        if not USED[w] then
            local s = scoreWord(w)
            if not best or s > bs then
                best, bs = w, s
            end
        end
    end
    if best then USED[best] = true end
    return best
end

-- ================= TURN UI DETECTOR =================
local function isMyTurn()
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then return false end
    for _,v in ipairs(pg:GetDescendants()) do
        if v:IsA("TextBox") and v:IsFocused() then
            return true
        end
    end
    return false
end

-- ================= CHAT =================
LocalPlayer.Chatted:Connect(function(msg)
    if not ENABLED then return end
    task.spawn(function()
        local t0 = os.clock()
        while os.clock() - t0 < 1.2 do
            if isMyTurn() then break end
            task.wait(0.05)
        end
        if not isMyTurn() then return end
        local letter = msg:sub(-1):lower()
        local ans = pickBest(letter)
        if ans then
            task.wait(0.12)
            typeText(ans)
        end
    end)
end)

-- ================= GUI =================
local gui = Instance.new("ScreenGui", game.CoreGui)
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0,190,0,46)
btn.Position = UDim2.new(0,20,0,200)
btn.TextColor3 = Color3.new(1,1,1)

local function refresh()
    btn.Text = ENABLED and "AUTO : ON (DEWA)" or "AUTO : OFF"
    btn.BackgroundColor3 = ENABLED and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
end

btn.MouseButton1Click:Connect(function()
    ENABLED = not ENABLED
    refresh()
end)
refresh()

UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == KEY_TOGGLE then
        ENABLED = not ENABLED
        refresh()
    end
end)
