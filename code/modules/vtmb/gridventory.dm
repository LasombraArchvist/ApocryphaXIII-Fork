//Meet the...

//...

//...

/*
GRIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIID-
VENTORY!
*/

/// Must be in the user's hands to be accessed
#define STORAGE_NO_WORN_ACCESS (1<<0)
/// Must be out of the user to be accessed
#define STORAGE_NO_EQUIPPED_ACCESS (1<<1)
/// jimmy joger variable
#define CHECK_BITFIELD(variable, flag) (variable & (flag))

/obj/item/storage/Initialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		STR.grid = grid
		STR.storage_flags = storage_flags
	update_grid_inventory()

/obj/item/storage/proc/update_grid_inventory()
	//this is stupid shitcode but grid inventory sadly requires it
	var/drop_location = drop_location()
	for(var/obj/item/item_in_source in contents)
		if(drop_location)
			item_in_source.forceMove(drop_location)
		else
			item_in_source.moveToNullspace()
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, item_in_source, null, TRUE, FALSE, FALSE)


// storage types //

/datum/component/storage/concrete/vtm
	grid = TRUE
	max_w_class = WEIGHT_CLASS_BULKY
	max_combined_w_class = 1000
	max_items = 1000

/datum/component/storage/concrete/vtm/satchel
	screen_max_columns = 6
	screen_max_rows = 6

/datum/component/storage/concrete/vtm/backpack
	screen_max_columns = 6
	screen_max_rows = 7

/datum/component/storage/concrete/vtm/duffel
	screen_max_columns = 8
	screen_max_rows = 6

/datum/component/storage/concrete/vtm/firstaid
	screen_max_columns = 4
	screen_max_rows = 4

/datum/component/storage/concrete/vtm/firstaid/ifak
	screen_max_columns = 3
	screen_max_rows = 3

/obj/item/storage/backpack
	component_type = /datum/component/storage/concrete/vtm/backpack

/datum/component/storage/concrete/vtm/holster
	screen_max_columns = 2
	screen_max_rows = 2

/datum/component/storage/concrete/vtm/belt
	screen_max_columns = 2
	screen_max_rows = 4

/datum/component/storage/concrete/vtm/hardcase
	screen_max_columns = 4
	screen_max_rows = 4

/datum/component/storage/concrete/vtm/car
	max_w_class = WEIGHT_CLASS_HUGE
	screen_max_columns = 7
	screen_max_rows = 9

/datum/component/storage/concrete/vtm/car/track
	max_w_class = WEIGHT_CLASS_GIGANTIC
	screen_max_columns = 13
	screen_max_rows = 9

/datum/component/storage/concrete/vtm/sheathe
	screen_max_columns = 2
	screen_max_rows = 5

/datum/component/storage
	screen_max_columns = 5
	screen_max_rows = 5
	screen_pixel_x = 0
	screen_pixel_y = 0
	screen_start_x = 1
	screen_start_y = 9
	rustle_sound = list(
		'sound/effects/rustle1.ogg',
		'sound/effects/rustle2.ogg',
		'sound/effects/rustle3.ogg',
		'sound/effects/rustle4.ogg',
		'sound/effects/rustle5.ogg',
	)
	/// Exactly what it sounds like, this makes it use the new RE4-like inventory system
	var/grid = TRUE
	var/static/grid_box_size
	var/static/list/mutable_appearance/underlay_appearances_by_size = list()
	var/list/grid_coordinates_to_item
	var/list/item_to_grid_coordinates
	var/maximum_depth = 1
	var/storage_flags = NONE

/obj/item/storage/ComponentInitialize() //backpacks are smaller but hold larger things
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	// ! THESE SHOULD BE ARGS YOU PASS INTO ADDCOMPONENT
	STR.max_w_class = WEIGHT_CLASS_HUGE
	STR.max_items = 40 //max grid
	STR.max_combined_w_class = 100

/datum/component/storage/Initialize(datum/component/storage/concrete/master, _screen_max_columns, _screen_max_rows)
	if(!grid_box_size)
		grid_box_size = world.icon_size
	. = ..()
	if(!.)
		return
	RegisterSignal(parent, COMSIG_STORAGE_BLOCK_USER_TAKE, PROC_REF(should_block_user_take))

/datum/component/storage/orient2hud()
	var/atom/real_location = real_location()
	var/adjusted_contents = LAZYLEN(real_location.contents)

	//Numbered contents display
	var/list/datum/numbered_display/numbered_contents
	if(display_numerical_stacking)
		numbered_contents = _process_numerical_display()
		adjusted_contents = LAZYLEN(numbered_contents)

	var/rows = 0
	var/columns = 0
	var/datum/component/storage/master = master()
	if(!master.grid)
		rows = clamp(max_items, 1, screen_max_rows)
		columns = clamp(CEILING(adjusted_contents / rows, 1), 1, screen_max_columns)
	else
		rows = screen_max_rows
		columns = screen_max_columns
	return standard_orient_objs(rows, columns, numbered_contents)

