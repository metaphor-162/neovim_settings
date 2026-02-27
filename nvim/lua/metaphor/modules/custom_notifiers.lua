local M = {}

M.SoundNotifier = {}

function M.SoundNotifier.new(timer, opts)
	local self = setmetatable({}, { __index = M.SoundNotifier })
	self.timer = timer
	self.opts = opts or {}
	return self
end

function M.SoundNotifier.start(self)
	-- タイマー開始時の処理（必要に応じて）
end

function M.SoundNotifier.tick(self, time_left)
	-- タイマーの進行中の処理（必要に応じて）
end

function M.SoundNotifier.done(self)
	-- タイマー終了時に音を鳴らす
	-- vim.fn.jobstart({ "play", vim.fn.expand("~/.config/nvim/sound/pomo.mp3") })
end

function M.SoundNotifier.stop(self)
	-- タイマー停止時の処理（必要に応じて）
end

return M
