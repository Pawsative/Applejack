--[[
	~ Detail Plugin ~
	~ Applejack ~
--]]

PLUGIN.Name = "Details";

PLUGIN.ToSpawn = {
	rp_evocity_v2d = {
		--[[{"models/props_wasteland/controlroom_chair001a.mdl",Angle(0, -19, 0), Vector(-7484.0786, -8753.0557, 1756.3939)},
		{"models/props/cs_office/phone.mdl",Angle(0, -146, 0), Vector(-7455.0645, -8735.4609, 1770.2837)},
		{"models/props_wasteland/controlroom_desk001a.mdl",Angle(0, -180, 0), Vector(-7448.9536, -8792.1367, 1752.9365)},
		{"models/weapons/w_rif_m4a1.mdl",Angle(2, -110, -85), Vector(-7445.2832, -8754.126, 1772.167)},
		{"models/props/de_prodigy/wood_pallet_01.mdl",Angle(-90, 90, 180), Vector(-7457.3955, -8867.9678, 1760.4998)},
		{"models/props/de_prodigy/prodcratesb.mdl",Angle(0, 90, 0), Vector(-7460.438, -8900.1396, 1788.5254)},
		{"models/props/de_prodigy/pushcart.mdl",Angle(0, 90, 0), Vector(-7523.5039, -8894.7119, 1752.3136)},
		{"models/props/de_prodigy/ammo_can_02.mdl",Angle(0, 77, 0), Vector(-7523.5103, -8886.7021, 1754.2803)},
		{"models/props/de_prodigy/ammo_can_02.mdl",Angle(0, 92, 0), Vector(-7522.7485, -8914.1113, 1754.531)},
		{"models/props/de_prodigy/ammo_can_02.mdl",Angle(0, 90, -31), Vector(-7555.2939, -8861.1602, 1748.9196)},
		{"models/props/de_prodigy/ammo_can_01.mdl",Angle(0, 88, 0), Vector(-7598.5015, -8907.626, 1736.4063)},
		{"models/props/de_prodigy/ammo_can_03.mdl",Angle(0, 90, 0), Vector(-7655.4941, -8905.583, 1736.4741)},
		{"models/props_combine/breendesk.mdl",Angle(0, 0, 0), Vector(-7008.0654, -8779.1191, 2616.3386)},
		{"models/props/cs_office/phone.mdl",Angle(-1, -142, 1), Vector(-7021.916, -8748.123, 2647.7722)},
		{"models/props_combine/breenglobe.mdl",Angle(0, -156, 0), Vector(-6997.6235, -8745.2197, 2656.6035)},
		{"models/props_combine/breenclock.mdl",Angle(1, -160, -1), Vector(-6994.4727, -8764.9307, 2652.0222)},
		{"models/props/cs_office/computer.mdl",Angle(0, 141, 0), Vector(-7003.6318, -8808.4482, 2647.7)},
		{"models/props/cs_office/phone.mdl",Angle(0, -90, 0), Vector(-6676.311, -9373.2129, 112.2358)},
		{"models/props/cs_office/computer_keyboard.mdl",Angle(0, -90, 0), Vector(-6655.9893, -9372.4658, 112.2707)},
		{"models/props/cs_office/computer_mouse.mdl",Angle(0, -83, 0), Vector(-6637.3638, -9372.1777, 112.2716)},
		{"models/props/cs_office/computer_monitor.mdl",Angle(0, -132, 0), Vector(-6618.9814, -9369.8506, 112.4032)},
		{"models/props/cs_office/phone.mdl",Angle(-1, 89, 0), Vector(-6550.0166, -9287.6455, 883.3712)},
		{"models/props/cs_office/computer.mdl",Angle(0, -93, 0), Vector(-7747.3818, -9252.2334, 2521.9355)},
		{"models/props/cs_office/phone.mdl",Angle(0, -106, 0), Vector(-7716.4868, -9250.9482, 2521.9858)},
		{"models/props_wasteland/controlroom_desk001b.mdl",Angle(0, -90, 0), Vector(-7729.7222, -9249.9219, 2504.7705)},
		{"models/props_wasteland/controlroom_desk001b.mdl",Angle(0, -90, 0), Vector(-8019.6216, -9245.3418, 2504.8923)},
		{"models/props/cs_office/computer.mdl",Angle(-1, -90, 0), Vector(-8020.5781, -9248.0518, 2522.072)},
		{"models/props/cs_office/phone.mdl",Angle(-1, -112, 0), Vector(-7991.8315, -9252.8398, 2522.1868)},
		{"models/props_combine/breendesk.mdl",Angle(0, -90, 0), Vector(-8010.1289, -8813.0479, 2488.3386)},
		{"models/props/cs_office/phone.mdl",Angle(-1, 129, 1), Vector(-7979.1431, -8799.1738, 2519.7722)},
		{"models/props_combine/breenglobe.mdl",Angle(0, 114, 0), Vector(-7976.2217, -8823.4639, 2528.6035)},
		{"models/props_combine/breenclock.mdl",Angle(1, 110, -1), Vector(-7995.9302, -8826.6299, 2524.0222)},
		{"models/props/cs_office/computer.mdl",Angle(0, 51, 0), Vector(-8039.4546, -8817.5029, 2519.7)},
		{"models/props/cs_office/bookshelf1.mdl",Angle(0, 90, 0), Vector(-8129.3789, -8917.9258, 2490.6602)},
		{"models/props/cs_office/bookshelf2.mdl",Angle(0, 180, 0), Vector(-7826.959, -9191.5059, 2488.4573)},
		{"models/props/cs_office/bookshelf3.mdl",Angle(0, 180, 0), Vector(-7582.9624, -9191.8818, 2488.3433)},
		{"models/props/cs_office/paperbox_pile_01.mdl",Angle(0, 0, 0), Vector(-7215.0942, -9464.3223, 2488.4998)},
		{"models/props/cs_office/shelves_metal3.mdl",Angle(0, -90, 0), Vector(-7148.6226, -9416.8096, 2488.3616)},
		{"models/props/cs_office/shelves_metal2.mdl",Angle(0, -90, 0), Vector(-7084.3677, -9416.4834, 2488.2905)},
		{"models/props/cs_office/shelves_metal1.mdl",Angle(0, 180, 0), Vector(-6878.4189, -9594.9512, 2488.3682)},
		{"models/props_wasteland/interior_fence002c.mdl",Angle(0, 0, 0), Vector(10813.3926, -12562.916, -988.5484)},
		{"models/props_wasteland/interior_fence003b.mdl",Angle(0, 0, 0), Vector(10808.7393, -12283.5771, -992.7797)},
--]]		--[[Alexander's BP
			{"models/props/cs_office/plant01.mdl",Angle(0, -90, 0), Vector(-7232.2886, -6170.4756, 71.6504)},
			{"models/props/cs_office/shelves_metal.mdl",Angle(0, -180, 0), Vector(-7333.5488, -6121.0181, 72.3473)},
			{"models/props/cs_office/shelves_metal.mdl",Angle(0, 180, 0), Vector(-7333.46, -6054.9248, 72.3682)},
			{"models/props/cs_office/shelves_metal.mdl",Angle(0, -180, 0), Vector(-7333.4541, -5990.582, 72.3624)},
			{"models/props_c17/cashregister01a.mdl",Angle(0, 90, 0), Vector(-7237.8862, -5994.8701, 128.6062)},
			{"models/props_c17/cashregister01a.mdl",Angle(0, 90, 0), Vector(-7237.6797, -6090.9033, 128.581)},
		--Billboards
			--near rogue spawn
			{"models/props_rooftop/scaffolding01a.mdl",Angle(0, -90, 0), Vector(4295.8135, 9028.7822, 246.7635)},
			{"models/props/cs_assault/billboard.mdl",Angle(0, -90, 0), Vector(4290.1831, 8985.2832, 327.1576)},
			--Syndicate base
			{"models/props_rooftop/scaffolding01a.mdl",Angle(0, -51, 0), Vector(3253.9521, 3704.7754, 519.1478)},
			{"models/props/cs_assault/billboard.mdl",Angle(0, -52, 0), Vector(3276.7092, 3667.2793, 599.5422)},
			--used cars area
			{"models/props_rooftop/scaffolding01a.mdl",Angle(0, 90, 0), Vector(-915.4747, -6450.6147, 272.2731)},
			{"models/props/cs_assault/billboard.mdl",Angle(0, 89, 0), Vector(-909.5449, -6407.1562, 352.6676)},
--]]

--Traffic calming
--[[
		{"models/props_c17/handrail04_short.mdl",Angle(2, -1, 0), Vector(-6271.7349, -4289.1475, 92.3374)},
		{"models/props_c17/handrail04_short.mdl",Angle(0, 0, 0), Vector(-6272.3359, -4111.7051, 92.2782)},

		{"models/props_c17/handrail04_long.mdl",Angle(0, -180, 0), Vector(-5735.2881, -4517.1421, 93.0553)},
		{"models/props_c17/handrail04_medium.mdl",Angle(0, 180, 0), Vector(-5734.5503, -4740.4932, 92.3931)},
		{"models/props_c17/handrail04_long.mdl",Angle(1, -180, 0), Vector(-5734.1069, -4644.6777, 92.7839)},

		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 43, 0), Vector(-6219.5547, -5103.5459, 64.3946)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 88, 0), Vector(-6217.1475, -5000.0449, 64.3691)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 43, 0), Vector(-6003.1616, -5012.4746, 64.2957)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 43, 0), Vector(-6004.3643, -5121.5488, 64.3627)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 178, 0), Vector(-5785.4702, -5113.2842, 64.3737)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(-1, -134, 1), Vector(-5780.9224, -5005.9067, 64.3407)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(-1, -43, 1), Vector(-5673.3633, -5226.2578, 65.3539)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, -92, 0), Vector(-5565.9546, -5229.9893, 65.3869)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 133, 0), Vector(-5556.0259, -5448.814, 65.3758)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 134, 0), Vector(-5665.106, -5448.4409, 65.3088)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 178, 0), Vector(-5675.9082, -5662.5151, 65.3823)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 134, 0), Vector(-5572.3921, -5664.1353, 65.4078)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 179, 0), Vector(-6454.416, -5661.7026, 64.3691)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 134, 0), Vector(-6350.8979, -5663.209, 64.3946)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 134, 0), Vector(-6443.8491, -5447.6167, 64.2957)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 134, 0), Vector(-6334.7686, -5447.8701, 64.3627)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, -91, 0), Vector(-6344.938, -5229.0562, 64.3737)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(-1, -43, 1), Vector(-6452.3506, -5225.4429, 64.3407)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 45, 0), Vector(-6219.3765, -5893.8809, 64.3946)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 90, 0), Vector(-6220.5571, -5790.3589, 64.3691)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 45, 0), Vector(-6006.269, -5795.3662, 64.2957)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 45, 0), Vector(-6003.6914, -5904.4165, 64.3627)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 180, 0), Vector(-5785.2153, -5888.5718, 64.3737)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(-1, -132, 1), Vector(-5784.3906, -5781.1016, 64.3407)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 180, 0), Vector(-5777.4263, -7938.104, 64.3737)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(-1, -132, 1), Vector(-5775.8062, -7830.6426, 64.3407)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 45, 0), Vector(-5997.7842, -7843.2646, 64.2957)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 45, 0), Vector(-5996.0137, -7952.3311, 64.3627)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 90, 0), Vector(-6212.0293, -7836.6714, 64.3691)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 45, 0), Vector(-6211.6152, -7940.1992, 64.3946)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, -1, 0), Vector(-6323.3789, -8073.5679, 64.3691)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, -45, 0), Vector(-6426.9072, -8073.3042, 64.3946)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, -46, 0), Vector(-6440.4507, -8288.8213, 64.3627)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, -46, 0), Vector(-6331.375, -8287.7656, 64.2957)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 89, 0), Vector(-6427.6553, -8507.4971, 64.3737)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(-1, 137, 1), Vector(-6320.207, -8509.8213, 64.3407)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 45, 0), Vector(-6219.0205, -8724.4463, 64.3946)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 89, 0), Vector(-6219, -8620.917, 64.3691)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 44, 0), Vector(-6003.4722, -8737.4834, 64.3627)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 44, 0), Vector(-6004.7847, -8628.4102, 64.2957)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 179, 0), Vector(-5784.8271, -8724.1738, 64.3737)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(-1, -133, 1), Vector(-5782.7554, -8616.7207, 64.3407)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 134, 0), Vector(-5567.3184, -8504.4307, 66.0875)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 178, 0), Vector(-5670.8311, -8502.5928, 66.062)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 133, 0), Vector(-5550.5, -8289.1436, 66.0556)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, 133, 0), Vector(-5659.5791, -8288.542, 65.9886)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(0, -92, 0), Vector(-5559.9692, -8070.2988, 66.0666)},
		{"models/props_trainstation/trainstation_post001.mdl",Angle(-1, -44, 1), Vector(-5667.3696, -8066.3418, 66.0337)},

		{"models/props_c17/handrail04_medium.mdl",Angle(0, 90, 0), Vector(-6476.1929, -5714.228, 92.3146)},
		{"models/props_c17/handrail04_corner.mdl",Angle(0, 90, 1), Vector(-6294.4355, -5157.7319, 72.4564)},
		{"models/props_c17/handrail04_corner.mdl",Angle(0, 180, 0), Vector(-6300.3589, -5733.1128, 72.9343)},
		{"models/props_c17/handrail04_corner.mdl",Angle(0, -90, 3), Vector(-5712.3247, -5733.6558, 72.4707)},
		{"models/props_c17/handrail04_long.mdl",Angle(0, -180, 0), Vector(-5733.1929, -5972.562, 94.2822)},
		{"models/props_c17/handrail04_corner.mdl",Angle(0, 0, 0), Vector(-5720.8071, -5153.9443, 74.1952)},

		{"models/props_wasteland/barricade001a.mdl",Angle(0,-90,0),Vector(4708.7632, 13248.7549,  79.466 )},
		{"models/props_wasteland/barricade002a.mdl",Angle(0,-90,0),Vector(4732.9673, 13160.8115,  96.5104)},
		{"models/props_wasteland/barricade002a.mdl",Angle(0,-90,0),Vector(4732.229 , 13087.2109,  96.5098)},
		{"models/props_wasteland/barricade002a.mdl",Angle(0,-90,0),Vector(4731.6465, 13003.1875,  96.5053)},
		{"models/props_wasteland/barricade002a.mdl",Angle(0,-90,0),Vector(4733.3862, 12928.7822,  96.4969)},
		{"models/props_wasteland/barricade001a.mdl",Angle(0,-90,0),Vector(4712.5156, 12820.7959,  79.4768)},
