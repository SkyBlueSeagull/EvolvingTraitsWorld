DTWActionsOverride = {};
local SBvars = SandboxVars.DynamicTraitsWorld;

local function applyXPBoost(player, perk, boostLevel)
	local newBoost = player:getXp():getPerkBoost(perk) + boostLevel;
	if newBoost > 3 then
		player:getXp():setPerkBoost(perk, 3);
	else
		player:getXp():setPerkBoost(perk, newBoost);
	end
end

function DTWActionsOverride.bodyworkEnthusiastCheck()
	local player = getPlayer();
	local modData = player:getModData().DynamicTraitsWorld;
	local level = player:getPerkLevel(Perks.MetalWelding) + player:getPerkLevel(Perks.Mechanics);
	local sblevel = SBvars.BodyworkEnthusiastSkill;
	local repairs = modData.VehiclePartRepairs;
	local sbrepairs = SBvars.BodyworkEnthusiastRepairs;
	if level >= sblevel and repairs >= sbrepairs then
		player:getTraits():add("bodyworkenthusiast");
		applyXPBoost(player, Perks.MetalWelding, 1);
		applyXPBoost(player, Perks.Mechanics, 1);
		local playerRecipes = player:getKnownRecipes();
		if not playerRecipes:contains("Make Metal Walls") then
			playerRecipes:add("Make Metal Walls");
		end
		if not playerRecipes:contains("Make Metal Fences") then
			playerRecipes:add("Make Metal Fences");
		end
		if not playerRecipes:contains("Make Metal Containers") then
			playerRecipes:add("Make Metal Containers");
		end
		if not playerRecipes:contains("Make Metal Sheet") then
			playerRecipes:add("Make Metal Sheet");
		end
		if not playerRecipes:contains("Make Small Metal Sheet") then
			playerRecipes:add("Make Small Metal Sheet");
		end
		if not playerRecipes:contains("Make Metal Roof") then
			playerRecipes:add("Make Metal Roof");
		end
		if not playerRecipes:contains("Make Metal Pipe") then
			playerRecipes:add("Make Metal Pipe");
		end
		HaloTextHelper.addTextWithArrow(player, getText("UI_trait_bodyworkenthusiast"), true, HaloTextHelper.getColorGreen());
	end
end

local original_fix_perform = ISFixAction.perform;
function ISFixAction:perform()
	local player = self.character;
	local modData = player:getModData().DynamicTraitsWorld;
	local vehiclePartCondition = 0;
	if self.vehiclePart then
		local part = self.vehiclePart;
		vehiclePartCondition = part:getCondition();
	end
	original_fix_perform(self);
	if SBvars.BodyworkEnthusiast == true and self.vehiclePart and not player:HasTrait("bodyworkenthusiast") then
		modData.VehiclePartRepairs = modData.VehiclePartRepairs + (self.vehiclePart:getCondition() - vehiclePartCondition);
		DTWActionsOverride.bodyworkEnthusiastCheck();
	end
	if player:HasTrait("restorationexpert") then
		self.item:setHaveBeenRepaired(self.item:getHaveBeenRepaired() - 1);
	end
end

return DTWActionsOverride;