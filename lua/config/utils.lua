function has_file(filenames)
  for _, file in ipairs(filenames) do
    if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. file) == 1 then
      return true
    end
  end
  return false
end
