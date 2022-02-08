local Signal = require(script.Parent.Packages.Signal)

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

function DummyRemoteFunction:_invokeServer()

end

function DummyRemoteFunction:InvokeClient()

end

return DummyRemoteFunction