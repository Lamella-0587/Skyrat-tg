// The general principle of operation of the latex sprayer copies the operation of a conventional single-shot grenade launcher.
// One grenade is charged, then a shot is fired, after which you need to remove the sleeve and load a new one.
// A living latex canister is used instead of a grenade.

// Latex Canister Receiver Class definition for Living latex sprayer
/obj/item/ammo_box/magazine/internal/latexbinreciever
	name = "Living latex sprayer internal magazine"
	ammo_type = /obj/item/ammo_casing/latexbin // A special type of ammunition. Defined below in code
	caliber = CALIBER_40MM // Look's like we don't need to set up our caliber for this gun
	max_ammo = 1 // Only one canister can be installed in a Living latex sprayer at a time

/obj/item/ammo_box/magazine/internal/latexbinreciever/Initialize(mapload)
	. = ..()
	stored_ammo = list()

// Latex Canister Class definition for Latex sprayer. Single Shot Latex sprayer Ammunition
/obj/item/ammo_casing/latexbin
	name = "living latex canister"
	desc = "A canister filled with a nanites. Used for firing a nanite latex sprayer. The canister is single-shot and cannot be refilled."
	caliber = CALIBER_40MM // Look's like we don't need to set up our caliber for this gun
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/latex_pulv.dmi'
	icon_state = "latexbin"
	projectile_type = /obj/projectile/bullet/livinglatexball
	var/list/latex_color_list = list("black", "pink", "teal", "yellow", "red", "green")
	var/latexcolors = null //List for color for color change menu
	var/latex_color = "black"
	var/list/latexbin_states = list("full","empty")
	var/latexbin_state = null
	var/color_changed = TRUE

//Latex bin init
/obj/item/ammo_casing/latexbin/Initialize()
	. = ..()
	populate_latex_colors()

	//random color variation on start. Because why not?
	latex_color = pick(latex_color_list)
	update_icon_state()
	update_icon()

	var/obj/item/ammo_casing/latexbin/B = src
	var/obj/projectile/bullet/livinglatexball/P = B.loaded_projectile
	P.latex_ball_color = latex_color
	latexbin_state = "[initial(icon_state)]_[latex_color]_[latexbin_states[1]]"
	icon_state = "[latexbin_state]"

//Latex bin examine
/obj/item/ammo_casing/latexbin/examine(mob/user)
	.=..()
	if(color_changed == FALSE)
		. += "<span class='notice'>Alt-Click \the [src.name] to customize it.</span>"

// Latex ball class definition
/obj/projectile/bullet/livinglatexball
	name ="living latexball"
	desc = "USE A LIVING LATEX SPRAYER"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/latex_pulv.dmi'
	icon_state= "latex_projectile"
	damage = 0 // Living latex ball does not damage targets
	nodamage = TRUE // Duplicate the lack of damage with a special parameter
	hitsound = 'sound/weapons/pierce.ogg' // LAMELLA TODO: Need a hit sound
	hitsound_wall = "ricochet" // LAMELLA TODO: Need a hit wall sound
	embedding = null
	shrapnel_type = null
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	shrapnel_type = /obj/item/shrapnel/livinglatexball
	ricochets = 0
	ricochets_max = 0
	ricochet_chance = 0
	var/list/latexprogram = list() // List of item types that are recorded in the latex program
	var/latex_ball_color = "black" // Default latex color
	range = 4 // max range befor latex ball drops down

// Latex balloon initialization. Set color
/obj/projectile/bullet/livinglatexball/Initialize(mapload)
	. = ..()
	icon_state = "[initial(icon_state)]_[latex_ball_color]"
	update_icon_state()

// Icon state update handler
/obj/projectile/bullet/livinglatexball/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]_[latex_ball_color]"

