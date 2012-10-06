//GUYS REMEMBER TO ADD A += to UPDATE_ADMINS
//AND A -= TO CLEAR_ADMIN_VERBS



//Some verbs that are still in the code but not used atm
			// Debug
//			verbs += /client/proc/radio_report //for radio debugging dont think its been used in a very long time
//			verbs += /client/proc/fix_next_move //has not been an issue in a very very long time

			// Mapping helpers added via enable_debug_verbs verb
// 			verbs += /client/proc/do_not_use_these
// 			verbs += /client/proc/camera_view
// 			verbs += /client/proc/sec_camera_report
// 			verbs += /client/proc/intercom_view
//			verbs += /client/proc/air_status //Air things
//			verbs += /client/proc/Cell //More air things

/client/proc/update_admins(var/rank)
	if(!holder)
		holder = new /datum/admins(src)

	holder.rank = rank

//It's never used due to state, so why bother?
/*	if(!holder.state)
		var/state = alert("Which state do you want the admin to begin in?", "Admin-state", "Play", "Observe", "Neither")
		if(state == "Play")
			holder.state = 1
			admin_play()
			return
		else if(state == "Observe")
			holder.state = 2
			admin_observe()
			return
		else
			del(holder)
			return
*/
		//debug - 4, admin - 3 (SHOULD BE 2 REALLY), moder - 0, observer - -1, banned - -2
	switch (rank)
		if ("Monarch", "God", "Tzar")
			holder.level = 9
			holder.seeprayers = 1
		if ("The Singularity", "Spiderman", "Batman", "Misanthrope", "The Legend")
			holder.level = 6
			holder.seeprayers = 1
		if ("Game Master", "Tyrant", "Coder")
			holder.level = 5
			holder.seeprayers = 1
		if ("Admin", "General", "Game Admin", "Trial Admin")
			holder.level = 3
		if ("Moderator", "Commandant", "Comandante", "Admin Candidate")
			holder.level = 0
		if ("Observer", "Watcher")
			holder.level = -1
		if ("Banned")
			holder.level = -2
			del(src)
			return;
		else
			del(src)
			return;
	if (holder)		//THE BELOW handles granting powers. The above is for special cases only!
		holder.owner = src
		holder.grant_admin_permanence(ckey)
		for(var/V in all_admin_verbs)
			if(all_admin_verbs[V] <= holder.level)
				verbs += text2path(V)
		holder.deadchat = 1

		//here you have verbs that disregard levels completely, aka you always have them even when deverbed
		verbs += /client/proc/toggle_verbs
//		if(scarecrows)
//			for(var/S in scarecrows)
//				if(S:ckey == ckey) holder.scarecrow = S
	return


/client/proc/clear_admin_verbs()
	holder.deadchat = 0
	holder.seeprayers = 0

	for(var/V in all_admin_verbs)
		if(V in verbs)
			verbs -= text2path(V)
	verbs -= /client/proc/toggle_verbs
	return


/client/proc/set_desired_spammage_level()
	set category = "Admin"
	set name = "Choose Spammage"
	var/holdalert = alert("Choose the level!",,"Adminlog: [(holder.spammage & ADMINLOGSPAM) ? "ON" : "OFF"]", "Attack: [(holder.spammage & ATTACKSPAM) ? "ON" : "OFF"]", "Failogin: [(holder.spammage & FAILOGINSPAM) ? "ON" : "OFF"]")
	switch(holdalert)
		if("Adminlog: ON")
			holder.spammage &= ~ADMINLOGSPAM
		if("Adminlog: OFF")
			holder.spammage |= ADMINLOGSPAM
		if("Attack: ON")
			holder.spammage &= ~ATTACKSPAM
		if("Attack: OFF")
			holder.spammage |= ATTACKSPAM
		if("Failogin: ON")
			holder.spammage &= ~FAILOGINSPAM
		if("Failogin: OFF")
			holder.spammage |= FAILOGINSPAM


