#define MAX_EMAG_ROCKETS 5
#define BEACON_COST 500
#define SP_LINKED 1
#define SP_READY 2
#define SP_LAUNCH 3
#define SP_UNLINK 4
#define SP_UNREADY 5

/obj/machinery/computer/cargo/express
	name = "Cargo Computer" //was named express supply console
	desc = "A computer used by the cargo staff to order supplies via a train."
	icon_screen = "supply_express"
	circuit = /obj/item/circuitboard/computer/cargo/express
	blockade_warning = "Bluespace instability detected. Delivery impossible."
	req_access = list(ACCESS_QM)
	is_express = TRUE

	var/list/order_queue = list()
	var/message
	var/printed_beacons = 0 //number of beacons printed. Used to determine beacon names.
	var/list/meme_pack_data
	var/list/supply_packs = list()
	var/obj/item/supplypod_beacon/beacon //the linked supplypod beacon
	var/area/landingzone = /area/quartermaster/storage //where we droppin boys
	var/podType = /obj/structure/closet/supplypod/centcompod
	var/cooldown = 0 //cooldown to prevent printing supplypod beacon spam
	var/locked = FALSE //is the console locked? unlock with ID
	var/usingBeacon = TRUE //is the console in beacon mode? exists to let beacon know when a pod may come in
	var/account_balance = 100
	var/max_orders = 10

/obj/machinery/computer/cargo/express/Initialize()
	. = ..()
	packin_up()
	for(var/obj/item/supplypod_beacon/sb in range(20, src))
		if(sb)
			if(sb.express_console != src)
				sb.altlink_console(src)
				sb.anchored = TRUE

/obj/machinery/computer/cargo/express/on_construction()
	. = ..()
	packin_up()

/obj/machinery/computer/cargo/express/Destroy()
	if(beacon)
		beacon.unlink_console()
	return ..()

/obj/machinery/computer/cargo/express/take_damage(damage_amount, damage_type = BRUTE, damage_flag =0, sound_effect =1)
	return
/obj/machinery/computer/cargo/express/deconstruct(disassembled = TRUE)
	return

/obj/machinery/computer/cargo/express/attackby(obj/item/W, mob/living/user, params)
	if(W.GetID() && allowed(user))
		locked = !locked
		to_chat(user, "<span class='notice'>You [locked ? "lock" : "unlock"] the interface.</span>")
		return
	else if(istype(W, /obj/item/stack/dollar))
		var/obj/item/stack/dollar/D = W
		if(D.get_item_credit_value())
			to_chat(user, "<span class='notice'>You insert [W] in [src].</span>")
			account_balance += D.get_item_credit_value()
			qdel(W)
			to_chat(user, "[src]'s balance now contains [account_balance] credits.")
	else if(istype(W, /obj/item/disk/cargo/bluespace_pod))
		podType = /obj/structure/closet/supplypod/bluespacepod//doesnt effect circuit board, making reversal possible
		to_chat(user, "<span class='notice'>You insert the disk into [src], allowing for advanced supply delivery vehicles.</span>")
		qdel(W)
		return TRUE
	else if(istype(W, /obj/item/supplypod_beacon))
		var/obj/item/supplypod_beacon/sb = W
		if (sb.express_console != src)
			sb.link_console(src, user)
			return TRUE
		else
			to_chat(user, "<span class='alert'>[src] is already linked to [sb].</span>")
	..()

/obj/machinery/computer/cargo/express/emag_act(mob/living/user)
	if(obj_flags & EMAGGED)
		return
	if(user)
		user.visible_message("<span class='warning'>[user] swipes a suspicious card through [src]!</span>",
		"<span class='notice'>You change the routing protocols, allowing the Supply Pod to land anywhere on the station.</span>")
	obj_flags |= EMAGGED
	contraband = TRUE
	// This also sets this on the circuit board
	var/obj/item/circuitboard/computer/cargo/board = circuit
	board.obj_flags |= EMAGGED
	board.contraband = TRUE
	packin_up()

