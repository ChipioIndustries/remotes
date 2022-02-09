---
sidebar_position: 1
---

# Remotes

Remotes is a library for creating middlewared remotes.

## Functions

|Return Type|Signature|Description|
|-|-|-|
|Dictionary|[`getAll()`](#getall)|Get a dictionary of all created remotes.|
|RemoteEvent|[`getEventAsync(string remoteName)`](#geteventasync)|Get a remote event by the given name.|
|RemoteFunction|[`getFunctionAsync(string remoteName)`](#getfunctionasync)|Get a remote function by the given name.|
|void|[`registerMiddleware(function middleware)`](#registerMiddleware)|Add the given function to the middleware list.|

## getAll

Returns all remotes.

```lua
local allRemotes = Remotes:getAll()

print(allRemotes)
--[[
	{
		events = {
			["RemoteName"] = DummyRemote;
		};
		functions = {
			["RemoteName"] = DummyRemote;
		}
	}
]]
```

## getEventAsync

Returns a remote event. On the server, this returns a `DummyRemoteEvent` which behaves as a standard RemoteEvent. On the client, this returns an actual RemoteEvent instance.

```lua
local myRemote = Remotes:getEventAsync("MyRemote")

myRemote:FireAllClients("Yeehaw")
```

### Parameters

|Type|Name|Default|Description|
|-|-|-|-|
|string|remoteName||The name of the given remote.|

## getFunctionAsync

Returns a remote function. On the server, this returns a `DummyRemoteFunction` which behaves as a standard RemoteFunction. On the client, this returns an actual RemoteFunction instance.

```lua
local myRemote = Remotes:getFunctionAsync("MyRemote")

local info = myRemote:InvokeServer()
```

### Parameters

|Type|Name|Default|Description|
|-|-|-|-|
|string|remoteName||The name of the given remote.|

## registerMiddleware

Adds the given function to the middleware suite. Middleware are functions executed when the client invokes the server but before the server responds.

A middleware function receives the table of arguments being sent by the client (including the player the call came from) and a table of metadata with info about the remote itself.

```lua
local metadata = {
	remoteName = "myRemote";
	remoteClass = "RemoteFunction";
}
```

Each middleware should return a boolean indicating if the call should be dropped, and the arguments to send to the next middleware function or the server call.

```lua
local function middleware(arguments, metadata)
	arguments[2] = "yeehaw"
	print(arguments[1]) -- Player
	print(metadata.remoteName)
	print(metadata.remoteClass)
	return false, arguments --don't drop the call, and send the modified arguments
end

Remotes:registerMiddleware(middleware)
```

### Parameters

|Type|Name|Default|Description|
|-|-|-|-|
|function|middleware||The function to add as middleware.|
