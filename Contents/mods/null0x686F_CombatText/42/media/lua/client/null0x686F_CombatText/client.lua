local log = require("null0x686F_CombatText/log")

-- every .lua under media/lua/client/ is auto-executed at boot whether or not
-- anything requires it, so a feature that registers its own events at file
-- scope can never be turned off by removing a require. registration goes
-- through init() called from here instead. see skill §4.Q and
-- suite/docs/LUA-STYLE.md §10.
local features_map = {
  combat_text = require("null0x686F_CombatText/combat_text"),
}

_G.__Null0x686FCombatText = _G.__Null0x686FCombatText or {
  __feature_hooks = false,
}

local function _init_feature_hooks()
  local state = _G.__Null0x686FCombatText
  if state.__feature_hooks then return end

  local ok = pcall(function ()
    Events.OnCreatePlayer.Add(function ()
      local loaded = 0
      for name, feature in pairs(features_map) do
        feature.init()
        loaded = loaded + 1
        log.debug(name .. " hook loaded!")
      end
      log.info("null0x686F_CombatText :: " .. loaded .. " features loaded successfully!")
    end)
  end)

  state.__feature_hooks = ok
end

_init_feature_hooks()
