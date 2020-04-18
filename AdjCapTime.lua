--[[
Info.lua
AdjCapTime.lrplugin
Author:@jenoki48
]]
local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'
local LrDate = import 'LrDate'
local LrLogger = import 'LrLogger'
Logger = LrLogger('AdjCapTime')
Logger:enable('logfile')
local CurrentCatalog = LrApplication.activeCatalog()
local interval = 10

function getIPTCDateTime(time)
	return LrDate.timeToUserFormat(time,'%Y-%m-%dT%H:%M:%S',false)
end

LrTasks.startAsyncTask( function ()
	local TargetPhoto = CurrentCatalog:getTargetPhoto()
	local TargetTime = TargetPhoto:getRawMetadata('dateTimeOriginal')
	local IPTCDateTime = getIPTCDateTime(TargetTime)
	Logger:info('Origin='.. IPTCDateTime)
	
	local SelectedPhotos = CurrentCatalog:getTargetPhotos()

	CurrentCatalog:withWriteAccessDo('Set Capture Time',function()
		for i,PhotoIt in ipairs(SelectedPhotos) do
			if TargetPhoto.localIdentifier ~= PhotoIt.localIdentifier then
				IPTCDateTime = getIPTCDateTime(TargetTime)
				Logger:info(TargetTime ..'='.. IPTCDateTime)
				PhotoIt:setRawMetadata('dateCreated',IPTCDateTime)
			end
			TargetTime = TargetTime + interval
		end
	end )
end )
