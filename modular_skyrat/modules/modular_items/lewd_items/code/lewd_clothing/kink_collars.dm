///////////////////
///NORMAL COLLAR///
///////////////////

//To determine what kind of stuff we can put in collar.

/datum/component/storage/concrete/pockets/small/kink_collar
	max_items = 1

/datum/component/storage/concrete/pockets/small/kink_collar/Initialize()
	. = ..()
	can_hold = typecacheof(list(
	/obj/item/food/cookie,
	/obj/item/food/cookie/sugar))

/datum/component/storage/concrete/pockets/small/kink_collar/locked/Initialize()
	. = ..()
	can_hold = typecacheof(list(
	/obj/item/food/cookie,
	/obj/item/food/cookie/sugar,
	/obj/item/key/kink_collar))

/datum/component/storage/concrete/pockets/small/mind_collar/Initialize()
	. = ..()
	max_items = 1
	can_hold = typecacheof(/obj/item/connect/mind_controller)

//Here goes code for normal collar

/obj/item/clothing/neck/kink_collar
	name = "collar"
<<<<<<< HEAD
	desc = "Nice and tight collar, that fits perfectly to skin"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_neck.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_neck.dmi'
	icon_state = "collar"
	inhand_icon_state = "collar"
=======
	desc = "A nice, tight collar. It fits perfectly to your skin"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_neck.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_neck.dmi'
	icon_state = "collar_cyan"
	inhand_icon_state = "collar_cyan"
>>>>>>> upstream/master
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_NECK
	w_class = WEIGHT_CLASS_SMALL
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/small/kink_collar
	var/tagname = null
	var/treat_path = /obj/item/food/cookie
<<<<<<< HEAD
	var/current_color = "cyan"
	var/color_changed = FALSE
	var/static/list/collar_designs

//create radial menu
/obj/item/clothing/neck/kink_collar/proc/populate_collar_designs()
	collar_designs = list(
		"cyan" = image (icon = src.icon, icon_state = "collar_cyan"),
		"yellow" = image(icon = src.icon, icon_state = "collar_yellow"),
		"green" = image(icon = src.icon, icon_state = "collar_green"),
		"red" = image(icon = src.icon, icon_state = "collar_red"),
		"latex" = image(icon = src.icon, icon_state = "collar_latex"),
		"orange" = image(icon = src.icon, icon_state = "collar_orange"),
		"white" = image(icon = src.icon, icon_state = "collar_white"),
		"purple" = image(icon = src.icon, icon_state = "collar_purple"),
		"black" = image(icon = src.icon, icon_state = "collar_black"),
		"tealblack" = image(icon = src.icon, icon_state = "collar_tealblack"),
		"spike" = image(icon = src.icon, icon_state = "collar_spike"))
=======
	unique_reskin = list("Cyan" = "collar_cyan",
						"Yellow" = "collar_yellow",
						"Green" = "collar_green",
						"Red" = "collar_red",
						"Latex" = "collar_latex",
						"Orange" = "collar_orange",
						"White" = "collar_white",
						"Purple" = "collar_purple",
						"Black" = "collar_black",
						"Black-teal" = "collar_tealblack",
						"Spike" = "collar_spike")
>>>>>>> upstream/master

//spawn thing in collar

/obj/item/clothing/neck/kink_collar/Initialize()
	. = ..()
	var/Key
	if(treat_path)
		Key = new treat_path(src)
		if(istype(Key,/obj/item/key/kink_collar))
			var/id = rand(111111,999999)
			var/obj/item/clothing/neck/kink_collar/locked/L = src
			var/obj/item/key/kink_collar/K = Key
			L.key_id = id
			K.key_id = id

<<<<<<< HEAD
	//to spawn icon properly
	update_icon_state()
	update_icon()
	if(!length(collar_designs))
		populate_collar_designs()

	//random color variation on start. Because why not?
	current_color = pick(collar_designs)
	update_icon_state()
	update_icon()

//reskin code
/obj/item/clothing/neck/kink_collar/AltClick(mob/user, obj/item/I)
	if(color_changed == FALSE)
		. = ..()
		if(.)
			return
		var/choice = show_radial_menu(user,src, collar_designs, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		current_color = choice
		update_icon()
		color_changed = TRUE
	else
		return

//to check if we can change collar's model
/obj/item/clothing/neck/kink_collar/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/clothing/neck/kink_collar/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]_[current_color]"
	inhand_icon_state = "[initial(icon_state)]_[current_color]"
