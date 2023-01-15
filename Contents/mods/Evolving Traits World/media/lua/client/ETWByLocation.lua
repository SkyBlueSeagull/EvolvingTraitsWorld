require "ETWModData";

local SBvars = SandboxVars.EvolvingTraitsWorld;

local notification = function() return EvolvingTraitsWorld.settings.EnableNotifications end

local function fearOfLocations()
	local player = getPlayer();
	local modData = player:getModData().EvolvingTraitsWorld.LocationFearSystem;
	local stress = player:getStats():getStress();
	local unhappiness = player:getBodyDamage():getUnhappynessLevel();
	--print("ETW Logger: stress: "..stress.." unhappiness:"..unhappiness); --stress is 0-1, unhappiness is 0-100
	local SBCounter = SBvars.FearOfLocationsSystemCounter;
	local upperCounterBoundary = SBCounter * 2;
	local lowerCounterBoundary = -2 * SBCounter;
	local counterDecrease = 1;
	if stress > 0 then counterDecrease = counterDecrease * (1 + stress) end
	if unhappiness > 0 then counterDecrease = counterDecrease * (1 + unhappiness / 100) end
	if counterDecrease == 1 then counterDecrease = 0 end
	counterDecrease = counterDecrease * SBvars.FearOfLocationsSystemCounterLoseMultiplier;
	if player:isOutside() then
		local resultingCounter = modData.FearOfOutside - counterDecrease + 1; -- +1 from passive ticking of just being outside
		resultingCounter = math.min(upperCounterBoundary, resultingCounter);
		resultingCounter = math.max(lowerCounterBoundary, resultingCounter);
		modData.FearOfOutside = resultingCounter;
		--print("ETW Logger: modData.FearOfOutside: " .. modData.FearOfOutside);
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
		--print("ETW Logger: modData.FearOfInside: " .. modData.FearOfInside);
		if player:HasTrait("Claustophobic") and modData.FearOfInside >= SBCounter then
			player:getTraits():remove("Claustophobic");
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_claustro"), false, HaloTextHelper.getColorGreen()) end
		end
		if not player:HasTrait("Claustophobic") and modData.FearOfInside <= -SBCounter then
			player:getTraits():add("Claustophobic");
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_claustro"), true, HaloTextHelper.getColorRed()) end
		end
	end
	--print("ETW Logger: ------------------------------------------------------------------------");
end

local function initializeEvents(playerIndex, player)
	Events.EveryOneMinute.Remove(fearOfLocations);
	if SBvars.FearOfLocationsSystem == true then Events.EveryOneMinute.Add(fearOfLocations) end
end

Events.OnCreatePlayer.Remove(initializeEvents);
Events.OnCreatePlayer.Add(initializeEvents);