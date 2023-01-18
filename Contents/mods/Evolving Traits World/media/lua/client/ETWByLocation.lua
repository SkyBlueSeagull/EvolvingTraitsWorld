require "ETWModData";

local SBvars = SandboxVars.EvolvingTraitsWorld;

local notification = function() return EvolvingTraitsWorld.settings.EnableNotifications end
local debug = function() return EvolvingTraitsWorld.settings.GatherDebug end

local function outdoorsman()
	local player = getPlayer();
	local modData = player:getModData().EvolvingTraitsWorld.OutdoorsmanSystem;
	local climateManager = getClimateManager();
	local rainIntensity = climateManager:getRainIntensity();
	local snowIntensity = climateManager:getSnowIntensity();
	local windIntensity = climateManager:getWindIntensity();
	local fogIntensity = climateManager:getFogIntensity();
	local isThunderstorm = climateManager:getIsThunderStorming();
	local baseGain = 1;
	local rainGain = 5 * rainIntensity * (player:HasTrait("Pluviophile") and 1.2 or 1) * (isThunderstorm and 3 or 1);
	local snowGain = 2 * snowIntensity;
	local windGain = 2 * windIntensity;
	local fogGain = fogIntensity;
	local totalGain = baseGain + (rainGain + snowGain + windGain + fogGain) * (player:HasTrait("Hiker") and 1.1 or 1);
	if player:isOutside() and player:getVehicle() == nil then
		modData.MinutesSinceOutside = math.max(0, modData.MinutesSinceOutside - 3);
		modData.OutdoorsmanCounter = math.min(modData.OutdoorsmanCounter + totalGain, SBvars.OutdoorsmanCounter * 10);
		if debug() then print("ETW Logger: Outdoorsman totalGain=" .. totalGain .. ". OutdoorsmanCounter=" .. modData.OutdoorsmanCounter) end
		if not player:HasTrait("Outdoorsman") and modData.OutdoorsmanCounter >= SBvars.OutdoorsmanCounter then
			player:getTraits():add("Outdoorsman");
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_outdoorsman"), true, HaloTextHelper.getColorGreen()) end
		end
	elseif modData.OutdoorsmanCounter > 0 then
		local totalLose = totalGain * 0.1 * (1 + modData.MinutesSinceOutside / 100) * SBvars.OutdoorsmanCounterLoseMultiplier;
		modData.MinutesSinceOutside = math.min(900, modData.MinutesSinceOutside + 1);
		modData.OutdoorsmanCounter = math.max(0, modData.OutdoorsmanCounter - totalLose);
		if debug() then print("ETW Logger: Outdoorsman totalLose=" .. totalLose .. ". OutdoorsmanCounter=" .. modData.OutdoorsmanCounter) end
		if player:HasTrait("Outdoorsman") and modData.OutdoorsmanCounter <= SBvars.OutdoorsmanCounter / 2 then
			player:getTraits():remove("Outdoorsman");
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_outdoorsman"), false, HaloTextHelper.getColorRed()) end
		end
	end
end

local function fearOfLocations()
	local player = getPlayer();
	local modData = player:getModData().EvolvingTraitsWorld.LocationFearSystem;
	local stress = player:getStats():getStress(); -- 0-1
	local unhappiness = player:getBodyDamage():getUnhappynessLevel(); -- 0-100
	local SBCounter = SBvars.FearOfLocationsSystemCounter;
	local upperCounterBoundary = SBCounter * 2;
	local lowerCounterBoundary = -2 * SBCounter;
	local counterDecrease = 1;
	if stress > 0 then counterDecrease = counterDecrease * (2 * stress) end
	if unhappiness > 0 then counterDecrease = counterDecrease * (2 * unhappiness / 100) end
	if counterDecrease == 1 then counterDecrease = 0 end
	counterDecrease = counterDecrease * SBvars.FearOfLocationsSystemCounterLoseMultiplier;
	if player:isOutside() then
		local resultingCounter = modData.FearOfOutside - counterDecrease + 1; -- +1 from passive ticking of just being outside
		resultingCounter = math.min(upperCounterBoundary, resultingCounter);
		resultingCounter = math.max(lowerCounterBoundary, resultingCounter);
		if debug() then modData.FearOfOutside = resultingCounter; print("ETW Logger: modData.FearOfOutside: " .. modData.FearOfOutside) end
		if player:HasTrait("Agoraphobic") and modData.FearOfOutside >= SBCounter then
			player:getTraits():remove("Agoraphobic");
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_agoraphobic"), false, HaloTextHelper.getColorGreen()) end
		end
		if not player:HasTrait("Agoraphobic") and modData.FearOfOutside <= -SBCounter then
			player:getTraits():add("Agoraphobic");
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_agoraphobic"), true, HaloTextHelper.getColorRed()) end
		end
	elseif not player:isOutside() or player:getVehicle() ~= nil then
		local resultingCounter = modData.FearOfInside - counterDecrease + 1; -- +1 from passive ticking of just being outside
		resultingCounter = math.min(upperCounterBoundary, resultingCounter);
		resultingCounter = math.max(lowerCounterBoundary, resultingCounter);
		modData.FearOfInside = resultingCounter;
		if debug() then print("ETW Logger: modData.FearOfInside: " .. modData.FearOfInside) end
		if player:HasTrait("Claustophobic") and modData.FearOfInside >= SBCounter then
			player:getTraits():remove("Claustophobic");
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_claustro"), false, HaloTextHelper.getColorGreen()) end
		end
		if not player:HasTrait("Claustophobic") and modData.FearOfInside <= -SBCounter then
			player:getTraits():add("Claustophobic");
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_claustro"), true, HaloTextHelper.getColorRed()) end
		end
	end
end

local function initializeEvents(playerIndex, player)
	Events.EveryOneMinute.Remove(outdoorsman)
	if SBvars.Outdoorsman == true then Events.EveryOneMinute.Add(outdoorsman) end
	Events.EveryOneMinute.Remove(fearOfLocations);
	if SBvars.FearOfLocationsSystem == true then Events.EveryOneMinute.Add(fearOfLocations) end
end

Events.OnCreatePlayer.Remove(initializeEvents);
Events.OnCreatePlayer.Add(initializeEvents);