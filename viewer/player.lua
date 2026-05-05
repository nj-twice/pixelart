local self = {}

self.frame = {}
self.frame.index = 1
self.frame.row = 1
self.frame.col = 1
local new_frame_index = self.frame.index

self.state = {}
self.state.pause = false
self.state.zoom_factor = 5
self.state.follows_mouse = false

self.colors = {}
local default_outline_color = { 0, 0, 0, 0 }
local hover_outline_color = { 0, 1, 0, 0.25 }
self.colors.outline = default_outline_color

self.speed_factor = 1
local speed_increment = 0.5

local function get_max_frame(img)
  local total_width, total_height = img.data:getDimensions()
  local tile_w, tile_h, tile_p = Text.parse_metadata_input(img.meta)

  local number_of_columns = total_width / (tile_w + (2 * tile_p))
  local number_of_rows = total_height / (tile_h + (2 * tile_p))

  return number_of_columns * number_of_rows
end

local function get_current_frame_coords(image)
  local frame_index = self.frame.index

  local tile_w, tile_h, tile_p = Text.parse_metadata_input(image.meta)
  local total_width, total_height = image.data:getDimensions()
  local number_of_columns = total_width / (tile_w + (2 * tile_p))
  local number_of_rows = total_height / (tile_h + (2 * tile_p))

  local current_col = frame_index % number_of_columns
  if current_col == 0 then current_col = number_of_columns end

  local current_row = math.ceil(frame_index / number_of_columns)

  -- DBG.print("Current frame_idx|row|col in sprite sheet: " .. frame_index .. "|" .. current_row .. "|" .. current_col)

  local x = tile_p + (tile_w + 2 * tile_p) * (current_col-1)
  local y = tile_p + (tile_h + 2 * tile_p) * (current_row-1)

  return x, y
end

function self.update_frame(dt)
  local image = Files.loaded[1]
  local max_frame = get_max_frame(image)

  if not self.state.pause then
    new_frame_index = new_frame_index + dt * self.speed_factor
    if new_frame_index > max_frame + 1 then
      new_frame_index = 1
    end
    self.frame.index = math.floor(new_frame_index)
    self.frame.x, self.frame.y = get_current_frame_coords(image)
  end
end

function self.keypressed(key)
  if key == "space" then
    self.state.pause = not self.state.pause
  end
  if key == "d" then
    self.speed_factor = self.speed_factor + speed_increment
  end
  if key == "a" then
    if not(self.speed_factor - speed_increment <= 0) then
      self.speed_factor = self.speed_factor - speed_increment
    end
  end
end

local outline_margin = 2

local function get_transf()
  local screen_w, screen_h = love.graphics.getDimensions()
  local anchor_x, anchor_y = screen_w/2, screen_h/2
  local move = love.math.newTransform(
     anchor_x,
     anchor_y,
     0
   )
  local scale = love.math.newTransform(
     0,
     0,
     0,
     self.state.zoom_factor,
     self.state.zoom_factor
  )

  return { move=move, scale=scale }
end

local function draw_loaded_images()
  love.graphics.setColor(1, 1, 1)

  local image = Files.loaded[1]
  local tile_w, tile_h, _ = Text.parse_metadata_input(image.meta)

  local transf = get_transf()

  local quad = love.graphics.newQuad(
      Player.frame.x,
      Player.frame.y,
      tile_w,
      tile_h,
      image.data
    )

  love.graphics.applyTransform(transf.move)
  love.graphics.applyTransform(transf.scale)

  love.graphics.setColor(Player.colors.outline)
  love.graphics.rectangle(
    "line",
     0,
     0,
     tile_w,
     tile_h
   )
  love.graphics.setColor(1, 1, 1)

  love.graphics.draw(image.data, quad)

  love.graphics.setColor(1, 1, 1, Ui.alpha_override)
end


function self.draw()
  if #Files.loaded > 0 then
    draw_loaded_images()
  end
end


local min_zoom = 0.25

function self.wheelmoved(x, y)
  if self.state.zoom_factor + y >= min_zoom then
    self.state.zoom_factor = self.state.zoom_factor + y
  end
end

local function is_point_in_rect(point, rect_origin, rect_size)
  local x = point[1]
  local y = point[2]

  return
    x > rect_origin[1]
    and x < rect_origin[1] + rect_size[1]
    and y > rect_origin[2]
    and y < rect_origin[2] + rect_size[2]
end

function self.mousemoved(x, y, dx, dy, istouch)
  if #Files.loaded >= 1 then
    local transf = get_transf()
    local move = transf.move
    local scale = transf.scale

    local image = Files.loaded[1]
    local tile_w, tile_h, _ = Text.parse_metadata_input(image.meta)

    if is_point_in_rect(
      { x, y },
      { move:transformPoint(0, 0) },
      { scale:transformPoint(tile_w, tile_h)}
    )
    then
      self.colors.outline = hover_outline_color
    else
      self.colors.outline = default_outline_color
    end
  end
end


function self.mousepressed(x, y, button, istouch, presses)
end

return self

