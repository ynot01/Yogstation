#define ADRENALINE_THRESHOLD 25

/obj/item/organ/heart
	name = "heart"
	desc = "I feel bad for the heartless bastard who lost this."
	icon_state = "heart"
	visual = FALSE
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_HEART
	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = 2.5 * STANDARD_ORGAN_DECAY		//designed to fail about 6 minutes after death

	low_threshold_passed = span_info("Prickles of pain appear then die out from within your chest...")
	high_threshold_passed = span_warning("Something inside your chest hurts, and the pain isn't subsiding. You notice yourself breathing far faster than before.")
	now_fixed = span_info("Your heart begins to beat again.")
	high_threshold_cleared = span_info("The pain in your chest has died down, and your breathing becomes more relaxed.")

	// Heart attack code is in code/modules/mob/living/carbon/human/life.dm
	var/beating = 1
	var/icon_base = "heart"
	attack_verb = list("beat", "thumped")
	var/beat = BEAT_NONE//is this mob having a heatbeat sound played? if so, which?
	var/failed = FALSE		//to prevent constantly running failing code
	var/operated = FALSE	//whether the heart's been operated on to fix some of its damages
	var/lasthealth
	COOLDOWN_DECLARE(adrenal_cooldown)

/obj/item/organ/heart/Initialize()
	. = ..()
	icon_base = icon_state
	update_icon()

/obj/item/organ/heart/update_icon()
	if(beating)
		icon_state = "[icon_base]-on"
	else
		icon_state = "[icon_base]"

/obj/item/organ/heart/Remove(mob/living/carbon/M, special = 0)
	..()
	if(!special)
		addtimer(CALLBACK(src, .proc/stop_if_unowned), 120)

/obj/item/organ/heart/proc/stop_if_unowned()
	if(!owner)
		Stop()

/obj/item/organ/heart/attack_self(mob/user)
	..()
	if(!beating)
		user.visible_message("<span class='notice'>[user] squeezes [src] to \
			make it beat again!</span>",span_notice("You squeeze [src] to make it beat again!"))
		Restart()
		addtimer(CALLBACK(src, .proc/stop_if_unowned), 80)

/obj/item/organ/heart/proc/Stop()
	beating = 0
	update_icon()
	return TRUE

/obj/item/organ/heart/proc/Restart()
	beating = 1
	update_icon()
	return TRUE

/obj/item/organ/heart/prepare_eat()
	var/obj/S = ..()
	S.icon_state = "heart-off"
	return S

/obj/item/organ/heart/on_life()
	..()
	if(owner.client && beating)
		failed = FALSE
		var/sound/slowbeat = sound('sound/health/slowbeat.ogg', repeat = TRUE)
		var/sound/fastbeat = sound('sound/health/fastbeat.ogg', repeat = TRUE)
		var/mob/living/carbon/H = owner
		if(COOLDOWN_FINISHED(src, adrenal_cooldown) && ((H.health+ADRENALINE_THRESHOLD) < lasthealth))
			H.reagents.add_reagent(/datum/reagent/adrenaline, 5)
			COOLDOWN_START(src, adrenal_cooldown, 10 MINUTES)
		lasthealth = H.health

		if(H.health <= H.crit_threshold && beat != BEAT_SLOW)
			beat = BEAT_SLOW
			H.playsound_local(get_turf(H), slowbeat,40,0, channel = CHANNEL_HEARTBEAT)
			to_chat(owner, "<span class = 'notice'>You feel your heart slow down...</span>")
		if(beat == BEAT_SLOW && H.health > H.crit_threshold)
			H.stop_sound_channel(CHANNEL_HEARTBEAT)
			beat = BEAT_NONE

		if(H.jitteriness)
			if(H.health > HEALTH_THRESHOLD_FULLCRIT && (!beat || beat == BEAT_SLOW))
				H.playsound_local(get_turf(H),fastbeat,40,0, channel = CHANNEL_HEARTBEAT)
				beat = BEAT_FAST
		else if(beat == BEAT_FAST)
			H.stop_sound_channel(CHANNEL_HEARTBEAT)
			beat = BEAT_NONE
	if(HAS_TRAIT(owner, TRAIT_FAT) && owner.stat != DEAD) //yogs: being fat causes heart damage
		owner.adjustOrganLoss(ORGAN_SLOT_HEART, maxHealth * STANDARD_ORGAN_DECAY, 85) //eat happy, eat healthy
		if(damage >= 80 && beating)
			if(prob(1))
				if(owner.stat == CONSCIOUS)
					owner.visible_message(span_userdanger("[owner] clutches at [owner.p_their()] chest as if [owner.p_their()] heart is stopping!"))
				owner.set_heartattack(TRUE) //yogs end
	if(organ_flags & ORGAN_FAILING)	//heart broke, stopped beating, death imminent
		if(owner.stat == CONSCIOUS)
			owner.visible_message(span_userdanger("[owner] clutches at [owner.p_their()] chest as if [owner.p_their()] heart is stopping!"))
		owner.set_heartattack(TRUE)
		failed = TRUE