--]]
		--[[
		{"models/props_c17/concrete_barrier001a.mdl",Angle(0, 0, 0), Vector(-6003.8213, -7651.5469, 64.5261)},
		{"models/props_c17/concrete_barrier001a.mdl",Angle(0, 0, 0), Vector(-6001.3301, -7378.6631, 64.5402)},
		{"models/props_c17/concrete_barrier001a.mdl",Angle(0, 0, 0), Vector(-6007.5854, -7131.5356, 64.6823)},
		{"models/props_c17/concrete_barrier001a.mdl",Angle(0, 0, 0), Vector(-6002.4326, -6864.8789, 64.4709)},
		{"models/props_c17/concrete_barrier001a.mdl",Angle(0, 0, 0), Vector(-6005.6685, -6616.5449, 64.6309)},
		{"models/props_c17/concrete_barrier001a.mdl",Angle(0, 0, 0), Vector(-6006.5591, -6359.9219, 64.4527)},
		{"models/props_c17/concrete_barrier001a.mdl",Angle(0, -180, 0), Vector(-6007.9888, -6106.8296, 64.5025)},--]]

--[[		{"models/props_c17/handrail04_long.mdl",Angle(0, 0, 0), Vector(-6274.561, -7685.8398, 92.3151)},
		{"models/props_c17/handrail04_short.mdl",Angle(0, 2, 0), Vector(-6276.8135, -7606.166, 92.2902)},
		{"models/props_c17/handrail04_short.mdl",Angle(0, -1, 0), Vector(-6271.1548, -7467.3848, 92.3338)},
		{"models/props_c17/handrail04_short.mdl",Angle(0, 0, 0), Vector(-6266.6943, -7293.0669, 92.3113)},
		{"models/props_c17/handrail04_medium.mdl",Angle(0, 90, 0), Vector(-6751.854, -8554.2129, 92.3044)},
		{"models/props_c17/handrail04_medium.mdl",Angle(0, 90, 0), Vector(-7006.1909, -8556.7373, 92.4321)},
		{"models/props_c17/handrail04_short.mdl",Angle(0, 180, 0), Vector(-5740.8486, -9939.6943, 93.4942)},
		{"models/props_c17/handrail04_short.mdl",Angle(0, 180, 0), Vector(-5740.5571, -10243.002, 92.4759)},

		{"models/props_c17/handrail04_long.mdl",Angle(2, 1, 0), Vector(-6978.9014, -5982.3301, 92.4407)},
		{"models/props_c17/handrail04_long.mdl",Angle(0, 0, 0), Vector(-6977.083, -6110.5249, 92.4827)},
		{"models/props_c17/handrail04_short.mdl",Angle(0, -90, 0), Vector(-6746.1909, -5773.832, 92.2711)},
		{"models/props_c17/handrail04_short.mdl",Angle(1, -90, 0), Vector(-6874.1733, -5773.4243, 92.2795)},

		{"models/props_c17/handrail04_short.mdl",Angle(-1, 0, 0), Vector(-6265.5234, -6932.9277, 92.3159)},
		{"models/props_c17/handrail04_short.mdl",Angle(0, 0, 0), Vector(-6264.8901, -7154.6641, 92.3094)},
		{"models/props_c17/handrail04_short.mdl",Angle(0, -180, 0), Vector(-5743.4404, -6169.0181, 92.2892)},
		{"models/props_c17/handrail04_short.mdl",Angle(0, 180, 0), Vector(-5743.1309, -6397.7358, 92.2105)},
		{"models/props_c17/handrail04_short.mdl",Angle(0, 180, 0), Vector(-5742.7144, -6978.4458, 92.8469)},
		{"models/props_c17/handrail04_short.mdl",Angle(0, 180, 0), Vector(-5744.5093, -7226.228, 92.2259)},
		{"models/props_c17/handrail04_short.mdl",Angle(0, -180, 0), Vector(-5743.98, -7447.0991, 92.4018)},
		{"models/props_c17/handrail04_short.mdl",Angle(0, 180, 0), Vector(-5742.7593, -7697.8057, 92.2833)},
		--[[
			Post Office
		--]]

		{"models/props/cs_office/file_cabinet1_group.mdl",Angle(-2, 0, 0), Vector(-6673.0371, -7547.7466, 73.0357)},
		{"models/props/cs_office/file_cabinet1_group.mdl",Angle(0, 0, 0), Vector(-6675.8496, -7483.3325, 72.4256)},
		{"models/props/cs_office/file_cabinet1_group.mdl",Angle(0, -90, 0), Vector(-6599.873, -7465.2334, 72.4092)},
		{"models/props/cs_office/file_cabinet1_group.mdl",Angle(0, -90, 0), Vector(-6535.3218, -7465.1318, 72.4908)},
		{"models/props/cs_office/file_cabinet1.mdl",Angle(0, -90, 0), Vector(-6492.4521, -7466.1714, 72.3394)},
		{"models/props/cs_office/phone.mdl",Angle(0, 0, 1), Vector(-6468.8652, -7502.7827, 112.436)},
		{"models/props/cs_office/computer.mdl",Angle(1, 27, 0), Vector(-6473.9932, -7557.624, 112.3496)},
		{"models/props/cs_office/computer_case.mdl",Angle(0, 0, 0), Vector(-6466.5615, -7566.9541, 72.3484)},
		{"models/props/cs_office/offpaintinga.mdl",Angle(0, 0, 0), Vector(-6549.4609, -7950.5059, 161.69)},
		{"models/props/cs_office/file_cabinet1_group.mdl",Angle(0, 90, 0), Vector(-6779.4116, -7933.3203, 72.4153)},
		{"models/props/cs_office/file_cabinet1_group.mdl",Angle(0, 90, 0), Vector(-6843.7275, -7936.7949, 72.3555)},
		{"models/props/cs_office/file_cabinet1.mdl",Angle(0, 0, 0), Vector(-6901.8604, -7898.2319, 72.3009)},
		{"models/props/cs_office/file_cabinet1.mdl",Angle(0, 0, 0), Vector(-6901.7495, -7876.7866, 72.3212)},
		{"models/props/cs_office/file_cabinet1_group.mdl",Angle(0, 0, 0), Vector(-6901.8433, -7834.0967, 72.3788)},
		{"models/props/cs_office/file_cabinet1_group.mdl",Angle(0, 0, 0), Vector(-6901.8003, -7769.7163, 72.3206)},
		{"models/props/cs_office/file_cabinet1_group.mdl",Angle(0, 0, 0), Vector(-6898.644, -7705.4521, 72.4468)},
		{"models/props/cs_office/file_cabinet1_group.mdl",Angle(0, 0, 0), Vector(-6900.6323, -7640.3809, 72.419)},
		{"models/props/cs_office/file_box.mdl",Angle(0, -1, 0), Vector(-6902.4858, -7779.2573, 135.6461)},
		{"models/props/cs_office/computer.mdl",Angle(1, -137, 0), Vector(-6669.5508, -7620.438, 112.4068)},
		{"models/props/cs_office/phone.mdl",Angle(0, -172, 0), Vector(-6670.8828, -7647.6899, 112.452)},
		{"models/props/cs_office/computer.mdl",Angle(1, 166, 0), Vector(-6672.0747, -7690.6299, 112.4216)},
		{"models/props/cs_office/phone.mdl",Angle(0, 180, 0), Vector(-6668.0298, -7711.8838, 112.3487)},
		{"models/props/cs_office/computer.mdl",Angle(0, 119, 0), Vector(-6672.0703, -7782.2671, 112.4995)},
		{"models/props/cs_office/file_cabinet1_group.mdl",Angle(0, -180, 0), Vector(-6710.3276, -7836.5874, 72.5489)},
		-- Abandoned house

		{"models/props_building_Description/storefront_template001a_bars.mdl",Angle(90,  -12, 180), Vector(-3497.3455, 264.7752,   71.4998)},
		{"models/props_building_Description/storefront_template001a_bars.mdl",Angle(0,   -90,  90), Vector(-3137.0242, 377.1901,  130.4329)},
		{"models/props_building_Description/storefront_template001a_bars.mdl",Angle(0,   -90,  90), Vector(-2878.3218, 377.4739,  133.4899)},
		{"models/props_building_Description/storefront_template001a_bars.mdl",Angle(0,  -180,  90), Vector(-2368.5991, 258.4106,  130.5176)},
		{"models/props_building_Description/storefront_template001a_bars.mdl",Angle(-90, 108, 180), Vector(-2866.9126, -246.3613,  59.4992)},
		{"models/props_building_Description/storefront_template001a_bars.mdl",Angle(0,    90,  90), Vector(-3107.9187, -128.7067, 131.8513)},
		{"models/props_building_Description/storefront_template001a_bars.mdl",Angle(0,   -90, -90), Vector(-3274.6797, -129.4378, 132.2727)},
		{"models/props_building_Description/storefront_template001a_bars.mdl",Angle(0,     0,   0), Vector(-2996.592,  -92.0126,  280.5203)},
		{"models/props_building_Description/storefront_template001a_bars.mdl",Angle(0,    90,  90), Vector(-2876.8455, -129.0346, 257.8382)},
		{"models/props_building_Description/storefront_template001a_bars.mdl",Angle(0,    90,  90), Vector(-2506.125, -128.6424,  260.9136)},
		{"models/props_building_Description/storefront_template001a_bars.mdl",Angle(0,   180,  90), Vector(-2368.4807, -10.6787,  255.0532)},
		{"models/props_building_Description/storefront_template001a_bars.mdl",Angle(0,   180,  90), Vector(-2367.9731, 258.1483,  256.5274)},
		{"models/props_building_Description/storefront_template001a_bars.mdl",Angle(0,     0,   0), Vector(-2996.3367, 337.6346,  275.5337)},

		--[[ Fences round the industrial district 
		{"models/props_wasteland/exterior_fence002e.mdl",Angle(0, -90, 0), Vector(1827.6575, 5370.8389, 241.1559)},
		{"models/props_wasteland/exterior_fence002e.mdl",Angle(0, -90, 0), Vector(1314.8015, 5371.7397, 241.1559)},
		{"models/props_wasteland/exterior_fence002e.mdl",Angle(0, -90, 0), Vector( 801.9455, 5372.6406, 241.1559)},
		{"models/props_wasteland/exterior_fence002b.mdl",Angle(0, -90, 0), Vector( 513.7485, 5372.1211, 241.1560)},
		{"models/props_wasteland/exterior_fence002a.mdl",Angle(0, -90, 0), Vector( 464.2468, 5371.3696, 241.1560)},
		{"models/props_wasteland/exterior_fence002e.mdl",Angle(0,-180, 0), Vector( 431.5098, 5637.5483, 241.1560)},
		{"models/props_wasteland/exterior_fence002e.mdl",Angle(0,-180, 0), Vector( 431.1820, 6150.4053, 241.1560)},
		{"models/props_wasteland/exterior_fence002e.mdl",Angle(0,-180, 0), Vector( 430.8543, 6663.2617, 241.1560)},
		{"models/props_wasteland/exterior_fence002e.mdl",Angle(0,-180, 0), Vector( 430.5265, 7176.1182, 241.1560)},
		{"models/props_wasteland/exterior_fence002d.mdl",Angle(0,-180, 0), Vector( 430.4338, 7561.3569, 241.1561)},
		{"models/props_wasteland/exterior_fence002e.mdl",Angle(0,  90, 0), Vector( 697.9948, 7683.6201, 241.1582)},
		{"models/props_wasteland/exterior_fence002e.mdl",Angle(0,-180, 0), Vector( 945.0824, 7928.1313, 241.1576)},
		{"models/props_wasteland/exterior_fence002e.mdl",Angle(0,  90, 0), Vector(1210.3352, 8196.5391, 241.1551)},
		{"models/props_wasteland/exterior_fence002e.mdl",Angle(0,  90, 0), Vector(1723.1920, 8196.5537, 241.1536)},
		{"models/props_wasteland/exterior_fence002d.mdl",Angle(0,  90, 0), Vector(2107.7832, 8197.4258, 241.1580)},
		{"models/props_wasteland/exterior_fence002e.mdl",Angle(0, -90, 0), Vector(3516.6113, 5368.3105, 241.1575)},
		{"models/props_wasteland/exterior_fence002e.mdl",Angle(0,   0, 0), Vector(4282.7690, 6417.5708, 241.1707)},
		{"models/props_wasteland/exterior_fence002e.mdl",Angle(0,   0, 0), Vector(4280.0146, 7414.8667, 241.1558)},
		{"models/props_wasteland/exterior_fence002e.mdl",Angle(0,  90, 0), Vector(4021.3748, 7682.9839, 241.1559)},
		{"models/props_wasteland/exterior_fence002e.mdl",Angle(0, -90, 0), Vector(4022.8984, 3578.0061, 241.1571)},
		{"models/props_wasteland/exterior_fence002c.mdl",Angle(0, -90, 0), Vector(3442.2615, 3578.1147, 241.1563)},
		{"models/props_wasteland/exterior_fence002e.mdl",Angle(0,   0, 0), Vector(4283.6484, 3845.2668, 241.1561)},
		{"models/props_wasteland/exterior_fence002e.mdl",Angle(0,   0, 0), Vector(4283.6118, 4358.1235, 241.1562)},
		{"models/props_wasteland/exterior_fence002d.mdl",Angle(0,  89, 0), Vector(4142.3896, 4616.1040, 241.1568)},
		{"models/props_wasteland/exterior_fence002c.mdl",Angle(0,  90, 0), Vector(3949.1897, 4614.1284, 241.1597)},
--]]
	},
	rp_christmastown = {
		{"models/props/cs_office/computer.mdl",Angle(0, 0, 0), Vector(1213, -738, 48.3241)},
		{"models/props/de_inferno/picture1.mdl",Angle(0, -90, -2), Vector(-405.8738, 787.5409, 93.722)},
		{"models/props/de_inferno/picture3.mdl",Angle(0, 180, 0), Vector(-176, 456, 75)},
		{"models/props/de_inferno/picture2.mdl",Angle(0, 0, 0), Vector(-454, 448, 71)},
		{"models/props/de_inferno/picture3.mdl",Angle(0, -90, 0), Vector(-361.282, 624.76, 220.168)},
		{"models/props/de_inferno/picture1.mdl",Angle(0, -90, 0), Vector(-271.208, 624.76, 220.027)},
		{"models/props/cs_office/computer_monitor.mdl",Angle(0, 90, 0), Vector(-1320.9808, -1647.9951, -86.5881)},
		{"models/props/cs_office/computer_monitor.mdl",Angle(0, 90, 0), Vector(-1377.981, -1647.9951, -86.6079)},
		{"models/props/cs_office/computer.mdl",Angle(0, 90, 0), Vector(-623.631, -1374.63, 50)},
		{"models/props/cs_office/computer.mdl",Angle(0, 90, 0), Vector(-722, -1375, 50)},
		{"models/props_interiors/furniture_couch01a.mdl",Angle(0, -91, 0), Vector(-180.9948, -1310.9646, 29.7778)},
		{"models/props_c17/furniturefridge001a.mdl",Angle(0, 0, 0), Vector(-254.0316, -1473.1387, 45.2287)},
		{"models/props_c17/furniturefridge001a.mdl",Angle(0, 180, 0), Vector(308.0114, -1472.7457, 45.2959)},
		{"models/props_c17/furniturefridge001a.mdl",Angle(0, 180, -1), Vector(310.9576, -1473.2217, 174.4304)},
		{"models/props_interiors/furniture_couch01a.mdl",Angle(0, -91, 0), Vector(-179.0454, -1310.8112, 158.842)},
		{"models/props/cs_office/computer.mdl",Angle(0, 180, 0), Vector(41, -964, 50)},
		{"models/props_furniture/chair2.mdl",Angle(0, -180, 0), Vector(-186.952, -1079.9957, 37.4113)},
		{"models/props_furniture/chair2.mdl",Angle(0, 0, 0), Vector(-247.0443, -1080.0027, 37.4122)},
		{"models/props_furniture/chair2.mdl",Angle(0, -180, 0), Vector(-342.893, -1078.9662, 37.3853)},
		{"models/props_furniture/chair2.mdl",Angle(0, 0, 0), Vector(-403.0758, -1079.0208, 37.3714)},
		{"models/props_furniture/chair2.mdl",Angle(0, -180, 0), Vector(-341.0045, -747.0309, 37.3652)},
		{"models/props_furniture/chair2.mdl",Angle(0, 0, 0), Vector(-401.0816, -746.9895, 37.36)},
		{"models/props_wasteland/kitchen_counter001b.mdl",Angle(0, 90, 0), Vector(-550.0717, -822.3942, 28.5016)},
		{"models/props/cs_office/computer.mdl",Angle(0, 0, 0), Vector(889, -1218, 50)},
		{"models/props/de_tides/vending_cart.mdl",Angle(0, 41, 0), Vector(885.971, -1399, 8.4509)},
		{"models/props/de_tides/vending_cart.mdl",Angle(0, -178, 0), Vector(779.971, -1088, 8.4509)},
		{"models/props/cs_office/computer.mdl",Angle(0, -90, 0), Vector(981.664, -2057.9299, -83.6759)},
		{"models/props/cs_office/computer.mdl",Angle(0, -90, 0), Vector(1060.66, -2056.9299, -83.6759)},
		{"models/props/cs_office/computer_monitor.mdl",Angle(0, 90, 0), Vector(942.535, -2533.28, -86.6969)},
		{"models/props/cs_office/computer.mdl",Angle(0, 90, 0), Vector(-287, -3308, -46)},
		{"models/props/cs_office/computer.mdl",Angle(0, 90, 0), Vector(-102, -1415, -83.6759)},
		{"models/props/cs_office/computer.mdl",Angle(0, 90, 0), Vector(-181, -1416, -83.6759)},
		{"models/props/cs_office/computer_monitor.mdl",Angle(0, -178, 0), Vector(250.9921, -1720.998, -75.6205)},
		{"models/props_furniture/kitchen_chair.mdl",Angle(0, 88, 0), Vector(222.1425, -1541.2595, -125.6093)},
		{"models/props_furniture/kitchen_chair.mdl",Angle(0, -92, 0), Vector(224.7557, -1479.2506, -125.6144)},
		{"models/props_furniture/kitchen_chair.mdl",Angle(0, 131, 0), Vector(154.5446, -1726.4519, -125.594)},
		{"models/props_furniture/kitchen_chair.mdl",Angle(0, -124, 0), Vector(153.6811, -1677.7938, -125.6383)},
		{"models/props_furniture/kitchen_chair.mdl",Angle(0, 59, 0), Vector(103.262, -1729.6572, -125.5907)},
		{"models/props_furniture/kitchen_chair.mdl",Angle(0, -49, 0), Vector(102.7134, -1677.5481, -125.5942)},
		{"models/props_furniture/kitchen_chair.mdl",Angle(0, 135, 0), Vector(144.9676, -1594.8395, -125.6542)},
		{"models/props/cs_office/snowman_arm.mdl",Angle(0, 0, 0), Vector(-369.606, 43.5082, 46.1129)},
		{"models/props/cs_office/snowman_arm.mdl",Angle(0, 180, 0), Vector(-400.718, 43.2271, 46.1129)},
		{"models/props/cs_office/snowman_face.mdl",Angle(0, 180, 0), Vector(-384.718, 41.2271, 56.1129)},
		{"models/props/cs_office/computer_monitor.mdl",Angle(0, -90, 0), Vector(1149.63, -2360.8701, 38.3031)},
		{"models/props/cs_office/chair_office.mdl",Angle(0, 90, 0), Vector(1150.016, -2385.9905, 6.4936)},
		{"models/props/cs_office/file_cabinet1_group.mdl",Angle(0, -180, 0), Vector(1197.0579, -2475.9724, 6.4217)},
		{"models/props/cs_office/file_box.mdl",Angle(0, 0, 0), Vector(1196.9475, -2474.04, 69.9383)},
		{"models/props/cs_office/file_box.mdl",Angle(0, 1, 0), Vector(1196.988, -2453.4116, 69.9086)},
		{"models/props/cs_office/file_box.mdl",Angle(0, 0, 0), Vector(1197.2106, -2494.2129, 69.9331)},
		{"models/props/cs_office/file_box.mdl",Angle(0, 0, 0), Vector(1124.0437, -2522.9624, 69.8708)},
		{"models/props/cs_office/file_cabinet1_group.mdl",Angle(0, 90, 0), Vector(1120.9476, -2523.9395, 6.4305)},
		{"models/props/cs_office/file_cabinet1_group.mdl",Angle(0, 89, 0), Vector(904.2714, -2523.4819, 6.437)},
		{"models/props/cs_office/file_cabinet1_group.mdl",Angle(0, 90, 0), Vector(837.9291, -2523.9297, 6.407)},
		{"models/props/cs_office/file_box.mdl",Angle(0, -1, 0), Vector(829.6861, -2522.5815, 69.9074)},
		{"models/props/cs_office/file_box.mdl",Angle(0, 5, 0), Vector(879.0891, -2521.7407, 69.915)},
		{"models/props/cs_office/file_box.mdl",Angle(0, 19, 0), Vector(915.8109, -2523.8398, 69.8971)},
		{"models/props/cs_office/computer_monitor.mdl",Angle(0, -90, 0), Vector(881.358, -2363.8701, 38.3031)},
		{"models/props/cs_office/chair_office.mdl",Angle(0, 90, 0), Vector(881.0266, -2384.7551, 6.4987)},
		{"models/props/cs_office/computer_monitor.mdl",Angle(0, 90, 0), Vector(881.711, -2341.28, 38.3031)},
		{"models/props/cs_office/chair_office.mdl",Angle(0, -90, 0), Vector(880.9007, -2318.9817, 6.4973)},
		{"models/props/cs_office/file_cabinet1_group.mdl",Angle(0, -90, 0), Vector(867.9577, -2178.1765, 6.431)},
		{"models/props/cs_office/file_box.mdl",Angle(0, 0, 0), Vector(862.0788, -2175.1211, 69.872)},
		{"models/props/cs_office/file_cabinet1_group.mdl",Angle(0, 180, 0), Vector(1195.9305, -2255.0381, 6.4401)},
		{"models/props/cs_office/file_box.mdl",Angle(0, 0, 0), Vector(1197.9696, -2255.0298, 69.8952)},
		{"models/props/cs_office/file_cabinet1_group.mdl",Angle(0, -90, 0), Vector(1132.0453, -2182.0747, 6.4589)},
		{"models/props/cs_office/file_box.mdl",Angle(0, 0, 0), Vector(1134.8689, -2182.1545, 69.9206)},
		{"models/props/cs_office/computer_monitor.mdl",Angle(0, 90, 0), Vector(1124.71, -2341.28, 38.3031)},
		{"models/props/cs_office/chair_office.mdl",Angle(0, -90, 0), Vector(1126.0028, -2315.0217, 6.3339)},
		{"models/props_c17/door01_left.mdl",Angle(0, 90, 0), Vector(-292, 282, 61)},

	}
}
PLUGIN.Vehicles = {
--
	rp_evocity_v2d = {
		{"Chair_Office2",Angle(0, -180, 0), Vector(-8008.7178, -8763.1748, 2487.7378)},
		{"Chair_Office2",Angle(0, -90, 0), Vector(-7057.937, -8777.6709, 2615.7378)},
		{"Chair_Office1",Angle(0, 0, 0), Vector(-7745.5928, -9289.25, 2488.4351)},
		{"Chair_Office1",Angle(0, 0, 0), Vector(-8015.3027, -9277.5322, 2488.3423)},
	}
--]]
}
PLUGIN.Doors = {
	rp_evocity_v2d = {
		{"prop_door_rotating",Angle(0, 270, 0),"models/props_c17/door01_left.mdl",Vector(-2900.7458,-128.9905, 123.3125),"Condemned House"},
		{"prop_door_rotating",Angle(0, 180, 0),"models/props_c17/door01_left.mdl",Vector(-3384.7771, 293.0889, 123.3125),"Condemned House"},
		{"prop_door_rotating",Angle(0, 180, 0),"models/props_c17/door01_left.mdl",Vector(-2753.2751,  74.5746, 123.3125),"Condemned House"},
		{"prop_door_rotating",Angle(0,	90, 0),"models/props_c17/door01_left.mdl",Vector(-2488.9202, 161.1112, 123.3125),"Condemned House"},
		{"prop_door_rotating",Angle(0, 270, 0),"models/props_c17/door01_left.mdl",Vector(-2707.8459, 196.3791, 259.3125),"Condemned House"},
	}
}
function PLUGIN:InitPostPostEntity()

	local filtr = ents.Create( "filter_activator_name" );
	filtr:SetKeyValue( "targetname", "aj_Description" );
	filtr:SetKeyValue( "negated", "1" );
	filtr:Spawn();
	local mapname = game.GetMap():lower();
	local ent;
	if (self.ToSpawn[mapname]) then
		for _,tab in ipairs(self.ToSpawn[mapname]) do
			ent = ents.Create("prop_physics");
			if (IsValid(ent)) then
				ent:SetModel (tab[1]);
				ent:SetAngles(tab[2]);
				ent:SetPos   (tab[3]);
				ent.PhysgunDisabled = true;
				ent.m_tblToolsAllowed = {};
				ent:Spawn();
				local phys = ent:GetPhysicsObject();
				if (IsValid(phys)) then
					phys:EnableMotion(false);
				else
					ErrorNoHalt("Applejack (Details): Model has no physics! "..tab[1].."\n");
				end
				ent:Fire ( "setdamagefilter", "aj_Description", 0 );
				hook.Call("PropSpawned", GAMEMODE, tab[1], ent);
				cider.propprotection.GiveToWorld(ent);
				GAMEMODE.entities[ent] = ent;
			else
				ErrorNoHalt("Applejack (Details): Couldn't create model "..tab[1].."!");
			end
		end
	end
	if (self.Vehicles[mapname]) then
		local VehicleList = list.Get( "Vehicles" );
		local vehicle;
		for _,tab in ipairs(self.Vehicles[mapname]) do
			vehicle = VehicleList[tab[1]];
			if (not vehicle) then
				ErrorNoHalt("Applejack (Details): No Such vehicle "..tab[1].."!");
			else
				ent = ents.Create(vehicle.Class);
				if (not IsValid(ent)) then
					ErrorNoHalt("Applejack (Details): Could not create vehicle "..tab[1].."!");
				else
					ent:SetModel( vehicle.Model )
					-- Fill in the keyvalues if we have them
					if (vehicle.KeyValues ) then
						for k, v in pairs( vehicle.KeyValues ) do
							ent:SetKeyValue( k, v );
						end
					end
					ent:SetAngles(tab[2]);
					ent:SetPos   (tab[3]);
					ent:Spawn    ();
					ent:Activate ();
					ent.PhysgunDisabled = true;
					ent.m_tblToolsAllowed = {};
					ent.VehicleName 	= tab[1];
					ent.DisplayName		= vehicle.Name;
					ent.VehicleTable 	= vehicle;
					if (vehicle.Members) then
						table.Merge(ent, vehicle.Members);
					end
					local phys = ent:GetPhysicsObject();
					if (IsValid(phys)) then
						phys:EnableMotion(false);
					else
						ErrorNoHalt("Applejack (Details): Vehicle model has no physics! "..tab[1]);
					end
					ent:Fire("setdamagefilter", "aj_Description", 0);
					cider.propprotection.GiveToWorld(ent);
					GAMEMODE.entities[ent] = ent;
				end
			end
		end
	end
	if (self.Doors[mapname]) then
		for _,tab in ipairs(self.Doors[mapname]) do
			ent = ents.Create(tab[1]);
			if (not IsValid(ent)) then
				ErrorNoHalt("Applejack (Details): Could not create a door with class "..tab[1].."!");
			else
				ent:SetAngles(tab[2]);
				ent:SetModel (tab[3]);
				ent:SetPos   (tab[4]);
				if (tab[1] == "prop_dynamic") then
					ent:SetKeyValue("solid",		6   );
					ent:SetKeyValue("MinAnimTime",	1   );
					ent:SetKeyValue("MaxAnimTime",	5   );
				else
					ent:SetKeyValue("hardware",		1   );
					ent:SetKeyValue("distance",		90  );
					ent:SetKeyValue("speed",		100 );
					ent:SetKeyValue("returndelay",	-1  );
					ent:SetKeyValue("spawnflags",	8192);
					ent:SetKeyValue("forceclosed",	0   );
				end
				ent:Spawn   ();
				ent:Activate();
				ent.PhysgunDisabled = true;
				ent.m_tblToolsAllowed = {};
				ent._DoorState = "closed";
				ent._Autoclose = 30;
				cider.entity.makeOwnable(ent);
				ent:SetNWString("Name",tab[5]);
			end
		end
	end
end
function PLUGIN:InitPostEntity()
	timer.Simple(0, function()
		self.InitPostPostEntity(self);
	end)
end