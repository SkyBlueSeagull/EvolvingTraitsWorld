require "ETWModOptions";

local SBvars = SandboxVars.EvolvingTraitsWorld;

local function checkStartingDTConflictingTrait(startingTraits, player, trait)
	if player:getModData().DTKillscheck2 == nil then
		-- migration from DT to ETW
		if trait == "Claustophobic" then
			if startingTraits.Claustrophobic == nil then
				startingTraits.Claustrophobic = player:HasTrait(trait);
			end
		elseif trait == "HeartyAppitite" then
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
		if trait == "Claustophobic" then
			if startingTraits.Claustrophobic == nil then
				startingTraits.Claustrophobic = player:HasTrait(trait);
			end
		elseif trait == "HeartyAppitite" then
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

local function checkStartingTrait(startingTraits, player, trait)
	if startingTraits[trait] == nil then
		startingTraits[trait] = player:HasTrait(trait);
	end
end

local function createModData(playerIndex, player)
	player:getModData().EvolvingTraitsWorld = player:getModData().EvolvingTraitsWorld or {};
	local modData = player:getModData().EvolvingTraitsWorld

	modData.VehiclePartRepairs = modData.VehiclePartRepairs or 0;
	modData.EagleEyedKills = modData.EagleEyedKills or 0;
	modData.CatEyesCounter = modData.CatEyesCounter or 0;
	modData.LocationFearCounter = nil; -- v.2.0.0 cleaning up, remove it later
	modData.FoodSicknessWeathered = modData.FoodSicknessWeathered or 0;
	modData.AsthmaticCounter = modData.AsthmaticCounter or 0;

	modData.StartingTraits = modData.StartingTraits or {};
	local startingTraits = modData.StartingTraits;
	checkStartingDTConflictingTrait(startingTraits, player, "HeartyAppitite");
	checkStartingDTConflictingTrait(startingTraits, player, "LightEater");
	checkStartingDTConflictingTrait(startingTraits, player, "HighThirst");
	checkStartingDTConflictingTrait(startingTraits, player, "LowThirst");
	checkStartingDTConflictingTrait(startingTraits, player, "SlowHealer");
	checkStartingDTConflictingTrait(startingTraits, player, "FastHealer");
	checkStartingDTConflictingTrait(startingTraits, player, "Thinskinned");
	checkStartingDTConflictingTrait(startingTraits, player, "ThickSkinned");
	checkStartingDTConflictingTrait(startingTraits, player, "Outdoorsman");
	checkStartingDTConflictingTrait(startingTraits, player, "NeedsLessSleep");
	checkStartingDTConflictingTrait(startingTraits, player, "NeedsMoreSleep");
	checkStartingDTConflictingTrait(startingTraits, player, "Agoraphobic");
	checkStartingDTConflictingTrait(startingTraits, player, "Claustophobic");
	checkStartingDTConflictingTrait(startingTraits, player, "Asthmatic");
	checkStartingTrait(startingTraits, player, "Bloodlust");
	checkStartingTrait(startingTraits, player, "Smoker");
	checkStartingTrait(startingTraits, player, "Outdoorsman");
	checkStartingTrait(startingTraits, player, "Herbalist");
	checkStartingTrait(startingTraits, player, "Pluviophile");
	checkStartingTrait(startingTraits, player, "Pluviophobia");

	if modData.HerbsPickedUp == nil and startingTraits.Herbalist == true then -- start at full counter if they have the trait
		modData.HerbsPickedUp = SBvars.HerbalistHerbsPicked;
	end
	modData.HerbsPickedUp = modData.HerbsPickedUp or 0;

	if modData.RainCounter == nil and startingTraits.Pluviophile == true then -- start at full counter if they have the trait
		modData.RainCounter = SBvars.RainSystemCounter * 2;
	elseif modData.RainCounter == nil and startingTraits.Pluviophobia == true then
		modData.RainCounter = SBvars.RainSystemCounter * -2;
	end
	modData.RainCounter = modData.RainCounter or 0;

	modData.OutdoorsmanCounter = nil; -- v.2.0.0 - remove this later, this is only for cleaning up

	modData.OutdoorsmanSystem = modData.OutdoorsmanSystem or {};
	local outdoorsmanSystem = modData.OutdoorsmanSystem;
	if outdoorsmanSystem.OutdoorsmanCounter == nil and startingTraits.Outdoorsman == true then -- start at full counter if they have the trait
		outdoorsmanSystem.OutdoorsmanCounter = SBvars.OutdoorsmanCounter * 10;
	end
	outdoorsmanSystem.OutdoorsmanCounter = outdoorsmanSystem.OutdoorsmanCounter or 0;
	outdoorsmanSystem.MinutesSinceOutside = outdoorsmanSystem.MinutesSinceOutside or 0;

	modData.LocationFearSystem = modData.LocationFearSystem or {};
	local locationFearSystem = modData.LocationFearSystem;
	if locationFearSystem.FearOfInside == nil and startingTraits.Claustrophobic == true then -- start at full counter if they have the trait
		locationFearSystem.FearOfInside = SBvars.FearOfLocationsSystemCounter * -2;
	end
	if locationFearSystem.FearOfOutside == nil and startingTraits.Agoraphobic == true then -- start at full counter if they have the trait
		locationFearSystem.FearOfOutside = SBvars.FearOfLocationsSystemCounter * -2;
	end
	locationFearSystem.FearOfInside = locationFearSystem.FearOfInside or 0; -- use existing value or start at 0 cuz they don't have the trait
	locationFearSystem.FearOfOutside = locationFearSystem.FearOfOutside or 0; -- use existing value or start at 0 cuz they don't have the trait

	modData.SleepSystem = modData.SleepSystem or {};
	local sleepSystem = modData.SleepSystem;
	if sleepSystem.CurrentlySleeping == nil then
		sleepSystem.CurrentlySleeping = false;
	end
	sleepSystem.WentToSleepAt = nil; -- v.2.0.0 - remove this later, this is only for cleaning up
	sleepSystem.HoursSinceLastSleep = sleepSystem.HoursSinceLastSleep or 0;
	sleepSystem.Last100PreferredHour = nil; -- v.2.0.0 - remove this later, this is only for cleaning up
	sleepSystem.LastMidpoint = sleepSystem.LastMidpoint or 4;
	if sleepSystem.SleepHealthinessBar == nil and startingTraits.NeedsLessSleep == true then
		sleepSystem.SleepHealthinessBar = 200;
	elseif sleepSystem.SleepHealthinessBar == nil and startingTraits.NeedsMoreSleep == true then
		sleepSystem.SleepHealthinessBar = sleepSystem.SleepHealthinessBar or -200;
	else
		sleepSystem.SleepHealthinessBar = sleepSystem.SleepHealthinessBar or 0;
	end

	modData.SmokeSystem = modData.SmokeSystem or {};
	local smokeSystem = modData.SmokeSystem;
	if smokeSystem.SmokingAddiction == nil and startingTraits.Smoker == true then
		smokeSystem.SmokingAddiction = SBvars.SmokerCounter * 2;
	else
		smokeSystem.SmokingAddiction = smokeSystem.SmokingAddiction or 0;
	end
	smokeSystem.MinutesSinceLastSmoke = smokeSystem.MinutesSinceLastSmoke or 0;

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
	bloodlustSystem.LastKillTimestamp = bloodlustSystem.LastKillTimestamp or 0;
	bloodlustSystem.BloodlustMeter = bloodlustSystem.BloodlustMeter or 0;
	if bloodlustSystem.BloodlustProgress == nil and startingTraits.Bloodlust == true then
		bloodlustSystem.BloodlustProgress = SBvars.BloodlustProgress;
	else
		bloodlustSystem.BloodlustProgress = bloodlustSystem.BloodlustProgress or 0;
	end

	player:getModData().KillCount = player:getModData().KillCount or {};
	player:getModData().KillCount.WeaponCategory = player:getModData().KillCount.WeaponCategory or {};
	local killCount = player:getModData().KillCount.WeaponCategory;
	killCount["Axe"] = killCount["Axe"] or { count = 0, WeaponType = {} };
	killCount["Blunt"] = killCount["Blunt"] or { count = 0, WeaponType = {} };
	killCount["SmallBlunt"] = killCount["SmallBlunt"] or { count = 0, WeaponType = {} };
	killCount["LongBlade"] = killCount["LongBlade"] or { count = 0, WeaponType = {} };
	killCount["SmallBlade"] = killCount["SmallBlade"] or { count = 0, WeaponType = {} };
	killCount["Spear"] = killCount["Spear"] or { count = 0, WeaponType = {} };
	killCount["Firearm"] = killCount["Firearm"] or { count = 0, WeaponType = {} };
	killCount["Fire"] = killCount["Fire"] or { count = 0, WeaponType = {} };
	killCount["Vehicles"] = killCount["Vehicles"] or { count = 0, WeaponType = {} };
	killCount["Unarmed"] = killCount["Unarmed"] or { count = 0, WeaponType = {} };
	killCount["Explosives"] = killCount["Explosives"] or { count = 0, WeaponType = {} };
end

Events.OnCreatePlayer.Remove(createModData);
Events.OnCreatePlayer.Add(createModData);