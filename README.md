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
Mods/ AutoDumper/ scripts/ main.lua , config.lua , dumper_pipeline.lua
3. Open (or create) `Mods/mods.txt`
4. Add this line: " AutoDumper : 1 " -- Make sure this stays above the " ; Built in Keybinds.. "
5. Save and launch the game.

## Configuration

Before launching the game, open: AutoDumper/scripts/config.lua
 Inside 'config.lua' enable or disable the dumpers you want to run
 true = run
 false = skip

## How It Works

Builds a queue of enabled dumpers
Runs each dumper in sequence
Monitors UE4SS.log for completion phrases
Automatically advances to the next dumper

## Notes (V1)

Reads the full UE4SS.log for completion detection
Old log entries may trigger false positives
!!~~ Best used with a fresh session/log ~~!!

## Roadmap

V2
Ignore old log entries
Cleaner logging output
Optional per-dumper delays

V3
User-friendly config (no Lua editing)
Auto-close game after completion
Output organization
Zip/package dump results
Status summary

## Credits

- UE4SS Team — for creating and maintaining the UE4SS framework that makes this tool possible  
- AutoDumper — built as an automation layer on top of UE4SS dumpers  

## Author
DFAsniper

~~ This project does not modify or replace UE4SS functionality. It simply automates the use of its existing features. ~~
