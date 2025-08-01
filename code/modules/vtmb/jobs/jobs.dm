/datum/job
	var/experience_addition = 5

/datum/outfit/job/post_equip(mob/living/carbon/human/H)
	. = ..()
	var/obj/item/storage/backpack/b = locate() in H
	if(b)
		var/obj/item/card/credit/card = locate() in b.contents
		if(card && card.has_checked == FALSE)
			for(var/obj/item/card/credit/caard in b.contents)
				if(caard)
					H.account_id = caard.registered_account.account_id
					caard.registered_account.account_holder = H.true_real_name
					caard.has_checked = TRUE

//ID

/obj/item/card/id/prince/AltClick(mob/user)
	return

/obj/item/card/id/sheriff/AltClick(mob/user)
	return

/obj/item/card/id/camarilla/AltClick(mob/user)
	return

/obj/item/card/id/clerk/AltClick(mob/user)
	return

/obj/item/card/id/anarch/AltClick(mob/user)
	return

/obj/item/card/id/clinic/AltClick(mob/user)
	return

/obj/item/card/id/archive/AltClick(mob/user)
	return

/obj/item/card/id/cleaning/AltClick(mob/user)
	return

/obj/item/card/id/dealer/AltClick(mob/user)
	return

/obj/item/card/id/supplytech/AltClick(mob/user)
	return

/obj/item/card/id/hunter/AltClick(mob/user)
	return

/obj/item/card/id/primogen/AltClick(mob/user)
	return

/obj/item/card/id/police/AltClick(mob/user)
	return

/obj/item/card/id/hunter
	var/last_detonated = 0

/obj/item/card/id/hunter/attack_self(mob/user)
	. = ..()
	if(last_detonated+300 > world.time)
		return
	if(!user.mind)
		return
	if(user.mind.holy_role != HOLY_ROLE_PRIEST)
		return
	last_detonated = world.time
	do_sparks(rand(5, 9), FALSE, user)
	playsound(user.loc, 'code/modules/wod13/sounds/cross.ogg', 100, FALSE, 8, 0.9)
	for(var/mob/living/M in get_hearers_in_view(4, user.loc))
		bang(get_turf(M), M, user)

/obj/item/card/id/hunter/proc/bang(turf/T, mob/living/M, mob/living/user)
	if(M.stat == DEAD)	//They're dead!
		return
	var/mob/living/carbon/human/H
	if(ishuman(M))
		H = M
	if(H)
		for(var/obj/item/card/id/hunter/HUNT in H.contents)
			if(HUNT)
				if(H.mind)
					if(H.mind.holy_role == HOLY_ROLE_PRIEST)
						return
		if(iskindred(H))
			if(H.clan)
				if(H.clan.name == CLAN_BAALI)
					H.emote("scream")
					H.pointed(user)
	M.show_message("<span class='warning'><b>GOD SEES YOU!</b></span>", MSG_AUDIBLE)
	var/distance = max(0,get_dist(get_turf(src),T))

	if(M.flash_act(affect_silicon = 1))
		M.Immobilize(max(10/max(1,distance), 5))

/obj/item/card/id/hunter/attack(mob/living/target, mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		return
	if(last_detonated+300 > world.time)
		return
	if(iskindred(target))
		var/mob/living/carbon/human/H = target
		if(H.clan)
			if(H.clan.name == CLAN_BAALI)
				last_detonated = world.time
				var/turf/lightning_source = get_step(get_step(H, NORTH), NORTH)
				lightning_source.Beam(H, icon_state="lightning[rand(1,12)]", time = 5)
				H.adjustFireLoss(100)
				H.electrocution_animation(50)
				to_chat(H, "<span class='userdanger'>The God has punished you for your sins!</span>", confidential = TRUE)

/obj/item/card/id/prince
	name = "leader badge"
	id_type_name = "leader badge"
	desc = "King in the castle!"
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id6"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id6"

/obj/item/card/id/sheriff
	name = "head security badge"
	id_type_name = "head security badge"
	desc = "A badge which shows honour and dedication."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id4"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id4"

/obj/item/card/id/camarilla
	name = "security badge"
	id_type_name = "security badge"
	desc = "A badge which shows honour and dedication."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id3"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id3"

/obj/item/card/id/clerk
	name = "clerk badge"
	id_type_name = "clerk badge"
	desc = "A badge which shows bureaucracy qualification."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id1"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id1"

/obj/item/card/id/clerk/harpy
	name = "Public Relations Clerk badge"
	desc = "A badge which shows social qualifications."

/obj/item/card/id/bruiser
	name = "bruiser badge"
	id_type_name = "bruiser badge"
	desc = "A badge which shows grit."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "bruiser_badge"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "bruiser_badge"
	registered_name_is_public = FALSE

/obj/item/card/id/sweeper
	name = "sweeper badge"
	id_type_name = "sweeper badge"
	desc = "A badge which shows perspective."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "sweeper_badge"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "sweeper_badge"
	registered_name_is_public = FALSE

/obj/item/card/id/emissary
	name = "emissary badge"
	id_type_name = "emissary badge"
	desc = "A badge which shows a favored voice, interlaced with gold thread."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "emissary_badge"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "emissary_badge"
	registered_name_is_public = FALSE

/obj/item/card/id/baron
	name = "eagle badge"
	id_type_name = "eagle badge"
	desc = "The badge of a leader. The eagle stands proud, surrounded by the gold of their nest."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "eagle_badge"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "eagle_badge"
	registered_name_is_public = FALSE

/obj/item/card/id/clinic
	name = "medical badge"
	id_type_name = "medical badge"
	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY)
	desc = "A badge which shows medical qualification."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id2"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id2"

