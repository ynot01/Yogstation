// the SMES
// stores power

//Cache defines
#define SMES_OUTPUTTING		7
#define SMES_NOT_OUTPUTTING 8
#define SMES_INPUTTING		9
#define SMES_INPUT_ATTEMPT	10

/obj/machinery/power/smes
	name = "power storage unit"
	desc = "A high-capacity superconducting magnetic energy storage (SMES) unit."
	icon_state = "smes"
	density = TRUE
	use_power = NO_POWER_USE
	circuit = /obj/item/circuitboard/machine/smes

	/// Maximum charge of the SMES
	var/capacity = 5e8
	/// Current charge of the SMES
	var/charge = 0
	/// TRUE = attempting to charge, FALSE = not attempting to charge
	var/input_attempt = TRUE
	/// TRUE = actually inputting, FALSE = not inputting
	var/inputting = TRUE
	/// Desired Power Input Level
	var/input_level = 50000
	/// Maximum Power Input
	var/input_level_max = 200000
	/// Last power input
	var/input_available = 0
	/// TRUE = attempting to output, FALSE = not attempting to output
	var/output_attempt = TRUE
	/// TRUE = actually outputting, FALSE = not outputting
	var/outputting = TRUE
	/// Desired Power Output Level
	var/output_level = 50000
	/// Maximum Power Output
	var/output_level_max = 200000
	/// Last power output
	var/output_used = 0 // amount of power actually outputted. may be less than output_level if the powernet returns excess power

	var/obj/machinery/power/terminal/terminal = null

/obj/machinery/power/smes/examine(user)
	. = ..()
	if(!terminal)
		. += span_warning("This SMES has no power terminal!")

/obj/machinery/power/smes/Initialize(mapload)
	. = ..()
	dir_loop:
		for(var/d in GLOB.cardinals)
			var/turf/T = get_step(src, d)
			for(var/obj/machinery/power/terminal/term in T)
				if(term && term.dir == turn(d, 180))
					terminal = term
					break dir_loop

	if(!terminal)
		obj_break()
		return
	terminal.master = src
	update_icon()

/obj/machinery/power/smes/RefreshParts()
	var/IO = 0
	var/MC = 0
	var/C
	for(var/obj/item/stock_parts/capacitor/CP in component_parts)
		IO += CP.rating
	input_level_max = initial(input_level_max) * IO
	output_level_max = initial(output_level_max) * IO
	for(var/obj/item/stock_parts/cell/PC in component_parts)
		MC += PC.maxcharge
		C += PC.charge
	capacity = MC / (15000) * 2e7
	if(!initial(charge) && !charge)
		charge = C / 15000 * 2e7

/obj/machinery/power/smes/attackby(obj/item/I, mob/user, params)
	//opening using screwdriver
	if(default_deconstruction_screwdriver(user, "[initial(icon_state)]-o", initial(icon_state), I))
		update_icon()
		return

	//changing direction using wrench
	if(default_change_direction_wrench(user, I))
		terminal = null
		var/turf/T = get_step(src, dir)
		for(var/obj/machinery/power/terminal/term in T)
			if(term && term.dir == turn(dir, 180))
				terminal = term
				terminal.master = src
				to_chat(user, span_notice("Terminal found."))
				break
		if(!terminal)
			to_chat(user, span_alert("No power terminal found."))
			return
		stat &= ~BROKEN
		update_icon()
		return

	//building and linking a terminal
	if(istype(I, /obj/item/stack/cable_coil))
		var/dir = get_dir(user,src)
		if(dir & (dir-1))//we don't want diagonal click
			return

		if(terminal) //is there already a terminal ?
			to_chat(user, span_warning("This SMES already has a power terminal!"))
			return

		if(!panel_open) //is the panel open ?
			to_chat(user, span_warning("You must open the maintenance panel first!"))
			return

		var/turf/T = get_turf(user)
		if (T.intact) //is the floor plating removed ?
			to_chat(user, span_warning("You must first remove the floor plating!"))
			return


		var/obj/item/stack/cable_coil/C = I
		if(C.get_amount() < 10)
			to_chat(user, span_warning("You need more wires!"))
			return

		to_chat(user, span_notice("You start building the power terminal..."))
		playsound(src.loc, 'sound/items/deconstruct.ogg', 50, 1)

		if(do_after(user, 2 SECONDS, src))
			if(C.get_amount() < 10 || !C)
				return
			var/obj/structure/cable/N = T.get_cable_node() //get the connecting node cable, if there's one
			if (prob(50) && electrocute_mob(usr, N, N, 1, TRUE)) //animate the electrocution if uncautious and unlucky
				do_sparks(5, TRUE, src)
				return
			if(!terminal)
				C.use(10)
				user.visible_message(\
					"[user.name] has built a power terminal.",\
					span_notice("You build the power terminal."))

				//build the terminal and link it to the network
				make_terminal(T)
				terminal.connect_to_network()
				connect_to_network()
		return

	//crowbarring it !
	var/turf/T = get_turf(src)
	if(default_deconstruction_crowbar(I))
		message_admins("[src] has been deconstructed by [ADMIN_LOOKUPFLW(user)] in [ADMIN_VERBOSEJMP(T)]")
		log_game("[src] has been deconstructed by [key_name(user)] at [AREACOORD(src)]")
		investigate_log("SMES deconstructed by [key_name(user)] at [AREACOORD(src)]", INVESTIGATE_SINGULO)
		investigate_log("SMES deconstructed by [key_name(user)] at [AREACOORD(src)]", INVESTIGATE_SUPERMATTER) // yogs - so supermatter investigate is useful
		return
	else if(panel_open && I.tool_behaviour == TOOL_CROWBAR)
		return

	return ..()