=======
//reskin code

/obj/item/clothing/neck/kink_collar/AltClick(mob/user)
	. = ..()
	if(unique_reskin && !current_skin && user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY))
		reskin_obj(user)
>>>>>>> upstream/master

//rename collar code

/obj/item/clothing/neck/kink_collar/attack_self(mob/user)
	tagname = stripped_input(user, "Would you like to change the name on the tag?", "Name your new pet", "Spot", MAX_NAME_LEN)
	name = "[initial(name)] - [tagname]"

<<<<<<< HEAD
//examine stuff

/obj/item/clothing/neck/kink_collar/examine(mob/user)
	.=..()
	if(color_changed == FALSE)
		. += "<span class='notice'>Alt-Click \the [src.name] to customize it.</span>"

=======
>>>>>>> upstream/master
////////////////////////
///COLLAR WITH A LOCK///
////////////////////////

/obj/item/clothing/neck/kink_collar/locked
	name = "locked collar"
<<<<<<< HEAD
	desc = "Tight collar. Looks like it have some kind of key lock on it."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_neck.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_neck.dmi'
	icon_state = "lock_collar"
	inhand_icon_state = "lock_collar"
=======
	desc = "A tight collar. It looks like it has some kind of lock."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_neck.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_neck.dmi'
	icon_state = "lock_collar_cyan"
	inhand_icon_state = "lock_collar_cyan"
>>>>>>> upstream/master
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/small/kink_collar/locked
	treat_path = /obj/item/key/kink_collar
	var/lock = FALSE
	var/broke = FALSE
	var/key_id = null //Adding unique id to collar
<<<<<<< HEAD
	var/static/list/lock_collar_designs

//create radial menu
/obj/item/clothing/neck/kink_collar/locked/proc/populate_lock_collar_designs()
	lock_collar_designs = list(
		"cyan" = image (icon = src.icon, icon_state = "lock_collar_cyan"),
		"yellow" = image(icon = src.icon, icon_state = "lock_collar_yellow"),
		"green" = image(icon = src.icon, icon_state = "lock_collar_green"),
		"red" = image(icon = src.icon, icon_state = "lock_collar_red"),
		"latex" = image(icon = src.icon, icon_state = "lock_collar_latex"),
		"orange" = image(icon = src.icon, icon_state = "lock_collar_orange"),
		"white" = image(icon = src.icon, icon_state = "lock_collar_white"),
		"purple" = image(icon = src.icon, icon_state = "lock_collar_purple"),
		"black" = image(icon = src.icon, icon_state = "lock_collar_black"),
		"tealblack" = image(icon = src.icon, icon_state = "lock_collar_tealblack"),
		"spike" = image(icon = src.icon, icon_state = "lock_collar_spike"))

//reskin code

/obj/item/clothing/neck/kink_collar/locked/AltClick(mob/user, obj/item/I)
	if(color_changed == FALSE)
		var/choice = show_radial_menu(user,src, lock_collar_designs, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		current_color = choice
		update_icon()
		color_changed = TRUE
	else
		return

//initialize
/obj/item/clothing/neck/kink_collar/locked/Initialize()
	. = ..()
	update_icon_state()
	update_icon()
	if(!length(lock_collar_designs))
		populate_lock_collar_designs()
=======
	unique_reskin = list("Cyan" = "lock_collar_cyan",
						"Yellow" = "lock_collar_yellow",
						"Green" = "lock_collar_green",
						"Red" = "lock_collar_red",
						"Latex" = "lock_collar_latex",
						"Orange" = "lock_collar_orange",
						"White" = "lock_collar_white",
						"Purple" = "lock_collar_purple",
						"Black" = "lock_collar_black",
						"Black-teal" = "lock_collar_tealblack",
						"Spike" = "lock_collar_spike")

//spawn thing in collar

//reskin code

/obj/item/clothing/neck/kink_collar/locked/AltClick(mob/user)
	. = ..()
	if(unique_reskin && !current_skin && user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY))
		reskin_obj(user)
>>>>>>> upstream/master

//locking or unlocking collar code

/obj/item/clothing/neck/kink_collar/locked/proc/IsLocked(var/L,mob/user)
	if(!broke)
		if(L == TRUE)
