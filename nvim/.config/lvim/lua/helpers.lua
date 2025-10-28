return {
	---@param alt any
	---@param getter function
	---@param setter function
	---@return function
	toggler = function(alt, getter, setter)
		local buf = alt
		return function()
			local cur = getter()
			setter(buf)
			buf = cur
		end
	end,

	---@param ... any
	---@return any
	dump = function(...)
		local objects = {}
		for i = 1, select('#', ...) do
			local v = select(i, ...)
			table.insert(objects, vim.inspect(v))
		end

		print(table.concat(objects, '\n'))
		return ...
	end
}
