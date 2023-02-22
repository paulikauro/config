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

# logseq
- Ctrl+Shift+P and "Install from plugins.edn" to finish installation
- [ ] TODO: nix it?