/obj/machinery/power/smes/wirecutter_act(mob/living/user, obj/item/I)
	//disassembling the terminal
	if(terminal && panel_open)
		terminal.dismantle(user, I)
		return TRUE


/obj/machinery/power/smes/default_deconstruction_crowbar(obj/item/crowbar/C)
	if(istype(C) && terminal)
		to_chat(usr, span_warning("You must first remove the power terminal!"))
		return FALSE

	return ..()

/obj/machinery/power/smes/on_deconstruction()
	for(var/obj/item/stock_parts/cell/cell in component_parts)
		cell.charge = (charge / capacity) * cell.maxcharge

/obj/machinery/power/smes/Destroy()
	if(SSticker.IsRoundInProgress())
		var/turf/T = get_turf(src)
		message_admins("SMES deleted at [ADMIN_VERBOSEJMP(T)]")
		log_game("SMES deleted at [AREACOORD(T)]")
		investigate_log("<font color='red'>deleted</font> at [AREACOORD(T)]", INVESTIGATE_SINGULO)
		investigate_log("<font color='red'>deleted</font> at [AREACOORD(T)]", INVESTIGATE_SUPERMATTER) // yogs - so supermatter investigate is useful
	if(terminal)
		disconnect_terminal()
	return ..()

// create a terminal object pointing towards the SMES
// wires will attach to this
/obj/machinery/power/smes/proc/make_terminal(turf/T)
	terminal = new/obj/machinery/power/terminal(T)
	terminal.setDir(get_dir(T,src))
	terminal.master = src
	stat &= ~BROKEN

/obj/machinery/power/smes/disconnect_terminal()
	if(terminal)
		terminal.master = null
		terminal = null
		obj_break()


/obj/machinery/power/smes/update_icon()
	cut_overlays()
	if(stat & BROKEN)
		return

	if(panel_open)
		return

	if(outputting)
		add_overlay("smes-out1")
	else
		add_overlay("smes-out0")

	if(inputting)
		add_overlay("smes-inp1")
	else
		if(input_attempt)
			add_overlay("smes-inp0")

	var/clevel = chargedisplay()
	if(clevel>0)
		add_overlay("smes-og[clevel]")


/obj/machinery/power/smes/proc/chargedisplay()
	return clamp(round(6.5*charge/capacity),0,6)

/obj/machinery/power/smes/process()
	if(stat & BROKEN)
		return

	//store machine state to see if we need to update the icon overlays
	var/last_disp = chargedisplay()
	var/last_chrg = inputting
	var/last_onln = outputting

	//inputting
	if(terminal && input_attempt)
		input_available = terminal.surplus()

		if(inputting)
			if(input_available > 0)		// if there's power available, try to charge

				var/load = min(min((capacity-charge), input_level), input_available)		// charge at set rate, limited to spare capacity

				charge += load	// increase the charge

				terminal.add_load(load) // add the load to the terminal side network

			else					// if not enough capcity
				inputting = FALSE		// stop inputting

		else
			if(input_attempt && input_available > 0)
				inputting = TRUE
	else
		inputting = FALSE

	//outputting
	if(output_attempt)
		if(outputting)
			output_used = min( charge, output_level)		//limit output to that stored

			if (add_avail(output_used))				// add output to powernet if it exists (smes side)
				charge -= output_used		// reduce the storage (may be recovered in /restore() if excessive)
			else
				outputting = FALSE

			if(output_used < 0.0001)		// either from no charge or set to 0
				outputting = FALSE
				investigate_log("SMES lost power and turned <font color='red'>off</font>", INVESTIGATE_SINGULO)
				investigate_log("SMES lost power and turned <font color='red'>off</font>", INVESTIGATE_SUPERMATTER) // yogs - so supermatter investigate is useful
		else if(output_attempt && charge > output_level && output_level > 0)
			outputting = TRUE
		else
			output_used = 0
	else
		outputting = FALSE

	// only update icon if state changed
	if(last_disp != chargedisplay() || last_chrg != inputting || last_onln != outputting)
		update_icon()



