local cfg = require("null0x686F_CombatText/cfg")
local log = require("null0x686F_CombatText/log")

-- cached for the render path only: _on_render_tick runs on OnPostRender, i.e.
-- every frame. _on_weapon_hit runs once per swing -- a player action -- so
-- nothing there is cached. see suite/docs/LUA-STYLE.md §5.
local _table_remove = table.remove
local _get_text_manager = getTextManager
local _x_to_screen = IsoUtils.XToScreen
local _y_to_screen = IsoUtils.YToScreen

local FONTS = {
  small = "Small",
  medium = "Medium",
  large = "Large",
}

-- texts currently on screen, plus the free list they return to. a fresh table
-- per hit would allocate steadily inside a render path; recycling keeps that
-- out of the GC's way. see skill §2.C.
local _active_texts = {}
local _free_texts = {}

-- resolved in init(): UIFont is a Java global and there is no guarantee it
-- exists at file-parse time, which is when this file is auto-executed.
local _font = nil

local _is_patched = false

local function _acquire()
  local n = #_free_texts
  if n == 0 then return {} end

  local t = _free_texts[n]
  _free_texts[n] = nil
  return t
end

local function _on_weapon_hit(wielder, target, _weapon, damage)
  if not cfg.enabled or not target or not wielder then return end
  if damage <= 0 then return end

  local is_crit = damage >= cfg.crit_threshold
  local text = string.format("%.1f%s", damage, (is_crit and cfg.show_crit) and "!" or "")
  local col = is_crit and cfg.crit_color or cfg.normal_color

  log.debug("weapon hit, damage =", damage, "crit =", is_crit)

  local t = _acquire()
  t.x = target:getX()
  t.y = target:getY()
  t.z = target:getZ() + 1.2
  t.text = text
  t.r = col.r
  t.g = col.g
  t.b = col.b
  t.alpha = 1.0

  _active_texts[#_active_texts + 1] = t
end

local function _on_render_tick()
  if #_active_texts == 0 then return end

  -- disabling mid-session should clear what is already floating, otherwise the
  -- toggle appears not to work until every text happens to fade out.
  if not cfg.enabled then
    for i = #_active_texts, 1, -1 do
      _free_texts[#_free_texts + 1] = _table_remove(_active_texts, i)
    end
    return
  end

  for i = #_active_texts, 1, -1 do
    local item = _active_texts[i]
    item.z = item.z + cfg.float_speed
    item.alpha = item.alpha - cfg.fade_speed

    if item.alpha <= 0 then
      _free_texts[#_free_texts + 1] = _table_remove(_active_texts, i)
    else
      local sx = _x_to_screen(item.x, item.y, item.z, 0)
      local sy = _y_to_screen(item.x, item.y, item.z, 0)
      _get_text_manager():DrawStringCentre(_font, sx, sy, item.text, item.r, item.g, item.b, item.alpha)
    end
  end
end

local function init()
  if _is_patched then return end

  _font = UIFont[FONTS[cfg.font_size] or FONTS.medium]

  Events.OnWeaponHitCharacter.Add(_on_weapon_hit)
  Events.OnPostRender.Add(_on_render_tick)

  _is_patched = true
  log.debug("combat_text.lua initialized")
end

return {
  init = init,
}
