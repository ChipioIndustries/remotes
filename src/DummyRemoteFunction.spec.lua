return function()
	describe("DummyRemoteFunction.lua", function()
		local DummyRemoteFunction = require(script.Parent.DummyRemoteFunction)

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

				return resultArgs
			end

			local func = DummyRemoteFunction.new()

			func.OnServerInvoke = checkArgs
			func._onClientInvoke = checkArgs

			local result1 = func:_invokeServer(unpack(args))
			local result2 = func:InvokeClient(unpack(args))

			checkArgs(unpack(result1))
			checkArgs(unpack(result2))

			expect(checkCount).to.equal(4)
		end)
	end)
end