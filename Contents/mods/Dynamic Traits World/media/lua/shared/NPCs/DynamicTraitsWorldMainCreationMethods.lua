require('NPCs/MainCreationMethods');

local function createTrait(name, cost, isProfExclusive, isDisabled)
	isProfExclusive = isProfExclusive or false;
	isDisabled = isDisabled or false;
	if getActivatedMods():contains("DynamicTraitsWorldMarkDynamicTraits") then
		return TraitFactory.addTrait(name, getText("UI_trait_" .. name .. "marked"), cost, getText("UI_trait_" .. name .."desc"), isProfExclusive, isDisabled);
	else
		return TraitFactory.addTrait(name, getText("UI_trait_" .. name), cost, getText("UI_trait_" .. name .."desc"), isProfExclusive, isDisabled);
	end
end

local function AddDTWTraits()

	--Positive Traits

	local avclub = createTrait("avclub", 5);
	avclub:addXPBoost(Perks.Electricity, 1);
	avclub:getFreeRecipes():add("Make Remote Controller V1");
	avclub:getFreeRecipes():add("Make Remote Controller V2");
	avclub:getFreeRecipes():add("Make Remote Controller V3");
	avclub:getFreeRecipes():add("Make Remote Trigger");
	avclub:getFreeRecipes():add("Make Timer");
	avclub:getFreeRecipes():add("Craft Makeshift Radio");
	avclub:getFreeRecipes():add("Craft Makeshift HAM Radio");
	avclub:getFreeRecipes():add("Craft Makeshift Walkie Talkie");
	avclub:getFreeRecipes():add("Make Noise generator");

	local axethrower = createTrait("axethrower", 4);
	axethrower:addXPBoost(Perks.Axe, 1);

	local bloodlust = createTrait("bloodlust", 4);

	local bodyworkenthusiast = createTrait("bodyworkenthusiast", 6);
	bodyworkenthusiast:addXPBoost(Perks.Mechanics, 1);
	bodyworkenthusiast:addXPBoost(Perks.MetalWelding, 1);
	bodyworkenthusiast:getFreeRecipes():add("Make Metal Walls");
	bodyworkenthusiast:getFreeRecipes():add("Make Metal Fences");
	bodyworkenthusiast:getFreeRecipes():add("Make Metal Containers");
	bodyworkenthusiast:getFreeRecipes():add("Make Metal Sheet");
	bodyworkenthusiast:getFreeRecipes():add("Make Small Metal Sheet");
	bodyworkenthusiast:getFreeRecipes():add("Make Metal Roof");
	bodyworkenthusiast:getFreeRecipes():add("Make Metal Pipe");

	local furnitureassembler = createTrait("furnitureassembler", 4);
	furnitureassembler:addXPBoost(Perks.Woodwork, 1);

	local gunnthusiast = createTrait("gunenthusiast", 6);
	gunnthusiast:addXPBoost(Perks.Aiming, 1);
	gunnthusiast:addXPBoost(Perks.Reloading, 1);

	local gymrat = createTrait("gymrat", 6);
	gymrat:addXPBoost(Perks.Fitness, 1);
	gymrat:addXPBoost(Perks.Strength, 1);

	local hoarder = createTrait("hoarder", 4);

	local homecook = createTrait("homecook", 3);
	homecook:addXPBoost(Perks.Cooking, 1);
	homecook:getFreeRecipes():add("Make Cake Batter");

	local kenshi = createTrait("kenshi", 4);
	kenshi:addXPBoost(Perks.LongBlade, 1);

	local knifefighter = createTrait("knifefighter", 3);
	knifefighter:addXPBoost(Perks.SmallBlade, 1);

	local lightstep = createTrait("lightstep", 3);
	lightstep:addXPBoost(Perks.Lightfoot, 1);

	local restorationexpert = createTrait("restorationexpert", 8);
	restorationexpert:addXPBoost(Perks.Maintenance, 1);

	local lowprofile = createTrait("lowprofile", 3);
	lowprofile:addXPBoost(Perks.Sneak, 1);

	local sojutsu = createTrait("sojutsu", 3);
	sojutsu:addXPBoost(Perks.Spear, 1);

	local stickfighter = createTrait("stickfighter", 3);
	stickfighter:addXPBoost(Perks.SmallBlunt, 1);

	-- Negative Traits

	local sedentary = createTrait("sedentary", -6);
	sedentary:addXPBoost(Perks.Fitness, -1);
	sedentary:addXPBoost(Perks.Strength, -1);


	--Exclusives
	TraitFactory.setMutualExclusive("gymrat", "Unfit");
	TraitFactory.setMutualExclusive("gymrat", "Out of Shape");
	TraitFactory.setMutualExclusive("gymrat", "Weak");
	TraitFactory.setMutualExclusive("gymrat", "Feeble");
	TraitFactory.setMutualExclusive("gymrat", "Obese");
	TraitFactory.setMutualExclusive("gymrat", "Very Underweight");
	TraitFactory.setMutualExclusive("sedentary", "Fit");
	TraitFactory.setMutualExclusive("sedentary", "Athletic");
	TraitFactory.setMutualExclusive("sedentary", "Strong");
	TraitFactory.setMutualExclusive("sedentary", "Stout");
	TraitFactory.setMutualExclusive("sedentary", "gymrat");
	
	TraitFactory.sortList();
end

Events.OnGameBoot.Add(AddDTWTraits);