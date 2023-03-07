---
sidebar_position: 1
---

# Remotes

Remotes is a library for creating remotes.

## Functions

|Return Type|Signature|Description|
|-|-|-|
|Dictionary|[`getAll()`](#getall)|Get a dictionary of all created remotes.|
|RemoteEvent|[`getEventAsync(string remoteName)`](#geteventasync)|Get a remote event by the given name.|
|RemoteFunction|[`getFunctionAsync(string remoteName)`](#getfunctionasync)|Get a remote function by the given name.|

## getAll

Returns all remotes.

```lua
local allRemotes = Remotes:getAll()

print(allRemotes)
--[[
	{
		events = {
			["RemoteName"] = Remote;
		};
		functions = {
			["RemoteName"] = Remote;
		}
	}
]]
```

## getEventAsync

Returns a remote event.

```lua
local myRemote = Remotes:getEventAsync("MyRemote")

myRemote:FireAllClients("Yeehaw")
```

### Parameters

|Type|Name|Default|Description|
|-|-|-|-|
|string|remoteName||The name of the given remote.|

## getFunctionAsync

Returns a remote function.

```lua
local myRemote = Remotes:getFunctionAsync("MyRemote")

local info = myRemote:InvokeServer()
```

### Parameters

|Type|Name|Default|Description|
|-|-|-|-|
|string|remoteName||The name of the given remote.|
