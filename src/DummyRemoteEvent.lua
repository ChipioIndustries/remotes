local Signal = require(script.Parent.Parent.Signal)

local DummyRemoteEvent = {}
DummyRemoteEvent.__index = DummyRemoteEvent

function DummyRemoteEvent.new()
	local self = {
		_onAllClientEvent = Signal.new();
		_onClientEvent = Signal.new();
		OnServerEvent = Signal.new();
	}

	setmetatable(self, DummyRemoteEvent)

	table.freeze(self)

	return self
end

function DummyRemoteEvent:FireAllClients(...)
	self._onAllClientEvent:fire(...)
end

function DummyRemoteEvent:FireClient(...)
	self._onClientEvent:fire(...)
end

function DummyRemoteEvent:_fireServer(...)
	self.OnServerEvent:fire(...)
end

return DummyRemoteEvent