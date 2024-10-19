/datum/controller/subsystem/ticker
	var/selected_lobby_music

/datum/controller/subsystem/ticker/proc/choose_lobby_music()
	//Add/remove songs from this list individually, rather than multiple at once. This makes it easier to judge PRs that change the list, since PRs that change it up heavily are less likely to meet broad support
	//Add a comment after the song link in the format [Artist - Name]
	var/list/songs = list(
		"https://www.youtube.com/watch?v=jA4u5Pur5KA",						// Jim Carrey - Cuban Pete
		"https://www.youtube.com/watch?v=lIrum6iFz6U", 						// Electric Light Orchestra - Mr. Blue Sky
		"https://www.youtube.com/watch?v=Ae2N5310MXE",						// SolusLunes - Endless Space
		"https://www.youtube.com/watch?v=UPHmazxB38g", 						// MashedByMachines - Sector11
		"https://soundcloud.com/jeffimam/title-plasma-attack",				// Jeff Imam - Title - Plasma Attack
		"https://www.youtube.com/watch?v=KaOC9danxNo", 						// David Bowie - Space Oddity (Cover by Chris Hadfield)
		"https://www.youtube.com/watch?v=UaD4AiqYDyA", 						// X-CEED - Flip-Flap
		"https://www.youtube.com/watch?v=a90kqxX3jPg",						// Monster860 - Orion Trail
		"https://www.youtube.com/watch?v=zKxwED8-Hws",						// Monster860 - Journey to Cygni
		"https://www.youtube.com/watch?v=icy4-CQHVh4", 						// Joseph "Zhaytee" Toscano - Absconditus
		"https://www.youtube.com/watch?v=dCPWE4WexM8", 						// Hiroaki Yoshida, Hitomi Komatsu - Robocop Theme (Remix by Cboyardee)
		"https://www.youtube.com/watch?v=3W7mwRpUbqQ", 						// Stellardrone - Comet Haley
		"https://www.youtube.com/watch?v=BY-1SrsLER0", 						// Jeroen Tel - Tintin on the Moon  (Noisemaker's Remix)
		"https://www.youtube.com/watch?v=YKVmXn-Gv0M", 						// Jeroen Tel - Tintin on the Moon (Remix by Cuboos)
		"https://www.youtube.com/watch?v=GISnTECX8Eg",						// Chris Remo - Space Asshole
		"https://www.youtube.com/watch?v=le1eD6I7k4s",						// Ronald Jenkee - Piano Wire
		"https://www.youtube.com/watch?v=r-eMVfiT8_c",						// Kelly Bailey - Nuclear Missile Jam/Something Secret Steers Us (Remix)
		"https://www.youtube.com/watch?v=WcWix770cvQ",						// Wintergatan - Local Cluster
		"https://www.youtube.com/watch?v=w5hBQDepXOE",						// Michael Giacchino - Main Theme (STAR TREK Beyond)
		"https://www.youtube.com/watch?v=9whQIbNmu9s",						// Admiral Hippie - Clown.wmv
		"https://www.youtube.com/watch?v=67BwWgrMlxk",						// Chris Christodoulou - Risk of Rain Coalescence
		"https://www.youtube.com/watch?v=SQOdPQQf2Uo",						// Star Trek The Motion Picture: Main Theme Album Style Edit
		"https://www.youtube.com/watch?v=jJDAV9vSmYc",						// Chris Remo - The Wizard
		"https://www.youtube.com/watch?v=nRjLv1L0WF8",						// Blue Oyster Cult - Sole Survivor
		"https://www.youtube.com/watch?v=xhlH91k-86E",						// J.G. Thirlwell - In a Spaceage Mood
		"https://www.youtube.com/watch?v=ZhhQrFfzFM4",						// Carpenter Brut - Escape from Midwich Valley
		"https://www.youtube.com/watch?v=YGulLVWu-s0",						// God Hand "Rock a Bay"
		"https://www.youtube.com/watch?v=IhEqUKBTffU",						// Streets Of Rogue - 5-1
		"https://www.youtube.com/watch?v=fXvxnDmwB_I",						// Rain World THS - Action Scene
		"https://www.youtube.com/watch?v=MPPCNM85eRY",						// The Kinks - Super Sonic Ship
		"https://www.youtube.com/watch?v=tRcPA7Fzebw",						// David Bowie - Starman
		"https://www.youtube.com/watch?v=zquJ6AqvVNw",						// Dungeons of Dredmor - Diggle Hell
		"https://www.youtube.com/watch?v=uiPJQgw6M_g",						// Ribbiks - Chasing Suns
		"https://www.youtube.com/watch?v=7F_xOzLWy5U",						// Ataraxia - Deja Vuzz
		"https://www.youtube.com/watch?v=dxDpdfzwuD4",						// The Penis (Eek!) - Surasshu
		"https://www.youtube.com/watch?v=TszmdpUtf0A",						// Short Circuit - Daft Punk
		"https://www.youtube.com/watch?v=VJ817kvh_DM",						// Ben Prunty - FTL - Theme Song
		"https://www.youtube.com/watch?v=52Gg9CqhbP8",  					// Stuck in the Sound - Let's G
		"https://www.youtube.com/watch?v=8GW6sLrK40k",						// HOME - Resonance
		"https://www.youtube.com/watch?v=8DNoXUnaQ9k",						// Chris Christodoulou - Dies Irae
		"https://www.youtube.com/watch?v=Nn9trJXUrp0",						// Chris Christodoulou - ...con lentitud poderosa
		"https://www.youtube.com/watch?v=rkas-NHQnsI",						// Clint Eastwood - Magnum Force Theme
		"https://www.youtube.com/watch?v=e3t_dbLaw-M",						// DM Dokuro - Treasures Within The Abomination
		"https://www.youtube.com/watch?v=2O4C8J4bcXw",						// Blinch - Loop Hero OST - Loop Blues
		"https://www.youtube.com/watch?v=4q-La8uR0HU",						// Blinch - Loop Hero OST - Dark Matter Moon
		"https://www.youtube.com/watch?v=pP6nEgo9UTs",						// Banda Municipal de Manizales - El Pilon
		"https://www.youtube.com/watch?v=V52QTyn6e-A",						// Alistair Lindsay - RimWorld OST - Waiting For The Sun
		"https://www.youtube.com/watch?v=0-CLAPJ1PLs",						// Pizza Tower OST - Tunnely Shimbers
		"https://www.youtube.com/watch?v=4JkIs37a2JE",						// Jamiroquai - Virtual Insanity
		"https://www.youtube.com/watch?v=z01VlftkqY8",						// PilotRedSun - The Grinch's Ultimatum
		"https://www.youtube.com/watch?v=rcmQefeyPBs",						// Nightmargin - IT'S TIME TO FIGHT CRIME
		"https://www.youtube.com/watch?v=OGcMPp7TNo4",						// Bear McCreary - Wander My Friends
		"https://soundcloud.com/lemmino/firecracker",						// LEMMiNO - Firecracker - CC BY-SA 4.0
		"https://www.youtube.com/watch?v=bJNXazHoLkE",						// Bright Primate - Bio-Engineering
		"https://soundcloud.com/jeffimam/the-sadness-club-at-the-edge-of-the-universe", // Jeff Imam - The Sadness Club At The Edge Of The Universe
		"https://soundcloud.com/jeffimam/forest"							// Jeff Imam - Forest
		)
	selected_lobby_music = pick(songs)

	if(SSgamemode.holidays) // What's this? Events are initialized before tickers? Let's do something with that!
		for(var/holidayname in SSgamemode.holidays)
			var/datum/holiday/holiday = SSgamemode.holidays[holidayname]
			if(LAZYLEN(holiday.lobby_music))
				selected_lobby_music = pick(holiday.lobby_music)
				break

	var/ytdl = CONFIG_GET(string/invoke_youtubedl)
	if(!ytdl)
		to_chat(world, span_boldwarning("Youtube-dl was not configured."))
		log_world("Could not play lobby song because youtube-dl is not configured properly, check the config.")
		return

	var/list/output = world.shelleo("[ytdl] --config-location /bootstrapper/yt-dlp.conf -- \"[selected_lobby_music]\"")
	var/errorlevel = output[SHELLEO_ERRORLEVEL]
	var/stdout = output[SHELLEO_STDOUT]
	var/stderr = output[SHELLEO_STDERR]

	if(!errorlevel)
		var/list/data
		try
			data = json_decode(stdout)
		catch(var/exception/e)
			to_chat(src, span_boldwarning("Youtube-dl JSON parsing FAILED:"), confidential=TRUE)
			to_chat(src, span_warning("[e]: [stdout]"), confidential=TRUE)
			return
		if(data["title"])
			login_music_data["title"] = data["title"]
			login_music_data["url"] = data["url"]

	if(errorlevel)
		to_chat(world, span_boldwarning("Youtube-dl failed."))
		log_world("Could not play lobby song [selected_lobby_music]: [stderr]")
		return
	return stdout
