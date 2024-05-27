local packages = { "astro-language-server", "prisma-language-server", "svelte-language-server" }
local packagesToCheck = {
  { filenames = { "biome.json" }, package = "biome" },
}

for _, check in ipairs(packagesToCheck) do
  local filenames = check.filenames
  local package = check.package
  local found = false

  for _, filename in ipairs(filenames) do
    if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. filename) == 1 then
      found = true
      break
    end
  end

  if found then
    table.insert(packages, package)
  end
end

return {
  "williamboman/mason.nvim",
  dependencies = { "williamboman/mason.nvim" },
  opts = {
    ensure_installed = packages,
  },
}
