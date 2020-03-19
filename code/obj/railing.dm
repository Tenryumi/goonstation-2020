/obj/railing
	name = "railing"
	desc = "Two sets of bars shooting onward with the sole goal of blocking you off. They can't stop you from vaulting over them though!"
	anchored = 1
	density = 1
	icon = 'icons/obj/objects.dmi'
	icon_state = "railing"
	layer = OBJ_LAYER - 0.1
	color = "#ffffff"
	flags = FPRINT | USEDELAY | ON_BORDER | ALWAYS_SOLID_FLUID
	event_handler_flags = USE_FLUID_ENTER | USE_CHECKEXIT | USE_CANPASS
	dir = SOUTH

	proc/layerify()
		if (dir == SOUTH)
			layer = MOB_LAYER + 1

		else if (dir == NORTH)
			layer = OBJ_LAYER - 0.2
		
		else
			layer = OBJ_LAYER - 0.1

	New()
		..()
		SPAWN_DBG(1 DECI SECOND) // why are you like this why is this necessary
		layerify()


	CanPass(atom/movable/O as mob|obj, turf/target, height=0, air_group=0)
		if (!src.density || (O.flags & TABLEPASS || istype(O, /obj/newmeteor)) )
			return 1
			world.log << "CanPass: [O.name] Is nodense / tablepass! Pass!"
		if(air_group || (height==0)) 
			return 1
			world.log << "CanPass: [O.name] Is air/height0! Pass!"
		if (src.dir == SOUTHWEST || src.dir == SOUTHEAST || src.dir == NORTHWEST || src.dir == NORTHEAST) // why would you be like this
			return 0
			world.log << "CanPass: [src.name] Is diagonal ([src.dir])! FAIL!"
		if(get_dir(loc, O) == dir)
			return !density
			world.log << "CanPass: [O.name] Not our dir! Pass!"
		else
			world.log << "CanPass: [O.name] Passed all checks! Pass!"
			return 1

	CheckExit(atom/movable/O as mob|obj, target as turf)
		if (!src.density)
			world.log << "CheckExit: [O.name] Is not dense! Pass!"
			return 1
		else if (!src.density || (O.flags & TABLEPASS || istype(O, /obj/newmeteor)) )
			world.log << "CheckExit: [O.name] Is nodense / tablepass! Pass!"
			return 1
		else if (get_dir(O.loc, target) == src.dir)
			world.log << "CheckExit: Same dir as ours ([src.dir])! FAIL!"
			return 0
		else
			world.log << "CheckExit: Passed all checks! Pass!"
			return 1
	
	Turn()
		..()
		layerify()
			

	/*CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		world.log << ("CANPASS TRIGGERED")
		if (istype(mover, /obj/projectile))
			var/obj/projectile/P = mover
			if (P.proj_data.window_pass)
				return 1
		world.log << ("DIR: [src.dir]")
		world.log << ("Get_DIR: [get_dir(loc, target)]")
		if (get_dir(loc, target) == dir) // Check for appropriate border.
			return !density
		else
			return 1

	CheckExit(atom/movable/mover as mob, turf/target as turf)
		world.log << ("CHECK EXIT TRIGGERED")
		world.log << ("Get_DIR: [get_dir(loc, target)]")
		if (get_dir(loc, target) == dir)
			return !density
		else
			return 1*/

	orange
		color = "#ff7b00"
	
	red
		color = "#ff0000"
	
	green
		color = "#09ff00"
	
	yellow
		color = "#ffe600"

	purple
		color = "#cc00ff"

	blue
		color = "#0026ff"