// Handler for the event when the shot has reached the maximum distance. Drop decal on the floor
/obj/projectile/bullet/livinglatexball/on_range()
	if(isopenturf(src.loc))
		new /obj/effect/decal/cleanable/latexdecal(loc, latex_ball_color)
	. = ..()


// LAMELLA TODO: Need a general special effect setting
// Defines of the special effect of being hit by live latex
/obj/effect/temp_visual/livinglatexhit
	name = "\improper Living latex hit"
	desc = "A black lump of living latex stuck to the target and then quickly enveloped it in its black tentacles, completely covering the entire body in an even layer." // LAMELA TODO: A description of the hit effect is needed.
	//icon = 'icons/effects/beam_splash.dmi' // LAMELA TODO: We need a file with the effects of a ball of latex.
	//icon_state = "living_latex_hit"
	layer = ABOVE_ALL_MOB_LAYER
	pixel_x = 0
	pixel_y = 0
	duration = 10 //Time in deciseconds that the effect will be displayed

// Class definition depicting a ball of live latex
/obj/item/shrapnel/livinglatexball
	name = "livinglatexball"
	//icon = 'icons/obj/guns/ammo.dmi' // LAMELLA TODD: Need a file with a picture of a ball of living latex
	//icon_state = "livinglatexball"
	embedding = null // embedding vars are taken from the projectile itself

// Hit handler
/obj/projectile/bullet/livinglatexball/on_hit(mob/target, blocked = FALSE)
	..() // Standard hit tests.

	if(isliving(target))
		// Let's throw off all the objects from the character before applying the latex.
		// Standard admin drop all cycle
		for(var/obj/item/W in target)
			if(!target.dropItemToGround(W))
				qdel(W)
				target.regenerate_icons()

		// Apply latex garments to the character
		if(ishuman(target))
			livinglatexspread(target)
	else if(isopenturf(target.loc))
		new /obj/effect/decal/cleanable/latexdecal(loc, latex_ball_color)


	return BULLET_ACT_HIT

// Handler for spreading live latex to target.
/obj/projectile/bullet/livinglatexball/proc/livinglatexspread(mob/target)
	var/mob/living/carbon/human/H = target

	//Turn target mob to south direction
	H.setDir(SOUTH)

	// //Immobilize target for latex animation duration
	//H.Immobilize(10000, TRUE)

	//Paralyze target for latex animation duration
	H.Paralyze(10000, TRUE)


	//H.livniglatexspread (10000, TRUE)

	var/list/items = list()
	for (var/T in src.latexprogram)

		var/obj/item/I = T
		I = new I
		items.Add(I)

	for(var/obj/item/I in items)
		var/slot = I.slot_flags
		var/obj/item/E = target.get_item_by_slot(slot)
		if(E != null)
			target.dropItemToGround(E, TRUE, TRUE)
			qdel(E)
		target.equip_to_slot(I, slot)
	target.regenerate_icons()

/// Latex color changing
// Create colors for color change menu items
/obj/item/ammo_casing/latexbin/proc/populate_latex_colors()
	latexcolors = list(
		"black" = image(icon = src.icon, icon_state = "latexbin_black_full"),
		"pink" = image(icon = src.icon, icon_state = "latexbin_pink_full"),
		"teal" = image(icon = src.icon, icon_state = "latexbin_teal_full"),
		"green" = image(icon = src.icon, icon_state = "latexbin_green_full"),
		"yellow" = image(icon = src.icon, icon_state = "latexbin_yellow_full"),
		"red" = image(icon = src.icon, icon_state = "latexbin_red_full"))

// Checking if we can use the menu
/obj/item/ammo_casing/latexbin/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

