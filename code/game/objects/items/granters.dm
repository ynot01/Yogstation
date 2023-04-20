
///books that teach things (intrinsic actions like bar flinging, spells like fireball or smoke, or martial arts)///

/obj/item/book/granter
	due_date = 0 // Game time in deciseconds
	unique = 1   // 0  Normal book, 1  Should not be treated as normal book, unable to be copied, unable to be modified
	var/list/remarks = list() //things to read about while learning.
	var/ordered = FALSE //determines if the remarks should display in order rather than randomly
	var/pages_to_mastery = 3 //Essentially controls how long a mob must keep the book in his hand to actually successfully learn
	var/reading = FALSE //sanity
	var/oneuse = TRUE //default this is true, but admins can var this to 0 if we wanna all have a pass around of the rod form book
	var/used = FALSE //only really matters if oneuse but it might be nice to know if someone's used it for admin investigations perhaps

/obj/item/book/granter/proc/turn_page(mob/user)
	playsound(user, pick('sound/effects/pageturn1.ogg','sound/effects/pageturn2.ogg','sound/effects/pageturn3.ogg'), 30, 1)
	if(do_after(user, 5 SECONDS, user))
		if(remarks.len && ordered)
			to_chat(user, span_notice("[popleft(remarks)]"))
		else if(remarks.len)
			to_chat(user, span_notice("[pick(remarks)]"))
		else
			to_chat(user, span_notice("You keep reading..."))
		return TRUE
	return FALSE

/obj/item/book/granter/proc/recoil(mob/user) //nothing so some books can just return

/obj/item/book/granter/proc/already_known(mob/user)
	return FALSE

/obj/item/book/granter/proc/on_reading_start(mob/user)
	to_chat(user, span_notice("You start reading [name]..."))

/obj/item/book/granter/proc/on_reading_stopped(mob/user)
	to_chat(user, span_notice("You stop reading..."))

/obj/item/book/granter/proc/on_reading_finished(mob/user)
	to_chat(user, span_notice("You finish reading [name]!"))

/obj/item/book/granter/proc/onlearned(mob/user)
	used = TRUE


/obj/item/book/granter/attack_self(mob/user)
	if(reading)
		to_chat(user, span_warning("You're already reading this!"))
		return FALSE
	if(!user.can_read(src))
		return FALSE
	if(already_known(user))
		return FALSE
	if(used && oneuse)
		recoil(user)
	else
		on_reading_start(user)
		reading = TRUE
		for(var/i=1, i<=pages_to_mastery, i++)
			if(!turn_page(user))
				on_reading_stopped()
				reading = FALSE
				return
		if(do_after(user, 5 SECONDS, user))
			on_reading_finished(user)
		reading = FALSE
	return TRUE

///ACTION BUTTONS///

/obj/item/book/granter/action
	var/granted_action
	var/actionname = "catching bugs" //might not seem needed but this makes it so you can safely name action buttons toggle this or that without it fucking up the granter, also caps

/obj/item/book/granter/action/already_known(mob/user)
	if(!granted_action)
		return TRUE
	for(var/datum/action/A in user.actions)
		if(A.type == granted_action)
			to_chat(user, span_notice("You already know all about [actionname]."))
			return TRUE
	return FALSE

/obj/item/book/granter/action/on_reading_start(mob/user)
	to_chat(user, span_notice("You start reading about [actionname]..."))

/obj/item/book/granter/action/on_reading_finished(mob/user)
	to_chat(user, span_notice("You feel like you've got a good handle on [actionname]!"))
	var/datum/action/G = new granted_action
	G.Grant(user)
	onlearned(user)

/obj/item/book/granter/action/origami
	granted_action = /datum/action/innate/origami
	name = "The Art of Origami"
	desc = "A meticulously in-depth manual explaining the art of paper folding."
	icon_state = "origamibook"
	actionname = "origami"
	oneuse = TRUE
	remarks = list("Dead-stick stability...", "Symmetry seems to play a rather large factor...", "Accounting for crosswinds... really?", "Drag coefficients of various paper types...", "Thrust to weight ratios?", "Positive dihedral angle?", "Center of gravity forward of the center of lift...")

/datum/action/innate/origami
	name = "Origami Folding"
	desc = "Toggles your ability to fold and catch robust paper airplanes."
	button_icon_state = "origami_off"
	check_flags = NONE

/datum/action/innate/origami/Activate()
	to_chat(owner, span_notice("You will now fold origami planes."))
	button_icon_state = "origami_on"
	active = TRUE
	UpdateButtonIcon()

/datum/action/innate/origami/Deactivate()
	to_chat(owner, span_notice("You will no longer fold origami planes."))
	button_icon_state = "origami_off"
	active = FALSE
	UpdateButtonIcon()

///SPELLS///

/obj/item/book/granter/spell
	var/spell
	var/spellname = "conjure bugs"

/obj/item/book/granter/spell/already_known(mob/user)
	if(!spell)
		return TRUE
	for(var/obj/effect/proc_holder/spell/knownspell in user.mind.spell_list)
		if(knownspell.type == spell)
			if(user.mind)
				if(iswizard(user))
					to_chat(user,span_notice("You're already far more versed in this spell than this flimsy how-to book can provide."))
				else
					to_chat(user,span_notice("You've already read this one."))
			return TRUE
	return FALSE

/obj/item/book/granter/spell/on_reading_start(mob/user)
	to_chat(user, span_notice("You start reading about casting [spellname]..."))

/obj/item/book/granter/spell/on_reading_finished(mob/user)
	to_chat(user, span_notice("You feel like you've experienced enough to cast [spellname]!"))
	var/obj/effect/proc_holder/spell/S = new spell
	user.mind.AddSpell(S)
	user.log_message("learned the spell [spellname] ([S])", LOG_ATTACK, color="orange")
	onlearned(user)

/obj/item/book/granter/spell/recoil(mob/user)
	user.visible_message(span_warning("[src] glows in a black light!"))

/obj/item/book/granter/spell/onlearned(mob/user)
	..()
	if(oneuse)
		user.visible_message(span_caution("[src] glows dark for a second!"))

/obj/item/book/granter/spell/fireball
	spell = /obj/effect/proc_holder/spell/aimed/fireball
	spellname = "fireball"
	icon_state = "bookfireball"
	desc = "This book feels warm to the touch."
	remarks = list("Aim...AIM, FOOL!", "Just catching them on fire won't do...", "Accounting for crosswinds... really?", "I think I just burned my hand...", "Why the dumb stance? It's just a flick of the hand...", "OMEE... ONI... Ugh...", "What's the difference between a fireball and a pyroblast...")

/obj/item/book/granter/spell/fireball/recoil(mob/user)
	..()
	explosion(user.loc, 1, 0, 2, 3, FALSE, FALSE, 2)
	qdel(src)

/obj/item/book/granter/spell/sacredflame
	spell = /obj/effect/proc_holder/spell/targeted/sacred_flame
	spellname = "sacred flame"
	icon_state = "booksacredflame"
	desc = "Become one with the flames that burn within... and invite others to do so as well."
	remarks = list("Well, it's one way to stop an attacker...", "I'm gonna need some good gear to stop myself from burning to death...", "Keep a fire extinguisher handy, got it...", "I think I just burned my hand...", "Apply flame directly to chest for proper ignition...", "No pain, no gain...", "One with the flame...")

/obj/item/book/granter/spell/smoke
	spell = /obj/effect/proc_holder/spell/targeted/smoke
	spellname = "smoke"
	icon_state = "booksmoke"
	desc = "This book is overflowing with the dank arts."
	remarks = list("Smoke Bomb! Heh...", "Smoke bomb would do just fine too...", "Wait, there's a machine that does the same thing in chemistry?", "This book smells awful...", "Why all these weed jokes? Just tell me how to cast it...", "Wind will ruin the whole spell, good thing we're in space... Right?", "So this is how the spider clan does it...")

/obj/item/book/granter/spell/smoke/lesser //Chaplain smoke book
	spell = /obj/effect/proc_holder/spell/targeted/smoke/lesser

/obj/item/book/granter/spell/smoke/recoil(mob/user)
	..()
	to_chat(user,span_caution("Your stomach rumbles..."))
	if(user.nutrition)
		user.set_nutrition(200)
		if(user.nutrition <= 0)
			user.set_nutrition(0)

/obj/item/book/granter/spell/blind
	spell = /obj/effect/proc_holder/spell/pointed/trigger/blind
	spellname = "blind"
	icon_state = "bookblind"
	desc = "This book looks blurry, no matter how you look at it."
	remarks = list("Well I can't learn anything if I can't read the damn thing!", "Why would you use a dark font on a dark background...", "Ah, I can't see an Oh, I'm fine...", "I can't see my hand...!", "I'm manually blinking, damn you book...", "I can't read this page, but somehow I feel like I learned something from it...", "Hey, who turned off the lights?")

/obj/item/book/granter/spell/blind/recoil(mob/user)
	..()
	to_chat(user,span_warning("You go blind!"))
	user.blind_eyes(10)

/obj/item/book/granter/spell/mindswap
	spell = /obj/effect/proc_holder/spell/targeted/mind_transfer
	spellname = "mindswap"
	icon_state = "bookmindswap"
	desc = "This book's cover is pristine, though its pages look ragged and torn."
	var/mob/stored_swap //Used in used book recoils to store an identity for mindswaps
	remarks = list("If you mindswap from a mouse, they will be helpless when you recover...", "Wait, where am I...?", "This book is giving me a horrible headache...", "This page is blank, but I feel words popping into my head...", "GYNU... GYRO... Ugh...", "The voices in my head need to stop, I'm trying to read here...", "I don't think anyone will be happy when I cast this spell...")

/obj/item/book/granter/spell/mindswap/onlearned()
	spellname = pick("fireball", "smoke", "blind", "forcewall", "knock", "barnyard", "charge")
	icon_state = "book[spellname]"
	name = "spellbook of [spellname]" //Note, desc doesn't change by design
	..()

/obj/item/book/granter/spell/mindswap/recoil(mob/user)
	..()
	if(stored_swap in GLOB.dead_mob_list)
		stored_swap = null
	if(!stored_swap)
		stored_swap = user
		to_chat(user,span_warning("For a moment you feel like you don't even know who you are anymore."))
		return
	if(stored_swap == user)
		to_chat(user,span_notice("You stare at the book some more, but there doesn't seem to be anything else to learn..."))
		return
	var/obj/effect/proc_holder/spell/targeted/mind_transfer/swapper = new
	if(swapper.cast(list(stored_swap), user, TRUE, TRUE))
		to_chat(user,span_warning("You're suddenly somewhere else... and someone else?!"))
		to_chat(stored_swap,span_warning("Suddenly you're staring at [src] again... where are you, who are you?!"))
	else
		user.visible_message(span_warning("[src] fizzles slightly as it stops glowing!")) //if the mind_transfer failed to transfer mobs, likely due to the target being catatonic.

	stored_swap = null

/obj/item/book/granter/spell/forcewall
	spell = /obj/effect/proc_holder/spell/targeted/forcewall
	spellname = "forcewall"
	icon_state = "bookforcewall"
	desc = "This book has a dedication to mimes everywhere inside the front cover."
	remarks = list("I can go through the wall! Neat.", "Why are there so many mime references...?", "This would cause much grief in a hallway...", "This is some surprisingly strong magic to create a wall nobody can pass through...", "Why the dumb stance? It's just a flick of the hand...", "Why are the pages so hard to turn, is this even paper?", "I can't mo Oh, i'm fine...")

/obj/item/book/granter/spell/forcewall/recoil(mob/living/user)
	..()
	to_chat(user,span_warning("You suddenly feel very solid!"))
	user.Stun(40, ignore_canstun = TRUE)
	user.petrify(60)

/obj/item/book/granter/spell/knock
	spell = /obj/effect/proc_holder/spell/aoe_turf/knock
	spellname = "knock"
	icon_state = "bookknock"
	desc = "This book is hard to hold closed properly."
	remarks = list("Open Sesame!", "So THAT'S the magic password!", "Slow down, book. I still haven't finished this page...", "The book won't stop moving!", "I think this is hurting the spine of the book...", "I can't get to the next page, it's stuck t- I'm good, it just turned to the next page on it's own.", "Yeah, staff of doors does the same thing. Go figure...")

/obj/item/book/granter/spell/knock/recoil(mob/living/user)
	..()
	to_chat(user,span_warning("You're knocked down!"))
	user.Paralyze(40)

/obj/item/book/granter/spell/barnyard
	spell = /obj/effect/proc_holder/spell/targeted/barnyardcurse
	spellname = "barnyard"
	icon_state = "bookhorses"
	desc = "This book is more horse than your mind has room for."
	remarks = list("Moooooooo!","Moo!","Moooo!", "NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!", "Oink!", "Squeeeeeeee!", "Oink Oink!", "Ree!!", "Reee!!", "REEE!!", "REEEEE!!")

/obj/item/book/granter/spell/barnyard/recoil(mob/living/carbon/user)
	if(ishuman(user))
		to_chat(user,"<font size='15' color='red'><b>HORSIE HAS RISEN</b></font>")
		var/obj/item/clothing/magichead = new /obj/item/clothing/mask/horsehead/cursed(user.drop_location())
		if(!user.dropItemToGround(user.wear_mask))
			qdel(user.wear_mask)
		user.equip_to_slot_if_possible(magichead, SLOT_WEAR_MASK, TRUE, TRUE)
		qdel(src)
	else
		to_chat(user,span_notice("I say thee neigh")) //It still lives here

/obj/item/book/granter/spell/charge
	spell = /obj/effect/proc_holder/spell/targeted/charge
	spellname = "charge"
	icon_state = "bookcharge"
	desc = "This book is made of 100% postconsumer wizard."
	remarks = list("I feel ALIVE!", "I CAN TASTE THE MANA!", "What a RUSH!", "I'm FLYING through these pages!", "THIS GENIUS IS MAKING IT!", "This book is ACTION PAcKED!", "HE'S DONE IT", "LETS GOOOOOOOOOOOO")

/obj/item/book/granter/spell/charge/recoil(mob/user)
	..()
	to_chat(user,span_warning("[src] suddenly feels very warm!"))
	empulse(src, 1, 1)

/obj/item/book/granter/spell/summonitem
	spell = /obj/effect/proc_holder/spell/targeted/summonitem
	spellname = "instant summons"
	icon_state = "booksummons"
	desc = "This book is bright and garish, very hard to miss."
	remarks = list("I can't look away from the book!", "The words seem to pop around the page...", "I just need to focus on one item...", "Make sure to have a good grip on it when casting...", "Slow down, book. I still haven't finished this page...", "Sounds pretty great with some other magical artifacts...", "Magicians must love this one.")

/obj/item/book/granter/spell/summonitem/recoil(mob/user)
	..()
	to_chat(user,span_warning("[src] suddenly vanishes!"))
	qdel(src)

/obj/item/book/granter/spell/lightningbolt
	spell = /obj/effect/proc_holder/spell/aimed/lightningbolt
	spellname = "lightning bolt"
	desc = "A book that crackles with energy."
	remarks = list("ZAP!", "I feel some tingling in my fingers...", "Swirl your hands to charge...?", "Unlimited... power...? Shocking...", "FEEL THE THUNDER!")

/obj/item/book/granter/spell/lightningbolt/recoil(mob/user)
	..()
	to_chat(user, span_warning("The book twists into lightning and leaps at you!"))
	tesla_zap(user, 8, 20000, TESLA_MOB_DAMAGE) //Will chain at a range of 8, but shouldn't straight up crit
	qdel(src)

/obj/item/book/granter/spell/random
	icon_state = "random_book"

/obj/item/book/granter/spell/random/Initialize()
	. = ..()
	var/static/banned_spells = list(/obj/item/book/granter/spell/mimery_blockade, /obj/item/book/granter/spell/mimery_guns, /obj/item/book/granter/spell/fireball)
	var/real_type = pick(subtypesof(/obj/item/book/granter/spell) - banned_spells)
	new real_type(loc)
	return INITIALIZE_HINT_QDEL

///MARTIAL ARTS///

/obj/item/book/granter/martial
	var/martial
	var/martialname = "bug jitsu"
	var/greet = "You feel like you have mastered the art in breaking code. Nice work, jackass."


/obj/item/book/granter/martial/already_known(mob/user)
	if(!martial)
		return TRUE
	var/datum/martial_art/MA = martial
	if(user.mind.has_martialart(initial(MA.id)))
		to_chat(user,span_warning("You already know [martialname]!"))
		return TRUE
	return FALSE

/obj/item/book/granter/martial/on_reading_start(mob/user)
	to_chat(user, span_notice("You start reading about [martialname]..."))

/obj/item/book/granter/martial/on_reading_finished(mob/user)
	to_chat(user, "[greet]")
	var/datum/martial_art/MA = new martial
	MA.teach(user)
	user.log_message("learned the martial art [martialname] ([MA])", LOG_ATTACK, color="orange")
	onlearned(user)

