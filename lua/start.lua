-- Author: Nova Senco
-- Last Change: 05 March 2022

local start = {}

-- by default, don't auto-open quickfix if error loading lua file
start.autoqf = false

function start:tryload(name)
  -- try to load a lua file in runtimepath
  --
  --   return table (error) keys:
  --     file: full path to lua file that failed to load ($XDG_CONFIG_HOME
  --           assumed if no file exists)
  --     err: error message
  --     lnum: line number if relevant
  --
  --   args:
  --     name: name of file to load from $rtp/lua/`name`.lua
  --
  --   return:
  --     nil if successful load;
  --     table with file, err, lnum keys if failed

  -- protected call + require lua file
  local ld, err = pcall(require, name)

  -- if ld is true, then successful load; return nil
  if ld then return nil end

  -- try to find the lua file in &runtimepath
  local file = nil
  for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
    local path = path..'/lua/'..name..'.lua'
    if vim.fn.filereadable(path) ~= 0 then
      file = path
      break
    end
  end

  local lnum = nil -- line number for error
  if file then

    -- try find line number ...
    -- 1: strip filename length from beginning of file
    -- 2: grab anything that looks like s/^:(\d+):/\1/
    local num, numpos = string.gsub(string.sub(err, #file + 1), "^:(%d+):.*", "%1", 1)
    if numpos == 1 then
      lnum = num
    end

  else -- file not found ...

    -- set error to better msg, 'file not found', since file DNE
    err = "lua file not found; did you mean to add this file?"

    -- assume user meant to add to $XDG_CONFIG_HOME/nvim/lua/*.lua
    file = vim.fn.stdpath("config").."/lua/"..name..".lua"

  end

  return {
    file = file, -- lua file pertaining to error
    err = err,   -- error message
    lnum = lnum, -- line number pertaining to error if relevant
  }

end

function start:loadall(names)
  -- load all lua files
  --
  -- args:
  --  names: array of lua files to try to load
  --
  -- return: nil

  -- try to load all names; add each error to errors
  local errors = {}
  for _, name in ipairs(names) do
    local ld = start:tryload(name)
    if ld then table.insert(errors, { filename=ld.file, type="E", text=ld.err, lnum=ld.lnum }) end
  end

  -- set quickfix list to errors if any
  if #errors ~= 0 then
    vim.fn.setqflist(errors) -- set quickfix list to errors
    if start.autoqf then
      vim.api.nvim_command("bot copen") -- auto-open quickfix list?
    end
  end
end

function start:init(p)
  -- load all lua/init/*.lua in config directory
  --
  -- args:
  --  p: path to use instead of vim.fn.stdpath'config'..'/lua/init/'; ensure a
  --     trailing slash is appended, and `p` must be an absolute path
  --
  -- eg, start:init(vim.fn.stdpath'config'..'/startup/') will load all lua files
  --     in ~/.config/nvim/startup/

  local ls = {}                              -- lua files list
  local p  = p and p or vim.fn.stdpath('config')..'/lua/init/' -- path to init dir
  local fd = vim.loop.fs_opendir(p, nil, 10) -- file descriptor
  local fs = vim.loop.fs_readdir(fd)         -- files in p

  -- build ls table with names of files in init dir
  while fs do
    for _,f in ipairs(fs) do
      if f.type == 'file' and f.name:match'.lua$' then
        table.insert(ls, 'init/'..f.name:sub(1, -5))
      end
    end
    fs = vim.loop.fs_readdir(fd)
  end

  start:loadall(ls)
end

return start

