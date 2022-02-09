local DummyRemoteFunction = {}
DummyRemoteFunction.__index = DummyRemoteFunction

function DummyRemoteFunction.new()
	local self = {
		_onClientInvoke = nil;
		OnServerInvoke = nil;
	}

	setmetatable(self, DummyRemoteFunction)

	return self
end

function DummyRemoteFunction:_invokeServer(...)
	return self.OnServerInvoke(...)
end

function DummyRemoteFunction:InvokeClient(...)
	return self._onClientInvoke(...)
end

return DummyRemoteFunction