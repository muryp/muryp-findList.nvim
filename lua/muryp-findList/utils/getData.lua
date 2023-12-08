---@param file string[] string containt file configs like `packgae.json`
---@return table,string,string : {data,dir,file}
local getData = function(file)
  local GET_FILE = vim.fs.find(file, { upward = true })[1]
  local GET_DIR = vim.fs.dirname(GET_FILE)
  local GET_DATA = vim.fn.system([[echo "$(yq '.' ]] .. GET_FILE .. ' -o=j)"')
  local DECODE = vim.fn.json_decode(GET_DATA) ---@type table
  return DECODE, GET_DIR, GET_FILE
end
return getData