/datum/component/storage/standard_orient_objs(rows = 0, cols = 0, list/obj/item/numerical_display_contents)
	var/datum/component/storage/master = master()
	boxes.screen_loc = "[screen_start_x]:[screen_pixel_x],[screen_start_y]:[screen_pixel_y] to [screen_start_x+cols-1]:[screen_pixel_x],[screen_start_y-rows+1]:[screen_pixel_y]"
	if(master.grid)
		var/mutable_appearance/bound_underlay
		var/screen_loc
		var/screen_x
		var/screen_y
		var/screen_pixel_x
		var/screen_pixel_y
		if(islist(numerical_display_contents))
			for(var/index in numerical_display_contents)
				var/datum/numbered_display/numbered_display = numerical_display_contents[index]
				var/obj/item/stored_item = numbered_display.sample_object
				stored_item.mouse_opacity = MOUSE_OPACITY_OPAQUE
				bound_underlay = LAZYACCESS(underlay_appearances_by_size, "[stored_item.grid_width]x[stored_item.grid_height]")
				if(!bound_underlay)
					bound_underlay = generate_bound_underlay(stored_item.grid_width, stored_item.grid_height)
					underlay_appearances_by_size["[stored_item.grid_width]x[stored_item.grid_height]"] = bound_underlay
				stored_item.underlays = null
				stored_item.underlays += bound_underlay
				screen_loc = LAZYACCESSASSOC(master.item_to_grid_coordinates, stored_item, 1)
				screen_loc = master.grid_coordinates_to_screen_loc(screen_loc)
				screen_x = copytext(screen_loc, 1, findtext(screen_loc, ","))
				screen_pixel_x = text2num(copytext(screen_x, findtext(screen_x, ":") + 1))
				screen_pixel_x += (world.icon_size/2)*((stored_item.grid_width/world.icon_size)-1)
				screen_x = text2num(copytext(screen_x, 1, findtext(screen_x, ":")))
				screen_y = copytext(screen_loc, findtext(screen_loc, ",") + 1)
				screen_pixel_y = text2num(copytext(screen_y, findtext(screen_y, ":") + 1))
				screen_pixel_y += (world.icon_size/2)*((stored_item.grid_height/world.icon_size)-1)
				screen_y = text2num(copytext(screen_y, 1, findtext(screen_y, ":")))
				stored_item.screen_loc = "[screen_x]:[screen_pixel_x],[screen_y]:[screen_pixel_y]"
				stored_item.plane = ABOVE_HUD_PLANE
				stored_item.maptext = MAPTEXT("<font color='white'>[(numbered_display.number > 1)? "[numbered_display.number]" : ""]</font>")
		else
			var/atom/real_location = real_location()
			for(var/obj/item/stored_item in real_location)
				if(QDELETED(stored_item))
					continue
				stored_item.mouse_opacity = MOUSE_OPACITY_OPAQUE
				bound_underlay = LAZYACCESS(underlay_appearances_by_size, "[stored_item.grid_width]x[stored_item.grid_height]")
				if(!bound_underlay)
					bound_underlay = generate_bound_underlay(stored_item.grid_width, stored_item.grid_height)
					underlay_appearances_by_size["[stored_item.grid_width]x[stored_item.grid_height]"] = bound_underlay
				stored_item.underlays = null
				stored_item.underlays += bound_underlay
				screen_loc = LAZYACCESSASSOC(master.item_to_grid_coordinates, stored_item, 1)
				screen_loc = master.grid_coordinates_to_screen_loc(screen_loc)
				screen_x = copytext(screen_loc, 1, findtext(screen_loc, ","))
				screen_pixel_x = text2num(copytext(screen_x, findtext(screen_x, ":") + 1))
				screen_pixel_x += (world.icon_size/2)*((stored_item.grid_width/world.icon_size)-1)
				screen_x = text2num(copytext(screen_x, 1, findtext(screen_x, ":")))
				screen_y = copytext(screen_loc, findtext(screen_loc, ",") + 1)
				screen_pixel_y = text2num(copytext(screen_y, findtext(screen_y, ":") + 1))
				screen_pixel_y += (world.icon_size/2)*((stored_item.grid_height/world.icon_size)-1)
				screen_y = text2num(copytext(screen_y, 1, findtext(screen_y, ":")))
				stored_item.screen_loc = "[screen_x]:[screen_pixel_x],[screen_y]:[screen_pixel_y]"
				stored_item.plane = ABOVE_HUD_PLANE
				stored_item.maptext = ""
		update_closer(rows, cols)
		return
	var/cx = screen_start_x
	var/cy = screen_start_y
	if(islist(numerical_display_contents))
		for(var/index in numerical_display_contents)
			var/datum/numbered_display/numbered_display = numerical_display_contents[index]
			numbered_display.sample_object.mouse_opacity = MOUSE_OPACITY_OPAQUE
			numbered_display.sample_object.screen_loc = "[cx]:[screen_pixel_x],[cy]:[screen_pixel_y]"
			numbered_display.sample_object.maptext = MAPTEXT("<font color='white'>[(numbered_display.number > 1)? "[numbered_display.number]" : ""]</font>")
			numbered_display.sample_object.plane = ABOVE_HUD_PLANE
			cy--
			if(screen_start_y - cy >= rows)
				cy = screen_start_y
				cx++
				if(cx - screen_start_x >= cols)
					break
	else
		var/atom/real_location = real_location()
		for(var/obj/stored_object in real_location)
			if(QDELETED(stored_object))
				continue
			stored_object.mouse_opacity = MOUSE_OPACITY_OPAQUE //This is here so storage items that spawn with contents correctly have the "click around item to equip"
			stored_object.screen_loc = "[cx]:[screen_pixel_x],[cy]:[screen_pixel_y]"
			stored_object.maptext = ""
			stored_object.plane = ABOVE_HUD_PLANE
			cy--
			if(screen_start_y - cy >= rows)
				cy = screen_start_y
				cx++
				if(cx - screen_start_x >= cols)
					break
	update_closer(rows, cols)

/datum/component/storage/_process_numerical_display()
	. = list()
	var/atom/real_location = real_location()
	for(var/obj/item/stored_item in real_location.contents)
		if(QDELETED(stored_item))
			continue
		if(!.["[stored_item.type]-[stored_item.name]"])
			.["[stored_item.type]-[stored_item.name]"] = new /datum/numbered_display(stored_item, 1)
		else
			var/datum/numbered_display/number_display = .["[stored_item.type]-[stored_item.name]"]
			number_display.number++

