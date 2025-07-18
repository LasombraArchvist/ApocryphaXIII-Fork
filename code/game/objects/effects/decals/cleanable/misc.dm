/obj/effect/decal/cleanable/generic
	name = "clutter"
	desc = "Someone should clean that up."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shards"
	beauty = -50

/obj/effect/decal/cleanable/ash
	name = "ashes"
	desc = "Ashes to ashes, dust to dust, and into space."
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"
	mergeable_decal = FALSE
	beauty = -50

/obj/effect/decal/cleanable/fire_ash
	name = "ashes"
	desc = "Ashes to ashes, dust to dust, and into space."
	icon = 'icons/obj/objects.dmi'
	icon_state = "dirt"
	mergeable_decal = FALSE
	beauty = -75
	color = "#000000"

/obj/effect/decal/cleanable/ash/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ash, 30)
	pixel_x = base_pixel_x + rand(-5, 5)
	pixel_y = base_pixel_y + rand(-5, 5)

/obj/effect/decal/cleanable/ash/crematorium
//crematoriums need their own ash cause default ash deletes itself if created in an obj
	turf_loc_check = FALSE

/obj/effect/decal/cleanable/ash/large
	name = "large pile of ashes"
	icon_state = "big_ash"
	beauty = -100

/obj/effect/decal/cleanable/ash/large/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ash, 30) //double the amount of ash.

/obj/effect/decal/cleanable/glass
	name = "tiny shards"
	desc = "Back to sand."
	icon = 'icons/obj/shards.dmi'
	icon_state = "tiny"
	beauty = -100

/obj/effect/decal/cleanable/glass/Initialize()
	. = ..()
	setDir(pick(GLOB.cardinals))

/obj/effect/decal/cleanable/glass/ex_act()
	qdel(src)

/obj/effect/decal/cleanable/glass/plasma
	icon_state = "plasmatiny"

/obj/effect/decal/cleanable/dirt
	name = "dirt"
	desc = "Someone should clean that up."
	icon = 'icons/effects/dirt.dmi'
	icon_state = "dirt"
	base_icon_state = "dirt"
	smoothing_flags = NONE
	smoothing_groups = list(SMOOTH_GROUP_CLEANABLE_DIRT)
	canSmoothWith = list(SMOOTH_GROUP_CLEANABLE_DIRT, SMOOTH_GROUP_WALLS)
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	beauty = -75

/obj/effect/decal/cleanable/dirt/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	if(T.tiled_dirt)
		smoothing_flags = SMOOTH_BITMASK
		QUEUE_SMOOTH(src)
	if(smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK))
		QUEUE_SMOOTH_NEIGHBORS(src)

/obj/effect/decal/cleanable/dirt/Destroy()
	if(smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK))
		QUEUE_SMOOTH_NEIGHBORS(src)
	return ..()

/obj/effect/decal/cleanable/gasoline
	name = "gasoline"
	desc = "I HOPE YOU DIE IN A FIRE!!!"
	icon = 'icons/effects/dirt.dmi'
	icon_state = "water"
	base_icon_state = "water"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_CLEANABLE_DIRT)
	canSmoothWith = list(SMOOTH_GROUP_CLEANABLE_DIRT, SMOOTH_GROUP_WALLS)
//	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	beauty = -50
	alpha = 64
	color = "#c6845b"

/obj/effect/decal/cleanable/gasoline/update_appearance()
	. = ..()
	QUEUE_SMOOTH(src)
	QUEUE_SMOOTH_NEIGHBORS(src)

/obj/effect/decal/cleanable/gasoline/Crossed(atom/movable/AM, oldloc)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.on_fire)
			var/obj/effect/fire/F = locate() in get_turf(src)
			if(!F)
				new /obj/effect/fire(get_turf(src))
	..(AM)

/obj/effect/decal/cleanable/gasoline/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	if(istype(T, /turf/open/floor))
		var/turf/open/floor/F = T
		F.spread_chance = 100
		F.burn_material += 100
//	smoothing_flags = SMOOTH_BITMASK
	QUEUE_SMOOTH(src)
	QUEUE_SMOOTH_NEIGHBORS(src)

/obj/effect/decal/cleanable/gasoline/Destroy()
	QUEUE_SMOOTH_NEIGHBORS(src)
	return ..()

/obj/effect/decal/cleanable/gasoline/fire_act(exposed_temperature, exposed_volume)
	var/obj/effect/fire/F = locate() in loc
	if(!F)
		new /obj/effect/fire(loc)
	..()

/obj/effect/decal/cleanable/gasoline/attackby(obj/item/I, mob/living/user)
	var/attacked_by_hot_thing = I.get_temperature()
	if(attacked_by_hot_thing)
		call_dharma("grief", user)
		visible_message("<span class='warning'>[user] tries to ignite [src] with [I]!</span>", "<span class='warning'>You try to ignite [src] with [I].</span>")
		log_combat(user, src, (attacked_by_hot_thing < 480) ? "tried to ignite" : "ignited", I)
		fire_act(attacked_by_hot_thing)
		return
	return ..()

