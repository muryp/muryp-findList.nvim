local getData     = require "muryp-findList.utils.getData"
local picker      = require "muryp-findList.utils.picker"
local M           = {}

M.findWorkspace   = function()
end
M.findWorkspaceJS = function()
  local LIST_WORKSPACE, DIR, FILE = getData({ 'pnpm-workspace.yaml', 'packages.json' })
  if FILE:match('.*/packages.json') then
    LIST_WORKSPACE = LIST_WORKSPACE.workspaces ---@type string[]
    local concate = table.concat(LIST_WORKSPACE, ' ' .. DIR)
    local getpath = vim.fn.system('ls -d ' .. DIR .. concate)
    print(getpath)
  else
    LIST_WORKSPACE = LIST_WORKSPACE.packages
    ---@diagnostic disable-next-line: cast-local-type
    LIST_WORKSPACE = table.concat(LIST_WORKSPACE, ' ' .. DIR .. '/')
    LIST_WORKSPACE = vim.fn.system('ls -d ' .. DIR .. '/' .. LIST_WORKSPACE)
    local TABLE = {}
    for match in LIST_WORKSPACE:gmatch("[^\n]+") do
      match = match:gsub(DIR, '')
      table.insert(TABLE, match)
    end
    LIST_WORKSPACE = TABLE
  end
  -- print(vim.inspect(LIST_WORKSPACE))
  ---@param UserSelect string|string[]
  ---@return nil
  local function callBack(UserSelect)
    if type(UserSelect) == 'string' then
      vim.cmd('cd ' .. DIR .. UserSelect)
    end
  end
  picker {
    opts = LIST_WORKSPACE,
    callBack = callBack,
    preview = false,
    title = 'choose your issue',
  }
end
M.cmdGlobal       = function()

end
M.cmdJS           = function()

end
return M