/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * WARNING: var/icon_type is used for both examine text and sprite name. Please look at the procs below and adjust your sprite names accordingly
 *		TODO: Cigarette boxes should be ported to this standard
 *
 * Contains:
 *		Donut Box
 *		Egg Box
 *		Candle Box
 *		Cigarette Box
 *		Cigar Case
 *		Heart Shaped Box w/ Chocolates
 */

/obj/item/storage/fancy
	icon = 'icons/obj/food/containers.dmi'
	resistance_flags = FLAMMABLE
	custom_materials = list(/datum/material/cardboard = 2000)
	storage_max_columns = 5
	storage_max_rows = 5
	var/icon_type = "donut"
	var/spawn_type = null
	var/fancy_open = FALSE
	var/obj/fold_result = /obj/item/stack/sheet/cardboard

/obj/item/storage/fancy/PopulateContents()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	for(var/i = 1 to STR.max_items)
		new spawn_type(src)

/obj/item/storage/fancy/update_icon_state()
	. = ..()
	if(fancy_open)
		icon_state = "[icon_type]box[contents.len]"
	else
		icon_state = "[icon_type]box"

/obj/item/storage/fancy/examine(mob/user)
	. = ..()
	if(fancy_open)
		if(length(contents) == 1)
			. += "There is one [icon_type] left."
		else
			. += "There are [contents.len <= 0 ? "no" : "[contents.len]"] [icon_type]s left."

/obj/item/storage/fancy/attack_self(mob/user)
	fancy_open = !fancy_open
	update_icon()
	. = ..()
	if(!contents.len)
		new fold_result(user.drop_location())
		to_chat(user, "<span class='notice'>You fold the [src] into [initial(fold_result.name)].</span>")
		user.put_in_active_hand(fold_result)
		qdel(src)

/obj/item/storage/fancy/Exited()
	. = ..()
	fancy_open = TRUE
	update_icon()

/obj/item/storage/fancy/Entered()
	. = ..()
	fancy_open = TRUE
	update_icon()

#define DONUT_INBOX_SPRITE_WIDTH 3

/*
 * Donut Box
 */

/obj/item/storage/fancy/donut_box
	name = "donut box"
	desc = "Mmm. Donuts."
	icon = 'icons/obj/food/donuts.dmi'
	icon_state = "donutbox_inner"
	icon_type = "donut"
	spawn_type = /obj/item/food/donut
	fancy_open = TRUE
	appearance_flags = KEEP_TOGETHER
	custom_premium_price = PAYCHECK_HARD * 1.75
	storage_max_columns = 6
	storage_max_rows = 2

/obj/item/storage/fancy/donut_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.set_holdable(list(/obj/item/food/donut))

/obj/item/storage/fancy/donut_box/PopulateContents()
	. = ..()
	update_icon()

/obj/item/storage/fancy/donut_box/update_icon_state()
	. = ..()
	if(fancy_open)
		icon_state = "donutbox_inner"
	else
		icon_state = "donutbox"

/obj/item/storage/fancy/donut_box/update_overlays()
	. = ..()

	if (!fancy_open)
		return

	var/donuts = 0

	for (var/_donut in contents)
		var/obj/item/food/donut/donut = _donut
		if (!istype(donut))
			continue

		. += image(icon = initial(icon), icon_state = donut.in_box_sprite(), pixel_x = donuts * DONUT_INBOX_SPRITE_WIDTH)
		donuts += 1

	. += image(icon = initial(icon), icon_state = "donutbox_top")

#undef DONUT_INBOX_SPRITE_WIDTH

/*
 * Egg Box
 */

/obj/item/storage/fancy/egg_box
	icon = 'icons/obj/food/containers.dmi'
	inhand_icon_state = "eggbox"
	icon_state = "eggbox"
	icon_type = "egg"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	name = "egg box"
	desc = "A carton for containing eggs."
	spawn_type = /obj/item/food/egg
	storage_max_columns = 6
	storage_max_rows = 2

/obj/item/storage/fancy/egg_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 12
	STR.set_holdable(list(/obj/item/food/egg))

/*
 * Candle Box
 */

/obj/item/storage/fancy/candle_box
	name = "candle pack"
	desc = "A pack of red candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox5"
	icon_type = "candle"
	inhand_icon_state = "candlebox5"
	worn_icon_state = "cigpack"
	throwforce = 2
	slot_flags = ITEM_SLOT_BELT
	spawn_type = /obj/item/candle
	fancy_open = TRUE

