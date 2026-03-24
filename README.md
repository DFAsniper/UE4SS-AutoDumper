# UE4SS-AutoDumper (V2 – Blocking Pipeline)

AutoDumper is a UE4SS Lua-based automation tool designed to execute multiple dumpers in a clean, sequential pipeline.

Version 2 uses the blocking execution model built into UE4SS dumpers, eliminating the need for log parsing, polling, and completion detection.

---

## ⚡ Features

- Fully automated dumper execution  
- Config-driven dumper selection  
- Sequential pipeline (no overlap)  
- Clean, structured logging system  
- Separate AutoDumper log file (no UE4SS noise)  
- Automatic log reset each run  
- No UI or keybind interaction required  

---

## 🧩 Supported Dumpers

- SDK Generator  
- Object Dump  
- UHT Compatible Headers  
- Static Mesh Dump  
- Actor Dump  
- USMAP Generator  

---

## 📦 Installation

1. Navigate to your game’s Mods folder:

```
<Game>\Binaries\Win64\Mods\
```

If you don't see a `Mods` folder, create one.

---

2. Copy the `AutoDumper` folder into the Mods directory.

Your structure should look like:

```text
Mods/
  AutoDumper/
    scripts/
      main.lua
      config.lua
      dumper_pipeline.lua
```

---

3. Open (or create if needed):

```
<Game>\Binaries\Win64\Mods\mods.txt
```

Add the following line, then save:

```
AutoDumper : 1
```

Make sure this is above:

```
; Built in Keybinds
```

Then follow the Configuration section below.

---

## ⚙️ Configuration

Before launching the game, open:

```
AutoDumper/scripts/config.lua
```

Inside `config.lua`, enable or disable dumpers:

```lua
true  = run
false = skip
```

---

## 🧠 How It Works

AutoDumper leverages the fact that UE4SS dumpers are **blocking operations**.

This means:

- Each dumper completes before the next begins  
- No need for polling or log-based completion detection  

Execution flow:

```text
SDK → Objects → UHT → Static Meshes → Actors → USMAP
```

---

## 📂 Logging

AutoDumper generates a clean log file in the UE4SS working directory:

```
ReadyOrNot/Binaries/Win64/AutoDumper.log
```

This is the same location as `UE4SS.log`.

- Overwritten each run  
- Timestamped entries  
- Step-based structure  

Example:

```text
==================================================
[11:33:38] STEP 2: Running SDK Dumper...
[11:33:40] SDK Dumper finished.
==================================================
```

---

## 🆕 Notes (V2)

Version 2 replaces the log-based pipeline with a blocking execution model.

- Removes polling and timeout systems  
- Eliminates log parsing complexity  
- Improves reliability and execution speed  

---

## 🚧 Roadmap

### V2
- Config cleanup (remove legacy polling settings)  
- Optional delay between dumpers  
- Output organization  

### V3
- User-friendly config (no Lua editing)  
- Auto-close game after completion  
- Output organization  
- Zip/package dump results  
- Final status summary  

---

## 🙏 Credits

- UE4SS Team — for creating and maintaining the UE4SS framework  
- AutoDumper — built as an automation layer on top of UE4SS dumpers  

---

## 👤 Author

**DFAsniper**

> Built to eliminate unnecessary complexity and let the engine do the work.  
> This project does not modify or replace UE4SS functionality — it automates its existing features.
