require "DTWModData";

local SBvars = SandboxVars.DynamicTraitsWorld;

local function DTWOnZombieKill(zombie)
	local player = getPlayer();
	local bodydamage = player:getBodyDamage();
	if player:HasTrait("bloodlust") and player:DistTo(zombie) <= 4 then
		bodydamage:setUnhappynessLevel(bodydamage:getUnhappynessLevel() - 0.04);
	end
end

local function DTWCheckWeightLimit(player)
	if not getActivatedMods():contains("ToadTraitsDynamic") and player:HasTrait("hoarder") then
		local default = 8;
		local strength = player:getPerkLevel(Perks.Strength);
		local hoarderBaseWeight = default + strength * SBvars.HoarderWeight;
		if player:getMaxWeightBase() ~= hoarderBaseWeight then
			player:setMaxWeightBase(hoarderBaseWeight);
		end
	end
end

local function DTWOneMinuteUpdate()
	local player = getPlayer();
	DTWCheckWeightLimit(player);
end

local function DTWInitializeTraitsLogic(player)
	Events.OnZombieDead.Add(DTWOnZombieKill);
	Events.EveryOneMinute.Add(DTWOneMinuteUpdate);
end

Events.OnGameStart.Add(DTWInitializeTraitsLogic)