// Radial menu handler for color selection by using altclick
/obj/item/ammo_casing/latexbin/AltClick(mob/user, obj/item/I)
	. = ..()
	if(.)
		return FALSE

	var/choice = show_radial_menu(user,src, latexcolors, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
	if(!choice)
		return TRUE
	latex_color = choice
	update_icon()

	var/obj/item/ammo_casing/latexbin/B = src
	var/obj/projectile/bullet/livinglatexball/P = B.loaded_projectile
	if(P)
		P.latex_ball_color = latex_color
		P.update_icon_state()
	color_changed = TRUE
	to_chat(user, span_notice("You change the color of the latex in the bin."))
	return TRUE

/////////////////////////////////
///	FUNCTION OVERRIDE SECTION ///
/////////////////////////////////

// Redefining the function of installing a magazine in a weapon to replace the sound
/obj/item/ammo_box/attackby(obj/item/A, mob/user, params, silent = FALSE, replace_spent = 0)
	var/num_loaded = 0
	if(!can_load(user))
		return
	if(istype(A, /obj/item/ammo_box))
		var/obj/item/ammo_box/AM = A
		for(var/obj/item/ammo_casing/AC in AM.stored_ammo)
			var/did_load = give_round(AC, replace_spent)
			if(did_load)
				AM.stored_ammo -= AC
				num_loaded++
			if(!did_load || !multiload)
				break
		if(num_loaded)
			AM.update_ammo_count()
	if(istype(A, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/AC = A
		if(give_round(AC, replace_spent))
			user.transferItemToLoc(AC, src, TRUE)
			num_loaded++
			AC.update_appearance()

	if(num_loaded)
		if(!silent)
			to_chat(user, span_notice("You load [num_loaded] shell\s into \the [src]!"))
			playsound(src, 'sound/weapons/gun/general/mag_bullet_insert.ogg', 60, TRUE) // LAMELLA TODO: Need the sound of inserting the latex canister into the sprayer
		update_ammo_count()

	return num_loaded

// Redefining the function of uninstalling a magazine in a weapon to replace the sound
/obj/item/ammo_box/attack_self(mob/user)
	var/obj/item/ammo_casing/A = get_round()
	if(!A)
		return

	A.forceMove(drop_location())
	if(!user.is_holding(src) || !user.put_in_hands(A)) //incase they're using TK
		A.bounce_away(FALSE, NONE)
	playsound(src, 'sound/weapons/gun/general/mag_bullet_insert.ogg', 60, TRUE) // LAMELLA TODO: Need the sound of taking out the latex canister into the sprayer
	to_chat(user, span_notice("You remove a round from [src]!"))
	update_ammo_count()

// Blocking the action with a wrench
/obj/item/gun/ballistic/wrench_act(mob/living/user, obj/item/I)
	to_chat(user, "You cannot find any way to accept the wrench to [src]. It doesn't fit anywhere.")
	return

// Blocking the action with a screwdriver
/obj/item/gun/screwdriver_act(mob/living/user, obj/item/I)
	to_chat(user, "It seems there is nothing to unscrew. You don't see a single screw.")
	return

//Blocking the action with a welder
/obj/item/gun/welder_act(mob/living/user, obj/item/I)
	to_chat(user, "Nothing to weld here...")
	return

// Blocking the action with a wirecutter
/obj/item/gun/wirecutter_act(mob/living/user, obj/item/I)
	to_chat(user, "You don't see any wires or anything like that.")
	return

// Extension for the icon state update handler
/obj/item/ammo_casing/latexbin/update_icon_state()
	..()
	if(loaded_projectile)
		icon_state = "[initial(icon_state)]_[latex_color]_[latexbin_states[1]]"
	else
		icon_state = "[initial(icon_state)]_[latex_color]_[latexbin_states[2]]"

// Local version of the projectile readiness processor
/obj/item/ammo_casing/latexbin/ready_proj(atom/target, mob/living/user, quiet, zone_override = "", atom/fired_from)
	if (!loaded_projectile)
		return
	loaded_projectile.original = target
	loaded_projectile.firer = user
	loaded_projectile.fired_from = fired_from
	loaded_projectile.hit_prone_targets = user.combat_mode
	if (zone_override)
		loaded_projectile.def_zone = zone_override
	else
		loaded_projectile.def_zone = user.zone_selected
	loaded_projectile.suppressed = quiet

	if(isgun(fired_from))
		var/obj/item/gun/G = fired_from
		loaded_projectile.damage *= G.projectile_damage_multiplier
		loaded_projectile.stamina *= G.projectile_damage_multiplier

	if(reagents && loaded_projectile.reagents)
		reagents.trans_to(loaded_projectile, reagents.total_volume, transfered_by = user) //For chemical darts/bullets
		qdel(reagents)

////////////////////////////////////////////////
/// LIVING LATEX SPRAYER USER MANUAL SECTION ///
////////////////////////////////////////////////
/obj/item/book/manual/latex_pulv_manual
	name = "latex kit instructions"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state ="paper"
	worn_icon_state = "paper"
	desc = "Crack it open, inhale the musk of its pages, and learn something new."
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL  //upped to three because books are, y'know, pretty big. (and you could hide them inside eachother recursively forever)
	attack_verb_continuous = list("bashes", "whacks", "educates")
	attack_verb_simple = list("bash", "whack", "educate")
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/items/handling/book_drop.ogg'
	pickup_sound =  'sound/items/handling/book_pickup.ogg'
	//dat //Actual page content
	//due_date = 0 //Game time in 1/10th seconds
	//author //Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	//unique = FALSE //false - Normal book, true - Should not be treated as normal book, unable to be copied, unable to be modified
	//title //The real name of the book.
	//window_size = null // Specific window size for the book, i.e: "1920x1080", Size x Width

// Manulal initialization handler. Fill in the content of the manual
/obj/item/book/manual/latex_pulv_manual/Initialize(mapload)
		. = ..()
		dat = {"<html>
				<head>
				<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {list-style: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				</style>
				</head>
				<body>
				<h3>Growing Humans</h3>

				Why would you want to grow humans? Well, I'm expecting most readers to be in the slave trade, but a few might actually
				want to revive fallen comrades. Growing pod people is actually quite simple:
				<p>
				<ol>
				<li>Find a dead person who is in need of revival. </li>
				<li>Take a blood sample with a syringe (samples of their blood taken BEFORE they died will also work). </li>
				<li>Inject a packet of replica pod seeds (which can be acquired by either mutating cabbages into replica pods (and then harvesting said replica pods) or by purchasing them from certain corporate entities) with the blood sample. </li>
				<li>It is imperative to understand that injecting the replica pod plant with blood AFTER it has been planted WILL NOT WORK; you have to inject the SEED PACKET, NOT the TRAY. </li>
				<li>Plant the seeds. </li>
				<li>Tend to the replica pod's water and nutrition levels until it is time to harvest the podcloned humanoid. </li>
				<li>Note that if the corpse's mind (or spirit, or soul, or whatever the hell your local chaplain calls it) is already in a new body or has left this plane of existence entirely, you will just receive seed packets upon harvesting the replica pod plant, not a podperson. </li>
				</ol>
				<p>
				It really is that easy! Good luck!

				</body>
				</html>
				"}

//////////////////////////////////////
/// LIVING LATEX DISSOLVER SECTION ///
//////////////////////////////////////
/obj/item/reagent_containers/spray/livinglatexdissolver
	name = "Nanite latex dissolver"
	desc = "The special solvent that dissolves nanites, that used for the imitation of living latex. Safe for skin and mucous membranes."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/latex_pulv.dmi'
	icon_state = "latex_dissolver"
	inhand_icon_state = "latex_dissolver"
	lefthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	volume = 10
	stream_range = 2
	amount_per_transfer_from_this = 5
	list_reagents = list(/datum/reagent/consumable/livinlatexdissolver = 10)


/// Reagent for Removing Live Latex Items
/datum/reagent/consumable/livinlatexdissolver
	name = "Nanite latex solvent"
	description = "A chemical agent used for dissolve a nanite latex materials."
	color = "#549681" // rgb: 84, 150, 129
	taste_description = "spicy and sour"
	penetrates_skin = NONE
	ph = 7.4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// Handler applying dissolver to mob
/datum/reagent/consumable/livinlatexdissolver/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(!ishuman(exposed_mob))
		return

	var/mob/living/carbon/victim = exposed_mob

	if(methods & (TOUCH|VAPOR))
		for(var/obj/item/W in victim)
			if(LAZYLEN(W.custom_materials) > 0)
				for(var/datum/material/M in W.custom_materials)
					if(istype(M, /datum/material/livinglatex))
						qdel(W)
		victim.regenerate_icons()

// Living latex material
/datum/material/livinglatex
	name = "living latex"
	desc = "living latex"
	color = "#242424"
	greyscale_colors = "#242424"
	strength_modifier = 0.85
	sheet_type = /obj/item/stack/sheet/plastic // LAMELLA TODO: вероятно нам потребуется специальная визуализация для материала
	categories = list(MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	value_per_unit = 0.0125
	beauty_modifier = -0.01
	armor_modifiers = list(MELEE = 1.5, BULLET = 1.1, LASER = 0.3, ENERGY = 0.5, BOMB = 1, BIO = 1, RAD = 1, FIRE = 1.1, ACID = 1)

// Handler for accidental material consumption
/datum/material/livinglatex/on_accidental_mat_consumption(mob/living/carbon/eater, obj/item/food)
	//LAMELLA TODO: Нужно прикинуть что будет если схавать живой латекс.
	eater.reagents.add_reagent(/datum/reagent/livinglatex, rand(6, 8))
	food?.reagents?.add_reagent(/datum/reagent/livinglatex, food.reagents.total_volume*(2/5))
	return TRUE

// Living latex reagent
/datum/reagent/livinglatex
	name = "living latex"
	description = "the latex based components mixed with nanites."
	color = "#242424"
	taste_description = "latex"
	ph = 6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// General description of the class of latex decal
/obj/effect/decal/cleanable/latexdecal
	name = "living latex"
	desc = "It's greasy. Looks like Beepsky made another mess."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/latex_pulv.dmi'
	icon_state = "latex_decal"
	//random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7")
	blood_state = BLOOD_STATE_OIL
	bloodiness = BLOOD_AMOUNT_PER_DECAL
	beauty = -100
	clean_type = CLEAN_TYPE_BLOOD

// Latex initialization, add latex reagent to the decal
/obj/effect/decal/cleanable/latexdecal/Initialize(mapload, var/color = "black")
	. = ..()
	reagents.add_reagent(/datum/reagent/livinglatex, 30)
	icon_state = "[initial(icon_state)]_[color]"

// Handler for affecting something on the decall
/obj/effect/decal/cleanable/latexdecal/attackby(obj/item/I, mob/living/user)

	// If it's hot, then we set fire to the latex
	var/attacked_by_hot_thing = I.get_temperature()
	if(attacked_by_hot_thing)
		visible_message(span_warning("[user] tries to ignite [src] with [I]!"), span_warning("You try to ignite [src] with [I]."))
		log_combat(user, src, (attacked_by_hot_thing < 480) ? "tried to ignite" : "ignited", I)
		fire_act(attacked_by_hot_thing)
		return
	return ..() // Otherwise the default actions

// Handler for the decal's ability to ignite
/obj/effect/decal/cleanable/latexdecal/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature < 480)
		return
	visible_message(span_danger("[src] catches fire!"))
	var/turf/T = get_turf(src)
	qdel(src)
	new /obj/effect/hotspot(T)

// Adding a slip effect when driving on a decal without anti-slip protection
/obj/effect/decal/cleanable/latexdecal/slippery/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/slippery, 80, (NO_SLIP_WHEN_WALKING | SLIDE))
