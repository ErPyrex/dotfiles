vim.pack.add({
  {
    src = "https://github.com/iamcco/markdown-preview.nvim",
    name = "markdown-preview.nvim",
  },
})

if vim.g.markdown_preview_setup_ran then
  return
end

vim.g.markdown_preview_setup_ran = true

local plugin_name = "markdown-preview.nvim"
local plugin_path = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "core", "opt", plugin_name)
local app_path = vim.fs.joinpath(plugin_path, "app")
local node_modules_path = vim.fs.joinpath(app_path, "node_modules")

if vim.fn.isdirectory(node_modules_path) == 0 then
  -- First, check if npm is available on the system.
  if vim.fn.executable("npm") == 0 then
    vim.notify("npm not found. Cannot install markdown-preview.nvim dependencies.", vim.log.levels.ERROR)
    return
  end

  if vim.fn.isdirectory(app_path) == 0 then
    vim.notify(
      plugin_name .. " plugin directory not found at: " .. app_path .. ". Please install the plugin first.",
      vim.log.levels.WARN
    )
    return
  end

  vim.notify("Installing markdown-preview.nvim dependencies...", vim.log.levels.INFO)

  local cmd = { "npm", "install" }
  vim.fn.jobstart(cmd, {
    cwd = app_path,
    on_exit = function(_, exit_code)
      vim.schedule(function()
        if exit_code == 0 then
          vim.notify("Successfully installed markdown-preview.nvim dependencies.", vim.log.levels.INFO)
        else
          vim.notify(
            "Failed to install markdown-preview.nvim dependencies. Exit code: " .. tostring(exit_code),
            vim.log.levels.ERROR
          )
        end
      end)
    end,
  })
end

vim.keymap.set("n", "<leader>md", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })
