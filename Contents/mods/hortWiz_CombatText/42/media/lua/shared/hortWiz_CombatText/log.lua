local cfg = require("hortWiz_CombatText/cfg")
local core_log = require("hortWiz_Core/log")

local function _get_level()
  if isDebugEnabled and isDebugEnabled() then
    return "debug"
  end
  return cfg.LOG_LEVEL or "info"
end

return core_log.new("HortWiz_CombatText", _get_level)