/datum/component/storage/signal_insertion_attempt(datum/source,
												obj/item/storing,
												mob/user,
												silent = FALSE,
												force = FALSE,
												worn_check = FALSE,
												params)
	if((!force && !can_be_inserted(storing, TRUE, user, worn_check, params = params)) || (storing == parent))
		return FALSE
	return handle_item_insertion(storing, silent, user, params = params, storage_click = FALSE)

/datum/component/storage/can_be_inserted(obj/item/storing, stop_messages, mob/user, worn_check = FALSE, params, storage_click = FALSE)
	if(!istype(storing) || (storing.item_flags & ABSTRACT))
		return FALSE //Not an item
	if(storing == parent)
		return FALSE //No paradoxes for you
	var/atom/host = parent
	var/atom/real_location = real_location()
	if(real_location == storing.loc)
		return FALSE //Means the item is already in the storage item
	if(locked)
		if(user && !stop_messages)
			host.add_fingerprint(user)
			to_chat(user, span_warning("[host] seems to be locked!"))
		return FALSE
	if(worn_check && !worn_check(parent, user))
		host.add_fingerprint(user)
		return FALSE
	if(LAZYLEN(real_location.contents) >= max_items)
		if(!stop_messages)
			to_chat(user, span_warning("[host] is full, make some space!"))
		return FALSE //Storage item is full
	if(LAZYLEN(can_hold))
		if(!is_type_in_typecache(storing, can_hold))
			if(!stop_messages)
				to_chat(user, span_warning("[host] cannot hold [storing]!"))
			return FALSE
	if(is_type_in_typecache(storing, cant_hold) || HAS_TRAIT(storing, TRAIT_NO_STORAGE_INSERT) || (can_hold_trait && !HAS_TRAIT(storing, can_hold_trait))) //Items which this container can't hold.
		if(!stop_messages)
			to_chat(user, span_warning("[host] cannot hold [storing]!"))
		return FALSE
	if((storing.w_class > max_w_class) && !is_type_in_typecache(storing, exception_hold))
		if(!stop_messages)
			to_chat(user, span_warning("[storing] is too big for [host]!"))
		return FALSE
	var/atom/recursive_loc = real_location?.loc
	var/depth = 0
	while(ismovable(recursive_loc))
		depth++
		var/datum/component/storage/biggerfish = recursive_loc.GetComponent(/datum/component/storage)
		if(biggerfish)
			//return false if we are inside of another container, and that container has a smaller max_w_class than us (like if we're a bag in a box)
			if(biggerfish.max_w_class < max_w_class)
				if(!stop_messages)
					to_chat(user, span_warning("[storing] can't fit in [host] while [recursive_loc] is in the way!"))
				return FALSE
			else if(worn_check && !biggerfish.worn_check(storing, user, stop_messages))
				if(!stop_messages)
					to_chat(user, span_warning("[storing] can't fit in [host] while [recursive_loc] is in the way!"))
				return FALSE
			else if(biggerfish.maximum_depth < depth)
				if(!stop_messages)
					to_chat(user, span_warning("[storing] can't fit in [host] while [recursive_loc] is in the way!"))
				return FALSE
		recursive_loc = recursive_loc.loc
	var/sum_w_class = storing.w_class
	for(var/obj/item/stored_item in real_location)
		sum_w_class += stored_item.w_class //Adds up the combined w_classes which will be in the storage item if the item is added to it.
	if(sum_w_class > max_combined_w_class)
		if(!stop_messages)
			to_chat(user, span_warning("[storing] won't fit in [host], make some space!"))
		return FALSE
	if(isitem(host))
		var/obj/item/host_item = host
		var/datum/component/storage/storage_internal = storing.GetComponent(/datum/component/storage)
		if((storing.w_class >= host_item.w_class) && storage_internal && !allow_big_nesting)
			if(!stop_messages)
				to_chat(user, span_warning("[host_item] cannot hold [storing] as it's a storage item of the same size!"))
			return FALSE //To prevent the stacking of same sized storage items
	//SHOULD be handled in unEquip, but better safe than sorry
	if(HAS_TRAIT(storing, TRAIT_NODROP))
		if(!stop_messages)
			to_chat(user, span_warning("\The [storing] is stuck to your hand, you can't put it in \the [host]!"))
		return FALSE
	var/datum/component/storage/concrete/master = master()
	if(!istype(master))
		return FALSE
	return master.slave_can_insert_object(src, storing, stop_messages, user, params = params, storage_click = storage_click)

/datum/component/storage/handle_item_insertion(obj/item/storing, prevent_warning = FALSE, mob/user, datum/component/storage/remote, params, storage_click = FALSE)
	var/atom/parent = src.parent
	var/datum/component/storage/concrete/master = master()
	if(!istype(master))
		return FALSE
	if(silent)
		prevent_warning = TRUE
	if(user)
		parent.add_fingerprint(user)
	return master.handle_item_insertion_from_slave(src, storing, prevent_warning, user, params = params, storage_click = storage_click)

/datum/component/storage/signal_take_obj(datum/source, atom/movable/taken, new_loc, force = FALSE)
	if(!(taken in real_location()))
		return FALSE
	return remove_from_storage(taken, new_loc)

/datum/component/storage/remove_from_storage(atom/movable/removed, atom/new_location)
	if(!istype(removed))
		return FALSE
	var/datum/component/storage/concrete/master = master()
	if(!istype(master))
		return FALSE
	return master.remove_from_storage(removed, new_location)

