require "DTWModData";

local SBvars = SandboxVars.DynamicTraitsWorld;

local function onZombieKill(zombie) -- confirmed working
	local player = getPlayer();
	if player:HasTrait("Bloodlust") and player:DistTo(zombie) <= 4 then
		local bodydamage = player:getBodyDamage();
		bodydamage:setUnhappynessLevel(bodydamage:getUnhappynessLevel() - 0.04);
		--print("DTW Logger: Bloodlust kill, adjusted unhappiness.");
	end
end

local function checkWeightLimit(player) -- confirmed working
	if not getActivatedMods():contains("ToadTraitsDynamic") and player:HasTrait("Hoarder") then
		local default = 8;
		local strength = player:getPerkLevel(Perks.Strength);
		local hoarderBaseWeight = default + strength * SBvars.HoarderWeight;
		if player:getMaxWeightBase() ~= hoarderBaseWeight then
			player:setMaxWeightBase(hoarderBaseWeight);
			--print("DTW Logger: Set Hoarder maxWeightBase to"..hoarderBaseWeight);
		end
	end
end

local function pluviophileTrait(player, rainIntensity) -- confirmed working
	local primaryItem = player:getPrimaryHandItem();
	local secondaryItem = player:getSecondaryHandItem();
	local rainProtection = (primaryItem and primaryItem:isProtectFromRainWhileEquipped()) or (secondaryItem and secondaryItem:isProtectFromRainWhileEquipped());
	local bodydamage = player:getBodyDamage();
	local stats = player:getStats();
	local unhappinessDecrease = 0.1 * rainIntensity * (rainProtection and 0.5 or 1) * SBvars.PluviophileMultiplier;
	bodydamage:setUnhappynessLevel(bodydamage:getUnhappynessLevel() - unhappinessDecrease);
	--print("DTW Logger: Pluviophile: unhappinessDecrease:"..unhappinessDecrease);
	local boredomDecrease = 0.02 * rainIntensity * (rainProtection and 0.5 or 1) * SBvars.PluviophileMultiplier;
	stats:setBoredom(stats:getBoredom() - boredomDecrease);
	--print("DTW Logger: Pluviophile: boredomDecrease:"..boredomDecrease);
	local stressDecrease = 0.04 * rainIntensity * (rainProtection and 0.5 or 1) * SBvars.PluviophileMultiplier;
	stats:setStress(stats:getStress() - stressDecrease);
	--print("DTW Logger: Pluviophile: stressDecrease:"..stressDecrease);
end

local function pluviophobiaTrait(player, rainIntensity) -- confirmed working
	local primaryItem = player:getPrimaryHandItem();
	local secondaryItem = player:getSecondaryHandItem();
	local rainProtection = (primaryItem and primaryItem:isProtectFromRainWhileEquipped()) or (secondaryItem and secondaryItem:isProtectFromRainWhileEquipped());
	local bodydamage = player:getBodyDamage();
	local stats = player:getStats();
	local unhappinessIncrease = 0.1 * rainIntensity * (rainProtection and 0.5 or 1) * SBvars.PluviophobiaMultiplier;
	bodydamage:setUnhappynessLevel(bodydamage:getUnhappynessLevel() + unhappinessIncrease);
	--print("DTW Logger: Pluviophobia: unhappinessIncrease:"..unhappinessIncrease);
	local boredomIncrease = 0.02 * rainIntensity * (rainProtection and 0.5 or 1) * SBvars.PluviophobiaMultiplier;
	stats:setBoredom(stats:getBoredom() + boredomIncrease);
	--print("DTW Logger: Pluviophobia: boredomIncrease:"..boredomIncrease);
	local stressIncrease = 0.04 * rainIntensity * (rainProtection and 0.5 or 1) * SBvars.PluviophobiaMultiplier;
	stats:setStress(stats:getStress() + stressIncrease);
	--print("DTW Logger: Pluviophobia: stressIncrease:"..stressIncrease);
end

local function oneMinuteUpdate()
	local player = getPlayer();
	checkWeightLimit(player);
	local rainIntensity = getClimateManager():getRainIntensity();
	if rainIntensity > 0 and player:isOutside() then
		if player:HasTrait("Pluviophobia") then pluviophobiaTrait(player, rainIntensity)
		elseif player:HasTrait("Pluviophile") then pluviophileTrait(player, rainIntensity) end
	end
end

local function initializeTraitsLogic(playerIndex, player)
	Events.OnZombieDead.Add(onZombieKill);
	Events.EveryOneMinute.Add(oneMinuteUpdate);
end

Events.OnCreatePlayer.Add(initializeTraitsLogic)