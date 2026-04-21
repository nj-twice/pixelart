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
self.filtered = self.filter()
self.loaded = {}


self.open = function(idx)
  if not Text.commited_input then
    Ui.input_mode = true
    return
  end

  local filename = self.filtered[idx]
  local image = love.graphics.newImage(filename)
  local metadata = Text.commited_input
  Text.commited_input = nil
  if #self.loaded ~= 1 then
    table.insert(self.loaded, { name=filename, data=image, meta=metadata })
  else
    print("Unload loaded file first.")
  end
end



return self

