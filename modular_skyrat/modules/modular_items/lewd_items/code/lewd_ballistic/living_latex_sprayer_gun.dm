#define LATEX_GUN_CLOSED "closed"
#define LATEX_GUN_OPENED "opened"
#define LATEX_GUN_HANDLED "handed"

/obj/item/gun/latexpulv
	desc = "Sprayer for firing projectiles of nanites simulating latex"
	name = "Nanite latex sprayer"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/latex_pulv.dmi'
	icon_state = "latex_pulv"
	inhand_icon_state = "latex_pulv"
	lefthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_skyrat/modules/modular_items/lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	fire_sound = 'sound/weapons/gun/general/grenade_launch.ogg' // LAMELLA TODO: Need a living latex sprayer voiceover file
	w_class = WEIGHT_CLASS_NORMAL
	vary_fire_sound = TRUE
	fire_sound_volume = 50
	dry_fire_sound = 'sound/weapons/gun/revolver/dry_fire.ogg'

	can_bayonet = FALSE
	can_flashlight = FALSE
	pinless = TRUE
	has_gun_safety = FALSE

	attack_verb_continuous = list("splashes on")
	attack_verb_simple = list("splashes on")

	var/obj/item/latex_pulv_module/chip = null

	var/pulv_state = LATEX_GUN_CLOSED
	var/chipslotisclosed = TRUE

/obj/item/gun/latexpulv/Initialize()
	. = ..()

	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, .proc/on_wield)
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, .proc/on_unwield)

	update_appearance()

/obj/item/gun/latexpulv/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]_[pulv_state]"

/obj/item/gun/latexpulv/update_overlays()
	. = ..()

	if(pulv_state == LATEX_GUN_OPENED && chambered)
		. += mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/latex_pulv.dmi', "hydraulics", BELOW_MOB_LAYER)

	var/latex_overlay
	var/glass_overlay
	if(!chambered)
		glass_overlay = "glass_[pulv_state]_nocan"
	else if(!chambered.loaded_projectile)
		glass_overlay = "glass_[pulv_state]_solid"
	else
		var/obj/projectile/bullet/livinglatexball/latexball = chambered.loaded_projectile
		latex_overlay = "latex_[pulv_state]_[latexball.latex_ball_color]"
		glass_overlay = "glass_[pulv_state]_trans"

	. += mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/latex_pulv.dmi', "[latex_overlay]", BELOW_MOB_LAYER)
	. += mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/latex_pulv.dmi', "[glass_overlay]", BELOW_MOB_LAYER)

	if(!chipslotisclosed)
		. += mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/latex_pulv.dmi', "module_rack", BELOW_MOB_LAYER)
		if(chip)
			. += mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/latex_pulv.dmi', "module", BELOW_MOB_LAYER)

/obj/item/gun/latexpulv/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=FALSE, \
										wieldsound=FALSE, \
										unwieldsound=FALSE, \
										attacksound=FALSE, \
										force_multiplier=0, \
										force_wielded=0, \
										force_unwielded=0, \
										icon_wielded=FALSE, \
										is_wieldable = CALLBACK(src, .proc/is_wieldable))

/obj/item/gun/latexpulv/AltClick(mob/user)
	. = ..()
	switch(pulv_state)
		if(LATEX_GUN_HANDLED)
			return
		if(LATEX_GUN_CLOSED)
			pulv_state = LATEX_GUN_OPENED
			update_appearance()
		if(LATEX_GUN_OPENED)
			pulv_state = LATEX_GUN_CLOSED
			update_appearance()

/obj/item/gun/latexpulv/can_trigger_gun(mob/living/user)
	. = ..()
	if(!chip)
		to_chat(user, span_warning("[src]'s trigger is locked. Please install a module"))
		return FALSE
	if(pulv_state != LATEX_GUN_HANDLED)
		to_chat(user, span_warning("\the [src] needs to be wielded to operate correctly!"))
		return FALSE

/obj/item/gun/latexpulv/attack_self(mob/user, modifiers)
	. = ..()
	if(user.is_holding(src) && pulv_state == LATEX_GUN_OPENED)
		chipslotisclosed = !chipslotisclosed
		to_chat(user, span_notice("You [chipslotisclosed ? "close" : "open"] [src]'s chip slot"))
		update_appearance()

/obj/item/gun/latexpulv/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(!user.is_holding(src))
		return
	if(!chipslotisclosed && chip)
		user.put_in_hands(chip)
		chip.add_fingerprint(user)
		to_chat(user, span_notice("You remove \the [chip] from [src]'s chip slot"))
		chip = null
		update_appearance()
		return
	if(pulv_state == LATEX_GUN_OPENED)
		to_chat(user, span_notice("You remove \the [chambered] from [src]'s loading chamber"))
		user.put_in_hands(chambered)
		chambered = null
		update_appearance()
		return

/obj/item/gun/latexpulv/attackby(obj/item/attacking_item, mob/living/user, params)
	. = ..()
	if(istype(attacking_item, /obj/item/ammo_casing/latexbin) && pulv_state == LATEX_GUN_OPENED)
		var/obj/item/ammo_casing/latexbin/new_can = attacking_item
		if(chambered)
			chambered.forceMove(drop_location())
			var/obj/item/ammo_casing/latexbin/old_can = chambered
			to_chat(user, span_notice("You swap [src]'s latex canister for a new canister."))
			new_can.forceMove(src)
			chambered = new_can
			user.put_in_hands(old_can)
		else
			to_chat(user, span_notice("You install a new canister into [src]."))
			new_can.forceMove(src)
			chambered = new_can

		update_appearance()

	if(istype(attacking_item, /obj/item/latex_pulv_module) && !chipslotisclosed)
		var/obj/item/latex_pulv_module/new_chip = attacking_item
		if(chip)
			chip.forceMove(drop_location())
			var/obj/item/latex_pulv_module/old_chip = chip
			to_chat(user, span_notice("You swap [src]'s chip for a new chip."))
			new_chip.forceMove(src)
			chip = new_chip
			user.put_in_hands(old_chip)
		else
			to_chat(user, span_notice("You install a new chip into [src]."))
			new_chip.forceMove(src)
			chip = new_chip

		update_appearance()

/obj/item/gun/latexpulv/can_shoot()
	return chambered?.loaded_projectile

/obj/item/gun/latexpulv/before_firing(atom/target, mob/user)
	var/obj/projectile/bullet/livinglatexball/latex_projectile = chambered.loaded_projectile
	latex_projectile.latexprogram = chip.latexprogram

/obj/item/gun/latexpulv/proc/is_wieldable()
	if(pulv_state != LATEX_GUN_CLOSED)
		return FALSE
	else
		return TRUE

/obj/item/gun/latexpulv/proc/on_wield()
	SIGNAL_HANDLER
	pulv_state = LATEX_GUN_HANDLED
	update_appearance()

/obj/item/gun/latexpulv/proc/on_unwield()
	SIGNAL_HANDLER
	pulv_state = LATEX_GUN_CLOSED
	update_appearance()


