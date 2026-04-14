function love.load()
  love.filesystem.setIdentity("github.nj-twice.pixelart")
  SAVE_DIR = love.filesystem.getSaveDirectory()
  print(SAVE_DIR)
  love.filesystem.createDirectory("placeholder")
end

function love.update(dt)
end


function love.draw()
end

function love.keypress(key)
end
