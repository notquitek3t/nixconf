{ pkgs, lib, ... }: {

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_lqx;
  boot.kernelParams = [ "i915.enable_guc=3" ];
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];


  # Self Maintenance
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };

  # Support
  fonts.packages = with pkgs; [ nerd-fonts noto-fonts noto-fonts-cjk-sans liberation_ttf fira-code fira-code-symbols ];
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  programs.dconf.enable = true;
  services.flatpak.enable = true;
  boot.binfmt.preferStaticEmulators = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  hardware.graphics.enable32Bit = true;
  programs.nix-ld.enable = true;
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # graphics
  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # Required for modern Intel GPUs (Xe iGPU and ARC)
      intel-media-driver     # VA-API (iHD) userspace
      vpl-gpu-rt             # oneVPL (QSV) runtime

      # Optional (compute / tooling):
      intel-compute-runtime  # OpenCL (NEO) + Level Zero for Arc/Xe
      # NOTE: 'intel-ocl' also exists as a legacy package; not recommended for Arc/Xe.
      # libvdpau-va-gl       # Only if you must run VDPAU-only apps
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";     # Prefer the modern iHD backend
    # VDPAU_DRIVER = "va_gl";      # Only if using libvdpau-va-gl
  };



  # X11
  services.xserver = {
    videoDrivers = [ "modesetting" "amdgpu" ];
    enable = true;   
    xkb = {
      layout = "us";
      variant = "";
    };
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    libinput.enable = true;
    #windowManager.i3.enable = true;
    windowManager.i3 = {
      #package = pkgs.i3-gaps;
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
	i3lock
	i3blocks
      ];
    };
  };
  services.displayManager.defaultSession = "xfce";

  services.picom = {
    enable = true;
    fade = true;
    #vSync = true;
    shadow = true;
    fadeDelta = 4 ;
    inactiveOpacity = 1;
    activeOpacity = 1;
    #backend = "glx";
    settings = {
      blur = {
        #method = "dual_kawase";
        #background = true;
        strength = 5;
      };
    };
  };

  # desktop oriented bluetooth settings
  hardware.bluetooth = {
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        KernelExperimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
        ControllerMode = "bredr";
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  # Sunshine (remote desktop)
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
    wireplumber.extraConfig.bluetoothEnhancements = {
      "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" "a2dp_sink" "a2dp_source" "bap_sink" "bap_source" ];
      };
    };
  };

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.kdeconnect.enable = true;
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      Preferences = {
        "cookiebanners.service.mode.privateBrowsing" = 2; # Block cookie banners in private browsing
        "cookiebanners.service.mode" = 2; # Block cookie banners
        "privacy.donottrackheader.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.trackingprotection.emailtracking.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
      };
      ExtensionSettings = {
        "jid1-ZAdIEUB7XOzOJw@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-for-firefox/latest.xpi";
          installation_mode = "force_installed";
        };
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
  environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";

  users.users.k3t = {
    packages = with pkgs; [
      joplin-desktop
      qbittorrent
      kdePackages.kate
      jellyfin-desktop
      flatpak
      vscode.fhs
      signal-desktop
      spotify
    ];
  };
}
