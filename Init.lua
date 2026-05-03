---@type string, Essences
local addonName, Private = ...

Private.L = {}

Private.EventRegistry = CreateFromMixins(CallbackRegistryMixin)
Private.EventRegistry:OnLoad()
Private.EventRegistry:GenerateCallbackEvents({ Private.Enum.Events.SETTING_CHANGED })

Private.LoginFnQueue = {}

EventUtil.ContinueOnAddOnLoaded(addonName, function()
	-- only Evokers, see classID here: https://wago.tools/db2/ChrSpecialization
	if select(3, UnitClass("player")) ~= 13 then
		return
	end

	---@type EssencesSaved
	EssencesSaved = EssencesSaved or {}
	EssencesSaved.Settings = EssencesSaved.Settings or {}

	if EssencesSaved.Settings.AnchorMode == nil and EssencesSaved.Settings.AnchorToScreenCenter ~= nil then
		EssencesSaved.Settings.AnchorMode = EssencesSaved.Settings.AnchorToScreenCenter
			and Private.Enum.AnchorMode.FreePosition
			or Private.Enum.AnchorMode.CooldownViewer
	end

	local defaults = Private.Settings.GetDefaultSettings()

	for key, value in pairs(defaults) do
		if EssencesSaved.Settings[key] == nil then
			EssencesSaved.Settings[key] = value
		end
	end

	for i = 1, #Private.LoginFnQueue do
		Private.LoginFnQueue[i]()
	end

	table.wipe(Private.LoginFnQueue)
end)
