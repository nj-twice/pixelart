local self = {}

self.user_input = ""
self.committed_input = nil

function self.is_in_table(element, table)
  for _, item in ipairs(table) do
    if element == item then
      return true
    end
  end
  return false
end

function self.parse_metadata_input(text)
  local _, w_end = string.find(text, "%d+")
  local width = string.sub(text, 1, w_end)
  local _, h_end = string.find(text, "%d+", w_end+1)
  local height = string.sub(text, w_end+2, h_end)
  local padding = string.sub(text, h_end+2, #text)

  return tonumber(width), tonumber(height), tonumber(padding)
end

local function check_input(text)
  DBG.print("Checking input: " .. text)

  local pattern = "%d+,%d+,%d+"
  local match_begin, match_end = string.find(text, pattern)

  -- If pattern doesn't match the full given string, throw an error
  if match_begin ~= 1 or match_end ~= #text then
    return false
  end

  local filename = Files.filtered[Files.selected_idx]
  local image = love.graphics.newImage(filename)
  local width, height = image:getDimensions()
  local user_tile_width,
        user_tile_height,
        user_tile_pad     = self.parse_metadata_input(text)

  DBG.print(
    "User-provided data :: \n"
    .. "  TileW: " .. user_tile_width
    .. "  TileH: " .. user_tile_height
    .. "  TileP: " .. user_tile_pad
  )

  -- Check consistency with actual image dimensions
  local number_of_columns = width / (user_tile_width + (2 * user_tile_pad))
  local number_of_rows = height / (user_tile_height + (2 * user_tile_pad))

  DBG.print(
    "Computed data from input ::\n"
    .. "  Columns: " .. number_of_columns
    .. "  Rows: " .. number_of_rows
  )

  if number_of_rows ~= math.floor(number_of_rows)
  or number_of_columns ~= math.floor(number_of_columns) then
     return false
  end

  image:release()

  return true
end

function self.commit_input()
  local success = check_input(self.user_input)
  if success then
    self.committed_input = self.user_input
    self.user_input = ""
    DBG.print("Input committed: " .. self.committed_input .. " User input reset.")
  else
    error("Wrong input")
  end
end

return self

