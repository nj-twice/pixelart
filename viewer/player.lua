local self = {}

self.frame = {}
self.frame.index = 1
self.frame.row = 1
self.frame.col = 1
local new_frame_index = self.frame.index

self.state = {}
self.state.pause = false

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

return self

