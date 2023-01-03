DynamicTraitsWorld = DynamicTraitsWorld or {};
DynamicTraitsWorld.settings = DynamicTraitsWorld.SETTINGS or {};

DynamicTraitsWorld.settings.ScavengerLootIndicator = true;
DynamicTraitsWorld.settings.ScavengerExpIndicator = true;

if ModOptions and ModOptions.getInstance then
    local function onModOptionsApply(optionValues)
        DynamicTraitsWorld.settings.EnableBloodLustMoodle = optionValues.settings.options.EnableBloodLustMoodle;
    end
    local SETTINGS = {
        options_data = {
            EnableBloodLustMoodle = {
                name = "UI_DynamicTraitsWorld_Options_EnableBloodLustMoodle",
                tooltip = "UI_DynamicTraitsWorld_Options_EnableBloodLustMoodle_tooltip",
                default = true,
                OnApplyMainMenu = onModOptionsApply,
                OnApplyInGame = onModOptionsApply,
            },
        },
        mod_id = 'DynamicTraitsWorld',
        mod_shortname = 'Dynamic Traits World',
        mod_fullname = 'Dynamic Traits World',
    }
    ModOptions:getInstance(SETTINGS)
    ModOptions:loadFile()

    Events.OnPreMapLoad.Add(function()
        onModOptionsApply({ settings = SETTINGS })
    end)
end