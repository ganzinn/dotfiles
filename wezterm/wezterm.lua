local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()
config.colors = wezterm.color.get_default_colors()
config.keys = {}

-- leader設定
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 2000 }
table.insert(config.keys,
  -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
  { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey { key = 'a', mods = 'CTRL' } }
)

-- ClaudeCode設定
table.insert(config.keys,
  -- Shift+Enterで改行を送信
  { key = 'Enter', mods = 'SHIFT', action = act { SendString = '\x1b\r' } }
)

-- タイトルバー関連
config.window_decorations = "RESIZE" -- タイトルバーを非表示

-- タブ関連
config.window_frame = { inactive_titlebar_bg = "none", active_titlebar_bg = "none" } -- タブバーの透過
config.window_background_gradient = { colors = { "#000000" } }                       -- タブバーを背景色に合わせる
config.show_new_tab_button_in_tab_bar = false                                        -- タブの追加ボタンを非表示
config.colors = { tab_bar = { inactive_tab_edge = "none" } }                         -- タブ同士の境界線を非表示
--config.show_close_tab_button_in_tabs = false -- タブの閉じるボタンを非表示（nightlyのみ使用可能）
--config.hide_tab_bar_if_only_one_tab = true -- タブバー非表示

-- タブの形をカスタマイズ
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle -- タブの左側の装飾
  local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle -- タブの右側の装飾
  local background = "#5c6d74"
  local foreground = "#FFFFFF"
  local edge_background = "none"
  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
    -- elseif hover then
    --   background = '#3b3052'
    --   foreground = '#909090'
  end
  local edge_foreground = background
  local function tab_title(tab_info)
    local title = tab_info.tab_title
    if title and #title > 0 then
      return title
    end
    return tab_info.active_pane.title
  end
  local title = " " .. tab_title(tab) .. " "
  title = wezterm.truncate_right(title, max_width)

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)
for _, value in ipairs({
  -- タブ名の変更
  { key = ',', mods = 'LEADER', action = act.PromptInputLine {
    description = "(wezterm) Rename tab:",
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        window:active_tab():set_title(line)
      end
    end) },
  },
  -- タブの移動
  { key = '{', mods = 'LEADER', action = act.MoveTabRelative(-1) },
  { key = '}', mods = 'LEADER', action = act.MoveTabRelative(1) },

}) do
  table.insert(config.keys, value)
end

-- padding設定
config.window_padding = {
  left = 8, right = 8, top = 0, bottom = 0,
}

-- フォント関連設定
config.font = wezterm.font('PlemolJP Console NF')
config.font_size = 15.0
config.adjust_window_size_when_changing_font_size = false
config.use_ime = true

-- 透過切り替え
wezterm.on('toggle-opacity', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = 0.7
  else
    overrides.window_background_opacity = nil
  end
  window:set_config_overrides(overrides)
end)
table.insert(config.keys,
  { key = 'u', mods = 'CMD', action = act.EmitEvent 'toggle-opacity' }
)

-- パネル関連
for _, value in ipairs({
  -- 分割
  { key = '\\', mods = 'LEADER',       action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-',  mods = 'LEADER',       action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  -- 移動
  { key = "h",  mods = "LEADER",       action = act.ActivatePaneDirection("Left") },
  { key = "l",  mods = "LEADER",       action = act.ActivatePaneDirection("Right") },
  { key = "k",  mods = "LEADER",       action = act.ActivatePaneDirection("Up") },
  { key = "j",  mods = "LEADER",       action = act.ActivatePaneDirection("Down") },
  -- サイズ変更
  { key = 'h',  mods = 'OPT',          action = act.AdjustPaneSize { 'Left', 25 } },
  { key = 'l',  mods = 'OPT',          action = act.AdjustPaneSize { 'Right', 25 } },
  { key = 'k',  mods = 'OPT',          action = act.AdjustPaneSize { 'Up', 10 } },
  { key = 'k',  mods = 'OPT|SHIFT',    action = act.AdjustPaneSize { 'Up', 100 } },
  { key = 'j',  mods = 'OPT',          action = act.AdjustPaneSize { 'Down', 10 } },
  { key = 'j',  mods = 'OPT|SHIFT',    action = act.AdjustPaneSize { 'Down', 100 } },
  -- 最大化
  { key = 'z',  mods = 'LEADER',       action = act.TogglePaneZoomState },
  -- ペインの削除
  { key = 'P',  mods = 'LEADER|SHIFT', action = act.CloseCurrentPane { confirm = true } },
  -- コピーモード
  { key = '[',  mods = 'LEADER',       action = act.ActivateCopyMode },
}) do
  table.insert(config.keys, value)
end
-- 分割線の色変更
config.colors.split = '#cccccc'

-- workspace関連
local prev_workspace = nil
local current_workspace = nil
for _, value in ipairs({
  -- workspace作成
  { mods = 'LEADER|SHIFT', key = 'W', action = act.PromptInputLine {
    description = "(wezterm) Create new workspace:",
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        window:perform_action(act.SwitchToWorkspace { name = line }, pane)
      end
    end) },
  },
  -- workspace選択
  { mods = 'LEADER', key = 'w',
    action = wezterm.action_callback(function(win, pane)
      -- workspace のリストを作成
      local workspaces = {}
      for _, name in ipairs(wezterm.mux.get_workspace_names()) do
        table.insert(workspaces, { id = name, label = name })
      end
      local current = wezterm.mux.get_active_workspace()
      -- 選択メニューを起動
      win:perform_action(act.InputSelector {
        action = wezterm.action_callback(function(_, _, id, label)
          if not id and not label then
            wezterm.log_info "Workspace selection canceled"               -- 入力が空ならキャンセル
          else
            win:perform_action(act.SwitchToWorkspace { name = id }, pane) -- workspace を移動
          end
        end),
        title = "Select workspace",
        choices = workspaces,
        -- fuzzy = true,
        -- fuzzy_description = string.format("Select workspace: %s -> ", current), -- requires nightly build
      }, pane)
    end),
  },
  -- workspace名変更
  { mods = 'LEADER', key = '.', action = act.PromptInputLine {
    description = "(wezterm) Set workspace title:",
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
      end
    end) },
  },
  -- 前回のworkspaceに切り替え
  { mods = 'LEADER', key = 's', action = wezterm.action_callback(function(window, pane)
    local all_workspaces = wezterm.mux.get_workspace_names()
    local current = wezterm.mux.get_active_workspace()
    local target = nil

    -- prev_workspaceが有効なら使い、なければ現在以外の最初のworkspaceを使う
    for _, name in ipairs(all_workspaces) do
      if name == prev_workspace then
        target = name
        break
      elseif not target and name ~= current then
        target = name
      end
    end

    if target then
      window:perform_action(act.SwitchToWorkspace { name = target }, pane)
    end
  end) },
}) do
  table.insert(config.keys, value)
end
-- タブエリアにワークスペース名を表示
wezterm.on('update-status', function(window, pane)
  local active = window:active_workspace()
  if current_workspace ~= active then
    prev_workspace = current_workspace
    current_workspace = active
  end
  local elements = {
    -- { Foreground = { Color = 'blue' } },
    { Background = { Color = 'none' } },
    { Text = "[   " .. active .. "   ]" },
  }
  window:set_left_status(wezterm.format(elements))
end)

return config