/obj/machinery/computer/cargo/express/proc/packin_up() // oh shit, I'm sorry
	meme_pack_data = list() // sorry for what?
	for(var/pack in subtypesof(/datum/supply_pack/vampire))
		var/datum/supply_pack/vampire/P = new pack()
		if(!P.contains)
			continue
		supply_packs[P.type] = P
	for(var/pack in supply_packs) // our quartermaster taught us not to be ashamed of our supply packs
		var/datum/supply_pack/vampire/P = supply_packs[pack]  // specially since they're such a good price and all
		if(!meme_pack_data[P.group]) // yeah, I see that, your quartermaster gave you good advice
			meme_pack_data[P.group] = list( // it gets cheaper when I return it
				"name" = P.group, // mmhm
				"packs" = list()  // sometimes, I return it so much, I rip the manifest
			) // see, my quartermaster taught me a few things too
		meme_pack_data[P.group]["packs"] += list(list(
			"name" = P.name,
			"cost" = P.cost,
			"id" = pack,
			"desc" = P.desc || P.name // If there is a description, use it. Otherwise use the pack's name.
		))

/obj/machinery/computer/cargo/express/ui_interact(mob/living/user, datum/tgui/ui)
	if(iskindred(user))
		var/mob/living/carbon/human/H = user
		if(H.clan)
			if(H.clan.name == CLAN_LASOMBRA)
				return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CargoExpress", name)
		ui.open()

/obj/machinery/computer/cargo/express/ui_data(mob/user)
	var/canBeacon = beacon && (isturf(beacon.loc) || ismob(beacon.loc))//is the beacon in a valid location?
	var/list/data = list()
	var/list/serialized_order_queue = list()

	for (var/datum/supply_pack/vampire/pack in order_queue)
		serialized_order_queue += list(
		"[pack.name] - [pack.cost] credits"
	)

	data["points"] = account_balance
	data["locked"] = locked//swipe an ID to unlock
	data["siliconUser"] = user.has_unlimited_silicon_privilege
	data["beaconzone"] = beacon ? get_area(beacon) : ""//where is the beacon located? outputs in the tgui
	data["usingBeacon"] = usingBeacon //is the mode set to deliver to the beacon or the cargobay?
	data["canBeacon"] = !usingBeacon || canBeacon //is the mode set to beacon delivery, and is the beacon in a valid location?
	data["canBuyBeacon"] = FALSE
	data["beaconError"] = usingBeacon && !canBeacon ? "(BEACON ERROR)" : ""//changes button text to include an error alert if necessary
	data["hasBeacon"] = beacon != null//is there a linked beacon?
	data["beaconName"] = beacon ? beacon.name : "No Beacon Found"
	data["printMsg"] = cooldown > 0 ? "Print Beacon for [BEACON_COST] credits ([cooldown])" : "Print Beacon for [BEACON_COST] credits"//buttontext for printing beacons
	data["supplies"] = list()
	data["total_order_cost"] = total_order_cost()
	data["order_queue"] = json_encode(serialized_order_queue)
	message = "Sales are near-instantaneous - please choose carefully."
	if(SSshuttle.supplyBlocked)
		message = blockade_warning
	if(usingBeacon && !beacon)
		message = "BEACON ERROR: BEACON MISSING"//beacon was destroyed
	else if (usingBeacon && !canBeacon)
		message = "BEACON ERROR: MUST BE EXPOSED"//beacon's loc/user's loc must be a turf
	if(obj_flags & EMAGGED)
		message = "(&!#@ERROR: R0UTING_#PRO7O&OL MALF(*CT#ON. $UG%ESTE@ ACT#0N: !^/PULS3-%E)ET CIR*)ITB%ARD."
	data["message"] = message
	if(!meme_pack_data)
		packin_up()
		stack_trace("There was no pack data for [src]")
	data["supplies"] = meme_pack_data
	if (cooldown > 0)//cooldown used for printing beacons
		cooldown--
	return data

