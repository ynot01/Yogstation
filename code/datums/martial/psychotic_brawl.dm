/datum/martial_art/psychotic_brawling
	name = "Psychotic Brawling"
	id = MARTIALART_PSYCHOBRAWL

/datum/martial_art/psychotic_brawling/teach(mob/living/carbon/human/H,make_temporary=0)
	. = ..()
	if(.)
		ADD_TRAIT(H, TRAIT_NO_STUN_WEAPONS, "[type][REF(src)]")

/datum/martial_art/psychotic_brawling/on_remove(mob/living/carbon/human/H)
	. = ..()
	REMOVE_TRAIT(H, TRAIT_NO_STUN_WEAPONS, "[type][REF(src)]")

/datum/martial_art/psychotic_brawling/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return psycho_attack(A,D)

/datum/martial_art/psychotic_brawling/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return psycho_attack(A,D)

/datum/martial_art/psychotic_brawling/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return psycho_attack(A,D)

/datum/martial_art/psychotic_brawling/proc/psycho_attack(mob/living/carbon/human/A, mob/living/carbon/human/D)
	var/atk_verb
	var/stun_mult = A.reagents.has_reagent(/datum/reagent/drug/bath_salts) ? 10 : 1	//Multiply all the stun values by 10 if we get this from bath salts
	var/armor_block = 0
	switch(rand(1,8))
		if(1)
			D.help_shake_act(A)
			atk_verb = "helped"
		if(2)
			A.emote("cry")
			A.Stun(20 * stun_mult)
			atk_verb = "cried looking at"
		if(3)
			if(A.grab_state >= GRAB_AGGRESSIVE)
				D.grabbedby(A, 1)
			else
				A.start_pulling(D, supress_message = TRUE)
				if(A.pulling)
					D.drop_all_held_items()
					D.stop_pulling()
					if(A.a_intent == INTENT_GRAB)
						log_combat(A, D, "grabbed", addition="aggressively")
						D.visible_message(span_warning("[A] violently grabs [D]!"), \
						  span_userdanger("[A] violently grabs you!"))
						A.grab_state = GRAB_AGGRESSIVE //Instant aggressive grab
					else
						log_combat(A, D, "grabbed", addition="passively")
						A.grab_state = GRAB_PASSIVE
		if(4)
			A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
			atk_verb = "headbutts"
			D.visible_message(span_danger("[A] [atk_verb] [D]!"), \
					  span_userdanger("[A] [atk_verb] you!"))
			playsound(get_turf(D), 'sound/weapons/punch1.ogg', 40, 1, -1)
			var/headbutt_damage = rand(A.get_punchdamagehigh() + rand(-5,5))	//5-15 damage
			armor_block = D.run_armor_check(BODY_ZONE_HEAD, MELEE, armour_penetration = 20)		//20 AP
			var/user_armor_block = A.run_armor_check(BODY_ZONE_HEAD, MELEE, armour_penetration = 20)	//for fairness
			D.apply_damage(headbutt_damage, A.dna.species.attack_type, BODY_ZONE_HEAD, armor_block)
			A.apply_damage(headbutt_damage, A.dna.species.attack_type, BODY_ZONE_HEAD, user_armor_block)
			if(!istype(D.head,/obj/item/clothing/head/helmet/) && !istype(D.head,/obj/item/clothing/head/hardhat))
				D.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5)
			A.Stun(rand(10,45) * stun_mult)			//No I'm not making wearing helmets reduce this
			D.Stun(rand(5,30) * armor_block / 100)	//But I will for the defender. This martial art is OSHA-approved.
		if(5,6)
			A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
			atk_verb = pick("punches", "kicks", "hits", "slams into")
			var/punch_damage = rand(A.get_punchdamagehigh() + 5 , 2 * A.get_punchdamagehigh() + 10)	//15-30 damage
			armor_block = D.run_armor_check(BODY_ZONE_CHEST, MELEE, armour_penetration = 20)
			D.visible_message(span_danger("[A] [atk_verb] [D] with inhuman strength, sending [D.p_them()] flying backwards!"), \
							  span_userdanger("[A] [atk_verb] you with inhuman strength, sending you flying backwards!"))
			D.apply_damage(punch_damage, A.dna.species.attack_type, BODY_ZONE_CHEST, armor_block)
			playsound(get_turf(D), 'sound/effects/meteorimpact.ogg', 25, 1, -1)
			var/throwtarget = get_edge_target_turf(A, get_dir(A, get_step_away(D, A)))
			D.throw_at(throwtarget, 4, 2, A)//So stuff gets tossed around at the same time.
			D.Paralyze(60 * armor_block / 100)
		if(7,8)
			basic_hit(A,D)

	if(atk_verb)
		log_combat(A, D, "[atk_verb] (Psychotic Brawling)")
	return 1
