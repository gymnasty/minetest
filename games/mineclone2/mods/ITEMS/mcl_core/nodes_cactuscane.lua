-- Cactus and Sugar Cane

local S = minetest.get_translator("mcl_core")

minetest.register_node("mcl_core:cactus", {
	description = S("Cactus"),
	_tt_help = S("Grows on sand").."\n"..minetest.colorize("#FFFF00", S("Contact damage: @1 per half second", 1)),
	_doc_items_longdesc = S("This is a piece of cactus commonly found in dry areas, especially deserts. Over time, cacti will grow up to 3 blocks high on sand or red sand. A cactus hurts living beings touching it with a damage of 1 HP every half second. When a cactus block is broken, all cactus blocks connected above it will break as well."),
	_doc_items_usagehelp = S("A cactus can only be placed on top of another cactus or any sand."),
	drawtype = "nodebox",
	tiles = {"mcl_core_cactus_top.png", "mcl_core_cactus_bottom.png", "mcl_core_cactus_side.png"},
	is_ground_content = true,
	stack_max = 64,
	groups = {handy=1, attached_node=1, plant=1, deco_block=1, dig_by_piston=1, enderman_takable=1},
	sounds = mcl_sounds.node_sound_wood_defaults(),
	paramtype = "light",
	sunlight_propagates = true,
	node_placement_prediction = "",
	node_box = {
		type = "fixed",
		fixed = {
			{-7/16, -8/16, -7/16,  7/16, 8/16,  7/16}, -- Main body
			{-8/16, -8/16, -7/16,  8/16, 8/16, -7/16}, -- Spikes
			{-8/16, -8/16,  7/16,  8/16, 8/16,  7/16}, -- Spikes
			{-7/16, -8/16, -8/16, -7/16, 8/16,  8/16}, -- Spikes
			{7/16,  -8/16,  8/16,  7/16, 8/16, -8/16}, -- Spikes
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {-7/16, -8/16, -7/16,  7/16, 7/16,  7/16}, -- Main body. slightly lower than node box
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-7/16, -8/16, -7/16, 7/16, 8/16, 7/16},
		},
	},
	-- Only allow to place cactus on sand or cactus
	on_place = mcl_util.generate_on_place_plant_function(function(pos, node)
		local node_below = minetest.get_node_or_nil({x=pos.x,y=pos.y-1,z=pos.z})
		if not node_below then return false end
		return (node_below.name == "mcl_core:cactus" or minetest.get_item_group(node_below.name, "sand") == 1)
	end),
	_mcl_blast_resistance = 0.4,
	_mcl_hardness = 0.4,
})

minetest.register_node("mcl_core:reeds", {
	description = S("Sugar Canes"),
	_tt_help = S("Grows on sand or dirt next to water"),
	_doc_items_longdesc = S("Sugar canes are a plant which has some uses in crafting. Sugar canes will slowly grow up to 3 blocks when they are next to water and are placed on a grass block, dirt, sand, red sand, podzol or coarse dirt. When a sugar cane is broken, all sugar canes connected above will break as well."),
	_doc_items_usagehelp = S("Sugar canes can only be placed top of other sugar canes and on top of blocks on which they would grow."),
	drawtype = "plantlike",
	tiles = {"default_papyrus.png"},
	inventory_image = "mcl_core_reeds.png",
	wield_image = "mcl_core_reeds.png",
	paramtype = "light",
	walkable = false,
	is_ground_content = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-7/16, -8/16, -7/16,  7/16, 8/16,  7/16}, -- Main Body
			{-8/16, -8/16, -7/16,  8/16, 8/16, -7/16}, -- Spikes
			{-8/16, -8/16,  7/16,  8/16, 8/16,  7/16}, -- Spikes
			{-7/16, -8/16, -8/16, -7/16, 8/16,  8/16}, -- Spikes
			{7/16,  -8/16,  8/16,  7/16, 8/16, -8/16}, -- Spikes
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-6/16, -8/16, -6/16, 6/16, 8/16, 6/16},
		},
	},
	stack_max = 64,
	groups = {dig_immediate=3, craftitem=1, deco_block=1, plant=1, non_mycelium_plant=1, dig_by_piston=1},
	sounds = mcl_sounds.node_sound_leaves_defaults(),
	node_placement_prediction = "",
	on_place = mcl_util.generate_on_place_plant_function(function(place_pos, place_node)
		local soil_pos = {x=place_pos.x, y=place_pos.y-1, z=place_pos.z}
		local soil_node = minetest.get_node_or_nil(soil_pos)
		if not soil_node then return false end
		local snn = soil_node.name -- soil node name

		-- Placement rules:
		-- * On top of group:soil_sugarcane AND next to water or frosted ice. OR
		-- * On top of sugar canes
		if snn == "mcl_core:reeds" then
			return true
		elseif minetest.get_item_group(snn, "soil_sugarcane") == 0 then
			return false
		end

		local posses = {
			{ x=0, y=0, z=1},
			{ x=0, y=0, z=-1},
			{ x=1, y=0, z=0},
			{ x=-1, y=0, z=0},
		}
		for p=1, #posses do
			local checknode = minetest.get_node(vector.add(soil_pos, posses[p]))
			if minetest.get_item_group(checknode.name, "water") ~= 0 or minetest.get_item_group(checknode.name, "frosted_ice") ~= 0 then
				-- Water found! Sugar canes are happy! :-)
				return true
			end
		end

		-- No water found! Sugar canes are not amuzed and refuses to be placed. :-(
		return false

	end),
	_mcl_blast_resistance = 0,
	_mcl_hardness = 0,
})
