![preview1](https://r2.fivemanage.com/WX5Hv6yMgODTgG2WF6rml/images/backgroundgithub.png)

# Naufal Printer

Printer Dokumen FiveM (ESX)

# Features 
- Fitur Show Foto di ingame
- Fitur Show bisa lihat sendiri
- Fitur Show bisa lihat sekitarnya
- Fitur Show bisa lihat orang yang di tuju
- Fitur Print berwarna dan tidak bermarna (hitam putih)
- Fitur Validasi harus mempunyai kertas hvs supaya bisa print dokumen

# Installation
- Download Resource
- Masukkan ke dalam resource kamu
- Masukkan item hasil dokumen dan kertas hvs pada item inventory (Using ox_inventory)

```lua
   	['printerdocument'] = {
		label = 'Dokumen',
		weight = 120,
		stack = false,
		close = false,
		description = 'Kertas Dokumen',
		client = {
			export = 'naufal-printer.printer:useitem'
		}
	},

	['kertashvs'] = {
		label = 'Kertas HVS',
		weight = 120,
		stack = true,
		close = true,
		description = 'Kertas HVS'
	},
```

# Shared settings

```lua
Config = {}

Config.Location = {
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
}  
```

- refresh dan start script

## Preview Script
### Preview Input Printer
![previewprinter](https://r2.fivemanage.com/WX5Hv6yMgODTgG2WF6rml/previewprinter1.png)

### Preview Show Dokumen Printer
![previewprinter](https://r2.fivemanage.com/WX5Hv6yMgODTgG2WF6rml/previewprinter2.png)

# Dependencies

- [esx](https://github.com/esx-framework/esx_core)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [ox_lib](https://github.com/overextended/ox_lib) -- Optisional

# Github Star History
[![Star History Chart](https://api.star-history.com/svg?repos=naufalmulyarizki/naufal-calculator&type=Date)](https://star-history.com/#naufalmulyarizki/naufal-calculator&Date)