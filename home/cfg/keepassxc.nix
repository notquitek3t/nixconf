{
 programs.keepassxc = {
    autostart = true;
    enable = true;
    settings = {
      # For available settings, see https://github.com/keepassxreboot/keepassxc/blob/develop/src/core/Config.cpp
      FdoSecrets.Enabled = true; # Enable Secret Service Integration
      SSHAgent.Enabled = true;
      SSHAgent.UseOpenSSH = true;
      Browser.Enabled = true;
    };
  };
  xdg.autostart.enable = true;
}
