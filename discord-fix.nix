self: super:
{
  discord = super.discord.overrideAttrs (_: {
    src = builtins.fetchTarball {
      url = "https://dl.discordapp.net/apps/linux/0.0.24/discord-0.0.24.tar.gz";
      sha256 = "087p8z538cyfa9phd4nvzjrvx4s9952jz1azb2k8g6pggh1vxwm8";
    };
  });
}
