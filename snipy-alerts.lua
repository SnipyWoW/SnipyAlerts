
-- initialize alert frame and all subframes
local function initAlert()
    -- create base frame
    OverPowerAlertFrame = CreateFrame("Frame", nil, UIParent)
    OverPowerAlertFrame:SetSize(50, 50)

    -- create bloodsurge base frame
    BloodSurgeAlertFrame = CreateFrame("Frame", nil, UIParent)
    BloodSurgeAlertFrame:SetSize(50, 50)

    -- init OverPowerDummyFrame (used to move frame later)
    OverPowerDummyFrame = CreateFrame("Frame", nil, UIParent)

    -- init BloodSurgeDummyFrame (used to move frame later)
    BloodSurgeDummyFrame = CreateFrame("Frame", nil, UIParent)

    -- set initial position on first log on
    if OverpowerPOSX == nil or OverpowerPOSY == nil then
        OverPowerAlertFrame:SetPoint("CENTER", 100, 0)
        _, _, _, OverpowerPOSX, OverpowerPOSY = OverPowerAlertFrame:GetPoint()
    else -- if not first log in, load saved posisition from saved variables: OverpowerPOSX and OverpowerPOSY
        OverPowerAlertFrame:SetPoint("CENTER", OverpowerPOSX, OverpowerPOSY)
    end

    -- set initial position on first log on
    if BloodsurgePOSX == nil or BloodsurgePOSY == nil then
        BloodSurgeAlertFrame:SetPoint("CENTER", -100, 0)
        _, _, _, BloodsurgePOSX, BloodsurgePOSY = BloodSurgeAlertFrame:GetPoint()
    else -- if not first log in, load saved posisition from saved variables: BloodsurgePOSX and BloodsurgePOSY
        BloodSurgeAlertFrame:SetPoint("CENTER", BloodsurgePOSX, BloodsurgePOSY)
    end

    -- the base alert frame is just a black square which will work as a background (makes the cooldown timer effect look better)
    OverPowerAlertFrame.texture = OverPowerAlertFrame:CreateTexture()
    OverPowerAlertFrame.texture:SetAllPoints()
    OverPowerAlertFrame.texture:SetColorTexture(0.0, 0.0, 0.0, 1)

    -- the base alert frame is just a black square which will work as a background (makes the cooldown timer effect look better)
    BloodSurgeAlertFrame.texture = BloodSurgeAlertFrame:CreateTexture()
    BloodSurgeAlertFrame.texture:SetAllPoints()
    BloodSurgeAlertFrame.texture:SetColorTexture(0.0, 0.0, 0.0, 1)

    -- create overpower icon frame
    OverPowerAlertFrameIcon = CreateFrame("StatusBar", nil, OverPowerAlertFrame)
    OverPowerAlertFrameIcon:SetSize(50, 50)
    OverPowerAlertFrameIcon:SetPoint("TOP", 0, 0)
    OverPowerAlertFrameIcon.texture = OverPowerAlertFrameIcon:CreateTexture()
    OverPowerAlertFrameIcon.texture:SetAllPoints(true)
    OverPowerAlertFrameIcon.texture:SetTexture("Interface\\Icons\\ability_meleedamage")

    -- create overpower icon frame
    BloodSurgeAlertFrameIcon = CreateFrame("StatusBar", nil, BloodSurgeAlertFrame)
    BloodSurgeAlertFrameIcon:SetSize(50, 50)
    BloodSurgeAlertFrameIcon:SetPoint("TOP", 0, 0)
    BloodSurgeAlertFrameIcon.texture = BloodSurgeAlertFrameIcon:CreateTexture()
    BloodSurgeAlertFrameIcon.texture:SetAllPoints(true)
    -- BloodSurgeAlertFrameIcon.texture:SetTexture("Interface\\Icons\\ability_meleedamage")
    BloodSurgeAlertFrameIcon.texture:SetTexture("Interface\\Icons\\ability_warrior_decisivestrike")

    -- this is the frame used to create the cooldown swipe / fade out animation
    OverPowerAlertFrameFade = CreateFrame("StatusBar", nil, OverPowerAlertFrameIcon)
    OverPowerAlertFrameFade:SetSize(50, 50)
    OverPowerAlertFrameFade:SetPoint("TOP", 0, 0)
    OverPowerAlertFrameFade.texture = OverPowerAlertFrameFade:CreateTexture()
    OverPowerAlertFrameFade.texture:SetAllPoints(true)  
    OverPowerAlertFrameFade.texture:SetColorTexture(0.0, 0.0, 0.0, 0.5)

    -- this is the frame used to create the cooldown swipe / fade out animation
    BloodSurgeAlertFrameFade = CreateFrame("StatusBar", nil, BloodSurgeAlertFrameIcon)
    BloodSurgeAlertFrameFade:SetSize(50, 50)
    BloodSurgeAlertFrameFade:SetPoint("TOP", 0, 0)
    BloodSurgeAlertFrameFade.texture = BloodSurgeAlertFrameFade:CreateTexture()
    BloodSurgeAlertFrameFade.texture:SetAllPoints(true)
    BloodSurgeAlertFrameFade.texture:SetColorTexture(0.0, 0.0, 0.0, 0.5)

    -- this text shows the remaining time on the current overpower window
    OverPowerTimerText = OverPowerAlertFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    OverPowerTimerText:SetPoint("CENTER", 0, -25-5)
    OverPowerTimerText:SetText("")

    -- this text shows the remaining time on the current overpower window
    BloodSurgeTimerText = BloodSurgeAlertFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    BloodSurgeTimerText:SetPoint("CENTER", 0, -25-5)
    BloodSurgeTimerText:SetText("")

    OverPowerAlertFrame:Hide() -- hide frame after initializing
    BloodSurgeAlertFrame:Hide() -- hide frame after initializing
