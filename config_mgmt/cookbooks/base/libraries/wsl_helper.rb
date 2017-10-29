# Helpers for Windows Subsystem for Linux (WSL)

module BaseLib
	module WSL

		include Chef::Mixin::ShellOut

		def is_WSL?
			return (node['kernel']['name'].include? "Linux" and node['os_version'].include? "Microsoft")
		end

		def choco_pkg_local_install?(pkg_name)
			cmd = shell_out!('choco.exe list --localonly -r', {:environment => { "PATH" => "/mnt/c/ProgramData/chocolatey/bin" }, :returns => [0]})
			return (cmd.stdout =~ /#{RegExp.escape(pkg_name)}/)
		end

		def choco_pkgs_locally_installed
			cmd = shell_out!('choco.exe list --localonly -r', {:environment => { "PATH" => "/mnt/c/ProgramData/chocolatey/bin" }, :returns => [0]})
			list_text = cmd.stdout
			list_text.gsub(/\r\n?/, "\n")
			app_lines = list_text.split("\n")
			app_ver = Hash.new
			app_lines.each do |app_line|
				app_ver[ app_line.split("|")[0] ] = app_line.split("|")[1]
			end
			return app_ver
		end

	end
end