/obj/effect/decal/cleanable/dirt/dust
	name = "dust"
	desc = "A thin layer of dust coating the floor."

/obj/effect/decal/cleanable/greenglow
	name = "glowing goo"
	desc = "Jeez. I hope that's not for lunch."
	icon_state = "greenglow"
	light_power = 3
	light_range = 2
	light_color = LIGHT_COLOR_GREEN
	beauty = -300

/obj/effect/decal/cleanable/greenglow/ex_act()
	return

/obj/effect/decal/cleanable/greenglow/filled/Initialize()
	. = ..()
	reagents.add_reagent(pick(/datum/reagent/uranium, /datum/reagent/uranium/radium), 5)

/obj/effect/decal/cleanable/greenglow/ecto
	name = "ectoplasmic puddle"
	desc = "You know who to call."
	light_power = 2

/obj/effect/decal/cleanable/cobweb
	name = "cobweb"
	desc = "Somebody should remove that."
	gender = NEUTER
	layer = WALL_OBJ_LAYER
	icon_state = "cobweb1"
	resistance_flags = FLAMMABLE
	beauty = -100
	clean_type = CLEAN_TYPE_HARD_DECAL

/obj/effect/decal/cleanable/cobweb/cobweb2
	icon_state = "cobweb2"

/obj/effect/decal/cleanable/molten_object
	name = "gooey grey mass"
	desc = "It looks like a melted... something."
	gender = NEUTER
	icon = 'icons/effects/effects.dmi'
	icon_state = "molten"
	mergeable_decal = FALSE
	beauty = -150
	clean_type = CLEAN_TYPE_HARD_DECAL

/obj/effect/decal/cleanable/molten_object/large
	name = "big gooey grey mass"
	icon_state = "big_molten"
	beauty = -300

//Vomit (sorry)
/obj/effect/decal/cleanable/vomit
	name = "vomit"
	desc = "Gosh, how unpleasant."
	icon = 'icons/effects/blood.dmi'
	icon_state = "vomit_1"
	random_icon_states = list("vomit_1", "vomit_2", "vomit_3", "vomit_4")
	beauty = -150

/obj/effect/decal/cleanable/vomit/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(isflyperson(H))
			playsound(get_turf(src), 'sound/items/drink.ogg', 50, TRUE) //slurp
			H.visible_message("<span class='alert'>[H] extends a small proboscis into the vomit pool, sucking it with a slurping sound.</span>")
			if(reagents)
				for(var/datum/reagent/R in reagents.reagent_list)
					if (istype(R, /datum/reagent/consumable))
						var/datum/reagent/consumable/nutri_check = R
						if(nutri_check.nutriment_factor >0)
							H.adjust_nutrition(nutri_check.nutriment_factor * nutri_check.volume)
							reagents.remove_reagent(nutri_check.type,nutri_check.volume)
			reagents.trans_to(H, reagents.total_volume, transfered_by = user)
			qdel(src)

/obj/effect/decal/cleanable/vomit/old
	name = "crusty dried vomit"
	desc = "You try not to look at the chunks, and fail."

/obj/effect/decal/cleanable/vomit/old/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	icon_state += "-old"
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_SLUDGE, CELL_VIRUS_TABLE_GENERIC, rand(2,4), 10)


/obj/effect/decal/cleanable/chem_pile
	name = "chemical pile"
	desc = "A pile of chemicals. You can't quite tell what's inside it."
	gender = NEUTER
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"

/obj/effect/decal/cleanable/shreds
	name = "shreds"
	desc = "The shredded remains of what appears to be clothing."
	icon_state = "shreds"
	gender = PLURAL
	mergeable_decal = FALSE

/obj/effect/decal/cleanable/shreds/ex_act(severity, target)
	if(severity == 1) //so shreds created during an explosion aren't deleted by the explosion.
		qdel(src)

/obj/effect/decal/cleanable/shreds/Initialize(mapload, oldname)
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)
	if(!isnull(oldname))
		desc = "The sad remains of what used to be [oldname]"
	. = ..()

/obj/effect/decal/cleanable/glitter
	name = "generic glitter pile"
	desc = "The herpes of arts and crafts."
	icon = 'icons/effects/atmospherics.dmi'
	icon_state = "plasma_old"
	gender = NEUTER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/cleanable/glitter/pink
	name = "pink glitter"
	icon_state = "plasma"

/obj/effect/decal/cleanable/glitter/white
	name = "white glitter"
	icon_state = "nitrous_oxide"

/obj/effect/decal/cleanable/glitter/blue
	name = "blue glitter"
	icon_state = "freon"

/obj/effect/decal/cleanable/plasma
	name = "stabilized plasma"
	desc = "A puddle of stabilized plasma."
	icon_state = "flour"
	icon = 'icons/effects/tomatodecal.dmi'
	color = "#2D2D2D"

