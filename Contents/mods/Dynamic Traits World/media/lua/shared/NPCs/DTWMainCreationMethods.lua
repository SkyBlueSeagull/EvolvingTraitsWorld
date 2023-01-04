require('NPCs/MainCreationMethods');

local function createTrait(name, cost, isProfExclusive, isDisabled)
	isProfExclusive = isProfExclusive or false;
	isDisabled = isDisabled or false;
	if getActivatedMods():contains("DynamicTraitsWorldMarkDynamicTraits") then
		return TraitFactory.addTrait(name, getText("UI_trait_" .. name .. "Marked"), cost, getText("UI_trait_" .. name .."Desc"), isProfExclusive, isDisabled);
	else
		return TraitFactory.addTrait(name, getText("UI_trait_" .. name), cost, getText("UI_trait_" .. name .."Desc"), isProfExclusive, isDisabled);
	end
end

if getActivatedMods():contains('DynamicTraitsWorldMarkDynamicTraits') then
	-- Special thanks to Albion and Chuck for this function
	local altNames = {}
	altNames.Gardener = getTextOrNull('UI_trait_GardenerMarked');
	altNames.FirstAid = getTextOrNull('UI_trait_FirstAidMarked');
	altNames.Graceful = getTextOrNull('UI_trait_GracefulMarked');
	altNames.Gymnast = getTextOrNull('UI_trait_GymnastMarked');
	altNames.BaseballPlayer = getTextOrNull('UI_trait_BaseballPlayerMarked');
	altNames.Mechanics = getTextOrNull('UI_trait_MechanicsMarked');
	altNames.Inconspicuous = getTextOrNull('UI_trait_InconspicuousMarked');
	altNames.Cook = getTextOrNull('UI_trait_CookMarked');
	altNames.Handy = getTextOrNull('UI_trait_HandyMarked');
	altNames.Jogger = getTextOrNull('UI_trait_RunnerMarked');
	altNames.Tailor = getTextOrNull('UI_trait_SewerMarked');
	altNames.FastLearner = getTextOrNull('UI_trait_FastLearnerMarked');
	altNames.SlowLearner = getTextOrNull('UI_trait_SlowLearnerMarked');
	altNames.Brawler = getTextOrNull('UI_trait_BrawlerMarked');
	altNames.EagleEyed = getTextOrNull('UI_trait_EagleEyedMarked');
	altNames.Outdoorsman = getTextOrNull('UI_trait_OutdoorsmanMarked');
	altNames.Hunter = getTextOrNull('UI_trait_HunterMarked');
	altNames.Cowardly = getTextOrNull('UI_trait_CowardlyMarked');
	altNames.Hemophobic = getTextOrNull('UI_trait_HemophobicMarked');
	altNames.Pacifist = getTextOrNull('UI_trait_PacifistMarked');
	altNames.AdrenalineJunkie = getTextOrNull('UI_trait_AdrenalineJunkieMarked');
	altNames.Brave = getTextOrNull('UI_trait_BraveMarked');
	altNames.NightVision = getTextOrNull('UI_trait_NightVisionMarked');
	altNames.Dextrous = getTextOrNull('UI_trait_DexterousMarked');
	altNames.Organized = getTextOrNull('UI_trait_OrganizedMarked');
	altNames.AllThumbs = getTextOrNull('UI_trait_AllThumbsMarked');
	altNames.Disorganized = getTextOrNull('UI_trait_DisorganizedMarked');
	altNames.Clumsy = getTextOrNull('UI_trait_ClumsyMarked');
	altNames.Conspicuous = getTextOrNull('UI_trait_ConspicuousMarked');
	altNames.Agoraphobic = getTextOrNull('UI_trait_AgoraphobicMarked');
	altNames.Claustophobic = getTextOrNull('UI_trait_ClaustrophobicMarked');
	altNames.Lucky = getTextOrNull('UI_trait_LuckyMarked');
	altNames.Unlucky = getTextOrNull('UI_trait_UnluckyMarked');
	altNames.Resilient = getTextOrNull('UI_trait_ResilientMarked');
	altNames.ProneToIllness = getTextOrNull('UI_trait_ProneToIllnessMarked');
	altNames.KeenHearing = getTextOrNull('UI_trait_KeenHearingMarked');
	altNames.HardOfHearing = getTextOrNull('UI_trait_HardOfHearingMarked');
	altNames.IronGut = getTextOrNull('UI_trait_IronGutMarked');
	altNames.WeakStomach = getTextOrNull('UI_trait_WeakStomachMarked');
	altNames.Hiker = getTextOrNull('UI_trait_HikerMarked');
	altNames.Herbalist = getTextOrNull('UI_trait_HerbalistMarked');
	altNames.NeedsMoreSleep = getTextOrNull('UI_trait_SleepyheadMarked');
	altNames.NeedsLessSleep = getTextOrNull('UI_trait_WakefulMarked');
	altNames.Stout = getTextOrNull('UI_trait_StoutMarked');
	altNames.Strong = getTextOrNull('UI_trait_StrongMarked');
	altNames.Feeble = getTextOrNull('UI_trait_FeebleMarked');
	altNames.Weak = getTextOrNull('UI_trait_WeakMarked');
	altNames.Overweight = getTextOrNull('UI_trait_OverweightMarked');
	altNames.Obese = getTextOrNull('UI_trait_ObeseMarked');
	altNames["Very Underweight"] = getTextOrNull('UI_trait_VeryUnderweightMarked');
	altNames.Underweight = getTextOrNull('UI_trait_UnderweightMarked');
	altNames.Fit = getTextOrNull('UI_trait_FitMarked');
	altNames.Athletic = getTextOrNull('UI_trait_AthleticMarked');
	altNames.Unfit = getTextOrNull('UI_trait_UnfitMarked');
	altNames["Out of Shape"] = getTextOrNull('UI_trait_OutOfShapeMarked');
	altNames.LightEater = getTextOrNull('UI_trait_LightEaterMarked');
	altNames.HeartyAppitite = getTextOrNull('UI_trait_HeartyAppetiteMarked');
	altNames.LowThirst = getTextOrNull('UI_trait_LowThirstMarked');
	altNames.HighThirst = getTextOrNull('UI_trait_HighThirstMarked');
	altNames.Thinskinned = getTextOrNull('UI_trait_ThinSkinnedMarked');
	altNames.ThickSkinned = getTextOrNull('UI_trait_ThickSkinnedMarked');
	altNames.FastHealer = getTextOrNull('UI_trait_FastHealerMarked');
	altNames.SlowHealer = getTextOrNull('UI_trait_SlowHealerMarked');

	if getActivatedMods():contains('Literacy') then
		altNames.FastReader = getTextOrNull('UI_trait_FastReaderMarked');
		altNames.SlowReader = getTextOrNull('UI_trait_SlowReaderMarked');
		altNames.PoorReader = getTextOrNull('UI_trait_PoorReaderMarked');
	end

	if getActivatedMods():contains('ToadTraitsDynamic') then
		altNames.packmule = getTextOrNull('UI_trait_PackMuleMarked');
		altNames.packmouse = getTextOrNull('UI_trait_PackMouseMarked');
		altNames.gymgoer = getTextOrNull('UI_trait_GymGoerMarked');
		altNames.secondwind = getTextOrNull('UI_trait_SecondWindMarked');
		altNames.hardy = getTextOrNull('UI_trait_HardyMarked');
		altNames.olympian = getTextOrNull('UI_trait_OlympianMarked');
		altNames.swift = getTextOrNull('UI_trait_SwiftMarked');
		altNames.flexible = getTextOrNull('UI_trait_FlexibleMarked');
		altNames.fitted = getTextOrNull('UI_trait_WellFittedMarked');
		altNames.quiet = getTextOrNull('UI_trait_QuietMarked');
		altNames.tavernbrawler = getTextOrNull('UI_trait_TavernBrawlerMarked');
		altNames.problade = getTextOrNull('UI_trait_ProBladeMarked');
		altNames.gordanite = getTextOrNull('UI_trait_GordaniteMarked');
		altNames.blunttwirl = getTextOrNull('UI_trait_ThuggishMarked');
		altNames.problunt = getTextOrNull('UI_trait_ProBluntMarked');
		altNames.martial = getTextOrNull('UI_trait_MartialArtistMarked');
		altNames.bouncer = getTextOrNull('UI_trait_BouncerMarked');
		altNames.bladetwirl = getTextOrNull('UI_trait_PracticedSwordsmanMarked');
		altNames.slowworker = getTextOrNull('UI_trait_SlowWorkerMarked');
		altNames.quickworker = getTextOrNull('UI_trait_FastWorkerMarked');
		altNames.grunt = getTextOrNull('UI_trait_GruntWorkerMarked');
		altNames.natural = getTextOrNull('UI_trait_NaturalEaterMarked');
		altNames.ascetic = getTextOrNull('UI_trait_AsceticMarked');
		altNames.gourmand = getTextOrNull('UI_trait_GourmandMarked');
		altNames.tinkerer = getTextOrNull('UI_trait_TinkererMarked');
		altNames.scrapper = getTextOrNull('UI_trait_ScrapperMarked');
		altNames.terminator = getTextOrNull('UI_trait_TerminatorMarked');
		altNames.antigun = getTextOrNull('UI_trait_AntiGunActivistMarked');
		altNames.progun = getTextOrNull('UI_trait_ProGunMarked');
		altNames.prospear = getTextOrNull('UI_trait_ProSpearMarked');
		altNames.wildsman = getTextOrNull('UI_trait_WildsmanMarked');
		altNames.indefatigable = getTextOrNull('UI_trait_IndefatigableMarked');
		altNames.noodlelegs = getTextOrNull('UI_trait_NoodleLegsMarked');
		altNames.evasive = getTextOrNull('UI_trait_EvasiveMarked');
		altNames.idealweight = getTextOrNull('UI_trait_IdealWeightMarked');
		altNames.leadfoot = getTextOrNull('UI_trait_LeadFootMarked');
		altNames.unwavering = getTextOrNull('UI_trait_UnwaveringMarked');
		altNames.immunocompromised = getTextOrNull('UI_trait_ImmunocompromisedMarked');
		altNames.superimmune = getTextOrNull('UI_trait_SuperimmuneMarked');
		altNames.mundane = getTextOrNull('UI_trait_MundaneMarked');
		altNames.butterfingers = getTextOrNull('UI_trait_ButterfingersMarked');
		altNames.paranoia = getTextOrNull('UI_trait_ParanoiaMarked');
		if getActivatedMods():contains('DrivingSkill') then
			altNames.motionsickness = getTextOrNull('UI_trait_MotionSicknessMarked');
		end
		if getActivatedMods():contains('ScavengingSkill') or getActivatedMods():contains("ScavengingSkillFixed") then
			altNames.incomprehensive = getTextOrNull('UI_trait_IncomprehensiveMarked');
			altNames.vagabond = getTextOrNull('UI_trait_VagabondMarked');
			altNames.graverobber = getTextOrNull('UI_trait_GraverobberMarked');
			altNames.antique = getTextOrNull('UI_trait_AntiqueCollectorMarked');
			altNames.packmule = getTextOrNull('UI_trait_PackMuleMarked');
		end
	end

	if getActivatedMods():contains('MoreSimpleTraits') then
		altNames.Sneaky = getTextOrNull('UI_trait_SneakyMarked');
		altNames.Lightfooted = getTextOrNull('UI_trait_LightfootedMarked');
		altNames.MarathonRunner = getTextOrNull('UI_trait_MarathonRunnerMarked');
		altNames.StrongNimble = getTextOrNull('UI_trait_RelentlessMarked');
		altNames.Nimble = getTextOrNull('UI_trait_AgileMarked');
		altNames.AMForager = getTextOrNull('UI_trait_ForagerMarked');
		altNames.AMTrapper = getTextOrNull('UI_trait_TrapperMarked');
		altNames.AMCook = getTextOrNull('UI_trait_ScullionMarked');
		altNames.AMElectrician = getTextOrNull('UI_trait_ElectricalTechnicianMarked');
		altNames.AMMechanic = getTextOrNull('UI_trait_AutoMechanicMarked');
		altNames.AMCarpenter = getTextOrNull('UI_trait_CarpenterMarked');
		altNames.AMMetalworker = getTextOrNull('UI_trait_MetalwelderMarked');
		altNames.Durabile = getTextOrNull('UI_trait_DurabilityMarked');
		altNames.Shortbladefan = getTextOrNull('UI_trait_PiercerMarked');
		altNames.Shortbluntfan = getTextOrNull('UI_trait_CrusherMarked');
		altNames.Cutter = getTextOrNull('UI_trait_CutterMarked');
		altNames.Spearman = getTextOrNull('UI_trait_LancerMarked');
		altNames.Swordsman = getTextOrNull('UI_trait_SwordsmanMarked');
		altNames.Gunfan = getTextOrNull('UI_trait_ShooterMarked');
		altNames.Sharpshooter = getTextOrNull('UI_trait_SniperMarked');
		altNames.NinjaWay = getTextOrNull('UI_trait_BetweenTheShadowsMarked');
	end

	if getActivatedMods():contains('SixthSenseMoodle') then
		altNames.SixthSense = getTextOrNull('UI_trait_SixthSenseMarked');
	end

	if getActivatedMods():contains('ExplorerTrait') then
		altNames.Explorer = getTextOrNull('UI_trait_ExplorerMarked');
	end

	local old_addTrait = TraitFactory.addTrait
	
	function TraitFactory.addTrait(type, name, ...)
		name = altNames[type] or name
		return old_addTrait(type, name, ...)
	end
