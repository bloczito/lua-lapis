-- app.lua
local lapis = require("lapis")
local json_params = require("lapis.application").json_params

-- Define Category model
local Category = {}
Category.__index = Category

function Category.new(id, name)
  local self = setmetatable({}, Category)
  self.id = id
  self.name = name
  return self
end

local categories = {}

local newCategory = Category.new(#categories + 1, "A")
categories[newCategory.id] = newCategory

local newCategory = Category.new(#categories + 1, "B")
categories[newCategory.id] = newCategory

local newCategory = Category.new(#categories + 1, "C")
categories[newCategory.id] = newCategory


-- Define Lapis application
local app = lapis.Application()

-- Category endpoints
app:post("/categories", json_params(function(self)
  local category = Category.new(#categories + 1, self.params.name)
  categories[category.id] = category
  return { status = 201, json = categories  }
end))

app:get("/categories", function()
  return { status = 200, json = categories }
end)






-- Start the Lapis server
return app
