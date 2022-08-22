--||||||||||||
--|| XP ATM ||
--||||||||||||

local S = minetest.get_translator(minetest.get_current_modname())

minetest.register_node("mcl_xp_atm:xp_atm",{
	description = S("Experience ATM"),
	_tt_help = S("Adds an ATM to store your XP."),
	_doc_items_longdesc = S('Used to store your experience points in a "back account".'),
	use_texture_alpha = "clip",
	paramtype2 = "facedir",
	tiles = {
		"mcl_xp_atm_top.png", "mcl_xp_atm_top.png",
		"mcl_xp_atm_side.png", "mcl_xp_atm_side.png",
		"mcl_xp_atm_top.png", "mcl_xp_atm_front.png",
	},
	groups = { pickaxey = 1, punchy = 2 },
	_mcl_blast_resistance = 3,
	_mcl_hardness = 3,
})
