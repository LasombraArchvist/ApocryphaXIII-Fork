/datum/job/vamp/trujah
	title = "Antique Worker"
	faction = "Vampire"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Del'Roh"
	selection_color = "#df7058"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/trujah
	antag_rep = 7
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.

	access = list(ACCESS_MAINT_TUNNELS)
	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_TRUJAH

	allowed_species = list("Vampire")

	v_duty = "Openly follow the traditions, ensure the coming of Gehenna so that you might fight along the side of the righteous."
	duty = "You serve the True Blackhand! Operating out of the antique shop, you engage in extremely subtle political moves against the local sects. Good luck, and don't be discovered."
	minimal_masquerade = 0
	allowed_bloodlines = list(CLAN_TRUE_BRUJAH, CLAN_OLD_TZIMISCE)

/datum/outfit/job/trujah
	name = "Antique Shop Worker"
	jobtype = /datum/job/vamp/trujah
	l_pocket = /obj/item/vamp/phone
	id = /obj/item/cockclock
	backpack_contents = list(
		/obj/item/passport=1,
		/obj/item/flashlight=1,
		/obj/item/card/credit=1,
	)

/datum/outfit/job/trujah/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.clan)
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
			if(H.clan.male_clothes)
				uniform = H.clan.male_clothes
		else
			shoes = /obj/item/clothing/shoes/vampire/heels
			if(H.clan.female_clothes)
				uniform = H.clan.female_clothes
	else
		uniform = /obj/item/clothing/under/vampire/emo
		if(H.gender == MALE)
			shoes = /obj/item/clothing/shoes/vampire
		else
			shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/trujah
	name = "Antique Shop Worker"
	icon_state = "Assistant"
