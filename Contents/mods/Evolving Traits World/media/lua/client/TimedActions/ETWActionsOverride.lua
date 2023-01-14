ETWActionsOverride = {};

local SBvars = SandboxVars.EvolvingTraitsWorld;

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

function ETWActionsOverride.bodyworkEnthusiastCheck()
	-- confirmed working
	local player = getPlayer();
	local modData = player:getModData().EvolvingTraitsWorld;
	local level = player:getPerkLevel(Perks.MetalWelding) + player:getPerkLevel(Perks.Mechanics);
	if level >= SBvars.BodyworkEnthusiastSkill and modData.VehiclePartRepairs >= SBvars.BodyworkEnthusiastRepairs then
		local notification = EvolvingTraitsWorld.settings.EnableNotifications;
		player:getTraits():add("BodyWorkEnthusiast");
		applyXPBoost(player, Perks.MetalWelding, 1);
		applyXPBoost(player, Perks.Mechanics, 1);
		addRecipe(player, "Make Metal Walls");
		addRecipe(player, "Make Metal Fences");
		addRecipe(player, "Make Metal Containers");
		addRecipe(player, "Make Metal Sheet");
		addRecipe(player, "Make Small Metal Sheet");
		addRecipe(player, "Make Metal Roof");
		if notification == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_BodyWorkEnthusiast"), true, HaloTextHelper.getColorGreen()) end
	end
end

function ETWActionsOverride.mechanicsCheck()
	-- confirmed working
	local player = getPlayer();
	local modData = player:getModData().EvolvingTraitsWorld;
	if player:getPerkLevel(Perks.Mechanics) >= SBvars.BodyworkEnthusiastSkill and modData.VehiclePartRepairs >= SBvars.MechanicsRepairs then
		player:getTraits():add("Mechanics");
		local notification = EvolvingTraitsWorld.settings.EnableNotifications;
		applyXPBoost(player, Perks.Mechanics, 1);
		addRecipe(player, "Basic Mechanics");
		addRecipe(player, "Intermediate Mechanics");
		if notification == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Mechanics"), true, HaloTextHelper.getColorGreen()) end
	end
end

local original_fix_perform = ISFixAction.perform;
function ISFixAction:perform()
	local player = self.character;
	local modData = player:getModData().EvolvingTraitsWorld;
	local vehiclePartCondition = 0;
	if self.vehiclePart then
		local part = self.vehiclePart;
		vehiclePartCondition = part:getCondition();
	end
	original_fix_perform(self);
	if self.vehiclePart and ((SBvars.BodyworkEnthusiast == true and not player:HasTrait("Mechanics")) or (SBvars.BodyWorkEnthusiast == true and not player:HasTrait("BodyWorkEnthusiast"))) then
		modData.VehiclePartRepairs = modData.VehiclePartRepairs + (self.vehiclePart:getCondition() - vehiclePartCondition);
		ETWActionsOverride.bodyworkEnthusiastCheck();
		ETWActionsOverride.mechanicsCheck();
	end
	if player:HasTrait("RestorationExpert") then
		self.item:setHaveBeenRepaired(self.item:getHaveBeenRepaired() - 1);
	end
end

local original_transfer_perform = ISInventoryTransferAction.perform;
function ISInventoryTransferAction:perform() -- confirmed working
	if self.character == getPlayer() and self.character:getModData().EvolvingTraitsWorld ~= nil then
		if SBvars.InventoryTransferSystem == true then
			local notification = EvolvingTraitsWorld.settings.EnableNotifications;
			local player = self.character;
			local item = self.item;
			local itemWeight = item:getWeight();
			local modData = player:getModData().EvolvingTraitsWorld.TransferSystem;
			modData.ItemsTransferred = modData.ItemsTransferred + 1;
			modData.WeightTransferred = modData.WeightTransferred + itemWeight;
			--print("ETW Logger: Moving an item with weight of "..itemWeight);
			--print("ETW Logger: Moved weight: "..modData.WeightTransferred..", Moved Items: "..modData.ItemsTransferred);
			original_transfer_perform(self);
			if player:HasTrait("Disorganized") and modData.WeightTransferred >= SBvars.InventoryTransferSystemWeight * 0.6 and modData.ItemsTransferred >= SBvars.InventoryTransferSystemItems * 0.3 then
				player:getTraits():remove("Disorganized");
				if notification == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Disorganized"), false, HaloTextHelper.getColorGreen()) end
			end
			if not player:HasTrait("Organized") and modData.WeightTransferred >= SBvars.InventoryTransferSystemWeight and modData.ItemsTransferred >= SBvars.InventoryTransferSystemItems * 0.6 then
				player:getTraits():add("Organized");
				if notification == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Packmule"), true, HaloTextHelper.getColorGreen()) end
			end
			if player:HasTrait("AllThumbs") and modData.WeightTransferred >= SBvars.InventoryTransferSystemWeight * 0.3 and modData.ItemsTransferred >= SBvars.InventoryTransferSystemItems * 0.6 then
				player:getTraits():remove("AllThumbs");
				if notification == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_AllThumbs"), false, HaloTextHelper.getColorGreen()) end
			end
			if not player:HasTrait("Dextrous") and modData.WeightTransferred >= SBvars.InventoryTransferSystemWeight * 0.6 and modData.ItemsTransferred >= SBvars.InventoryTransferSystemItems then
				player:getTraits():add("Dextrous");
				if notification == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Dexterous"), true, HaloTextHelper.getColorGreen()) end
			end
			if player:HasTrait("butterfingers") and modData.WeightTransferred >= SBvars.InventoryTransferSystemWeight * 1.5 and modData.ItemsTransferred >= SBvars.InventoryTransferSystemItems * 1.5 then
				player:getTraits():remove("butterfingers");
				if notification == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_AllThumbs"), false, HaloTextHelper.getColorGreen()) end
			end
		end
	else
		original_transfer_perform(self);
	end
end

local function iterList(_list)
	local list = _list;
	local size = list:size() - 1;
	local i = -1;
	return function()
		i = i + 1;
		if i <= size and not list:isEmpty() then
			return list:get(i), i;
		end
	end
end

local original_forageSystem_addOrDropItems = forageSystem.addOrDropItems;
function forageSystem.addOrDropItems(_character, _inventory, _items, _discardItems)
	local player = getPlayer();
	if not _discardItems then
		for item in iterList(_items) do
			--print("ETW Logger: picking up item: "..item:getFullType());
			local herbs = {
				-- Medical herbs
				"Base.Plantain",
				"Base.Comfrey",
				"Base.WildGarlic",
				"Base.CommonMallow",
				"Base.LemonGrass",
				"Base.BlackSage",
				"Base.Ginseng",
				-- Wild Plants
				"Base.Violets",
				"Base.GrapeLeaves",
				"Base.Rosehips",
				-- Wild Herbs
				"Base.Basil",
				"Base.Chives",
				"Base.Cilantro",
				"Base.Oregano",
				"Base.Parsley",
				"Base.Rosemary",
				"Base.Sage",
				"Base.Thyme",
				-- Testing
				--"Base.Twigs",
			}
			for _, herb in pairs(herbs) do
				if herb == item:getFullType() then
					--print("ETW Logger: picking up herbs: "..item:getFullType())
					local modData = player:getModData().EvolvingTraitsWorld;
					modData.HerbsPickedUp = modData.HerbsPickedUp + 1;
					if not player:HasTrait("Herbalist") and modData.HerbsPickedUp >= SBvars.HerbalistHerbsPicked then
						local notification = EvolvingTraitsWorld.settings.EnableNotifications;
						player:getTraits():add("Herbalist");
						addRecipe(player, "Herbalist");
						if notification == true then HaloTextHelper.addTextWithArrow(player, getText("UI_trait_Herbalist"), true, HaloTextHelper.getColorGreen()) end
					end
				end
			end
		end
	end
	return (original_forageSystem_addOrDropItems(_character, _inventory, _items, _discardItems));
end

return ETWActionsOverride;