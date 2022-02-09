---
sidebar_position: 2
---

# Usage

Begin by requiring the module.

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Packages.Remotes)
```

The Remotes module does not have a constructor - it behaves like a service once required. This enables middleware functionality that affects every remote in the game.

## Getting a Remote

Depending on the desired remote type, call `getEventAsync` or `getFunctionAsync`.

```lua
local myRemoteEvent = Remotes:getEventAsync("MyRemoteEvent")
local myRemoteFunction = Remotes:getFunctionAsync("MyRemoteFunction")
```

If these functions are called on the server, they will create a remote instance if one does not exist. If they are called on the client, they will yield until one is created by the server. If a remote is gotten by the client but not the server, the client will yield forever.

## Adding Middleware

Middleware are functions that run on the server when an invocation is received from the client, but before the invocation is forwarded to the connected function(s). This allows the middleware to mutate the client arguments or drop the call entirely. This enables features such as analytics and exploit detection.

```lua
local function myMiddleware(arguments, metadata)
	local player = arguments[1] --1st argument is always a player
	if metadata.remoteName == "BuyItems" then
		if arguments[2] > 10 then
			-- player shouldn't be able to buy more than 10 items at once
			return true
		end
	end
	return false, arguments
end

Remotes:registerMiddleware(myMiddleware)
```
