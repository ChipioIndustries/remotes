--[[
	Remotes.new({
		scope = "myScope";
	})
	Remotes:getAll()
	Remotes:getEventAsync(name)
	Remotes:getFunctionAsync(name)
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local DefaultConfig = require(script.DefaultConfig)
local DummyRemoteEvent = require(script.DummyRemoteEvent)
local DummyRemoteFunction = require(script.DummyRemoteFunction)

local packages = script.Packages
local Llama = require(packages.Llama)
local Rapscallion = require(packages.Rapscallion).new()

local SCOPE_FOLDER_PREFIX = "REMOTES_"

local function getRouteAsync(origin, route)
	if RunService:IsServer() then
		return Rapscallion:buildRoute(origin, route)
	elseif RunService:IsClient() then
		return Rapscallion:waitForRoute(origin, route)
	end
end

local Remotes = {}
Remotes.__index = Remotes

function Remotes.new(config: DefaultConfig.Config?)
	config = Llama.Dictionary.join(DefaultConfig, config or {})

	assert(typeof(config.scope) == "string", "scope must be a string")

	local scopeFolder = getRouteAsync(ReplicatedStorage, SCOPE_FOLDER_PREFIX .. config.scope)

	local self = {
		_config = config;
		_eventFolder = getRouteAsync(scopeFolder, "Events");
		_functionFolder = getRouteAsync(scopeFolder, "Functions");
		_middleware = {};
		_dummyCache = {
			-- [Instance] = Dummy.new()
		};
	}

	setmetatable(self, Remotes)

	table.freeze(self)
	table.freeze(config)

	return self
end

function Remotes:_getRemoteAsync(name: string, className: string, folder: Instance)
	local remote = folder:FindFirstChild(name)

	if not remote then
		remote = Instance.new(className)
		remote.Name = name
		remote.Parent = folder
	end

	return remote
end

function Remotes:getAll()
	local result = {
		events = {};
		functions = {};
	}

	for _, event in pairs(self._eventFolder) do
		result.events[event.Name] = event
	end

	for _, func in pairs(self._functionFolder) do
		result.events[func.Name] = func
	end

	return result
end

function Remotes:getEventAsync(name: string)
	return self:_getRemoteAsync(name, "RemoteEvent", self._eventFolder)
end

function Remotes:getFunctionAsync(name: string)
	return self:_getRemoteAsync(name, "RemoteFunction", self._functionFolder)
end

function Remotes:registerServerMiddleware(middleware)
	assert(RunService:IsServer(), "attempt to register server middleware on client")
	table.insert(self._middleware, middleware)
end

return Remotes