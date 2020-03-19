/obj/railing
	name = "railing"
	desc = "Two sets of bars shooting onward with the sole goal of blocking you off. They can't stop you from vaulting over them though!"
	anchored = 1
	density = 1
	icon = 'icons/obj/objects.dmi'
	icon_state = "railing"
	layer = 2.9
	color = "#ffffff"
	flags = FPRINT | USEDELAY | ON_BORDER | ALWAYS_SOLID_FLUID
	event_handler_flags = USE_FLUID_ENTER | USE_CHECKEXIT | USE_CANPASS
	dir = 2
	//list of atoms that can pass over rails!
	var/list/passable_things = list(/obj/projectile, 
	/obj/critter, 
	/obj/item, 
	/mob/living/carbon/human/monkey)

	New()
		..()
		SPAWN_DBG(1 DECI SECOND) // why are you like this why is this necessary
		if (dir == 2)
			layer = MOB_LAYER + 1
		else
			layer = OBJ_LAYER - 0.1


	CanPass(atom/movable/mover, turf/target)
		for (var/i=1, i <= src.passable_things.len, i++)
			if (istype(mover, src.passable_things[i]))
				return !density
		if (src.dir == SOUTHWEST || src.dir == SOUTHEAST || src.dir == NORTHWEST || src.dir == NORTHEAST)
			return 0
		if(get_dir(loc, target) == dir)
			return !density
		else
			return 1

	CheckExit(atom/movable/O as mob|obj, target as turf)
		if (!src.density)
			return 1
		if(istype(O, /obj/projectile))
			return !density
		if (get_dir(O.loc, target) == src.dir)
			return 0
		return 1
	
	Turn()
		..()
		if (dir == 2)
			layer = MOB_LAYER + 1
		else
			layer = OBJ_LAYER
			

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
		color = "#fbff00"

	purple
		color = "#cc00ff"

	blue
		color = "#0026ff"