/obj/item/storage/fancy/candle_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 5

/obj/item/storage/fancy/candle_box/attack_self(mob/user)
	if(!contents.len)
		new fold_result(user.drop_location())
		to_chat(user, "<span class='notice'>You fold the [src] into [initial(fold_result.name)].</span>")
		user.put_in_active_hand(fold_result)
		qdel(src)

////////////
//CIG PACK//
////////////
/obj/item/storage/fancy/cigarettes
	name = "\improper Space Cigarettes packet"
	desc = "The most popular brand of cigarettes, sponsors of the Space Olympics."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cig"
	inhand_icon_state = "cigpacket"
	worn_icon_state = "cigpack"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	slot_flags = ITEM_SLOT_BELT
	icon_type = "cigarette"
	spawn_type = /obj/item/clothing/mask/cigarette/space_cigarette
	custom_price = PAYCHECK_MEDIUM
	age_restricted = TRUE
	///for cigarette overlay
	var/candy = FALSE
	/// Does this cigarette packet come with a coupon attached?
	var/spawn_coupon = TRUE
	/// For VV'ing, set this to true if you want to force the coupon to give an omen
	var/rigged_omen = FALSE

/obj/item/storage/fancy/cigarettes/attack_self(mob/user)
	if(contents.len == 0 && spawn_coupon)
		to_chat(user, "<span class='notice'>You rip the back off \the [src] and get a coupon!</span>")
		var/obj/item/coupon/attached_coupon = new
		user.put_in_hands(attached_coupon)
		attached_coupon.generate(rigged_omen)
		attached_coupon = null
		spawn_coupon = FALSE
		name = "discarded cigarette packet"
		desc = "An old cigarette packet with the back torn off, worth less than nothing now."
		var/datum/component/storage/STR = GetComponent(/datum/component/storage)
		STR.max_items = 0
		return
	return ..()

/obj/item/storage/fancy/cigarettes/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 10
	STR.set_holdable(list(/obj/item/clothing/mask/cigarette, /obj/item/lighter))

/obj/item/storage/fancy/cigarettes/examine(mob/user)
	. = ..()

	. += "<span class='notice'>Alt-click to extract contents.</span>"
	if(spawn_coupon)
		. += "<span class='notice'>There's a coupon on the back of the pack! You can tear it off once it's empty.</span>"

/obj/item/storage/fancy/cigarettes/AltClick(mob/user)
	if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, TRUE))
		return
	var/obj/item/clothing/mask/cigarette/W = locate(/obj/item/clothing/mask/cigarette) in contents
	if(W && contents.len > 0)
		SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, W, user)
		user.put_in_hands(W)
		contents -= W
		to_chat(user, "<span class='notice'>You take \a [W] out of the pack.</span>")
	else
		to_chat(user, "<span class='notice'>There are no [icon_type]s left in the pack.</span>")

/obj/item/storage/fancy/cigarettes/update_icon_state()
	. = ..()
	if(fancy_open || !contents.len)
		if(!contents.len)
			icon_state = "[initial(icon_state)]_empty"
		else
			icon_state = initial(icon_state)

/obj/item/storage/fancy/cigarettes/update_overlays()
	. = ..()
	if(fancy_open && contents.len)
		. += "[icon_state]_open"
		var/cig_position = 1
		for(var/C in contents)
			var/mutable_appearance/inserted_overlay = mutable_appearance(icon)

			if(istype(C, /obj/item/lighter/greyscale))
				inserted_overlay.icon_state = "lighter_in"
			else if(istype(C, /obj/item/lighter))
				inserted_overlay.icon_state = "zippo_in"
			else if(candy)
				inserted_overlay.icon_state = "candy"
			else
				inserted_overlay.icon_state = "cigarette"

			inserted_overlay.icon_state = "[inserted_overlay.icon_state]_[cig_position]"
			. += inserted_overlay
			cig_position++

/obj/item/storage/fancy/cigarettes/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!ismob(M))
		return
	var/obj/item/clothing/mask/cigarette/cig = locate(/obj/item/clothing/mask/cigarette) in contents
	if(cig)
		if(M == user && contents.len > 0 && !user.wear_mask)
			var/obj/item/clothing/mask/cigarette/W = cig
			SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, W, M)
			M.equip_to_slot_if_possible(W, ITEM_SLOT_MASK)
			contents -= W
			to_chat(user, "<span class='notice'>You take \a [W] out of the pack.</span>")
		else
			..()
	else
		to_chat(user, "<span class='notice'>There are no [icon_type]s left in the pack.</span>")

