print("[AutoDumper] main.lua loaded")

local ok, err = pcall(function()
    dofile("Mods/AutoDumper/scripts/dumper_pipeline.lua")
end)

if not ok then
    print("[AutoDumper] Failed to load dumper_pipeline.lua: " .. tostring(err))
end