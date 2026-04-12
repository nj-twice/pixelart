function love.load()
  love.filesystem.setIdentity("nj_pixanim")
  SAVE_DIR = love.filesystem.getSaveDirectory()
  print(SAVE_DIR)

  EXPECTED_FILENAME = "spritesheet.png"

  if not love.filesystem.exists(EXPECTED_FILENAME) then
    love.filesystem.createDirectory("placeholder")
    print("FILE_NOT_FOUND = " .. SAVE_DIR .. "/" .. EXPECTED_FILENAME)
    love.event.quit(1)
  end

end

function love.update(dt)
end

function love.draw()
  local image = love.graphics.newImage(EXPECTED_FILENAME)
  love.graphics.draw(image)
end

function love.keypress(key)
end