/obj/item/card/id/clinic/director
	name = "clinic director's badge"
	desc = "A badge which shows not only medical qualification, but also an authority over the clinic."

/obj/item/card/id/archive
	name = "scholar badge"
	id_type_name = "scholar badge"
	desc = "A badge which shows a love of culture."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id7"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id7"

/obj/item/card/id/regent
	name = "erudite scholar badge"
	id_type_name = "erudite scholar badge"
	desc = "A badge which shows a deep understanding of culture."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id7_regent"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id7_regent"

/obj/item/card/id/cleaning
	name = "janitor badge"
	id_type_name = "janitor badge"
	desc = "A badge which shows cleaning employment."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id8"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id8"

/obj/item/card/id/graveyard
	name = "keeper badge"
	id_type_name = "keeper badge"
	desc = "A badge which shows graveyard employment."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id8"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id8"

/obj/item/card/id/dealer
	name = "business badge"
	id_type_name = "business badge"
	desc = "A badge which shows business."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id9"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id9"

/obj/item/card/id/supplytech
	name = "technician badge"
	id_type_name = "technician badge"
	desc = "A badge which shows supply employment."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id10"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id10"

/obj/item/card/id/hunter
	name = "cross"
	id_type_name = "cross"
	desc = "When you come into the land that the Lord your God is giving you, you must not learn to imitate the abhorrent practices of those nations. No one shall be found among you who makes a son or daughter pass through fire, or who practices divination, or is a soothsayer, or an augur, or a sorcerer, or one who casts spells, or who consults ghosts or spirits, or who seeks oracles from the dead. For whoever does these things is abhorrent to the Lord; it is because of such abhorrent practices that the Lord your God is driving them out before you (Deuteronomy 18:9-12)."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id11"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id11"
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_ID
	registered_name_is_public = FALSE

/obj/item/card/id/primogen
	name = "mysterious primogen badge"
	id_type_name = "mysterious primogen badge"
	desc = "Sponsored by the Shadow Government."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id12"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id12"
	registered_name_is_public = FALSE

/obj/item/card/id/police
	name = "police officer badge"
	id_type_name = "police officer badge"
	desc = "Sponsored by the Government."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id13"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id13"

/obj/item/card/id/government
	name = "emergency dispatcher badge"
	id_type_name = "emergency dispatcher badge"
	desc = "Sponsored by the Government."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id1"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id1"

/obj/item/card/id/police/sergeant
	name = "police sergeant badge"
	desc = "Sponsored by the Government. This one seems slightly more worn down than all the others."

/obj/item/card/id/police/chief
	name = "police chief badge"
	desc = "Sponsored by the Government. This one has a chrome plated finish."

/obj/item/card/id/police/fbi
	name = "fbi special agent badge"
	desc = "Sponsored by the Government. This one has all the bells and whistles."

/obj/item/card/id/bahari
	name = "cultist badge"
	id_type_name = "cultist badge"
	desc = "This shows your devotion to the dark mother."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id14"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id14"
	registered_name_is_public = FALSE

/obj/item/card/id/noddist
	name = "cultist badge"
	id_type_name = "cultist badge"
	desc = "This shows your devotion to the dark father."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id15"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id15"
	registered_name_is_public = FALSE

//TZIMISCE ROLES

