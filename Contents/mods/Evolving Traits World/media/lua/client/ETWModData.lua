local function checkStartingTrait(startingTraits, player, trait)
	if player:getModData().DTKillscheck2 == nil then
		if trait == "HeartyAppitite" then
			if startingTraits.HeartyAppetite == nil then
				startingTraits.HeartyAppetite = player:HasTrait(trait);
			end
		elseif trait == "Thinskinned" then
			if startingTraits.ThinSkinned == nil then
				startingTraits.ThinSkinned = player:HasTrait(trait);
			end
		elseif startingTraits[trait] == nil then
			startingTraits[trait] = player:HasTrait(trait);
		end
	else
		if trait == "HeartyAppitite" then
			if startingTraits.HeartyAppetite == nil then
				startingTraits.HeartyAppetite = false;
			end
		elseif trait == "Thinskinned" then
			if startingTraits.ThinSkinned == nil then
				startingTraits.ThinSkinned = false;
			end
		elseif startingTraits[trait] == nil then
			startingTraits[trait] = false;
		end
	end
end

local function createModData(playerIndex, player)
	player:getModData().EvolvingTraitsWorld = player:getModData().EvolvingTraitsWorld or {};
	local modData = player:getModData().EvolvingTraitsWorld
	local SBvars = SandboxVars.EvolvingTraitsWorld;

	modData.VehiclePartRepairs = modData.VehiclePartRepairs or 0;
	modData.EagleEyedKills = modData.EagleEyedKills or 0;
	modData.OutdoorsmanCounter = modData.OutdoorsmanCounter or 0;
	modData.RainCounter = modData.RainCounter or 0;
	modData.CatEyesCounter = modData.CatEyesCounter or 0;
	modData.LocationFearCounter = modData.LocationFearCounter or 0;
	modData.FoodSicknessWeathered = modData.FoodSicknessWeathered or 0;
	modData.HerbsPickedUp = modData.HerbsPickedUp or 0;

	modData.StartingTraits = modData.StartingTraits or {};
	local startingTraits = modData.StartingTraits;
	checkStartingTrait(startingTraits, player, "HeartyAppitite");
	checkStartingTrait(startingTraits, player, "LightEater");
	checkStartingTrait(startingTraits, player, "HighThirst");
	checkStartingTrait(startingTraits, player, "LowThirst");
	checkStartingTrait(startingTraits, player, "SlowHealer");
	checkStartingTrait(startingTraits, player, "FastHealer");
	checkStartingTrait(startingTraits, player, "Thinskinned");
	checkStartingTrait(startingTraits, player, "ThickSkinned");

	modData.SleepSystem = modData.SleepSystem or {};
	local sleepSystem = modData.SleepSystem;
	if sleepSystem.CurrentlySleeping == nil then
		sleepSystem.CurrentlySleeping = false;
	end
	sleepSystem.WentToSleepAt = sleepSystem.WentToSleepAt or 0;
	sleepSystem.HoursSinceLastSleep = sleepSystem.HoursSinceLastSleep or 0;
	sleepSystem.Last100PreferredHour = sleepSystem.Last100PreferredHour or {28};
	if sleepSystem.SleepHealthinessBar == nil and player:HasTrait("NeedsLessSleep") then
		sleepSystem.SleepHealthinessBar = 200;
	elseif sleepSystem.SleepHealthinessBar == nil and player:HasTrait("NeedsMoreSleep") then
		sleepSystem.SleepHealthinessBar = sleepSystem.SleepHealthinessBar or -200;
	else
		sleepSystem.SleepHealthinessBar = sleepSystem.SleepHealthinessBar or 0;
	end

	modData.ColdSystem = modData.ColdSystem or {};
	local coldSystem = modData.ColdSystem;
	if coldSystem.CurrentlySick == nil then
		coldSystem.CurrentlySick = false;
	end
	coldSystem.ColdsWeathered = coldSystem.ColdsWeathered or 0;
	coldSystem.CurrentColdCounterContribution = coldSystem.CurrentColdCounterContribution or 0;

	modData.TransferSystem = modData.TransferSystem or {};
	local transferSystem = modData.TransferSystem;
	transferSystem.ItemsTransferred = transferSystem.ItemsTransferred or 0;
	transferSystem.WeightTransferred = transferSystem.WeightTransferred or 0;

	modData.BloodlustSystem = modData.BloodlustSystem or {};
	local bloodlustSystem = modData.BloodlustSystem;
	bloodlustSystem.BloodlustMeter = bloodlustSystem.BloodlustMeter or 0;
	if bloodlustSystem.BloodlustProgress == nil and player:HasTrait("Bloodlust") then
		bloodlustSystem.BloodlustProgress = SBvars.BloodlustProgress;
	else
		bloodlustSystem.BloodlustProgress = bloodlustSystem.BloodlustProgress or 0;
	end

	player:getModData().KillCount = player:getModData().KillCount or {};
	player:getModData().KillCount.WeaponCategory = player:getModData().KillCount.WeaponCategory or {};
	local killCount = player:getModData().KillCount.WeaponCategory;
	killCount["Axe"] = killCount["Axe"] or {count = 0, WeaponType = {}};
	killCount["Blunt"] = killCount["Blunt"] or {count = 0, WeaponType = {}};
	killCount["SmallBlunt"] = killCount["SmallBlunt"] or {count = 0, WeaponType = {}};
	killCount["LongBlade"] = killCount["LongBlade"] or {count = 0, WeaponType = {}};
	killCount["SmallBlade"] = killCount["SmallBlade"] or {count = 0, WeaponType = {}};
	killCount["Spear"] = killCount["Spear"] or {count = 0, WeaponType = {}};
	killCount["Firearm"] = killCount["Firearm"] or {count = 0, WeaponType = {}};
	killCount["Fire"] = killCount["Fire"] or {count = 0, WeaponType = {}};
	killCount["Vehicles"] = killCount["Vehicles"] or {count = 0, WeaponType = {}};
	killCount["Unarmed"] = killCount["Unarmed"] or {count = 0, WeaponType = {}};
	killCount["Explosives"] = killCount["Explosives"] or {count = 0, WeaponType = {}};
end

Events.OnCreatePlayer.Add(createModData)