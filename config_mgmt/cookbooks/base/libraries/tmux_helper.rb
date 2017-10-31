# Helpers for Tmux

module Tmux
  include Chef::Mixin::ShellOut

  def is_installed?
    fname = '/usr/local/bin/tmux'
    return (
      ::File.exist?(fname) &&
      ::File.file?(fname) &&
      ::File.executable?(fname)
    )
  end

  def installed_ver
    cmd = shell_out!('tmux -V', {:environment => { "PATH" => "/usr/local/bin" }, :returns => [0]})
    cmd_out = cmd.stdout.gsub(/\r|\n/, "")
    installed_ver = cmd_out.gsub(/tmux /, '')
    return installed_ver
  end
end
