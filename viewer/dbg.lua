local self = {}

self.enabled = false

self.print = function(txt)
  if self.enabled then
    -- love.graphics.print(txt, 400, 400)
    print(txt)
  end
end

return self
