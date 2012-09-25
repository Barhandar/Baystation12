/mob/verb/listen_ooc()
	set name = "Hear/Stop Hearing OOC"
	set category = "OOC"

	if (src.client)
		src.client.listen_ooc = !src.client.listen_ooc
		if (src.client.listen_ooc)
			src << "\blue You are now listening to messages on the OOC channel."
		else
			src << "\blue You are no longer listening to messages on the OOC channel."

/mob/verb/ooc(msg as text)
	set name = "OOC" //Gave this shit a shorter name so you only have to time out "ooc" rather than "ooc message" to use it --NeoFite
	set category = "OOC"
	if (IsGuestKey(src.key))
		src << "You are not authorized to communicate over these channels."
		return
	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return
	else if (!src.client.listen_ooc)
		return
	else if (!ooc_allowed && !src.client.holder)
		return
	else if (!dooc_allowed && !src.client.holder && (src.client.holder.deadchat != 0))
		usr << "OOC for dead mobs has been turned off."
		return
	else if (src.client && (src.client.muted || src.client.muted_complete))
		src << "You are muted."
		return
	else if (findtext(msg, "byond://") && !src.client.holder)
		src << "<B>Advertising other servers is not allowed.</B>"
		log_admin("[key_name(src)] has attempted to advertise in OOC.")
		message_admins("[key_name_admin(src)] has attempted to advertise in OOC.")
		return

	log_ooc("[src.name]/[src.key] : [msg]")

//Yes, I favor readable code over compact/fast. Who could have guessed? --Barhandar
	for (var/client/C)
		if (C.listen_ooc)
			if (src.client.holder)
				if(src.client.holder.level >= 5) //Access to custom OOC color AND mimic
					if (C.holder)
						C << "<span class='tyrantooc'><font color=[src.client.ooccolor]><b><span class='prefix'>OOC:</span> <EM>[src.key][(src.client.holder.mimic || src.client.holder.stealth) ? "/([src.client.fakekey])" : ""]:</EM> <span class='message'>[msg]</span></b></font></span>"
					else
						if (src.client.holder.mimic)
							C << "<font color=[src.client.ooccolor]><b><span class='prefix'>OOC:</span> <EM>[src.client.fakekey]:</EM> <span class='message'>[msg]</span></b></font>"
						else if (src.client.holder.stealth)
							C << "<span class='stealthooc'><span class='prefix'>OOC:</span> <EM>[src.client.fakekey]:</EM> <span class='message'>[msg]</span></span>"
						else //neither mimic nor stealth, full-color
							C << "<font color=[src.client.ooccolor]><b><span class='prefix'>OOC:</span> <EM>[src.key]:</EM> <span class='message'>[msg]</span></b></font>"
				else //No access to these
					if (C.holder)
						C << "<span class='adminooc'><span class='prefix'>OOC:</span> <EM>[src.key][(src.client.holder.stealth) ? "/([src.client.fakekey])" : ""]:</EM> <span class='message'>[msg]</span></span>"
					else
						C << "<span class='ooc'><span class='prefix'>OOC:</span> <EM>[src.client.holder.stealth ? src.client.fakekey : src.key]:</EM> <span class='message'>[msg]</span></span>"
			else //sayer is not holder - cannot be mimic or stealth
				C << "<span class='ooc'><span class='prefix'>OOC:</span> <EM>[src.key]:</EM> <span class='message'>[msg]</span></span>"