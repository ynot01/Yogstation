/datum/admins/proc/checkMentorEditList(ckey)
	var/datum/DBQuery/query_memoedits = SSdbcore.NewQuery("SELECT edits FROM [format_table_name("mentor_memo")] WHERE (ckey = :key)", list("key" = ckey))
	if(!query_memoedits.warn_execute())
		qdel(query_memoedits)
		return

	if(query_memoedits.NextRow())
		var/edit_log = "<HTML><HEAD><meta charset='UTF-8'></HEAD><BODY>" + query_memoedits.item[1] + "</BODY></HTML>"
		usr << browse(edit_log,"window=mentormemoeditlist")
	qdel(query_memoedits)

/datum/admins/proc/makeMentor(ckey, position)
	if(!usr.client)
		return

	if (!check_rights(R_EVERYTHING))
		return

	if(!ckey)
		return

	var/client/C = GLOB.directory[ckey]
	if(C)
		if(check_rights_for(C, R_ADMIN,0))
			to_chat(usr, span_danger("The client chosen is an admin! Cannot mentorize."), confidential=TRUE)
			return

		new /datum/mentors(ckey, position)

	if(SSdbcore.Connect())
		var/datum/DBQuery/query_get_mentor = SSdbcore.NewQuery("SELECT id FROM `[format_table_name("mentor")]` WHERE `ckey` = :ckey", list("ckey" = ckey))
		query_get_mentor.warn_execute()
		if(query_get_mentor.NextRow())
			to_chat(usr, span_danger("[ckey] is already a mentor."), confidential=TRUE)
			qdel(query_get_mentor)
			return
		qdel(query_get_mentor)

		var/datum/DBQuery/query_add_mentor = SSdbcore.NewQuery("INSERT INTO `[format_table_name("mentor")]` (`id`, `ckey`, `position`) VALUES (null, :ckey, :position)", list("ckey" = ckey, "position" = position))
		if(!query_add_mentor.warn_execute())
			qdel(query_add_mentor)
			return
		qdel(query_add_mentor)

		var/datum/DBQuery/query_add_mentor_log = SSdbcore.NewQuery({"
			INSERT INTO [format_table_name("admin_log")] (datetime, round_id, adminckey, adminip, operation, target, log)
			VALUES (:time, :round_id, :adminckey, INET_ATON(:adminip), 'add mentor', :target, CONCAT('New mentor added: ', :target))
		"}, list("time" = SQLtime(), "round_id" = "[GLOB.round_id]", "adminckey" = usr.ckey, "adminip" = usr.client.address, "target" = ckey))
		if(!query_add_mentor_log.warn_execute())
			qdel(query_add_mentor_log)
			return
		qdel(query_add_mentor_log)

		webhook_send_mchange(owner.ckey, C.ckey, "add")

	else
		to_chat(usr, span_danger("Failed to establish database connection. The changes will last only for the current round."), confidential=TRUE)

	message_admins("[key_name_admin(usr)] added new [position]: [ckey]")
	log_admin("[key_name(usr)] added new [position]: [ckey]")

/datum/admins/proc/removeMentor(ckey)
	if(!usr.client)
		return

	if (!check_rights(R_EVERYTHING))
		return

	if(!ckey)
		return

	var/client/C = GLOB.directory[ckey]
	if(C)
		if(check_rights_for(C, R_ADMIN,0))
			to_chat(usr, span_danger("The client chosen is an admin, not a mentor! Cannot de-mentorize."), confidential=TRUE)
			return

		C.remove_mentor_verbs()
		QDEL_NULL(C.mentor_datum)
		GLOB.mentors -= C

	if(SSdbcore.Connect())
		var/datum/DBQuery/query_remove_mentor = SSdbcore.NewQuery("DELETE FROM `[format_table_name("mentor")]` WHERE `ckey` = :ckey", list("ckey" = ckey))
		query_remove_mentor.warn_execute()
		qdel(query_remove_mentor)

		webhook_send_mchange(owner.ckey, C.ckey, "remove")

	else
		to_chat(usr, span_danger("Failed to establish database connection. The changes will last only for the current round."), confidential=TRUE)

	message_admins("[key_name_admin(usr)] removed mentor: [ckey]")
	log_admin("[key_name(usr)] removed mentor: [ckey]")
