local function generate_toc(lines, options)
  local toc = {}
  local headers = {}
  local max_level = 6
  local min_level = 2 -- Ignorar o primeiro nível (h1)
  local tab_size = options.tab_size or 2
  local markers = options.markers or { "*", "+", "-" }

  for _, line in ipairs(lines) do
    local level, title = line:match("^(#+)%s+(.+)")
    if level and #level >= min_level and #level <= max_level then
      local id = title:lower():gsub("%s+", "-"):gsub("[^%w-]", "")
      table.insert(headers, { level = #level, title = title, id = id })
    end
  end

  for _, header in ipairs(headers) do
    local indent = string.rep(" ", (header.level - min_level) * tab_size)
    local marker = markers[(header.level - min_level) % #markers + 1]
    table.insert(toc, string.format("%s%s [%s](#%s)", indent, marker, header.title, header.id))
  end

  return toc
end

local function gen_toc(action, options)
  options = options or {}
  options.tab_size = options.tab_size or 2
  options.markers = options.markers or { "*", "+", "-" }

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local toc = generate_toc(lines, options)

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

vim.api.nvim_create_user_command("InsertTOC", function()
  gen_toc("insert", { tab_size = 2, markers = { "*", "+", "-" } })
end, {
  desc = "Inserir uma Tabela de Conteúdo no cursor atual",
  nargs = "*",
  complete = function()
    return { "tab_size", "markers" }
  end,
})

vim.api.nvim_create_user_command("UpdateTOC", function()
  gen_toc("update", { tab_size = 2, markers = { "-" } })
end, {
  desc = "Atualizar a Tabela de Conteúdo existente",
  nargs = "*",
  complete = function()
    return { "tab_size", "markers" }
  end,
})

-- Autocommand para atualizar o TOC ao salvar arquivos markdown
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.md",
  callback = function()
    gen_toc("update", { tab_size = 2, markers = { "-" } })
  end,
})
