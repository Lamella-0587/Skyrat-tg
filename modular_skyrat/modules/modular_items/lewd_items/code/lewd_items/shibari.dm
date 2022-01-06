//Defining rope tightness for code readability. This var works as multiplier for arousal and pleasure per tick when character tied up with those.
#define ROPE_TIGHTNESS_LOW (1<<0)
#define ROPE_TIGHTNESS_MED (1<<1)
#define ROPE_TIGHTNESS_HIGH (1<<2)

/obj/item/stack/shibari_rope
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	icon_state = "shibari_rope"
	name = "shibari ropes"
	desc = "Coil of bondage ropes."
	amount = 1
	merge_type = /obj/item/stack/shibari_rope
	singular_name = "rope"
	max_amount = 5
	flags_1 = IS_PLAYER_COLORABLE_1

	greyscale_config = /datum/greyscale_config/shibari_rope
	greyscale_colors = "#bd8fcf"

	greyscale_config_inhand_left = /datum/greyscale_config/shibari_rope_inhand_left
	greyscale_config_inhand_right = /datum/greyscale_config/shibari_rope_inhand_right

	///We use this var to change tightness var on worn version of this item.
	var/tightness = ROPE_TIGHTNESS_LOW

	///Things this rope can transform into when it's tied to a person
	var/obj/item/clothing/under/shibari/torso/shibari_body
	var/obj/item/clothing/under/shibari/groin/shibari_groin
	var/obj/item/clothing/under/shibari/full/shibari_fullbody
	var/obj/item/clothing/shoes/shibari_legs/shibari_legs
	var/obj/item/clothing/gloves/shibari_hands/shibari_hands

/obj/item/stack/shibari_rope/update_icon_state()
	if(amount <= (max_amount * (1/3)))
		set_greyscale(greyscale_colors, /datum/greyscale_config/shibari_rope)
		return ..()
	if (amount <= (max_amount * (2/3)))
		set_greyscale(greyscale_colors, /datum/greyscale_config/shibari_rope/med)
		return ..()
	set_greyscale(greyscale_colors, /datum/greyscale_config/shibari_rope/high)
	return ..()

/obj/item/stack/shibari_rope/split_stack(mob/user, amount)
	. = ..()
	if(.)
		var/obj/item/stack/F = .
		F.greyscale_colors = greyscale_colors
		F.update_greyscale()

/obj/item/stack/shibari_rope/can_merge(obj/item/stack/check)
	if(check.greyscale_colors == greyscale_colors)
		return ..()
	else
		return FALSE

/obj/item/stack/shibari_rope/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	. = ..()
	if(!greyscale_colors)
		var/new_color = "#"
		for(var/i in 1 to 3)
			new_color += num2hex(rand(0, 255), 2)
		set_greyscale(colors = list(new_color))

