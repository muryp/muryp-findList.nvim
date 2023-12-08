---@param Arg {callBack:function,opts:table,preview:boolean,title:string}
---@return nil : Telescope custom list
return function(Arg)
  local pickers = require 'telescope.pickers'
  local previewers = require 'telescope.previewers'
  local finders = require 'telescope.finders'
  local actions = require 'telescope.actions'
  local conf = require('telescope.config').values
  local action_state = require 'telescope.actions.state'
  local callBack = Arg.callBack ---if user select/enter
  local Opts = Arg.opts         ---list opts for choose
  local TITLE = Arg.title       ---title for telescope

  -- Fungsi untuk mengaktifkan highlight sintaksis Markdown
  local function enable_markdown_highlight(bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'filetype', 'markdown')
    vim.api.nvim_command 'runtime! syntax/markdown.vim'
  end

  --- for content result by issue number
  local showPreview
  showPreview = Arg.preview
  if showPreview then
    showPreview = previewers.new_buffer_previewer {
      get_buffer_by_name = function(_, entry)
        return entry.filename
      end,
      define_preview = function(self, entry)
        local FILE = entry.value
        local bufnr = self.state.bufnr
        enable_markdown_highlight(bufnr)
        local content = {}
        for line in io.lines(FILE) do
          table.insert(content, line)
        end
        -- add loading text if content will not generate now
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, content)
      end,
    }
  end
  pickers
      .new({}, {
        prompt_title = TITLE,
        finder = finders.new_table {
          results = Opts,
        },
        attach_mappings = function(prompt_bufnr, _)
          actions.select_default:replace(function()
            local MultiSelect = action_state.get_current_picker(prompt_bufnr)._multi._entries
            actions.close(prompt_bufnr)
            local UserSelect = {}
            local TABLE_LENG = 0
            for key, _ in pairs(MultiSelect) do
              table.insert(UserSelect, key[1])
              TABLE_LENG = TABLE_LENG + 1
            end
            ---@return string|string[]
            local singleSelect = function()
              if TABLE_LENG == 0 then
                return action_state.get_selected_entry()[1]
              end
              return UserSelect
            end
            callBack(singleSelect())
          end)
          -- keep default keybindings
          return true
        end,
        previewer = showPreview,
        sorter = conf.generic_sorter {},
      })
      :find()
end