RegisterNetEvent('FinishMoneyCheckForVeh')
RegisterNetEvent('vehshop:spawnVehicle')
local vehshop_blips = {}
local financedPlates = {}
local inrangeofvehshop = false
local currentlocation = nil
local boughtcar = false
local vehicle_price = 0
local backlock = false
local firstspawn = 0
local commissionbuy = 0
local insideVehShop = false
local rank = 0

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
local currentCarSpawnLocation = 0
local ownerMenu = false

local vehshopDefault = {
	opened = false,
	title = "Vehicle Shop",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 250, type = 1 },
	menu = {
		x = 0.14,
		y = 0.15,
		width = 0.12,
		height = 0.03,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.29,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Vehicles", description = ""},
				{name = "Cycles", description = ""},
			}
		},
		["vehicles"] = {
			title = "VEHICLES",
			name = "vehicles",
			buttons = {
				{name = "Job Vehicles", description = ''},
				{name = "Compacts", description = ''},
				{name = "Coupes", description = ''},
				{name = "Sedans", description = ''},
				{name = "Sports", description = ''},
				{name = "Sports Classics", description = ''},
				{name = "Super", description = '', rank = 5},
				{name = "Muscle", description = ''},
				{name = "Off-Road", description = ''},
				{name = "SUVs", description = ''},
				{name = "Vans", description = ''},
				
			}
		},
		["jobvehicles"] = {
			title = "job vehicles",
			name = "job vehicles",
			buttons = {
				{name = "Taxi Cab", costs = 4000, description = {}, model = "taxi"},
				{name = "Flat Bed", costs = 4000, description = {}, model = "flatbed"},
				{name = "News Rumpo", costs = 4000, description = {}, model = "rumpo"},
				{name = "Food Truck New", costs = 4000, description = {}, model = "taco"},
			}
		},
		["compacts"] = {
			title = "compacts",
			name = "compacts",
			buttons = {			
				{name = "Blista", costs = 12000, description = {}, model = "blista"},
				{name = "Brioso R/A", costs = 22000, description = {}, model = "brioso"},
				{name = "Dilettante", costs = 7000, description = {}, model = "Dilettante"},
				{name = "Issi", costs = 14000, description = {}, model = "issi2"},
				{name = "Panto", costs = 8000, description = {}, model = "panto"},
				{name = "Prairie", costs = 8000, description = {}, model = "prairie"},
				{name = "Rhapsody", costs = 6000, description = {}, model = "rhapsody"},

				--GTAWiseGuy
				{name = "Issi Classic", costs = 60000, description = {}, model = "issi3"},
				{name = "Futo", costs = 25000, description = {}, model = "Futo"},
			}
		},
		["coupes"] = {
			title = "coupes",
			name = "coupes",
			buttons = {
				{name = "Cognoscenti Cabrio", costs = 180000, description = {}, model = "cogcabrio"},
				{name = "Exemplar", costs = 70000, description = {}, model = "exemplar"},
				{name = "F620", costs = 80000, description = {}, model = "f620"},
				{name = "Felon", costs = 40000, description = {}, model = "felon"},
				{name = "Felon GT", costs = 45000, description = {}, model = "felon2"},
				{name = "Jackal", costs = 36000, description = {}, model = "jackal"},
				{name = "Oracle", costs = 17000, description = {}, model = "oracle"},
				{name = "Oracle XS", costs = 18000, description = {}, model = "oracle2"},
				{name = "Sentinel", costs = 15000, description = {}, model = "sentinel"},
				{name = "Sentinel XS", costs = 17000, description = {}, model = "sentinel2"},
				{name = "Windsor", costs = 140000, description = {}, model = "windsor"},
				{name = "Windsor Drop", costs = 150000, description = {}, model = "windsor2"},
				{name = "Zion", costs = 6000, description = {}, model = "zion"},
				{name = "Zion Cabrio", costs = 12000, description = {}, model = "zion2"},
			}
		},
		["sports"] = {
			title = "sports",
			name = "sports",
			buttons = {
				{name = "Acura TL Type-S", costs = 20000, description = {}, model = "tltypes"},
				{name = "Aston Martin DBX Carbon Edition", costs = 60000, description = {}, model = "amdbx"},
				{name = "2013 Aston Martin Vanquish", costs = 75000, description = {}, model = "ast"},
				{name = "1995 Audi Cabriolet (RS2) (B4)", costs = 45000, description = {}, model = "80B4"},
				{name = "1983 Audi Quattro Sport", costs = 25000, description = {}, model = "audquattros"},
				{name = "2017 Audi A4 Quattro ABT", costs = 20000, description = {}, model = "aaq4"},
				{name = "2020 Audi Q8 50TDI", costs = 38000, description = {}, model = "q820"},
				{name = "2013 Audi R8 V10", costs = 90000, description = {}, model = "r8ppi"},
				{name = "2020 Audi R8", costs = 90000, description = {}, model = "r820"},
				{name = "2016 Audi RS6 C7", costs = 30000, description = {}, model = "rs6"},
				{name = "2020 Audi RS7", costs = 140000, description = {}, model = "rs72020"},
				{name = "1998 Audi S8 D2/PFL", costs = 18000, description = {}, model = "s8d2"},
				{name = "2016 Audi SQ7", costs = 60000, description = {}, model = "sq72016"},
				{name = "2010 Audi TT RS", costs = 65000, description = {}, model = "ttrs"},
				{name = "Bentley Bentayga", costs = 100000, description = {}, model = "bbentayga"},
				{name = "2004 BMW 760Li Individual (E66/PFL)", costs = 70000, description = {}, model = "cgts"},
				{name = "1995 BMW M5 E34", costs = 20000, description = {}, model = "760li04"},
				{name = "2016 BMW M2", costs = 24000, description = {}, model = "e34"},
				{name = "1997 BMW M3 E36", costs = 150000, description = {}, model = "m2"},
				{name = "2008 BMW M3 e92", costs = 27000, description = {}, model = "m3e36"},
				{name = "2015 BMW M3 (F80)", costs = 60000, description = {}, model = "m3e92"},
				{name = "2015 BMW M4 F82", costs = 80000, description = {}, model = "m3f80"},
				{name = "2015 BMW M4 F82", costs = 75000, description = {}, model = "m4f82"},
				{name = "BMW M6 F13 Shadow Line", costs = 80000, description = {}, model = "m6f13"},
				{name = "2019 BMW Z4 M40i", costs = 58000, description = {}, model = "z419"},
				{name = "2020 Bugatti Bolide", costs = 220000, description = {}, model = "bolide"},
				{name = "2016 Cadillac ATS-V Coupe", costs = 96000, description = {}, model = "cats"},
				{name = "2021 Cadillac Escalade", costs = 60000, description = {}, model = "cesc21"},
				{name = "2009 Chevrolet Tahoe", costs = 88000, description = {}, model = "09tahoe"},
				{name = "2015 Chevrolet Tahoe", costs = 88000, description = {}, model = "15tahoe"},
				{name = "2020 Chevrolet Camaro SS", costs = 85000, description = {}, model = "2020ss"},
				{name = "2017 Chevrolet Camaro RS", costs = 65000, description = {}, model = "camrs17"},
				{name = "2021 Chevrolet Tahoe RST", costs = 75000, description = {}, model = "tahoe21"},
				{name = "Chevrolet Corvette C5 Z06", costs = 100000, description = {}, model = "corvettec5z06"},
				{name = "2009 Chevrolet Corvette ZR1", costs = 120000, description = {}, model = "czr1"},
				{name = "2014 Chevrolet Corvette C7 Stingray", costs = 130000, description = {}, model = "c7"},
				{name = "2020 Chevrolet Corvette C8", costs = 145000, description = {}, model = "c8"},
				{name = "2016 Dodge Charger", costs = 130000, description = {}, model = "16charger"},
				{name = "1999 Dodge Viper GTS ACR", costs = 100000, description = {}, model = "99viper"},
				{name = "Dodge Charger Hellcat Widebody 2021", costs = 200000, description = {}, model = "chr20"},
				{name = "2015 Dodge RAM 2500", costs = 40000, description = {}, model = "ram2500"},
				{name = "2017 Dodge RAM 1500 Rebel TRX", costs = 70000, description = {}, model = "trx"},
				{name = "Ferrari 488 Spider", costs = 120000, description = {}, model = "488"},
				{name = "Ferrari F430 Scuderia", costs = 260000, description = {}, model = "f430s"},
				{name = "2018 Ferrari 812 Superfast", costs = 150000, description = {}, model = "f812"},
				{name = "2015 Ferrari California T", costs = 160000, description = {}, model = "fct"},
				{name = "Ferrari FXX-K Hybrid Hypercar", costs = 270000, description = {}, model = "fxxk"},
				{name = "2015 Ferrari LaFerrari", costs = 200000, description = {}, model = "laferrari"},
				{name = "Ferrari Enzo", costs = 150000, description = {}, model = "mig"},
				{name = "458 Italia", costs = 150000, description = {}, model = "yFe458i1"},
				{name = "458 Speciale", costs = 150000, description = {}, model = "yFe458i2"},
				{name = "458 Spider (Roof Extra)", costs = 150000, description = {}, model = "yFe458s1X"},
				{name = "458 Spider (Roofworks)", costs = 155000, description = {}, model = "yFe458s1"},
				{name = "458 Speciale Aperta (Roof Extra)", costs = 150000, description = {}, model = "yFe458s2X"},
				{name = "458 Speciale Aperta (Roofworks)", costs = 155000, description = {}, model = "yFe458s2"},
				--{name = "Ferrari F60 America", costs = , description = {}, model = "yFeF12A"},
				--{name = "Ferrari F12 TRS Roadster", costs = , description = {}, model = "yFeF12T"},
				{name = "1978 Ford F150 XLT Ranger", costs = 15000, description = {}, model = "f15078"},
				{name = "2012 Ford F150 SVT Raptor R", costs = 20000, description = {}, model = "f150"},
				{name = "2005 Ford GT", costs = 170000, description = {}, model = "fgt"},
				{name = "2017 Ford GT", costs = 260000, description = {}, model = "gt17"},
				{name = "2015 Ford Mustang GT 50 Years Special Edition", costs = 130000, description = {}, model = "mustang50th"},
				--{name = "2017 Ford Raptor", costs = , description = {}, model = "raptor2017"},
				{name = "2021 Ford Bronco Wildtrak", costs = 100000, description = {}, model = "wildtrak"},
				{name = "Honda CRX SiR 1991", costs = 25000, description = {}, model = "honcrx91"},
				--{name = "1992 Honda NSX-R (NA1)", costs = , description = {}, model = "na1"},
				{name = "Honda S2000 AP2", costs = 75000, description = {}, model = "ap2"},
				{name = "1997 Honda Civic Sedan Drag Version", costs = 500000, description = {}, model = "dragekcivick"},
				--{name = "2018 Honda Civic Type-R (FK8)", costs = , description = {}, model = "fk8"},
				{name = "2017 Italdesign Zerouno", costs = 170000, description = {}, model = "it18"},
				{name = "Jaguar F-pace 2017 Hamann Edition", costs = 50000, description = {}, model = "fpacehm"},
				{name = "2012 Jeep Wrangler", costs = 35000, description = {}, model = "jeep2012"},
				{name = "Jeep Renegade", costs = 40000, description = {}, model = "jeepreneg"},
				{name = "2015 Jeep SRT-8", costs = 950000, description = {}, model = "srt8"},
				{name = "2018 Jeep Grand Cherokee Trackhawk Series IV", costs = 100000, description = {}, model = "trhawk"},
				{name = "2017 Koenigsegg Agera RS", costs = 170000, description = {}, model = "agerars"},
				{name = "Koenigsegg Regera", costs = 175000, description = {}, model = "agerars"},
				{name = "Lamborghini Huracan Super Trofeo", costs = 200000, description = {}, model = "huracanst"},
				{name = "Lamborghini Sesto Elemento", costs = 200000, description = {}, model = "lambose"},
				{name = "2013 Lamborghini Aventador LP700-4 Roadster", costs = 250000, description = {}, model = "lp700r"},
				{name = "Lamborghini Aventador SVJ", costs = 300000, description = {}, model = "svj63"},
				{name = "Lamborghini Urus", costs = 100000, description = {}, model = "urus"},
				{name = "2013 Lamborghini Veneno LP750-4", costs = 300000, description = {}, model = "veneno"},
				{name = "Lexus GS 350", costs = 30000, description = {}, model = "gs350"},
				{name = "2014 Lexus IS 350", costs = 30000, description = {}, model = "is350mod"},
				{name = "2015 Lexus RCF", costs = 40000, description = {}, model = "rcf"},
				{name = "1973 Land Rover Range Rover", costs = 98000, description = {}, model = "lrrr"},
				{name = "2002 Lotus Esprit V8", costs = 170000, description = {}, model = "esprit02"},
				{name = "Quartz Regalia 723", costs = 120000, description = {}, model = "regalia"},
				{name = "Maserati Levante", costs = 30000, description = {}, model = "levante"},
				{name = "1984 Mazda RX-7 Stanced Version", costs = 25000, description = {}, model = "84rx7k"},
				{name = "2002 Mazda RX-7 FD Drag", costs = 97000, description = {}, model = "dragfd"},
				{name = "Mazda RX7 FC3S", costs = 18000, description = {}, model = "fc3s"},
				{name = "Mazda RX-7 FD", costs = 30000, description = {}, model = "majfd"},
				{name = "1989 Mazda Miata NA", costs = 45000, description = {}, model = "miata3"},
				{name = "Mazda MX-5 Miata (NA6C)", costs = 22000, description = {}, model = "na6"},
				{name = "2020 McLaren Speedtail", costs = 170000, description = {}, model = "mcst"},
				{name = "2020 Mercedes-Benz AMG GT-R Roadster", costs = 55000, description = {}, model = "amggtrr20"},
				{name = "2020 Mercedes-AMG C63s", costs = 80000, description = {}, model = "c6320"},
				{name = "2013 Mercedes-Benz G65 AMG", costs = 140000, description = {}, model = "G65"},
				{name = "2019 Mercedes-Benz E400 Coupe 4matic (C238)", costs = 97000, description = {}, model = "e400"},
				{name = "Mercedes-Benz GL63 AMG", costs = 40000, description = {}, model = "gl63"},
				{name = "2012 Mercedes-Benz C63 AMG Coupe Black Series", costs = 100000, description = {}, model = "mbc63"},
				{name = "2014 Mercedes-Benz S500 W222", costs = 30000, description = {}, model = "s500w222"},
				{name = "1995 Mercedes-Benz SL500", costs = 30000, description = {}, model = "sl500"},
				{name = "Mercedes-Benz V-class 250 Bluetec LWB", costs = 80000, description = {}, model = "v250"},
				{name = "Mitsubishi Lancer Evo VI T.M.E (CP9A)", costs = 35000, description = {}, model = "cp9a"},
				{name = "Mitsubishi FTO GP Version-R", costs = 22000, description = {}, model = "fto"},
				{name = "Nissan 180SX Type-X", costs = 28000, description = {}, model = "180sx"},
				{name = "2017 Nissan GTR", costs = 35000, description = {}, model = "gtr"},
				{name = "2017 R35 Nissan GTR Convertible", costs = 110000, description = {}, model = "gtrc"},
				{name = "Nissan Fairlady Z Z33", costs = 65000, description = {}, model = "maj350"},
				{name = "Nissan Silvia S15 Spec-R", costs = 30000, description = {}, model = "nis15"},
				{name = "2017 Nissan Titan Warrior", costs = 170000, description = {}, model = "nissantitan17"},
				{name = "Nissan 350z Stardast", costs = 40000, description = {}, model = "ns350"},
				{name = "Nissan 370z Pandem", costs = 45000, description = {}, model = "nzp"},
				{name = "1998 Nissan Silvia K", costs = 18000, description = {}, model = "s14"},
				{name = "1997 Nissan Patrol Super Safari Y60", costs = 100000, description = {}, model = "Safari97"},
				{name = "Nissan Skyline GT-R (BNR34)", costs = 30000, description = {}, model = "skyline"},
				{name = "Nissan 300ZX Z32", costs = 50000, description = {}, model = "z32"},
				{name = "1978 Porsche 935 Moby Dick", costs = 300000, description = {}, model = "maj935"},
				{name = "2018 Porsche Cayenne S", costs = 65000, description = {}, model = "pcs18"},
				{name = "Porsche 718 Cayman S", costs = 125000, description = {}, model = "718caymans"},
				{name = "2003 Porsche Carrera GT (980)", costs = 100000, description = {}, model = "cgt"},
				{name = "2019 Porsche Macan Turbo", costs = 45000, description = {}, model = "pm19"},
				{name = "2020 Porsche Taycan Turbo S", costs = 130000, description = {}, model = "taycan"},
				{name = "Range Rover Evoque", costs = 30000, description = {}, model = "rrevoque"},
				{name = "Range Rover Vogue Startech", costs = 35000, description = {}, model = "rrst"},
				{name = "2016 Range Rover Sport SVR", costs = 40000, description = {}, model = "rsvr16"},
				{name = "2016 Rolls-Royce Dawn Onyx", costs = 100000, description = {}, model = "dawnonyx"},
				{name = "Rolls-Royce Wraith", costs = 160000, description = {}, model = "wraith"},
				{name = "Rolls Royce Cullinan", costs = 150000, description = {}, model = "rculi"},
				{name = "2018 Rolls-Royce Phantom VIII", costs = 75000, description = {}, model = "rrphantom"},
				{name = "2008 Subaru WRX STi", costs = 45000, description = {}, model = "subisti08"},
				{name = "2004 Subaru Impreza WRX STI", costs = 50000, description = {}, model = "subwrx"},
				{name = "1996 Subaru Alcyone SVX", costs = 28000, description = {}, model = "svx"},
				{name = "2018 Toyota Camry XSE", costs = 20000, description = {}, model = "cam8tun"},
				{name = "2016 Toyota Land Cruiser VXR", costs = 28000, description = {}, model = "vxr"},
				{name = "1998 Toyota Supra Turbo (A80)", costs = 50000, description = {}, model = "toysupmk4"},
				{name = "Toyota Mark II JZX100", costs = 22000, description = {}, model = "mk2100"},
				{name = "2015 Volkswagen Golf GTI MK7", costs = 30000, description = {}, model = "golfgti7"},
				{name = "Volvo XC90 T8", costs = 50000, description = {}, model = "xc90"},
				{name = "W-Motors Fenyr Supersport", costs = 200000, description = {}, model = "wmfenyr"},
				{name = "W-Motors Lykan HyperSport", costs = 100000, description = {}, model = "lykan"},
				--{name = "2017 Honda Civic Touring", costs = , description = {}, model = "17civict"},
				--{name = "", costs = , description = {}, model = "a45"},
				--{name = "", costs = , description = {}, model = "e63amg"},
				{name = "Ce se vede", costs = 250000, description = {}, model = "f8spider"},
				--{name = "", costs = , description = {}, model = "golfgti7"},
				--{name = "", costs = , description = {}, model = "gtr"},
				--{name = "", costs = , description = {}, model = "m6f13"},
				{name = "Panamera", costs = 65000, description = {}, model = "panamera17turbo"},
				{name = "Porsche", costs = 35000, description = {}, model = "pruf"},
				--{name = "", costs = , description = {}, model = "q8roof_01"},
				--{name = "", costs = , description = {}, model = "q820"},
				{name = "Yamaha R1", costs = 20000, description = {}, model = "r1"},
				--{name = "", costs = , description = {}, model = "r820"},
				{name = "Audi RS5", costs = 165000, description = {}, model = "rs5"},
				--{name = "", costs = , description = {}, model = "rs6+"},
				--{name = "", costs = , description = {}, model = "rs7r"},
				--{name = "", costs = , description = {}, model = "rs318"},
				--{name = "", costs = , description = {}, model = "rs615"},
				{name = "Motor", costs = 17000, description = {}, model = "tmaxDX"},
				--{name = "", costs = , description = {}, model = "w140"},
				{name = "9F", costs = 165000, description = {}, model = "ninef"},
				{name = "9F Cabrio", costs = 175000, description = {}, model = "ninef2"},
				{name = "Alpha", costs = 9000, description = {}, model = "alpha"},
				{name = "Banshee", costs = 140000, description = {}, model = "banshee"},
				{name = "Bestia GTS", costs = 160000, description = {}, model = "bestiagts"},

				{name = "Buffalo", costs = 15000, description = {}, model = "buffalo"},
				{name = "Buffalo S", costs = 19000, description = {}, model = "buffalo2"},
				{name = "Carbonizzare", costs = 225000, description = {}, model = "carbonizzare"},
				{name = "Comet", costs = 190000, description = {}, model = "comet2"},
				{name = "Coquette", costs = 138000, description = {}, model = "coquette"},
				{name = "Drift Tampa", costs = 250000, description = {}, model = "tampa2"},
				{name = "Feltzer", costs = 60000, description = {}, model = "feltzer2"},
				{name = "Furore GT", costs = 44800, description = {}, model = "furoregt"},
				{name = "Fusilade", costs = 15000, description = {}, model = "fusilade"},
				{name = "Jester", costs = 230000, description = {}, model = "jester"},
				{name = "Kuruma", costs = 95000, description = {}, model = "kuruma"},
				{name = "Lynx", costs = 135000, description = {}, model = "lynx"},
				{name = "Massacro", costs = 165000, description = {}, model = "massacro"},
				{name = "Omnis", costs = 121000, description = {}, model = "omnis"},
				{name = "Penumbra", costs = 9000, description = {}, model = "penumbra"},
				{name = "Rapid GT", costs = 45000, description = {}, model = "rapidgt"},
				{name = "Rapid GT Convertible", costs = 50000, description = {}, model = "rapidgt2"},
				{name = "Schafter V12", costs = 50000, description = {}, model = "schafter3"},
				{name = "Sultan", costs = 70000, description = {}, model = "sultan"},
				{name = "Surano", costs = 110000, description = {}, model = "surano"},
				{name = "Tropos", costs = 276000, description = {}, model = "tropos"},
				{name = "Verkierer", costs = 195000, description = {}, model = "verlierer2"},
				{name = "Neon", costs = 210000, description = {}, model = "npneon"}, -- doomsday Heist , handling done
				{name = "Comet SR", costs = 270000, description = {}, model = "comet5"}, -- doomsday Heist , handling done
				{name = "Sentinel Classic", costs = 80000, description = {}, model = "sentinel3"}, -- doomsday Heist , handling done
				{name = "Revolter", costs = 90000, description = {}, model = "revolter"}, -- doomsday Heist , handling done
				{name = "Streiter", costs = 230000, description = {}, model = "streiter"}, -- doomsday Heist , handling done
				{name = "Comet Safari", costs = 250000, description = {}, model = "comet4"}, -- doomsday Heist , handling done
				{name = "Pariah", costs = 180000, description = {}, model = "pariah"}, -- doomsday Heist , handling done
				{name = "Raiden", costs = 220000, description = {}, model = "raiden"}, -- doomsday Heist , handling done

				-- GTAWiseGuy
				{name = "Sentinel SG4", costs = 150000, description = {}, model = "sentinelsg4"},
				{name = "Elegy RH8", costs = 150000, description = {}, model = "elegy2"},
				--imports 
				{name = "Lamborghini Aventador LP700R", costs = 400000, description = {}, model = "lp700r"},
                {name = "Porsche 911 Turbo S", costs = 325000, description = {}, model = "911turbos"},
                {name = "Mazda RX7 RB", costs = 275000, description = {}, model = "rx7rb"},
                {name = "Subaru Impreza WRX", costs = 250000, description = {}, model = "subwrx"},
                {name = "Subaru WRX", costs = 240000, description = {}, model = "ff4wrx"},
                {name = "Ford Mustang RMod", costs = 375000, description = {}, model = "rmodmustang"},
                {name = "Honda Civic EG", costs = 250000, description = {}, model = "delsoleg"},
                {name = "Nissan Skyline R34 GTR", costs = 325000, description = {}, model = "fnf4r34"},
                {name = "Honda S2000", costs = 275000, description = {}, model = "ap2"},
				{name = "Mitsubishi Lancer Evolution X MR FQ-400", costs = 275000, description = {}, model = "evo10"},
				
				-- pack 2
				
                {name = "BMW i8", costs = 300000, description = {}, model = "acs8"},
                {name = "Datsun 510", costs = 325000, description = {}, model = "510"},

                -- pack 3

                {name = "Nissan GTR R35 LW", costs = 350000, description = {}, model = "LWGTR"},
                {name = "Toyota Supra Mk.IV", costs = 335000, description = {}, model = "a80"},
                {name = "Nissan 370Z", costs = 300000, description = {}, model = "370Z"},
                {name = "1966 Ford Mustang", costs = 275000, description = {}, model = "66fastback"},
                {name = "BMW M3 E46", costs = 250000, description = {}, model = "E46"},

				-- GTA Wise Guy new vehicles pack 1
				
                {name = "Mazda MX5 NA", costs = 200000, description = {}, model = "na6"},
                {name = "2019 Ford Mustang", costs = 350000, description = {}, model = "mustang19"},
                {name = "Yamaha R1", costs = 250000, description = {}, model = "r1"},
                {name = "Audi RS6", costs = 325000, description = {}, model = "audirs6tk"},
                {name = "Mercedes AMG GT63", costs = 375000, description = {}, model = "gt63"},
                {name = "1969 Dodge Charger", costs = 300000, description = {}, model = "69charger"},
                {name = "Corvette C7", costs = 350000, description = {}, model = "c7"},
				{name = "McLaren 650S LW", costs = 650000, description = {}, model = "650slw"},

				-- GTA Wise Guy new vehicles pack 2

				-- {name = "S14 RB Boss", costs = 650000, description = {}, model = "s14boss"},
				{name = "Mazda RX7 FD3S", costs = 275000, description = {}, model = "fnfrx7"},
				{name = "Nissan Silvia S15", costs = 300000, description = {}, model = "s15rb"},
				{name = "Honda Civic Type-R FK8", costs = 300000, description = {}, model = "fk8"},
				{name = "Ford Focus RS", costs = 285000, description = {}, model = "focusrs"},
				{name = "Ford Raptor F150", costs = 250000, description = {}, model = "f150"},
				{name = "Jeep Grand Cherokee SRT8", costs = 325000, description = {}, model = "srt8b"},
				{name = "Porsche Panamera Turbo", costs = 375000, description = {}, model = "panamera17turbo"},
				{name = "Camaro ZL1", costs = 350000, description = {}, model = "exor"},
				{name = "Porsche 911 GT3RS", costs = 390000, description = {}, model = "gt3rs"},
				-- {name = "Lamborghini Murcielago LP670", costs = 450000, description = {}, model = "lp670"},
				-- {name = "Schwartzer, costs = 80000, description = {}, model = "schwarzer"},
			}
		},
		["sportsclassics"] = {
			title = "sports classics",
			name = "sportsclassics",
			buttons = {
				{name = "Casco", costs = 280000, description = {}, model = "casco"},
				{name = "Coquette Classic", costs = 65000, description = {}, model = "coquette2"},
				{name = "JB 700", costs = 290000, description = {}, model = "jb700"},
				{name = "Pigalle", costs = 9000, description = {}, model = "pigalle"},
				{name = "Stinger", costs = 210000, description = {}, model = "stinger"},
				{name = "Stinger GT", costs = 275000, description = {}, model = "stingergt"},
				{name = "Stirling GT", costs = 275000, description = {}, model = "feltzer3"},

				{name = "Rapid GT Classic", costs = 100000, description = {}, model = "rapidgt3"}, -- smugglers run , handling done
				{name = "Retinue", costs = 110000, description = {}, model = "retinue"}, -- smugglers run , handling done
				{name = "Viseris", costs = 110000, description = {}, model = "viseris"}, -- doomsday Heist , handling done 
				{name = "190z", costs = 90000, description = {}, model = "z190"}, -- doomsday Heist , handling done
				{name = "GT500", costs = 120000, description = {}, model = "gt500"}, -- doomsday Heist , handling done
				{name = "Savestra", costs = 110000, description = {}, model = "savestra"}, -- doomsday Heist , handling done

				-- GTAWiseGuy
				{name = "Cheburek", costs = 30000, description = {}, model = "Cheburek"}, 
				{name = "Tornado Lowrider", costs = 40000, description = {}, model = "tornado5"}, 
				{name = "Buccaneer Lowrider", costs = 45000, description = {}, model = "buccaneer2"},
				{name = "Voodoo Lowrider", costs = 50000, description = {}, model = "voodoo"},
				{name = "Chino Lowrider", costs = 45000, description = {}, model = "chino2"},
				{name = "Moonbeam Lowrider", costs = 60000, description = {}, model = "moonbeam2"},
				-- {name = "Sabre GT Lowrider", costs = 275000, description = {}, model = "sabregt2"},
				-- {name = "Slamvan Lowrider", costs = 275000, description = {}, model = "slamvan3"},
				-- {name = "Virgo Lowrider", costs = 275000, description = {}, model = "virgo2"},
				{name = "Michelli GT", costs = 140000, description = {}, model = "michelli"},
				-- {name = "Fagaloa", costs = 60000, description = {}, model = "fagaloa"},
				-- {name = "Clique", costs = 275000, description = {}, model = "clique"},
				
			}
		},
		["super"] = {
			title = "super",
			name = "super",
			buttons = {
				-- {name = "Adder", costs = 1000000, description = {}, model = "adder"},
				-- {name = "Banshee 900R", costs = 365000, description = {}, model = "banshee2"},
				-- {name = "Bullet", costs = 355000, description = {}, model = "bullet"},
				-- {name = "Cheetah", costs = 650000, description = {}, model = "cheetah"},
				-- {name = "Entity XF", costs = 1495000, description = {}, model = "entityxf"},
				-- {name = "ETR1", costs = 2359500, description = {}, model = "sheava"},
				-- {name = "FMJ", costs = 1750000, description = {}, model = "fmj"},
				-- {name = "Infernus", costs = 250000, description = {}, model = "infernus"},
				-- {name = "Osiris", costs = 1550000, description = {}, model = "osiris"},
				-- {name = "RE-7B", costs = 3475000, description = {}, model = "le7b"},
				-- {name = "Reaper", costs = 295000, description = {}, model = "reaper"},
				-- {name = "Sultan RS", costs = 95000, description = {}, model = "sultanrs"},
				-- {name = "T20", costs = 2200000, description = {}, model = "t20"},
				-- {name = "Turismo R", costs = 2000000, description = {}, model = "turismor"},
				-- {name = "Tyrus", costs = 2550000, description = {}, model = "tyrus"},
				-- {name = "Vacca", costs = 150000, description = {}, model = "vacca"},
				-- {name = "Voltic", costs = 69000, description = {}, model = "voltic"},
				-- {name = "X80 Proto", costs = 3300000, description = {}, model = "prototipo"},
				-- {name = "Zentorno", costs = 725000, description = {}, model = "zentorno"},
				-- {name = "Cyclone", costs = 960000, description = {}, model = "cyclone"}, -- smugglers run , handling done
				-- {name = "Visione", costs = 895000, description = {}, model = "visione"}, -- smugglers run , handling done
				-- {name = "Autarch", costs = 2800000, description = {}, model = "autarch"}, -- doomsday Heist , handling done
				-- {name = "SC1", costs = 1050000, description = {}, model = "sc1"}, -- doomsday Heist , handling done

				-- GTAWiseGuy
				{name = "Turismo Classic", costs = 450000, description = {}, model = "turismo2"},
				{name = "WCR Patriot Stretch", costs = 150000, description = {}, model = "patriot2"},
				{name = "Scuffvan Lowrider", costs = 70000, description = {}, model = "minivan2"},

			}
		},
		["muscle"] = {
			title = "muscle",
			name = "muscle",
			buttons = {
				{name = "Blade", costs = 20000, description = {}, model = "blade"},
				{name = "Buccaneer", costs = 22000, description = {}, model = "buccaneer"},
				{name = "Chino", costs = 25000, description = {}, model = "chino"},
				{name = "Coquette BlackFin", costs = 99500, description = {}, model = "coquette3"},
				{name = "Dominator", costs = 35000, description = {}, model = "dominator"},
				{name = "Dukes", costs = 72000, description = {}, model = "dukes"},
				{name = "Gauntlet", costs = 39000, description = {}, model = "gauntlet"},
				{name = "Hotknife", costs = 69000, description = {}, model = "hotknife"},
				{name = "Faction", costs = 36000, description = {}, model = "faction"},
				{name = "Faction 2", costs = 42000, description = {}, model = "faction2"},
				{name = "Faction 3", costs = 42000, description = {}, model = "faction3"},
				{name = "Nightshade", costs = 85000, description = {}, model = "nightshade"},
				{name = "Picador", costs = 9000, description = {}, model = "picador"},
				{name = "Sabre Turbo", costs = 35000, description = {}, model = "sabregt"},
				{name = "Tampa", costs = 35000, description = {}, model = "tampa"},
				{name = "Virgo", costs = 15000, description = {}, model = "virgo"},
				{name = "Vigero", costs = 41000, description = {}, model = "vigero"},
				{name = "Hustler", costs = 7000, description = {}, model = "hustler"}, -- doomsday Heist , handling done
				{name = "Hermes", costs = 127000, description = {}, model = "hermes"}, -- doomsday Heist , handling done
				{name = "Yosemite", costs = 70000, description = {}, model = "yosemite"}, -- doomsday Heist , handling done

				-- GTA Wise Guy
				{name = "Phoenix", costs = 35000, description = {}, model = "Phoenix"},
				{name = "Ruiner", costs = 30000, description = {}, model = "ruiner"},
				{name = "Dominator GTX", costs = 180000, description = {}, model = "dominator3"},
				{name = "Vamos", costs = 140000, description = {}, model = "vamos"},
				-- {name = "Impaler", costs = 60000, description = {}, model = "impaler"},
				-- {name = "Tulip", costs = 60000, description = {}, model = "tulip"},
			}
		},
		["offroad"] = {
			title = "off-road",
			name = "off-road",
			buttons = {
				{name = "Bifta", costs = 75000, description = {}, model = "bifta"},
				{name = "Blazer", costs = 8000, description = {}, model = "blazer"},
				{name = "Brawler", costs = 71500, description = {}, model = "brawler"},
				{name = "Bubsta 6x6", costs = 159000, description = {}, model = "dubsta3"},
				{name = "Dune Buggy", costs = 5000, description = {}, model = "dune"},
				{name = "Rebel", costs = 22000, description = {}, model = "rebel2"},
				{name = "Sandking", costs = 38000, description = {}, model = "sandking"},
				{name = "Trophy Truck", costs = 210000, description = {}, model = "trophytruck"},
				{name = "Kamacho", costs = 280000, description = {}, model = "kamacho"}, -- doomsday Heist , handling done
				{name = "Riata", costs = 190000, description = {}, model = "riata"}, -- doomsday Heist , handling done
				
				--GTA Wise Guy
				{name = "Lifted Mesa", costs = 90000, description = {}, model = "mesa3"},
				{name = "Lego Car", costs = 40000, description = {}, model = "kalahari"},
				{name = "Street Blazer", costs = 35000, description = {}, model = "blazer4"},
			}
		},
		["suvs"] = {
			title = "suvs",
			name = "suvs",
			buttons = {
				{name = "Baller", costs = 60000, description = {}, model = "baller"},
				{name = "Cavalcade", costs = 20000, description = {}, model = "cavalcade"},
				{name = "Granger", costs = 55000, description = {}, model = "granger"},
				{name = "Huntley S", costs = 195000, description = {}, model = "huntley"},
				{name = "Landstalker", costs = 38000, description = {}, model = "landstalker"},
				{name = "Radius", costs = 22000, description = {}, model = "radi"},
				{name = "Rocoto", costs = 85000, description = {}, model = "rocoto"},
				{name = "Seminole", costs = 10000, description = {}, model = "seminole"},
				{name = "XLS", costs = 90000, description = {}, model = "xls"},

				--GTA Wise Guy
				{name = "Mesa", costs = 60000, description = {}, model = "Mesa"},
				{name = "Baller LE", costs = 210000, description = {}, model = "baller3"},
			}
		},
		["vans"] = {
			title = "vans",
			name = "vans",
			buttons = {
				{name = "Bison", costs = 30000, description = {}, model = "bison"},
				{name = "Bobcat XL", costs = 15000, description = {}, model = "bobcatxl"},
				{name = "Gang Burrito", costs = 15000, description = {}, model = "gburrito"},
				{name = "Journey", costs = 5000, description = {}, model = "journey"},
				{name = "Minivan", costs = 3000, description = {}, model = "minivan"},
				{name = "Paradise", costs = 5000, description = {}, model = "paradise"},
				{name = "Surfer", costs = 5000, description = {}, model = "surfer"},
				{name = "Youga", costs = 6000, description = {}, model = "youga"},
			}
		},
		["sedans"] = {
			title = "sedans",
			name = "sedans",
			buttons = {
				{name = "2004 Subaru Impreza WRX STI", costs = 50000, description = {}, model = "subwrx"},
				{name = "Emperor", costs = 2000, description = {}, model = "emperor2"},
				{name = "Tornado", costs = 2000, description = {}, model = "tornado3"},
				{name = "Tornado +", costs = 2900, description = {}, model = "tornado6"},
				{name = "Bodhi", costs = 3000, description = {}, model = "bodhi2"},
				{name = "Youga", costs = 5000, description = {}, model = "youga2"},
				{name = "Rumpo", costs = 16000, description = {}, model = "rumpo3"},			
				{name = "Asea", costs = 8000, description = {}, model = "asea"},
				{name = "Asterope", costs = 10000, description = {}, model = "asterope"},
				{name = "Fugitive", costs = 28000, description = {}, model = "fugitive"},
				{name = "Glendale", costs = 8000, description = {}, model = "glendale"},
				{name = "Ingot", costs = 9000, description = {}, model = "ingot"},
				{name = "Intruder", costs = 25000, description = {}, model = "intruder"},
				{name = "Premier", costs = 10000, description = {}, model = "premier"},
				{name = "Primo", costs = 9000, description = {}, model = "primo"},
				{name = "Primo Custom", costs = 9500, description = {}, model = "primo2"},
				{name = "Regina", costs = 8000, description = {}, model = "regina"},
				{name = "Schafter", costs = 45000, description = {}, model = "schafter2"},
				{name = "Stanier", costs = 10000, description = {}, model = "stanier"},
				{name = "Stratum", costs = 10000, description = {}, model = "stratum"},
				{name = "Stretch", costs = 30000, description = {}, model = "stretch"},
				{name = "Super Diamond", costs = 200000, description = {}, model = "superd"},
				{name = "Surge", costs = 18000, description = {}, model = "surge"},
				{name = "Warrener", costs = 80000, description = {}, model = "warrener"},
				{name = "Washington", costs = 15000, description = {}, model = "washington"},
				-- Gta wise guy
				{name = "Tailgater", costs = 90000, description = {}, model = "tailgater"},
				{model = "taxirooster", name = "Rooster Cab Co Taxi", costs = 5000, description = {} },
				{name = "Cognoscenti 55", costs = 125000, description = {}, model = "cog55"},
				{name = "Cognoscenti", costs = 150000, description = {}, model = "cognoscenti"},


			}
		},
		["motorcycles"] = {
			title = "MOTORCYCLES",
			name = "motorcycles",
			buttons = {
			--	{name = "Ratbike", costs = 4000, description = {}, model = "ratbike"},			
				{name = "Akuma", costs = 9000, description = {}, model = "AKUMA"},
				{name = "Bagger", costs = 25000, description = {}, model = "bagger"},
				{name = "Bati 801", costs = 15000, description = {}, model = "bati"},
				{name = "Bati 801RR", costs = 15000, description = {}, model = "bati2"},
			--	{name = "BF400", costs = 95000, description = {}, model = "bf400"},
				{name = "Carbon RS", costs = 11000, description = {}, model = "carbonrs"},
			--	{name = "Cliffhanger", costs = 32500, description = {}, model = "cliffhanger"},
				{name = "Daemon", costs = 25000, description = {}, model = "daemon"},
				{name = "Double T", costs = 12000, description = {}, model = "double"},
			--	{name = "Enduro", costs = 48000, description = {}, model = "enduro"},
				{name = "Faggio", costs = 2000, description = {}, model = "faggio2"},
			--	{name = "Gargoyle", costs = 70000, description = {}, model = "gargoyle"},
				{name = "Hakuchou", costs = 32000, description = {}, model = "hakuchou"},
				{name = "Hexer", costs = 25000, description = {}, model = "hexer"},
			--	{name = "Innovation", costs = 30000, description = {}, model = "innovation"},
				{name = "Lectro", costs = 32000, description = {}, model = "lectro"},
				{name = "Nemesis", costs = 12000, description = {}, model = "nemesis"},
				{name = "PCJ-600", costs = 9000, description = {}, model = "pcj"},
				{name = "Ruffian", costs = 9000, description = {}, model = "ruffian"},
				{name = "Sanchez", costs = 17000, description = {}, model = "sanchez"},
				{name = "Sovereign", costs = 62000, description = {}, model = "sovereign"},
			--	{name = "Thrust", costs = 75000, description = {}, model = "thrust"},
			--	{name = "Shotaro", costs = 189000, description = {}, model = "SHOTARO"},
			--	{name = "Vindicator", costs = 41000, description = {}, model = "vindicator"},
			--	{name = "Zombiea", costs = 60000, description = {}, model = "zombiea"},
			--	{name = "Zombieb", costs = 65000, description = {}, model = "zombieb"},
			--	{name = "Wolfsbane", costs = 70000, description = {}, model = "wolfsbane"},
			--	{name = "Nightblade", costs = 90000, description = {}, model = "nightblade"},

			-- gtawiseguy
				{name = "Faggio Custom", costs = 25000, description = {}, model = "faggio3"},
				{name = "Cliffhanger", costs = 40000, description = {}, model = "Cliffhanger"},
				{name = "Daemon Custom", costs = 40000, description = {}, model = "daemon2"},
				{name = "Faggio", costs = 8000, description = {}, model = "faggio"},

			}
		},
		["cycles"] = {
			title = "cycles",
			name = "cycles",
			buttons = {
				{name = "BMX", costs = 150, description = {}, model = "bmx"},
				{name = "Cruiser", costs = 240, description = {}, model = "cruiser"},
				{name = "Fixter", costs = 270, description = {}, model = "fixter"},
				{name = "Scorcher", costs = 300, description = {}, model = "scorcher"},
				{name = "Pro 1", costs = 2500, description = {}, model = "tribike"},
				{name = "Pro 2", costs = 2600, description = {}, model = "tribike2"},
				{name = "Pro 3", costs = 2900, description = {}, model = "tribike3"},
			}
		},		
	}
}