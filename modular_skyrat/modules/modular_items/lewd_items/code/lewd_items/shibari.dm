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
	singular_name = "ropes"

	greyscale_config = /datum/greyscale_config/shibari_rope
	greyscale_colors = "#AD66BE"

	///We use this var to change tightness var on worn version of this item.
	var/tightness = ROPE_TIGHTNESS_LOW

	///Things this rope can transform into when it's tied to a person
	var/obj/item/clothing/under/shibari/torso/shibari_body
	var/obj/item/clothing/under/shibari/groin/shibari_groin
	var/obj/item/clothing/under/shibari/full/shibari_fullbody
	var/obj/item/clothing/shoes/shibari_legs/shibari_legs
	var/obj/item/clothing/gloves/shibari_hands/shibari_hands

/obj/item/stack/shibari_rope/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/stack/shibari_rope/attack(mob/living/carbon/attacked, mob/living/user)
	add_fingerprint(user)
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
						if(do_after(user, 60))
							shibari_legs = new(src)
							if(them.equip_to_slot_if_possible(shibari_legs,ITEM_SLOT_FEET,0,0,1))
								use(1)
								shibari_legs = null
								them.visible_message(span_warning("[user] tied [them]'s feet!"),\
									span_userdanger("[user] tied your feet!"),\
									span_hear("You hear ropes being completely tightened."))
							else
								qdel(shibari_legs)

				if(BODY_ZONE_PRECISE_GROIN)
					if(!(them.w_uniform))
						them.visible_message(span_warning("[user] starts tying [them]'s groin!"),\
							span_userdanger("[user] starts tying your groin!"),\
							span_hear("You hear ropes being tightened."))
						if(do_after(user, 60))
							shibari_groin = new(src)
							if(them.equip_to_slot_if_possible(shibari_groin,ITEM_SLOT_ICLOTHING,0,0,1))
								use(1)
								shibari_groin.tightness = tightness
								shibari_groin = null
								them.visible_message(span_warning("[user] tied [them]'s groin!"),\
									span_userdanger("[user] tied your groin!"),\
									span_hear("You hear ropes being completely tightened."))
							else
								qdel(shibari_groin)
					else if(istype(them.w_uniform, /obj/item/clothing/under/shibari/torso))
						them.visible_message(span_warning("[user] starts tying [them]'s groin!"),\
							span_userdanger("[user] starts tying your groin!"),\
							span_hear("You hear ropes being tightened."))
						if(do_after(user, 60))
							shibari_fullbody = new(src)
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

				if(BODY_ZONE_CHEST)
					if(!(them.w_uniform))
						them.visible_message(span_warning("[user] starts tying [them]'s chest!"),\
							span_userdanger("[user] starts tying your chest!"),\
							span_hear("You hear ropes being tightened."))
						if(do_after(user, 60))
							shibari_body = new(src)
							if(them.equip_to_slot_if_possible(shibari_body,ITEM_SLOT_ICLOTHING,0,0,1))
								use(1)
								shibari_body.tightness = tightness
								shibari_body = null
								them.visible_message(span_warning("[user] tied [them]'s chest!"),\
									span_userdanger("[user] tied your chest!"),\
									span_hear("You hear ropes being completely tightened."))
							else
								qdel(shibari_body)
					else if(istype(them.w_uniform, /obj/item/clothing/under/shibari/groin))
						them.visible_message(span_warning("[user] starts tying [them]'s chest!"),\
							span_userdanger("[user] starts tying your chest!"),\
							span_hear("You hear ropes being tightened."))
						if(do_after(user, 60))
							shibari_fullbody = new(src)
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

				if(BODY_ZONE_L_ARM || BODY_ZONE_R_ARM)
					if(!(them.gloves))
						them.visible_message(span_warning("[user] starts tying [them]'s hands!"),\
							span_userdanger("[user] starts tying your hands!"),\
							span_hear("You hear ropes being tightened."))
						if(do_after(user, 60))
							shibari_hands = new(src)
							if(them.equip_to_slot_if_possible(shibari_hands,ITEM_SLOT_GLOVES,0,0,1))
								use(1)
								shibari_hands = null
								them.visible_message(span_warning("[user] tied [them]'s hands!"),\
									span_userdanger("[user] tied your hands!"),\
									span_hear("You hear ropes being completely tightened."))
							else
								qdel(shibari_hands)
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
	amount = 10

#undef ROPE_TIGHTNESS_LOW
#undef ROPE_TIGHTNESS_MED
#undef ROPE_TIGHTNESS_HIGH
