return function()
	describe("Remotes.lua", function()
		local args = {
			{},
			5143,
			"Yeehaw"
		}

		table.freeze(args)

		local Remotes = require(script.Parent)
		local Llama = require(script.Parent.Parent.Llama)

		it("should create remote folders", function()
			expect(Remotes._eventFolder).to.be.ok()
			expect(Remotes._functionFolder).to.be.ok()
			expect(Remotes._eventFolder:IsA("Folder")).to.equal(true)
			expect(Remotes._functionFolder:IsA("Folder")).to.equal(true)
		end)

		it("should be frozen", function()
			expect(function()
				Remotes.test = 5
			end).to.throw()

			expect(function()
				Remotes._config.scope = "sdfogjnsdj"
			end).to.throw()
		end)

		describe("_getRemoteAsync", function()
			it("should make remote on server", function()
				local hasYielded = false
				task.defer(function()
					hasYielded = true
				end)
				local remote = Remotes:_getRemoteAsync("myRemote1", "RemoteEvent", Remotes._eventFolder)
				expect(hasYielded).to.equal(false)
				expect(remote).to.be.a("userdata")
				expect(remote:IsA("RemoteEvent")).to.equal(true)
			end)
		end)

		describe("_executeMiddleware", function()
			it("should work with no middleware", function()
				local metadata = {
					remoteName = "remotename";
					remoteClass = "RemoteFunction";
				}
				local dropCall, resultArgs = Remotes:_executeMiddleware(args, metadata)

				expect(dropCall).to.equal(false)
				expect(resultArgs).to.be.a("table")

				for index, arg in ipairs(resultArgs) do
					expect(arg).to.equal(args[index])
				end
			end)

			it("should work with multiple middlewares", function()
				local metadata1 = {
					remoteName = "dropCall";
					remoteClass = "RemoteFunction";
				}

				local metadata2 = {
					remoteName = "mutateArguments";
					remoteClass = "RemoteFunction";
				}

				local function middleware1(arguments, metadata)
					if metadata.remoteName == "dropCall" then
						return true, arguments
					end
					return false, arguments
				end

				local function middleware2(arguments, metadata)
					if metadata.remoteName == "mutateArguments" then
						return false, Llama.List.push(arguments, "Hello")
					end
					return false, arguments
				end

				Remotes:registerMiddleware(middleware1)
				Remotes:registerMiddleware(middleware2)

				local dropCall, resultArgs = Remotes:_executeMiddleware(args, metadata1)

				expect(dropCall).to.equal(true)

				for index, value in ipairs(resultArgs) do
					expect(args[index]).to.equal(value)
				end

				local dropCall2, resultArgs2 = Remotes:_executeMiddleware(args, metadata2)

				expect(dropCall2).to.equal(false)

				for index = 1, 3 do
					expect(args[index]).to.equal(resultArgs2[index])
				end

				expect(resultArgs2[4]).to.equal("Hello")
			end)

			it("should return dummy on server", function()
				local event = Remotes:getEventAsync("Yeehaw1")
				local func = Remotes:getFunctionAsync("Yeehaw2")

				expect(event).to.be.a("table")
				expect(func).to.be.a("table")
			end)
		end)
	end)
end