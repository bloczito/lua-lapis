-- app.lua
local lapis = require "lapis"
local json_params = require "lapis.application".json_params

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

-- Define Product model
local Product = {}
Product.__index = Product

function Product.new(id, name, categoryId)
  local self = setmetatable({}, Product)
  self.id = id
  self.name = name
  self.categoryId = categoryId
  return self
end

local products = {}

-- Define Lapis application
local app = lapis.Application()

-- Category endpoints
app:post("/categories", json_params({ name = "string" }), function(self)
  local category = Category.new(#categories + 1, self.params.name)
  categories[category.id] = category
  return { status = 201, json = { category } }
end)

app:get("/categories", function()
  return { status = 200, json = categories }
end)

app:get("/categories/:id", function(self)
  local category = categories[tonumber(self.params.id)]
  if category then
    return { status = 200, json = { category } }
  else
    return { status = 404, json = { message = "Category not found" } }
  end
end)

app:put("/categories/:id", json_params({ name = "string" }), function(self)
  local category = categories[tonumber(self.params.id)]
  if category then
    category.name = self.params.name
    return { status = 200, json = { category } }
  else
    return { status = 404, json = { message = "Category not found" } }
  end
end)

app:delete("/categories/:id", function(self)
  local category = categories[tonumber(self.params.id)]
  if category then
    categories[tonumber(self.params.id)] = nil
    return { status = 204 }
  else
    return { status = 404, json = { message = "Category not found" } }
  end
end)

-- Product endpoints
app:post("/products", json_params({ name = "string", categoryId = "number" }), function(self)
  local category = categories[self.params.categoryId]
  if category then
    local product = Product.new(#products + 1, self.params.name, self.params.categoryId)
    products[product.id] = product
    return { status = 201, json = { product } }
  else
    return { status = 404, json = { message = "Category not found" } }
  end
end)

app:get("/products", function()
  return { status = 200, json = products }
end)

app:get("/products/:id", function(self)
  local product = products[tonumber(self.params.id)]
  if product then
    return { status = 200, json = { product } }
  else
    return { status = 404, json = { message = "Product not found" } }
  end
end)

app:put("/products/:id", json_params({ name = "string", categoryId = "number" }), function(self)
  local product = products[tonumber(self.params.id)]
  if product then
    local category = categories[self.params.categoryId]
    if category then
      product.name = self.params.name
      product.categoryId = self.params.categoryId
      return { status = 200, json = { product } }
    else
      return { status = 404, json = { message = "Category not found" } }
    end
  else
    return { status = 404, json = { message = "Product not found" } }
  end
end)

app:delete("/products/:id", function(self)
  local product = products[tonumber(self.params.id)]
  if product then
    products[tonumber(self.params.id)] = nil
    return { status = 204 }
  else
    return { status = 404, json = { message = "Product not found" } }
  end
end)

-- Start the Lapis server
app:run()