/client/proc/admin_observe()
	set category = "Admin"
	set name = "Set Observe"
	if(!holder)
		alert("You are not an admin")
		return

	verbs -= /client/proc/admin_play
	spawn( 1200 )
		verbs += /client/proc/admin_play
	//var/rank = holder.rank
	//clear_admin_verbs()
	holder.state = 2
	//update_admins(rank)
	if(!istype(mob, /mob/dead/observer))
		mob.admin_observing = 1
		mob.adminghostize(1)
	src << "\blue You are now observing"
//	feedback_add_details("admin_verb","O") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/admin_play()
	set category = "Admin"
	set name = "Set Play"
	if(!holder)
		alert("You are not an admin")
		return
	verbs -= /client/proc/admin_observe
	spawn( 1200 )
		verbs += /client/proc/admin_observe
	//var/rank = holder.rank
	//clear_admin_verbs()
	holder.state = 1
	//update_admins(rank)
	if(istype(mob, /mob/dead/observer) && mob:corpse)
		mob:reenter_corpse()
	src << "\blue You are now playing"
//	feedback_add_details("admin_verb","P") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/get_admin_state()
	set name = "Get Admin State"
	set category = "Debug"
	for(var/mob/M in world)
		if(M.client && M.client.holder)
			if(M.client.holder.state == 1)
				src << "[M.key] is playing - [M.client.holder.state]"
			else if(M.client.holder.state == 2)
				src << "[M.key] is observing - [M.client.holder.state]"
			else
				src << "[M.key] is undefined - [M.client.holder.state]"
//	feedback_add_details("admin_verb","GAS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/*
/client/proc/player_panel()
	set name = "Player Panel-Old"
	set category = "Admin"
	if(holder)
		holder.player_panel_old()
//	feedback_add_details("admin_verb","PP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return
*/
/client/proc/player_panel_new()
	set name = "Player Panel"
	set category = "Admin"
	if(holder)
		holder.player_panel_new()
//	feedback_add_details("admin_verb","PPN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/mod_panel()
	set name = "Moderator Panel"
	set category = "Admin"
	if(holder)
		holder.mod_panel()
//	feedback_add_details("admin_verb","MP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/check_antagonists()
	set name = "Check Antagonists"
	set category = "Admin"
	if(holder)
		holder.check_antagonists()
		log_admin("[key_name(usr)] checked antagonists.")	//for tsar~
	//feedback_add_details("admin_verb","CHA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/jobbans()
	set name = "Unjobban Panel"
	set category = "Admin"
//	set hidden = 1 //LEBEDEV
	if(holder)
		holder.Jobbans()
//	feedback_add_details("admin_verb","VJB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/unban_panel()
	set name = "Unban Panel"
	set category = "Admin"
	if(holder)
		holder.unbanpanel()
//	feedback_add_details("admin_verb","UBP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/game_panel()
	set name = "Game Panel"
	set category = "Admin"
	if(holder)
		holder.Game()
//	feedback_add_details("admin_verb","GP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/secrets()
	set name = "Secrets"
	set category = "Admin"
	if (holder)
		holder.Secrets()
//	feedback_add_details("admin_verb","S") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/voting()
	set name = "Voting"
	set category = "Admin"
	if (holder)
		holder.Voting()
//	feedback_add_details("admin_verb","VO") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/colorooc()
	set category = "Fun"
	set name = "OOC Text Color"
	ooccolor = input(src, "Please select your OOC color.", "OOC color") as color
//	feedback_add_details("admin_verb","OC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/stealth()
	set category = "Admin"
	set name = "Stealth Mode"
	if(!holder)
		src << "Only administrators may use this command."
		return
	//src = src.holder
	if(holder.mimic)
		src.mimic()
	if(!holder.stealth)
		var/new_key = trim(input("Enter your desired display name.", "Fake Key", key))
		if(!new_key)
			holder.stealth = 0
			return
		new_key = strip_html(new_key)
		if(length(new_key) >= 26)
			new_key = copytext(new_key, 1, 26)
		fakekey = new_key
		holder.stealth = 1
	else
		fakekey = null
		holder.stealth = 0
	log_admin("[key_name(usr)] has turned stealth mode [holder.stealth ? "ON with name [fakekey]" : "OFF"]")
	message_admins("[key_name_admin(usr)] has turned stealth mode [holder.stealth ? "ON with name [fakekey]" : "OFF"]", 1)

