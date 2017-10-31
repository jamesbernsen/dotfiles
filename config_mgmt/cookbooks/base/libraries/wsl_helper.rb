# Helpers for Windows Subsystem for Linux (WSL)

module BaseLib

  module WSL
    include Chef::Mixin::ShellOut

    def is_WSL?
      return (node['kernel']['name'].include? "Linux" and node['os_version'].include? "Microsoft")
    end

    def choco_pkg_local_install?(pkg_name)
      cmd = shell_out!("choco.exe list --localonly -r #{pkg_name}", {:environment => { "PATH" => "/mnt/c/ProgramData/chocolatey/bin" }, :returns => [0]})
      return (cmd.stdout =~ /#{RegExp.escape(pkg_name)}/)
    end

    def choco_pkgs_locally_installed
      cmd = shell_out!('choco.exe list --localonly -r', {:environment => { "PATH" => "/mnt/c/ProgramData/chocolatey/bin" }, :returns => [0]})
      list_text = cmd.stdout
      list_text.gsub(/\r\n?/, "\n")
      pkg_lines = list_text.split("\n")
      pkg_ver = Hash.new
      pkg_lines.each do |pkg_line|
        pkg_ver[ pkg_line.split("|")[0] ] = pkg_line.split("|")[1]
      end
      return pkg_ver
    end

    def choco_pkg_local_version(pkg_name)
      cmd = shell_out!("choco.exe list --localonly -r #{pkg_name}", {:environment => { "PATH" => "/mnt/c/ProgramData/chocolatey/bin" }, :returns => [0]})
      pkg_line = cmd.stdout
      pkg_line = pkg_line.gsub(/\r|\n/, "")
      ver = pkg_line.split("|")[1]
      return ver
    end
  end

end
