local M = {}

local zettelkasten_home = os.getenv("ZETTELKASTEN_HOME") or (os.getenv("HOME") .. "/dotfiles/zettelkasten")

-- JST = UTC + 9
local function get_jst_time()
  return os.date("!%Y-%m-%dT%H:%M:%S", os.time() + 9 * 3600)
end

-- Frontmatterをパースしてキーバリューのテーブルと終了行インデックスを返す
-- Obsidianスタイルのリスト形式（インデントされた - value）に対応
local function parse_frontmatter(lines)
  local frontmatter_end_idx = 0
  local fm_data = {}
  local has_frontmatter = false

  if lines[1] == "---" then
    local i = 2
    while i <= #lines do
      if lines[i] == "---" then
        has_frontmatter = true
        frontmatter_end_idx = i
        break
      end
      
      local line = lines[i]
      -- キー: 値 の形式をマッチ（行頭のスペースを許容）
      local key, value = line:match("^%s*(%w+):%s*(.*)")
      
      if key then
        -- 値のトリミング（CRLF対策など）
        value = value:match("^%s*(.-)%s*$")

        if value == "" then
          -- 値が空の場合、次の行からリストが始まる可能性を確認
          local list_items = {}
          local j = i + 1
          while j <= #lines and lines[j] ~= "---" do
            -- インデントされたリストアイテム (- item) を探す
            local item = lines[j]:match("^%s*-%s+(.*)")
            if item then
              -- 値の前後の空白を除去してリストに追加
              table.insert(list_items, item:match("^%s*(.-)%s*$"))
              j = j + 1
            else
              -- リスト以外の行が来たら終了（次のキー定義など）
              break
            end
          end
          
          if #list_items > 0 then
            -- リストが見つかった場合、テーブルとして保持（構造を維持）
            fm_data[key] = list_items
            -- 読み進めた分だけインデックスを進める
            i = j - 1
          else
            -- 空文字列として保持
            fm_data[key] = ""
          end
        else
          -- 通常の文字列値
          fm_data[key] = value
        end
      end
      i = i + 1
    end
  end

  return has_frontmatter, fm_data, frontmatter_end_idx
end

-- Frontmatterブロックを構築する
local function build_frontmatter(filename_base, original_fm, mode)
  local current_time = get_jst_time()
  local new_lines = {}
  
  table.insert(new_lines, "---")
  
  -- ID: ファイル名ベース
  table.insert(new_lines, "id: " .. filename_base)
  
  -- tags: リストならリスト形式、文字列なら文字列形式で書き出す
  local tags_val = original_fm["tags"]
  if type(tags_val) == "table" and #tags_val > 0 then
    -- リスト形式（Obsidianスタイル）で出力
    table.insert(new_lines, "tags:")
    for _, tag in ipairs(tags_val) do
      table.insert(new_lines, "  - " .. tag)
    end
  elseif type(tags_val) == "string" and tags_val ~= "" and tags_val ~= "[]" then
    -- 文字列形式（一行スタイル）で出力
    table.insert(new_lines, "tags: " .. tags_val)
  else
    -- 空または空の配列の場合、空欄にする
    table.insert(new_lines, "tags: ")
  end
  
  -- createdAt
  if original_fm["createdAt"] and original_fm["createdAt"] ~= "" then
    table.insert(new_lines, "createdAt: " .. original_fm["createdAt"])
  else
    table.insert(new_lines, "createdAt: " .. current_time)
  end
  
  -- updatedAt
  if mode == "save" then
    table.insert(new_lines, "updatedAt: " .. current_time)
  elseif original_fm["updatedAt"] then
    table.insert(new_lines, "updatedAt: " .. original_fm["updatedAt"])
  else
    table.insert(new_lines, "updatedAt: " .. current_time)
  end

  -- lastViewedAt
  if mode == "read" then
    table.insert(new_lines, "lastViewedAt: " .. current_time)
  elseif original_fm["lastViewedAt"] then
    table.insert(new_lines, "lastViewedAt: " .. original_fm["lastViewedAt"])
  end

  -- count
  local count = 0
  local raw_count = original_fm["count"]
  if raw_count then
      -- 文字列から数値部分のみを抽出して変換（"1" -> 1, "1 views" -> 1, nil -> 0）
      -- raw_count がテーブル（リスト）の場合は無視（0になる）
      if type(raw_count) == "string" then
          local n = raw_count:match("(%d+)")
          if n then count = tonumber(n) end
      elseif type(raw_count) == "number" then
          count = raw_count
      end
  end

  if mode == "read" then
    local current_date_str = string.sub(current_time, 1, 10)
    
    -- 1. 作成日チェック (作成日はカウントしない)
    local created_at_str = original_fm["createdAt"] or current_time
    -- YYYY-MM-DD を抽出 (先頭10文字)
    local created_date = string.sub(created_at_str, 1, 10)
    
    -- 2. 前回閲覧日チェック (同日の再閲覧はカウントしない)
    local last_viewed_at_str = original_fm["lastViewedAt"]
    local last_viewed_date = nil
    if last_viewed_at_str and #last_viewed_at_str >= 10 then
        last_viewed_date = string.sub(last_viewed_at_str, 1, 10)
    end

    -- カウントアップ条件: (今日が作成日ではない) かつ (今日が前回閲覧日ではない)
    local is_not_created_today = (created_date and current_date_str ~= created_date)
    local is_not_viewed_today = (current_date_str ~= last_viewed_date)

    if is_not_created_today and is_not_viewed_today then
      count = count + 1
    end
  end
  table.insert(new_lines, "count: " .. tostring(count))
  
  -- その他の維持したいフィールド (titleなど)
  if original_fm["title"] then
       table.insert(new_lines, "title: " .. original_fm["title"])
  end

  table.insert(new_lines, "---")
  return new_lines
