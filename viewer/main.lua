function love.load()
  love.filesystem.setIdentity("github.nj-twice.poorsprite")
  love.graphics.setDefaultFilter("nearest")

  DBG = require "dbg"
  DBG.enabled = true

  Ui = require "ui"
  Files = require "files"
  Text = require "text"
  Player = require "player"
end

function love.update(dt)
  if #Files.loaded > 0 then
    Player.update_frame(dt)
  end
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
  Player.keypressed(key)
  if Ui.state.show_menu and not Ui.state.input_mode then
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
  end
  if key == "m" then
    Ui.state.show_menu = not(Ui.state.show_menu)
  end
  if Ui.state.input_mode then
    if key == "backspace" and #Text.user_input > 0 then
      Text.user_input = string.sub(Text.user_input, 1, #Text.user_input - 1)
    end
  end
  if key == "return" then
    if Ui.state.show_menu and not Ui.state.input_mode then
      Files.open(Files.selected_idx)
    elseif Ui.state.input_mode then
      Text.commit_input()
      Ui.state.input_mode = false
      Files.open(Files.selected_idx)
      Ui.alpha_override = 1
    end
  end
end
