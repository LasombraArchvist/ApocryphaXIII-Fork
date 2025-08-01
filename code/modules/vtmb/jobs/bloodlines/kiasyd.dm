/datum/job/vamp/kiasyd
	title = "Church Curator"
	faction = "Vampire"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Traditions"
	selection_color = "#df7058"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/kiasyd
	antag_rep = 7
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.

	access = list(ACCESS_MAINT_TUNNELS)
	liver_traits = list(TRAIT_GREYTIDE_METABOLISM)

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_KIASYD

	allowed_species = list("Vampire")

	v_duty = "You are a member of the Kiasyd bloodline! You maintain the Library on the top floor of the Church, sharing space with the local Lasombra, and conduct arcane rituals out of sight. Good luck."
	duty = "You are a member of the Kiasyd bloodline! You maintain the Library on the top floor of the Church, sharing space with the local Lasombra, and conduct arcane rituals out of sight. Good luck."
	minimal_masquerade = 0
	allowed_bloodlines = list(CLAN_KIASYD)

/datum/outfit/job/kiasyd
	name = CLAN_KIASYD
	jobtype = /datum/job/vamp/kiasyd
	l_pocket = /obj/item/vamp/phone
	id = /obj/item/cockclock
	backpack_contents = list(
		/obj/item/passport=1,
		/obj/item/flashlight=1,
		/obj/item/card/credit=1,
	)

/datum/outfit/job/kiasyd/pre_equip(mob/living/carbon/human/H)
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

/obj/effect/landmark/start/kiasyd
	name = "Museum Groundskeeper"
	icon_state = "Assistant"
