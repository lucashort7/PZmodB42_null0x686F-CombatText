local cfg = {
  enabled = true,
  LOG_LEVEL = "info",
  show_crit = true,
  -- damage at or above this counts as a critical hit. lived as a bare 3.0
  -- inside the hit handler, where nobody could find or change it.
  crit_threshold = 3.0,
  -- "small" | "medium" | "large". was declared here and ignored -- the render
  -- call hardcoded UIFont.Medium regardless of what this said.
  font_size = "medium",
  normal_color = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 },
  crit_color = { r = 1.0, g = 0.2, b = 0.2, a = 1.0 },
  float_speed = 0.02,
  fade_speed = 0.03,
}

return cfg
