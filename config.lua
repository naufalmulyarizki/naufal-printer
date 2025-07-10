lib.locale() -- untuk mendeteksi locale resource

Config = {}
Config.Target = 'ox_target' -- Config target (ox_target, qtarget, bttarget, qb-target)
Config.NUI = false -- Mau menggunakan nui atau context ox_lib
Config.Location = { -- Edit the various interaction points for players or create new ones
    ["printer"] = {
        [1] = {
            coords = vec3(309.7512, -583.7197, 43.0685),
            size = vec3(1.0, 1.0, 5.85),
            debug = false,
            radius = 1,
            rotation = 50,
            groups = {
                ['ambulance'] = 1,
            }
        },
    },
}
Config.PropTarget = false -- Mau menggunakan nui atau context ox_lib
Config.printers = { -- Prop interaksi printer
    `prop_printer_01`,
    `prop_printer_02`,
    `v_res_printer`
}