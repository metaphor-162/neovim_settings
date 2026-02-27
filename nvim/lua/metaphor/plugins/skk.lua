if vim.fn.has("wsl") == 1 then
    return {
        {
            "vim-skk/skkeleton",
            dependencies = { "vim-denops/denops.vim", "Shougo/ddc.vim" },
            opts = { lazy = false }, -- 遅延読み込みを無効化
            config = function()
                vim.cmd([[ call skkeleton#config({
            \ 'globalDictionaries': ['~/.skk/SKK-JISYO.L', '~/.skk/SKK-JISYO.okinawa'],
            \ 'completionRankFile': '~/.skk/rank.json',
            \ 'eggLikeNewline': v:true,
            \ })]])
                vim.cmd([[ call ddc#custom#patch_global( 'sources', ['skkeleton'])]])
                vim.cmd([[ call ddc#custom#patch_global( 'sourceOptions', {
            \ '_': {
            \ 'matchers': ['matcher_head'],
            \ 'sorters': ['sorter_rank'],
            \ },
            \ 'skkeleton' : {
            \ 'mark': 'skkeleton',
            \ 'matchers': [],
            \ 'sorters': [],
            \ 'converters': [],
            \ 'isVolatile': v:true,
            \ 'minAutoCompleteLength': 1
            \ }})]])
                vim.cmd([[call ddc#enable()]])
                vim.cmd([[ call ddc#custom#patch_global('ui', 'pum')]])
                vim.cmd([[ call skkeleton#register_keymap('input', ';', 'henkanPoint')]])
            end,
        },
    }
else
    return {}
end
