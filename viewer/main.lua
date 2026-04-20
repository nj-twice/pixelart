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
    Files.selected_idx = ((Files.selected_idx - 1) % (#Files.filtered))
    if Files.selected_idx == 0 then Files.selected_idx = #Files.filtered end
  elseif key == "down" then
    Files.selected_idx = ((Files.selected_idx + 1) % (#Files.filtered))
    if Files.selected_idx == 0 then Files.selected_idx = #Files.filtered end
  end
  if key == "delete" then
    table.remove(Files.loaded)
  end
  if key == "return" then
    Files.open(Files.selected_idx)
  end
end