/obj/item/book/granter/martial/cqc
	martial = /datum/martial_art/cqc
	name = "old manual"
	martialname = "close quarters combat"
	desc = "A small, black manual. There are drawn instructions of tactical hand-to-hand combat."
	greet = span_boldannounce("You've mastered the basics of CQC.")
	icon_state = "cqcmanual"
	remarks = list("Kick... Slam...", "Lock... Kick...", "Strike their abdomen, neck and back for critical damage...", "Slam... Lock...", "I could probably combine this with some other martial arts!", "Words that kill...", "The last and final moment is yours...")

/obj/item/book/granter/martial/cqc/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		to_chat(user, span_warning("[src] beeps ominously..."))

/obj/item/book/granter/martial/cqc/recoil(mob/living/carbon/user)
	to_chat(user, span_warning("[src] explodes!"))
	playsound(src,'sound/effects/explosion1.ogg',40,1)
	user.flash_act(1, 1)
	user.adjustBruteLoss(6)
	user.adjustFireLoss(6)
	qdel(src)

/obj/item/book/granter/martial/carp
	martial = /datum/martial_art/the_sleeping_carp
	name = "mysterious scroll"
	martialname = "sleeping carp"
	desc = "A scroll filled with strange markings. It seems to be drawings of some sort of martial art."
	greet = "<span class='sciradio'>You have learned the ancient martial art of the Sleeping Carp! Your hand-to-hand combat has become much more effective, and you are now able to deflect any projectiles \
	directed toward you. However, you are also unable to use any ranged weaponry. You can learn more about your newfound art by using the Recall Teachings verb in the Sleeping Carp tab.</span>"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll2"
	remarks = list("I must prove myself worthy to the masters of the sleeping carp...", "Stance means everything...", "Focus... And you'll be able to incapacitate any foe in seconds...", "I must pierce armor for maximum damage...", "I don't think this would combine with other martial arts...", "Grab them first so they don't retaliate...", "I must prove myself worthy of this power...")

/obj/item/book/granter/martial/carp/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		desc = "It's completely blank."
		name = "empty scroll"
		icon_state = "blankscroll"

/obj/item/book/granter/martial/flyingfang
	martial = /datum/martial_art/flyingfang
	name = "strange tablet"
	martialname = "Flying Fang"
	desc = "A tablet with strange pictograms that appear to detail some kind of fighting technique."
	force = 10
	greet = "<span class='sciradio'>You have learned the ancient martial art of Flying Fang! Your unarmed attacks have become somewhat more effective,  \
	and you are more resistant to damage and stun-based weaponry. However, you are also unable to use any ranged weaponry or armor. You can learn more about your newfound art by using the Recall Teachings verb in the Flying Fang tab.</span>"
	icon = 'icons/obj/library.dmi'
	icon_state = "stone_tablet"
	remarks = list("Feasting on the insides of your enemies...", "Some of these techniques look a bit dizzying...", "Not like I need armor anyways...", "Don't get shot, whatever that means...")

/obj/item/book/granter/martial/flyingfang/already_known(mob/user)
	if(!islizard(user))
		to_chat(user, span_warning("You can't tell if this is some poorly written fanfiction or an actual guide to something."))
		return TRUE
	return ..()

/obj/item/book/granter/martial/flyingfang/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		desc = "It's completely blank."
		name = "blank tablet"
		icon_state = "stone_tablet_blank"

/obj/item/book/granter/martial/plasma_fist
	martial = /datum/martial_art/plasma_fist
	name = "frayed scroll"
	martialname = "plasma fist"
	desc = "An aged and frayed scrap of paper written in shifting runes. There are hand-drawn illustrations of pugilism."
	greet = "<span class='boldannounce'>You have learned the ancient martial art of Plasma Fist. Your combos are extremely hard to pull off, but include some of the most deadly moves ever seen including \
	the plasma fist, which when pulled off will make someone violently explode.</span>"
	icon = 'icons/obj/wizard.dmi'
	icon_state ="scroll2"
	remarks = list("Balance...", "Power...", "Control...", "Mastery...", "Vigilance...", "Skill...")

/obj/item/book/granter/martial/plasma_fist/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		desc = "It's completely blank."
		name = "empty scroll"