/obj/machinery/computer/cargo/express/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
//		if("LZCargo")
//			usingBeacon = FALSE
//			if (beacon)
//				beacon.update_status(SP_UNREADY) //ready light on beacon will turn off

		if("add_to_queue")
			var/id = text2path(params["id"])
			var/datum/supply_pack/vampire/pack = supply_packs[id]
			if(!istype(pack))
				return
			order_queue += list(pack)
			to_chat(usr, "Added [pack.name] to the order queue.")
			return TRUE

		if("remove_from_queue")
			var/id = text2path(params["id"])
			var/datum/supply_pack/vampire/pack = supply_packs[id]
			if(pack in order_queue)
				order_queue -= list(pack)
				to_chat(usr, "Removed [pack.name] from the order queue.")
			else
				to_chat(usr, "Could not find [pack.name] in the order queue.")
			return TRUE
		if("reset_queue")
			order_queue = list()
			to_chat(usr, "Order queue reset.")
			return TRUE
		if("finalize_order")
			var/list/final_order = order_queue.Copy()
			if(!final_order.len)
				to_chat(usr, "Order queue is empty.")
				return
			if(final_order.len > max_orders)
				to_chat(usr, "You can only make 10 orders at a time!")
				return
			if(account_balance < total_order_cost())
				to_chat(usr, "Insufficient funds.")
				return
			account_balance -= total_order_cost()
			var/LZ
			if(istype(beacon) && usingBeacon)
				LZ = get_turf(beacon)
				beacon.update_status(SP_LAUNCH)
				TIMER_COOLDOWN_START(src, COOLDOWN_EXPRESSPOD_CONSOLE, 5 SECONDS)
				var/obj/cargotrain/train = new(get_farthest_open_chain_turf(LZ))
				train.starter = usr
				train.glide_size = (32 / 3) * world.tick_lag
				walk_to(train, LZ, 1, 3)
				playsound(train, 'code/modules/wod13/sounds/train_arrive.ogg', 50, FALSE)
				var/track_travel_time = get_dist(get_farthest_open_chain_turf(LZ), LZ)*5
				spawn(track_travel_time)
					var/obj/structure/closet/crate/crate = new(get_turf(train))
					crate.name = "Supply Crate"
					for(var/datum/supply_pack/vampire/pack in final_order)
						for(var/item_path in pack.contains)
							if(!pack.contains[item_path])
								pack.contains[item_path] = 1
							for(var/iteration = 1 to pack.contains[item_path])
								var/obj/item/item_instance = new item_path
								item_instance.forceMove(crate)
					playsound(train, 'code/modules/wod13/sounds/train_depart.ogg', 50, FALSE)
					walk_to(train, get_farthest_open_chain_turf(LZ), 1, 3)
					spawn(track_travel_time)
						qdel(train)
					order_queue.Cut()
				return

/obj/machinery/computer/cargo/express/proc/total_order_cost()
	var/total = 0
	for(var/datum/supply_pack/vampire/pack in order_queue)
		total += pack.cost
	return total