/client/proc/mimic()
	set category = "Admin"
	set name = "Mimic Mode"
	if(!holder)
		src << "Only administrators may use this command."
		return
	//src = src.holder
	if(holder.stealth)
		src.stealth()
	if(!holder.mimic)
		var/new_key = trim(input("Enter your desired display name.", "Fake Key", key))
		if(!new_key)
			holder.stealth = 0
			return
		new_key = strip_html(new_key)
		if(length(new_key) >= 26)
			new_key = copytext(new_key, 1, 26)
		fakekey = new_key
		holder.mimic = 1
	else
		fakekey = null
		holder.mimic = 0
	log_admin("[key_name(usr)] has turned mimic mode [holder.mimic ? "ON with name [fakekey]" : "OFF"]")
	message_admins("[key_name_admin(usr)] has turned mimic mode [holder.mimic ? "ON with name [fakekey]" : "OFF"]", 1)

/client/proc/fakerank()
	set category = "Admin"
	set name = "Fake Rank"
	if(!holder)
		src << "Only administrators may use this command."
		return
	//src = src.holder
	if(!holder.fakerank)
		var/new_rank = trim(input("Enter your desired display rank.", "Fake Rank", holder.rank))
		if(!new_rank)
			holder.fakerank = null
			return
		new_rank = strip_html(new_rank)
		if(length(new_rank) >= 26)
			new_rank = copytext(new_rank, 1, 26)
		holder.fakerank = new_rank
	else
		holder.fakerank = null
	log_admin("[key_name(usr)] has turned fakerank [holder.fakerank ? "ON with rank [holder.fakerank]" : "OFF"]")
	message_admins("[key_name_admin(usr)] has turned fakerank [holder.fakerank ? "ON with name [holder.fakerank]" : "OFF"]", 1)


/client/proc/playernotes()
	set name = "Show Player Info"
	set category = "Admin"
	if(holder)
		holder.PlayerNotes()
	return

#define AUTOBANTIME 10
/client/proc/warn(var/mob/M in world)
	set category = "Special Verbs"
	set name = "Warn"
	// If you've edited AUTOBANTIME, change the below desc.
	set desc = "Warn a player. If player is already warned, they will be autobanned for 10 minutes."
	if(!holder)
		src << "Only administrators may use this command."
		return
	if(M.client && M.client.holder && (M.client.holder.level >= holder.level))
		alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
		return
	if(!M.client.warned)
		M << "\red <B>You have been warned by an administrator. This is the only warning you will recieve.</B>"
		M.client.warned = 1
		message_admins("\blue [ckey] warned [M.ckey].")
	else
		AddBan(M.ckey, M.computer_id, "Autobanning due to previous warn", ckey, 1, AUTOBANTIME)
		M << "\red<BIG><B>You have been autobanned by [ckey]. This is what we in the biz like to call a \"second warning\".</B></BIG>"
		M << "\red This is a temporary ban; it will automatically be removed in [AUTOBANTIME] minutes."
		log_admin("[ckey] warned [M.ckey], resulting in a [AUTOBANTIME] minute autoban.")
		ban_unban_log_save("[ckey] warned [M.ckey], resulting in a [AUTOBANTIME] minute autoban.")
		message_admins("\blue [ckey] warned [M.ckey], resulting in a [AUTOBANTIME] minute autoban.")
		//feedback_inc("ban_warn",1)

		del(M.client)
//	feedback_add_details("admin_verb","WARN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/drop_bomb() // Some admin dickery that can probably be done better -- TLE
	set category = "Special Verbs"
	set name = "Drop Bomb"
	set desc = "Cause an explosion of varying strength at your location."

	var/turf/epicenter = mob.loc
	var/list/choices = list("Small Bomb", "Medium Bomb", "Big Bomb", "Custom Bomb")
	var/choice = input("What size explosion would you like to produce?") in choices
	switch(choice)
		if(null)
			return 0
		if("Small Bomb")
			explosion(epicenter, 1, 2, 3, 3)
		if("Medium Bomb")
			explosion(epicenter, 2, 3, 4, 4)
		if("Big Bomb")
			explosion(epicenter, 3, 5, 7, 5)
		if("Custom Bomb")
			var/devastation_range = input("Devastation range (in tiles):") as num
			var/heavy_impact_range = input("Heavy impact range (in tiles):") as num
			var/light_impact_range = input("Light impact range (in tiles):") as num
			var/flash_range = input("Flash range (in tiles):") as num
			explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)
	message_admins("\blue [ckey] creating an admin explosion at [epicenter.loc].")