//This proc is called when you want to place an item into the storage item
/datum/component/storage/attackby(datum/source, obj/item/attacking_item, mob/user, params, storage_click = FALSE)
	if(istype(attacking_item, /obj/item/hand_labeler))
		var/obj/item/hand_labeler/labeler = attacking_item
		if(labeler.mode)
			return FALSE
	. = TRUE //no afterattack
	if(iscyborg(user))
		return
	if(!can_be_inserted(attacking_item, FALSE, user, params = params, storage_click = storage_click))
		var/atom/real_location = real_location()
		if(LAZYLEN(real_location.contents) >= max_items) //don't use items on the backpack if they don't fit
			return TRUE
		return FALSE
	return handle_item_insertion(attacking_item, FALSE, user, params = params, storage_click = storage_click)

/datum/component/storage/proc/on_equipped(obj/item/source, mob/user, slot)
	SIGNAL_HANDLER

	var/atom/parent_atom = parent
	for(var/mob/living/living_viewer in can_see_contents())
		if(!living_viewer.CanReach(parent_atom))
			hide_from(living_viewer)
	if(!worn_check_aggressive(parent, user, TRUE))
		hide_from(user)
	update_actions()

/datum/component/storage/proc/worn_check(obj/item/storing, mob/user, no_message = FALSE)
	. = TRUE
	if(!istype(storing) || !istype(user) || !CHECK_BITFIELD(storage_flags, STORAGE_NO_WORN_ACCESS|STORAGE_NO_EQUIPPED_ACCESS))
		return TRUE

	if((storage_flags & STORAGE_NO_EQUIPPED_ACCESS) && (storing.item_flags & IN_INVENTORY))
		if(!no_message)
			to_chat(user, span_warning("[storing] is too bulky! I need to set it down before I can access it's contents!"))
		return FALSE
	else if((storage_flags & STORAGE_NO_WORN_ACCESS) && (storing.item_flags & IN_INVENTORY) && !(storing in user.held_items))
		if(!no_message)
			to_chat(user, span_warning("My arms aren't long enough to reach into [storing] while wearing it!"))
		return FALSE

/datum/component/storage/proc/worn_check_aggressive(obj/item/storing, mob/user, no_message = FALSE)
	. = TRUE
	if(!istype(storing) || !istype(user) || !CHECK_BITFIELD(storage_flags, STORAGE_NO_WORN_ACCESS|STORAGE_NO_EQUIPPED_ACCESS))
		return TRUE

	if(storage_flags & STORAGE_NO_EQUIPPED_ACCESS)
		if(!no_message)
			to_chat(user, span_warning("[storing] is too bulky! I need to set it down before I can access it's contents!"))
		return FALSE
	else if((storage_flags & STORAGE_NO_WORN_ACCESS) && !(storing in user.held_items))
		if(!no_message)
			to_chat(user, span_warning("My arms aren't long enough to reach into [storing] while wearing it!"))
		return FALSE

/datum/component/storage/proc/should_block_user_take(obj/item/stored, mob/user, worn_check = FALSE, no_message = FALSE)
	if(worn_check && !worn_check(parent, user, no_message))
		return TRUE
	var/atom/real_location = real_location()
	var/atom/recursive_loc = real_location?.loc
	var/depth = 0
	while(isatom(recursive_loc) && !isturf(recursive_loc) && !isarea(recursive_loc))
		var/datum/component/storage/biggerfish = recursive_loc.GetComponent(/datum/component/storage)
		if(biggerfish)
			depth++
			if(!biggerfish.worn_check(biggerfish.parent, user, TRUE))
				if(!no_message)
					to_chat(user, span_warning("[recursive_loc] is in the way!"))
				return TRUE
			else if(biggerfish.maximum_depth < depth)
				if(!no_message)
					to_chat(user, span_warning("[recursive_loc] is in the way!"))
				return TRUE
		recursive_loc = recursive_loc.loc
	return FALSE

/datum/component/storage/proc/update_closer(rows = 0, cols = 0)
	closer.cut_overlays()
	closer.icon_state = "close"
	var/half = (cols - 1)/2
	var/half_ceiling = CEILING(half, 1)
	var/half_floor = FLOOR(half, 1)
	closer.screen_loc = "[src.screen_start_x+half_floor]:[src.screen_pixel_x],[src.screen_start_y+1]:[src.screen_pixel_y]"
	switch(cols)
		if(-INFINITY to 1)
			closer.icon_state = "close"
		if(2)
			closer.icon_state = "close_left"
		if(3 to INFINITY)
			closer.icon_state = "close_mid"
	var/image/offset_image
	for(var/overlayer in 1 to half_floor)
		var/state = (overlayer >= half_floor) ? "close_left" : "close_mid"
		offset_image = image(closer.icon, state)
		offset_image.transform = offset_image.transform.Translate(world.icon_size * -overlayer, 0)
		closer.add_overlay(offset_image)
	for(var/overlayer in 1 to half_ceiling)
		var/state = (overlayer >= half_ceiling) ? "close_right" : "close_mid"
		offset_image = image(closer.icon, state)
		offset_image.transform = offset_image.transform.Translate(world.icon_size * overlayer, 0)
		closer.add_overlay(offset_image)
	if(cols > 1)
		var/image/close_overlay = image(closer.icon, "close_overlay")
		close_overlay.transform = close_overlay.transform.Translate(world.icon_size * (half - half_floor), 0)
		closer.add_overlay(close_overlay)

