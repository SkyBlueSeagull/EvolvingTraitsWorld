require "MF_ISMoodle";
require "DTWModData";
MF.createMoodle("BloodlustMoodle");

local SBvars = SandboxVars.DynamicTraitsWorld;

local function bloodlustMoodleUpdate(player)
	if player == getPlayer() then
		local moodle = MF.getMoodle("BloodlustMoodle");
		moodle:setThresholds(0.1, 0.2, 0.35, 0.49, 0.5, 0.65, 0.8, 0.9);
		local percentage = player:getModData().DynamicTraitsWorld.Bloodlust.BloodlustMeter / 36;
		moodle:setValue(percentage);
	end
end

local function activateMoodle(playerIndex, player)
	bloodlustMoodleUpdate(player);
end

local function BloodlustKill(zombie)
	local player = getPlayer();
	if SBvars.Bloodlust == true then
		local bloodlust = player:getModData().DynamicTraitsWorld.Bloodlust;
		local distance = player:DistTo(zombie);
		if distance <= 10 then
			if bloodlust.BloodlustMeter <= 36 then
				bloodlust.BloodlustMeter = bloodlust.BloodlustMeter + math.min(1 / distance, 1) * SBvars.BloodlustMeterFillMultiplier;
			else
				bloodlust.BloodlustMeter = bloodlust.BloodlustMeter + math.min(1 / distance, 1) * SBvars.BloodlustMeterFillMultiplier * 0.1;
			end
			bloodlustMoodleUpdate(player);
		end
	end
end

local function BloodlustTime()
	local player = getPlayer();
	local modData = player:getModData().DynamicTraitsWorld.Bloodlust;
	local killCount = player:getModData().KillCount.WeaponCategory;
	if SBvars.Bloodlust == true then
		-- Bloodlust Progress when no perk
		if not player:HasTrait("bloodlust") then
			modData.BloodlustMeter = math.max(modData.BloodlustMeter - 1, 0);
			bloodlustMoodleUpdate(player);
			if modData.BloodlustMeter >= 18 then -- gain if above 50%
				modData.BloodlustProgress = modData.BloodlustProgress + modData.BloodlustMeter * 0.1;
				if modData.BloodlustProgress >= SBvars.BloodlustProgress then
					player:getTraits():add("bloodlust");
					HaloTextHelper.addTextWithArrow(player, getText("UI_trait_bloodlust"), true, HaloTextHelper.getColorGreen());
				end
			else 
				modData.BloodlustProgress = math.max(0, modData.BloodlustProgress - (3.6 - modData.BloodlustMeter * 0.1));
			end
		end
		-- Bloodlust Progress when perk is present
		if player:HasTrait("bloodlust") then
			modData.BloodlustMeter = math.max(modData.BloodlustMeter - 1, 0);
			bloodlustMoodleUpdate(player);
			print("Bloodlust Meter: "..modData.BloodlustMeter);
			if modData.BloodlustMeter >= 18 then -- gain progress if above 50%
				modData.BloodlustProgress = modData.BloodlustProgress + modData.BloodlustMeter * 0.1;
			else -- lose progress when below 50%
				modData.BloodlustProgress = math.max(0, modData.BloodlustProgress - (3.6 - modData.BloodlustMeter * 0.1));
				if modData.BloodlustProgress <= SBvars.BloodlustProgress / 2 then
					player:getTraits():remove("bloodlust");
					HaloTextHelper.addTextWithArrow(player, getText("UI_trait_bloodlust"), false, HaloTextHelper.getColorRed());
				end
			end
		end
	end
end

local function InitializeKills(player)
	Events.OnZombieDead.Add(BloodlustKill);
	Events.EveryHours.Add(BloodlustTime);
end

Events.OnGameStart.Add(InitializeKills);
Events.OnCreatePlayer.Add(activateMoodle);