/obj/item/stack/shibari_rope/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/stack/shibari_rope/attack(mob/living/carbon/attacked, mob/living/user)
	add_fingerprint(user)
	if(get_dist(user, src) > 1)
		return ..()
	if(ishuman(attacked))
		if(attacked.client?.prefs?.read_preference(/datum/preference/toggle/erp/sex_toy))
			var/mob/living/carbon/human/them = attacked
			switch(user.zone_selected)
				if(BODY_ZONE_L_LEG || BODY_ZONE_R_LEG)
					if(!(them.shoes))
						if(them?.dna?.mutant_bodyparts["taur"])
							var/datum/sprite_accessory/taur/S = GLOB.sprite_accessories["taur"][them.dna.species.mutant_bodyparts["taur"][MUTANT_INDEX_NAME]]
							if(S.hide_legs)
								to_chat(user, span_warning("You can't tie their feet, they're a taur!"))
								return ..()
						them.visible_message(span_warning("[user] starts tying [them]'s feet!"),\
							span_userdanger("[user] starts tying your feet!"),\
							span_hear("You hear ropes being tightened."))
						if(do_after(user, HAS_TRAIT(user, TRAIT_RIGGER) ? 20 : 60))
							shibari_legs = new(src)
							shibari_legs.set_greyscale(greyscale_colors)
							if(them.equip_to_slot_if_possible(shibari_legs,ITEM_SLOT_FEET,0,0,1))
								use(1)
								shibari_legs = null
								them.visible_message(span_warning("[user] tied [them]'s feet!"),\
									span_userdanger("[user] tied your feet!"),\
									span_hear("You hear ropes being completely tightened."))
							else
								qdel(shibari_legs)
					else
						to_chat(user, span_warning("They're already wearing something on this slot!"))

				if(BODY_ZONE_PRECISE_GROIN)
					if(!(them.w_uniform))
						them.visible_message(span_warning("[user] starts tying [them]'s groin!"),\
							span_userdanger("[user] starts tying your groin!"),\
							span_hear("You hear ropes being tightened."))
						shibari_groin = new(src)
						shibari_groin.set_greyscale(greyscale_colors)
						if(do_after(user, HAS_TRAIT(user, TRAIT_RIGGER) ? 20 : 60))
							if(them.equip_to_slot_if_possible(shibari_groin,ITEM_SLOT_ICLOTHING,0,0,1))
								use(1)
								shibari_groin.tightness = tightness
								shibari_groin = null
								them.visible_message(span_warning("[user] tied [them]'s groin!"),\
									span_userdanger("[user] tied your groin!"),\
									span_hear("You hear ropes being completely tightened."))
							else
								qdel(shibari_groin)
						else
							qdel(shibari_groin)
					else if(istype(them.w_uniform, /obj/item/clothing/under/shibari/torso))
						if(them.w_uniform.greyscale_colors == greyscale_colors)
							them.visible_message(span_warning("[user] starts tying [them]'s groin!"),\
								span_userdanger("[user] starts tying your groin!"),\
								span_hear("You hear ropes being tightened."))
							shibari_fullbody = new(src)
							shibari_fullbody.set_greyscale(greyscale_colors)
							if(do_after(user, HAS_TRAIT(user, TRAIT_RIGGER) ? 20 : 60))
								qdel(them.w_uniform, force = TRUE)
								if(them.equip_to_slot_if_possible(shibari_fullbody,ITEM_SLOT_ICLOTHING,0,0,1))
									use(1)
									shibari_fullbody.tightness = tightness
									shibari_fullbody = null
									them.visible_message(span_warning("[user] tied [them]'s groin!"),\
										span_userdanger("[user] tied your groin!"),\
										span_hear("You hear ropes being completely tightened."))
								else
									qdel(shibari_fullbody)
							else
								qdel(shibari_fullbody)
						else
							to_chat(user, span_warning("You can't mix colors with this kind of rope!"))
					else
						to_chat(user, span_warning("They're already wearing something on this slot!"))

				if(BODY_ZONE_CHEST)
					if(!(them.w_uniform))
						them.visible_message(span_warning("[user] starts tying [them]'s chest!"),\
							span_userdanger("[user] starts tying your chest!"),\
							span_hear("You hear ropes being tightened."))
						shibari_body = new(src)
						shibari_body.set_greyscale(greyscale_colors)
						if(do_after(user, HAS_TRAIT(user, TRAIT_RIGGER) ? 20 : 60))
							if(them.equip_to_slot_if_possible(shibari_body,ITEM_SLOT_ICLOTHING,0,0,1))
								use(1)
								shibari_body.tightness = tightness
								shibari_body = null
								them.visible_message(span_warning("[user] tied [them]'s chest!"),\
									span_userdanger("[user] tied your chest!"),\
									span_hear("You hear ropes being completely tightened."))
							else
								qdel(shibari_body)
						else
							qdel(shibari_body)
					else if(istype(them.w_uniform, /obj/item/clothing/under/shibari/groin))
						if(them.w_uniform.greyscale_colors == greyscale_colors)
							them.visible_message(span_warning("[user] starts tying [them]'s chest!"),\
								span_userdanger("[user] starts tying your chest!"),\
								span_hear("You hear ropes being tightened."))
							shibari_fullbody = new(src)
							shibari_fullbody.set_greyscale(greyscale_colors)
							if(do_after(user, HAS_TRAIT(user, TRAIT_RIGGER) ? 20 : 60))
								qdel(them.w_uniform, force = TRUE)
								if(them.equip_to_slot_if_possible(shibari_fullbody,ITEM_SLOT_ICLOTHING,0,0,1))
									use(1)
									shibari_fullbody.tightness = tightness
									shibari_fullbody = null
									them.visible_message(span_warning("[user] tied [them]'s chest!"),\
										span_userdanger("[user] tied your chest!"),\
										span_hear("You hear ropes being completely tightened."))
								else
									qdel(shibari_fullbody)
							else
								qdel(shibari_fullbody)
						else
							to_chat(user, span_warning("You can't mix colors with this kind of rope!"))
					else
						to_chat(user, span_warning("They're already wearing something on this slot!"))

				if(BODY_ZONE_L_ARM || BODY_ZONE_R_ARM)
					if(!(them.gloves))
						them.visible_message(span_warning("[user] starts tying [them]'s hands!"),\
							span_userdanger("[user] starts tying your hands!"),\
							span_hear("You hear ropes being tightened."))
						if(do_after(user, HAS_TRAIT(user, TRAIT_RIGGER) ? 20 : 60))
							shibari_hands = new(src)
							shibari_hands.set_greyscale(greyscale_colors)
							if(them.equip_to_slot_if_possible(shibari_hands,ITEM_SLOT_GLOVES,0,0,1))
								use(1)
								shibari_hands = null
								them.visible_message(span_warning("[user] tied [them]'s hands!"),\
									span_userdanger("[user] tied your hands!"),\
									span_hear("You hear ropes being completely tightened."))
							else
								qdel(shibari_hands)
					else
						to_chat(user, span_warning("They're already wearing something on this slot!"))
				else
					return ..()
		else
			to_chat(user, span_danger("Looks like [attacked] doesn't want you to do that."))
			return ..()
	else
		return ..()

///This part of code required for tightness adjustment. You can change tightness of future shibari bondage on character by clicking on ropes.

/obj/item/stack/shibari_rope/attack_self(mob/user, obj/item/I)
	switch(tightness)
		if(ROPE_TIGHTNESS_HIGH)
			tightness = ROPE_TIGHTNESS_LOW
			playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/latex.ogg', 25)
			to_chat(user, span_notice("You slightly tightened the ropes"))
		if(ROPE_TIGHTNESS_LOW)
			tightness = ROPE_TIGHTNESS_MED
			playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/latex.ogg', 50)
			to_chat(user, span_notice("You moderately tightened the ropes"))
		if(ROPE_TIGHTNESS_MED)
			tightness = ROPE_TIGHTNESS_HIGH
			playsound(loc, 'modular_skyrat/modules/modular_items/lewd_items/sounds/latex.ogg', 75)
			to_chat(user, span_notice("You strongly tightened the ropes"))

//This part of code spawns ropes with full stack.
/obj/item/stack/shibari_rope/full
	amount = 5

#undef ROPE_TIGHTNESS_LOW
#undef ROPE_TIGHTNESS_MED
#undef ROPE_TIGHTNESS_HIGH
