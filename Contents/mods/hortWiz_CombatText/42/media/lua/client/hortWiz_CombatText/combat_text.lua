local combat_text = {}
local cfg = require("hortWiz_CombatText/cfg")
local log = require("hortWiz_CombatText/log")

local _string_format = string.format
local _table_insert = table.insert
local _table_remove = table.remove
local _getTextManager = getTextManager
local _XToScreen = IsoUtils.XToScreen
local _YToScreen = IsoUtils.YToScreen

-- active floating text pool to avoid garbage collection allocations
local _active_texts = {}

local function _on_weapon_hit(wielder, target, weapon, damage)
  if not cfg.enabled or not target or not wielder then return end
  if damage <= 0 then return end

  local is_crit = damage >= 3.0
  local text_str = _string_format("%.1f%s", damage, (is_crit and cfg.show_crit) and "!" or "")
  local col = is_crit and cfg.crit_color or cfg.normal_color

  log.debug("weapon hit, damage =", damage, "crit =", is_crit)

  _table_insert(_active_texts, {
    x = target:getX(),
    y = target:getY(),
    z = target:getZ() + 1.2,
    text = text_str,
    r = col.r,
    g = col.g,
    b = col.b,
    alpha = 1.0,
    is_crit = is_crit,
  })
end

local function _on_render_tick()
  if #_active_texts == 0 then return end

  for i = #_active_texts, 1, -1 do
    local item = _active_texts[i]
    item.z = item.z + cfg.float_speed
    item.alpha = item.alpha - cfg.fade_speed

    if item.alpha <= 0 then
      _table_remove(_active_texts, i)
    else
      -- render text in world space
      local sx = _XToScreen(item.x, item.y, item.z, 0)
      local sy = _YToScreen(item.x, item.y, item.z, 0)
      _getTextManager():DrawStringCentre(UIFont.Medium, sx, sy, item.text, item.r, item.g, item.b, item.alpha)
    end
  end
end

Events.OnWeaponHitCharacter.Add(_on_weapon_hit)
Events.OnPostRender.Add(_on_render_tick)

return combat_text