end

local function addTraits()

	local AVClub = createTrait("AVClub", 5);
	AVClub:addXPBoost(Perks.Electricity, 1);
	AVClub:getFreeRecipes():add("Make Remote Controller V1");
	AVClub:getFreeRecipes():add("Make Remote Controller V2");
	AVClub:getFreeRecipes():add("Make Remote Controller V3");
	AVClub:getFreeRecipes():add("Make Remote Trigger");
	AVClub:getFreeRecipes():add("Make Timer");
	AVClub:getFreeRecipes():add("Craft Makeshift Radio");	
	AVClub:getFreeRecipes():add("Craft Makeshift HAM Radio");
	AVClub:getFreeRecipes():add("Craft Makeshift Walkie Talkie");
	AVClub:getFreeRecipes():add("Make Noise generator");

	local AxeThrower = createTrait("AxeThrower", 4);
	AxeThrower:addXPBoost(Perks.Axe, 1);

	local Bloodlust = createTrait("Bloodlust", 4);

	local BodyWorkEnthusiast = createTrait("BodyWorkEnthusiast", 6);
	BodyWorkEnthusiast:addXPBoost(Perks.Mechanics, 1);
	BodyWorkEnthusiast:addXPBoost(Perks.MetalWelding, 1);
	BodyWorkEnthusiast:getFreeRecipes():add("Make Metal Walls");
	BodyWorkEnthusiast:getFreeRecipes():add("Make Metal Fences");
	BodyWorkEnthusiast:getFreeRecipes():add("Make Metal Containers");
	BodyWorkEnthusiast:getFreeRecipes():add("Make Metal Sheet");
	BodyWorkEnthusiast:getFreeRecipes():add("Make Small Metal Sheet");
	BodyWorkEnthusiast:getFreeRecipes():add("Make Metal Roof");
	BodyWorkEnthusiast:getFreeRecipes():add("Make Metal Pipe");

	local Fishing = createTrait("Fishing", 4);
	Fishing:addXPBoost(Perks.Fishing, 1)
	Fishing:getFreeRecipes():add("Make Fishing Rod");
	Fishing:getFreeRecipes():add("Fix Fishing Rod");

	local FurnitureAssembler = createTrait("FurnitureAssembler", 4);
	FurnitureAssembler:addXPBoost(Perks.Woodwork, 1);

	local GunEnthusiast = createTrait("GunEnthusiast", 6);
	GunEnthusiast:addXPBoost(Perks.Aiming, 1);
	GunEnthusiast:addXPBoost(Perks.Reloading, 1);

	local GymRat = createTrait("GymRat", 6);
	GymRat:addXPBoost(Perks.Fitness, 1);
	GymRat:addXPBoost(Perks.Strength, 1);

	local Hoarder = createTrait("Hoarder", 4);

	local HomeCook = createTrait("HomeCook", 3);
	HomeCook:addXPBoost(Perks.Cooking, 1);
	HomeCook:getFreeRecipes():add("Make Cake Batter");

	local Kenshi = createTrait("Kenshi", 4);
	Kenshi:addXPBoost(Perks.LongBlade, 1);

	local KnifeFighter = createTrait("KnifeFighter", 3);
	KnifeFighter:addXPBoost(Perks.SmallBlade, 1);

	local LightStep = createTrait("LightStep", 3);
	LightStep:addXPBoost(Perks.Lightfoot, 1);

	local LowProfile = createTrait("LowProfile", 3);
	LowProfile:addXPBoost(Perks.Sneak, 1);

	local Pluviophile = createTrait("Pluviophile", 2);

	local Pluviophobia = createTrait("Pluviophobia", -2);

	local RestorationExpert = createTrait("RestorationExpert", 8);
	RestorationExpert:addXPBoost(Perks.Maintenance, 1);

	local Sojutsu = createTrait("Sojutsu", 3);
	Sojutsu:addXPBoost(Perks.Spear, 1);

	local StickFighter = createTrait("StickFighter", 3);
	StickFighter:addXPBoost(Perks.SmallBlunt, 1);

	--Exclusives
	TraitFactory.setMutualExclusive("GymRat", "Unfit");
	TraitFactory.setMutualExclusive("GymRat", "Out of Shape");
	TraitFactory.setMutualExclusive("GymRat", "Weak");
	TraitFactory.setMutualExclusive("GymRat", "Feeble");
	TraitFactory.setMutualExclusive("GymRat", "Obese");
	TraitFactory.setMutualExclusive("GymRat", "Very Underweight");
	TraitFactory.setMutualExclusive("Pluviophobia", "Pluviophile");
	
	TraitFactory.sortList();

	local traitList = TraitFactory.getTraits()
	for i = 1, traitList:size() do
		local trait = traitList:get(i - 1)
		BaseGameCharacterDetails.SetTraitDescription(trait)
	end
end

Events.OnGameBoot.Add(addTraits);