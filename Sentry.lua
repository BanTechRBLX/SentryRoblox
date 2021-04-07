--[[
	For instructions on setting up your Sentry project, visit
	https://github.com/BanTechRBLX/SentryRoblox
]]

-- Services --
local HttpService = game:GetService( 'HttpService' )
local LogService = game:GetService( 'LogService' )
local RunService = game:GetService( 'RunService' )

-- Constants --
local RATE_LIMIT = 1 -- per second

-- In Sentry, under your project settings -> SDK Setup -> Client Keys (DSN) you'll find a URL like this:
-- https://sentryapikeyhere@o123456.ingest.sentry.io/1234567
-- The API URL is https://o123456.ingest.sentry.io/1234567
-- The API KEY is sentryapikeyhere
local SENTRY_API_URL = 'https://o123456.ingest.sentry.io/api/1234567' -- Replace with the specifics from your DSN URL from Sentry, without any trailing slash
local SENTRY_API_KEY = 'sentryapikeyhere'
local SENTRY_PROJECT_NAME = 'your-project'

local LOG_MESSAGE_TYPES = {
	[ Enum.MessageType.MessageOutput ] = false, -- Probably a good idea to leave false
	[ Enum.MessageType.MessageInfo ] = false, -- Probably a good idea to leave false
	[ Enum.MessageType.MessageWarning ] = 'warning', -- 'warning' or false; Depending on whether you want to record them or not
	[ Enum.MessageType.MessageError ] = 'error',
}

-- Variables --
local logConnection = nil
local lastErrorTime = 0
local lastErrorContent = ''

local gameVersion = game.PlaceVersion -- Set to whatever you use to record version

-- Functions --
local function isStaging()
	-- If you have more criteria to determine what is production vs staging (e.g. PlaceId check), edit this function
	return RunService:IsStudio()
end

local function submitLogEvent( errorMessage, errorType )
	local nowTime = os.time()
	if nowTime - lastErrorTime < 1 / RATE_LIMIT then
		-- Rate limit
		return
	end
	if errorMessage == lastErrorContent then
		return
	end
	local uuidV4 = HttpService:GenerateGUID( false ):gsub( '-', '' ):lower()
	local success, response = pcall( HttpService.RequestAsync, HttpService, {
		Url = SENTRY_API_URL .. '/store/',
		Method = 'POST',
		Headers = {
			['X-Sentry-Auth'] = 'Sentry sentry_version=7, sentry_timestamp=' .. tostring( nowTime ) .. ', sentry_key=' .. SENTRY_API_KEY,
			['Content-Type'] = 'application/json',
		},
		Body = HttpService:JSONEncode( {
			event_id = uuidV4,
			timestamp = nowTime,
			platform = 'other',
			level = errorType,
			server_name = game.JobId,
			release = SENTRY_PROJECT_NAME .. '@' .. tostring( gameVersion ),
			environment = isStaging() and 'staging' or 'production',
			message = errorMessage,
		} )
	} )
	lastErrorTime = nowTime
	lastErrorContent = errorMessage

	if not success then
		print( 'HTTP Request Error: ' .. response )
		return false, response
	elseif not response.Success then
		print( 'HTTP Request Rejected: ' .. response.Body )
		return false, response.StatusCode, response.Body
	else
		return true, response.StatusCode, response.Body
	end
end

-- Initialisation --
logConnection = LogService.MessageOut:Connect( function ( message, messageType )
	if LOG_MESSAGE_TYPES[ messageType ] then
		submitLogEvent( message, LOG_MESSAGE_TYPES[ messageType ] )
	end
end )

return {}
