---
sidebar_position: 2
---

# Usage

Begin by requiring the module.

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Packages.Remotes)
```

The Remotes module does not have a constructor - it behaves like a service once required.

## Getting a Remote

Depending on the desired remote type, call `getEventAsync` or `getFunctionAsync`.

```lua
local myRemoteEvent = Remotes:getEventAsync("MyRemoteEvent")
local myRemoteFunction = Remotes:getFunctionAsync("MyRemoteFunction")
```

If these functions are called on the server, they will create a remote instance if one does not exist. If they are called on the client, they will yield until one is created by the server. If a remote is gotten by the client but not the server, the client will yield forever.
