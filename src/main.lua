function love.load()
  love.filesystem.setIdentity("nj_pixanim")
  SAVE_DIR = love.filesystem.getSaveDirectory()
  print(SAVE_DIR)

  EXPECTED_FILENAME = "spritesheet.png"

  if not love.filesystem.exists(EXPECTED_FILENAME) then
    love.filesystem.createDirectory("placeholder")
    print("DIR_NOT_FOUND = " .. SAVE_DIR)
    print("FILE_NOT_FOUND = " .. SAVE_DIR .. "/" .. EXPECTED_FILENAME)
    love.event.quit(1)
  end

  local metadata_file = "metadata.txt"
  METADATA = love.filesystem.read(metadata_file)
  print(METADATA)
  TILE = {}
  --    Width,   Height,  Margin
  _, _, TILE[1], TILE[2], TILE[3] = string.find(METADATA, "(%d+),(%d+),(%d+)")
end

function love.update(dt)
end


function love.draw()
  local image = love.graphics.newImage(EXPECTED_FILENAME)
  love.graphics.draw(image)
  for i, v in ipairs(TILE) do
    love.graphics.print(v, 100, 100+20*i)
  end

end

function love.keypress(key)
end
