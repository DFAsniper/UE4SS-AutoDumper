print("[AutoDumper] dumper_pipeline.lua loaded")

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

local LOG_PATH = "UE4SS.log"
local queue = {}
local currentIndex = 1
local pipelineStarted = false

local function SafePrint(msg)
    print("[AutoDumper] " .. tostring(msg))
end

local function ReadEntireFile(path)
    local file = io.open(path, "r")
    if not file then
        return nil
    end

    local content = file:read("*a")
    file:close()
    return content
end

local function LogContains(text)
    local content = ReadEntireFile(LOG_PATH)
    if not content then
        return false
    end

    return string.find(content, text, 1, true) ~= nil
end

local function BuildQueue()
    local dumpers = {
        {
            key = "SDK",
            name = "SDK",
            done_text = "SDK generated in",
            run = function()
                SafePrint("Starting SDK generation...")
                GenerateSDK()
                SafePrint("GenerateSDK() called")
            end
        },
        {
            key = "OBJECTS",
            name = "Objects",
            done_text = "Dumping GUObjectArray took",
            run = function()
                SafePrint("Starting object dump...")
                DumpAllObjects()
                SafePrint("DumpAllObjects() called")
            end
        },
        {
            key = "UHT",
            name = "UHT",
            done_text = "Generating UHT compatible headers took",
            run = function()
                SafePrint("Starting UHT generation...")
                GenerateUHTCompatibleHeaders()
                SafePrint("GenerateUHTCompatibleHeaders() called")
            end
        },
        {
            key = "STATIC_MESHES",
            name = "Static Meshes",
            done_text = "Finished dumping CSV of all loaded static mesh actors, positions and mesh properties",
            run = function()
                SafePrint("Starting static meshes dump...")
                DumpStaticMeshes()
                SafePrint("DumpStaticMeshes() called")
            end
        },
        {
            key = "ACTORS",
            name = "Actors",
            done_text = "Finished dumping CSV of all loaded actor types, positions and mesh properties",
            run = function()
                SafePrint("Starting actor dump...")
                DumpAllActors()
                SafePrint("DumpAllActors() called")
            end
        },
        {
            key = "USMAP",
            name = "USMAP",
            done_text = "Mappings Generation Completed Successfully!",
            run = function()
                SafePrint("Starting USMAP generation...")
                DumpUSMAP()
                SafePrint("DumpUSMAP() called")
            end
        }
    }

    for _, dumper in ipairs(dumpers) do
        local cfg = CONFIG.DUMPERS[dumper.key]
        if cfg and cfg.ENABLED then
            table.insert(queue, {
                key = dumper.key,
                name = dumper.name,
                done_text = dumper.done_text,
                run = dumper.run,
                timeout_ms = cfg.TIMEOUT_MS or CONFIG.DEFAULT_TIMEOUT_MS
            })
        end
    end
end

local function StartNextDumper()
    local dumper = queue[currentIndex]

    if not dumper then
        SafePrint("Pipeline complete. No more dumpers to run.")
        return
    end

    SafePrint("Running dumper " .. currentIndex .. "/" .. #queue .. ": " .. dumper.name)

    local startTime = os.clock()
    dumper.run()

    local function PollForCompletion()
        local elapsedMs = math.floor((os.clock() - startTime) * 1000)

        if LogContains(dumper.done_text) then
            SafePrint(dumper.name .. " finished. Detected completion text: " .. dumper.done_text)
            currentIndex = currentIndex + 1
            ExecuteWithDelay(CONFIG.POLL_INTERVAL_MS, StartNextDumper)
            return
        end

        if elapsedMs >= dumper.timeout_ms then
            SafePrint(dumper.name .. " timed out after " .. tostring(dumper.timeout_ms) .. " ms")
            currentIndex = currentIndex + 1
            ExecuteWithDelay(CONFIG.POLL_INTERVAL_MS, StartNextDumper)
            return
        end

        ExecuteWithDelay(CONFIG.POLL_INTERVAL_MS, PollForCompletion)
    end

    ExecuteWithDelay(CONFIG.POLL_INTERVAL_MS, PollForCompletion)
end

local function StartPipeline()
    if pipelineStarted then
        SafePrint("Pipeline already started, skipping duplicate launch")
        return
    end

    pipelineStarted = true
    BuildQueue()

    if #queue == 0 then
        SafePrint("No dumpers are enabled in config.lua")
        return
    end

    SafePrint("Queue built with " .. tostring(#queue) .. " enabled dumper(s)")
    StartNextDumper()
end

SafePrint("Initial delay set to " .. tostring(CONFIG.INITIAL_DELAY_MS) .. " ms")
ExecuteWithDelay(CONFIG.INITIAL_DELAY_MS, StartPipeline)