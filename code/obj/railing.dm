/obj/railing
	name = "railing"
	desc = "Two sets of bars shooting onward with the sole goal of blocking you off. They can't stop you from vaulting over them though!"
	anchored = 0
	icon = 'icons/obj/objects.dmi'
	icon_state = "railing"
	color = "#ffffff"

	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if (istype(mover, /obj/projectile))
			var/obj/projectile/P = mover
			if (P.proj_data.window_pass)
				return 1

		if (get_dir(loc, target) == dir) // Check for appropriate border.
			return !density
		else
			return 1

	CheckExit(atom/movable/mover as mob, turf/target as turf)
		if (get_dir(loc, target) == dir)
			return !density
		else
			return 1

	orange
		color = "#ff7b00"
	
	red
		color = "#ff0000"