//	feedback_add_details("admin_verb","DB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/give_spell(mob/T as mob in world) // -- Urist
	set category = "Fun"
	set name = "Give Spell"
	set desc = "Gives a spell to a mob."
	var/obj/effect/proc_holder/spell/S = input("Choose the spell to give to that guy", "ABRAKADABRA") as null|anything in spells
	if(!S) return
	T.spell_list += new S
//	feedback_add_details("admin_verb","GS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] gave [key_name(T)] the spell [S].")
	message_admins("\blue [key_name_admin(usr)] gave [key_name(T)] the spell [S].", 1)

/client/proc/make_sound(var/obj/O in world) // -- TLE
	set category = "Special Verbs"
	set name = "Make Sound"
	set desc = "Display a message to everyone who can hear the target"
	if(O)
		var/message = input("What do you want the message to be?", "Make Sound") as text|null
		if(!message)
			return
		for (var/mob/V in hearers(O))
			V.show_message(message, 2)
		log_admin("[key_name(usr)] made [O] at [O.x], [O.y], [O.z]. make a sound")
		message_admins("\blue [key_name_admin(usr)] made [O] at [O.x], [O.y], [O.z]. make a sound", 1)
//		feedback_add_details("admin_verb","MS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/togglebuildmodeself()
	set name = "Toggle Build Mode Self"
	set category = "Special Verbs"
	if(src.mob)
		togglebuildmode(src.mob)
//	feedback_add_details("admin_verb","TBMS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//BARHMARK
/client/proc/toggleadminhelpsound()
	set name = "Toggle Adminhelp Sound"
	set category = "Admin"
	sound_adminhelp = !sound_adminhelp
	if(sound_adminhelp)
		usr << "You will now hear a sound when adminhelps arrive"
	else
		usr << "You will no longer hear a sound when adminhelps arrive"
//	feedback_add_details("admin_verb","AHS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/object_talk(var/msg as text) // -- TLE
	set category = "Special Verbs"
	set name = "oSay"
	set desc = "Display a message to everyone who can hear the target"
	if(mob.control_object)
		if(!msg)
			return
		for (var/mob/V in hearers(mob.control_object))
			V.show_message("<b>[mob.control_object.name]</b> says: \"" + msg + "\"", 2)
//	feedback_add_details("admin_verb","OT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/kill_air() // -- TLE
	set category = "Debug"
	set name = "Kill Air"
	set desc = "Toggle Air Processing"
	if(kill_air)
		kill_air = 0
		usr << "<b>Enabled air processing.</b>"
	else
		kill_air = 1
		usr << "<b>Disabled air processing.</b>"
//	feedback_add_details("admin_verb","KA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] used 'kill air' (toggle), kill_air: [kill_air].")
	message_admins("\blue [key_name_admin(usr)] used 'kill air'.", 1)


/client/proc/toggle_clickproc() //TODO ERRORAGE (This is a temporary verb here while I test the new clicking proc)
	set name = "Toggle NewClickProc"
	set category = "Debug"

	if(!holder) return
	using_new_click_proc = !using_new_click_proc
	world << "Testing of new click proc [using_new_click_proc ? "enabled" : "disabled"]"
//	feedback_add_details("admin_verb","TNCP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_hear_deadcast()
	set name = "Toggle Hear Deadcast"
	set category = "Admin"
	if(!holder) return
	src = src.holder
	STFU_ghosts = !STFU_ghosts
	usr << "You will now [STFU_ghosts ? "not hear" : "hear"] ghosts"
//	feedback_add_details("admin_verb","THDC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_hear_radio()
	set name = "Toggle Hear Radio"
	set category = "Admin"
	if(!holder) return
	STFU_radio = !STFU_radio
	usr << "You will now [STFU_radio ? "not hear" : "hear"] radio chatter from nearby radios or speakers"
