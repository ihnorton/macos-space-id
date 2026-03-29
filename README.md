# macos-space-id

A macOS menu bar app that lets you assign names to Spaces (virtual desktops). The current space's name is always visible in the menu bar.

- **Left-click** the menu bar item to rename the current space
- **Right-click** for a Quit option

| | |
|---|---|
| ![](assets/screenshot1.png) | ![](assets/screenshot2.png) |

## Requirements

- macOS 13 Ventura or later
- Xcode Command Line Tools (`xcode-select --install`)

## Build & Run

```sh
make run
```

## Install (with auto-start at login)

```sh
make launchagent-install
```

To remove the auto-start:

```sh
make launchagent-uninstall
```
