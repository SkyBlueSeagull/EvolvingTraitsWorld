require "MF_ISMoodle";
require "DTWModData";
MF.createMoodle("BloodlustMoodle");

local SBvars = SandboxVars.DynamicTraitsWorld;

local function bloodlustMoodleUpdate(player) -- confirmed working
	local moodle = MF.getMoodle("BloodlustMoodle");
	moodle:setThresholds(0.1, 0.2, 0.35, 0.4999, 0.5001, 0.65, 0.8, 0.9);
	if player == getPlayer() and DynamicTraitsWorld.settings.EnableBloodLustMoodle == true then
		local percentage = player:getModData().DynamicTraitsWorld.BloodlustSystem.BloodlustMeter / 36;
		moodle:setValue(percentage);
	else
		moodle:setValue(0.5);
	end
end

local function bloodlustKill(zombie) -- confirmed working
	local player = getPlayer();
	if SBvars.Bloodlust == true then
		local bloodlust = player:getModData().DynamicTraitsWorld.BloodlustSystem;
		local distance = player:DistTo(zombie);
		if distance <= 10 then
			if bloodlust.BloodlustMeter <= 36 then
				bloodlust.BloodlustMeter = bloodlust.BloodlustMeter + math.min(1 / distance, 1) * SBvars.BloodlustMeterFillMultiplier;
				--print("DTW Logger: BloodlustMeter="..bloodlust.BloodlustMeter);
			else
				bloodlust.BloodlustMeter = bloodlust.BloodlustMeter + math.min(1 / distance, 1) * SBvars.BloodlustMeterFillMultiplier * 0.1;
				--print("DTW Logger: BloodlustMeter (soft-capped)="..bloodlust.BloodlustMeter);
			end
			bloodlustMoodleUpdate(player);
		end
	end
end

local function bloodlustTime() -- confirmed working
	local player = getPlayer();
	local modData = player:getModData().DynamicTraitsWorld.BloodlustSystem;
	if SBvars.Bloodlust == true then
		modData.BloodlustMeter = math.max(modData.BloodlustMeter - 1, 0);
		bloodlustMoodleUpdate(player);
		-- Bloodlust Progress when no perk
		if not player:HasTrait("Bloodlust") then
			--print("DTW Log: Bloodlust Meter (perk is not present): "..modData.BloodlustMeter);
			if modData.BloodlustMeter >= 18 then -- gain if above 50%
				modData.BloodlustProgress = math.min(SBvars.BloodlustProgress * 2, modData.BloodlustProgress + modData.BloodlustMeter * 0.1);
				--print("DTW Logger: BloodlustMeter is above 50%, BloodlustProgress (no trait)="..modData.BloodlustProgress);
				if modData.BloodlustProgress >= SBvars.BloodlustProgress then
					player:getTraits():add("Bloodlust");
					HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Bloodlust"), true, HaloTextHelper.getColorGreen());
				end
			else 
				modData.BloodlustProgress = math.max(0, modData.BloodlustProgress - (3.6 - modData.BloodlustMeter * 0.1));
				--print("DTW Logger: BloodlustMeter is below 50%, BloodlustProgress (no trait)="..modData.BloodlustProgress);
			end
		end
		-- Bloodlust Progress when perk is present
		if player:HasTrait("Bloodlust") then
			--print("DTW Log: Bloodlust Meter (perk is present): "..modData.BloodlustMeter);
			if modData.BloodlustMeter >= 18 then -- gain progress if above 50%
				modData.BloodlustProgress = math.min(SBvars.BloodlustProgress * 2, modData.BloodlustProgress + modData.BloodlustMeter * 0.1);
				--print("DTW Logger: BloodlustMeter is above 50%, BloodlustProgress (trait)="..modData.BloodlustProgress);
			else -- lose progress when below 50%
				modData.BloodlustProgress = math.max(0, modData.BloodlustProgress - (3.6 - modData.BloodlustMeter * 0.1));
				--print("DTW Logger: BloodlustMeter is below 50%, BloodlustProgress (trait)="..modData.BloodlustProgress);
				if modData.BloodlustProgress <= SBvars.BloodlustProgress / 2 then
					player:getTraits():remove("Bloodlust");
					HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Bloodlust"), false, HaloTextHelper.getColorRed());
				end
			end
		end
	end
