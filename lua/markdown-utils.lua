function OpenLink(path_or_link)
  if path_or_link:match("^https?://") then
    os.execute("xdg-open '" .. path_or_link .. "' &")
    print("Opening external link: " .. path_or_link)
  else
    local dir_path = vim.fn.expand("%:p:h")
    local absolute_path = vim.fn.fnamemodify(dir_path .. "/" .. path_or_link, ":p")
    if vim.fn.filereadable(absolute_path) == 1 then
      vim.cmd("edit " .. absolute_path)
      print("Opening file: " .. absolute_path)
    else
      local file_name = vim.fn.fnamemodify(path_or_link, ":t")
      print("File not found: " .. absolute_path)
    end
  end
end

function OpenFileFromLink()
  local line_content = vim.fn.getline(".")
  local cursor_col = vim.fn.col(".")
  local start_index = 1
  local found_link = nil

  while true do
    local link_start, link_end, text, path_or_link = line_content:find("%[(.-)%]%((.-)%)", start_index)

    if not link_start then
      break
    end

    if link_start <= cursor_col and cursor_col <= link_end then
      found_link = { text = text, path = path_or_link:gsub("^<(.-)>$", "%1") }
      break
    elseif link_start > cursor_col then
      found_link = { text = text, path = path_or_link:gsub("^<(.-)>$", "%1") }
      break
    end

    start_index = link_end + 1
  end

  if found_link then
    OpenLink(found_link.path)
  else
    print("No links found after the cursor on this line.")
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>l", ":lua OpenFileFromLink()<CR>", { noremap = true, silent = true })
  end,
})
