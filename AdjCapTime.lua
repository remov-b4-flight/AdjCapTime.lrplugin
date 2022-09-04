--[[
AdjCapTime.lua
AdjCapTime.lrplugin
Author:@jenoki48
]]
local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'
local LrDate = import 'LrDate'
local LrDialog = import 'LrDialogs'
local LrProgress = import 'LrProgressScope'
local LrLogger = import 'LrLogger'
Logger = LrLogger('AdjCapTime')
Logger:enable('logfile')

local CurrentCatalog = LrApplication.activeCatalog()
local interval = 10
local TagHead = 'sh exiftool'
local TagDateOpt = ' -allDates='
local TagCapOpt = ' -Caption-Abstruct='

function getIPTCDateTime(time)
	return LrDate.timeToUserFormat(time,'%Y-%m-%dT%H:%M:%S',false)
end

function getExifToolDateTime(time)
	return LrDate.timeToUserFormat(time,'%Y:%m:%d %H:%M:%S',false)
end

LrTasks.startAsyncTask( function ()
	local TargetPhoto = CurrentCatalog:getTargetPhoto()
	local SelectedPhotos = CurrentCatalog:getTargetPhotos()
	local countPhotos = #SelectedPhotos
	if (countPhotos == 0) then 
		return 
	end

	local TargetTime = TargetPhoto:getRawMetadata('dateTimeOriginal')
	if (TargetTime == nil) then 
		TargetTime = TargetPhoto:getRawMetadata('dateTime')
		if (TargetTime == nil) then 
			LrDialog:message('Can\'t get target date/time.\nSet target date/time.')
			return
		end
	end

	local OriginDateTime = getExifToolDateTime(TargetTime)
	local ProgressBar = LrProgress(
		{title = 'Adjusting Times...'}
	)
	Logger:info('Origin='.. OriginDateTime)

	CurrentCatalog:withWriteAccessDo('Set Capture Time',function()
		for i,PhotoIt in ipairs(SelectedPhotos) do
			if TargetPhoto.localIdentifier ~= PhotoIt.localIdentifier then
				local FilePath = PhotoIt:getRawMetadata('path')
				local DateTime = getExifToolDateTime(TargetTime)
				local caption = PhotoIt:getFormattedMetadata('caption')
				local CommandLine = TagHead .. TagCapOpt ..'\"'.. caption ..'\"'.. TagDateOpt ..'\"'.. DateTime ..'\" '.. FilePath
				Logger:info(CommandLine)
				LrTasks.execute(CommandLine)
			end
			TargetTime = TargetTime + interval
			ProgressBar:setPortionComplete(i,countPhotos)
		end
		ProgressBar:done()
	end )
end )