/obj/item/organ/heart/get_availability(datum/species/species)
	return !(NOBLOOD in species.species_traits)

/obj/item/organ/heart/cursed
	name = "cursed heart"
	desc = "A heart that, when inserted, will force you to pump it manually."
	icon_state = "cursedheart"
	icon_base = "cursedheart"
	decay_factor = 0
	actions_types = list(/datum/action/item_action/organ_action/cursed_heart)
	var/last_pump = 0
	var/add_colour = TRUE //So we're not constantly recreating colour datums
	var/pump_delay = 30 //you can pump 1 second early, for lag, but no more (otherwise you could spam heal)
	var/blood_loss = 100 //600 blood is human default, so 5 failures (below 122 blood is where humans die because reasons?)

	//How much to heal per pump, negative numbers would HURT the player
	var/heal_brute = 0
	var/heal_burn = 0
	var/heal_oxy = 0


/obj/item/organ/heart/cursed/attack(mob/living/carbon/human/H, mob/living/carbon/human/user, obj/target)
	if(H == user && istype(H))
		playsound(user,'sound/effects/singlebeat.ogg',40,1)
		user.temporarilyRemoveItemFromInventory(src, TRUE)
		Insert(user)
	else
		return ..()

/obj/item/organ/heart/cursed/on_life()
	if(world.time > (last_pump + pump_delay))
		if(ishuman(owner) && owner.client) //While this entire item exists to make people suffer, they can't control disconnects.
			var/mob/living/carbon/human/H = owner
			if(H.dna && !(NOBLOOD in H.dna.species.species_traits))
				H.blood_volume = max(H.blood_volume - blood_loss, 0)
				to_chat(H, "<span class = 'userdanger'>You have to keep pumping your blood!</span>")
				if(add_colour)
					H.add_client_colour(/datum/client_colour/cursed_heart_blood) //bloody screen so real
					add_colour = FALSE
		else
			last_pump = world.time //lets be extra fair *sigh*

/obj/item/organ/heart/cursed/Insert(mob/living/carbon/M, special = 0)
	..()
	if(owner)
		to_chat(owner, "<span class ='userdanger'>Your heart has been replaced with a cursed one, you have to pump this one manually otherwise you'll die!</span>")

/obj/item/organ/heart/cursed/Remove(mob/living/carbon/M, special = 0)
	..()
	M.remove_client_colour(/datum/client_colour/cursed_heart_blood)

/datum/action/item_action/organ_action/cursed_heart
	name = "Pump your blood"

//You are now brea- pumping blood manually
/datum/action/item_action/organ_action/cursed_heart/Trigger()
	. = ..()
	if(. && istype(target, /obj/item/organ/heart/cursed))
		var/obj/item/organ/heart/cursed/cursed_heart = target

		if(world.time < (cursed_heart.last_pump + (cursed_heart.pump_delay-10))) //no spam
			to_chat(owner, span_userdanger("Too soon!"))
			return

		cursed_heart.last_pump = world.time
		playsound(owner,'sound/effects/singlebeat.ogg',40,1)
		to_chat(owner, "<span class = 'notice'>Your heart beats.</span>")

		var/mob/living/carbon/human/H = owner
		if(istype(H))
			if(H.dna && !(NOBLOOD in H.dna.species.species_traits))
				H.blood_volume = min(H.blood_volume + cursed_heart.blood_loss*0.5, BLOOD_VOLUME_MAXIMUM(H))
				H.remove_client_colour(/datum/client_colour/cursed_heart_blood)
				cursed_heart.add_colour = TRUE
				H.adjustBruteLoss(-cursed_heart.heal_brute)
				H.adjustFireLoss(-cursed_heart.heal_burn)
				H.adjustOxyLoss(-cursed_heart.heal_oxy)


