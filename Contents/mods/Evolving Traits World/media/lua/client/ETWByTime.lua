require "ETWModData";

local SBvars = SandboxVars.EvolvingTraitsWorld;

local function catEyes() -- confirmed working
    local player = getPlayer();
    local nightStrength = getClimateManager():getNightStrength()
    local playerNum = player:getPlayerNum();
    local checkedSquares = 0;
    local squaresVisible = 0;
    local darknessLevel = 0;
    local square;
    local plX, plY, plZ = player:getX(), player:getY(), player:getZ();
    local radius = 30;
    local modData = player:getModData().EvolvingTraitsWorld;
    for x = -radius, radius do
        for y = -radius, radius do
            square = getCell():getGridSquare(plX + x, plY + y, plZ);
            checkedSquares = checkedSquares + 1;
            if square and square:isCanSee(playerNum) then
                local squareDarknessLevel = nightStrength * (1 - square:getLightLevel(playerNum)) * 0.01 * (square:isInARoom() and player:isInARoom() and 2 or 1);
                squaresVisible = squaresVisible + 1;
                darknessLevel = darknessLevel + squareDarknessLevel;
                modData.CatEyesCounter = modData.CatEyesCounter + squareDarknessLevel;
            end
        end
    end
    --print("ETW Logger: Checked squares: "..checkedSquares..", visible squares: "..squaresVisible.." with total darkness level of "..darknessLevel);
    --print("ETW Logger: CatEyesCounter: "..modData.CatEyesCounter);
    if not player:HasTrait("NightVision") and modData.CatEyesCounter >= SBvars.CatEyesCounter then
        player:getTraits():add("NightVision");
        HaloTextHelper.addTextWithArrow(player, getText("UI_trait_NightVision"), true, HaloTextHelper.getColorGreen());
        Events.EveryOneMinute.Remove(catEyes);
    end
end

local function calculateTime(time1, time2)
    local endTime = time1 + time2;
    if endTime < 0 then return endTime + 24
    elseif endTime > 24 then return endTime - 24
    else return endTime end
end

local function findMidpoint(time1, time2)
    local midPoint = 0;
    if time1 > time2 then midPoint = (time1 + time2 + 24) / 2
    else midPoint = (time1 + time2) / 2 end
    if midPoint <= 6 then midPoint = midPoint + 24 end
    return midPoint
end

local function insertValueInSleepTable(value, tableToInsertInto)
    table.insert(tableToInsertInto, 1, value);
    if #tableToInsertInto > 100 then
        tableToInsertInto[101] = nil;
    end
end

local function calculateAverage(values)
    local sum = 0;
    for i, value in ipairs(values) do
        sum = sum + value;
        --print("ETW Logger: Value in modData.Last100PreferredHour = "..value);
    end
    return sum / #values
end

local function sleepSystem()
    local player = getPlayer();
    local modData = player:getModData().EvolvingTraitsWorld.SleepSystem;
    local timeOfDay = getGameTime():getTimeOfDay();
    if player:isAsleep() then
        local currentPreferredTargetHour = calculateAverage(modData.Last100PreferredHour);
        local lowerBoundary = calculateTime(currentPreferredTargetHour, -6);
        local upperBoundary = calculateTime(currentPreferredTargetHour, 6);
        if modData.CurrentlySleeping == false then
            modData.WentToSleepAt = timeOfDay;
            modData.CurrentlySleeping = true;
        end
        if timeOfDay > lowerBoundary or timeOfDay < upperBoundary then
            modData.SleepHealthinessBar = math.min(200, (modData.SleepHealthinessBar + 1 / 6) * SBvars.SleepSystemMultiplier);
        else
            modData.SleepHealthinessBar = math.max(-200, (modData.SleepHealthinessBar - 1 / 6) * SBvars.SleepSystemMultiplier);
        end
    end
    if not player:isAsleep() and modData.CurrentlySleeping == true then
        --local currentPreferredTargetHour = calculateAverage(modData.Last100PreferredHour); -- only needed for debugging
        if modData.WentToSleepAt > timeOfDay then
            --print("ETW Logger: old currentPreferredTargetHour: "..currentPreferredTargetHour)
            --print("ETW Logger: findMidpoint("..modData.WentToSleepAt..", "..24 + timeOfDay..")="..findMidpoint(modData.WentToSleepAt, 24 + timeOfDay));
            insertValueInSleepTable(findMidpoint(modData.WentToSleepAt, 24 + timeOfDay), modData.Last100PreferredHour);
            --print("ETW Logger: new currentPreferredTargetHour: "..calculateAverage(modData.Last100PreferredHour));
        else
            --print("ETW Logger: old currentPreferredTargetHour: "..currentPreferredTargetHour)
            --print("ETW Logger: findMidpoint("..modData.WentToSleepAt..", "..timeOfDay..")="..findMidpoint(modData.WentToSleepAt, timeOfDay));
            insertValueInSleepTable(findMidpoint(modData.WentToSleepAt, timeOfDay), modData.Last100PreferredHour);
            --print("ETW Logger: new currentPreferredTargetHour: "..calculateAverage(modData.Last100PreferredHour));
        end
        modData.CurrentlySleeping = false;
        modData.HoursSinceLastSleep = 0;
    end
    if not player:isAsleep() then
        modData.HoursSinceLastSleep = modData.HoursSinceLastSleep + 1 / 6;
        if modData.HoursSinceLastSleep >= 24 then
            modData.SleepHealthinessBar = math.max(-200, (modData.SleepHealthinessBar - 1 / 6) * SBvars.SleepSystemMultiplier);
        end
    end
    if modData.SleepHealthinessBar > 100 then
        if not player:HasTrait("NeedsLessSleep") then
            player:getTraits():add("NeedsLessSleep")
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_LessSleep"), true, HaloTextHelper.getColorGreen())
        end
    elseif modData.SleepHealthinessBar < -100 then
        if not player:HasTrait("NeedsMoreSleep") then
            player:getTraits():add("NeedsMoreSleep")
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_MoreSleep"), true, HaloTextHelper.getColorRed())
        end
    else
        if player:HasTrait("NeedsLessSleep") then
            player:getTraits():remove("UI_trait_LessSleep")
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_LessSleep"), false, HaloTextHelper.getColorRed())
        end
        if player:HasTrait("NeedsMoreSleep") then
            player:getTraits():remove("UI_trait_MoreSleep")
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_MoreSleep"), true, HaloTextHelper.getColorGreen())
        end
    end
    --print("ETW Logger: modData.SleepHealthinessBar: "..modData.SleepHealthinessBar);
end

local function initializeEvents(playerIndex, player)
    if SBvars.CatEyes == true and not player:HasTrait("NightVision") then Events.EveryOneMinute.Add(catEyes) end
    if SBvars.SleepSystem == true then Events.EveryTenMinutes.Add(sleepSystem) end
end

Events.OnCreatePlayer.Add(initializeEvents);