/datum/component/storage/proc/screen_loc_to_grid_coordinates(screen_loc = "")
	if(!grid)
		return FALSE
	var/screen_x = copytext(screen_loc, 1, findtext(screen_loc, ","))
	var/screen_pixel_x = text2num(copytext(screen_x, findtext(screen_x, ":") + 1))
	screen_x = text2num(copytext(screen_x, 1, findtext(screen_x, ":")))

	var/screen_y = copytext(screen_loc, findtext(screen_loc, ",") + 1)
	var/screen_pixel_y = text2num(copytext(screen_y, findtext(screen_y, ":") + 1))
	screen_y = text2num(copytext(screen_y, 1, findtext(screen_y, ":")))

	var/screen_x_pixels = (screen_x * world.icon_size) + screen_pixel_x
	screen_x_pixels -= (src.screen_start_x * world.icon_size) + src.screen_pixel_x
	screen_x_pixels = FLOOR(screen_x_pixels/grid_box_size, 1)
	var/screen_y_pixels = (screen_y * world.icon_size) + screen_pixel_y
	screen_y_pixels -= ((src.screen_start_y - src.screen_max_rows + 1) * world.icon_size) + src.screen_pixel_y
	screen_y_pixels = FLOOR(screen_y_pixels/grid_box_size, 1)

	return "[screen_x_pixels],[screen_y_pixels]"

/datum/component/storage/proc/grid_coordinates_to_screen_loc(coordinates = "")
	if(!grid)
		return FALSE

	var/coordinate_x = copytext(coordinates, 1, findtext(coordinates, ","))
	coordinate_x = text2num(copytext(coordinate_x, 1, findtext(coordinate_x, ":")))

	var/coordinate_y = copytext(coordinates, findtext(coordinates, ",") + 1)
	coordinate_y = text2num(copytext(coordinate_y, 1, findtext(coordinate_y, ":")))

	var/screen_x_pixels = coordinate_x * grid_box_size
	screen_x_pixels += (src.screen_start_x * world.icon_size) + src.screen_pixel_x
	var/screen_y_pixels = coordinate_y * grid_box_size
	screen_y_pixels += ((src.screen_start_y - src.screen_max_rows + 1) * world.icon_size) + src.screen_pixel_y

	var/screen_x = FLOOR(screen_x_pixels/world.icon_size, 1)
	var/screen_pixel_x = FLOOR(screen_x_pixels - FLOOR(screen_x_pixels, world.icon_size), 1)
	var/screen_y = FLOOR(screen_y_pixels/world.icon_size, 1)
	var/screen_pixel_y = FLOOR(screen_y_pixels - FLOOR(screen_y_pixels, world.icon_size), 1)

	return "[screen_x]:[screen_pixel_x],[screen_y]:[screen_pixel_y]"

/datum/component/storage/proc/validate_grid_coordinates(coordinates = "", grid_width = 1, grid_height = 1, obj/item/dragged_item)
	if(!grid)
		return FALSE
	var/grid_box_ratio = (world.icon_size/grid_box_size)
	var/screen_x = copytext(coordinates, 1, findtext(coordinates, ","))
	screen_x = text2num(copytext(screen_x, 1, findtext(screen_x, ":")))
	var/screen_y = copytext(coordinates, findtext(coordinates, ",") + 1)
	screen_y = text2num(copytext(screen_y, 1, findtext(screen_y, ":")))
	var/validate_x = FLOOR((grid_width/grid_box_size)-1, 1)
	var/validate_y = FLOOR((grid_height/grid_box_size)-1, 1)
	var/final_x = 0
	var/final_y = 0
	var/final_coordinates = ""
	//this loops through all possible cells in the inventory box that we could overlap when given this screen_x and screen_y
	//and returns false on any failure
	for(var/current_x in 0 to validate_x)
		for(var/current_y in 0 to validate_y)
			final_x = screen_x+current_x
			final_y = screen_y+current_y
			final_coordinates = "[final_x],[final_y]"
			if(final_x >= (screen_max_columns*grid_box_ratio))
				return FALSE
			if(final_y >= (screen_max_rows*grid_box_ratio))
				return FALSE
			var/existing_item = LAZYACCESS(grid_coordinates_to_item, final_coordinates)
			if(existing_item && (!dragged_item || (existing_item != dragged_item)))
				return FALSE
	return TRUE

/datum/component/storage/proc/generate_bound_underlay(grid_width = 32, grid_height = 32)
	var/mutable_appearance/bound_underlay = mutable_appearance(icon = 'code/modules/wod13/UI/storage.dmi')
	var/static/list/scale_both = list("block_under")
	var/static/list/scale_x_states = list("up", "down")
	var/static/list/scale_y_states = list("left", "right")

	var/scale_x = grid_width/world.icon_size
	var/scale_y = grid_height/world.icon_size
	var/width_constant = (world.icon_size/2)*((grid_width/world.icon_size)-1)
	var/height_constant = (world.icon_size/2)*((grid_height/world.icon_size)-1)
	for(var/i in 1 to scale_x)
		for(var/b in 1 to scale_y)
			var/image/scaled_image = image(bound_underlay.icon, "block_under")
			scaled_image.pixel_w = 32*(i-1)-width_constant
			scaled_image.pixel_z = 32*(b-1)-height_constant
			bound_underlay.add_overlay(scaled_image)
			if(i == 1)
				var/image/side_image = image(bound_underlay.icon, "left")
				side_image.pixel_w = 32*(i-1)-width_constant
				side_image.pixel_z = 32*(b-1)-height_constant
				bound_underlay.add_overlay(side_image)
			if(i == scale_x)
				var/image/side_image = image(bound_underlay.icon, "right")
				side_image.pixel_w = 32*(i-1)-width_constant
				side_image.pixel_z = 32*(b-1)-height_constant
				bound_underlay.add_overlay(side_image)
			if(b == 1)
				var/image/side_image = image(bound_underlay.icon, "down")
				side_image.pixel_w = 32*(i-1)-width_constant
				side_image.pixel_z = 32*(b-1)-height_constant
				bound_underlay.add_overlay(side_image)
			if(b == scale_y)
				var/image/side_image = image(bound_underlay.icon, "up")
				side_image.pixel_w = 32*(i-1)-width_constant
				side_image.pixel_z = 32*(b-1)-height_constant
				bound_underlay.add_overlay(side_image)
	var/image/corner_left_down = image(bound_underlay.icon, "corner_left_down")
	corner_left_down.transform = corner_left_down.transform.Translate(-width_constant, -height_constant)
	bound_underlay.add_overlay(corner_left_down)
	var/image/corner_right_down = image(bound_underlay.icon, "corner_right_down")
	corner_right_down.transform = corner_right_down.transform.Translate(width_constant, -height_constant)
	bound_underlay.add_overlay(corner_right_down)
	var/image/corner_left_up = image(bound_underlay.icon, "corner_left_up")
	corner_left_up.transform = corner_left_up.transform.Translate(-width_constant, height_constant)
	bound_underlay.add_overlay(corner_left_up)
	var/image/corner_right_up = image(bound_underlay.icon, "corner_right_up")
	corner_right_up.transform = corner_right_up.transform.Translate(width_constant, height_constant)
	bound_underlay.add_overlay(corner_right_up)

	return bound_underlay

