vim.pack.add({
  "https://github.com/mfussenegger/nvim-lint",
})

local lint = require("lint")

local lint_conditions = {
  eslint_d = {
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    ".eslintrc.json",
    "eslint.config.js",
  },
  biomejs = { "biome.json", "biome.jsonc" },
}

lint.linters_by_ft = {
  javascript = { "eslint_d", "biomejs" },
  typescript = { "eslint_d", "biomejs" },
  javascriptreact = { "eslint_d", "biomejs" },
  typescriptreact = { "eslint_d", "biomejs" },
}

local timer = vim.uv.new_timer()

local function do_lint()
  local ft = vim.bo.filetype
  local linters = lint.linters_by_ft[ft] or {}
  local names = {}

  -- Solo añadimos los linters que tengan archivo de configuración en el proyecto
  for _, name in ipairs(linters) do
    local config_files = lint_conditions[name]
    if config_files then
      local found = vim.fs.find(config_files, { upward = true, path = vim.fn.expand("%:p:h") })[1]
      if found then
        table.insert(names, name)
      end
    end
  end

  if #names > 0 then
    lint.try_lint(names)
  end
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
  callback = function()
    if timer then
      timer:stop()
      timer:start(100, 0, vim.schedule_wrap(do_lint))
    end
  end,
})