end

local function eagleEyed(wielder, character, handWeapon, damage) -- confirmed working
	if wielder == getPlayer() and character:isZombie() and SBvars.EagleEyed == true and not wielder:HasTrait("EagleEyed") then
		local player = wielder;
		local zombie = character;
		local zHealth = zombie:getHealth();
		local distance = player:DistTo(zombie);
		if distance >= SBvars.EagleEyedDistance and zHealth <= damage then
			player:getModData().DynamicTraitsWorld.EagleEyedKills = player:getModData().DynamicTraitsWorld.EagleEyedKills + 1;
			--print("DTW Logger: Caught a kill on following distance: "..distance..", current eagle eyed kills:"..player:getModData().DynamicTraitsWorld.EagleEyedKills);
			if player:getModData().DynamicTraitsWorld.EagleEyedKills >= SBvars.EagleEyedKills then
				player:getTraits():add("EagleEyed");
				HaloTextHelper.addTextWithArrow(player, getText("UI_trait_eagleeyed"), true, HaloTextHelper.getColorGreen());
			end
		end
	end
end

local function braverySystem(zombie) -- confirmed working
	local player = getPlayer();
	local totalKills = player:getZombieKills();
	local braveryKills = SBvars.BraverySystemKills;
	local killCountModData = player:getModData().KillCount.WeaponCategory;
	local fireKills = killCountModData["Fire"].count;
	local vehiclesKills = killCountModData["Vehicles"].count;
	local explosivesKills = killCountModData["Explosives"].count;
	local meleeKills = totalKills - fireKills - vehiclesKills - explosivesKills;
	-- clean version by https://chat.openai.com/
	-- Define table of trait information
	local traitInfo = {
		{trait = "Cowardly", threshold = braveryKills * 0.1, remove = true},
		{trait = "Hemophobic", threshold = braveryKills * 0.2, remove = true},
		{trait = "Pacifist", threshold = braveryKills * 0.3, remove = true},
		{trait = "AdrenalineJunkie", threshold = braveryKills * 0.4, add = true},
		{trait = "Brave", threshold = braveryKills * 0.6, add = true},
		{trait = "Desensitized", threshold = braveryKills, add = true}
	}

	for i, info in ipairs(traitInfo) do
		local trait = info.trait
		local threshold = info.threshold
		local remove = info.remove
		local add = info.add

		if (totalKills + meleeKills) >= threshold then
			if player:HasTrait(trait) and remove then
				player:getTraits():remove(trait)
				HaloTextHelper.addTextWithArrow(player, getText("UI_trait_" .. trait), false, HaloTextHelper.getColorGreen())
			elseif not player:HasTrait(trait) and add then
				player:getTraits():add(trait)
				HaloTextHelper.addTextWithArrow(player, getText("UI_trait_" .. (trait == "Brave" and "brave" or trait)), true, HaloTextHelper.getColorGreen())
				if trait == "Desensitized" then
					Events.OnZombieDead.Remove(braverySystem);
				end
			end
		end
	end
end

local function initializeKills(playerIndex, player)
	bloodlustMoodleUpdate(player);
	Events.OnZombieDead.Add(bloodlustKill);
	Events.EveryHours.Add(bloodlustTime);
	if SBvars.EagleEyed == true and not player:HasTrait("EagleEyed") then Events.OnWeaponHitCharacter.Add(eagleEyed) end
	if SBvars.BraverySystem == true and not player:HasTrait("Desensitized") then
		Events.OnZombieDead.Add(braverySystem);
	end
end

Events.OnCreatePlayer.Add(initializeKills);