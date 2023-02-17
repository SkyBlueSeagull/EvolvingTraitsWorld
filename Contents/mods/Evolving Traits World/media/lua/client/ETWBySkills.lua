require "ETWModData";
local ETWActionsOverride = require "TimedActions/ETWActionsOverride";

local SBvars = SandboxVars.EvolvingTraitsWorld;
local notification = function() return EvolvingTraitsWorld.settings.EnableNotifications end
local debug = function() return EvolvingTraitsWorld.settings.GatherDebug end

local function applyXPBoost(player, perk, boostLevel)
	local newBoost = player:getXp():getPerkBoost(perk) + boostLevel;
	if newBoost > 3 then
		player:getXp():setPerkBoost(perk, 3);
	else
		player:getXp():setPerkBoost(perk, newBoost);
	end
end

local function addRecipe (player, recipe)
	local playerRecipes = player:getKnownRecipes();
	if not playerRecipes:contains(recipe) then
		playerRecipes:add(recipe);
	end
end

local function traitsGainsBySkill(player, perk)
	if player:getModData().EvolvingTraitsWorld == nil then return end
	player = getPlayer();
	local modData = player:getModData();
	local activatedMods = getActivatedMods();

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

	-- All Perks
		-- Unlucky/Lucky
				if SBvars.LuckSystem == true and not player:HasTrait("Lucky") then
					local totalPerkLevel = 0
					local totalMaxPerkLevel = 0;
					for i = 1, Perks.getMaxIndex() - 1 do
						local selectedPerk = Perks.fromIndex(i)
						if selectedPerk:getParent():getName() ~= "None" then
							if debug() then print("ETW Logger: Perk: "..selectedPerk:getName()..", parent: "..selectedPerk:getParent():getName()) end
							local perkLevel = player:getPerkLevel(selectedPerk)
							totalPerkLevel = totalPerkLevel + perkLevel;
							totalMaxPerkLevel = totalMaxPerkLevel + 10;
						end
					end
					local percentageOfSkillLevels = totalPerkLevel / totalMaxPerkLevel * 100;
					if player:HasTrait("Unlucky") and percentageOfSkillLevels >= SBvars.LuckSystemSkill / 2 then
						player:getTraits():remove("Unlucky");
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_unlucky"), false, HaloTextHelper.getColorGreen()) end
					elseif not player:HasTrait("Lucky") and percentageOfSkillLevels >= SBvars.LuckSystemSkill then
						player:getTraits():add("Lucky");
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_lucky"), true, HaloTextHelper.getColorGreen()) end
					end
				end
	-- Passive
		-- Strength
			-- Hoarder
				if perk == "characterInitialization" or perk == Perks.Strength then
					if not activatedMods:contains("EvolvingTraitsWorldDisableHoarder") and SBvars.Hoarder == true and not player:HasTrait("Hoarder") and strength >= SBvars.HoarderSkill then
						player:getTraits():add("Hoarder");
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Hoarder"), true, HaloTextHelper.getColorGreen()) end
					end
				end
			-- Gym Rat
				if perk == "characterInitialization" or perk == Perks.Strength or perk == Perks.Fitness then
					if not activatedMods:contains("EvolvingTraitsWorldDisableGymRat") and SBvars.GymRat == true and not player:HasTrait("GymRat") and (strength + fitness) >= SBvars.GymRatSkill then
						player:getTraits():add("GymRat");
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_GymRat"), true, HaloTextHelper.getColorGreen()) end
					end
				end
	-- Agility
		-- Springing
			-- Runner
				if perk == "characterInitialization" or perk == Perks.Sprinting then
					if SBvars.Runner == true and not player:HasTrait("Jogger") and sprinting >= SBvars.RunnerSkill then
						player:getTraits():add("Jogger");
						applyXPBoost(player, Perks.Sprinting, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Jogger"), true, HaloTextHelper.getColorGreen()) end
					end
				end
			-- Hard of Hearing / Keen Hearing
				if perk == "characterInitialization" or perk == Perks.Sprinting or perk == Perks.Lightfoot or perk == Perks.Nimble or perk == Perks.Sneak or perk == Perks.Axe or perk == Perks.Blunt or perk == Perks.SmallBlunt or perk == Perks.LongBlade or perk == Perks.SmallBlade or perk == Perks.Spear and SBvars.HearingSystem == true then
					local levels = sprinting + lightfooted + nimble + sneaking + axe + longBlunt + shortBlunt + longBlade + shortBlade + spear;
					if player:HasTrait("HardOfHearing") and levels >= SBvars.HearingSystemSkill / 2 then
						player:getTraits():remove("HardOfHearing");
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_hardhear"), false, HaloTextHelper.getColorGreen()) end
					elseif not player:HasTrait("KeenHearing") and levels >= SBvars.HearingSystemSkill then
						player:getTraits():add("KeenHearing");
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_keenhearing"), true, HaloTextHelper.getColorGreen()) end
					end
				end
		-- Lightfooted
			-- Light Step
				if perk == "characterInitialization" or perk == Perks.Lightfoot then
					if not activatedMods:contains("EvolvingTraitsWorldDisableLightStep") and SBvars.LightStep == true and not player:HasTrait("LightStep") and lightfooted >= SBvars.LightStepSkill then
						player:getTraits():add("LightStep");
						applyXPBoost(player, Perks.Lightfoot, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_LightStep"), true, HaloTextHelper.getColorGreen()) end
					end
				end
			-- Gymnast
				if perk == "characterInitialization" or perk == Perks.Lightfoot or perk == Perks.Nimble then
					if SBvars.Gymnast == true and not player:HasTrait("Gymnast") and (lightfooted + nimble) >= SBvars.GymnastSkill then
						player:getTraits():add("Gymnast");
						applyXPBoost(player, Perks.Lightfoot, 1);
						applyXPBoost(player, Perks.Nimble, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Gymnast"), true, HaloTextHelper.getColorGreen()) end
					end
				end
			-- Clumsy
				if perk == "characterInitialization" or perk == Perks.Lightfoot or perk == Perks.Sneak then
					if SBvars.Clumsy == true and player:HasTrait("Clumsy") and (lightfooted + sneaking) >= SBvars.ClumsySkill then
						player:getTraits():remove("Clumsy");
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_clumsy"), false, HaloTextHelper.getColorGreen()) end
					end
				end
		-- Sneaking
			-- Low Profile
				if perk == "characterInitialization" or perk == Perks.Sneak then
					if not activatedMods:contains("EvolvingTraitsWorldDisableLowProfile") and SBvars.LowProfile == true and not player:HasTrait("LowProfile") and axe >= SBvars.LowProfileSkill then
						player:getTraits():add("LowProfile");
						applyXPBoost(player, Perks.Sneak, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_LowProfile"), true, HaloTextHelper.getColorGreen()) end
					end
				end
			-- Conspicuous
				if perk == "characterInitialization" or perk == Perks.Sneak then
					if SBvars.Conspicuous == true and player:HasTrait("Conspicuous") and sneaking >= SBvars.ConspicuousSkill then
						player:getTraits():remove("Conspicuous");
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Conspicuous"), false, HaloTextHelper.getColorGreen()) end
					end
				end
			-- Inconspicuous
				if perk == "characterInitialization" or perk == Perks.Sneak then
					if SBvars.Inconspicuous == true and not player:HasTrait("Inconspicuous") and sneaking >= SBvars.InconspicuousSkill then
						player:getTraits():add("Inconspicuous");
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Inconspicuous"), true, HaloTextHelper.getColorGreen()) end
					end
				end
			-- Hunter
				if perk == "characterInitialization" or perk == "kill" or perk == Perks.Sneak or perk == Perks.Aiming or perk == Perks.Trapping or perk == Perks.SmallBlade then
					local levels = sneaking + aiming + trapping + shortBlade;
					if SBvars.Hunter == true and not player:HasTrait("Hunter") and sneaking >= 2 and aiming >= 2 and trapping >= 2 and shortBlade >= 2 and levels >= SBvars.HunterSkill and (shortBladeKills + firearmKills) >= SBvars.HunterKills then
						player:getTraits():add("Hunter");
						applyXPBoost(player, Perks.Aiming, 1);
						applyXPBoost(player, Perks.Trapping, 1);
						applyXPBoost(player, Perks.Sneak, 1);
						applyXPBoost(player, Perks.SmallBlade, 1);
						addRecipe(player, "Make Stick Trap");
						addRecipe(player, "Make Snare Trap");
						addRecipe(player, "Make Wooden Box Trap");
						addRecipe(player, "Make Trap Box");
						addRecipe(player, "Make Cage Trap");
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Hunter"), true, HaloTextHelper.getColorGreen()) end
					end
				end
	-- Combat
		-- Axe
			-- Brawler 
				if perk == "characterInitialization" or perk == "kill" or perk == Perks.Axe or perk == Perks.Blunt then
					if SBvars.Brawler == true and not player:HasTrait("Brawler") and (axe + longBlunt) >= SBvars.BrawlerSkill and (axeKills + longBluntKills) >= SBvars.BrawlerKills then
						player:getTraits():add("Brawler");
						applyXPBoost(player, Perks.Axe, 1);
						applyXPBoost(player, Perks.Blunt, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_BarFighter"), true, HaloTextHelper.getColorGreen()) end
					end
				end
			-- Axe Thrower 
				if perk == "characterInitialization" or perk == "kill" or perk == Perks.Axe then
					if not activatedMods:contains("EvolvingTraitsWorldDisableAxeThrower") and SBvars.AxeThrower == true and not player:HasTrait("AxeThrower") and axe >= SBvars.AxeThrowerSkill and axeKills >= SBvars.AxeThrowerKills then
						player:getTraits():add("AxeThrower");
						applyXPBoost(player, Perks.Axe, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_AxeThrower"), true, HaloTextHelper.getColorGreen()) end
					end
				end
		-- Long Blunt
			-- Baseball Player
				if perk == "characterInitialization" or perk == "kill" or perk == Perks.Blunt then
					if SBvars.BaseballPlayer == true and not player:HasTrait("BaseballPlayer") and longBlunt >= SBvars.BaseballPlayerSkill and longBluntKills >= SBvars.BaseballPlayerKills then
						player:getTraits():add("BaseballPlayer");
						applyXPBoost(player, Perks.Blunt, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_PlaysBaseball"), true, HaloTextHelper.getColorGreen()) end
					end
				end
		-- Short Blunt
			-- Stick Fighter 
				if perk == "characterInitialization" or perk == "kill" or perk == Perks.SmallBlunt then
					if not activatedMods:contains("EvolvingTraitsWorldDisableStickFighter") and SBvars.StickFighter == true and not player:HasTrait("StickFighter") and shortBlunt >= SBvars.StickFighterSkill and shortBluntKills >= SBvars.StickFighterKills then
						player:getTraits():add("StickFighter");
						applyXPBoost(player, Perks.SmallBlunt, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_StickFighter"), true, HaloTextHelper.getColorGreen()) end
					end
				end
		-- Long Blade
			-- Kenshi 
				if perk == "characterInitialization" or perk == "kill" or perk == Perks.LongBlade then
					if not activatedMods:contains("EvolvingTraitsWorldDisableKenshi") and SBvars.Kenshi == true and not player:HasTrait("Kenshi") and longBlade >= SBvars.KenshiSkill and longBladeKills >= SBvars.KenshiKills then
						player:getTraits():add("Kenshi");
						applyXPBoost(player, Perks.LongBlade, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Kenshi"), true, HaloTextHelper.getColorGreen()) end
					end
				end
		-- Short Blade
			-- Knife Fighter 
				if perk == "characterInitialization" or perk == "kill" or perk == Perks.ShortBlade then
					if not activatedMods:contains("EvolvingTraitsWorldDisableKnifeFighter") and SBvars.KnifeFighter == true and not player:HasTrait("KnifeFighter") and shortBlade >= SBvars.KnifeFighterSkill and shortBladeKills >= SBvars.KnifeFighterKills then
						player:getTraits():add("KnifeFighter");
						applyXPBoost(player, Perks.ShortBlade, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_KnifeFighter"), true, HaloTextHelper.getColorGreen()) end
					end
				end
		-- Spear
			-- Sojutsu 
				if perk == "characterInitialization" or perk == "kill" or perk == Perks.Spear then
					if not activatedMods:contains("EvolvingTraitsWorldDisableSojutsu") and SBvars.Sojutsu == true and not player:HasTrait("Sojutsu") and spear >= SBvars.SojutsuSkill and spearKills >= SBvars.SojutsuKills then
						player:getTraits():add("Sojutsu");
						applyXPBoost(player, Perks.Spear, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Sojutsu"), true, HaloTextHelper.getColorGreen()) end
					end
				end
		-- Maintenance
			-- Restoration Expert
				if perk == "characterInitialization" or perk == Perks.Maintenance then
					if not activatedMods:contains("EvolvingTraitsWorldDisableRestorationExpert") and SBvars.RestorationExpert == true and not player:HasTrait("RestorationExpert") and maintenance >= SBvars.RestorationExpertSkill then
						player:getTraits():add("RestorationExpert");
						applyXPBoost(player, Perks.Maintenance, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_RestorationExpert"), true, HaloTextHelper.getColorGreen()) end
					end
				end
			-- Handy
				if perk == "characterInitialization" or perk == Perks.Maintenance or perk == Perks.Woodwork then
					if SBvars.Handy == true and not player:HasTrait("Handy") and (maintenance + carpentry) >= SBvars.HandySkill then
						player:getTraits():add("Handy");
						applyXPBoost(player, Perks.Maintenance, 1);
						applyXPBoost(player, Perks.Woodwork, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_handy"), true, HaloTextHelper.getColorGreen()) end
					end
				end
			-- Slow Learner
				if perk == "characterInitialization" or perk == Perks.Maintenance or perk == Perks.Woodwork or perk == Perks.Cooking or perk == Perks.Farming or perk == Perks.Doctor or perk == Perks.Electricity or perk == Perks.MetalWelding or perk == Perks.Mechanics or perk == Perks.Tailoring then
					local levels = maintenance + carpentry + farming + firstAid + electrical + metalworking + mechanics + tailoring;
					if SBvars.SlowLearner == true and player:HasTrait("SlowLearner") and levels >= SBvars.SlowLearnerSkill then
						player:getTraits():remove("SlowLearner");
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_SlowLearner"), false, HaloTextHelper.getColorGreen()) end
					end
				end
			-- Fast Learner
				if perk == "characterInitialization" or perk == Perks.Maintenance or perk == Perks.Woodwork or perk == Perks.Cooking or perk == Perks.Farming or perk == Perks.Doctor or perk == Perks.Electricity or perk == Perks.MetalWelding or perk == Perks.Mechanics or perk == Perks.Tailoring then
					local levels = maintenance + carpentry + farming + firstAid + electrical + metalworking + mechanics + tailoring;
					if SBvars.FastLearner == true and not player:HasTrait("FastLearner") and levels >= SBvars.FastLearnerSkill then
						player:getTraits():add("FastLearner");
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_FastLearner"), true, HaloTextHelper.getColorGreen()) end
					end
				end
	-- Crafting
		-- Carpentry
			-- Furniture Assembler 
				if perk == "characterInitialization" or perk == Perks.Woodwork then
					if not activatedMods:contains("EvolvingTraitsWorldDisableFurnitureAssembler") and SBvars.FurnitureAssembler == true and not player:HasTrait("FurnitureAssembler") and carpentry >= SBvars.FurnitureAssemblerSkill then
						player:getTraits():add("FurnitureAssembler");
						applyXPBoost(player, Perks.Woodwork, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_FurnitureAssembler"), true, HaloTextHelper.getColorGreen()) end
					end
				end
		-- Cooking
			-- Home Cook 
				if perk == "characterInitialization" or perk == Perks.Cooking then
					if not activatedMods:contains("EvolvingTraitsWorldDisableHomeCook") and SBvars.HomeCook == true and not player:HasTrait("HomeCook") and cooking >= SBvars.HomeCookSkill then
						player:getTraits():add("HomeCook");
						addRecipe(player, "Make Cake Batter");
						applyXPBoost(player, Perks.Cooking, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_HomeCook"), true, HaloTextHelper.getColorGreen()) end
					end
				end
			-- Cook
				if perk == "characterInitialization" or perk == Perks.Cooking then
					if SBvars.Cook == true and not player:HasTrait("Cook") and cooking >= SBvars.CookSkill then
						player:getTraits():add("Cook");				
						addRecipe(player, "Make Cake Batter");
						addRecipe(player, "Make Pie Dough");
						addRecipe(player, "Make Bread Dough");
						addRecipe(player, "Make Biscuits");
						addRecipe(player, "Make Cookie Dough");
						addRecipe(player, "Make Chocolate Chip Cookie Dough");
						addRecipe(player, "Make Oatmeal Cookie Dough");
						addRecipe(player, "Make Shortbread Cookie Dough");
						addRecipe(player, "Make Sugar Cookie Dough");
						addRecipe(player, "Make Pizza");
						applyXPBoost(player, Perks.Cooking, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Cook"), true, HaloTextHelper.getColorGreen()) end
					end
				end
		-- Farming
			-- Gardener
				if perk == "characterInitialization" or perk == Perks.Farming then
					if SBvars.Gardener == true and not player:HasTrait("Gardener") and farming >= SBvars.GardenerSkill then
						player:getTraits():add("Gardener");
						applyXPBoost(player, Perks.Farming, 1);
						addRecipe(player, "Make Mildew Cure");
						addRecipe(player, "Make Flies Cure");
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Gardener"), true, HaloTextHelper.getColorGreen()) end
					end
				end
		-- First Aid
			-- First Aider
				if perk == "characterInitialization" or perk == Perks.Doctor then
					if SBvars.FirstAid == true and not player:HasTrait("FirstAid") and firstAid >= SBvars.FirstAidSkill then
						player:getTraits():add("FirstAid");
						applyXPBoost(player, Perks.Doctor, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_FirstAid"), true, HaloTextHelper.getColorGreen()) end
					end
				end
		-- Electrical
			-- AVClub
				if perk == "characterInitialization" or perk == Perks.Electricity then
					if not activatedMods:contains("EvolvingTraitsWorldDisableAVClub") and SBvars.AVClub == true and not player:HasTrait("AVClub") and electrical >= SBvars.AVClubSkill then
						player:getTraits():add("AVClub");
						addRecipe(player, "Make Remote Controller V1");
						addRecipe(player, "Make Remote Controller V2");
						addRecipe(player, "Make Remote Controller V3");
						addRecipe(player, "Make Remote Trigger");
						addRecipe(player, "Make Timer");
						addRecipe(player, "Craft Makeshift Radio");
						addRecipe(player, "Craft Makeshift HAM Radio");
						addRecipe(player, "Craft Makeshift Walkie Talkie");
						addRecipe(player, "Make Noise generator");
						applyXPBoost(player, Perks.Electricity, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_AVClub"), true, HaloTextHelper.getColorGreen()) end
					end
				end
		-- Metalworking
			-- Bodywork Enthusiast
				if perk == "characterInitialization" or perk == Perks.MetalWelding  or perk == Perks.Mechanics then
					if not activatedMods:contains("EvolvingTraitsWorldDisableBodyWorkEnthusiast") and SBvars.BodyworkEnthusiast == true and not player:HasTrait("BodyWorkEnthusiast") then
						ETWActionsOverride.bodyworkEnthusiastCheck();
					end
				end
		-- Mechanics
			-- Amateur Mechanic
				if perk == "characterInitialization" or perk == Perks.Mechanics then
					if SBvars.Mechanics == true and not player:HasTrait("Mechanics") and mechanics >= SBvars.MechanicsSkill then
						ETWActionsOverride.mechanicsCheck();
					end
				end
		-- Tailoring
			-- Sewer
				if perk == "characterInitialization" or perk == Perks.Tailoring then
					if SBvars.Sewer == true and not player:HasTrait("Tailor") and tailoring >= SBvars.SewerSkill then
						player:getTraits():add("Tailor");
						applyXPBoost(player, Perks.Tailoring, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Tailor"), true, HaloTextHelper.getColorGreen()) end
					end
				end
	-- Firearms
		-- Aiming
			-- Gun Enthusiast
				if perk == "characterInitialization" or perk == "kill" or perk == Perks.Aiming or perk == Perks.Reloading then
					if not activatedMods:contains("EvolvingTraitsWorldDisableGunEnthusiast") and SBvars.GunEnthusiast == true and not player:HasTrait("GunEnthusiast") and (aiming + reloading) >= SBvars.GunEnthusiastSkill and firearmKills >= SBvars.GunEnthusiastKills then
						player:getTraits():add("GunEnthusiast");
						applyXPBoost(player, Perks.Aiming, 1);
						applyXPBoost(player, Perks.Reloading, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_GunEnthusiast"), true, HaloTextHelper.getColorGreen()) end
					end
				end
	-- Survival
		-- Fishing
			-- Angler
				if perk == "characterInitialization" or perk == "kill" or perk == Perks.Fishing then
					if SBvars.Fishing == true and not player:HasTrait("Fishing") and fishing >= SBvars.FishingSkill then
						player:getTraits():add("Fishing");
						addRecipe(player, "Make Fishing Rod");
						addRecipe(player, "Fix Fishing Rod");
						applyXPBoost(player, Perks.Fishing, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Fishing"), true, HaloTextHelper.getColorGreen()) end
					end
				end
		-- Trapping
			-- Hiker
				if perk == "characterInitialization" or perk == Perks.Trapping or perk == Perks.PlantScavenging then
					if SBvars.Hiker == true and not player:HasTrait("Hiker") and (trapping + foraging) >= SBvars.HikerSkill then
						player:getTraits():add("Hiker");
						addRecipe(player, "Make Stick Trap");
						addRecipe(player, "Make Snare Trap");
						addRecipe(player, "Make Wooden Box Trap");
						applyXPBoost(player, Perks.PlantScavenging, 1);
						applyXPBoost(player, Perks.Trapping, 1);
						if notification() == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Hiker"), true, HaloTextHelper.getColorGreen()) end
					end
				end
end

local function onZombieKill(zombie)
	local player = getPlayer();
	traitsGainsBySkill(player, "kill");
end

local function initializeEvents(playerIndex, player)
	traitsGainsBySkill(player, "characterInitialization");
	Events.LevelPerk.Remove(traitsGainsBySkill);
	Events.LevelPerk.Add(traitsGainsBySkill);
	Events.OnZombieDead.Remove(onZombieKill);
	Events.OnZombieDead.Add(onZombieKill);
end

Events.OnCreatePlayer.Remove(initializeEvents);
Events.OnCreatePlayer.Add(initializeEvents);