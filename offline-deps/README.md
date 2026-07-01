# Offline build dependencies (Windows / NSIS)

This network blocks GitHub, so electron-builder cannot download the prebuilt
binaries it needs to build the Windows installer. Download these **3 files** on
any machine/network that can reach GitHub (or over VPN), then drop each one into
the matching folder below. After that, run `scripts/build-win-offline.sh`.

| # | Download URL | Save into this folder as |
|---|--------------|--------------------------|
| 1 | https://github.com/electron/electron/releases/download/v22.3.27/electron-v22.3.27-win32-x64.zip | `offline-deps/22.3.27/electron-v22.3.27-win32-x64.zip` |
| 2 | https://github.com/electron-userland/electron-builder-binaries/releases/download/nsis-3.0.4.1/nsis-3.0.4.1.7z | `offline-deps/nsis-3.0.4.1/nsis-3.0.4.1.7z` |
| 3 | https://github.com/electron-userland/electron-builder-binaries/releases/download/nsis-resources-3.4.1/nsis-resources-3.4.1.7z | `offline-deps/nsis-resources-3.4.1/nsis-resources-3.4.1.7z` |

Keep the exact filenames. Then:

```bash
bash scripts/build-win-offline.sh
```

The finished installer appears in `dist/` as `PDF Font Inspector Setup 1.0.0.exe`.
