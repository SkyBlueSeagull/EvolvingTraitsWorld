require "ETWModData";

local SBvars = SandboxVars.EvolvingTraitsWorld;

local notification = function() return EvolvingTraitsWorld.settings.EnableNotifications end
local debug = function() return EvolvingTraitsWorld.settings.GatherDebug end

local function onZombieKill(zombie)
	local player = getPlayer();
	if player:HasTrait("Bloodlust") and player:DistTo(zombie) <= 4 then
		local bodydamage = player:getBodyDamage();
		local stats = player:getStats();
		local unhappiness = bodydamage:getUnhappynessLevel(); -- 0-100
		local stress = stats:getStress(); -- 0-1
		local panic = stats:getPanic(); -- 0-100
		bodydamage:setUnhappynessLevel(math.max(0, unhappiness - 4));
		stats:setStress(math.max(0, stress - 0.04));
		stats:setPanic(math.max(0, panic - 4));
		if debug() then print("ETW Logger: Bloodlust kill. Unhappiness:"..unhappiness.."->"..bodydamage:getUnhappynessLevel()..", stress: "..stress.."->"..stats:getStress()..", panic: "..panic.."->"..stats:getPanic()) end
	end
end

local function checkWeightLimit(player)
	if not getActivatedMods():contains("ToadTraitsDynamic") and player:HasTrait("Hoarder") then
		local default = 8;
		local strength = player:getPerkLevel(Perks.Strength);
		local hoarderBaseWeight = default + strength * SBvars.HoarderWeight;
		if player:getMaxWeightBase() ~= hoarderBaseWeight then
			player:setMaxWeightBase(hoarderBaseWeight);
			if debug() then print("ETW Logger: Set Hoarder maxWeightBase to"..hoarderBaseWeight) end
		end
	end
end

local function rainTraits(player, rainIntensity)
	local primaryItem = player:getPrimaryHandItem();
	local secondaryItem = player:getSecondaryHandItem();
	local rainProtection = (primaryItem and primaryItem:isProtectFromRainWhileEquipped()) or (secondaryItem and secondaryItem:isProtectFromRainWhileEquipped());
	local bodydamage = player:getBodyDamage();
	local stats = player:getStats();
	if player:HasTrait("Pluviophobia") then
		local unhappinessIncrease = 0.1 * rainIntensity * (rainProtection and 0.5 or 1) * SBvars.PluviophobiaMultiplier;
		bodydamage:setUnhappynessLevel(bodydamage:getUnhappynessLevel() + unhappinessIncrease);
		if debug() then print("ETW Logger: Pluviophobia: unhappinessIncrease:"..unhappinessIncrease) end
		local boredomIncrease = 0.02 * rainIntensity * (rainProtection and 0.5 or 1) * SBvars.PluviophobiaMultiplier;
		stats:setBoredom(stats:getBoredom() + boredomIncrease);
		if debug() then print("ETW Logger: Pluviophobia: boredomIncrease:"..boredomIncrease) end
		local stressIncrease = 0.04 * rainIntensity * (rainProtection and 0.5 or 1) * SBvars.PluviophobiaMultiplier;
		stats:setStress(stats:getStress() + stressIncrease);
		if debug() then print("ETW Logger: Pluviophobia: stressIncrease:"..stressIncrease) end
	elseif player:HasTrait("Pluviophile") then
		local unhappinessDecrease = 0.1 * rainIntensity * (rainProtection and 0.5 or 1) * SBvars.PluviophileMultiplier;
		bodydamage:setUnhappynessLevel(bodydamage:getUnhappynessLevel() - unhappinessDecrease);
		if debug() then print("ETW Logger: Pluviophile: unhappinessDecrease:"..unhappinessDecrease) end
		local boredomDecrease = 0.02 * rainIntensity * (rainProtection and 0.5 or 1) * SBvars.PluviophileMultiplier;
		stats:setBoredom(stats:getBoredom() - boredomDecrease);
		if debug() then print("ETW Logger: Pluviophile: boredomDecrease:"..boredomDecrease) end
		local stressDecrease = 0.04 * rainIntensity * (rainProtection and 0.5 or 1) * SBvars.PluviophileMultiplier;
		stats:setStress(stats:getStress() - stressDecrease);
		if debug() then print("ETW Logger: Pluviophile: stressDecrease:"..stressDecrease) end
	end
end

local function fogTraits(player, fogIntensity)
	local bodydamage = player:getBodyDamage();
	local stats = player:getStats();
	if player:HasTrait("Homichlophobia") then
		local panicIncrease = 4 * fogIntensity * SBvars.HomichlophobiaMultiplier;
		local resultingPanic = stats:getPanic() + panicIncrease;
		if resultingPanic <= 50 then
			stats:setPanic(resultingPanic);
			if debug() then print("ETW Logger: Homichlophobia: panicIncrease:"..panicIncrease) end
		end
		local stressIncrease = 0.04 * fogIntensity * SBvars.HomichlophobiaMultiplier;
		local resultingStress = stats:getStress() + stressIncrease;
		if resultingStress <= 0.5 then
			stats:setStress(resultingStress);
			if debug() then print("ETW Logger: Homichlophobia: stressIncrease:"..stressIncrease) end
		end
	elseif player:HasTrait("Homichlophile") then
		local panicDecrease = 4 * fogIntensity * SBvars.HomichlophileMultiplier;
		stats:setPanic(stats:getPanic() - panicDecrease);
		if debug() then print("ETW Logger: Homichlophile: panicDecrease:"..panicDecrease) end
		local stressDecrease = 0.04 * fogIntensity * SBvars.HomichlophileMultiplier;
		stats:setStress(stats:getStress() - stressDecrease);
		if debug() then print("ETW Logger: Homichlophile: stressDecrease:"..stressDecrease) end
	end
end

local function oneMinuteUpdate()
	local player = getPlayer();
	if false and not getActivatedMods():contains("SimpleOverhaulTraitsAndOccupations") and not getActivatedMods():contains("MoreSimpleTraitsVanilla") and not getActivatedMods():contains("MoreSimpleTraits") then
		-- pending SOTO/MST update first
		checkWeightLimit(player)
	end
	checkWeightLimit(player)

	local climateManager = getClimateManager();
	local rainIntensity = climateManager:getRainIntensity();
	if rainIntensity > 0 and player:isOutside() then rainTraits(player, rainIntensity) end

	local fogIntensity = climateManager:getFogIntensity();
	if fogIntensity > 0 and player:isOutside() then fogTraits(player, fogIntensity)	end
end

local function initializeTraitsLogic(playerIndex, player)
	Events.OnZombieDead.Remove(onZombieKill);
	Events.OnZombieDead.Add(onZombieKill);
	Events.EveryOneMinute.Remove(oneMinuteUpdate);
	Events.EveryOneMinute.Add(oneMinuteUpdate);
end

Events.OnCreatePlayer.Remove(initializeTraitsLogic);
Events.OnCreatePlayer.Add(initializeTraitsLogic);