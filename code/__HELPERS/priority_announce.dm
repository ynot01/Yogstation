#define RANDOM_REPORT_SOUND "random_report_sound"

/proc/priority_announce(text, title = "", sound, type, sender_override, has_important_message, sanitize = TRUE)
	if(!text)
		return

	var/announcement
	var/default_sound


	if(!sound)
		sound = SSstation.announcer.get_rand_alert_sound()
		default_sound = SSstation.default_announcer.get_rand_alert_sound()
	else if(SSstation.announcer.event_sounds[sound])
		sound = SSstation.announcer.event_sounds[sound]

	if(SSstation.default_announcer.event_sounds[sound])
		default_sound = SSstation.default_announcer.event_sounds[sound]


	if(sound == RANDOM_REPORT_SOUND)
		sound = SSstation.announcer.get_rand_report_sound()
		default_sound = SSstation.default_announcer.get_rand_report_sound()


	if(type == "Priority")
		announcement += "<h1 class='alert'>Priority Announcement</h1>"
		if (title && length(title) > 0)
			announcement += "<br><h2 class='alert'>[sanitize ? html_encode(title) : title]</h2>"
	else if(type == "Captain")
		announcement += "<h1 class='alert'>Captain Announces</h1>"
		GLOB.news_network.SubmitArticle(text, "Captain's Announcement", "Station Announcements", null)

	else
		if(!sender_override)
			announcement += "<h1 class='alert'>[command_name()] Update</h1>"
		else
			announcement += "<h1 class='alert'>[sender_override]</h1>"
		if (title && length(title) > 0)
			announcement += "<br><h2 class='alert'>[sanitize ? html_encode(title) : title]</h2>"

		if(!sender_override)
			if(title == "")
				GLOB.news_network.SubmitArticle(text, "Central Command Update", "Station Announcements", null)
			else
				GLOB.news_network.SubmitArticle(title + "<br><br>" + text, "Central Command", "Station Announcements", null)

	///If the announcer overrides alert messages, use that message.
	if(SSstation.announcer.custom_alert_message && !has_important_message)
		announcement +=  SSstation.announcer.custom_alert_message
	else
		announcement += "<br>[span_alert("[sanitize ? html_encode(text) : text]")]<br>"
	announcement += "<br>"

	var/s = sound(sound)
	var/default_s = s
	if(!istype(SSstation.announcer, /datum/centcom_announcer/default))
		default_s = sound(default_sound)
	for(var/mob/M in GLOB.player_list)
		if(!isnewplayer(M) && M.can_hear())
			if(isliving(M) && M.stat != DEAD)
				var/mob/living/L = M
				if(!L.IsUnconscious())
					to_chat(L, announcement)
			else
				to_chat(M, announcement)
			if(M.client.prefs.toggles & SOUND_ANNOUNCEMENTS)
				if(M.client.prefs.read_preference(/datum/preference/toggle/disable_alternative_announcers))
					SEND_SOUND(M, default_s)
				else
					SEND_SOUND(M, s)

/proc/print_command_report(text = "", title = null, announce=TRUE)
	if(!title)
		title = "Classified [command_name()] Update"

	if(announce)
		priority_announce("A report has been downloaded and printed out at all communications consoles.", "Incoming Classified Message", RANDOM_REPORT_SOUND, has_important_message = TRUE)

	var/datum/comm_message/M  = new
	M.title = title
	M.content =  text

	SScommunications.send_message(M)

/proc/minor_announce(message, title = "Attention:", alert, custom_alert_sound)
	if(!message)
		return

	for(var/mob/M in GLOB.player_list)
		if(!isnewplayer(M) && M.can_hear())
			if(isliving(M) && M.stat != DEAD)
				var/mob/living/L = M
				if(!L.IsUnconscious())
					to_chat(L, "<span class='big bold'><font color = red>[html_encode(title)]</font color><BR>[html_encode(message)]</span><BR>")
			else
				to_chat(M, "<span class='big bold'><font color = red>[html_encode(title)]</font color><BR>[html_encode(message)]</span><BR>")
			if(M.client.prefs.toggles & SOUND_ANNOUNCEMENTS)
				var/s = sound(custom_alert_sound)
				if(custom_alert_sound)
					SEND_SOUND(M, s)
				else
					if(alert)
						SEND_SOUND(M, sound('sound/misc/notice1.ogg'))
					else
						SEND_SOUND(M, sound('sound/misc/notice2.ogg'))