/obj/item/book/granter/martial/preternis_stealth
	martial = /datum/martial_art/stealth
	name = "strange electronic board"
	martialname = "Stealth"
	desc = "A strange electronic board, containing some sort of software."
	greet = "<span class='sciradio'>You have uploaded some combat modules into yourself. Your combos will now have special effects on your enemies, and mostly are not obvious to other people. \
	You can check what combos can you do, and their effect by using Refresh Data verb in Combat Modules tab.</span>"
	icon = 'icons/obj/module.dmi'
	icon_state = "cyborg_upgrade"
	remarks = list("Processing data...")

/obj/item/book/granter/martial/preternis_stealth/already_known(mob/user)
	if(!ispreternis(user))
		to_chat(user, span_warning("You don't understand what to do with this strange electronic device."))
		return TRUE
	return ..()

/obj/item/book/granter/martial/preternis_stealth/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		desc = "It looks like it doesn't contain any data no more."

/obj/item/book/granter/martial/garden_warfare
	martial = /datum/martial_art/gardern_warfare
	name = "mysterious scroll"
	martialname = "Garden Warfare"
	desc = "A scroll, filled with a tone of text. Looks like it says something about combat and... plants?"
	greet = "<span class='sciradio'>You know the martial art of Garden Warfare! Now you control your body better, then other phytosians do, allowing you to extend vines from your body and impale people with splinters. \
	You can check what combos can you do, and their effect by using Remember the basics verb in Garden Warfare tab.</span>"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll2"
	remarks = list("I didn't know that my body grows sprinklers...", "I am able to snatch people with vines? Interesting.", "Wow, strangling people is brutal.")   ///Kill me please for this cringe

/obj/item/book/granter/martial/garden_warfare/already_known(mob/user)
	if(!ispodperson(user))
		to_chat(user, span_warning("You see that this scroll says something about natural abilitites of podpeople, but, unfortunately, you are not one of them."))
		return TRUE
	return ..()

/obj/item/book/granter/martial/garden_warfare/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		desc = "It's completely blank."

/obj/item/book/granter/martial/explosive_fist
	martial = /datum/martial_art/explosive_fist
	name = "burnt scroll"
	martialname = "Explosive Fist"
	desc = "A burnt scroll, that glorifies plasmamen, and also says a lot things of explosions."
	greet = "<span class='sciradio'>You know the martial art of Explosive Fist. Now your attacks deal brute and burn damage, while your combos are able to set people on fire, explode them, or all at once. \
	You can check what combos can you do, and their effect by using Remember the basics verb in Explosive Fist tab.</span>"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll2"
	remarks = list("Set them on fire...", "Show the punny humans who is here the supreme race...", "Make them burn...", "Explosion are cool!")

/obj/item/book/granter/martial/explosive_fist/already_known(mob/user)
	if(!isplasmaman(user))
		to_chat(user, span_warning("It says about very dangerous things, that you would prefer not to know."))
		return TRUE
	return ..()

/obj/item/book/granter/martial/explosive_fist/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		desc = "It's completely blank."

/obj/item/book/granter/martial/ultra_violence
	martial = /datum/martial_art/ultra_violence
	name = "Version one upgrade module"
	martialname = "Ultra Violence"
	desc = "A module full of forbidden techniques from a horrific event long since passed, or perhaps yet to come."
	greet = "<span class='sciradio'>You have installed how to perform Ultra Violence! You are able to redirect electromagnetic pulses, \
	blood heals you, and you CANNOT BE STOPPED. You can mentally practice by using Cyber Grind in the Ultra Violence tab.</span>"
	icon = 'icons/obj/module.dmi'
	icon_state = "cyborg_upgrade"
	remarks = list("MANKIND IS DEAD.", "BLOOD IS FUEL.", "HELL IS FULL.")
	ordered = TRUE

/obj/item/book/granter/martial/ultra_violence/already_known(mob/user)
	if(!isipc(user))
		to_chat(user, span_warning("You don't understand what to do with this strange electronic device."))
		return TRUE
	return ..()

/obj/item/book/granter/martial/ultra_violence/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		desc = "It's a damaged upgrade module."
		name = "damaged board"

// I did not include mushpunch's grant, it is not a book and the item does it just fine.


//Crafting Recipe books

/obj/item/book/granter/crafting_recipe
	var/list/crafting_recipe_types = list()

/obj/item/book/granter/crafting_recipe/on_reading_finished(mob/user)
	. = ..()
	if(!user.mind)
		return
	for(var/crafting_recipe_type in crafting_recipe_types)
		var/datum/crafting_recipe/R = crafting_recipe_type
		user.mind.teach_crafting_recipe(crafting_recipe_type)
		to_chat(user,span_notice("You learned how to make [initial(R.name)]."))

