EvolvingTraitsWorld = EvolvingTraitsWorld or {};
EvolvingTraitsWorld.settings = EvolvingTraitsWorld.SETTINGS or {};

EvolvingTraitsWorld.settings.ScavengerLootIndicator = true;
EvolvingTraitsWorld.settings.ScavengerExpIndicator = true;

if ModOptions and ModOptions.getInstance then
    local function onModOptionsApply(optionValues)
        EvolvingTraitsWorld.settings.EnableBloodLustMoodle = optionValues.settings.options.EnableBloodLustMoodle;
    end
    local SETTINGS = {
        options_data = {
            EnableBloodLustMoodle = {
                name = "UI_EvolvingTraitsWorld_Options_EnableBloodLustMoodle",
                tooltip = "UI_EvolvingTraitsWorld_Options_EnableBloodLustMoodle_tooltip",
                default = true,
                OnApplyMainMenu = onModOptionsApply,
                OnApplyInGame = onModOptionsApply,
            },
        },
        mod_id = 'EvolvingTraitsWorld',
        mod_shortname = 'Evolving Traits World',
        mod_fullname = 'Evolving Traits World',
    }
    ModOptions:getInstance(SETTINGS)
    ModOptions:loadFile()

    Events.OnPreMapLoad.Add(function()
        onModOptionsApply({ settings = SETTINGS })
    end)
end