/datum/component/storage/proc/grid_add_item(obj/item/storing, coordinates)
	var/coordinate_x = text2num(copytext(coordinates, 1, findtext(coordinates, ",")))
	var/coordinate_y = text2num(copytext(coordinates, findtext(coordinates, ",") + 1))
	var/calculated_coordinates = ""
	var/final_x
	var/final_y
	var/validate_x = (storing.grid_width/grid_box_size)-1
	var/validate_y = (storing.grid_height/grid_box_size)-1
	//this loops through all cells we overlap given these coordinates
	for(var/current_x in 0 to validate_x)
		for(var/current_y in 0 to validate_y)
			final_x = coordinate_x+current_x
			final_y = coordinate_y+current_y
			calculated_coordinates = "[final_x],[final_y]"
			LAZYADDASSOCLIST(grid_coordinates_to_item, calculated_coordinates, storing)
			LAZYINITLIST(item_to_grid_coordinates)
			LAZYINITLIST(item_to_grid_coordinates[storing])
			LAZYADD(item_to_grid_coordinates[storing], calculated_coordinates)
	return TRUE

/datum/component/storage/proc/grid_remove_item(obj/item/removed)
	if(grid && LAZYACCESS(item_to_grid_coordinates, removed))
		for(var/location in LAZYACCESS(item_to_grid_coordinates, removed))
			LAZYREMOVE(grid_coordinates_to_item, location)
		LAZYREMOVE(item_to_grid_coordinates, removed)
		removed.underlays = null
		return TRUE
	return FALSE

/datum/component/storage/concrete/slave_can_insert_object(datum/component/storage/slave, obj/item/storing, stop_messages = FALSE, mob/user, params, storage_click = FALSE)
	//This is where the pain begins
	if(grid)
		var/list/modifiers = params2list(params)
		var/coordinates = LAZYACCESS(modifiers, "screen-loc")
		var/grid_box_ratio = (world.icon_size/grid_box_size)

		//if it's not a storage click, find the first cell that happens to be valid
		if(!storage_click)
			var/final_x = 0
			var/final_y = 0
			var/final_coordinates = ""
			var/grid_location_found = FALSE
			for(var/current_x in 0 to ((screen_max_rows*grid_box_ratio)-1))
				for(var/current_y in 0 to ((screen_max_columns*grid_box_ratio)-1))
					final_y = current_y
					final_x = current_x
					final_coordinates = "[final_x],[final_y]"
					if(validate_grid_coordinates(final_coordinates, storing.grid_width, storing.grid_height, storing))
						coordinates = final_coordinates
						grid_location_found = TRUE
						break
				if(grid_location_found)
					break
			if(!grid_location_found)
				return FALSE
		else
			coordinates = screen_loc_to_grid_coordinates(coordinates)

		if(!validate_grid_coordinates(coordinates, storing.grid_width, storing.grid_height, storing))
			return FALSE
	return TRUE

//Remote is null or the slave datum
/datum/component/storage/concrete/handle_item_insertion(obj/item/storing, prevent_warning = FALSE, mob/user, datum/component/storage/remote, params, storage_click = FALSE)
	var/datum/component/storage/concrete/master = master()
	var/atom/parent = src.parent
	var/moved = FALSE
	if(!istype(storing))
		return FALSE
	if(user)
		if(!worn_check(parent, user))
			return FALSE
		if(!user.temporarilyRemoveItemFromInventory(storing))
			return FALSE
		else
			//At this point if the proc fails we need to manually move the object back to the turf/mob/whatever.
			moved = TRUE
	if(storing.pulledby)
		storing.pulledby.stop_pulling()
	if(silent)
		prevent_warning = TRUE
	if(!_insert_physical_item(storing))
		if(moved)
			if(user)
				if(!user.put_in_active_hand(storing))
					storing.forceMove(parent.drop_location())
			else
				storing.forceMove(parent.drop_location())
		return FALSE
	storing.on_enter_storage(master)
	storing.item_flags |= IN_STORAGE
	storing.mouse_opacity = MOUSE_OPACITY_OPAQUE //So you can click on the area around the item to equip it, instead of having to pixel hunt
	if(user)
		if(user.client && (user.active_storage != src))
			user.client.screen -= storing
		if(LAZYLEN(user.observers))
			for(var/mob/dead/observe as anything in user.observers)
				if(observe.client && (observe.active_storage != src))
					observe.client.screen -= storing
		if(!remote)
			parent.add_fingerprint(user)
			if(!prevent_warning)
				mob_item_insertion_feedback(usr, user, storing)
	if(grid)
		var/list/modifiers = params2list(params)
		var/coordinates = LAZYACCESS(modifiers, "screen-loc")
		var/grid_box_ratio = (world.icon_size/grid_box_size)

		//if it's not a storage click, find the first cell that happens to be valid
		if(!storage_click)
			var/final_x = 0
			var/final_y = 0
			var/final_coordinates = ""
			var/grid_location_found = FALSE
			for(var/current_x in 0 to ((screen_max_rows*grid_box_ratio)-1))
				for(var/current_y in 0 to ((screen_max_columns*grid_box_ratio)-1))
					final_y = current_y
					final_x = current_x
					final_coordinates = "[final_x],[final_y]"
					if(validate_grid_coordinates(final_coordinates, storing.grid_width, storing.grid_height, storing))
						coordinates = final_coordinates
						grid_location_found = TRUE
						break
				if(grid_location_found)
					break
			if(!grid_location_found)
				return FALSE
		else
			coordinates = screen_loc_to_grid_coordinates(coordinates)
		grid_add_item(storing, coordinates)
	update_appearance()
	refresh_mob_views()
	return TRUE

