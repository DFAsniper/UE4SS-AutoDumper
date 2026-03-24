AutoDumperConfig = {
    INITIAL_DELAY_MS = 15000,
    POLL_INTERVAL_MS = 2000,
    DEFAULT_TIMEOUT_MS = 120000,

    DUMPERS = {
        SDK = {
            ENABLED = true,
            TIMEOUT_MS = 120000
        },
        OBJECTS = {
            ENABLED = true,
            TIMEOUT_MS = 120000
        },
        UHT = {
            ENABLED = true,
            TIMEOUT_MS = 180000
        },
        STATIC_MESHES = {
            ENABLED = true,
            TIMEOUT_MS = 120000
        },
        ACTORS = {
            ENABLED = true,
            TIMEOUT_MS = 120000
        },
        USMAP = {
            ENABLED = true,
            TIMEOUT_MS = 120000
        }
    }
}