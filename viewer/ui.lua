local self = {}

self.show_menu = true
self.input_mode = false

local function draw_selection_list()
  for idx, item in ipairs(Files.filtered) do
    if idx == Files.selected_idx then
      love.graphics.setColor(1,0,0)
      love.graphics.print(item, 100, 40+20*(idx-1), 0, 2, 2)
      love.graphics.setColor(1,1,1)
    else
      love.graphics.print(item, 100, 40+20*(idx-1), 0, 2, 2)
    end
  end
  DBG.print(Files.selected_idx)
end

local function draw_loaded_list()
  local tbl = Files.loaded
  for _, item in ipairs(tbl) do
    love.graphics.print(item.name, 400, 40, 0, 2, 2)
  end
end

local function draw_loaded_images()
  local transf = love.math.newTransform(1, 1, 0, 5, 5)
  for _, image in ipairs(Files.loaded) do
    love.graphics.draw(image.data, transf)
  end
end

local function draw_input()
  love.graphics.print(Text.user_input, 200, 200, 0, 3, 3)
end

self.draw = function()
  draw_loaded_images()
  if self.show_menu then
    draw_selection_list()
    draw_loaded_list()
  end
  if self.input_mode then
    draw_input()
  end
end

return self
