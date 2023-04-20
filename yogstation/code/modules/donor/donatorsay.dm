/client/proc/cmd_donator_say(msg as text)
	set category = "Donator"
	set name = "Donator Chat"

	if(!is_donator(usr))
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	msg = pretty_filter(msg)
	msg = emoji_parse(msg)
	mob.log_talk(msg, LOG_DONATOR, "Donator")

	msg = "<b><font color ='#2e87a1'><span class='prefix donator'>DONATOR CHAT:</span> <EM>[key_name(src, 0, 0)]</EM>: <span class='message donator'>[msg]</span></font></b>"

	for(var/client/C in GLOB.clients)
		if(is_donator(C))
			to_chat(C, msg, confidential=TRUE, type=MESSAGE_TYPE_DONATOR)
	return

/client/verb/get_donator_say()
	set hidden = TRUE
	set name = ".donorsay"

	var/message = input(src, null, "Donator Chat \"text\"") as text|null
	if (message)
		cmd_donator_say(message)