/*		if("LZBeacon")
			usingBeacon = TRUE
			if (beacon)
				beacon.update_status(SP_READY) //turns on the beacon's ready light
//		if("printBeacon")
//			var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_CAR)
//			if(D)
//				if(D.adjust_money(-BEACON_COST))
//					cooldown = 10//a ~ten second cooldown for printing beacons to prevent spam
//					var/obj/item/supplypod_beacon/C = new /obj/item/supplypod_beacon(drop_location())
//					C.link_console(src, usr)//rather than in beacon's Initialize(), we can assign the computer to the beacon by reusing this proc)
//					printed_beacons++//printed_beacons starts at 0, so the first one out will be called beacon # 1
//					beacon.name = "Supply Pod Beacon #[printed_beacons]"


		if("add")//Generate Supply Order first
			if(TIMER_COOLDOWN_CHECK(src, COOLDOWN_EXPRESSPOD_CONSOLE))
				say("Railgun recalibrating. Stand by.")
				return
			var/id = text2path(params["id"])
			var/datum/supply_pack/vampire/pack = supply_packs[id]
			if(!istype(pack))
				return
			var/name = "*None Provided*"
			var/rank = "*None Provided*"
			var/ckey = usr.ckey
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				name = H.get_authentification_name()
				rank = H.get_assignment(hand_first = TRUE)
			else if(issilicon(usr))
				name = usr.real_name
				rank = "Silicon"
			var/reason = ""
			var/list/empty_turfs
			var/datum/supply_order/SO = new(pack, name, rank, ckey, reason)
			var/points_to_check = account_balance
			if(!(obj_flags & EMAGGED))
				if(SO.pack.cost <= points_to_check)
					var/LZ
					if (istype(beacon) && usingBeacon)//prioritize beacons over landing in cargobay
						LZ = get_turf(beacon)
						beacon.update_status(SP_LAUNCH)
//					else if (!usingBeacon)//find a suitable supplypod landing zone in cargobay
//						landingzone = GLOB.areas_by_type[/area/vtm/supply]
//						if (!landingzone)
//							WARNING("[src] couldnt find a Quartermaster/Storage (aka cargobay) area on the station, and as such it has set the supplypod landingzone to the area it resides in.")
//							landingzone = get_area(src)
//						for(var/turf/open/floor/T in landingzone.contents)//uses default landing zone
//							if(T.is_blocked_turf())
//								continue
//							LAZYADD(empty_turfs, T)
//							CHECK_TICK
//						if(empty_turfs?.len)
//							LZ = pick(empty_turfs)
					if (SO.pack.cost <= points_to_check && LZ)//we need to call the cost check again because of the CHECK_TICK call
						TIMER_COOLDOWN_START(src, COOLDOWN_EXPRESSPOD_CONSOLE, 5 SECONDS)
						account_balance = max(0, account_balance-SO.pack.cost)
						var/obj/cargotrain/train = new(get_farthest_open_chain_turf(LZ))
						train.starter = usr
						train.glide_size = (32 / 3) * world.tick_lag
						walk_to(train, LZ, 1, 3)
						playsound(train, 'code/modules/wod13/sounds/train_arrive.ogg', 50, FALSE)
						var/track_travel_time = get_dist(get_farthest_open_chain_turf(LZ), LZ)*5
						spawn(track_travel_time)
							SO.generate(get_turf(train))
							playsound(train, 'code/modules/wod13/sounds/train_depart.ogg', 50, FALSE)
							walk_to(train, get_farthest_open_chain_turf(LZ), 1, 3)
							spawn(track_travel_time)
								qdel(train)
//						if(pack.special_pod)
//							new /obj/effect/pod_landingzone(LZ, pack.special_pod, SO)
//						else
//							new /obj/effect/pod_landingzone(LZ, podType, SO)
						. = TRUE
						update_appearance()
			else
				if(SO.pack.cost * (0.72*MAX_EMAG_ROCKETS) <= points_to_check) // bulk discount :^)
					landingzone = GLOB.areas_by_type[pick(GLOB.the_station_areas)]  //override default landing zone
					for(var/turf/open/floor/T in landingzone.contents)
						if(T.is_blocked_turf())
							continue
						LAZYADD(empty_turfs, T)
						CHECK_TICK
					if(empty_turfs?.len)
						TIMER_COOLDOWN_START(src, COOLDOWN_EXPRESSPOD_CONSOLE, 10 SECONDS)
						account_balance = max(0, account_balance-(SO.pack.cost*(0.72*MAX_EMAG_ROCKETS)))

						SO.generateRequisition(get_turf(src))
						for(var/i in 1 to MAX_EMAG_ROCKETS)
							var/LZ = pick(empty_turfs)
							LAZYREMOVE(empty_turfs, LZ)
							var/obj/cargotrain/train = new(get_farthest_open_chain_turf(LZ))
							train.starter = usr
							train.glide_size = (32 / 3) * world.tick_lag
							walk_to(train, LZ, 1, 3)
							playsound(train, 'code/modules/wod13/sounds/train_arrive.ogg', 50, FALSE)
							var/track_travel_time = get_dist(get_farthest_open_chain_turf(LZ), LZ)*5
							spawn(track_travel_time)
								playsound(train, 'code/modules/wod13/sounds/train_depart.ogg', 50, FALSE)
								SO.generate(get_turf(train))
								walk_to(train, get_farthest_open_chain_turf(LZ), 1, 3)
								spawn(track_travel_time)
									qdel(train)
//							if(pack.special_pod)
//								new /obj/effect/pod_landingzone(LZ, pack.special_pod, SO)
//							else
//								new /obj/effect/pod_landingzone(LZ, podType, SO)
							. = TRUE
							update_appearance()
							CHECK_TICK
*/
