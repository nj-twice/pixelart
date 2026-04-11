function love.load()
  CWD = love.filesystem.getWorkingDirectory()
  EXPECTED_FILENAME = "spritesheet.png"

  local path = CWD .. "/" .. EXPECTED_FILENAME
  INFO = love.filesystem.exists(CWD)

  print(CWD)
  print(INFO)

  -- if INFO == nil then
  --   error("Error while trying to read file: " .. path)
  -- end

end

function love.update(dt)
end

function love.draw()
  love.graphics.print("CWD: " .. CWD, 200, 200, 0, 2, 2)
  -- love.graphics.print("INFO: " .. INFO, 200, 300, 0, 2, 2)
end

function love.keypress(key)
end
