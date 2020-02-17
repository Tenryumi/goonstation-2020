// the underfloor wiring terminal for the APC
// autogenerated when an APC is placed
// all conduit connects go to this object instead of the APC
// using this solves the problem of having the APC in a wall yet also inside an area

/obj/machinery/power/terminal
	name = "terminal"
	icon_state = "term"
	desc = "An underfloor wiring terminal for power equipment"
	level = 1
	layer = FLOOR_EQUIP_LAYER1
	var/obj/machinery/power/master = null
	anchored = 1
	directwired = 0		// must have a cable on same turf connecting to terminal

/obj/machinery/power/terminal/New()
	..()
	var/turf/T = src.loc
	if(level==1) hide(T.intact)

/obj/machinery/power/terminal/disposing()
	if (src.powernet && src.powernet.data_nodes)
		src.powernet.data_nodes -= src
	if (src.master)
		if (istype(src.master,/obj/machinery/power/apc))
			var/obj/machinery/power/apc/APC = src.master
			if (APC.terminal == src)
				APC.terminal = null
	..()

/obj/machinery/power/terminal/hide(var/i)
	invisibility = i ? 101 : 0
	alpha = invisibility ? 128 : 255

//A regular terminal that can ferry signals between the network and the connected APC.
/obj/machinery/power/terminal/netlink
	use_datanet = 1

	receive_signal(datum/signal/signal)
		if(!signal)
			return

		//It can't pick up wireless transmissions
		if(signal.transmission_method != TRANSMISSION_WIRE)
			return

		if(src.master)
			src.master.receive_signal(signal)

		return


	proc
		post_signal(obj/source, datum/signal/signal)
			if(!src.powernet || !signal)
				return

			if(isnull(src.master) || source != src.master)
				return

			signal.transmission_method = TRANSMISSION_WIRE
			signal.channels_passed += "PN[src.netnum];"

			for(var/obj/machinery/power/device in src.powernet.data_nodes)
				if(device != src)
					device.receive_signal(signal, TRANSMISSION_WIRE)

			//qdel(signal)
			return

//Data terminal is pretty similar in appearance to the regular terminal
//It sends wired /datum/signal information between its master obj and other
//data terminals in its powernet's nodes.

/obj/machinery/power/data_terminal //The data terminal is remarkably similar to a regular terminal
	name = "data terminal"
	icon_state = "dterm"
	desc = "An underfloor connection point for power line communication equipment."
	level = 1
	layer = FLOOR_EQUIP_LAYER1
	anchored = 1
	directwired = 0
	use_datanet = 1
	mats = 5
	deconstruct_flags = DECON_SCREWDRIVER | DECON_CROWBAR | DECON_WELDER | DECON_WIRECUTTERS | DECON_MULTITOOL
	var/obj/master = null //It can be any obj that can use receive_signal

	ex_act()
		if (master)
			return

		return ..()

/obj/machinery/power/data_terminal

	New()
		..()

		var/turf/T = get_turf(src.loc)

		if(level==1) hide(T.intact)

	disposing()
		master = null
		..()

	receive_signal(datum/signal/signal)
		if(!signal)
			return

		//It can't pick up wireless transmissions
		if(signal.transmission_method != TRANSMISSION_WIRE)
			return

		if(src.master && is_valid_master(src.master))
			src.master.receive_signal(signal)

		return


	proc
		post_signal(obj/source, datum/signal/signal)
			if(!src.powernet || !signal)
				return

			if(source != src.master || !is_valid_master(src.master))
				return

			signal.transmission_method = TRANSMISSION_WIRE
			signal.channels_passed += "PN[src.netnum];"

			var/iterations = 0
			for(var/obj/machinery/power/device in src.powernet.data_nodes)
				if(device != src)
					device.receive_signal(signal, TRANSMISSION_WIRE)

				if (iterations/100 < 1)
					iterations = 0
					LAGCHECK(LAG_REALTIME)

				iterations++

			if (signal)
				if (!reusable_signals || reusable_signals.len > 10)
					signal.dispose()
				else
					signal.wipe()
					if (!(signal in reusable_signals))
						reusable_signals += signal
			return

		is_valid_master(obj/test_master)
			if(!test_master)
				//boutput(world, "no test master")
				return 0

			if(get_turf(test_master) != src.loc)
				//boutput(world, "[test_master] isn't on the same turf")
				return 0

			//boutput(world, "[test_master] is a valid master")
			return 1

	hide(var/i)
		invisibility = i ? 101 : 0
		alpha = invisibility ? 128 : 255
