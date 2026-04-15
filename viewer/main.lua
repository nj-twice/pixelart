local function filter_items()
  local tbl = {}
  for _, item in ipairs(Items) do
    if string.sub(item, -4, -1) == ".png" then
      table.insert(tbl, item)
    end
  end
  return tbl
end

local function open_file(idx)
  local image = love.graphics.newImage(FilteredItems[idx])
  table.insert(Loaded_files, image)
end


function love.load()
  DBG = require "dbg"
  DBG.enabled = true
  love.filesystem.setIdentity("github.nj-twice.pixelart")
  SAVE_DIR = love.filesystem.getSaveDirectory()
  Items = love.filesystem.getDirectoryItems("")
  FilteredItems = filter_items()
  Selected_item_idx = 1
  Loaded_files = {}
end

local function draw_selection_list()
  for idx, item in ipairs(FilteredItems) do
    if item then
      if idx == Selected_item_idx then
        love.graphics.setColor(1,0,0)
        love.graphics.print(item, 100, 40+20*(idx-1), 0, 2, 2)
        love.graphics.setColor(1,1,1)
      else
        love.graphics.print(item, 100, 40+20*(idx-1), 0, 2, 2)
      end
    end
  end
  DBG.print(Selected_item_idx)
end

local function draw_loaded_images()
  for _, image in ipairs(Loaded_files) do
    love.graphics.draw(image)
  end
end

function love.update(dt)
end


function love.draw()
  draw_selection_list()
  draw_loaded_images()
end

function love.keypressed(key)
  if key == "up" then
    Selected_item_idx = ((Selected_item_idx - 1) % (#FilteredItems))
    if Selected_item_idx == 0 then Selected_item_idx = #FilteredItems end
  elseif key == "down" then
    Selected_item_idx = ((Selected_item_idx + 1) % (#FilteredItems))
    if Selected_item_idx == 0 then Selected_item_idx = #FilteredItems end
  end
  if key == "return" then
    print("Selected: " .. FilteredItems[Selected_item_idx])
    open_file(Selected_item_idx)
  end
end
