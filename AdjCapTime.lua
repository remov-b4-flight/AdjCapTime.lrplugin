--[[
Info.lua
AdjCapTime.lrplugin
Author:@jenoki48
]]
local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'
local LrDate = import 'LrDate'
local LrLogger = import 'LrLogger'
AJLogger = LrLogger('AdjCapTime')
AJLogger:enable('logfile')
local CurrentCatalog = LrApplication.activeCatalog()
local interval = 10

LrTasks.startAsyncTask( function ()
	local TargetPhoto = CurrentCatalog:getTargetPhoto()
	local TargetTime = TargetPhoto:getRawMetadata('dateTime')
	
	local SelectedPhotos = CurrentCatalog:getTargetPhotos()

	CurrentCatalog:withWriteAccessDo('Set Capture Time',function()
		for i,PhotoIt in ipairs(SelectedPhotos) do
			AJLogger:info(TargetTime)
			if TargetPhoto.localIdentifier ~= PhotoIt.localIdentifier then
				IPTCDateTime = LrDate.timeToUserFormat(TargetTime,'%Y-%m-%dT%H:%M:%S',false)
				PhotoIt:setRawMetadata('dateCreated',IPTCDateTime)
			end
			TargetTime = TargetTime + interval
		end
	end )
end )
