function love.load()
  love.filesystem.setIdentity("github.nj-twice.pixelart")
  love.graphics.setDefaultFilter("nearest")

  DBG = require "dbg"
  DBG.enabled = true

  Ui = require "ui"
  Files = require "files"
  Text = require "text"
end

function love.update(dt)
end


function love.draw()
  Ui.draw()
end

function love.textinput(text)
  local allowed_chars = {",", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
  if Text.is_in_table(text, allowed_chars) then
    Text.user_input = Text.user_input .. text
  end
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
  if key == "m" then
    Ui.show_menu = not(Ui.show_menu)
  end
  if key == "return" then
    if Ui.show_menu and not Ui.input_mode then
      Files.open(Files.selected_idx)
    elseif Ui.input_mode then
      Text.commit_input()
      Ui.input_mode = false
      Files.open(Files.selected_idx)
    end
  end
end