// called after all power processes are finished
// restores charge level to smes if there was excess this ptick
/obj/machinery/power/smes/proc/restore()
	if(stat & BROKEN)
		return

	if(!outputting)
		output_used = 0
		return

	var/excess = powernet.netexcess		// this was how much wasn't used on the network last ptick, minus any removed by other SMESes

	excess = min(output_used, excess)				// clamp it to how much was actually output by this SMES last ptick

	excess = min((capacity-charge), excess)	// for safety, also limit recharge by space capacity of SMES (shouldn't happen)

	// now recharge this amount

	var/clev = chargedisplay()

	charge += excess			// restore unused power
	powernet.netexcess -= excess		// remove the excess from the powernet, so later SMESes don't try to use it

	output_used -= excess

	if(clev != chargedisplay() ) //if needed updates the icons overlay
		update_icon()
	return


/obj/machinery/power/smes/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Smes", name)
		ui.open()

/obj/machinery/power/smes/ui_data()
	var/list/data = list(
		"capacity" = capacity,
		"capacityPercent" = round(100*charge/capacity, 0.1),
		"charge" = charge,
		"inputAttempt" = input_attempt,
		"inputting" = inputting,
		"inputLevel" = input_level,
		"inputLevel_text" = DisplayPower(input_level),
		"inputLevelMax" = input_level_max,
		"inputAvailable" = input_available,
		"outputAttempt" = output_attempt,
		"outputting" = outputting,
		"outputLevel" = output_level,
		"outputLevel_text" = DisplayPower(output_level),
		"outputLevelMax" = output_level_max,
		"outputUsed" = output_used,
	)
	return data

/obj/machinery/power/smes/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("tryinput")
			input_attempt = !input_attempt
			log_smes(usr)
			update_icon()
			. = TRUE
		if("tryoutput")
			output_attempt = !output_attempt
			log_smes(usr)
			update_icon()
			. = TRUE
		if("input")
			var/target = params["target"]
			var/adjust = text2num(params["adjust"])
			if(target == "input")
				target = input("New input target (0-[input_level_max]):", name, input_level) as num|null
				if(!isnull(target) && !..())
					. = TRUE
			else if(target == "min")
				target = 0
				. = TRUE
			else if(target == "max")
				target = input_level_max
				. = TRUE
			else if(adjust)
				target = input_level + adjust
				. = TRUE
			else if(text2num(target) != null)
				target = text2num(target)
				. = TRUE
			if(.)
				input_level = clamp(target, 0, input_level_max)
				log_smes(usr)
		if("output")
			var/target = params["target"]
			var/adjust = text2num(params["adjust"])
			if(target == "input")
				target = input("New output target (0-[output_level_max]):", name, output_level) as num|null
				if(!isnull(target) && !..())
					. = TRUE
			else if(target == "min")
				target = 0
				. = TRUE
			else if(target == "max")
				target = output_level_max
				. = TRUE
			else if(adjust)
				target = output_level + adjust
				. = TRUE
			else if(text2num(target) != null)
				target = text2num(target)
				. = TRUE
			if(.)
				output_level = clamp(target, 0, output_level_max)
				log_smes(usr)

/obj/machinery/power/smes/proc/log_smes(mob/user)
	investigate_log("input/output; [input_level>output_level?"<font color='green'>":"<font color='red'>"][input_level]/[output_level]</font> | Charge: [charge] | Output-mode: [output_attempt?"<font color='green'>on</font>":"<font color='red'>off</font>"] | Input-mode: [input_attempt?"<font color='green'>auto</font>":"<font color='red'>off</font>"] by [user ? key_name(user) : "outside forces"]", INVESTIGATE_SINGULO)
	investigate_log("input/output; [input_level>output_level?"<font color='green'>":"<font color='red'>"][input_level]/[output_level]</font> | Charge: [charge] | Output-mode: [output_attempt?"<font color='green'>on</font>":"<font color='red'>off</font>"] | Input-mode: [input_attempt?"<font color='green'>auto</font>":"<font color='red'>off</font>"] by [user ? key_name(user) : "outside forces"]", INVESTIGATE_SUPERMATTER) // yogs - so supermatter investigate is useful

/obj/machinery/power/smes/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	input_attempt = rand(0,1)
	inputting = input_attempt
	output_attempt = rand(0,1)
	outputting = output_attempt
	output_level = rand(0, output_level_max)
	input_level = rand(0, input_level_max)
	charge = max(charge - 1e6/severity, 0)
	update_icon()
	log_smes()

/obj/machinery/power/smes/engineering
	charge = 5e7 // Engineering starts with some charge for singulo

/obj/machinery/power/smes/fullycharged
	charge = 5e8 // A fully charged SMES

/obj/machinery/power/smes/empty
	charge = 0

/obj/machinery/power/smes/magical
	name = "magical power storage unit"
	desc = "A high-capacity superconducting magical energy storage (SMES) unit. Magically produces power."

/obj/machinery/power/smes/magical/process()
	capacity = INFINITY
	charge = INFINITY
	..()

/obj/machinery/power/smes/CtrlClick(mob/user)
	if(!user.canUseTopic(src, !issilicon(user)))
		return
	output_attempt = !output_attempt
	log_smes(user)
	update_icon()

#undef SMES_OUTPUTTING
#undef SMES_NOT_OUTPUTTING
#undef SMES_INPUTTING
#undef SMES_INPUT_ATTEMPT
