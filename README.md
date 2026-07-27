# null0x686F CombatText

![Project Zomboid](https://img.shields.io/badge/Project%20Zomboid-B42-blue)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Performance](https://img.shields.io/badge/Performance-O(1)-brightgreen)

Floating damage numbers and combat HUD for Project Zomboid Build 42.

## Requires
- **null0x686F CoreLib** (hard dependency).

## Features
- Floating damage numbers on `OnWeaponHitCharacter`, red with `!` for critical hits/backstabs.
- Zero-GC render loop (`OnPostRender`).

## Installation (Manual)
1. Download the latest `.zip` from [Releases](../../releases).
2. Extract the `null0x686F_CombatText` folder into `C:\Users\YOUR_USER\Zomboid\mods\`.
3. Install **null0x686F CoreLib** too.
4. Enable both mods in the main menu.