/datum/component/storage/concrete/handle_item_insertion_from_slave(datum/component/storage/slave, obj/item/storing, prevent_warning = FALSE, mob/user, params, storage_click = FALSE)
	. = handle_item_insertion(storing, prevent_warning, user, slave, params = params, storage_click = storage_click)
	if(. && !prevent_warning)
		slave.mob_item_insertion_feedback(usr, user, storing)

/datum/component/storage/concrete/remove_from_storage(atom/movable/removed, atom/new_location)
	//This loops through all cells in the inventory box that we overlap and removes the item from them
	grid_remove_item(removed)
	//Cache this as it should be reusable down the bottom, will not apply if anyone adds a sleep to dropped or moving objects, things that should never happen
	var/atom/parent = src.parent
	var/list/seeing_mobs = can_see_contents()
	for(var/mob/seeing_mob as anything in seeing_mobs)
		seeing_mob.client.screen -= removed
	if(isitem(removed))
		var/obj/item/removed_item = removed
		removed_item.item_flags &= ~IN_STORAGE
		if(ismob(parent.loc))
			var/mob/carrying_mob = parent.loc
			removed_item.dropped(carrying_mob, TRUE)
	if(new_location)
		//Reset the items values
		_removal_reset(removed)
		removed.forceMove(new_location)
		//We don't want to call this if the item is being destroyed
		removed.on_exit_storage(src)
	else
		//Being destroyed, just move to nullspace now (so it's not in contents for the icon update)
		removed.moveToNullspace()
	update_appearance()
	refresh_mob_views()
	return TRUE

/atom/movable/screen/close
	icon = 'code/modules/wod13/UI/storage.dmi'
	icon_state = "close"
	var/locked = TRUE

/atom/movable/screen/close/Click(location, control, params)
	. = ..()
	var/datum/component/storage/storage_master = master
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, "shift"))
		if(!istype(storage_master))
			return
		storage_master.screen_start_x = initial(storage_master.screen_start_x)
		storage_master.screen_pixel_x = initial(storage_master.screen_pixel_x)
		storage_master.screen_start_y = initial(storage_master.screen_start_y)
		storage_master.screen_pixel_y = initial(storage_master.screen_pixel_y)
		storage_master.orient2hud()
		storage_master.show_to(usr)
		testing("storage screen variables reset.")
		to_chat(usr, span_notice("Storage window position has been reset."))
	else
		if(!istype(storage_master))
			return
		storage_master.hide_from(usr)

/atom/movable/screen/storage
	icon = 'code/modules/wod13/UI/storage.dmi'
	icon_state = "background"
	plane = HUD_PLANE
	layer = 1
	alpha = 180
	var/atom/movable/screen/storage_hover/hovering

/atom/movable/screen/storage/Initialize(mapload, new_master)
	. = ..()
	hovering = new()

/atom/movable/screen/storage/Destroy()
	. = ..()
	qdel(hovering)

/atom/movable/screen/storage/MouseEntered(location, control, params)
	. = ..()
	if(!usr.client)
		return
	MouseMove(location, control, params)

/atom/movable/screen/storage/MouseExited(location, control, params)
	. = ..()
	if(!usr.client)
		return
	usr.client.screen -= hovering

/atom/movable/screen/storage/MouseMove(location, control, params)
	. = ..()
	if(!usr.client)
		return
	usr.client.screen -= hovering
	var/datum/component/storage/storage_master = master
	if(!istype(storage_master) || !(usr in storage_master.is_using) || !isliving(usr) || usr.incapacitated())
		return
	var/obj/item/held_item = usr.get_active_held_item()
	if(!held_item)
		return
	storage_master = storage_master.master()
	if(!storage_master.grid)
		return
	var/list/modifiers = params2list(params)
	var/screen_loc = LAZYACCESS(modifiers, "screen-loc")
	var/coordinates = storage_master.screen_loc_to_grid_coordinates(screen_loc)
	if(!coordinates)
		return
	if(storage_master.can_be_inserted(held_item, stop_messages = TRUE, user = usr, worn_check = TRUE, params = params, storage_click = TRUE))
		hovering.color = COLOR_LIME
	else
		hovering.color = COLOR_RED_LIGHT
	hovering.transform = matrix()
	var/scale_x = held_item.grid_width/world.icon_size
	var/scale_y = held_item.grid_height/world.icon_size
	hovering.transform = hovering.transform.Scale(scale_x, scale_y)
	var/translate_x = (world.icon_size/2)*((held_item.grid_width/world.icon_size)-1)
	var/translate_y = (world.icon_size/2)*((held_item.grid_height/world.icon_size)-1)
	hovering.transform = hovering.transform.Translate(translate_x, translate_y)
	hovering.screen_loc = storage_master.grid_coordinates_to_screen_loc(coordinates)

	usr.client.screen |= hovering