end

local function unlock()
    -- create dummy frame to position alert frame (initialize in init func)
    OverPowerDummyFrame:Show()
    OverPowerDummyFrame:SetSize(50, 50)
    OverPowerDummyFrame:SetPoint("CENTER", OverpowerPOSX, OverpowerPOSY)
    OverPowerDummyFrame.texture = OverPowerDummyFrame:CreateTexture()
    OverPowerDummyFrame.texture:SetAllPoints()
    OverPowerDummyFrame.texture:SetTexture("Interface\\Icons\\ability_meleedamage")

    -- create dummy frame to position alert frame (initialize in init func)
    BloodSurgeDummyFrame:Show()
    BloodSurgeDummyFrame:SetSize(50, 50)
    BloodSurgeDummyFrame:SetPoint("CENTER", BloodsurgePOSX, BloodsurgePOSY)
    BloodSurgeDummyFrame.texture = BloodSurgeDummyFrame:CreateTexture()
    BloodSurgeDummyFrame.texture:SetAllPoints()
    BloodSurgeDummyFrame.texture:SetTexture("Interface\\Icons\\ability_warrior_decisivestrike")
    -- BloodSurgeDummyFrame.texture:SetTexture("Interface\\Icons\\ability_meleedamage")
    -- BloodSurgeDummyFrame.texture:SetTexture("Interface\\Icons\\ability_warrior_bloodsurge")

    -- make OverPowerDummyFrame movable and save its position
    OverPowerDummyFrame:SetMovable(true)
    OverPowerDummyFrame:EnableMouse(true)
    OverPowerDummyFrame:RegisterForDrag("LeftButton")
    OverPowerDummyFrame:SetScript("OnDragStart", OverPowerDummyFrame.StartMoving)
    local function setFramePos()
        OverPowerDummyFrame:StopMovingOrSizing()
        _, _, _, OverpowerPOSX, OverpowerPOSY = OverPowerDummyFrame:GetPoint() -- saves points OverpowerPOSX and OverpowerPOSY to saved variables
    end
    OverPowerDummyFrame:SetScript("OnDragStop", setFramePos)

    -- make BloodSurgeDummyFrame movable and save its position
    BloodSurgeDummyFrame:SetMovable(true)
    BloodSurgeDummyFrame:EnableMouse(true)
    BloodSurgeDummyFrame:RegisterForDrag("LeftButton")
    BloodSurgeDummyFrame:SetScript("OnDragStart", BloodSurgeDummyFrame.StartMoving)
    local function setFramePos()
        BloodSurgeDummyFrame:StopMovingOrSizing()
        _, _, _, BloodsurgePOSX, BloodsurgePOSY = BloodSurgeDummyFrame:GetPoint() -- saves points BloodsurgePOSX and OverpowerPOSY to saved variables
    end
    BloodSurgeDummyFrame:SetScript("OnDragStop", setFramePos)

    -- create user help text
    local overpowerMoveText = OverPowerDummyFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    overpowerMoveText:SetPoint("TOP", 0, 12)
    overpowerMoveText:SetText("Move me!")

    -- create user help text
    local bloodsurgeMoveText = BloodSurgeDummyFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    bloodsurgeMoveText:SetPoint("TOP", 0, 12)
    bloodsurgeMoveText:SetText("Move me!")

    local overpowerLockText = OverPowerDummyFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    overpowerLockText:SetPoint("BOTTOM", 0, -12)
    overpowerLockText:SetText("'/snipy lock' to lock")

    local bloodsurgeLockText = BloodSurgeDummyFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    bloodsurgeLockText:SetPoint("BOTTOM", 0, -12)
    bloodsurgeLockText:SetText("'/snipy lock' to lock")
end

local function lock()
    OverPowerDummyFrame:EnableMouse(false)
    OverPowerDummyFrame:Hide()
    BloodSurgeDummyFrame:EnableMouse(false)
    BloodSurgeDummyFrame:Hide()
