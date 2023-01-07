require "ETWModData";

local SBvars = SandboxVars.EvolvingTraitsWorld;

local function outdoorsman() -- confirmed working
	local player = getPlayer();
	local climateManager = getClimateManager();
	local rainIntensity = climateManager:getRainIntensity();
	local snowIntensity = climateManager:getSnowIntensity();
	local windIntensity = climateManager:getWindIntensity();
	local fogIntensity = climateManager:getFogIntensity();
	local isThunderstorm = climateManager:getIsThunderStorming();
	if player:isOutside() and player:getVehicle() == nil then
		local baseGain = 1;
		local rainGain = 5 * rainIntensity * (player:HasTrait("Pluviophile") and 1.2 or 1) * (isThunderstorm and 3 or 1);
		local snowGain = 2 * snowIntensity;
		local windGain = 2 * windIntensity;
		local fogGain = fogIntensity;
		local totalGain = baseGain + (rainGain + snowGain + windGain + fogGain) * (player:HasTrait("Hiker") and 1.1 or 1);
		local modData = player:getModData().EvolvingTraitsWorld;
		modData.OutdoorsmanCounter = modData.OutdoorsmanCounter + totalGain;
		--print("ETW Logger: Outdoorsman totalGain="..totalGain..". OutdoorsmanCounter=" .. modData.OutdoorsmanCounter);
		if modData.OutdoorsmanCounter >= SBvars.OutdoorsmanCounter then
			player:getTraits():add("Outdoorsman");
			HaloTextHelper.addTextWithArrow(player, getText("UI_trait_outdoorsman"), true, HaloTextHelper.getColorGreen());
			Events.EveryOneMinute.Remove(outdoorsman);
		end
	end
end

local function rainTraits() -- confirmed working
	local player = getPlayer();
	local rainIntensity = getClimateManager():getRainIntensity();
	if rainIntensity > 0 and player:isOutside() and player:getVehicle() == nil then
		local primaryItem = player:getPrimaryHandItem();
		local secondaryItem = player:getSecondaryHandItem();
		local rainProtection = (primaryItem and primaryItem:isProtectFromRainWhileEquipped()) or (secondaryItem and secondaryItem:isProtectFromRainWhileEquipped());
		local rainGain = rainIntensity * (rainProtection and 0.5 or 1);
		local modData = player:getModData().EvolvingTraitsWorld;
		--print("ETW Logger: rainTraits rainGain="..rainGain..". RainCounter=" .. modData.RainCounter);
		modData.RainCounter = modData.RainCounter + rainGain;
		if player:HasTrait("Pluviophobia") and modData.RainCounter >= SBvars.RainSystemCounter / 2 then
			player:getTraits():remove("Pluviophobia");
			HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Pluviophobia"), false, HaloTextHelper.getColorGreen());
		elseif not player:HasTrait("Pluviophile") and modData.RainCounter >= SBvars.RainSystemCounter then
			player:getTraits():add("Pluviophile");
			HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Pluviophobia"), true, HaloTextHelper.getColorGreen());
			Events.EveryOneMinute.Remove(rainTraits);
		end
	end
end

local function initializeEvents(playerIndex, player)
	if SBvars.Outdoorsman == true and not player:HasTrait("Outdoorsman") then Events.EveryOneMinute.Add(outdoorsman) end
	if SBvars.RainSystem == true and not player:HasTrait("Pluviophile") then Events.EveryOneMinute.Add(rainTraits) end
end

Events.OnCreatePlayer.Add(initializeEvents);