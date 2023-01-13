require "ETWModData";

local SBvars = SandboxVars.EvolvingTraitsWorld;

local notification = function() return EvolvingTraitsWorld.settings.EnableNotifications end

local function outdoorsman()
	-- confirmed working
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
		--print("ETW Logger: Outdoorsman totalGain=" .. totalGain .. ". OutdoorsmanCounter=" .. modData.OutdoorsmanCounter);
		if not player:HasTrait("Outdoorsman") and modData.OutdoorsmanCounter >= SBvars.OutdoorsmanCounter then
			player:getTraits():add("Outdoorsman");
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_outdoorsman"), true, HaloTextHelper.getColorGreen()) end
		end
	else
		local totalLose = totalGain * 0.1 * (1 + modData.MinutesSinceOutside / 100) * SBvars.OutdoorsmanCounterLoseMultiplier;
		modData.MinutesSinceOutside = math.min(900, modData.MinutesSinceOutside + 1);
		modData.OutdoorsmanCounter = math.max(0, modData.OutdoorsmanCounter - totalLose);
		--print("ETW Logger: Outdoorsman totalLose=" .. totalLose .. ". OutdoorsmanCounter=" .. modData.OutdoorsmanCounter);
		if player:HasTrait("Outdoorsman") and modData.OutdoorsmanCounter <= SBvars.OutdoorsmanCounter / 2 then
			player:getTraits():remove("Outdoorsman");
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_outdoorsman"), false, HaloTextHelper.getColorRed()) end
		end
	end
end

local function rainTraits()
	-- confirmed working
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
		local lowerBoundary = -SBCounter;
		local upperBoundary = SBCounter * 2;
		if panic <= 25 then
			--print("ETW Logger: rainTraits rainGain="..rainGain..". RainCounter=" .. modData.RainCounter);
			modData.RainCounter = math.min(upperBoundary, modData.RainCounter + rainGain);
		else
			local rainDecrease = rainGain * panic / 100 * SBvars.RainSystemCounterMultiplier;
			--print("ETW Logger: rainTraits rainDecrease="..rainDecrease..". RainCounter=" .. modData.RainCounter);
			modData.RainCounter = math.max(lowerBoundary, modData.RainCounter - rainDecrease);
		end
		if not player:HasTrait("Pluviophobia") and modData.RainCounter <= 0 then
			player:getTraits():add("Pluviophobia");
			if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Pluviophobia"), true, HaloTextHelper.getColorRed()) end
		elseif player:HasTrait("Pluviophobia") and modData.RainCounter > 0 then
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

local function initializeEvents(playerIndex, player)
	Events.EveryOneMinute.Remove(outdoorsman)
	if SBvars.Outdoorsman == true then Events.EveryOneMinute.Add(outdoorsman) end
	Events.EveryOneMinute.Remove(rainTraits)
	if SBvars.RainSystem == true then Events.EveryOneMinute.Add(rainTraits) end
end

Events.OnCreatePlayer.Remove(initializeEvents);
Events.OnCreatePlayer.Add(initializeEvents);