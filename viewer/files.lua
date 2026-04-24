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
  if #self.loaded >= 1 then
    print("Unload loaded file first.")
    return
  end

  Ui.alpha_override = 0.4

  if not Text.committed_input then
    DBG.print("There is no committed input. Enabling input mode.")
    Ui.state.input_mode = true
    return
  end

  local filename = self.filtered[idx]
  local image = love.graphics.newImage(filename)
  local metadata = Text.committed_input
  Text.committed_input = nil
  table.insert(self.loaded, { name=filename, data=image, meta=metadata })
end



return self