end

-- event that is triggered after a dodge occurs
local function triggerOverpowerAlert()
    lock()
    OverPowerAlertFrame:SetPoint("CENTER", OverpowerPOSX, OverpowerPOSY)

    -- show frame
    OverPowerAlertFrame:Show()

    -- set some useful variables
    local START = 0
    local END = 5
    local timer = 0
    OverPowerAlertFrameFade:SetMinMaxValues(START, END)

    -- timer script
    OverPowerAlertFrameFade:SetScript("OnUpdate", function(self, elapsed)
        timer = timer + elapsed -- add amount of elapsed time since last update to current timer
        local percentDone = timer / END -- get percentage of total time elapsed
        OverPowerAlertFrameFade:SetSize(50, 50*percentDone) -- update fade frame to reflect time remaining
        OverPowerTimerText:SetText(string.format("%.1f", END - timer)) -- update timer below alert

        -- when timer reaches desired value, defined by END (seconds), restart by setting to 0, defined by START
        if timer >= END then
            timer = START -- reset timer to 0
            OverPowerAlertFrame:Hide() -- hide frame when complete
        end
    end)
end

local function triggerBloodSurgeAlert()
    lock()
    BloodSurgeAlertFrame:SetPoint("CENTER", BloodsurgePOSX, BloodsurgePOSY)

    -- show frame
    BloodSurgeAlertFrame:Show()

    -- set some useful variables
    local START = 0
    local END = 15
    local timer = 0
    BloodSurgeAlertFrameFade:SetMinMaxValues(START, END)

    -- timer script
    BloodSurgeAlertFrameFade:SetScript("OnUpdate", function(self, elapsed)
        timer = timer + elapsed -- add amount of elapsed time since last update to current timer
        local percentDone = timer / END -- get percentage of total time elapsed
        BloodSurgeAlertFrameFade:SetSize(50, 50*percentDone) -- update fade frame to reflect time remaining
        BloodSurgeTimerText:SetText(string.format("%.1f", END - timer)) -- update timer below alert

        -- when timer reaches desired value, defined by END (seconds), restart by setting to 0, defined by START
        if timer >= END then
            timer = START -- reset timer to 0
            BloodSurgeAlertFrame:Hide() -- hide frame when complete
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
                OverPowerAlertFrame:Hide()
            end

            -- check if Blood Surge is known
            if(GetSpellInfo(NAME_BLOODSURGE)) then
                -- for some reason slam shows as SPELL_DAMAGE when it's an instant Blood Surge proc
                if(arr[13] == NAME_SLAM and arr[2] == "SPELL_DAMAGE") then
                    BloodSurgeAlertFrame:Hide()
                end

                
                if arr[12] == NAME_BLOODSURGE or arr[13] == NAME_BLOODSURGE then
                    triggerBloodSurgeAlert()
                end

                            -- fade bloodsurge alert out when bloodsurge is still on CD
                local bloodsurgeStart, bloodsurgeDuration, bloodsuregeEnabled, _ = GetSpellCooldown(NAME_BLOODSURGE)
                local bsCD = bloodsurgeStart + bloodsurgeDuration - GetTime()
                if(bsCD > 1.5) then
                    BloodSurgeAlertFrame:SetAlpha(.2)
                else
                    BloodSurgeAlertFrame:SetAlpha(1)
                end
            end

            -- below works (on swings and spells)
            if arr[12] == eventSearchingFor or arr[15] == eventSearchingFor then
                triggerOverpowerAlert()
            end
        end

        -- fade overpower alert out when overpower is still on CD
        local start, duration, enabled, _ = GetSpellCooldown(NAME_OVERPOWER)
        local opCD = start + duration - GetTime()
        if(opCD > 1.5) then
            OverPowerAlertFrame:SetAlpha(.2)
        else
            OverPowerAlertFrame:SetAlpha(1)
        end
    end
end

-- slash command to test alert
SLASH_SNIPY_TEST1 = "/snipy"
SlashCmdList["SNIPY_TEST"] = function(msg)
    if(msg == "test" or msg == "t") then
        triggerOverpowerAlert()
        triggerBloodSurgeAlert()
    elseif(msg == "unlock" or msg == "ul" or msg == "u") then
        print("Unlocking frame.")
        unlock()
    elseif(msg == "lock" or msg == "l") then
        print("Locking frame.")
        lock()
    elseif(msg == "reset") then
        print("Resetting position.")
        OverpowerPOSX = 100
        OverpowerPOSY = 0
        BloodsurgePOSX = -100
        BloodsurgePOSY = 0
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
NAME_SLAM = GetSpellInfo(1464)
NAME_BLOODSURGE = GetSpellInfo(413380)

initAlert() -- initialize alert frame
print("Snipy Alerts loaded.")
