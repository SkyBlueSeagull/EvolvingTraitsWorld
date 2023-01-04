require "DTWModData";

local SBvars = SandboxVars.DynamicTraitsWorld;

local function coldTraits() -- confirmed working
    local player = getPlayer();
    local coldStrength = player:getBodyDamage():getColdStrength() / 100;
    local modData = player:getModData().DynamicTraitsWorld.ColdSystem;
    if coldStrength > 0 and modData.CurrentlySick == false then modData.CurrentlySick = true end
    if modData.CurrentlySick == true then
        modData.CurrentColdCounterContribution = modData.CurrentColdCounterContribution + coldStrength / 60;
        --print("DTW Logger: CurrentColdCounterContribution = "..modData.CurrentColdCounterContribution);
        if coldStrength == 0 then
            modData.CurrentColdCounterContribution = math.min(10, modData.CurrentColdCounterContribution);
            --print("DTW Logger: Healthy now, CurrentColdCounterContribution = "..modData.CurrentColdCounterContribution);
            modData.CurrentlySick = false;
            if modData.CurrentColdCounterContribution == 10 then modData.ColdsWeathered = modData.ColdsWeathered + 1 end
            modData.CurrentColdCounterContribution = 0;
            if player:HasTrait("ProneToIllness") and modData.ColdsWeathered >= SBvars.ColdIllnessSystemColdsWeathered / 2 then
                player:getTraits():remove("ProneToIllness");
                HaloTextHelper.addTextWithArrow(player, getText("UI_trait_pronetoillness"), false, HaloTextHelper.getColorGreen());
            elseif not player:HasTrait("Resilient") and modData.ColdsWeathered >= SBvars.ColdIllnessSystemColdsWeathered then
                player:getTraits():add("Resilient");
                HaloTextHelper.addTextWithArrow(player, getText("UI_trait_resilient"), true, HaloTextHelper.getColorGreen());
                Events.EveryOneMinute.Remove(coldTraits);
            end
        end
    end
end

local function foodSicknessTraits()
    local player = getPlayer();
    local foodSicknessStrength = player:getBodyDamage():getFoodSicknessLevel() / 100;
    --print("DTW Logger: foodSicknessStrength="..foodSicknessStrength);
    local modData = player:getModData().DynamicTraitsWorld;
    modData.FoodSicknessWeathered = modData.FoodSicknessWeathered + foodSicknessStrength;
    if player:HasTrait("WeakStomach") and modData.FoodSicknessWeathered >= SBvars.FoodSicknessSystemCounter / 2 then
        player:getTraits():remove("WeakStomach");
        HaloTextHelper.addTextWithArrow(player, getText("UI_trait_WeakStomach"), false, HaloTextHelper.getColorGreen());
    elseif not player:HasTrait("IronGut") and modData.FoodSicknessWeathered >= SBvars.FoodSicknessSystemCounter then
        player:getTraits():add("IronGut");
        HaloTextHelper.addTextWithArrow(player, getText("UI_trait_IronGut"), true, HaloTextHelper.getColorGreen());
        Events.EveryOneMinute.Remove(foodSicknessTraits);
    end
end