<<<<<<< HEAD
			to_chat(user, "<span class='warning'>With a click the collar locks!</span>")
			lock = TRUE
		if(L == FALSE)
			to_chat(user, "<span class='warning'>With a click the collar unlocks!</span>")
			lock = FALSE
			REMOVE_TRAIT(src, TRAIT_NODROP, TRAIT_NODROP)
	else
		to_chat(user, "<span class='warning'>Looks like the lock is broken. Now it is an ordinary collar.</span>")
=======
			to_chat(user, span_warning("The collar locks with a resounding click!"))
			lock = TRUE
		if(L == FALSE)
			to_chat(user, span_warning("The collar unlocks with a small clunk."))
			lock = FALSE
			REMOVE_TRAIT(src, TRAIT_NODROP, TRAIT_NODROP)
	else
		to_chat(user, span_warning("It looks like the lock is broken - now it's just an ordinary old collar."))
>>>>>>> upstream/master
		lock = FALSE
		REMOVE_TRAIT(src, TRAIT_NODROP, TRAIT_NODROP)

/obj/item/clothing/neck/kink_collar/locked/attackby(obj/item/K, mob/user, params)
	var/obj/item/clothing/neck/kink_collar/locked/collar = src
	if(istype(K, /obj/item/key/kink_collar))
		var/obj/item/key/kink_collar/key = K
		if(key.key_id==collar.key_id)
			if(lock != FALSE)
				IsLocked(FALSE,user)
			else
				IsLocked(TRUE,user)
		else
<<<<<<< HEAD
			to_chat(user,"<span class='warning'>Looks like it's a wrong key!</span>")
=======
			to_chat(user, span_warning("This isn't the correct key!"))
>>>>>>> upstream/master
	return

/obj/item/clothing/neck/kink_collar/locked/equipped(mob/living/U, slot)
	.=..()
	var/mob/living/carbon/human/H = U
	if(lock == TRUE && src == H.wear_neck)
		ADD_TRAIT(src, TRAIT_NODROP, TRAIT_NODROP)
<<<<<<< HEAD
		to_chat(H, "<span class='warning'>You heard a suspicious click. Looks like the collar now is locked on your neck!</span>")
=======
		to_chat(H, span_warning("You hear a suspicious click around your neck - it seems the collar is now locked!"))
>>>>>>> upstream/master

//this code prevents wearer from taking collar off if it's locked. Have fun!

/obj/item/clothing/neck/kink_collar/locked/attack_hand(mob/user)
	if(loc == user && user.get_item_by_slot(ITEM_SLOT_NECK) && lock != FALSE)
<<<<<<< HEAD
		to_chat(user, "<span class='warning'>The collar is locked! You'll need unlock the collar before you can take it off!</span>")
		return
	add_fingerprint(usr)
	..()
=======
		to_chat(user, span_warning("The collar is locked! You'll need to unlock it before you can take it off!"))
		return
	add_fingerprint(usr)
	return ..()
>>>>>>> upstream/master

/obj/item/clothing/neck/kink_collar/locked/MouseDrop(atom/over_object)
	var/mob/M = usr
	if(loc == usr && usr.get_item_by_slot(ITEM_SLOT_NECK) && lock != FALSE && istype(over_object, /atom/movable/screen/inventory/hand))
<<<<<<< HEAD
		to_chat(usr, "<span class='warning'>The collar is locked! You'll need unlock the collar before you can take it off!</span>")
=======
		to_chat(usr, span_warning("The collar is locked! You'll need to unlock it before you can take it off!"))
>>>>>>> upstream/master
		return
	var/atom/movable/screen/inventory/hand/H = over_object
	if(M.putItemFromInventoryInHandIfPossible(src, H.held_index))
		add_fingerprint(usr)
<<<<<<< HEAD
	..()
=======
	return ..()
>>>>>>> upstream/master

//This is a KEY moment of this code. You got it. Key.
//...
//It's 2:56 of 08.04.2021, i want to sleep. Please laugh.

/obj/item/key/kink_collar
	name = "kink collar key"
	desc = "A key for a tiny lock on a collar or bag."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	icon_state = "collar_key"
	var/keyname = null//name of our key. It's null by default.
	var/key_id = null //Adding same unique id to key
<<<<<<< HEAD
	var/current_color = "metal"
	var/color_changed = FALSE
	var/static/list/key_designs

