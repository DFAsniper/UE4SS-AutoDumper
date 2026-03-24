# UE4SS AutoDumper

AutoDumper is a Lua-based automation mod for UE4SS that sequentially runs built-in dumpers and advances only after detecting completion via UE4SS.log.

## Features

- Fully automated dumper execution
- Config-driven dumper selection
- Sequential pipeline (no overlap)
- Log-based completion detection
- No UI or keybind interaction required

## Supported Dumpers

- SDK Generator
- Object Dump
- UHT Compatible Headers
- Static Mesh Dump
- Actor Dump
- USMAP Generator

## Installation

1. Navigate to your game's Mods folder: <Game>\Binaries\Win64\Mods\
2. Copy the `AutoDumper` folder into the existing `Mods` directory.
Final structure should look like:
Mods/
├── AutoDumper/
│ └── scripts/
│ ├── main.lua
│ ├── config.lua
│ └── dumper_pipeline.lua
3. Open (or create) `Mods/mods.txt`
4. Add this line: AutoDumper : 1
5. Save and launch the game.