/obj/item/storage/fancy/cigarettes/dromedaryco
	name = "\improper Camel packet"
	desc = "A packet of six imported Camel cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\""
	icon_state = "dromedary"
	spawn_type = /obj/item/clothing/mask/cigarette/dromedary

/obj/item/storage/fancy/cigarettes/cigpack_uplift
	name = "\improper Uplift Smooth packet"
	desc = "Your favorite brand, now menthol flavored."
	icon_state = "uplift"
	spawn_type = /obj/item/clothing/mask/cigarette/uplift

/obj/item/storage/fancy/cigarettes/cigpack_robust
	name = "\improper Malboro packet"
	desc = "Smoked by the robust."
	icon_state = "robust"
	spawn_type = /obj/item/clothing/mask/cigarette/robust

/obj/item/storage/fancy/cigarettes/cigpack_robustgold
	name = "\improper Robust Gold packet"
	desc = "Smoked by the truly robust."
	icon_state = "robustg"
	spawn_type = /obj/item/clothing/mask/cigarette/robustgold

/obj/item/storage/fancy/cigarettes/cigpack_carp
	name = "\improper Carp Classic packet"
	desc = "Since 2313."
	icon_state = "carp"
	spawn_type = /obj/item/clothing/mask/cigarette/carp

/obj/item/storage/fancy/cigarettes/cigpack_syndicate
	name = "cigarette packet"
	desc = "An obscure brand of cigarettes."
	icon_state = "syndie"
	spawn_type = /obj/item/clothing/mask/cigarette/syndicate

/obj/item/storage/fancy/cigarettes/cigpack_midori
	name = "\improper Midori Tabako packet"
	desc = "You can't understand the runes, but the packet smells funny."
	icon_state = "midori"
	spawn_type = /obj/item/clothing/mask/cigarette/rollie/nicotine

/obj/item/storage/fancy/cigarettes/cigpack_candy
	name = "\improper Timmy's First Candy Smokes packet"
	desc = "Unsure about smoking? Want to bring your children safely into the family tradition? Look no more with this special packet! Includes 100%* Nicotine-Free candy cigarettes."
	icon_state = "candy"
	icon_type = "candy cigarette"
	spawn_type = /obj/item/clothing/mask/cigarette/candy
	candy = TRUE
	age_restricted = FALSE

/obj/item/storage/fancy/cigarettes/cigpack_candy/Initialize()
	. = ..()
	if(prob(7))
		spawn_type = /obj/item/clothing/mask/cigarette/candy/nicotine //uh oh!

/obj/item/storage/fancy/cigarettes/cigpack_shadyjims
	name = "\improper Shady Jim's Super Slims packet"
	desc = "Is your weight slowing you down? Having trouble running away from gravitational singularities? Can't stop stuffing your mouth? Smoke Shady Jim's Super Slims and watch all that fat burn away. Guaranteed results!"
	icon_state = "shadyjim"
	spawn_type = /obj/item/clothing/mask/cigarette/shadyjims

/obj/item/storage/fancy/cigarettes/cigpack_xeno
	name = "\improper Newport packet"
	desc = "Loaded with 100% pure tabacco. And also nicotine."
	icon_state = "slime"
	spawn_type = /obj/item/clothing/mask/cigarette/xeno

/obj/item/storage/fancy/cigarettes/cigpack_cannabis
	name = "\improper Freak Brothers' Special packet"
	desc = "A label on the packaging reads, \"Endorsed by Phineas, Freddy and Franklin.\""
	icon_state = "midori"
	spawn_type = /obj/item/clothing/mask/cigarette/rollie/cannabis

/obj/item/storage/fancy/cigarettes/cigpack_mindbreaker
	name = "\improper Leary's Delight packet"
	desc = "Banned in over 36 galaxies."
	icon_state = "shadyjim"
	spawn_type = /obj/item/clothing/mask/cigarette/rollie/mindbreaker

/obj/item/storage/fancy/rollingpapers
	name = "rolling paper pack"
	desc = "A pack of Nanotrasen brand rolling papers."
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cig_paper_pack"
	///The value in here has NOTHING to do with icons. It needs to be this for the proper examine.
	icon_type = "rolling paper"
	spawn_type = /obj/item/rollingpaper
	custom_price = PAYCHECK_PRISONER