//	feedback_add_details("admin_verb","THR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/deadmin_self()
	set name = "De-admin self"
	set category = "Admin"

	if(src.holder)
		if(alert("Confirm self-deadmin for the round? You can't re-admin yourself without someone promoting you.",,"Yes","No") == "Yes")
			//del(holder)
			log_admin("[src] deadmined themself.")
			message_admins("[src] deadmined themself.", 1)
			src.clear_admin_verbs()
			src.update_admins(null)
			admins.Remove(src.ckey)
			usr << "You are now a normal player."
//	feedback_add_details("admin_verb","DAS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/toggle_verbs()
	set name = "Toggle ALL verbs"
	set category = "Admin"
	set desc = "Toggle ALL of the verbs"

	if(holder.hidverbs)
		update_admins(holder.rank)
		holder.hidverbs = 0
	else
		clear_admin_verbs()
		holder.deadchat = 1
		holder.hidverbs = 1
		verbs += /client/proc/toggle_verbs

		verbs += /client/proc/cmd_admin_say//asay
//	feedback_add_details("admin_verb","TAVVH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/toggle_log_hrefs()
	set name = "Toggle href logging"
	set category = "Server"
	if(!holder)	return
	if(config)
		if(config.log_hrefs)
			config.log_hrefs = 0
			src << "<b>Stopped logging hrefs</b>"
		else
			config.log_hrefs = 1
			src << "<b>Started logging hrefs</b>"

/client/proc/admin_invis()
	set category = "Admin"
	set name = "Invisibility"
	if(!src.holder)
		src << "Only administrators may use this command."
		return
	src.admin_invis =! src.admin_invis
	if(src.mob)
		mob.update_clothing()
	log_admin("[key_name(usr)] has turned their invisibility [src.admin_invis ? "ON" : "OFF"]")
	message_admins("[key_name_admin(usr)] has turned their invisibility [src.admin_invis ? "ON" : "OFF"]", 1)

/client/proc/cmd_admin_godmode(mob/M as mob in world)
	set category = "Admin"
	set name = "Toggle Godmode"
	if(!src.holder)
		src << "Only administrators may use this command."
		return
	if (M.nodamage == 1)
		M.nodamage = 0
		usr << "\blue Toggled OFF"
	else
		M.nodamage = 1
		usr << "\blue Toggled ON"

	log_admin("[key_name(usr)] has toggled [key_name(M)]'s nodamage to [(M.nodamage ? "On" : "Off")]")
	message_admins("[key_name_admin(usr)] has toggled [key_name_admin(M)]'s nodamage to [(M.nodamage ? "On" : "Off")]", 1)

