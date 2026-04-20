function love.load()
  love.filesystem.setIdentity("github.nj-twice.pixelart")
  love.graphics.setDefaultFilter("nearest")

  DBG = require "dbg"
  DBG.enabled = true

  Ui = require "ui"
  Files = require "files"
end

function love.update(dt)
end


function love.draw()
  Ui.draw()
end

function love.keypressed(key)
  if key == "up" then
    Files.selected_idx = ((Files.selected_idx - 1) % (#Files.filtered_items))
    if Files.selected_idx == 0 then Files.selected_idx = #Files.filtered_items end
  elseif key == "down" then
    Files.selected_idx = ((Files.selected_idx + 1) % (#Files.filtered_items))
    if Files.selected_idx == 0 then Files.selected_idx = #Files.filtered_items end
  end
  if key == "return" then
    Files.open(Files.selected_idx)
  end
end