/datum/client_colour/cursed_heart_blood
	priority = 100 //it's an indicator you're dying, so it's very high priority
	colour = "red"

/obj/item/organ/heart/vampheart
	beating = 0
	///If a heartbeat is being faked.
	var/fakingit = FALSE

/obj/item/organ/heart/vampheart/Restart()
	beating = FALSE
	return FALSE

/obj/item/organ/heart/vampheart/Stop()
	fakingit = FALSE
	return ..()

/obj/item/organ/heart/vampheart/proc/FakeStart()
	fakingit = TRUE // We're pretending to beat, to fool people.

/// Bloodsuckers don't have a heartbeat at all when stopped (default is "an unstable")
/obj/item/organ/heart/vampheart/HeartStrengthMessage()
	if(fakingit)
		return "a healthy"
	return span_danger("no")

/// Proc for the default (Non-Bloodsucker) Heart!
/obj/item/organ/heart/proc/HeartStrengthMessage()
	if(beating)
		return "a healthy"
	return span_danger("an unstable")

/obj/item/organ/heart/ghetto
	name = "so called 'maintenance heart'"
	desc = "A haphazardly constructed device that can supposedly pump blood. Used by the desperate or insane."
	icon_state = "heart-g"
	maxHealth = 0.5 * STANDARD_ORGAN_THRESHOLD
	organ_efficiency = 0.5
	organ_flags = ORGAN_SYNTHETIC

/obj/item/organ/heart/cybernetic
	name = "cybernetic heart"
	desc = "An electronic device designed to mimic the functions of an organic human heart."
	icon_state = "heart-c"
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	organ_efficiency = 2
	organ_flags = ORGAN_SYNTHETIC
	var/restartTimer = 10 SECONDS

/obj/item/organ/heart/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	Stop()
	addtimer(CALLBACK(src, .proc/Restart), restartTimer/severity) //Can restart itself after an EMP so it isnt an insta death

/obj/item/organ/heart/cybernetic/upgraded
	name = "upgraded cybernetic heart"
	desc = "An electronic device designed to mimic the functions of an organic human heart. Fitted with a blood synthesizer, it also holds an emergency epinephrine synthesizer that supplies a dosage if the body is critically damaged."
	icon_state = "heart-c-u"
	maxHealth = 3 * STANDARD_ORGAN_THRESHOLD
	organ_efficiency = 3
	var/dose_available = TRUE
	var/rid = /datum/reagent/medicine/epinephrine
	var/ramount = 10
	restartTimer = 5 SECONDS //restarts faster

/obj/item/organ/heart/cybernetic/upgraded/on_life()
	. = ..()
	if(dose_available && owner.stat == UNCONSCIOUS && !owner.reagents.has_reagent(rid))
		owner.reagents.add_reagent(rid, ramount)
		used_dose()

/obj/item/organ/heart/cybernetic/upgraded/proc/used_dose()
	dose_available = FALSE
	addtimer(VARSET_CALLBACK(src, dose_available, TRUE), 5 MINUTES)

/obj/item/organ/heart/cybernetic/ipc
	desc = "An electronic device that appears to mimic the functions of an organic heart."

/obj/item/organ/heart/cybernetic/ipc/emp_act()
	if(prob(30))
		return
	. = ..()
	to_chat(owner, "<span class='warning'>Alert: Cybernetic heart failed one heartbeat</span>")
	addtimer(CALLBACK(src, .proc/Restart), 10 SECONDS)

/obj/item/organ/heart/freedom
	name = "heart of freedom"
	desc = "This heart pumps with the passion to give... something freedom."
	organ_flags = ORGAN_SYNTHETIC //the power of freedom prevents heart attacks
	var/min_next_adrenaline = 0

/obj/item/organ/heart/freedom/on_life()
	. = ..()
	if(owner.health < 5 && world.time > min_next_adrenaline)
		min_next_adrenaline = world.time + rand(250, 600) //anywhere from 4.5 to 10 minutes
		to_chat(owner, span_userdanger("You feel yourself dying, but you refuse to give up!"))
		owner.heal_overall_damage(15, 15, 0, BODYPART_ORGANIC)
		if(owner.reagents.get_reagent_amount(/datum/reagent/medicine/ephedrine) < 20)
			owner.reagents.add_reagent(/datum/reagent/medicine/ephedrine, 10)
