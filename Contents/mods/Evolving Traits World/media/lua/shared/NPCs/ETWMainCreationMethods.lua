require('NPCs/MainCreationMethods');

local function createTrait(name, cost, isProfExclusive, isDisabled)
	isProfExclusive = isProfExclusive or false;
	isDisabled = isDisabled or false;
	if getActivatedMods():contains("EvolvingTraitsWorldMarkDynamicTraits") then
		return TraitFactory.addTrait(name, getText("UI_trait_" .. name) .. " (D)", cost, getText("UI_trait_" .. name .. "Desc"), isProfExclusive, isDisabled);
	else
		return TraitFactory.addTrait(name, getText("UI_trait_" .. name), cost, getText("UI_trait_" .. name .. "Desc"), isProfExclusive, isDisabled);
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

	--local traitList = TraitFactory.getTraits()
	--for i = 1, traitList:size() do
	--	local trait = traitList:get(i - 1)
	--	BaseGameCharacterDetails.SetTraitDescription(trait)
	--end
end

Events.OnGameBoot.Add(addTraits);