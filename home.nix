{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tuommaki";
  home.homeDirectory = "/home/tuommaki";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.bc
    pkgs.git
    pkgs.go
    pkgs.helix
    pkgs.htop 
    pkgs.netcat
    pkgs.tmux
    pkgs.unzip

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/tuommaki/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Tuomas Makinen";
    userEmail = "tuommaki@gmail.com";
  };

  home.file = {
    ".config/helix/config.toml" = {
      text = ''
      [editor]
      line-number = "relative"
      bufferline = "multiple"
      true-color = true

      [keys.normal]
      C-t = "jump_backward"
      '';
    };

    ".config/helix/languages.toml" = {
      text = ''
      [[language]]
      name = "go"
      config = { goimports = true, gofumpt = true, staticcheck = true, analyses = { unusedparams = true, unreachable = true } }
      '';
    };

    ".tmux.conf" = {
      text = ''
      # ~/.tmux.conf

      # Set non-default prefix due to conflict with Vi
      unbind C-b
      set -g prefix C-o

      # Allow for long enough backlog
      set-option -g history-limit 131072

      # Use vi mode
      set-option -g mode-keys vi

      # Colors
      set -g default-terminal "screen-256color"

      # Notify on visual activity on other buffers
      set-option -g visual-activity on

      # Open a man page
      bind-key / command-prompt "split-window -h 'exec man %%'"

      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
      bind-key -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
      bind-key -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
      bind-key -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"
      bind-key -n C-\\ if-shell "$is_vim" "send-keys C-\\" "select-pane -l"
      '';
    };
  };
}