end

function M.setup()
  local group = vim.api.nvim_create_augroup("MetaphorFrontmatter", { clear = true })

  -- 保存時 (BufWritePre)
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    pattern = "*.md",
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      local filepath = vim.api.nvim_buf_get_name(bufnr)
      
      -- zettelkasten配下でない場合は処理しない
      if not string.find(filepath, zettelkasten_home, 1, true) then
        return
      end

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local filename_base = vim.fn.expand("%:t:r")

      local has_frontmatter, original_fm, frontmatter_end_idx = parse_frontmatter(lines)
      
      -- タグ救出ロジック
      local tags_broken = false
      local current_tags = original_fm["tags"]
      -- テーブルの場合は空ではないとみなす
      if type(current_tags) == "table" then
          if #current_tags == 0 then tags_broken = true end
      elseif not current_tags or current_tags == "" or current_tags == "[]" then
          tags_broken = true
      end

      if tags_broken and has_frontmatter then
        -- filepath is already defined above
        if vim.fn.filereadable(filepath) == 1 then
            local file_lines = vim.fn.readfile(filepath)
            local _, file_fm, _ = parse_frontmatter(file_lines)
            
            local saved_tags = file_fm["tags"]
            -- 救出対象の検証
            local is_valid_saved = false
            if type(saved_tags) == "table" and #saved_tags > 0 then
                is_valid_saved = true
            elseif type(saved_tags) == "string" and saved_tags ~= "" and saved_tags ~= "[]" then
                is_valid_saved = true
            end
            
            if is_valid_saved then
                original_fm["tags"] = saved_tags
            end
        end
      end

      local new_lines = build_frontmatter(filename_base, original_fm, "save")
      
      -- 本文追加
      if has_frontmatter then
        for i = frontmatter_end_idx + 1, #lines do
          table.insert(new_lines, lines[i])
        end
      else
        -- 新規の場合空行追加
        table.insert(new_lines, "")
        for i = 1, #lines do
          table.insert(new_lines, lines[i])
        end
      end

      local was_modifiable = vim.bo[bufnr].modifiable
      if not was_modifiable then
          vim.bo[bufnr].modifiable = true
      end
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
      if not was_modifiable then
          vim.bo[bufnr].modifiable = false
      end
    end,
  })

  -- 読み込み時 (BufReadPost)
  vim.api.nvim_create_autocmd("BufReadPost", {
    group = group,
    pattern = "*.md",
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      local filepath = vim.api.nvim_buf_get_name(bufnr)

      -- zettelkasten配下でない場合は処理しない
      if not string.find(filepath, zettelkasten_home, 1, true) then
        return
      end

      -- ファイルが空などの場合はスキップ
      if vim.api.nvim_buf_line_count(bufnr) <= 1 then return end
      
      local filename_base = vim.fn.expand("%:t:r")

      -- ★ vim.schedule でラップして LSP エラーを回避
      vim.schedule(function()
          -- バッファがまだ有効か確認
          if not vim.api.nvim_buf_is_valid(bufnr) then return end

          local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
          local has_frontmatter, original_fm, frontmatter_end_idx = parse_frontmatter(lines)

          if has_frontmatter then
            local new_lines = build_frontmatter(filename_base, original_fm, "read")
            
            for i = frontmatter_end_idx + 1, #lines do
              table.insert(new_lines, lines[i])
            end
            
            -- 変更チェック（配列比較は簡易的に行数と内容で行う）
            local needs_update = false
            if #lines ~= #new_lines then
                needs_update = true
            else
                for i = 1, #lines do
                    if lines[i] ~= new_lines[i] then
                        needs_update = true
                        break
                    end
                end
            end

            if needs_update then
                -- 読み取り専用でも強制的に更新するために一時的に権限を変更
                local was_modifiable = vim.bo[bufnr].modifiable
                if not was_modifiable then
                    vim.bo[bufnr].modifiable = true
                end
                
                -- ★ Edit Restriction対策: readonly も一時的に解除
                local was_readonly = vim.bo[bufnr].readonly
                if was_readonly then
                    vim.bo[bufnr].readonly = false
                end

                vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
                
                -- count/lastViewedAt を永続化するためにサイレント保存
                -- noautocmd により BufWritePre (updatedAt更新) などを回避
                vim.api.nvim_buf_call(bufnr, function()
                    vim.cmd("silent! noautocmd write")
                end)

                -- 権限を元に戻す
                if was_readonly then
                    vim.bo[bufnr].readonly = true
                    -- readonly時はmodifiedフラグを下ろしておく（保存失敗した場合も含む）
                    if vim.bo[bufnr].modified then
                        vim.bo[bufnr].modified = false
                    end
                end

                if not was_modifiable then
                    vim.bo[bufnr].modifiable = false
                end
            end
          end
      end)
    end,
  })
end

return M
