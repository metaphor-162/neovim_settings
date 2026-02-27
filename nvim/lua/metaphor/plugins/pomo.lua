-- 日記に書き込む処理を追加する
-- 引数に書き込む内容を設定する
local function append_to_daily_note(daily_note_path, write_sentence)
	local file = io.open(daily_note_path, "a")
	if file then
		file:write(write_sentence)
		file:close()
	else
		print("Failed to open daily note")
	end
end

-- タイムゾーン情報を取得する関数
local function get_timezone_offset()
	local now = os.time()
	local local_time = os.date("*t", now)
	local utc_time = os.date("!*t", now)
	local_time.isdst = false -- サマータイムを考慮しない
	local local_timestamp = os.time(local_time)
	local utc_timestamp = os.time(utc_time)
	local offset = os.difftime(local_timestamp, utc_timestamp)
	local hours = math.floor(offset / 3600)
	local minutes = math.floor(math.abs(offset % 3600) / 60)
	return string.format("%+03d:%02d", hours, minutes)
end

-- ポモドーロの処理をラップする
local function start_pomodoro_timer(duration, description)
	vim.cmd("TimerStart " .. duration .. "m " .. description)
	-- 書き込む内容を設定する
	local date = os.date("%Y-%m-%d")
	local timestamp = os.date("%Y-%m-%dT%H:%M:%S.")
		.. string.format("%03d", os.clock() * 1000 % 1000)
		.. get_timezone_offset()
	local zettelkasten_home = os.getenv("ZETTELKASTEN_HOME") or (os.getenv("HOME") .. "/dotfiles/zettelkasten")
	local daily_note_path = zettelkasten_home .. "/daily/" .. date .. ".md"
	local write_sentence = "\n````fw " .. timestamp .. "\n" .. duration .. " pomodoro session started\n````\n"
	append_to_daily_note(daily_note_path, write_sentence)
end
return {
	"epwalsh/pomo.nvim",
	version = "*",
	lazy = true,
	dependencies = {
		"rcarriga/nvim-notify",
	},
	opts = {
		notifiers = {
			{
				name = "Default",
				opts = {
					sticky = false,
					title_icon = "󰄉",
					text_icon = "󰄉",
				},
			},
			{
				init = function(timer)
					local custom_notifiers = require("metaphor.modules.custom_notifiers")
					return custom_notifiers.SoundNotifier.new(timer)
				end,
			},
		},
	},
	config = function(_, opts)
		require("pomo").setup(opts)
		require("notify").setup({
			stages = "fade_in_slide_out",
			timeout = 3000,
			background_colour = "#000000",
			render = "default",
			minimum_width = 50,
			icons = {
				ERROR = "",
				WARN = "",
				INFO = "",
				DEBUG = "",
				TRACE = "✎",
			},
			top_down = false, -- 通知が下から上に表示されるように設定
			position = "bottom_left", -- ここで位置を指定
		})
	end,
	keys = {
		{
			"<leader>t1",
			function()
				start_pomodoro_timer(25, "Work")
			end,
			desc = "Start 25m Work Timer",
		},
		{
			"<leader>t2",
			function()
				start_pomodoro_timer(5, "Break")
			end,
			desc = "Start 5m breakTimer",
		},
		{
			"<leader>t3",
			"<cmd>TimerStart 5s break<cr>",
			desc = "Start test",
		},
		{
			"<leader>ts",
			"<cmd>TimerShow<cr>",
			desc = "Timer Show",
		},
		{
			"<leader>th",
			"<cmd>TimerHide<cr>",
			desc = "Timer Hide",
		},
		{
			"<leader>te",
			"<cmd>TimerStop<cr>",
			desc = "Timer End",
		},
	},
}