/client/proc/editappear(mob/living/carbon/human/M as mob in world)
	set name = "Edit Appearance"
	set category = "Fun"
	if(!istype(M, /mob/living/carbon/human))
		usr << "\red You can only do this to humans!"
		return
	switch(alert("You sure you wish to edit this mob's appearance?",,"Yes","No"))
		if("No")
			return
	if(istype(M,/mob/living/carbon/human/tajaran))
		usr << "\red Humanoid aliens do not have an editable appearance... yet!"
	else
		var/new_facial = input("Please select facial hair color.", "Character Generation") as color
		if(new_facial)
			M.r_facial = hex2num(copytext(new_facial, 2, 4))
			M.g_facial = hex2num(copytext(new_facial, 4, 6))
			M.b_facial = hex2num(copytext(new_facial, 6, 8))

		var/new_hair = input("Please select hair color.", "Character Generation") as color
		if(new_facial)
			M.r_hair = hex2num(copytext(new_hair, 2, 4))
			M.g_hair = hex2num(copytext(new_hair, 4, 6))
			M.b_hair = hex2num(copytext(new_hair, 6, 8))

		var/new_eyes = input("Please select eye color.", "Character Generation") as color
		if(new_eyes)
			M.r_eyes = hex2num(copytext(new_eyes, 2, 4))
			M.g_eyes = hex2num(copytext(new_eyes, 4, 6))
			M.b_eyes = hex2num(copytext(new_eyes, 6, 8))

		var/new_tone = input("Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation")  as text

		if (new_tone)
			M.s_tone = max(min(round(text2num(new_tone)), 220), 1)
			M.s_tone =  -M.s_tone + 35

		// hair
		var/list/all_hairs = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
		var/list/hairs = list()

		// loop through potential hairs
		for(var/x in all_hairs)
			var/datum/sprite_accessory/hair/H = new x // create new hair datum based on type x
			hairs.Add(H.name) // add hair name to hairs
			del(H) // delete the hair after it's all done

		var/new_style = input("Please select hair style", "Character Generation")  as null|anything in hairs

		// if new style selected (not cancel)
		if (new_style)
			M.h_style = new_style

			for(var/x in all_hairs) // loop through all_hairs again. Might be slightly CPU expensive, but not significantly.
				var/datum/sprite_accessory/hair/H = new x // create new hair datum
				if(H.name == new_style)
					M.hair_style = H // assign the hair_style variable a new hair datum
					break
				else
					del(H) // if hair H not used, delete. BYOND can garbage collect, but better safe than sorry

		// facial hair
		var/list/all_fhairs = typesof(/datum/sprite_accessory/facial_hair) - /datum/sprite_accessory/facial_hair
		var/list/fhairs = list()

		for(var/x in all_fhairs)
			var/datum/sprite_accessory/facial_hair/H = new x
			fhairs.Add(H.name)
			del(H)

		new_style = input("Please select facial style", "Character Generation")  as null|anything in fhairs

		if(new_style)
			M.f_style = new_style
			for(var/x in all_fhairs)
				var/datum/sprite_accessory/facial_hair/H = new x
				if(H.name == new_style)
					M.facial_hair_style = H
					break
				else
					del(H)

	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female")
	if (new_gender)
		if(new_gender == "Male")
			M.gender = MALE
		else
			M.gender = FEMALE
	M.rebuild_appearance()
	M.update_body()
	M.check_dna(M)


/client/proc/radioalert()
	set category = "Fun"
	set name = "Create Radio Alert"
	var/message = input("Choose a message! (Don't forget the \"says, \" or similar at the start.)", "Message") as text|null
	var/from = input("From whom? (Who's saying this?)", "From") as text|null
	if(message && from)
		var/obj/item/device/radio/intercom/a = new /obj/item/device/radio/intercom(null)
		a.autosay(message,from)
		del(a)

/client/proc/CarbonCopy(atom/movable/O as mob|obj in world)
	set category = "Debug"
	set name = "CarbonCopy"
	var/atom/movable/NewObj = new O.type(usr.loc)
	for(var/V in O.vars)
		if (issaved(O.vars[V]))
			if(V == "contents")
				for(var/atom/movable/C in O.contents)
					C.CarbonCopy2(NewObj)
			else
				NewObj.vars[V] = O.vars[V]
	return NewObj

/atom/proc/CarbonCopy2(atom/movable/O as mob|obj in world)
	var/atom/movable/NewObj = new type(O)
	for(var/V in vars)
		if (issaved(vars[V]))
			if(V == "contents")
				for(var/atom/movable/C in contents)
					C.CarbonCopy2(NewObj)
			else
				NewObj.vars[V] = vars[V]
	return NewObj

