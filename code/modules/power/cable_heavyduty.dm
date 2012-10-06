/obj/item/weapon/cable_coil/heavyduty
	color = "red"
//NOTHING TO SEE HERE NOT A VALID OBJECT
/obj/item/weapon/cable_coil/heavyduty/deck
	name = "heavy cable deck"
	icon = 'power.dmi'
	icon_state = "wire"
	desc = "Heavy-duty cable deck. There's [] lenghts of cable left."

/obj/structure/heavyduty
	icon = 'power_cond_heavy.dmi'

/obj/structure/heavyduty/node
	icon_state = "node"
	name = "heavy-duty power node"
	desc = "Node for connecting heavy-duty cables to."
	dir = 0 //dir determines where cables go. Zero is cableless.

/obj/structure/heavyduty/cable
	icon_state = "1-2"
	name = "heavy-duty power cable"
	desc = "This cable is insulated enough to transfer power to/from heavy-duty machines like supermatter engines. Incidentally, it also needs power tools to be cut."
	dir = 1 //doesn't matter for cables, they are only 1-2 and 4-8

/obj/structure/heavyduty/attackby(obj/item/W, mob/user)
	..()
/obj/structure/heavyduty/cable/attackby(obj/item/W, mob/user)

	var/turf/T = src.loc
	if(T.intact)
		return
	if(istype(W, /obj/item/weapon/wirecutters))
		usr << "\blue These cables are too tough to be cut with [W.name]."
		return
	else if(istype(W, /obj/item/weapon/cable_coil))
		usr << "\blue You cannot connect power cables directly - use nodes to change direction."
		return
//	else if(istype(W, HYPOTHETICPOWERTOOLS OR CIRCULARSAW))
	else
		..()
/obj/structure/heavyduty/node/attackby(obj/item/W, mob/user)
	var/turf/T = src.loc
	if(T.intact)
		return
	if(istype(W, /obj/item/weapon/cable_coil/heavyduty))
		return W:turf_place(src.loc, user)


/*
/obj/structure/cable/heavyduty/cableColor(var/colorC)
	return
*/

/obj/item/weapon/cable_coil/heavyduty/New(loc, length = MAXCOIL, var/param_color = null)
	..()
	src.amount = length
	if (param_color)
		color = param_color
	pixel_x = rand(-2,2)
	pixel_y = rand(-2,2)
	updateicon()

/obj/item/weapon/cable_coil/heavyduty/updateicon()
	return //no such thing exists

/obj/item/weapon/cable_coil/heavyduty/deck/updateicon()
	if (!color)
		color = pick("red", "yellow", "blue", "green", "pink")
	else
		icon_state = "hd_deck_[color]"
	if(amount == MAXCOIL) //full
		icon_state = icon_state + "_full"
	else if(amount >= MAXCOIL/2)
		icon_state = icon_state + "_uhalf"
	else if(amount > 0)
		icon_state = icon_state + "_lhalf"
	else //zero
		icon_state = icon_state + "_empty"

/obj/item/weapon/cable_coil/examine()
	set src in view(1)
	usr << "A deck of power cable. There are [amount] lengths of cable in the deck."

/obj/item/weapon/cable_coil/heavyduty/make_restraint()
	//set name = "HDMake Cable Restraints"
	set hidden = 1
	usr << "Stop trying to make restraints from heavy-duty cable, you ugly code-reader."
	return

/obj/item/weapon/cable_coil/heavyduty/attackby(obj/item/weapon/W, mob/user)
	return ..()
//can't merge heavyduty cable coils due to them not being
/obj/item/weapon/cable_coil/heavyduty/deck/attackby(obj/item/weapon/W, mob/user)
	..()
	//ADDS A CABLE

/obj/item/weapon/cable_coil/heavyduty/deck/use(var/used)
	if(src.amount < used)
		return 0
	else
		amount -= used
		updateicon()
		return 1

/obj/item/weapon/cable_coil/heavyduty/turf_place(turf/simulated/floor/F, mob/user)
/*
	if(locate(/obj/structure/heavyduty/cable, F))
		user << "HD cable already exists. If you want to change direction, cut it first and add a node."
		return
	if(var/obj/structure/heavyduty/node/N = locate(/obj/structure/heavyduty/node, F))
		if(N.loc == user.loc)
			if(N.dir & user.dir)
				user << "There's already cable attached to node in that direction."
				return
		else
			if(N.dir & user.dir.rotate(180))
				user << "There's already cable attached to node in that direction."
				return
*/

//SHOULD CHECK FOR NODE INSTEAD
/*
	if(!isturf(user.loc))
		return

	if(get_dist(F,user) > 1)
		user << "You can't lay cable at a place that far away."
		return

	if(F.intact)		// if floor is intact, complain
		user << "You can't lay cable there unless the floor tiles are removed."
		return

	else
		var/dirn

		if(user.loc == F)
			dirn = user.dir			// if laying on the tile we're on, lay in the direction we're facing
		else
			dirn = get_dir(F, user)

		for(var/obj/structure/heavyduty/cable/LC in F)


		var/obj/structure/cable/C = new(F)

		C.cableColor(color)

		C.d1 = 0
		C.d2 = dirn
		C.add_fingerprint(user)
		C.updateicon()

		var/datum/powernet/PN = new()
		PN.number = powernets.len + 1
		powernets += PN
		C.netnum = PN.number
		PN.cables += C

		C.mergeConnectedNetworks(C.d2)
		C.mergeConnectedNetworksOnTurf()


		use(1)
		if (C.shock(user, 50))
			if (prob(50)) //fail
				new/obj/item/weapon/cable_coil(C.loc, 1, C.color)
				del(C)
		//src.laying = 1
		//last = C
*/

/obj/item/weapon/cable_coil/heavyduty/cable_join(obj/structure/heavyduty/C, mob/user)
	if(istype (C, /obj/structure/heavyduty/node))
		turf_place(C.loc, user)
	else //cable
		usr << "You cannot connect heavy-duty cables directly. Use node to change direction."
	return

/obj/item/weapon/cable_coil/heavyduty/attack(mob/M as mob, mob/user as mob)
	return ..()
