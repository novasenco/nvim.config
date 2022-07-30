nvim.config
===========
my `nvim` config for `v:version >= 700` (>= ~ +1000 patches)

The config is documented. I hope it inspires you.

+ [plugin/](plugin/) is the most important directory; it loads all of my lua and
  vim scripts.
    + [plugin/maps.lua](plugin/maps.lua) probably has the most interesting stuff
+ [after/](after/) mostly has ftplugin scripts that set up buffers correcly per
  their filetype
+ [autoload/](autoload/) has magic autoload functions that only get loaded when
  they're called and thus lighten the startup load
+ [lua/](lua/) has some lua scripts that only get loaded when `require`d
  + [lua/snippets/](lua/snippets/) has my snippets
  + [lua/utils/](lua/utils/) has some utility scripts to help create maps and
    autocmds in lua
