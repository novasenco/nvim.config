-- Author: Nova Senco
-- Last Change: 18 March 2022

local start = {}

-- by default, don't auto-open quickfix if error loading lua file
local autoqf = false

function start.config(cfg)
  if type(cfg) == 'table' then
    autoqf = cfg.autoqf ~= false and cfg.autoqf ~= nil
  end
  return start
end

function start.tryload(name, errors)
  -- try to load a lua file in runtimepath
  --
  --   args:
  --     name: name of file to load from $rtp/lua/`name`.lua
  --     errrs: list of errors to append to for qflist
  xpcall(require, function(err)
    local i = 1
    local init = vim.env.MYVIMRC

    local lnum = err:match('^/.-:(%d): ', 1)
    local fname
    if lnum then
      local _,fend = err:find('^/.-:%d:')
      fend = fend - 2 - #tostring(lnum)
      fname = err:sub(1, fend)
    else
      err = 'Failed to load init '..init..': '..err
      fname = init
    end
    table.insert(errors, {
      type     = 'E',
      filename = fname,
      text     = err,
      lnum     = lnum
    })

    while true do
      i = i + 1
      local info = debug.getinfo(i)
      if not info then break end
      if info.currentline ~= -1 and info.linedefined == 0 and info.short_src ~= init and info.what == 'main' then
        -- some other required file in the stack trace failed; append to errors
        table.insert(errors, {
          type     = 'E',
          filename = info.short_src,
          text     = err,
          lnum     = info.currentline
        })
      end
    end
  end, name)
end

function start.loadall(names)
  -- load all lua files
  --
  -- args.
  --  names: array of lua files to try to load
  --
  -- return: nil

  -- try to load all names; add each error to errors
  -- local errors = vim.fn.getqflist()
  local errors = {}
  for _, name in ipairs(names) do
    start.tryload(name, errors)
  end

  -- set quickfix list to errors if any
  if #errors ~= 0 then
    vim.fn.setqflist(errors, 'a') -- set quickfix list to errors
    if autoqf then
      -- auto-open quickfix list?
      local win = vim.api.nvim_get_current_win()
      vim.cmd'botright copen'
      local nlines = math.max(#errors, vim.fn.line('$')) + 1
      if vim.fn.winheight('') > nlines then
        vim.cmd(nlines .. 'wincmd _')
      end
      vim.api.nvim_set_current_win(win)
    end
    vim.cmd[[
      echohl ErrorMsg
      echon 'There were errors opening nvim. See qf list. :copen'
      echohl None
    ]]
  end
end

function start.init(p)
  -- load all lua/init/*.lua in config directory
  --
  -- args:
  --  p: path to use instead of vim.fn.stdpath'config'..'/lua/init/'; ensure a
  --     trailing slash is appended, and `p` must be an absolute path
  --
  -- eg, start.init(vim.fn.stdpath'config'..'/startup/') will load all lua files
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

  start.loadall(ls)
end

return start

