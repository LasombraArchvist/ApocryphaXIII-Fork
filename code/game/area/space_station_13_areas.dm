/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME   (you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = 'ICON FILENAME' 			(defaults to 'icons/turf/areas.dmi')
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = FALSE 				(defaults to true)
	ambience_index = AMBIENCE_GENERIC   (picks the ambience from an assoc list in ambience.dm)
	ambientsounds = list()				(defaults to ambience_index's assoc on Initialize(). override it as "ambientsounds = list('sound/ambience/signal.ogg')" or by changing ambience_index)

NOTE: there are two lists of areas in the end of this file: centcom and station itself. Please maintain these lists valid. --rastaf0

*/


/*-----------------------------------------------------------------------------*/

/area/ai_monitored	//stub defined ai_monitored.dm

/area/ai_monitored/turret_protected

/area/space
	icon_state = "space"
	requires_power = TRUE
	always_unpowered = TRUE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	area_flags = UNIQUE_AREA | NO_ALERTS
	outdoors = TRUE
	ambience_index = AMBIENCE_SPACE
	flags_1 = CAN_BE_DIRTY_1
	sound_environment = SOUND_AREA_SPACE

/area/space/nearstation
	icon_state = "space_near"
	dynamic_lighting = DYNAMIC_LIGHTING_IFSTARLIGHT

/area/start
	name = "start area"
	icon_state = "start"
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	has_gravity = STANDARD_GRAVITY


/area/testroom
	requires_power = FALSE
	name = "Test Room"
	icon_state = "storage"

//EXTRA

/area/asteroid
	name = "Asteroid"
	icon_state = "asteroid"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	area_flags = UNIQUE_AREA
	ambience_index = AMBIENCE_MINING
	flags_1 = CAN_BE_DIRTY_1
	sound_environment = SOUND_AREA_ASTEROID
	min_ambience_cooldown = 70 SECONDS
	max_ambience_cooldown = 220 SECONDS

/area/asteroid/nearstation
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	ambience_index = AMBIENCE_RUINS
	always_unpowered = FALSE
	requires_power = TRUE
	area_flags = UNIQUE_AREA | BLOBS_ALLOWED

/area/asteroid/nearstation/bomb_site
	name = "Bomb Testing Asteroid"

//STATION13

//Maintenance

/area/maintenance
	name = "Generic Maintenance"
	ambience_index = AMBIENCE_MAINT
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA
	airlock_wires = /datum/wires/airlock/maint
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED

//Departments

/area/maintenance/department/chapel
	name = "Chapel Maintenance"
	icon_state = "maint_chapel"

/area/maintenance/department/chapel/monastery
	name = "Monastery Maintenance"
	icon_state = "maint_monastery"

/area/maintenance/department/crew_quarters/bar
	name = "Bar Maintenance"
	icon_state = "maint_bar"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/maintenance/department/crew_quarters/dorms
	name = "Dormitory Maintenance"
	icon_state = "maint_dorms"

/area/maintenance/department/eva
	name = "EVA Maintenance"
	icon_state = "maint_eva"

/area/maintenance/department/electrical
	name = "Electrical Maintenance"
	icon_state = "maint_electrical"

/area/maintenance/department/engine/atmos
	name = "Atmospherics Maintenance"
	icon_state = "maint_atmos"

/area/maintenance/department/security
	name = "Security Maintenance"
	icon_state = "maint_sec"

/area/maintenance/department/security/upper
	name = "Upper Security Maintenance"

/area/maintenance/department/security/brig
	name = "Brig Maintenance"
	icon_state = "maint_brig"

/area/maintenance/department/medical
	name = "Medbay Maintenance"
	icon_state = "medbay_maint"

/area/maintenance/department/medical/central
	name = "Central Medbay Maintenance"
	icon_state = "medbay_maint_central"

/area/maintenance/department/medical/morgue
	name = "Morgue Maintenance"
	icon_state = "morgue_maint"

/area/maintenance/department/science
	name = "Science Maintenance"
	icon_state = "maint_sci"

/area/maintenance/department/science/central
	name = "Central Science Maintenance"
	icon_state = "maint_sci_central"

/area/maintenance/department/cargo
	name = "Cargo Maintenance"
	icon_state = "maint_cargo"

/area/maintenance/department/bridge
	name = "Bridge Maintenance"
	icon_state = "maint_bridge"

/area/maintenance/department/engine
	name = "Engineering Maintenance"
	icon_state = "maint_engi"

/area/maintenance/department/science/xenobiology
	name = "Xenobiology Maintenance"
	icon_state = "xenomaint"
	area_flags = VALID_TERRITORY | BLOBS_ALLOWED | UNIQUE_AREA | XENOBIOLOGY_COMPATIBLE


//Maintenance - Generic

/area/maintenance/aft
	name = "Aft Maintenance"
	icon_state = "amaint"

/area/maintenance/aft/upper
	name = "Upper Aft Maintenance"

/area/maintenance/aft/secondary
	name = "Aft Maintenance"
	icon_state = "amaint_2"

/area/maintenance/central
	name = "Central Maintenance"
	icon_state = "maintcentral"

/area/maintenance/central/secondary
	name = "Central Maintenance"
	icon_state = "maintcentral"

/area/maintenance/fore
	name = "Fore Maintenance"
	icon_state = "fmaint"

/area/maintenance/fore/upper
	name = "Upper Fore Maintenance"

/area/maintenance/fore/secondary
	name = "Fore Maintenance"
	icon_state = "fmaint_2"

/area/maintenance/starboard
	name = "Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/starboard/upper
	name = "Upper Starboard Maintenance"

/area/maintenance/starboard/central
	name = "Central Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/starboard/secondary
	name = "Secondary Starboard Maintenance"
	icon_state = "smaint_2"

/area/maintenance/starboard/aft
	name = "Starboard Quarter Maintenance"
	icon_state = "asmaint"

/area/maintenance/starboard/aft/secondary
	name = "Secondary Starboard Quarter Maintenance"
	icon_state = "asmaint_2"

/area/maintenance/starboard/fore
	name = "Starboard Bow Maintenance"
	icon_state = "fsmaint"

/area/maintenance/port
	name = "Port Maintenance"
	icon_state = "pmaint"

/area/maintenance/port/central
	name = "Central Port Maintenance"
	icon_state = "maintcentral"

/area/maintenance/port/aft
	name = "Port Quarter Maintenance"
	icon_state = "apmaint"

/area/maintenance/port/fore
	name = "Port Bow Maintenance"
	icon_state = "fpmaint"

/area/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"

/area/maintenance/disposal/incinerator
	name = "Incinerator"
	icon_state = "incinerator"

/area/maintenance/space_hut
	name = "Space Hut"
	icon_state = "spacehut"

/area/maintenance/space_hut/cabin
	name = "Abandoned Cabin"

/area/maintenance/space_hut/plasmaman
	name = "Abandoned Plasmaman Friendly Startup"

/area/maintenance/space_hut/observatory
	name = "Space Observatory"

//Hallway
/area/hallway
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/hallway/primary
	name = "Primary Hallway"

/area/hallway/primary/aft
	name = "Aft Primary Hallway"
	icon_state = "hallA"

/area/hallway/primary/fore
	name = "Fore Primary Hallway"
	icon_state = "hallF"

/area/hallway/primary/starboard
	name = "Starboard Primary Hallway"
	icon_state = "hallS"

/area/hallway/primary/port
	name = "Port Primary Hallway"
	icon_state = "hallP"

/area/hallway/primary/central
	name = "Central Primary Hallway"
	icon_state = "hallC"

/area/hallway/primary/upper
	name = "Upper Central Primary Hallway"
	icon_state = "hallC"


/area/hallway/secondary/command
	name = "Command Hallway"
	icon_state = "bridge_hallway"

/area/hallway/secondary/construction
	name = "Construction Area"
	icon_state = "construction"

/area/hallway/secondary/exit
	name = "Escape Shuttle Hallway"
	icon_state = "escape"

/area/hallway/secondary/exit/departure_lounge
	name = "Departure Lounge"
	icon_state = "escape_lounge"

/area/hallway/secondary/entry
	name = "Arrival Shuttle Hallway"
	icon_state = "entry"

/area/hallway/secondary/service
	name = "Service Hallway"
	icon_state = "hall_service"

//Command

/area/bridge
	name = "Bridge"
	icon_state = "bridge"
	ambientsounds = list('sound/ambience/signal.ogg')
	airlock_wires = /datum/wires/airlock/command
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/bridge/meeting_room
	name = "Heads of Staff Meeting Room"
	icon_state = "meeting"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/bridge/meeting_room/council
	name = "Council Chamber"
	icon_state = "meeting"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/bridge/showroom/corporate
	name = "Corporate Showroom"
	icon_state = "showroom"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/crew_quarters/heads
	airlock_wires = /datum/wires/airlock/command

/area/crew_quarters/heads/captain
	name = "Captain's Office"
	icon_state = "captain"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/crew_quarters/heads/captain/private
	name = "Captain's Quarters"
	icon_state = "captain_private"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/crew_quarters/heads/chief
	name = "Chief Engineer's Office"
	icon_state = "ce_office"

/area/crew_quarters/heads/cmo
	name = "Chief Medical Officer's Office"
	icon_state = "cmo_office"

/area/crew_quarters/heads/hop
	name = "Head of Personnel's Office"
	icon_state = "hop_office"

/area/crew_quarters/heads/hos
	name = "Head of Security's Office"
	icon_state = "hos_office"

/area/crew_quarters/heads/hor
	name = "Research Director's Office"
	icon_state = "rd_office"

/area/comms
	name = "Communications Relay"
	icon_state = "tcomsatcham"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/server
	name = "Messaging Server Room"
	icon_state = "server"
	sound_environment = SOUND_AREA_STANDARD_STATION

//Crew

/area/crew_quarters
	name = "Crew Quarters"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/crew_quarters/dorms
	name = "Dormitories"
	icon_state = "dorms"
	area_flags = VALID_TERRITORY | BLOBS_ALLOWED | UNIQUE_AREA

/area/crew_quarters/dorms/barracks
	name = "Sleep Barracks"

/area/crew_quarters/dorms/barracks/male
	name = "Male Sleep Barracks"
	icon_state = "dorms_male"

/area/crew_quarters/dorms/barracks/female
	name = "Female Sleep Barracks"
	icon_state = "dorms_female"

/area/crew_quarters/toilet
	name = "Dormitory Toilets"
	icon_state = "toilet"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/crew_quarters/toilet/auxiliary
	name = "Auxiliary Restrooms"
	icon_state = "toilet"

/area/crew_quarters/toilet/locker
	name = "Locker Toilets"
	icon_state = "toilet"

/area/crew_quarters/toilet/restrooms
	name = "Restrooms"
	icon_state = "toilet"

/area/crew_quarters/locker
	name = "Locker Room"
	icon_state = "locker"

/area/crew_quarters/lounge
	name = "Lounge"
	icon_state = "lounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/crew_quarters/fitness
	name = "Fitness Room"
	icon_state = "fitness"

/area/crew_quarters/fitness/locker_room
	name = "Unisex Locker Room"
	icon_state = "locker"

/area/crew_quarters/fitness/locker_room/male
	name = "Male Locker Room"
	icon_state = "locker_male"

/area/crew_quarters/fitness/locker_room/female
	name = "Female Locker Room"
	icon_state = "locker_female"


/area/crew_quarters/fitness/recreation
	name = "Recreation Area"
	icon_state = "rec"

/area/crew_quarters/cafeteria
	name = "Cafeteria"
	icon_state = "cafeteria"

/area/crew_quarters/kitchen
	name = "Kitchen"
	icon_state = "kitchen"
	airlock_wires = /datum/wires/airlock/service

/area/crew_quarters/kitchen/coldroom
	name = "Kitchen Cold Room"
	icon_state = "kitchen_cold"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/crew_quarters/bar
	name = "Bar"
	icon_state = "bar"
	mood_bonus = 5
	mood_message = "<span class='nicegreen'>I love being in the bar!</span>\n"
	mood_trait = TRAIT_EXTROVERT
	airlock_wires = /datum/wires/airlock/service
	sound_environment = SOUND_AREA_WOODFLOOR

/area/crew_quarters/bar/atrium
	name = "Atrium"
	icon_state = "bar"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/crew_quarters/electronic_marketing_den
	name = "Electronic Marketing Den"
	icon_state = "abandoned_m_den"

/area/crew_quarters/abandoned_gambling_den
	name = "Abandoned Gambling Den"
	icon_state = "abandoned_g_den"

/area/crew_quarters/abandoned_gambling_den/secondary
	icon_state = "abandoned_g_den_2"

/area/crew_quarters/theatre
	name = "Theatre"
	icon_state = "theatre"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/crew_quarters/theatre/abandoned
	name = "Abandoned Theatre"
	icon_state = "abandoned_theatre"

/area/library
	name = "Library"
	icon_state = "library"
	mood_bonus = 5
	mood_message = "<span class='nicegreen'>I love being in the library!</span>\n"
	mood_trait = TRAIT_INTROVERT
	flags_1 = CULT_PERMITTED_1
	sound_environment = SOUND_AREA_LARGE_SOFTFLOOR

/area/library/lounge
	name = "Library Lounge"
	icon_state = "library_lounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/library/artgallery
	name = " Art Gallery"
	icon_state = "library_gallery"

/area/library/private
	name = "Library Private Study"
	icon_state = "library_gallery_private"

/area/library/upper
	name = "Library Upper Floor"
	icon_state = "library"

/area/library/printer
	name = "Library Printer Room"
	icon_state = "library"

/area/library/abandoned
	name = "Abandoned Library"
	icon_state = "abandoned_library"
	flags_1 = CULT_PERMITTED_1

/area/chapel
	icon_state = "chapel"
	mood_bonus = 5
	mood_message = "<span class='nicegreen'>Being in the chapel brings me peace.</span>\n"
	mood_trait = TRAIT_SPIRITUAL
	ambience_index = AMBIENCE_HOLY
	flags_1 = NONE
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/chapel/main
	name = "Chapel"

/area/chapel/main/monastery
	name = "Monastery"

/area/chapel/office
	name = "Chapel Office"
	icon_state = "chapeloffice"

/area/chapel/asteroid
	name = "Chapel Asteroid"
	icon_state = "explored"
	sound_environment = SOUND_AREA_ASTEROID

/area/chapel/asteroid/monastery
	name = "Monastery Asteroid"

/area/chapel/dock
	name = "Chapel Dock"
	icon_state = "construction"

/area/lawoffice
	name = "Law Office"
	icon_state = "law"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR


//Engineering

/area/engine
	ambience_index = AMBIENCE_ENGI
	airlock_wires = /datum/wires/airlock/engineering
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/engine/engine_smes
	name = "Engineering SMES"
	icon_state = "engine_smes"

/area/engine/engineering
	name = "Engineering"
	icon_state = "engine"

/area/engine/atmos
	name = "Atmospherics"
	icon_state = "atmos"
	flags_1 = CULT_PERMITTED_1

/area/engine/atmos/upper
	name = "Upper Atmospherics"

/area/engine/atmospherics_engine
	name = "Atmospherics Engine"
	icon_state = "atmos_engine"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/engine/engine_room //donut station specific
	name = "Engine Room"
	icon_state = "atmos_engine"

/area/engine/lobby
	name = "Engineering Lobby"
	icon_state = "engi_lobby"

/area/engine/engine_room/external
	name = "Supermatter External Access"
	icon_state = "engine_foyer"

/area/engine/supermatter
	name = "Supermatter Engine"
	icon_state = "engine_sm"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/engine/break_room
	name = "Engineering Foyer"
	icon_state = "engine_break"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/engine/gravity_generator
	name = "Gravity Generator Room"
	icon_state = "grav_gen"

/area/engine/storage
	name = "Engineering Storage"
	icon_state = "engi_storage"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/engine/storage_shared
	name = "Shared Engineering Storage"
	icon_state = "engi_storage"

/area/engine/transit_tube
	name = "Transit Tube"
	icon_state = "transit_tube"


//Solars

/area/solar
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_IFSTARLIGHT
	area_flags = UNIQUE_AREA
	flags_1 = NONE
	ambience_index = AMBIENCE_ENGI
	airlock_wires = /datum/wires/airlock/engineering
	sound_environment = SOUND_AREA_SPACE

/area/solar/fore
	name = "Fore Solar Array"
	icon_state = "yellow"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/solar/aft
	name = "Aft Solar Array"
	icon_state = "yellow"

/area/solar/aux/port
	name = "Port Bow Auxiliary Solar Array"
	icon_state = "panelsA"

/area/solar/aux/starboard
	name = "Starboard Bow Auxiliary Solar Array"
	icon_state = "panelsA"

/area/solar/starboard
	name = "Starboard Solar Array"
	icon_state = "panelsS"

/area/solar/starboard/aft
	name = "Starboard Quarter Solar Array"
	icon_state = "panelsAS"

/area/solar/starboard/fore
	name = "Starboard Bow Solar Array"
	icon_state = "panelsFS"

/area/solar/port
	name = "Port Solar Array"
	icon_state = "panelsP"

/area/solar/port/aft
	name = "Port Quarter Solar Array"
	icon_state = "panelsAP"

/area/solar/port/fore
	name = "Port Bow Solar Array"
	icon_state = "panelsFP"

/area/solar/aisat
	name = "AI Satellite Solars"
	icon_state = "yellow"


//Solar Maint

/area/maintenance/solars
	name = "Solar Maintenance"
	icon_state = "yellow"

/area/maintenance/solars/port
	name = "Port Solar Maintenance"
	icon_state = "SolarcontrolP"

/area/maintenance/solars/port/aft
	name = "Port Quarter Solar Maintenance"
	icon_state = "SolarcontrolAP"

/area/maintenance/solars/port/fore
	name = "Port Bow Solar Maintenance"
	icon_state = "SolarcontrolFP"

/area/maintenance/solars/starboard
	name = "Starboard Solar Maintenance"
	icon_state = "SolarcontrolS"

/area/maintenance/solars/starboard/aft
	name = "Starboard Quarter Solar Maintenance"
	icon_state = "SolarcontrolAS"

/area/maintenance/solars/starboard/fore
	name = "Starboard Bow Solar Maintenance"
	icon_state = "SolarcontrolFS"

//Teleporter

/area/teleporter
	name = "Teleporter Room"
	icon_state = "teleporter"
	ambience_index = AMBIENCE_ENGI
	airlock_wires = /datum/wires/airlock/command

/area/gateway
	name = "Gateway"
	icon_state = "gateway"
	ambience_index = AMBIENCE_ENGI
	airlock_wires = /datum/wires/airlock/command
	sound_environment = SOUND_AREA_STANDARD_STATION

//MedBay

/area/medical
	name = "Medical"
	icon_state = "medbay1"
	ambience_index = AMBIENCE_MEDICAL
	airlock_wires = /datum/wires/airlock/medbay
	sound_environment = SOUND_AREA_STANDARD_STATION
	min_ambience_cooldown = 90 SECONDS
	max_ambience_cooldown = 180 SECONDS

/area/medical/abandoned
	name = "Abandoned Medbay"
	icon_state = "abandoned_medbay"
	ambientsounds = list('sound/ambience/signal.ogg')
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/medical/medbay/central
	name = "Medbay Central"
	icon_state = "med_central"

/area/medical/medbay/lobby
	name = "Medbay Lobby"
	icon_state = "med_lobby"

	//Medbay is a large area, these additional areas help level out APC load.

/area/medical/medbay/zone2
	name = "Medbay"
	icon_state = "medbay2"

/area/medical/medbay/aft
	name = "Medbay Aft"
	icon_state = "med_aft"

/area/medical/storage
	name = "Medbay Storage"
	icon_state = "med_storage"

/area/medical/paramedic
	name = "Paramedic Dispatch"
	icon_state = "paramedic"

/area/medical/office
	name = "Medical Office"
	icon_state = "med_office"

/area/medical/surgery/room_c
	name = "Surgery C"
	icon_state = "surgery"

/area/medical/surgery/room_d
	name = "Surgery D"
	icon_state = "surgery"

/area/medical/break_room
	name = "Medical Break Room"
	icon_state = "med_break"

/area/medical/coldroom
	name = "Medical Cold Room"
	icon_state = "kitchen_cold"

/area/medical/patients_rooms
	name = "Patients' Rooms"
	icon_state = "patients"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/medical/patients_rooms/room_a
	name = "Patient Room A"
	icon_state = "patients"

/area/medical/patients_rooms/room_b
	name = "Patient Room B"
	icon_state = "patients"

/area/medical/virology
	name = "Virology"
	icon_state = "virology"
	flags_1 = CULT_PERMITTED_1

/area/medical/morgue
	name = "Morgue"
	icon_state = "morgue"
	ambience_index = AMBIENCE_SPOOKY
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/medical/chemistry
	name = "Chemistry"
	icon_state = "chem"

/area/medical/pharmacy
	name = "Pharmacy"
	icon_state = "pharmacy"

/area/medical/surgery
	name = "Surgery"
	icon_state = "surgery"

/area/medical/surgery/room_b
	name = "Surgery B"
	icon_state = "surgery"

/area/medical/cryo
	name = "Cryogenics"
	icon_state = "cryo"

/area/medical/exam_room
	name = "Exam Room"
	icon_state = "exam_room"

/area/medical/genetics
	name = "Genetics Lab"
	icon_state = "genetics"

/area/medical/sleeper
	name = "Medbay Treatment Center"
	icon_state = "exam_room"

/area/medical/psychology
	name = "Psychology Office"
	icon_state = "psychology"
	mood_bonus = 3
	mood_message = "<span class='nicegreen'>I feel at ease here.</span>\n"
	ambientsounds = list('sound/ambience/aurora_caelus_short.ogg')

//Security

/area/security
	name = "Security"
	icon_state = "security"
	ambience_index = AMBIENCE_DANGER
	airlock_wires = /datum/wires/airlock/security
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/security/main
	name = "Security Office"
	icon_state = "security"

/area/security/brig
	name = "Brig"
	icon_state = "brig"

/area/security/brig/upper
	name = "Brig Overlook"

/area/security/courtroom
	name = "Courtroom"
	icon_state = "courtroom"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/security/prison
	name = "Prison Wing"
	icon_state = "sec_prison"

/area/security/prison/toilet //radproof
	name = "Prison Toilet"
	icon_state = "sec_prison_safe"

/area/security/prison/safe //radproof
	name = "Prison Wing Cells"
	icon_state = "sec_prison_safe"

/area/security/prison/upper
	name = "Upper Prison Wing"
	icon_state = "prison_upper"

/area/security/prison/visit
	name = "Prison Visitation Area"
	icon_state = "prison_visit"

/area/security/prison/rec
	name = "Prison Rec Room"
	icon_state = "prison_rec"

/area/security/prison/mess
	name = "Prison Mess Hall"
	icon_state = "prison_mess"

/area/security/prison/work
	name = "Prison Work Room"
	icon_state = "prison_work"

/area/security/prison/shower
	name = "Prison Shower"
	icon_state = "prison_shower"

/area/security/prison/workout
	name = "Prison Gym"
	icon_state = "prison_workout"

/area/security/prison/garden
	name = "Prison Garden"
	icon_state = "prison_garden"

/area/security/processing
	name = "Labor Shuttle Dock"
	icon_state = "sec_processing"

/area/security/processing/cremation
	name = "Security Crematorium"
	icon_state = "sec_cremation"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/security/warden
	name = "Brig Control"
	icon_state = "warden"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/security/detectives_office
	name = "Detective's Office"
	icon_state = "detective"
	ambientsounds = list('sound/ambience/ambidet1.ogg','sound/ambience/ambidet2.ogg')

/area/security/detectives_office/private_investigators_office
	name = "Private Investigator's Office"
	icon_state = "investigate_office"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/security/range
	name = "Firing Range"
	icon_state = "firingrange"

/area/security/execution
	icon_state = "execution_room"

/area/security/execution/transfer
	name = "Transfer Centre"
	icon_state = "sec_processing"

/area/security/execution/education
	name = "Prisoner Education Chamber"

/area/security/nuke_storage
	name = "Vault"
	icon_state = "nuke_storage"
	airlock_wires = /datum/wires/airlock/command

/area/ai_monitored/nuke_storage
	name = "Vault"
	icon_state = "nuke_storage"
	airlock_wires = /datum/wires/airlock/command

/area/security/checkpoint
	name = "Security Checkpoint"
	icon_state = "checkpoint1"

/area/security/checkpoint/auxiliary
	icon_state = "checkpoint_aux"

/area/security/checkpoint/escape
	icon_state = "checkpoint_esc"

/area/security/checkpoint/supply
	name = "Security Post - Cargo Bay"
	icon_state = "checkpoint_supp"

/area/security/checkpoint/engineering
	name = "Security Post - Engineering"
	icon_state = "checkpoint_engi"

/area/security/checkpoint/medical
	name = "Security Post - Medbay"
	icon_state = "checkpoint_med"

/area/security/checkpoint/science
	name = "Security Post - Science"
	icon_state = "checkpoint_sci"

/area/security/checkpoint/science/research
	name = "Security Post - Research Division"
	icon_state = "checkpoint_res"

/area/security/checkpoint/customs
	name = "Customs"
	icon_state = "customs_point"

/area/security/checkpoint/customs/auxiliary
	icon_state = "customs_point_aux"


//Service

/area/quartermaster
	name = "Quartermasters"
	icon_state = "quart"
	airlock_wires = /datum/wires/airlock/service
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/quartermaster/sorting
	name = "Delivery Office"
	icon_state = "cargo_delivery"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/quartermaster/warehouse
	name = "Warehouse"
	icon_state = "cargo_warehouse"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/quartermaster/warehouse/upper
	name = "Upper Warehouse"

/area/quartermaster/office
	name = "Cargo Office"
	icon_state = "cargo_office"

/area/quartermaster/storage
	name = "Cargo Bay"
	icon_state = "cargo_bay"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/quartermaster/qm
	name = "Quartermaster's Office"
	icon_state = "quart_office"

/area/quartermaster/qm/perch
	name = "Quartermaster's Perch"
	icon_state = "quart_perch"

/area/quartermaster/miningdock
	name = "Mining Dock"
	icon_state = "mining"

/area/quartermaster/miningoffice
	name = "Mining Office"
	icon_state = "mining"

/area/janitor
	name = "Custodial Closet"
	icon_state = "janitor"
	flags_1 = CULT_PERMITTED_1
	airlock_wires = /datum/wires/airlock/service
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/hydroponics
	name = "Hydroponics"
	icon_state = "hydro"
	airlock_wires = /datum/wires/airlock/service
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/hydroponics/upper
	name = "Upper Hydroponics"
	icon_state = "hydro"

/area/hydroponics/garden
	name = "Garden"
	icon_state = "garden"

/area/hydroponics/garden/abandoned
	name = "Abandoned Garden"
	icon_state = "abandoned_garden"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/hydroponics/garden/monastery
	name = "Monastery Garden"
	icon_state = "hydro"


//Science

/area/science
	name = "Science Division"
	icon_state = "science"
	airlock_wires = /datum/wires/airlock/science
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/science/lab
	name = "Research and Development"
	icon_state = "research"

/area/science/xenobiology
	name = "Xenobiology Lab"
	icon_state = "xenobio"

/area/science/cytology
	name = "Cytology Lab"
	icon_state = "cytology"

/area/science/storage
	name = "Toxins Storage"
	icon_state = "tox_storage"

/area/science/test_area
	name = "Toxins Test Area"
	icon_state = "tox_test"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA

/area/science/mixing
	name = "Toxins Mixing Lab"
	icon_state = "tox_mix"

/area/science/mixing/chamber
	name = "Toxins Mixing Chamber"
	icon_state = "tox_mix_chamber"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA

/area/science/genetics
	name = "Genetics Lab"
	icon_state = "geneticssci"

/area/science/misc_lab
	name = "Testing Lab"
	icon_state = "tox_misc"

/area/science/misc_lab/range
	name = "Research Testing Range"
	icon_state = "tox_range"

/area/science/server
	name = "Research Division Server Room"
	icon_state = "server"

/area/science/explab
	name = "Experimentation Lab"
	icon_state = "exp_lab"

/area/science/robotics
	name = "Robotics"
	icon_state = "robotics"

/area/science/robotics/mechbay
	name = "Mech Bay"
	icon_state = "mechbay"

/area/science/robotics/lab
	name = "Robotics Lab"
	icon_state = "ass_line"

/area/science/research
	name = "Research Division"
	icon_state = "science"

/area/science/research/abandoned
	name = "Abandoned Research Lab"
	icon_state = "abandoned_sci"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/science/nanite
	name = "Nanite Lab"
	icon_state = "nanite"

//Storage
/area/storage
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/storage/tools
	name = "Auxiliary Tool Storage"
	icon_state = "tool_storage"

/area/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primary_storage"

/area/storage/art
	name = "Art Supply Storage"
	icon_state = "art_storage"

/area/storage/tcom
	name = "Telecomms Storage"
	icon_state = "tcom"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA

/area/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/storage/emergency/starboard
	name = "Starboard Emergency Storage"
	icon_state = "emergency_storage"

/area/storage/emergency/port
	name = "Port Emergency Storage"
	icon_state = "emergency_storage"

/area/storage/tech
	name = "Technical Storage"
	icon_state = "aux_storage"

/area/storage/mining
	name = "Public Mining Storage"
	icon_state = "mining"

//Construction

/area/construction
	name = "Construction Area"
	icon_state = "construction"
	ambience_index = AMBIENCE_ENGI
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/construction/mining/aux_base
	name = "Auxiliary Base Construction"
	icon_state = "aux_base_construction"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/construction/storage_wing
	name = "Storage Wing"
	icon_state = "storage_wing"

// Vacant Rooms
/area/vacant_room
	name = "Vacant Room"
	icon_state = "vacant_room"
	ambience_index = AMBIENCE_MAINT

/area/vacant_room/office
	name = "Vacant Office"
	icon_state = "vacant_office"

/area/vacant_room/commissary
	name = "Vacant Commissary"
	icon_state = "vacant_commissary"

//AI

/area/ai_monitored
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/ai_monitored/security/armory
	name = "Armory"
	icon_state = "armory"
	ambience_index = AMBIENCE_DANGER
	airlock_wires = /datum/wires/airlock/security

/area/ai_monitored/security/armory/upper
	name = "Upper Armory"

/area/ai_monitored/storage/eva
	name = "EVA Storage"
	icon_state = "eva"
	ambience_index = AMBIENCE_DANGER

/area/ai_monitored/storage/eva/upper
	name = "Upper EVA Storage"

/area/ai_monitored/storage/satellite
	name = "AI Satellite Maint"
	icon_state = "ai_storage"
	ambience_index = AMBIENCE_DANGER
	airlock_wires = /datum/wires/airlock/ai

	//Turret_protected

/area/ai_monitored/turret_protected
	ambientsounds = list('sound/ambience/ambimalf.ogg', 'sound/ambience/ambitech.ogg', 'sound/ambience/ambitech2.ogg', 'sound/ambience/ambiatmos.ogg', 'sound/ambience/ambiatmos2.ogg')
	airlock_wires = /datum/wires/airlock/ai

/area/ai_monitored/turret_protected/ai_upload
	name = "AI Upload Chamber"
	icon_state = "ai_upload"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/ai_monitored/turret_protected/ai_upload_foyer
	name = "AI Upload Access"
	icon_state = "ai_upload_foyer"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/ai_monitored/turret_protected/ai
	name = "AI Chamber"
	icon_state = "ai_chamber"

/area/ai_monitored/turret_protected/aisat
	name = "AI Satellite"
	icon_state = "ai"
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/ai_monitored/turret_protected/aisat/atmos
	name = "AI Satellite Atmos"
	icon_state = "ai"

/area/ai_monitored/turret_protected/aisat/foyer
	name = "AI Satellite Foyer"
	icon_state = "ai_foyer"

/area/ai_monitored/turret_protected/aisat/service
	name = "AI Satellite Service"
	icon_state = "ai"

/area/ai_monitored/turret_protected/aisat/hallway
	name = "AI Satellite Hallway"
	icon_state = "ai"

/area/aisat
	name = "AI Satellite Exterior"
	icon_state = "ai"
	airlock_wires = /datum/wires/airlock/ai

/area/ai_monitored/turret_protected/aisat_interior
	name = "AI Satellite Antechamber"
	icon_state = "ai_interior"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/ai_monitored/turret_protected/ai_sat_ext_as
	name = "AI Sat Ext"
	icon_state = "ai_sat_east"

/area/ai_monitored/turret_protected/ai_sat_ext_ap
	name = "AI Sat Ext"
	icon_state = "ai_sat_west"


// Telecommunications Satellite

/area/tcommsat
	ambientsounds = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg', 'sound/ambience/ambitech.ogg',\
											'sound/ambience/ambitech2.ogg', 'sound/ambience/ambitech3.ogg', 'sound/ambience/ambimystery.ogg')
	airlock_wires = /datum/wires/airlock/engineering
	network_root_id = STATION_NETWORK_ROOT	// They should of unpluged the router before they left

/area/tcommsat/computer
	name = "Telecomms Control Room"
	icon_state = "tcomsatcomp"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/tcommsat/server
	name = "Telecomms Server Room"
	icon_state = "tcomsatcham"

/area/tcommsat/server/upper
	name = "Upper Telecomms Server Room"

//External Hull Access
/area/maintenance/external
	name = "External Hull Access"
	icon_state = "amaint"

/area/maintenance/external/aft
	name = "Aft External Hull Access"

/area/maintenance/external/port
	name = "Port External Hull Access"

/area/maintenance/external/port/bow
	name = "Port Bow External Hull Access"
