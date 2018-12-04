--[[
Info.lua
AdjCapTime.lrplugin
Author:@jenoki48
]]

return {

	LrSdkVersion = 3.0,

	LrToolkitIdentifier = 'nu.mine.ruffles.adjcaptime',
	LrPluginName = 'AdjCapTime',
	LrPluginInfoUrl='https://twitter.com/remov_b4_flight',
	LrLibraryMenuItems = { 
		{title = 'AdjCapTime',
		file = 'AdjCapTime.lua',
		enabledWhen = 'photosAvailable',},
	},
	VERSION = { major=0, minor=1, revision=0, build=0, },

}