/atom/movable/screen/storage_hover
	icon = 'code/modules/wod13/UI/storage.dmi'
	icon_state = "white"
	plane = ABOVE_HUD_PLANE
	layer = 1
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 96

/obj/item/storage/firstaid
	grid_width = 2 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/storage/firstaid/ifak
	grid_width = 1 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/storage/fancy/hardcase
	grid_width = 3 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/melee/vampirearms/fireaxe
	grid_width = 7 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/melee/vampirearms/katana
	grid_width = 5 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/melee/vampirearms/machete
	grid_width = 3 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/melee/vampirearms/rapier
	grid_width = 2 GRID_BOXES
	grid_height = 5 GRID_BOXES

/obj/item/melee/vampirearms/sabre
	grid_width = 2 GRID_BOXES
	grid_height = 5 GRID_BOXES

/obj/item/melee/vampirearms/longsword
	grid_width = 2 GRID_BOXES
	grid_height = 5 GRID_BOXES

/obj/item/melee/vampirearms/baseball
	grid_width = 3 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/melee/vampirearms/baseball/hand
	grid_width = 3 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/melee/vampirearms/tire
	grid_width = 2 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/melee/vampirearms/knife
	grid_width = 2 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/melee/vampirearms/handsickle
	grid_width = 2 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/melee/vampirearms/chainsaw
	grid_width = 8 GRID_BOXES
	grid_height = 4 GRID_BOXES

/obj/item/vampire_stake
	grid_width = 1 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/melee/vampirearms/shovel
	grid_width = 5 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/melee/vampirearms/katana/kosa
	grid_width = 3 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/melee/vampirearms/eguitar
	grid_width = 7 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/melee/classic_baton/vampire
	grid_width = 1 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/shield/door
	grid_width = 7 GRID_BOXES
	grid_height = 9 GRID_BOXES

/obj/item/ammo_box/vampire
	grid_width = 2 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/ammo_box/magazine/glock9mm
	grid_width = 1 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/gun/ballistic/automatic/vampire/glock19
	grid_width = 2 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/ammo_box/magazine/glock45acp
	grid_width = 1 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/gun/ballistic/automatic/vampire/glock21
	grid_width = 2 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/ammo_box/vampire
	grid_width = 2 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/ammo_box/magazine/vamp9mm
	grid_width = 1 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/ammo_box/vampire/c9mm/moonclip
	grid_width = 1 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/gun/ballistic/vampire/revolver/snub
	grid_width = 1 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/gun/ballistic/automatic/vampire/uzi
	grid_width = 2 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/ammo_box/magazine/vamp9mp5
	grid_width = 1 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/gun/ballistic/automatic/vampire/mp5
	grid_width = 2 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/ammo_box/magazine/m44
	grid_width = 1 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/gun/ballistic/automatic/vampire/deagle
	grid_width = 3 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/gun/ballistic/vampire/revolver
	grid_width = 2 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/ammo_box/magazine/vamp45acp
	grid_width = 1 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/gun/ballistic/automatic/vampire/m1911
	grid_width = 2 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/ammo_box/magazine/semi9mm
	grid_width = 1 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/gun/ballistic/automatic/vampire/beretta
	grid_width = 2 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/ammo_box/magazine/vamp556
	grid_width = 1 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/gun/ballistic/automatic/vampire/ar15
	grid_width = 8 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/gun/ballistic/automatic/vampire/huntrifle
	grid_width = 8 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/ammo_box/magazine/vamp545
	grid_width = 1 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/gun/ballistic/automatic/vampire/ak74
	grid_width = 8 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/ammo_box/magazine/vampaug
	grid_width = 1 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/gun/ballistic/automatic/vampire/aug
	grid_width = 8 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/ammo_box/magazine/vampthompson
	grid_width = 2 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/gun/ballistic/automatic/vampire/thompson
	grid_width = 5 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/gun/ballistic/automatic/vampire/autoshotgun
	grid_width = 5 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/gun/ballistic/automatic/vampire/sniper
	grid_width = 4 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/gun/ballistic/shotgun/vampire
	grid_width = 6 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/ammo_box/vampire/c12g
	grid_width = 2 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/gun/ballistic/shotgun/toy/crossbow/vampire
	grid_width = 5 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/ammo_box/vampire/arrows
	grid_width = 2 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/ammo_casing/caseless/bolt // not sure this was intended unless individual bolts can be picked up and loaded? added real ammo box above
	grid_width = 1 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/molotov
	grid_width = 1 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/vampire_flamethrower
	grid_width = 7 GRID_BOXES
	grid_height = 3 GRID_BOXES

/obj/item/food/fish/shark
	grid_width = 3 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/food/fish/tune
	grid_width = 2 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/food/fish/catfish
	grid_width = 2 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/fishing_rod
	grid_width = 3 GRID_BOXES
	grid_height = 1 GRID_BOXES

/obj/item/clothing/under
	grid_width = 2 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/clothing/suit
	grid_width = 2 GRID_BOXES
	grid_height = 3 GRID_BOXES

/obj/item/clothing/head
	grid_width = 2 GRID_BOXES
	grid_height = 2 GRID_BOXES

/obj/item/vampire/drill
	grid_width = 10 GRID_BOXES
	grid_height = 10 GRID_BOXES

/obj/item/gun/energy/taser
	grid_width = 2 GRID_BOXES
	grid_height = 1 GRID_BOXES
