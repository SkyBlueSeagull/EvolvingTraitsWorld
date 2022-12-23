require "DTWModData";
local DTWActionsOverride = require "TimedActions/DTWActionsOverride";

local function applyXPBoost(player, perk, boostLevel)
	local newBoost = player:getXp():getPerkBoost(perk) + boostLevel;
	if newBoost > 3 then
		player:getXp():setPerkBoost(perk, 3);
	else
		player:getXp():setPerkBoost(perk, newBoost);
	end
end

local function traitsGainsBySkill(player, perk)
	local SBvars = SandboxVars.DynamicTraitsWorld;
	local modData = player:getModData();
 
	-- locals for perk levels
	local strength = player:getPerkLevel(Perks.Strength);
	local fitness = player:getPerkLevel(Perks.Fitness);
	local sprinting = player:getPerkLevel(Perks.Sprinting);
	local lightfooted = player:getPerkLevel(Perks.Lightfoot);
	local nimble = player:getPerkLevel(Perks.Nimble);
	local sneaking = player:getPerkLevel(Perks.Sneak);
	local axe = player:getPerkLevel(Perks.Axe);
	local longBlunt = player:getPerkLevel(Perks.Blunt);
	local shortBlunt = player:getPerkLevel(Perks.SmallBlunt);
	local longBlade = player:getPerkLevel(Perks.LongBlade);
	local shortBlade = player:getPerkLevel(Perks.SmallBlade);
	local spear = player:getPerkLevel(Perks.Spear);
	local maintenance = player:getPerkLevel(Perks.Maintenance);
	local carpentry = player:getPerkLevel(Perks.Woodwork);
	local cooking = player:getPerkLevel(Perks.Cooking);
	local farming = player:getPerkLevel(Perks.Farming);
	local firstAid = player:getPerkLevel(Perks.Doctor);
	local electrical = player:getPerkLevel(Perks.Electricity);
	local metalworking = player:getPerkLevel(Perks.MetalWelding);
	local mechanics = player:getPerkLevel(Perks.Mechanics);
	local tailoring = player:getPerkLevel(Perks.Tailoring);
	local aiming = player:getPerkLevel(Perks.Aiming);
	local reloading = player:getPerkLevel(Perks.Reloading);
	local fishing = player:getPerkLevel(Perks.Fishing);
	local trapping = player:getPerkLevel(Perks.Trapping);
	local foraging = player:getPerkLevel(Perks.PlantScavenging);


	-- locals for kills by category
	local killCountModData = player:getModData().KillCount.WeaponCategory;
	local axeKills = killCountModData["Axe"].count;
	local longBluntKills = killCountModData["Blunt"].count;
	local shortBluntKills = killCountModData["SmallBlunt"].count;
	local longBladeKills = killCountModData["LongBlade"].count;
	local shortBladeKills = killCountModData["SmallBlade"].count;
	local spearKills = killCountModData["Spear"].count;
	local firearmKills = killCountModData["Firearm"].count;


	-- Passive
		-- Strength
			-- Hoarder / confirmed working
				if perk == "characterInitialization" or perk == Perks.Strength then
					if SBvars.Hoarder == true and not player:HasTrait("hoarder") and strength >= SBvars.HoarderSkill then
						player:getTraits():add("hoarder");
						HaloTextHelper.addTextWithArrow(player, getText("UI_trait_hoarder"), true, HaloTextHelper.getColorGreen());
					end
				end
			-- Gym Rat / confirmed working
				if perk == "characterInitialization" or perk == Perks.Strength or perk == Perks.Fitness then
					if SBvars.GymRat == true and not player:HasTrait("gymrat") and (strength + fitness) >= SBvars.GymRatSkill then
						player:getTraits():add("gymrat");
						HaloTextHelper.addTextWithArrow(player, getText("UI_trait_gymrat"), true, HaloTextHelper.getColorGreen());
					end
				end
	-- Agility
		-- Lightfooted
			-- Light Step / confirmed working
				if perk == "characterInitialization" or perk == Perks.Lightfoot then
					if SBvars.LightStep == true and not player:HasTrait("lightstep") and axe >= SBvars.LightStepSkill then
						player:getTraits():add("lightstep");
						applyXPBoost(player, Perks.Lightfoot, 1);
						HaloTextHelper.addTextWithArrow(player, getText("UI_trait_lightstep"), true, HaloTextHelper.getColorGreen());
					end
				end
		-- Sneaking
			-- Low Profile / confirmed working
				if perk == "characterInitialization" or perk == Perks.Sneak then
					if SBvars.LowProfile == true and not player:HasTrait("lowprofile") and axe >= SBvars.LowProfileSkill then
						player:getTraits():add("lowprofile");
						applyXPBoost(player, Perks.Sneak, 1);
						HaloTextHelper.addTextWithArrow(player, getText("UI_trait_lowprofile"), true, HaloTextHelper.getColorGreen());
					end
				end
	-- Combat
		-- Axe
			-- Axe Thrower / confirmed working
				if perk == "characterInitialization" or perk == "kill" or perk == Perks.Axe then
					if SBvars.AxeThrower == true and not player:HasTrait("axethrower") and axe >= SBvars.AxeThrowerSkill and axeKills >= SBvars.AxeThrowerKills then
						player:getTraits():add("axethrower");
						applyXPBoost(player, Perks.Axe, 1);
						HaloTextHelper.addTextWithArrow(player, getText("UI_trait_axethrower"), true, HaloTextHelper.getColorGreen());
					end
				end
		-- Short Blunt
			-- Stick Fighter / confirmed working
			if perk == "characterInitialization" or perk == "kill" or perk == Perks.SmallBlunt then
				if SBvars.StickFighter == true and not player:HasTrait("stickfighter") and shortBlunt >= SBvars.StickFighterSkill and shortBluntKills >= SBvars.StickFighterKills then
					player:getTraits():add("stickfighter");
					applyXPBoost(player, Perks.SmallBlunt, 1);
					HaloTextHelper.addTextWithArrow(player, getText("UI_trait_stickfighter"), true, HaloTextHelper.getColorGreen());
				end
			end
		-- Long Blade
			-- Kenshi
				if perk == "characterInitialization" or perk == "kill" or perk == Perks.LongBlade then
					if SBvars.Kenshi == true and not player:HasTrait("kenshi") and longBlade >= SBvars.KenshiSkill and longBladeKills >= SBvars.KenshiKills then
						player:getTraits():add("kenshi");
						applyXPBoost(player, Perks.LongBlade, 1);
						HaloTextHelper.addTextWithArrow(player, getText("UI_trait_kenshi"), true, HaloTextHelper.getColorGreen());
					end
				end
		-- Short Blade
			-- Knife Fighter / confirmed working
				if perk == "characterInitialization" or perk == "kill" or perk == Perks.ShortBlade then
					if SBvars.KnifeFighter == true and not player:HasTrait("knifefighter") and shortBlade >= SBvars.KnifeFighterSkill and shortBladeKills >= SBvars.KnifeFighterKills then
						player:getTraits():add("knifefighter");
						applyXPBoost(player, Perks.ShortBlade, 1);
						HaloTextHelper.addTextWithArrow(player, getText("UI_trait_knifefighter"), true, HaloTextHelper.getColorGreen());
					end
				end
		-- Spear
			-- Sojutsu / confirmed working
				if perk == "characterInitialization" or perk == "kill" or perk == Perks.Spear then
					if SBvars.Sojutsu == true and not player:HasTrait("sojutsu") and spear >= SBvars.SojutsuSkill and spearKills >= SBvars.SojutsuKills then
						player:getTraits():add("sojutsu");
						applyXPBoost(player, Perks.Spear, 1);
						HaloTextHelper.addTextWithArrow(player, getText("UI_trait_sojutsu"), true, HaloTextHelper.getColorGreen());
					end
				end
		-- Maintenance
			-- Restoration Expert / confirmed working
				if perk == "characterInitialization" or perk == Perks.Maintenance then
					if SBvars.RestorationExpert == true and not player:HasTrait("restorationexpert") and maintenance >= SBvars.RestorationExpertSkill then
						player:getTraits():add("restorationexpert");
						applyXPBoost(player, Perks.Maintenance, 1);
						HaloTextHelper.addTextWithArrow(player, getText("restorationexpert"), true, HaloTextHelper.getColorGreen());
					end
				end
	-- Crafting
		-- Carpentry
			-- Furniture Assembler / confirmed working
				if perk == "characterInitialization" or perk == Perks.Woodwork then
					if SBvars.FurnitureAssembler == true and not player:HasTrait("furnitureassembler") and carpentry >= SBvars.FurnitureAssemblerSkill then
						player:getTraits():add("furnitureassembler");
						applyXPBoost(player, Perks.Woodwork, 1);
						HaloTextHelper.addTextWithArrow(player, getText("UI_trait_furnitureassembler"), true, HaloTextHelper.getColorGreen());
					end
				end
		-- Cooking
			-- Home Cook / confirmed working
				if perk == "characterInitialization" or perk == Perks.Cooking then
					if SBvars.HomeCook == true and not player:HasTrait("homecook") and cooking >= SBvars.HomeCookSkill then
						player:getTraits():add("homecook");
						local playerRecipes = player:getKnownRecipes();
						if not playerRecipes:contains("Make Cake Batter") then
							playerRecipes:add("Make Cake Batter");
						end
						applyXPBoost(player, Perks.Cooking, 1);
						HaloTextHelper.addTextWithArrow(player, getText("UI_trait_homecook"), true, HaloTextHelper.getColorGreen());
					end
				end
		-- Electrical
			-- AVClub / confirmed working
				if perk == "characterInitialization" or perk == Perks.Electricity then
					if SBvars.AVClub == true and not player:HasTrait("avclub") and electrical >= SBvars.AVClubSkill then
						player:getTraits():add("avclub");
						local playerRecipes = player:getKnownRecipes();
						if not playerRecipes:contains("Make Remote Controller V1") then
							playerRecipes:add("Make Remote Controller V1");
						end
						if not playerRecipes:contains("Make Remote Controller V2") then
							playerRecipes:add("Make Remote Controller V2");
						end
						if not playerRecipes:contains("Make Remote Controller V3") then
							playerRecipes:add("Make Remote Controller V3");
						end
						if not playerRecipes:contains("Make Remote Trigger") then
							playerRecipes:add("Make Remote Trigger");
						end
						if not playerRecipes:contains("Make Timer") then
							playerRecipes:add("Make Timer");
						end
						if not playerRecipes:contains("Craft Makeshift Radio") then
							playerRecipes:add("Craft Makeshift Radio");
						end
						if not playerRecipes:contains("Craft Makeshift HAM Radio") then
							playerRecipes:add("Craft Makeshift HAM Radio");
						end
						if not playerRecipes:contains("Craft Makeshift Walkie Talkie") then
							playerRecipes:add("Craft Makeshift Walkie Talkie");
						end
						if not playerRecipes:contains("Make Noise generator") then
							playerRecipes:add("Make Noise generator");
						end
						applyXPBoost(player, Perks.Electricity, 1);
						HaloTextHelper.addTextWithArrow(player, getText("UI_trait_avclub"), true, HaloTextHelper.getColorGreen());
					end
				end
		-- Metalworking
			-- Bodywork Enthusiast / confirmed working
				if perk == "characterInitialization" or perk == Perks.MetalWelding  or perk == Perks.Mechanics then
					if SBvars.BodyworkEnthusiast == true and not player:HasTrait("bodyworkenthusiast") then
						DTWActionsOverride.bodyworkEnthusiastCheck();
					end
				end
	-- Firearms
		-- Aiming
			-- Gun Enthusiast / confirmed working
				if perk == "characterInitialization" or perk == "kill" or perk == Perks.Aiming or perk == Perks.Reloading then
					if SBvars.GunEnthusiast == true and not player:HasTrait("gunenthusiast") and (aiming + reloading) >= SBvars.GunEnthusiastSkill and firearmKills >= SBvars.GunEnthusiastKills then
						player:getTraits():add("gunenthusiast");
						applyXPBoost(player, Perks.Aiming, 1);
						applyXPBoost(player, Perks.Reloading, 1);
						HaloTextHelper.addTextWithArrow(player, getText("UI_trait_gunenthusiast"), true, HaloTextHelper.getColorGreen());
					end
				end
end

local function OnZombieKill(zombie)
	local player = getPlayer();
	traitsGainsBySkill(player, "kill");
end

local function DTWInitializeEvents()
	Events.LevelPerk.Add(traitsGainsBySkill);
	Events.OnZombieDead.Add(OnZombieKill);
end

Events.OnGameStart.Add(DTWInitializeEvents)

return DTWSkills;