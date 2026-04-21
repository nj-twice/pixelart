local self = {}

self.user_input = ""
self.commited_input = nil

function self.is_in_table(element, table)
  for _, item in ipairs(table) do
    if element == item then
      return true
    end
  end
  return false
end

local function check_input(text)
  -- TODO: check format \d+,\d+,\d+
  -- TODO: check consistency with image size → here we do the math
  DBG.print("Checking input...")
  return true
end

function self.commit_input()
  local success = check_input(self.user_input)
  if success then
    self.committed_input = self.user_input
    self.user_input = ""
  else
    error("Wrong input")
  end
end

return self

