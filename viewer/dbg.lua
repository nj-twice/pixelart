local self = {}

self.enabled = false

function self.love_print(txt)
  local screen_w, screen_h = love.graphics.getDimensions()
  love.graphics.print(txt, screen_w - 150, screen_h - 150, 0, 3, 3)
end

function self.print(txt)
  if self.enabled then
    -- love.graphics.print(txt, 400, 400)
    print(txt)
  end
end

return self