local function weightSystemBasic()
    local player = getPlayer();
    local startingTraits = player:getModData().DynamicTraitsWorld.StartingTraits;
    local weight = player:getNutrition():getWeight();
    local stress = player:getStats():getStress();
    local unhappiness = player:getBodyDamage():getUnhappynessLevel();
    --print("stress: "..stress.." unhappiness:"..unhappiness); stress is 0-1, unhappiness is 0-100
    if weight >= 100 or weight <= 65 then
        if not player:HasTrait("SlowHealer") then
            player:getTraits():add("SlowHealer");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_SlowHealer"), true, HaloTextHelper.getColorRed());
        end
        if not player:HasTrait("Thinskinned") then
            player:getTraits():add("Thinskinned");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_ThinSkinned"), true, HaloTextHelper.getColorRed());
        end
    end
    if (weight > 85 and weight < 100) or (weight > 65 and weight < 75) then
        if not player:HasTrait("HeartyAppitite") then
            player:getTraits():add("HeartyAppitite");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_heartyappetite"), true, HaloTextHelper.getColorRed());
        end
        if not player:HasTrait("HighThirst") then
            player:getTraits():add("HighThirst");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_HighThirst"), true, HaloTextHelper.getColorRed());
        end
        if player:HasTrait("Thinskinned") and startingTraits.ThinSkinned ~= true then
            player:getTraits():remove("Thinskinned");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_ThinSkinned"), false, HaloTextHelper.getColorGreen());
        end
        if player:HasTrait("SlowHealer") and startingTraits.SlowHealer ~= true then
            player:getTraits():remove("SlowHealer");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_SlowHealer"), false, HaloTextHelper.getColorGreen());
        end
        if player:HasTrait("ThickSkinned") and startingTraits.ThickSkinned ~= true then
            player:getTraits():remove("ThickSkinned");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_thickskinned"), false, HaloTextHelper.getColorRed());
        end
        if player:HasTrait("FastHealer") and startingTraits.FastHealer ~= true then
            player:getTraits():remove("FastHealer");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_FastHealer"), false, HaloTextHelper.getColorRed());
        end
        if player:HasTrait("LightEater") and startingTraits.LightEater ~= true then
            player:getTraits():remove("LightEater");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_lighteater"), false, HaloTextHelper.getColorRed());
        end
        if player:HasTrait("LowThirst") and startingTraits.LowThirst ~= true then
            player:getTraits():remove("LowThirst");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_LowThirst"), false, HaloTextHelper.getColorRed());
        end
    end
    if weight >= 75 and weight <= 85 then
        if player:HasTrait("HeartyAppitite") and startingTraits.HeartyAppetite ~= true then
            player:getTraits():remove("HeartyAppitite");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_heartyappetite"), false, HaloTextHelper.getColorGreen());
        end
        if player:HasTrait("HighThirst") and startingTraits.HighThirst ~= true then
            player:getTraits():remove("HighThirst");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_HighThirst"), false, HaloTextHelper.getColorGreen());
        end
        if stress <= 0.75 and unhappiness <= 75 then
            if not player:HasTrait("LightEater") then
                player:getTraits():add("LightEater");
                HaloTextHelper.addTextWithArrow(player, getText("UI_trait_lighteater"), true, HaloTextHelper.getColorGreen());
            end
            if not player:HasTrait("LowThirst") then
                player:getTraits():add("LowThirst");
                HaloTextHelper.addTextWithArrow(player, getText("UI_trait_LowThirst"), true, HaloTextHelper.getColorGreen());
            end
            local passiveLevels = player:getPerkLevel(Perks.Strength) + player:getPerkLevel(Perks.Fitness);
            if passiveLevels >= SBvars.WeightSystemSkill then
                if not player:HasTrait("ThickSkinned") then
                    player:getTraits():add("ThickSkinned");
                    HaloTextHelper.addTextWithArrow(player, getText("UI_trait_thickskinned"), true, HaloTextHelper.getColorGreen());
                end
                if not player:HasTrait("FastHealer") then
                    player:getTraits():add("FastHealer");
                    HaloTextHelper.addTextWithArrow(player, getText("UI_trait_FastHealer"), true, HaloTextHelper.getColorGreen());
                end
            end
        else
            if player:HasTrait("LightEater") and startingTraits.LightEater ~= true then
                player:getTraits():remove("LightEater");
                HaloTextHelper.addTextWithArrow(player, getText("UI_trait_lighteater"), false, HaloTextHelper.getColorRed());
            end
            if player:HasTrait("LowThirst") and startingTraits.LowThirst ~= true then
                player:getTraits():remove("LowThirst");
                HaloTextHelper.addTextWithArrow(player, getText("UI_trait_LowThirst"), false, HaloTextHelper.getColorRed());
            end
        end
    end
end