/obj/effect/decal/cleanable/insectguts
	name = "insect guts"
	desc = "One bug squashed. Four more will rise in its place."
	icon = 'icons/effects/blood.dmi'
	icon_state = "xfloor1"
	random_icon_states = list("xfloor1", "xfloor2", "xfloor3", "xfloor4", "xfloor5", "xfloor6", "xfloor7")

/obj/effect/decal/cleanable/confetti
	name = "confetti"
	desc = "Tiny bits of colored paper thrown about for the janitor to enjoy!"
	icon = 'icons/effects/confetti_and_decor.dmi'
	icon_state = "confetti"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT //the confetti itself might be annoying enough

/obj/effect/decal/cleanable/plastic
	name = "plastic shreds"
	desc = "Bits of torn, broken, worthless plastic."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shards"
	color = "#c6f4ff"

/obj/effect/decal/cleanable/wrapping
	name = "wrapping shreds"
	desc = "Torn pieces of cardboard and paper, left over from a package."
	icon = 'icons/obj/objects.dmi'
	icon_state = "paper_shreds"

/obj/effect/decal/cleanable/garbage
	name = "trash bag"
	desc = "Holds garbage inside."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "garbage1"
	layer = OBJ_LAYER //To display the decal over wires.
	beauty = -150
	clean_type = CLEAN_TYPE_HARD_DECAL

/obj/effect/decal/cleanable/garbage/Initialize()
	. = ..()
	icon_state = "garbage[rand(1, 6)]"

/obj/structure/trashbag
	name = "trash bags"
	desc = "Enough trashbags to block your way."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "garbage1"
	layer = OBJ_LAYER //To display the decal over wires.
	density = TRUE
	anchored = TRUE

/obj/structure/trashbag/Initialize()
	. = ..()
	icon_state = "garbage[rand(7, 9)]"

/obj/structure/trashbag/Destroy()
	new /obj/effect/spawner/random/trash/garbage(loc)
	return ..()


/obj/effect/decal/cleanable/feet_trail
	name = "trails"
	desc = "Can lead somewhere... Or not."
	icon = 'icons/effects/dirt.dmi'
	icon_state = "feet_trail"

/obj/effect/decal/cleanable/feet_trail/Initialize()
	. = ..()
	pixel_x = rand(-4, 4)
	pixel_y = rand(-4, 4)

/obj/effect/decal/cleanable/drag_trail
	name = "trails"
	desc = "Can lead somewhere... Or not."
	icon = 'icons/effects/dirt.dmi'
	icon_state = "drag_trail"

/obj/effect/decal/cleanable/car_trail
	name = "trails"
	desc = "Can lead somewhere... Or not."
	icon = 'icons/effects/dirt.dmi'
	icon_state = "car_trail"

/turf/open/floor/Exited(atom/movable/Obj, atom/newloc)
	. = ..()
	/*
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				if(isliving(Obj))
					if(ishuman(Obj))
						var/mob/living/carbon/human/human = Obj
						if(human.body_position != LYING_DOWN)
							var/obj/effect/decal/cleanable/feet_trail/trail = new(src)
							trail.dir = get_dir(src, newloc)
						else
							var/obj/effect/decal/cleanable/drag_trail/trail = new(src)
							trail.dir = get_dir(src, newloc)
					else
						var/mob/living/living = Obj
						if(!living.stat)
							var/obj/effect/decal/cleanable/feet_trail/trail = new(src)
							trail.dir = get_dir(src, newloc)
						else
							var/obj/effect/decal/cleanable/drag_trail/trail = new(src)
							trail.dir = get_dir(src, newloc)
				if(istype(Obj, /obj/vampire_car))
					var/obj/vampire_car/car = Obj
					if(car.on)
						var/obj/effect/decal/cleanable/car_trail/trail = new(src)
						trail.dir = Obj.dir
	*/

/obj/effect/decal/cleanable/trash
	name = "trash"
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "trash1"
	clean_type = CLEAN_TYPE_HARD_DECAL

/obj/effect/decal/cleanable/trash/Initialize()
	. = ..()
	icon_state = "trash[rand(1, 30)]"

/obj/effect/decal/cleanable/litter
	name = "litter"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "paper1"
	clean_type = CLEAN_TYPE_HARD_DECAL

/obj/effect/decal/cleanable/litter/Initialize()
	. = ..()
	icon_state = "paper[rand(1, 6)]"

/obj/effect/decal/cleanable/cardboard
	name = "cardboard"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "cardboard1"
	clean_type = CLEAN_TYPE_HARD_DECAL

/obj/effect/decal/cleanable/cardboard/Initialize()
	. = ..()
	icon_state = "cardboard[rand(1, 5)]"
	var/matrix/M = matrix()
	M.Turn(rand(0, 360))
	transform = M
