require "ETWModData";

local SBvars = SandboxVars.EvolvingTraitsWorld;

local notification = function() return EvolvingTraitsWorld.settings.EnableNotifications end
local debug = function() return EvolvingTraitsWorld.settings.GatherDebug end

local function rainTraits()
	local player = getPlayer();
	local rainIntensity = getClimateManager():getRainIntensity();
	if rainIntensity > 0 and player:isOutside() and player:getVehicle() == nil then
		local panic = player:getStats():getPanic(); -- 0-100
		local primaryItem = player:getPrimaryHandItem();
		local secondaryItem = player:getSecondaryHandItem();
		local rainProtection = (primaryItem and primaryItem:isProtectFromRainWhileEquipped()) or (secondaryItem and secondaryItem:isProtectFromRainWhileEquipped());
		local rainGain = rainIntensity * (rainProtection and 0.5 or 1);
		local modData = player:getModData().EvolvingTraitsWorld;
		local SBCounter = SBvars.RainSystemCounter
		local lowerBoundary = -SBCounter * 2;
		local upperBoundary = SBCounter * 2;
		if panic <= 25 then
			if debug() then print("ETW Logger: rainTraits rainGain="..rainGain..". RainCounter=" .. modData.RainCounter) end
			modData.RainCounter = math.min(upperBoundary, modData.RainCounter + rainGain);
		else
			local rainDecrease = rainGain * panic / 100 * SBvars.RainSystemCounterMultiplier;
			if debug() then print("ETW Logger: rainTraits rainDecrease="..rainDecrease..". RainCounter=" .. modData.RainCounter) end
			modData.RainCounter = math.max(lowerBoundary, modData.RainCounter - rainDecrease);
		end
		if not player:HasTrait("Pluviophobia") and modData.RainCounter <= -SBCounter then
			player:getTraits():add("Pluviophobia");
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Pluviophobia"), true, HaloTextHelper.getColorRed()) end
		elseif player:HasTrait("Pluviophobia") and modData.RainCounter > -SBCounter then
			player:getTraits():remove("Pluviophobia");
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Pluviophobia"), false, HaloTextHelper.getColorGreen()) end
		elseif player:HasTrait("Pluviophile") and modData.RainCounter <= SBCounter then
			player:getTraits():remove("Pluviophile");
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Pluviophile"), false, HaloTextHelper.getColorRed()) end
		elseif not player:HasTrait("Pluviophile") and modData.RainCounter > SBCounter then
			player:getTraits():add("Pluviophile");
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Pluviophile"), true, HaloTextHelper.getColorGreen()) end
		end
	end
end

local function fogTraits()
	local player = getPlayer();
	local fogIntensity = getClimateManager():getFogIntensity();
	if fogIntensity > 0 and player:isOutside() and player:getVehicle() == nil then
		local panic = player:getStats():getPanic(); -- 0-100
		local fogGain = fogIntensity * SBvars.FogSystemCounterIncreaseMultiplier;
		local fogDecrease = fogIntensity * (panic / 100) * 0.9 * SBvars.FogSystemCounterDecreaseMultiplier;
		local modData = player:getModData().EvolvingTraitsWorld;
		local SBCounter = SBvars.FogSystemCounter
		local lowerBoundary = -SBCounter * 2;
		local upperBoundary = SBCounter * 2;
		local finalFogCounter = modData.FogCounter + fogGain - fogDecrease;
		finalFogCounter = math.max(finalFogCounter, lowerBoundary);
		finalFogCounter = math.min(finalFogCounter, upperBoundary);
		modData.FogCounter = finalFogCounter;
		if debug() then print("ETW Logger: modData.FogCounter="..modData.FogCounter) end
		if not player:HasTrait("Homichlophobia") and modData.RainCounter <= -SBCounter then
			player:getTraits():add("Homichlophobia");
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Homichlophobia"), true, HaloTextHelper.getColorRed()) end
		elseif player:HasTrait("Homichlophobia") and modData.RainCounter > -SBCounter then
			player:getTraits():remove("Homichlophobia");
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Homichlophobia"), false, HaloTextHelper.getColorGreen()) end
		elseif player:HasTrait("Homichlophile") and modData.RainCounter <= SBCounter then
			player:getTraits():remove("Homichlophile");
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Homichlophobia"), false, HaloTextHelper.getColorRed()) end
		elseif not player:HasTrait("Homichlophile") and modData.RainCounter > SBCounter then
			player:getTraits():add("Homichlophile");
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Homichlophobia"), true, HaloTextHelper.getColorGreen()) end
		end
	end
end

local function initializeEvents(playerIndex, player)
	Events.EveryOneMinute.Remove(rainTraits)
	if SBvars.RainSystem == true then Events.EveryOneMinute.Add(rainTraits) end
	Events.EveryOneMinute.Remove(fogTraits)
	if SBvars.FogSystem == true then Events.EveryOneMinute.Add(fogTraits) end
end

Events.OnCreatePlayer.Remove(initializeEvents);
Events.OnCreatePlayer.Add(initializeEvents);