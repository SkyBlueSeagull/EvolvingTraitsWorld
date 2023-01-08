ETWMoodles = {};
require "MF_ISMoodle";

local SBvars = SandboxVars.EvolvingTraitsWorld;

MF.createMoodle("BloodlustMoodle");
MF.createMoodle("SleepHealthMoodle");

function ETWMoodles.bloodlustMoodleUpdate(player, hide) -- confirmed working
    local moodle = MF.getMoodle("BloodlustMoodle");
    local modData = player:getModData().EvolvingTraitsWorld.BloodlustSystem;
    local timeSinceLastKill = player:getHoursSurvived() - modData.LastKillTimestamp;
    moodle:setThresholds(0.1, 0.2, 0.35, 0.4999, 0.5001, 0.65, 0.8, 0.9);
    if player == getPlayer() and EvolvingTraitsWorld.settings.EnableBloodLustMoodle == true and hide == false and timeSinceLastKill <= SBvars.BloodlustMoodleVisibilityHours then
        local percentage = modData.BloodlustMeter / 36;
        local displayedPercentage = string.format("%.1f",percentage * 100);
        moodle:setValue(percentage);
        moodle:setDescription(moodle:getGoodBadNeutral(),moodle:getLevel(), getText("Moodles_BloodlustMoodle_Custom",displayedPercentage));
    else
        moodle:setValue(0.5);
    end
end

function ETWMoodles.sleepHealthMoodleUpdate(player, hide)
    local moodle = MF.getMoodle("SleepHealthMoodle");
    moodle:setThresholds(-0.0001, nil, nil, nil, nil, nil, nil, 0.0001);
    if player == getPlayer() and EvolvingTraitsWorld.settings.EnableSleepHealthMoodle == true and hide == false then
        moodle:setValue(player:getModData().EvolvingTraitsWorld.SleepSystem.SleepHealthinessBar);
    else
        moodle:setValue(0);
    end
end

return ETWMoodles;