# uefi secure boot stuff
- Platform Key (PK)
    - RSA-2048
    - Used to verify changes to UEFI environment variables and to KEK, DB and DBX.
    - Cannot be used to sign binaries
    - Only one may exist per machine
    - For best security: do not reuse across machines
- Key Exchange Key (KEK)
    - RSA-2048
    - Used to verify changes to DB and DBX
    - Do not sign binaries with KEKs, even though this is possible
        - Harder to revoke
    - Multiple may exist per machine
    - Might also be reused across machines
- Allow list database (DB)
    - RSA-2048 or SHA-256
    - Used to verify binaries, either through signature verification or checking if hash is trusted
- Deny list database (DBX)
    - Like DB, but for denying
    - Useful for denying specific binaries (with a hash) without having to revoke the key used for signing it (which would deny all other binaries signed with it)

(Additionally, the pre-bootloader shim (for Linux) uses Machine Owner Key (MOK, MOKX) analogous to DB and DBX.)

Microsoft keys: a KEK and DB/DBX entries

fast/automatic/minimal boot modes may compromise system integrity, prefer full/thorough boot

No legacy fallback: disable CSM (Compatibility Support Module)

Use PCR 7 for system encryption; this PCR changes when UEFI SecureBoot configuration changes (keys or other)

No key migration for TPM! This means that the SRK's (Storage Root Key) private key is never exposed anywhere outside the TPM.

# threats
- realistic: someone steals laptop

# goals
- type only a single password on boot
- also require TPM PCR 7 to match
- also possibly USB

systemd-cryptenroll --tpm2-with-pin

# preparations
## Disk erasure
```sh
# $disk = nvme disk (/dev/nvme1n1)
nvme format -s 2 $disk
# blkdiscard --secure was not supported
blkdiscard $disk
```
Might also want to fill the drive with random data and disable TRIM.
I didn't. This makes it possible to see certain things (like filesystem type) without the encryption key.

## USB boot stick
(I switched to having the ESP on an internal SSD because the USB drive was pretty slow.
I still have the LUKS header on the USB drive.)
```sh
# $usb = usb stick (/dev/sdb)
fdisk $usb
# g (GPT), n +1GB, t 1 (EFI), w
mkfs.fat -F 32 /dev/sdb1
mkdir mnt
mount $usb mnt
fatlabel $usb USBOOT # pun
```

## LUKS
```sh
cryptsetup luksFormat --header mnt/header.img $disk
# forgot --allow-discards, so add it:
cryptsetup --allow-discards open --header mnt/header.img $disk notroot
cryptsetup --allow-discards --persistent refresh --header mnt/header.img notroot
# check for discard flag
cryptsetup luksDump --header mnt/header.img $disk

umount mnt
rmdir mnt
```

## File system
```sh
# root on tmpfs
mount -t tmpfs none /mnt
mkdir -p /mnt{boot,persist,local,notroot}
mount $usb /mnt/boot

# main file system
mkfs.btrfs -L notroot /dev/mapper/notroot
mount /dev/mapper/notroot /mnt/notroot
cd /mnt/notroot
btrfs subvolume create nix
btrfs subvolume create persist
btrfs subvolume create local
btrfs subvolume create tmp
cd /mnt
sudo umount notroot
mount -o subvol=nix,noatime /dev/mapper/notroot /mnt/nix
mount -o subvol=persist,noatime /dev/mapper/notroot /mnt/persist
mount -o subvol=local,noatime /dev/mapper/notroot /mnt/local
mount -o subvol=tmp,noatime /dev/mapper/notroot /mnt/tmp
```

## Config
```sh
nixos-generate-config --root /mnt
# edit stuff

# hash password
sh bin/mypasswd.sh | tee /mnt/local/password
```

## Install
```sh
nixos-install --root /mnt --flake /etc/nixos#thonkpad --cores 0 --no-root-password
```

