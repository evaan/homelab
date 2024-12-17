{ inputs, pkgs, ... }: {
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];


  services.minecraft-servers = {
    enable = true;
    eula = true;
    
    servers = {
      paper = {
        enable = true;
        package = pkgs.paperServers.paper;
        jvmOpts = "-Xms128M -Xmx8192M";
        openFirewall = true;
      };
    };
  };
}