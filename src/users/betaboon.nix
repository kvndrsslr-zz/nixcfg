{ config, pkgs, ... } :
{

  users.extraUsers.betaboon = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    extraGroups = ["wheel" "audio"];

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+EvnWPnkDBgWJA9cnhmZhoVlR7nUG1cW7Bs9PmaiVocc+UBdVKi4JahgdM1PS9Cl8c20rdv1eoASeJtDQToDK+N4kTJQjxW0D7gpS/pDYrHEb1UOedpT/ZbbuPrMFYCOkCQaBP30Vz308+c7CIXoAzd6mIiulcpvfylyivdhKC7Q1PFCqJNwRM8i7CCSwNtjpBFpGndTl5TqOu9ktt9EfjSdORDRAG6589jHbEeSrIsAUKP/s+IBjNJcxO/ys6m7i56MWFFKm+41+H5VkK/Ai6HL3Y8etcCvKwBQJm8gbnnpq3D1aoCFMwRbuEIQTHDyBEqzkceSBaE4BI5ydiaJh8xDpcLjZB58KbSJDnA5TCJrIJr0gmycTEkS/05uGHptQdMfE9pq6BRVfMA3RTe7XGe2r6CdHbKTCSHIX7smQjxOO/3iXRxy7/xetaEgGMT1DRQV4KXt2HMtf3s4D3fw4VDWyFTLdFZdrKqc3nSM4l7ldtp/Yayj10PF/t3vGCzOzR4wRbY9I2iVHto0TC578fcE+1V9+lld9SS/0XSdfgBen2aLzIvkRlWCzzLjvkeskyTRzjaTe5PqsNnaDx1cX9h5mjsmrJzVB4r2X5tRTMyNDMygRNV3sRCvmtSjQdIMVKanwKNqH4qwL2+Vb7LdSKZj9IPADDJbGMuXqJBk00Q== betaboon@monarch"
    ];

    shell = pkgs.zsh;
    home = "/home/betaboon";
  };

}
