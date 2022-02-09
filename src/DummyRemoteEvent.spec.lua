return function()
	describe("DummyRemoteEvent.lua", function()
		local DummyRemoteEvent = require(script.Parent.DummyRemoteEvent)

		it("should pass through identical arguments", function()
			local args = {
				{};
				5234;
				"test123";
			}

			local checkCount = 0

			local function checkArgs(...)
				local resultArgs = {...}

				for index, arg in ipairs(resultArgs) do
					expect(arg).to.equal(args[index])
				end

				checkCount += 1
			end

			local event = DummyRemoteEvent.new()

			event.OnServerEvent:connect(checkArgs)
			event._onClientEvent:connect(checkArgs)
			event._onAllClientEvent:connect(checkArgs)

			event:FireAllClients(unpack(args))
			event:FireClient(unpack(args))
			event:_fireServer(unpack(args))

			expect(checkCount).to.equal(3)
		end)
	end)
end