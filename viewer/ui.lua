local self = {}

self.state = {}
self.state.show_menu = true
self.state.input_mode = false

self.alpha_override = 1

local function draw_selection_list()
  for idx, item in ipairs(Files.filtered) do
    if idx == Files.selected_idx then
      love.graphics.setColor(1, 0, 0,  self.alpha_override)
      love.graphics.print(item, 100, 40+20*(idx-1), 0, 2, 2)
      love.graphics.setColor(1, 1, 1,  self.alpha_override)
    else
      love.graphics.print(item, 100, 40+20*(idx-1), 0, 2, 2)
    end
  end
  -- DBG.print(Files.selected_idx)
end

local function draw_loaded_list()
  love.graphics.setColor(1, 1, 1, self.alpha_override)
  local tbl = Files.loaded
  for _, item in ipairs(tbl) do
    love.graphics.print(item.name, 400, 40, 0, 2, 2)
  end
  love.graphics.setColor(1, 1, 1)
end

local function draw_loaded_images()
  love.graphics.setColor(1, 1, 1)

  local image = Files.loaded[1]
  local tile_w, tile_h, _ = Text.parse_metadata_input(image.meta)
  local quad = love.graphics.newQuad(
      Player.frame.x,
      Player.frame.y,
      tile_w,
      tile_h,
      image.data
    )

  local screen_w, screen_h = love.graphics.getDimensions()
  local transf = love.math.newTransform(screen_w/2, screen_h/2, 0, 10, 10)
  love.graphics.draw(image.data, quad, transf)

  love.graphics.setColor(1, 1, 1, self.alpha_override)
end

local function draw_input()
  love.graphics.setColor(1, 1, 1)
  love.graphics.print(Text.user_input, 200, 200, 0, 3, 3)
  love.graphics.setColor(1, 1, 1, self.alpha_override)
end

local function draw_info()
  love.graphics.setColor(1, 1, 1)

  local _, screen_h = love.graphics.getDimensions()
  love.graphics.print("Speed factor: " .. Player.speed_factor, 0, screen_h - 30)
  love.graphics.print("Frame index: " .. Player.frame.index, 200, screen_h - 30)

  love.graphics.setColor(1, 1, 1, self.alpha_override)
end

self.draw = function()
  if self.state.show_menu then
    draw_selection_list()
    draw_loaded_list()
    draw_info()
  end
  if self.state.input_mode then
    draw_input()
  end
  if #Files.loaded > 0 then
    draw_loaded_images()
  end
end

return self
