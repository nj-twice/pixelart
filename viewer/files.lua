local self = {}

self.filter = function()
  local items = love.filesystem.getDirectoryItems("")
  local tbl = {}
  for _, item in ipairs(items) do
    if string.sub(item, -4, -1) == ".png" then
      table.insert(tbl, item)
    end
  end
  return tbl
end

self.selected_idx = 1
self.filtered_items = self.filter()
self.loaded = {}


self.open = function(idx)
  local filename = self.filtered_items[idx]
  local image = love.graphics.newImage(filename)
  if #self.loaded ~= 1 then
    table.insert(self.loaded, { name=filename, data=image })
  else
    print("Unload loaded file first.")
  end
end



return self

