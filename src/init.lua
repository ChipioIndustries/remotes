--[[
	Remotes.new({
		scope = "myScope";
	})
	Remotes:getAll()
	Remotes:getEventAsync(name)
	Remotes:getFunctionAsync(name)
	Remotes:registerMiddleware((table args, dictionary metadata) > (bool dropCall, table mutatedArgs))
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local DefaultConfig = require(script.DefaultConfig)
local DummyRemoteEvent = require(script.DummyRemoteEvent)
local DummyRemoteFunction = require(script.DummyRemoteFunction)

local Llama = require(script.Parent.Llama)
local Rapscallion = require(script.Parent.Rapscallion).new()

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

function Remotes:_executeMiddleware(args, metadata)
	local dropCall = false
	for _, middleware in ipairs(self._middleware) do
		local shouldDropCall, mutatedArgs = middleware(args, metadata)
		if shouldDropCall then -- drop call
			dropCall = true
		end
		args = mutatedArgs or args
	end

	return dropCall, args
end

function Remotes:_getRemoteAsync(name: string, className: string, folder: Instance, _isClientOverride: boolean?)
	local remote = folder:FindFirstChild(name)
	local created = false

	if not remote then
		if (not _isClientOverride) and RunService:IsServer() then
			remote = Instance.new(className)
			remote.Name = name
			remote.Parent = folder
			created = true
		else
			return folder:WaitForChild(name, false)
		end
	end

	return remote, created
end

function Remotes:getAll()
	local result = {
		events = {};
		functions = {};
	}

	for _, event in pairs(self._eventFolder:GetChildren()) do
		result.events[event.Name] = self._dummyCache[event]
	end

	for _, func in pairs(self._functionFolder:GetChildren()) do
		result.functions[func.Name] = self._dummyCache[func]
	end

	return result
end

function Remotes:getEventAsync(name: string)
	local remote, created = self:_getRemoteAsync(name, "RemoteEvent", self._eventFolder)
	if RunService:IsServer() then
		local dummyRemote = self._dummyCache[remote]

		if not dummyRemote then
			if created then
				dummyRemote = DummyRemoteEvent.new()

				dummyRemote._onAllClientEvent:connect(function(...)
					remote:FireAllClients(...)
				end)

				dummyRemote._onClientEvent:connect(function(...)
					remote:FireClient(...)
				end)

				remote.OnServerEvent:connect(function(...)
					local metadata = {
						remoteName = name;
						remoteClass = "RemoteEvent";
					}

					local dropCall, args = self:_executeMiddleware({...}, metadata)

					if not dropCall then
						remote:_fireServer(unpack(args))
					end
				end)

				self._dummyCache[remote] = dummyRemote
			else
				error(("Remote %s is managed by another Remotes instance"):format(name))
			end
		end

		return dummyRemote
	else
		return remote
	end
end

function Remotes:getFunctionAsync(name: string)
	local remote, created = self:_getRemoteAsync(name, "RemoteFunction", self._functionFolder)
	if RunService:IsServer() then
		local dummyRemote = self._dummyCache[remote]

		if not dummyRemote then
			if created then
				dummyRemote = DummyRemoteFunction.new()

				dummyRemote._onClientInvoke = function(...)
					return remote:InvokeClient(...)
				end

				remote.OnServerInvoke = function(...)
					local metadata = {
						remoteName = name;
						remoteClass = "RemoteFunction";
					}

					local dropCall, args = self:_executeMiddleware({...}, metadata)

					if not dropCall then
						return remote:_invokeServer(unpack(args))
					end

					return nil
				end

				self._dummyCache[remote] = dummyRemote
			else
				error(("Remote %s is managed by another Remotes instance"):format(name))
			end
		end

		return dummyRemote
	else
		return remote
	end
end

function Remotes:registerMiddleware(middleware)
	assert(RunService:IsServer(), "attempt to register server middleware on client")
	assert(typeof(middleware) == "function", "middleware is not a valid function")
	table.insert(self._middleware, middleware)
end

return Remotes.new()