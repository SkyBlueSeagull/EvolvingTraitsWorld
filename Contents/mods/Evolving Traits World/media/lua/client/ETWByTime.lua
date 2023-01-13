require "ETWModData";
local ETWMoodles = require "ETWMoodles";

local SBvars = SandboxVars.EvolvingTraitsWorld;

local notification = function() return EvolvingTraitsWorld.settings.EnableNotifications end


local function catEyes()
	-- confirmed working
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
		if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_NightVision"), true, HaloTextHelper.getColorGreen()) end
		Events.EveryOneMinute.Remove(catEyes);
	end
end

local function findMidpoint(time1, time2)
	local midPoint = 0;
	if time1 > time2 then midPoint = (time1 + time2 + 24) / 2 else midPoint = (time1 + time2) / 2 end
	if midPoint >= 24 then midPoint = midPoint - 24 end
	return midPoint
end

local function sleepSystem()
	local player = getPlayer();
	local modData = player:getModData().EvolvingTraitsWorld.SleepSystem;
	local timeOfDay = getGameTime():getTimeOfDay();
	local currentPreferredTargetHour = modData.LastMidpoint;
	if player:isAsleep() then
		local hoursAwayFromPreferredHour = math.min(math.abs(currentPreferredTargetHour - timeOfDay), 24 - math.abs(timeOfDay - currentPreferredTargetHour));
		if modData.CurrentlySleeping == false then modData.CurrentlySleeping = true end
		if hoursAwayFromPreferredHour <= 6 then
			modData.SleepHealthinessBar = math.min(200, (modData.SleepHealthinessBar + 1 / 6) * SBvars.SleepSystemMultiplier);
		else
			modData.SleepHealthinessBar = math.max(-200, (modData.SleepHealthinessBar - 1 / 6) * SBvars.SleepSystemMultiplier);
		end
		ETWMoodles.sleepHealthMoodleUpdate(player, hoursAwayFromPreferredHour, false);
	end
	if not player:isAsleep() and modData.CurrentlySleeping == true then
		ETWMoodles.sleepHealthMoodleUpdate(nil, nil, true);
		modData.CurrentlySleeping = false;
		modData.HoursSinceLastSleep = 0;
		--print("ETW Logger: AVG from: modData.Last100PreferredHour"..currentPreferredTargetHour);
		--print("ETW Logger: SleepHealthinessBar: "..modData.SleepHealthinessBar);
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
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_LessSleep"), true, HaloTextHelper.getColorGreen()) end
		end
	elseif modData.SleepHealthinessBar < -100 then
		if not player:HasTrait("NeedsMoreSleep") then
			player:getTraits():add("NeedsMoreSleep")
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_MoreSleep"), true, HaloTextHelper.getColorRed()) end
		end
	else
		if player:HasTrait("NeedsLessSleep") then
			player:getTraits():remove("NeedsLessSleep")
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_LessSleep"), false, HaloTextHelper.getColorRed()) end
		end
		if player:HasTrait("NeedsMoreSleep") then
			player:getTraits():remove("NeedsMoreSleep")
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_MoreSleep"), true, HaloTextHelper.getColorGreen()) end
		end
	end
	--print("ETW Logger: modData.SleepHealthinessBar: "..modData.SleepHealthinessBar);
end

local function smoker()
	local player = getPlayer();
	local modData = player:getModData().EvolvingTraitsWorld.SmokeSystem; -- SmokingAddiction MinutesSinceLastSmoke
	local timeSinceLastSmoke = player:getTimeSinceLastSmoke() * 60;
	modData.MinutesSinceLastSmoke = modData.MinutesSinceLastSmoke + 1;
	--print("ETW Logger: timeSinceLastSmoke: "..timeSinceLastSmoke);
	--print("ETW Logger: modData.MinutesSinceLastSmoke: "..modData.MinutesSinceLastSmoke);
	local stress = player:getStats():getStress(); -- stress is 0-1
	local panic = player:getStats():getPanic(); -- 0-100
	local addictionDecay = SBvars.SmokingAddictionDecay * ( 0.0167 / 10 * (1 + stress) * (1 + panic / 100));
	modData.SmokingAddiction = math.max(0, modData.SmokingAddiction - addictionDecay);
	ETWMoodles.smokerMoodleUpdate(player, modData.SmokingAddiction);
	--print("ETW Logger: addictionDecay: "..addictionDecay);
	--print("ETW Logger: modData.SmokingAddiction: "..modData.SmokingAddiction);
	if modData.SmokingAddiction >= SBvars.SmokerCounter and not player:HasTrait("Smoker") then
		player:getTraits():add("Smoker")
		if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Smoker"), true, HaloTextHelper.getColorRed()) end
	elseif modData.SmokingAddiction <= SBvars.SmokerCounter / 2 and player:HasTrait("Smoker") then
		player:getTraits():remove("Smoker")
		if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Smoker"), false, HaloTextHelper.getColorGreen()) end
	end
end

local function initializeEvents(playerIndex, player)
	Events.EveryOneMinute.Remove(catEyes);
	if SBvars.CatEyes == true and not player:HasTrait("NightVision") then Events.EveryOneMinute.Add(catEyes) end
	Events.EveryTenMinutes.Remove(sleepSystem);
	if SBvars.SleepSystem == true then Events.EveryTenMinutes.Add(sleepSystem) end
	Events.EveryOneMinute.Remove(smoker);
	if SBvars.Smoker == true then Events.EveryOneMinute.Add(smoker) end
end

Events.OnCreatePlayer.Remove(initializeEvents);
Events.OnCreatePlayer.Add(initializeEvents);