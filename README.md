# Smart Mousepad

A small wrapper that opens normal user-writable files in Mousepad as your regular user, while automatically elevating only when a file requires root permissions.

This is useful for editing protected system files from a file manager such as Thunar without running your entire desktop session as root.

## How it works

The wrapper checks whether:

- the file itself is writable
- the file's parent directory is writable

If both are writable, Mousepad opens normally as the current user.

If either is not writable, the wrapper launches Mousepad through `plus.sh`, so the editor runs with elevated privileges.

This allows normal files in your home directory to stay under your regular user account while protected files such as files under `/etc` can still be opened with a double-click.

## Setup

1. Copy `plus.sh` and `mousepad-smart.sh` to `~/.local/bin/`   
2. Make the scripts executable: `chmod +x ~/.local/bin/plus.sh ~/.local/bin/mousepad-smart.sh`
3. Add `~/.local/bin` to your `$PATH`   
4. Copy `mousepad-smart.desktop` to `~/.local/share/applications/`   
5. Refresh the desktop application database: `update-desktop-database ~/.local/share/applications`   
6. Set the default application for plain text files: `xdg-mime default mousepad-smart.desktop text/plain`   
7. Set it as the default for other text-based MIME types   
```
    for mime in \
        application/x-shellscript \
        text/x-shellscript \
        application/xml \
        text/xml \
        text/x-csrc \
        text/x-c++src \
        text/x-python \
        text/x-perl \
        text/x-ruby \
        text/x-lua \
        text/x-java \
        text/x-makefile \
        text/css \
        text/markdown \
        application/x-theme
    do
        xdg-mime default mousepad-smart.desktop "$mime"
    done
```
Do not associate `application/x-desktop` if you want your file manager to retain its normal behavior for launching `.desktop` files.

## Why check the parent directory?
Some editors do not save by directly modifying the existing file.
Instead, they may:
1. create a temporary file in the same directory
2. write the new contents to that file
3. replace the original file with the temporary file

Because of this, checking only whether the file itself is writable is not always enough.
The parent directory must also be writable, which is why the wrapper checks:`[ -w "$(dirname "$file")" ]`
This helps the wrapper work correctly with editors that use atomic save behavior.

## Result
After setup, double-clicking supported text files in the file manager should open them in Mousepad with the appropriate privileges:
- user-writable files open normally as your regular user
- protected files automatically open through `plus.sh` with elevated privileges
- normal user-owned files are not unnecessarily edited as root
- Mousepad displays its root warning when an elevated instance is opened
