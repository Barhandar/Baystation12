/mob/verb/who()
	set name = "Who"
	set category = "OOC"

	usr << "<b>Current Players:</b>"

	var/list/peeps = list()

	for (var/mob/M in world)
		if (!M.client)
			continue
		if ((M.client.holder.stealth || M.client.holder.mimic) && !usr.client.holder)
			peeps += "\t[M.client.fakekey]"
		else
			peeps += "\t[M.client][(M.client.holder.stealth || M.client.holder.mimic) ? " <i>(as [M.client.fakekey])</i>" : ""][M.client.holder.scarecrow ? " (Scarecrow'd)" : ""]"
	peeps = sortList(peeps)

	for (var/p in peeps)
		usr << p

	usr << "<b>Total Players: [length(peeps)]</b>"

/client/verb/adminwho()
	set category = "Admin"
	set name = "Adminwho"

	usr << "<b>Current Admins:</b>"

	for (var/mob/M in world)
		if(M && M.client && M.client.holder)
			if(usr.client.holder && usr.client.holder.level >= -1)
				var/afk = 0
				if( M.client.inactivity > 3000 ) //3000 deciseconds = 300 seconds = 5 minutes
					afk = 1
				if(isobserver(M))
					usr << "[M.key][(M.client.holder.stealth || M.client.holder.mimic) ? " <i>(as [M.client.fakekey])</i>" : ""] is a [M.client.holder.fakerank ? "[M.client.holder.rank]/<i>[M.client.holder.fakerank]</i>" : M.client.holder.rank] - Observing [afk ? "(AFK)" : ""] [M.client.holder.scarecrow ? "(Scarecrow'd)" : ""]"
				else if(istype(M,/mob/new_player))
					usr << "[M.key][(M.client.holder.stealth || M.client.holder.mimic) ? " <i>(as [M.client.fakekey])</i>" : ""] is a [M.client.holder.fakerank ? "[M.client.holder.rank]/<i>[M.client.holder.fakerank]</i>" : M.client.holder.rank] - Has not entered [afk ? "(AFK)" : ""][M.client.holder.scarecrow ? "(Scarecrow'd)" : ""]"
				else if(istype(M,/mob/living))
					usr << "[M.key][(M.client.holder.stealth || M.client.holder.mimic) ? " <i>(as [M.client.fakekey])</i>" : ""] is a [M.client.holder.fakerank ? "[M.client.holder.rank]/<i>[M.client.holder.fakerank]</i>" : M.client.holder.rank] - Playing [afk ? "(AFK)" : ""][M.client.holder.scarecrow ? "(Scarecrow'd)" : ""]"
			else if(!M.client.holder.stealth && !M.client.holder.scarecrow)
				usr << "\t[pick(nobles)] [M.client.holder.mimic ? M.client.fakekey : M.client] is a [M.client.holder.fakerank ? M.client.holder.fakerank : M.client.holder.rank]"
var/list/nobles = list("Baron","Bookkeeper","Captain of the Guard","Chief Medical Dwarf","Count","Dungeon Master","Duke","General","Mayor","Outpost Liaison","Sheriff","Champion")

/client/verb/active_players()
	set category = "OOC"
	set name = "Active Players"
	var/total = 0
	for(var/mob/living/M in world)
		if(!M.client) continue
		if(M.client.inactivity > 10 * 60 * 10) continue
		if(M.stat == 2) continue

		total++

	usr << "<b>Active Players: [total]</b>"