//create radial menu
/obj/item/key/kink_collar/proc/populate_key_designs()
	key_designs = list(
		"cyan" = image (icon = src.icon, icon_state = "collar_key_cyan"),
		"yellow" = image(icon = src.icon, icon_state = "collar_key_yellow"),
		"green" = image(icon = src.icon, icon_state = "collar_key_green"),
		"red" = image(icon = src.icon, icon_state = "collar_key_red"),
		"latex" = image(icon = src.icon, icon_state = "collar_key_latex"),
		"orange" = image(icon = src.icon, icon_state = "collar_key_orange"),
		"white" = image(icon = src.icon, icon_state = "collar_key_white"),
		"purple" = image(icon = src.icon, icon_state = "collar_key_purple"),
		"black" = image(icon = src.icon, icon_state = "collar_key_black"),
		"tealblack" = image(icon = src.icon, icon_state = "collar_key_tealblack"),
		"metal" = image(icon = src.icon, icon_state = "collar_key_metal"))

//initialize stuff

/obj/item/key/kink_collar/Initialize()
	. = ..()
	//to spawn icon properly
	update_icon_state()
	update_icon()
	if(!length(key_designs))
		populate_key_designs()

	//random color variation on start. Because why not?
	current_color = pick(key_designs)
	update_icon_state()
	update_icon()

//changing color of key in case if we using multiple collars
/obj/item/key/kink_collar/AltClick(mob/user, obj/item/I)
	if(color_changed == FALSE)
		. = ..()
		if(.)
			return
		var/choice = show_radial_menu(user,src, key_designs, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		current_color = choice
		update_icon()
		color_changed = TRUE
	else
		return

//to check if we can change collar's model
/obj/item/key/kink_collar/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/key/kink_collar/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]_[current_color]"
	inhand_icon_state = "[initial(icon_state)]_[current_color]"
=======
	unique_reskin = list("Cyan" = "collar_key_blue",
						"Yellow" = "collar_key_yellow",
						"Green" = "collar_key_green",
						"Red" = "collar_key_red",
						"Latex" = "collar_key_latex",
						"Orange" = "collar_key_orange",
						"White" = "collar_key_white",
						"Purple" = "collar_key_purple",
						"Black" = "collar_key_black",
						"Metal" = "collar_key",
						"Black-teal" = "collar_key_tealblack")

//changing color of key in case if we using multiple collars
/obj/item/key/kink_collar/AltClick(mob/user)
	. = ..()
	if(unique_reskin && !current_skin && user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY))
		reskin_obj(user)
>>>>>>> upstream/master

//changing name of key in case if we using multiple collars with same color
/obj/item/key/kink_collar/attack_self(mob/user)
	keyname = stripped_input(user, "Would you like to change the name on the key?", "Renaming key", "Key", MAX_NAME_LEN)
	name = "[initial(name)] - [keyname]"

//we checking if we can open collar with THAT KEY with SAME ID as the collar.
/obj/item/key/kink_collar/attack(mob/living/M, mob/living/user, params)
	. = ..()
	var/mob/living/carbon/target = M
	if(istype(target.wear_neck,/obj/item/clothing/neck/kink_collar/locked/))
		var/obj/item/key/kink_collar/key = src
		var/obj/item/clothing/neck/kink_collar/locked/collar = target.wear_neck
		if(collar.key_id == key.key_id)
			if(collar.lock != FALSE)
				collar.IsLocked(FALSE,user)
			else
				collar.IsLocked(TRUE,user)
		else
<<<<<<< HEAD
			to_chat(user,"<span class='warning'>Looks like it's a wrong key!</span>")
=======
			to_chat(user, span_warning("This isn't the correct key!"))
>>>>>>> upstream/master
	return

/obj/item/circular_saw/attack(mob/living/M, mob/living/user, params)
	. = ..()
	var/mob/living/carbon/target = M
	if(istype(target.wear_neck,/obj/item/clothing/neck/kink_collar/locked/))
		var/obj/item/clothing/neck/kink_collar/locked/collar = target.wear_neck
		if(!collar.broke)
			if(target != user)
<<<<<<< HEAD
				to_chat(user, "<span class='warning'>You try to cut collar lock!</span>")
=======
				to_chat(user, span_warning("You try to cut the lock right off!"))
>>>>>>> upstream/master
				if(do_after(user, 20, target))
					collar.broke = TRUE
					collar.IsLocked(FALSE,user)
					if(rand(0,2) == 0) //chance to get damage
