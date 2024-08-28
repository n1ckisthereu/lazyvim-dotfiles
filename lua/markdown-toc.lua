local autosave_enabled = false
local numbering_enabled = false

local function generate_toc(lines)
  local toc = {}
  local headers = {}
  local max_level = 6
  local min_level = 2 -- Ignore h1
  local tab_size = 2
  local markers = { "-" }
  local numbering = {}

  for _, line in ipairs(lines) do
    local level, title = line:match("^(#+)%s+(.+)")
    if level and #level >= min_level and #level <= max_level then
      local id = title:lower():gsub("%s+", "-"):gsub("[^%w-]", "")
      table.insert(headers, { level = #level, title = title, id = id })
    end
  end

  for _, header in ipairs(headers) do
    local level = header.level - min_level + 1
    local indent = string.rep(" ", (level - 1) * tab_size)
    local marker = markers[(level - 1) % #markers + 1]

    local number = ""
    if numbering_enabled then
      -- Adjust the size of table of numeration to the actual level
      while #numbering > level do
        table.remove(numbering)
      end
      while #numbering < level do
        table.insert(numbering, 0)
      end

      -- Increment the number of actual level
      numbering[level] = numbering[level] + 1

      -- Build the string of numeration
      number = table.concat(numbering, ".") .. " "
    end

    table.insert(toc, string.format("%s%s [%s%s](#%s)", indent, marker, number, header.title, header.id))
  end
  return toc
end

local function toc_exists()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for _, line in ipairs(lines) do
    if line:match("<!%-%-toc:start%-%->") then
      return true
    end
  end
  return false
end

local function call_gen(action)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local toc = generate_toc(lines)
  if #toc == 0 then
    print("No headers found to generate TOC")
    return
  end
  local result = "<!--toc:start-->\n" .. table.concat(toc, "\n") .. "\n<!--toc:end-->"
  local start_index, end_index
  for i, line in ipairs(lines) do
    if line:match("<!%-%-toc:start%-%->") then
      start_index = i
    elseif line:match("<!%-%-toc:end%-%->") then
      end_index = i
      break
    end
  end
  local new_lines = vim.split(result, "\n", { trimempty = false })
  if action == "update" and start_index and end_index then
    -- Update existing TOC
    vim.api.nvim_buf_set_lines(0, start_index - 1, end_index, false, new_lines)
  elseif action == "insert" or (action == "update" and not (start_index and end_index)) then
    -- Insert new TOC
    local current_line = vim.fn.line(".")
    local current_col = vim.fn.col(".")
    vim.api.nvim_buf_set_lines(0, current_line - 1, current_line - 1, false, new_lines)
    vim.fn.cursor(current_line + #new_lines, current_col)
  end
end

-- Keymaps

vim.api.nvim_create_user_command("InsertTOC", function()
  call_gen("insert")
end, {
  desc = "Insert toc on actual cursor position",
  nargs = "*",
  complete = function()
    return { "tab_size", "markers" }
  end,
})

vim.api.nvim_create_user_command("UpdateTOC", function()
  call_gen("update")
end, {
  desc = "Update existing table",
  nargs = "*",
  complete = function()
    return { "tab_size", "markers" }
  end,
})

vim.api.nvim_create_user_command("ToggleAutoTOC", function()
  if toc_exists() then
    autosave_enabled = not autosave_enabled
    if autosave_enabled then
      print("AutoTOC enabled")
    else
      print("AutoTOC disabled")
    end
  else
    autosave_enabled = false
    print("No TOC found. AutoTOC disabled. Insert a TOC first using :InsertTOC")
  end
end, {
  desc = "Toggle automatic TOC update on save",
})

vim.api.nvim_create_user_command("ToggleTOCNumbering", function()
  numbering_enabled = not numbering_enabled
  if numbering_enabled then
    print("TOC numbering enabled")
  else
    print("TOC numbering disabled")
  end
  if toc_exists() then
    call_gen("update")
  end
end, {
  desc = "Toggle TOC numbering",
})

vim.api.nvim_create_user_command("RemoveTOC", function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local start_index, end_index

  for i, line in ipairs(lines) do
    if line:match("<!%-%-toc:start%-%->") then
      start_index = i
    elseif line:match("<!%-%-toc:end%-%->") then
      end_index = i
      break
    end
  end

  if start_index and end_index then
    vim.api.nvim_buf_set_lines(0, start_index - 1, end_index, false, {})
    print("TOC removed successfully")
  else
    print("No TOC found in the document")
  end
end, {
  desc = "Remove the Table of Contents",
})

local augroup = vim.api.nvim_create_augroup("MarkdownTOC", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = "*.md",
  callback = function()
    if autosave_enabled and toc_exists() then
      call_gen("update")
    end
  end,
})

vim.api.nvim_set_keymap("n", "<leader>md", ":RemoveTOC<CR>", { noremap = true, silent = true, desc = "Remove TOC" })
vim.api.nvim_set_keymap(
  "n",
  "<leader>mn",
  ":ToggleTOCNumbering<CR>",
  { noremap = true, silent = true, desc = "Toggle TOC Numbering" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>ms",
  ":ToggleAutoTOC<CR>",
  { noremap = true, silent = true, desc = "Toggle Auto TOC" }
)
