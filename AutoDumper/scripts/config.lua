-- true = run
-- false = skip
-- Make sure to change these depending on what dumps you want ran!!!
-- Default is set to have all 6 set to true!

AutoDumperConfig = {
    INITIAL_DELAY_MS = 15000,

    DUMPERS = {
        SDK = { ENABLED = true },
        OBJECTS = { ENABLED = true },
        UHT = { ENABLED = true },
        STATIC_MESHES = { ENABLED = true },
        ACTORS = { ENABLED = true },
        USMAP = { ENABLED = true }
    }
}