<<<<<<< HEAD
						to_chat(user, "<span class='warning'>You broke the collar lock, but [target.name] have sevaral cuts!</span>")
						target.apply_damage(rand(1,4),BRUTE,BODY_ZONE_HEAD,wound_bonus=10)
					else
						to_chat(user, "<span class='warning'>You broke the collar lock!</span>")
			else
				to_chat(user, "<span class='warning'>You try to cut collar lock!</span>")
				if(do_after(user, 30, target))
					if(rand(0,2) == 0)
						to_chat(user, "<span class='warning'>You broke the collar lock and got sevaral cuts!</span>")
=======
						to_chat(user, span_warning("You successfully cut away the lock, but gave [target.name] several cuts in the process!"))
						target.apply_damage(rand(1,4),BRUTE,BODY_ZONE_HEAD,wound_bonus=10)
					else
						to_chat(user, span_warning("You successfully cut away the lock!"))
			else
				to_chat(user, span_warning("You try to cut the lock right off!"))
				if(do_after(user, 30, target))
					if(rand(0,2) == 0)
						to_chat(user, span_warning("You successfully cut away the lock, but gave yourself several cuts in the process!"))
>>>>>>> upstream/master
						collar.broke = TRUE
						collar.IsLocked(FALSE,user)
						target.apply_damage(rand(2,4),BRUTE,BODY_ZONE_HEAD,wound_bonus=10)
					else
<<<<<<< HEAD
						to_chat(user, "<span class='warning'>You you didn't break the collar lock and got sevaral cuts!</span>")
						target.apply_damage(rand(3,5),BRUTE,BODY_ZONE_HEAD,wound_bonus=30)
		else
			to_chat(user, "<span class='warning'>Looks like the lock is broken.</span>")

//examine stuff

/obj/item/key/kink_collar/examine(mob/user)
	.=..()
	. += "<span class='notice'>It can be customized by Alt-click.</font>\n"
=======
						to_chat(user, span_warning("You fail to cut away the lock, cutting yourself in the process!"))
						target.apply_damage(rand(3,5),BRUTE,BODY_ZONE_HEAD,wound_bonus=30)
		else
			to_chat(user, span_warning("The lock is already broken!"))
>>>>>>> upstream/master

/////////////////////////
///MIND CONTROL COLLAR///
/////////////////////////

//Ok, first - it's not mind control. Just forcing someone to do emotes that user added to remote thingy. Just a funny illegal ERP toy.

//Controller stuff
/obj/item/connect/mind_controller
	name = "mind controller"
<<<<<<< HEAD
	desc = "Small remote for sending basic emotion patterns to collar."
=======
	desc = "A small remote for sending basic emotion patterns to a collar."
>>>>>>> upstream/master
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	lefthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	icon_state = "mindcontroller"
	var/obj/item/clothing/neck/mind_collar/collar = null

/obj/item/connect/mind_controller/Initialize(mapload, collar)
    //Store the collar on creation.
	src.collar = collar
	. = ..() //very important to call parent in Intialize

/obj/item/connect/mind_controller/attack_self(mob/user)
	collar.emoting = stripped_input(user, "Change the emotion pattern")
	collar.emoting_proc()

//Collar stuff
/obj/item/clothing/neck/mind_collar
	name = "mind collar"
<<<<<<< HEAD
	desc = "Tight collar. Looks like it has some strange high-tech emitters on its sides."
=======
	desc = "A tight collar. It has some strange high-tech emitters on the side."
>>>>>>> upstream/master
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_neck.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_neck.dmi'
	icon_state = "mindcollar"
	inhand_icon_state = "mindcollar"
	var/obj/item/connect/mind_controller/remote = null
	var/emoting = "Shivers"

/obj/item/clothing/neck/mind_collar/Initialize()
	. = ..()
	remote = new /obj/item/connect/mind_controller(src, src)
	var/turf = get_turf(src)
	remote.forceMove(turf)

/obj/item/clothing/neck/mind_collar/proc/emoting_proc()
	var/mob/living/carbon/human/U = src.loc
	if(src == U.wear_neck)
		U.emote("me", 1,"[emoting]", TRUE)
<<<<<<< HEAD
	else
		return
=======

/obj/item/clothing/neck/mind_collar/Destroy()
	if(remote)
		remote.collar = null
		remote = null
	return ..()
>>>>>>> upstream/master
