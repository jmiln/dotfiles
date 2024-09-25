local wezterm = require("wezterm")
local M = {}

M.basename = function(path) -- get filename from path
  if type(path) ~= "string" then
    return nil
  end
  if M.is_windows then
    return path:gsub("(.*[/\\])(.*)", "%2") -- replace (path/ or path\)(file) with (file)
  else
    return path:gsub("(.*/)(.*)", "%2")
  end -- replace (path/)(file)          with (file)
end

local function is_found(str, pattern)
   return string.find(str, pattern) ~= nil
end

M.platform = function()
   local is_win = is_found(wezterm.target_triple, 'windows')
   local is_linux = is_found(wezterm.target_triple, 'linux')
   local is_mac = is_found(wezterm.target_triple, 'apple')
   local os = is_win and 'windows' or is_linux and 'linux' or is_mac and 'mac' or 'unknown'
   return {
      os = os,
      is_win = is_win,
      is_linux = is_linux,
      is_mac = is_mac,
   }
end


M.get_cwd_hostname = function(pane, platform)
    local cwd, hostname = "", ""
    local cwd_uri = pane:get_current_working_dir()
    local home = (os.getenv "USERPROFILE" or os.getenv "HOME" or wez.home_dir or ""):gsub("\\", "/")
    if cwd_uri then
        if type(cwd_uri) == "userdata" then
            -- Running on a newer version of wezterm and we have
            -- a URL object here, making this simple!

            ---@diagnostic disable-next-line: undefined-field
            cwd = cwd_uri.file_path
        else
            -- an older version of wezterm, 20230712-072601-f4abf8fd or earlier,
            -- which doesn't have the Url object
            cwd_uri = cwd_uri:sub(8)
            local slash = cwd_uri:find "/"
            if slash then
                hostname = cwd_uri:sub(1, slash - 1)
                -- and extract the cwd from the uri, decoding %-encoding
                cwd = cwd_uri:sub(slash):gsub("%%(%x%x)", function(hex)
                    return string.char(tonumber(hex, 16))
                end)
            end
        end

        if platform.is_win then
            cwd = cwd:gsub("/" .. home .. "(.-)$", "~%1")
        else
            cwd = cwd:gsub(home .. "(.-)$", "~%1")
        end

    end

    return cwd, hostname
end

return M
