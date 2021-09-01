/obj/item/clothing/under/stripper_outfit
	name = "stripper outfit"
<<<<<<< HEAD
	desc = "This clothing shows more, than hides"
=======
	desc = "An item of clothing that leaves little to the imagination."
>>>>>>> upstream/master
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_uniform.dmi'
	worn_icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_uniform/lewd_uniform.dmi'
	worn_icon_digi = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_uniform/lewd_uniform-digi.dmi'
	worn_icon_taur_snake = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_uniform/lewd_uniform-snake.dmi'
	worn_icon_taur_paw = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_uniform/lewd_uniform-paw.dmi'
	worn_icon_taur_hoof = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_uniform/lewd_uniform-hoof.dmi'
	mutant_variants = STYLE_DIGITIGRADE|STYLE_TAUR_ALL
	can_adjust = FALSE
<<<<<<< HEAD
	icon_state = "stripper"
	inhand_icon_state = "stripper"
	var/current_color = "cyan"
	var/color_changed = FALSE
	var/static/list/stripper_designs

//create radial menu
/obj/item/clothing/under/stripper_outfit/proc/populate_stripper_designs()
	stripper_designs = list(
		"cyan" = image (icon = src.icon, icon_state = "stripper_cyan"),
		"yellow" = image(icon = src.icon, icon_state = "stripper_yellow"),
		"green" = image(icon = src.icon, icon_state = "stripper_green"),
		"red" = image(icon = src.icon, icon_state = "stripper_red"),
		"latex" = image(icon = src.icon, icon_state = "stripper_latex"),
		"orange" = image(icon = src.icon, icon_state = "stripper_orange"),
		"white" = image(icon = src.icon, icon_state = "stripper_white"),
		"purple" = image(icon = src.icon, icon_state = "stripper_purple"),
		"black" = image(icon = src.icon, icon_state = "stripper_black"),
		"tealblack" = image(icon = src.icon, icon_state = "stripper_tealblack"))

//spawn thing in stripper outfit

/obj/item/clothing/under/stripper_outfit/Initialize()
	. = ..()
	//to spawn icon properly
	update_icon_state()
	update_icon()
	if(!length(stripper_designs))
		populate_stripper_designs()

	//random color variation on start. Because why not?
	current_color = pick(stripper_designs)
	update_icon_state()
	update_icon()

//reskin code
/obj/item/clothing/under/stripper_outfit/AltClick(mob/user, obj/item/I)
	if(color_changed == FALSE)
		. = ..()
		if(.)
			return
		var/choice = show_radial_menu(user,src, stripper_designs, custom_check = CALLBACK(src, .proc/check_menu, user, I), radius = 36, require_near = TRUE)
		if(!choice)
			return FALSE
		current_color = choice
		update_icon()
		color_changed = TRUE
	else
		return

//to check if we can change collar's model
/obj/item/clothing/under/stripper_outfit/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/clothing/under/stripper_outfit/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]_[current_color]"
	inhand_icon_state = "[initial(icon_state)]_[current_color]"

//examine stuff

/obj/item/clothing/under/stripper_outfit/examine(mob/user)
	.=..()
	if(color_changed == FALSE)
		. += "<span class='notice'>Alt-Click \the [src.name] to customize it.</span>"
=======
	icon_state = "stripper_cyan"
	inhand_icon_state = "stripper_cyan"
	unique_reskin = list("Cyan" = "stripper_cyan",
						"Yellow" = "stripper_yellow",
						"Green" = "stripper_green",
						"Red" = "stripper_red",
						"Latex" = "stripper_latex",
						"Orange" = "stripper_orange",
						"White" = "stripper_white",
						"Purple" = "stripper_purple",
						"Black" = "stripper_black",
						"Black-teal" = "stripper_tealblack")

/obj/item/clothing/under/stripper_outfit/AltClick(mob/user)
	. = ..()
	if(unique_reskin && !current_skin && user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY))
		reskin_obj(user)
>>>>>>> upstream/master
