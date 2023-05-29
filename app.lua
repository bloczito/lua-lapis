local lapis = require("lapis")
local app = lapis.Application()


local Category = {}
Category.__index

function Category.new(id, name)
  local self = setmetatable({}, Category)
  self.id = id
  self.name = name
  return self
end

app:get("/", function()
  local category = Category.new(1, "Test")

  return { status = 201, json = { category } }
end)

return app