local function weightSystemAdvanced()
    local player = getPlayer();
    local startingTraits = player:getModData().DynamicTraitsWorld.StartingTraits;
    local modData = player:getModData().DynamicTraitsWorld.SleepSystem;
    local weight = player:getNutrition():getWeight();
    local stress = player:getStats():getStress();
    local unhappiness = player:getBodyDamage():getUnhappynessLevel();
    --print("stress: "..stress.." unhappiness:"..unhappiness); stress is 0-1, unhappiness is 0-100
    if weight >= 100 or weight <= 65 then
        if not player:HasTrait("SlowHealer") then
            player:getTraits():add("SlowHealer");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_SlowHealer"), true, HaloTextHelper.getColorRed());
        end
        if not player:HasTrait("Thinskinned") then
            player:getTraits():add("Thinskinned");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_ThinSkinned"), true, HaloTextHelper.getColorRed());
        end
    end
    if (weight > 85 and weight < 100) or (weight > 65 and weight < 75) then
        if not player:HasTrait("HeartyAppitite") then
            player:getTraits():add("HeartyAppitite");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_heartyappetite"), true, HaloTextHelper.getColorRed());
        end
        if not player:HasTrait("HighThirst") then
            player:getTraits():add("HighThirst");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_HighThirst"), true, HaloTextHelper.getColorRed());
        end
        if player:HasTrait("Thinskinned") and startingTraits.ThinSkinned ~= true then
            player:getTraits():remove("Thinskinned");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_ThinSkinned"), false, HaloTextHelper.getColorGreen());
        end
        if player:HasTrait("SlowHealer") and startingTraits.SlowHealer ~= true then
            player:getTraits():remove("SlowHealer");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_SlowHealer"), false, HaloTextHelper.getColorGreen());
        end
        if player:HasTrait("ThickSkinned") and startingTraits.ThickSkinned ~= true then
            player:getTraits():remove("ThickSkinned");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_thickskinned"), false, HaloTextHelper.getColorRed());
        end
        if player:HasTrait("FastHealer") and startingTraits.FastHealer ~= true then
            player:getTraits():remove("FastHealer");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_FastHealer"), false, HaloTextHelper.getColorRed());
        end
        if player:HasTrait("LightEater") and startingTraits.LightEater ~= true then
            player:getTraits():remove("LightEater");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_lighteater"), false, HaloTextHelper.getColorRed());
        end
        if player:HasTrait("LowThirst") and startingTraits.LowThirst ~= true then
            player:getTraits():remove("LowThirst");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_LowThirst"), false, HaloTextHelper.getColorRed());
        end
    end
    if weight >= 75 and weight <= 85 then
        if player:HasTrait("HeartyAppitite") and startingTraits.HeartyAppetite ~= true then
            player:getTraits():remove("HeartyAppitite");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_heartyappetite"), false, HaloTextHelper.getColorGreen());
        end
        if player:HasTrait("HighThirst") and startingTraits.HighThirst ~= true then
            player:getTraits():remove("HighThirst");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_HighThirst"), false, HaloTextHelper.getColorGreen());
        end
        if stress <= 0.75 and unhappiness <= 75 and modData.SleepHealthinessBar > 0 then
            if not player:HasTrait("LightEater") then
                player:getTraits():add("LightEater");
                HaloTextHelper.addTextWithArrow(player, getText("UI_trait_lighteater"), true, HaloTextHelper.getColorGreen());
            end
            if not player:HasTrait("LowThirst") then
                player:getTraits():add("LowThirst");
                HaloTextHelper.addTextWithArrow(player, getText("UI_trait_LowThirst"), true, HaloTextHelper.getColorGreen());
            end
            local passiveLevels = player:getPerkLevel(Perks.Strength) + player:getPerkLevel(Perks.Fitness);
            if passiveLevels >= SBvars.WeightSystemSkill then
                if not player:HasTrait("ThickSkinned") then
                    player:getTraits():add("ThickSkinned");
                    HaloTextHelper.addTextWithArrow(player, getText("UI_trait_thickskinned"), true, HaloTextHelper.getColorGreen());
                end
                if not player:HasTrait("FastHealer") then
                    player:getTraits():add("FastHealer");
                    HaloTextHelper.addTextWithArrow(player, getText("UI_trait_FastHealer"), true, HaloTextHelper.getColorGreen());
                end
            end
        else
            if player:HasTrait("LightEater") and startingTraits.LightEater ~= true then
                player:getTraits():remove("LightEater");
                HaloTextHelper.addTextWithArrow(player, getText("UI_trait_lighteater"), false, HaloTextHelper.getColorRed());
            end
            if player:HasTrait("LowThirst") and startingTraits.LowThirst ~= true then
                player:getTraits():remove("LowThirst");
                HaloTextHelper.addTextWithArrow(player, getText("UI_trait_LowThirst"), false, HaloTextHelper.getColorRed());
            end
        end
    end
end

local function initializeEvents(playerIndex, player)
    if SBvars.ColdIllnessSystem == true and not player:HasTrait("Resilient") then Events.EveryOneMinute.Add(coldTraits) end
    if SBvars.FoodSicknessSystem == true and not player:HasTrait("IronGut") then Events.EveryOneMinute.Add(foodSicknessTraits) end
    if SBvars.WeightSystem == true and SBvars.SleepSystem == true then Events.EveryTenMinutes.Add(weightSystemAdvanced) end
    if SBvars.WeightSystem == true and SBvars.SleepSystem == false then Events.EveryTenMinutes.Add(weightSystemBasic) end
end

Events.OnCreatePlayer.Add(initializeEvents);