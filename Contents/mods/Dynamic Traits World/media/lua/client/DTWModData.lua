local function createModData(playerIndex, player)
	player:getModData().DynamicTraitsWorld = player:getModData().DynamicTraitsWorld or {};
	local modData = player:getModData().DynamicTraitsWorld

	modData.VehiclePartRepairs = modData.VehiclePartRepairs or 0;
	
	modData.Bloodlust = modData.Bloodlust or {};
	modData.Bloodlust.BloodlustMeter = modData.Bloodlust.BloodlustMeter or 0;
	if modData.Bloodlust.BloodlustProgress and player:HasTrait("bloodlust") then
		modData.Bloodlust.BloodlustProgress = SandboxVars.DynamicTraitsWorld.BloodlustProgress;
	else
		modData.Bloodlust.BloodlustProgress = modData.Bloodlust.BloodlustProgress or 0;
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
end

Events.OnCreatePlayer.Add(createModData)