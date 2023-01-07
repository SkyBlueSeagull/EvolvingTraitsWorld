require "ETWModData";

local SBvars = SandboxVars.EvolvingTraitsWorld;

function fearOfLocations()
    local player = getPlayer();
    local modData = player:getModData().EvolvingTraitsWorld;
    if player:HasTrait("Agoraphobic") and player:isOutside() then
        modData.LocationFearCounter = modData.LocationFearCounter + 1;
    end
    if player:HasTrait("Claustophobic") and not player:isOutside() then
        modData.LocationFearCounter = modData.LocationFearCounter + 1;
    end
    --print("ETW Logger: LocationFearCounter="..modData.LocationFearCounter);
    if modData.LocationFearCounter >= SBvars.FearOfLocationsSystemCounter then
        if player:HasTrait("Agoraphobic") then
            player:getTraits():remove("Agoraphobic");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_agoraphobic"), false, HaloTextHelper.getColorGreen());
        else
            player:getTraits():remove("Claustophobic");
            HaloTextHelper.addTextWithArrow(player, getText("UI_trait_claustro"), false, HaloTextHelper.getColorGreen());
        end
        Events.EveryOneMinute.Remove(fearOfLocations);
    end
end

local function initializeEvents(playerIndex, player)
    if SBvars.FearOfLocationsSystem == true and (player:HasTrait("Agoraphobic") or player:HasTrait("Claustophobic")) then Events.EveryOneMinute.Add(fearOfLocations) end
end

Events.OnCreatePlayer.Add(initializeEvents);