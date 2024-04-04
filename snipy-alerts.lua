
-- initialize alert frame and all subframes
local function initAlert()
    -- create base frame
    SnipyAlertFrame = CreateFrame("Frame", nil, UIParent)
    SnipyAlertFrame:SetSize(50, 50)

    -- init DummyFrame (used to move frame later)
    DummyFrame = CreateFrame("Frame", nil, UIParent)

    -- set initial position on first log on
    if POSX == nil or POSY == nil then
        SnipyAlertFrame:SetPoint("CENTER", 100, 0)
        _, _, _, POSX, POSY = SnipyAlertFrame:GetPoint()
    else -- if not first log in, load saved posisition from saved variables: POSX and POSY
        SnipyAlertFrame:SetPoint("CENTER", POSX, POSY)
    end

    -- the base alert frame is just a black square which will work as a background (makes the cooldown timer effect look better)
    SnipyAlertFrame.texture = SnipyAlertFrame:CreateTexture()
    SnipyAlertFrame.texture:SetAllPoints()
    SnipyAlertFrame.texture:SetColorTexture(0.0, 0.0, 0.0, 1)

    -- create overpower icon frame
    SnipyAlertFrameIcon = CreateFrame("StatusBar", nil, SnipyAlertFrame)
    SnipyAlertFrameIcon:SetSize(50, 50)
    SnipyAlertFrameIcon:SetPoint("TOP", 0, 0)
    SnipyAlertFrameIcon.texture = SnipyAlertFrameIcon:CreateTexture()
    SnipyAlertFrameIcon.texture:SetAllPoints(true)
    SnipyAlertFrameIcon.texture:SetTexture("Interface\\Icons\\ability_meleedamage")

    -- this is the fame used to create the cooldown swipe / fade out animation
    SnipyAlertFrameFade = CreateFrame("StatusBar", nil, SnipyAlertFrameIcon)
    SnipyAlertFrameFade:SetSize(50, 50)
    SnipyAlertFrameFade:SetPoint("TOP", 0, 0)
    SnipyAlertFrameFade.texture = SnipyAlertFrameFade:CreateTexture()
    SnipyAlertFrameFade.texture:SetAllPoints(true)  
    SnipyAlertFrameFade.texture:SetColorTexture(0.0, 0.0, 0.0, 0.5)

    -- this text shows the remaining time on the current overpower window
    timerText = SnipyAlertFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    timerText:SetPoint("CENTER", 0, -25-5)
    timerText:SetText("")

    SnipyAlertFrame:Hide() -- hide frame after initializing
end


local function unlock()
    -- create dummy frame to position alert frame (initialize in init func)
    DummyFrame:Show()
    DummyFrame:SetSize(50, 50)
    DummyFrame:SetPoint("CENTER", POSX, POSY)
    DummyFrame.texture = DummyFrame:CreateTexture()
    DummyFrame.texture:SetAllPoints()
    DummyFrame.texture:SetTexture("Interface\\Icons\\ability_meleedamage")

    -- make DummyFrame movable and save its position
    DummyFrame:SetMovable(true)
    DummyFrame:EnableMouse(true)
    DummyFrame:RegisterForDrag("LeftButton")
    DummyFrame:SetScript("OnDragStart", DummyFrame.StartMoving)
    function setFramePos()
        DummyFrame:StopMovingOrSizing()
        _, _, _, POSX, POSY = DummyFrame:GetPoint() -- saves points POSX and POSY to saved variables
    end
    DummyFrame:SetScript("OnDragStop", setFramePos)

    -- create user help text
    moveText = DummyFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    moveText:SetPoint("TOP", 0, 12)
    moveText:SetText("Move me!")

    lockText = DummyFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    lockText:SetPoint("BOTTOM", 0, -12)
    lockText:SetText("'/snipy lock' to lock")
end

local function lock()
    DummyFrame:EnableMouse(false)
    DummyFrame:Hide()
end

-- event that is triggered after a dodge occurs
local function triggerAlert()
    lock()
    SnipyAlertFrame:SetPoint("CENTER", POSX, POSY)

    -- show frame
    SnipyAlertFrame:Show()

    -- set some useful variables
    local START = 0
    local END = 5
    local timer = 0
    SnipyAlertFrameFade:SetMinMaxValues(START, END)

    -- timer script
    SnipyAlertFrameFade:SetScript("OnUpdate", function(self, elapsed)
        timer = timer + elapsed -- add amount of elapsed time since last update to current timer
        percentDone = timer / END -- get percentage of total time elapsed
        SnipyAlertFrameFade:SetSize(50, 50*percentDone) -- update fade frame to reflect time remaining
        timerText:SetText(string.format("%.1f", END - timer)) -- update timer below alert

        -- when timer reaches desired value, defined by END (seconds), restart by setting to 0, defined by START
        if timer >= END then
            timer = START -- reset timer to 0
            SnipyAlertFrame:Hide() -- hide frame when complete
        end
    end)
end

-- combat log function
local eventSearchingFor = "DODGE" -- name of event to search for
local arr = {}
local function OnEvent(self, event)
    if(GetSpellInfo(NAME_OVERPOWER)) then -- only load if player knows the spell
        arr[1], arr[2], arr[3], arr[4], arr[5], arr[6], arr[7], arr[8], arr[9], arr[10], arr[11], arr[12], arr[13], arr[14], arr[15], arr[16], arr[17], arr[18], arr[19], arr[20] = CombatLogGetCurrentEventInfo()
    
    -- read through player's combat log
        if arr[5] == UnitName("player") then
            -- hide alert after player overpowers successfully
            if(arr[2] == "SPELL_CAST_SUCCESS" and arr[13] == NAME_OVERPOWER) then
                SnipyAlertFrame:Hide()
            end

            -- below works (on swings and spells)
            if arr[12] == eventSearchingFor or arr[15] == eventSearchingFor then
                triggerAlert()
            end
        end

        -- fade overpower alert out when overpower is still on CD
        local start, duration, enabled, _ = GetSpellCooldown(NAME_OVERPOWER)
        local opCD = start + duration - GetTime()
        if(opCD > 1.5) then
            SnipyAlertFrame:SetAlpha(.2)
        else
            SnipyAlertFrame:SetAlpha(1)
        end
    end
end


-- slash command to test alert
SLASH_SNIPY_TEST1 = "/snipy"
SlashCmdList["SNIPY_TEST"] = function(msg)
    if(msg == "test" or msg == "t") then
        triggerAlert()
    elseif(msg == "unlock" or msg == "ul" or msg == "u") then
        print("Unlocking frame.")
        unlock()
    elseif(msg == "lock" or msg == "l") then
        print("Locking frame.")
        lock()
    elseif(msg == "reset") then
        print("Resetting position.")
        POSX = 100
        POSY = 0
    else
        print("-- Snipy Alerts --")
        print("Commands: ")
        print("  '/snipy unlock' - unlocks alert frame, allowing it to be moved")
        print("  '/snipy lock'   - locks alert frame, preventing it from being moved")
        print("  '/snipy reset'  - reset alert frame to default position")
        print("  '/snipy test'   - test alert frame")
    end
end

-- create hidden frame, register it to watch for combat log events. On each combat log event, load OnEvent() function
local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "player")
f:SetScript("OnEvent", OnEvent)

NAME_OVERPOWER = GetSpellInfo(11585)

initAlert() -- initialize alert frame
print("Snipy Alerts loaded.")
