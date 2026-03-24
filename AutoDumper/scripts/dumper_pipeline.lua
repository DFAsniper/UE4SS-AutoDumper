print("[AutoDumper] dumper_pipeline.lua (V2) loaded")

local ok, err = pcall(function()
    dofile("Mods/AutoDumper/scripts/config.lua")
end)

if not ok then
    print("[AutoDumper] Failed to load config.lua: " .. tostring(err))
    return
end

if not AutoDumperConfig then
    print("[AutoDumper] AutoDumperConfig is missing")
    return
end

local CONFIG = AutoDumperConfig

-- =========================
-- Logging System (V2.1)
-- =========================

local LOG_FILE = "AutoDumper.log"

-- wipe old log on start
local file = io.open(LOG_FILE, "w")
if file then file:close() end

local function WriteLog(msg)
    local file = io.open(LOG_FILE, "a")
    if file then
        file:write(msg .. "\n")
        file:close()
    end
end

local function GetTime()
    return os.date("%H:%M:%S")
end

local function Log(msg)
    local line = "[" .. GetTime() .. "] [AutoDumper] " .. tostring(msg)
    print(line)
    WriteLog(line)
end

local function PrintDivider()
    local line = "=================================================="
    print(line)
    WriteLog(line)
end

local step = 1

local function StartStep(msg)
    PrintDivider()
    Log("STEP " .. step .. ": " .. msg)
end

local function EndStep(msg)
    Log(msg)
    PrintDivider()
    step = step + 1
end

-- =========================
-- Dumpers (Blocking)
-- =========================

local function RunSDK()
    StartStep("Running SDK Dumper...")
    GenerateSDK()
    EndStep("SDK Dumper finished.")
end

local function RunObjects()
    StartStep("Running Objects Dumper...")
    DumpAllObjects()
    EndStep("Objects Dumper finished.")
end

local function RunUHT()
    StartStep("Running UHT Dumper...")
    GenerateUHTCompatibleHeaders()
    EndStep("UHT Dumper finished.")
end

local function RunStaticMeshes()
    StartStep("Running Static Meshes Dumper...")
    DumpStaticMeshes()
    EndStep("Static Meshes Dumper finished.")
end

local function RunActors()
    StartStep("Running Actors Dumper...")
    DumpAllActors()
    EndStep("Actors Dumper finished.")
end

local function RunUSMAP()
    StartStep("Running USMAP Dumper...")
    DumpUSMAP()
    EndStep("USMAP Dumper finished.")
end

-- =========================
-- Main Pipeline
-- =========================

local function RunPipeline()
    PrintDivider()
    Log("STEP " .. step .. ": Starting AutoDumper V2 pipeline...")
    PrintDivider()
    step = step + 1

    local dumpers = CONFIG.DUMPERS

    if dumpers.SDK and dumpers.SDK.ENABLED then
        RunSDK()
    end

    if dumpers.OBJECTS and dumpers.OBJECTS.ENABLED then
        RunObjects()
    end

    if dumpers.UHT and dumpers.UHT.ENABLED then
        RunUHT()
    end

    if dumpers.STATIC_MESHES and dumpers.STATIC_MESHES.ENABLED then
        RunStaticMeshes()
    end

    if dumpers.ACTORS and dumpers.ACTORS.ENABLED then
        RunActors()
    end

    if dumpers.USMAP and dumpers.USMAP.ENABLED then
        RunUSMAP()
    end

    PrintDivider()
    Log("STEP" .. step .. ": All enabled dumpers completed!!")
    PrintDivider()
    step = step + 1
end

-- =========================
-- Start (keeps your delay)
-- =========================

Log("Initial delay set to " .. tostring(CONFIG.INITIAL_DELAY_MS) .. " ms")

ExecuteWithDelay(CONFIG.INITIAL_DELAY_MS, function()
    RunPipeline()
end)