/obj/item/card/id/voivode
	name = "ancient badge"
	id_type_name ="ancient badge"
	desc = "You have to wear this filthy thing to be recognized."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id12"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id12"
	registered_name_is_public = FALSE

/obj/item/card/id/bogatyr
	name = "dusty badge"
	id_type_name ="dusty badge"
	desc = "You have to wear this because the Voivode wants you to."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id12"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id12"
	registered_name_is_public = FALSE

// PRIMOGEN STAFF (Distributed in game by Primogen)

/obj/item/card/id/whip
	name = "primogen's whip badge"
	id_type_name = "whip badge"
	desc = "This badge shows your servitude to an important person."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "onyxBadge"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "onyxBadge"

/obj/item/card/id/steward
	name = "primogen's steward badge"
	id_type_name = "steward badge"
	desc = "This badge shows you're very good at taking care of someone else's property."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "emeraldBadge"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "emeraldBadge"

/obj/item/card/id/myrmidon
	name = "primogen's myrmidon badge"
	id_type_name = "myrmidon badge"
	desc = "A badge which shows you're responsible enough to protect someone important but not responsible enough to protect the most important."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "rubyBadge"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "rubyBadge"

// GAROU
/obj/item/card/id/garou
	name = "Base Garou ID"
	id_type_name = "Coder Moment badge"
	desc = "DO NOT USE THIS, THIS IS FOR CODE FOUNDATION ONLY. IF YOU SEE THIS, REPORT IT AS A BUG."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "id5"
	inhand_icon_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	worn_icon_state = "id5"

//PAINTED CITY
/obj/item/card/id/garou/city/council
	name = "Pantry volunteer manager badge"
	desc = "For those who have managed to go through the most dangerous of tasks, and lived long enough to be considered old in such a field. Volunteer work."

/obj/item/card/id/garou/city/keeper
	name = "Pantry building manager badge"
	desc = "Forever stuck to taking care of the pantry, well, you signed up for this."

/obj/item/card/id/garou/city/truthcatcher
	name = "Pantry mediator badge"
	desc = "You are not just the talker and cleaner by assignment. You volunteered for this. Good luck."

/obj/item/card/id/garou/city/warder
	name = "Pantry security lead badge"
	desc = "Private security for a single building, there are no donuts in the backroom."

/obj/item/card/id/garou/city/guardian
	name = "Pantry security volunteer badge"
	desc = "Private security for a single building, just hope they have donuts in the backroom."

//AMBERGLADE
/obj/item/card/id/garou/glade
	icon_state = "id7"
	worn_icon_state = "id7"

/obj/item/card/id/garou/glade/council
	name = "NPS Oversight Committee badge"
	desc = "You have been out in the woods to know that you arent afraid of anything but one specific topic out there. Leadership."

/obj/item/card/id/garou/glade/keeper
	name = "NPS Biologist badge"
	desc = "You love the outdoors? Good, you are now taking care of a wide outdoors area."

/obj/item/card/id/garou/glade/truthcatcher
	name = "Park Guide badge"
	desc = "Remember, Dire Wolves arent real, as far as you tell people."

/obj/item/card/id/garou/glade/warder
	name = "Lead Park Ranger badge"
	desc = "These are your woods and your lands. Keep them safe."

/obj/item/card/id/garou/glade/guardian
	name = "Park Ranger badge"
	desc = "Only you can prevent forest fires."

//ENDRON
/obj/item/card/id/garou/spiral
	icon_state = "id9"
	worn_icon_state = "id9"

/obj/item/card/id/garou/spiral/lead
	name = "Endron Branch Leader card"
	desc = "How bad can you possibly be?"

/obj/item/card/id/garou/spiral/executive
	name = "Endron Executive card"
	desc = "All the customers are buying."

/obj/item/card/id/garou/spiral/affairs
	name = "Endron Internal Affairs card"
	desc = "And the Lawyers are denying."

/obj/item/card/id/garou/spiral/secchief
	name = "Endron Chief of Security badge"
	icon_state = "id3"
	worn_icon_state = "id3"
	desc = "Its not illegal if nobody finds out about it. Now if only Endron would pay for a single tank for you."

/obj/item/card/id/garou/spiral/sec
	name = "Endron Security Agent badge"
	icon_state = "id3"
	worn_icon_state = "id3"
	desc = "Corporate Security, a step above a mall cop. Better paid than a real cop."

/obj/item/card/id/garou/spiral/employee
	name = "Endron Employee card"
	desc = "Congratulations, Wagie."
