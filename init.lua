--||||||||||||
--|| XP ATM ||
--||||||||||||

local S = minetest.get_translator(minetest.get_current_modname())
local C = minetest.colorize
local F = minetest.formspec_escape

-- Create XP ATM Account
minetest.register_on_joinplayer(function(player)
	if not player:get_meta():get_int("mcl_xp_atm_account") or player:get_meta():get_int("mcl_xp_atm_account") == "" or nil then
		player:get_meta():set_int("mcl_xp_atm_account", 0)
	else
		return false
	end
end)

-- ATM GUI
local gui = function(pos, node, clicker, itemstack, pointed_thing)
	local name = minetest.get_meta(pos):get_string("name")
	local playername = clicker:get_player_name()
	
	if name == "" then
		name = S("Experience ATM") .. ": " .. playername
	end
	
	local balance = clicker:get_meta():get_int("mcl_xp_atm_account")
	
	minetest.show_formspec(playername,
		"mcl_xp_atm:xp_atm",
		table.concat({
			"size[5.6,6.5]",
			"label[0,0;"..F(C("#313131", name)).."]",
			"label[0,0.5;"..F(C("#313131",S("XP Balance")..": "..balance)).."]",
			"label[0,1;"..F(C("#313131",S("Deposit"))).."]",
			"button[0,1.5;1,1;deposit_1;1]",
			"button[0,2.5;1,1;deposit_5;5]",
			"button[0,3.5;1,1;deposit_10;10]",
			"button[0,4.5;1,1;deposit_100;100]",
			"button[0,5.5;1,1;deposit_1000;1000]",
			"label[1.5,1;"..F(C("#313131",S("Withdraw"))).."]",
			"button[1.5,1.5;1,1;withdraw_1;1]",
			"button[1.5,2.5;1,1;withdraw_5;5]",
			"button[1.5,3.5;1,1;withdraw_10;10]",
			"button[1.5,4.5;1,1;withdraw_100;100]",
			"button[1.5,5.5;1,1;withdraw_1000;1000]",
		})
	)
	minetest.register_on_player_receive_fields(function(player, form, pressed)
		local xp_amount = {1, 5, 10, 100, 1000}
		playername = player:get_player_name()
		if form == "mcl_xp_atm:xp_atm" then
			local balance = player:get_meta():get_int("mcl_xp_atm_account")
			local experience = mcl_experience.get_xp(player)
			for _, i in ipairs(xp_amount) do
				if pressed["withdraw_" .. i] then
					if balance >= i then
						mcl_experience.add_xp(player, i)
						--minetest.chat_send_player(playername, "[Experience ATM] Successfully Withdrew " .. i .. " XP.")
						balance = balance - i
						player:get_meta():set_int("mcl_xp_atm_account", balance)
					elseif balance < i then
						minetest.chat_send_all("[Experience ATM] Not Enough XP in your account.")
						return
					end
				elseif pressed["deposit_"..i] then
					if experience >= i then
						mcl_experience.add_xp(player, -i)
						--minetest.chat_send_player(playername, "[Experience ATM] Successfully Deposited " .. i .. " XP.")
						balance = balance + i
						player:get_meta():set_int("mcl_xp_atm_account", balance)
					elseif experience < i then
						minetest.chat_send_all("[Experience ATM] Not Enough XP in your inventory.")
						return
					end
				end
			end
		end
	end)
end

-- Define XP ATM Node
minetest.register_node("mcl_xp_atm:xp_atm",{
	description = S("Experience ATM"),
	_tt_help = S("Adds an ATM to store your XP."),
	_doc_items_longdesc = S('Used to store your experience points in a "bank account".'),
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
	on_rightclick = gui,
})

-- Define Craft Recipe
minetest.register_craft({
	output = "mcl_xp_atm:xp_atm",
	recipe = {
		{"mcl_core:iron_ingot", "mesecons:redstone", "mcl_core:iron_ingot"},
		{"mcl_core:glass", "mcl_potions:glass_bottle", "mcl_core:glass"},
		{"mcl_core:iron_ingot", "mesecons:redstone", "mcl_core:iron_ingot"}
	}
})
