Encrypt Folder
==============

Creates a script that encrypts a folder on a machine.

*Please use caution!*  Folders that are encrypted with this formula will not be able to be decrypted.  A single-use password is randomly generated and a folder is mounted on top of itself with ecryptfs.  This means the contents of the folder will be encyrpted when stored at rest, but there is no way to decrypt the files once you reboot the machine.

Encryption keys are stored entirely in RAM.  It is theoretically possible for someone to hack a machine and scan the memory for the encryption keys, but if they can do that then the attacker can already access the files directly.

Examples

    wickFormula encrypt-folder

    # Once the program is installed on the system, you may encrypt a folder:
    mkdir /mnt/encrypted
    /usr/local/bin/encrypt-folder /mnt/encrypted

    # This removes the encryption.
    umount /mnt/encrypted

    # Encrypted files still persist in /mnt/encrypted/.ecryptfs
    # You may choose to wipe them.  The script does not require that you
    # remove them before remounting the encrypted folder again.
    rm -r /mnt/encrypted/.ecryptfs

Returns nothing.


