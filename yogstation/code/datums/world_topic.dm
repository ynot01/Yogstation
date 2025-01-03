GLOBAL_VAR_INIT(mentornoot, FALSE)

/datum/world_topic/asay
	keyword = "asay"
	require_comms_key = TRUE

/datum/world_topic/asay/Run(list/input)
	to_chat(GLOB.permissions.admins, span_adminsay("[span_prefix("DISCORD:")] <EM>[input["admin"]]</EM>: [span_message("[input["asay"]]")]"), confidential=TRUE)

/datum/world_topic/ooc
	keyword = "ooc"
	require_comms_key = TRUE

/datum/world_topic/ooc/Run(list/input)
	if(!GLOB.ooc_allowed)
		return
	input["ooc"] = pretty_filter(input["ooc"])
	for(var/client/C in GLOB.clients)
		to_chat(C, "<font color='[GLOB.normal_ooc_colour]'><span class='ooc'>[span_prefix("DISCORD OOC:")] <EM>[input["admin"]]:</EM> [span_message("[input["ooc"]]")]</span></font>")

/datum/world_topic/toggleooc
	keyword = "toggleooc"
	require_comms_key = TRUE

/datum/world_topic/toggleooc/Run(list/input)
	toggle_ooc()
	return GLOB.ooc_allowed

/datum/world_topic/adminwho/Run(list/input)
	var/list/message = list("Admins: ")
	var/list/admin_keys = list()
	for(var/adm in GLOB.permissions.admins)
		var/client/C = adm
		if(isnull(C)) //Yog we're having issues with null holders breaking adminwho, so let's skip nulls
			continue
		if(input["adminchannel"])
			admin_keys += "[C][C.holder.fakekey ? "(Stealth)" : ""][C.is_afk() ? "(AFK)" : ""]"
		else if(!C.holder.fakekey)
			admin_keys += "[C]"

	for(var/admin in admin_keys)
		if(LAZYLEN(message) > 1)
			message += ", [admin]"
		else
			message += "[admin]"

	return jointext(message, "")

/datum/world_topic/pr_announce/Run(list/input)
	var/msgTitle = input["announce"]
	var/author = input["author"]
	var/id = input["id"]
	var/link = "https://github.com/yogstation13/Yogstation/pull/[id]"

	var/final_composed = span_announce("PR: <a href=[link]>[msgTitle]</a> by [author]")
	for(var/client/C in GLOB.clients)
		C.AnnouncePR(final_composed)

/datum/world_topic/reboot
	keyword = "reboot"
	require_comms_key = TRUE

/datum/world_topic/reboot/Run(list/input)
	SSticker.Reboot("Initiated from discord")

/datum/world_topic/msay
	keyword = "msay"
	require_comms_key = TRUE

/datum/world_topic/msay/Run(list/input)
	to_chat(GLOB.permissions.admins | GLOB.mentors, "<b><font color ='#8A2BE2'>[span_prefix("DISCORD MENTOR:")]</span> <EM>[input["admin"]]</EM>: [span_message("[input["msay"]]")]</span>", confidential = TRUE)

/datum/world_topic/mhelp
	keyword = "mhelp"
	require_comms_key = TRUE

/datum/world_topic/mhelp/Run(list/input)
	var/whom = input["whom"]
	var/msg = input["msg"]
	var/from = input["admin"]
	var/from_id = input["admin_id"]
	var/client/C = GLOB.directory[ckey(whom)]
	if(!C)
		return 0
	if((C.prefs.toggles & SOUND_ALT) && (GLOB.mentornoot || prob(1)))
		SEND_SOUND(C, sound('sound/misc/nootnoot.ogg'))
	else
		SEND_SOUND(C, sound('sound/items/bikehorn.ogg'))
	var/datum/DBQuery/add_mhelp_query = SSdbcore.NewQuery(
		"INSERT INTO `[format_table_name("mentor_interactions")]` (round_id, ckey, ckey_mentor, target_ckey, target_mentor, message) VALUES (:round, :send, :smentor, :receive, :rmentor, :msg);",
		list("round" = GLOB.round_id, "send" = from, "smentor" = TRUE, "receive" = C.ckey, "rmentor" = C.is_mentor(), "msg" = msg)
	)
	if(!add_mhelp_query.Execute())
		message_admins("Failed insert mhelp into mhelp DB. Check the SQL error logs for more details.")
	qdel(add_mhelp_query)
	if(C.ckey in SSYogs.mentortickets)
		var/datum/mentorticket/T = SSYogs.mentortickets[C.ckey]
		T.log += "<b>[from]:</b> [msg]"
	to_chat(C, "<font color='purple'>Mentor PM from-<b>[discord_mentor_link(from, from_id)]</b>: [msg]</font>", confidential = TRUE)
	var/show_char_recip = !C.is_mentor() && CONFIG_GET(flag/mentors_mobname_only)
	for(var/client/X in GLOB.mentors | GLOB.permissions.admins)
		if(X != C)
			to_chat(X, "<B><font color='green'>Mentor PM: [discord_mentor_link(from, from_id)]-&gt;[key_name_mentor(C, X, 0, 0, show_char_recip)]:</B> <font color ='cyan'> [msg]</font>", confidential = TRUE)
	return 1

/datum/world_topic/unlink
	keyword = "unlink"
	require_comms_key = TRUE

/datum/world_topic/unlink/Run(list/input)
	var/ckey = input["unlink"]
	var/returned_id = SSdiscord.lookup_id(ckey)
	if(returned_id)
		SSdiscord.unlink_account(ckey)
		return "[ckey] has been unlinked!"
	else
		return "Account not unlinked! Please contact a coder."
