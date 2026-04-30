local self = {}

self.frame_index = 1
local new_frame_index = self.frame_index

self.speed_factor = 1
local speed_increment = 0.5

function self.update_frame(dt)
  local max_frame = 3 -- Hardcoded temporarily

  new_frame_index = new_frame_index + dt * self.speed_factor
  if new_frame_index > max_frame + 1 then
    new_frame_index = 1
  end
  self.frame_index = math.floor(new_frame_index)
end

function self.keypressed(key)
  if key == "d" then
    self.speed_factor = self.speed_factor + speed_increment
  end
  if key == "a" then
    if not(self.speed_factor - speed_increment <= 0) then
      self.speed_factor = self.speed_factor - speed_increment
    end
  end
end

return self