/obj/item/storage/fancy/rollingpapers/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 10
	STR.set_holdable(list(/obj/item/rollingpaper))

///Overrides to do nothing because fancy boxes are fucking insane.
/obj/item/storage/fancy/rollingpapers/update_icon_state()
	. = ..()
	//reset any changes the parent call may have made
	icon_state = base_icon_state

/obj/item/storage/fancy/rollingpapers/update_overlays()
	. = ..()
	if(!contents.len)
		. += "[icon_state]_empty"

/////////////
//CIGAR BOX//
/////////////

/obj/item/storage/fancy/cigarettes/cigars
	name = "\improper premium cigar case"
	desc = "A case of premium cigars. Very expensive."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigarcase"
	w_class = WEIGHT_CLASS_NORMAL
	icon_type = "premium cigar"
	spawn_type = /obj/item/clothing/mask/cigarette/cigar
	spawn_coupon = FALSE

/obj/item/storage/fancy/cigarettes/cigars/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 5
	STR.set_holdable(list(/obj/item/clothing/mask/cigarette/cigar))

/obj/item/storage/fancy/cigarettes/cigars/update_icon_state()
	. = ..()
	if(fancy_open)
		icon_state = "[initial(icon_state)]_open"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/storage/fancy/cigarettes/cigars/update_overlays()
	. = ..()
	if(fancy_open)
		var/cigar_position = 1 //generate sprites for cigars in the box
		for(var/obj/item/clothing/mask/cigarette/cigar/smokes in contents)
			var/mutable_appearance/cigar_overlay = mutable_appearance(icon, "[smokes.icon_off]_[cigar_position]")
			. += cigar_overlay
			cigar_position++

/obj/item/storage/fancy/cigarettes/cigars/cohiba
	name = "\improper Cohiba Robusto cigar case"
	desc = "A case of imported Cohiba cigars, renowned for their strong flavor."
	icon_state = "cohibacase"
	spawn_type = /obj/item/clothing/mask/cigarette/cigar/cohiba

/obj/item/storage/fancy/cigarettes/cigars/havana
	name = "\improper premium Havanian cigar case"
	desc = "A case of classy Havanian cigars."
	icon_state = "cohibacase"
	spawn_type = /obj/item/clothing/mask/cigarette/cigar/havana

/*
 * Heart Shaped Box w/ Chocolates
 */

/obj/item/storage/fancy/heart_box
	name = "heart-shaped box"
	desc = "A heart-shaped box for holding tiny chocolates."
	icon = 'icons/obj/food/containers.dmi'
	inhand_icon_state = "chocolatebox"
	icon_state = "chocolatebox"
	icon_type = "chocolate"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	spawn_type = /obj/item/food/tinychocolate

/obj/item/storage/fancy/heart_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 8
	STR.set_holdable(list(/obj/item/food/tinychocolate))


/obj/item/storage/fancy/nugget_box
	name = "wing box"
	desc = "A cardboard box used for holding unsauced chicken wings."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "nuggetbox"
	icon_type = "nugget"
	custom_price = 3
	spawn_type = /obj/item/food/vampire/nugget

/obj/item/storage/fancy/nugget_box/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 5
	STR.set_holdable(list(/obj/item/food/vampire/nugget))

/obj/item/storage/fancy/hardcase
	name = "5.56 magazine hardcase"
	desc = "A small metal hardcase specifically designed to carry 5.56 magazines."
	icon = 'icons/obj/storage.dmi'
	icon_state = "hardcasbox"
	icon_type = "hardcase"
	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	spawn_type = /obj/item/ammo_box/magazine/vamp556
	component_type = /datum/component/storage/concrete/vtm/hardcase

/obj/item/storage/fancy/hardcase/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 4
	STR.set_holdable(list(/obj/item/ammo_box/magazine/vamp556))

/obj/item/storage/fancy/hardcase/mp5
	name = "Mp5 magazine hardcase"
	desc = "A small metal hardcase specifically designed to carry Mp5 magazines."
	icon_state = "hardcasebox"
	inhand_icon_state = "syringe_kit"
	icon_type = "hardcase"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	spawn_type = /obj/item/ammo_box/magazine/vamp9mp5
	component_type = /datum/component/storage/concrete/vtm/hardcase

/obj/item/storage/fancy/hardcase/mp5/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 4
	STR.set_holdable(list(/obj/item/ammo_box/magazine/vamp9mp5))