/*
/client/proc/scarecrow()
	set category = "Fun"
	set desc = "Puts up a scarecrow to, uhm, scare players out of not abiding rules."
	set name = "Scarecrow!"

	if (!holder)
		usr << "Sorry, but you don't have necessary variables to run Scarecrow."
		return
	for(var/datum/admins/scarecrow/S in scarecrows)
		if(S.ckey == ckey)
			scarecrows -= S
			del(S)
			usr << "Scarecrow removed!"
			holder.scarecrow = null
			return
	var/datum/admins/scarecrow/pugalo = new/datum/admins/scarecrow
	pugalo.ckey = ckey
	pugalo.key = (fakekey ? fakekey : key)
	pugalo.rank = (holder.fakerank ? holder.fakerank : holder.rank)
//	pugalo.src = null
	scarecrows += pugalo
	holder.scarecrow = pugalo
	usr << "Scarecrow successfully created! You are also not visible in adminwho and who while scarecrow exists."
*/
//-1 is observer, 0 is moderator, 1 is admin, 2 is server, 3 is reserved, 4 is debug, 5 is FUN TIME
//LIST ALL OF THE ADMIN VERBS WITH RANK HERE!
//REMEMBER TO USE INLINE COMMENTS OR USE ENTIRE LINE!
//FIVE - FUNTIME
var/list/all_admin_verbs = list("/client/proc/send_space_ninja" = 5, \
	"/client/proc/mimic" = 5, \
	"/client/proc/fakerank" = 5, \
	"/client/proc/only_one" = 5, \
	"/proc/possess" = 5, \
	"/proc/release" = 5, \
	"/client/proc/drop_bomb" = 5, \
	"/client/proc/spawn_xeno" = 5, \
	"/client/proc/strike_team" = 5, \
	"/client/proc/toggleprayers" = 5, \
	"/client/proc/Blobize" = 5, \
	"/client/proc/toggle_gravity_on" = 5, \
	"/client/proc/toggle_gravity_off" = 5, \
	"/client/proc/cinematic" = 5, \
	"/client/proc/admin_invis" = 5, \
	"/client/proc/cmd_admin_godmode" = 5, \
	"/client/proc/cmd_admin_christmas" = 5, \
	"/client/proc/colorooc" = 5, \
	"/client/proc/cmd_assume_direct_control" = 5, \
//FOUR - DEBUG
	"/client/proc/startSinglo" = 4, \
	"/client/proc/enable_debug_verbs" = 4, \
	"/client/proc/callproc" = 4, \
	"/client/proc/kill_air" = 4, \
	"/client/proc/debug_variables" = 4, \
	"/datum/admins/proc/spawn_atom" = 4, \
	"/client/proc/cmd_debug_make_powernets" = 4, \
	"/client/proc/cmd_debug_del_all" = 4, \
	"/client/proc/cmd_debug_tog_aliens" = 4, \
	"/client/proc/enable_debug_verbs" = 4, \
	"/client/proc/Cell" = 4, \
	"/client/proc/debug_variables" = 4, \
	"/client/proc/Debug2" = 4, \
	"/client/proc/cmd_modify_ticker_variables" = 4, \
	"/client/proc/cmd_admin_delete" = 4, \
	"/client/proc/cmd_admin_check_contents" = 4, \
	"/client/proc/general_report" = 4, \
	"/client/proc/restartcontroller" = 4, \
	"/client/proc/toggle_clickproc" = 4, \
	"/client/proc/tension_report" = 4, \
	"/client/proc/giveruntimelog" = 4, \
	"/client/proc/getserverlog" = 4, \
	"/client/proc/toggle_log_hrefs" = 4, \
	"/client/proc/callprocgen" = 4, \
	"/client/proc/callprocobj" = 4, \
	"/client/proc/delbook" = 4, \
	"/client/proc/rnd_check_designs" = 4, \
	"/client/proc/CarbonCopy" = 4, \
	"/client/proc/cmd_modify_ref_variables" = 4, \
	"/client/proc/togglebuildmodeself" = 4, \
	"/client/proc/debug_master_controller" = 4, \
	"/client/proc/editappear" = 4, \
	"/datum/admins/proc/show_skills" = 4, \
	"/client/proc/cmd_admin_grantfullaccess" = 4, \
//THREE - SHIT ADMINS SHOULDNT HAVE BUT DO
	"/client/proc/object_talk" = 3, \
	"/client/proc/toggle_view_range" = 3, \
	"/client/proc/cmd_admin_gib_self" = 3, \
	"/client/proc/make_sound" = 3, \
	"/client/proc/cmd_admin_direct_narrate" = 3, \
	"/client/proc/cmd_admin_world_narrate" = 3, \
	"/client/proc/cmd_admin_rejuvenate" = 3, \
	"/client/proc/cmd_admin_add_freeform_ai_law" = 3, \
	"/client/proc/cmd_admin_add_random_ai_law" = 3, \
	"/client/proc/cmd_admin_dress" = 3, \
	"/client/proc/respawn_character" = 3, \
	"/client/proc/play_sound" = 3, \
	"/client/proc/cmd_admin_subtle_message" = 3, \
	"/client/proc/update_mob_sprite" = 3, \
	"/client/proc/play_local_sound" = 3, \
	"/client/proc/toggle_random_events" = 3, \
	"/client/proc/everyone_random" = 3, \
	"/client/proc/cmd_admin_change_custom_event" = 3, \
	"/client/proc/Force_Event_admin" = 3, \
	"/client/proc/radioalert" = 3, \
	"/client/proc/make_tajaran" = 3, \
	"/client/proc/playernotes" = 3, \
//TWO - SERVER
	"/datum/admins/proc/immreboot" = 2, \
	"/datum/admins/proc/restart" = 2, \
	"/client/proc/reload_admins" = 2, \
	"/datum/admins/proc/delay" = 2, \
	"/datum/admins/proc/startnow" = 2, \
	"/datum/admins/proc/view_txt_log" = 2, \
	"/datum/admins/proc/view_atk_log" = 2, \
	"/client/proc/voting" = 2, \
	"/client/proc/investigate_show" = 2, \
//ONE - ADMIN
	"/client/proc/check_words" = 1, \
	"/datum/admins/proc/votekill" = 1, \
	"/datum/admins/proc/toggleAI" = 1, \
	"/datum/admins/proc/toggleenter" = 1, \
	"/datum/admins/proc/toggleooc" = 1, \
	"/datum/admins/proc/toggleoocdead" = 1, \
	"/datum/admins/proc/voteres" = 1, \
	"/datum/admins/proc/toggle_aliens" = 1, \
	"/datum/admins/proc/toggle_space_ninja" = 5, \
	"/datum/admins/proc/adrev" = 1, \
	"/datum/admins/proc/adspawn" = 1, \
	"/datum/admins/proc/toggleaban" = 1, \
	"/datum/admins/proc/announce" = 1, \
	"/datum/admins/proc/adjump" = 1, \
	"/client/proc/triple_ai" = 1, \
	"/client/proc/stealth" = 1, \
	"/client/proc/secrets" = 1, \
	"/client/proc/game_panel" = 1, \
	"/client/proc/cmd_admin_list_open_jobs" = 1, \
	"/datum/admins/proc/vmode" = 1, \
	"/client/proc/Getmob" = 1, \
	"/client/proc/Getkey" = 1, \
	"/client/proc/sendmob" = 1, \
	"/client/proc/admin_call_shuttle" = 1, \
	"/client/proc/admin_cancel_shuttle" = 1, \
	"/client/proc/cmd_admin_create_centcom_report" = 1, \
	"/client/proc/player_panel_new" = 1, \
	"/client/proc/admin_memo" = 1, \
	"/client/proc/admin_deny_shuttle" = 1, \
	"/client/proc/set_desired_spammage_level" = 1, \
//ZERO - MODERATOR
	"/datum/admins/proc/show_traitor_panel" = 0, \
	"/datum/admins/proc/show_player_panel" = 0, \
/*	"/client/proc/get_admin_state" = 0, \*/
	"/client/proc/check_antagonists" = 0, \
	"/client/proc/deadchat" = 0, \
	"/client/proc/unban_panel" = 0, \
	"/client/proc/jobbans" = 0, \
	"/client/proc/Jump" = 0, \
	"/client/proc/jumptokey" = 0, \
	"/client/proc/jumptomob" = 0, \
	"/client/proc/jumptoturf" = 0, \
	"/client/proc/jumptocoord" = 0, \
	"/client/proc/dsay" = 0, \
	"/client/proc/toggle_hear_deadcast" = 0, \
	"/client/proc/toggle_hear_radio" = 0, \
//MINUS ONE - OBSERVER
	"/client/proc/cmd_admin_say" = -1, \
	"/client/proc/admin_play" = -1, \
	"/client/proc/admin_observe" = -1, \
	"/client/proc/toggleadminhelpsound" = -1, \
	"/client/proc/cmd_admin_pm_context" = -1, \
	"/client/proc/cmd_admin_pm_panel" = -1, \
	"/client/proc/deadmin_self" = -1)

//ADMIN RANK-RELATED PROCS

/proc/get_rank_from_level(var/level)
	switch(level)
		if(9) return "Monarch"
		if(6) return "Batman"
		if(5) return "Tyrant"
		if(3) return "General"
		if(0) return "Comandante"
		if(-1) return "Watcher"
		if(-2) return null
		else return null