/obj/item/book/granter/crafting_recipe/weapons
	name = "makeshift weapons 101"
	desc = "A book filled with directions on how to make various weaponry."
	crafting_recipe_types = list(/datum/crafting_recipe/metal_baseball_bat, /datum/crafting_recipe/lance, /datum/crafting_recipe/knifeboxing, /datum/crafting_recipe/pipebomb, /datum/crafting_recipe/makeshiftpistol, /datum/crafting_recipe/makeshiftmagazine, /datum/crafting_recipe/makeshiftsuppressor, /datum/crafting_recipe/makeshiftcrowbar, /datum/crafting_recipe/makeshiftwrench, /datum/crafting_recipe/makeshiftwirecutters, /datum/crafting_recipe/makeshiftweldingtool, /datum/crafting_recipe/makeshiftmultitool, /datum/crafting_recipe/makeshiftscrewdriver, /datum/crafting_recipe/makeshiftknife, /datum/crafting_recipe/makeshiftpickaxe, /datum/crafting_recipe/makeshiftradio, /datum/crafting_recipe/bola_arrow, /datum/crafting_recipe/flaming_arrow, /datum/crafting_recipe/makeshiftemag)
	icon_state = "bookCrafting"
	oneuse = TRUE

/obj/item/book/granter/crafting_recipe/roburgers
	name = "roburger crafting recipe"
	desc = "A book containing knowledge how to make roburgers."
	crafting_recipe_types = list(/datum/crafting_recipe/food/roburger)
	icon_state = "bookCrafting"
	oneuse = FALSE

// For testing
/obj/item/book/granter/crafting_recipe/ashwalker
	name = "sandstone slab"
	desc = "A book filled with directions on how to make various tribal clothes and weapons."
	icon_state = "stone_tablet"
	crafting_recipe_types = list(/datum/crafting_recipe/bola_arrow,
								/datum/crafting_recipe/flaming_arrow,
								/datum/crafting_recipe/raider_leather,
								/datum/crafting_recipe/tribal_wraps,
								/datum/crafting_recipe/ash_robe,
								/datum/crafting_recipe/ash_robe/young,
								/datum/crafting_recipe/ash_robe/hunter,
								/datum/crafting_recipe/ash_robe/chief,
								/datum/crafting_recipe/ash_robe/shaman,
								/datum/crafting_recipe/ash_robe/tunic,
								/datum/crafting_recipe/ash_robe/dress,
								/datum/crafting_recipe/shamanash,
								/datum/crafting_recipe/tribalmantle,
								/datum/crafting_recipe/leathercape,
								/datum/crafting_recipe/hidemantle)

//for upstart mech pilots to move faster
/obj/item/book/granter/mechpiloting
	name = "Mech Piloting for Dummies"
	desc = "A step-by-step guide on how to effectively pilot a mech, written in such a way that even a clown could understand."
	remarks = list("Hmm, press forward to go forwards...", "Avoid getting hit to reduce damage...", "Welding to repair..?", "Make sure to turn it on...", "EMP bad...", "I need to turn internals on?", "What's a gun ham?")

/obj/item/book/granter/mechpiloting/on_reading_finished(mob/user)
	. = ..()
	user.AddComponent(/datum/component/mech_pilot, 0.8)
	onlearned(user)

/obj/item/book/granter/martial/psychotic_brawling
	martial = /datum/martial_art/psychotic_brawling
	name = "blood-stained paper"
	martialname = "psychotic brawling"
	desc = "A piece of blood-stained paper that emanates pure rage. Just holding it makes you want to punch someone."
	greet = "<span class='boldannounce'>You have learned the tried and true art of Psychotic Brawling. \
			You will be unable to disarm or grab, but your punches have a chance to do serious damage.</span>"
	icon = 'yogstation/icons/obj/bureaucracy.dmi'
	icon_state = "paper_talisman"
	remarks = list("Just keep punching...", "Let go of your inhibitions...", "Methamphetamine...", "Embrace Space Florida...", "Become too angry to die...")

/obj/item/book/granter/martial/psychotic_brawling/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		to_chat(user, span_notice("All of the blood on the paper seems to have vanished."))
		user.dropItemToGround(src)
		qdel(src)
		user.put_in_hands(new /obj/item/paper)
