--
-- Author: Sundyhy
-- Date: 2014-01-17 15:24:58
--
ActorData = {

playerData={
--	#兵种类型 	#攻击类型 0 对空 1 对陆 2 空陆	#等级 	#杀伤力 	#攻击频率 	#攻击范围	#卖出价格 	#升级所需金钱 	#图片帧 	#宽 	#高
	{"0", "2", "0", "7", "0.7", "110", "45", "60", "Tower1_1", "40", "59"},	--
	{"0", "2", "1", "15", "0.7", "120", "124", "105", "Tower1_2", "41", "57"},	--
	{"0", "2", "2", "32", "0.7", "110", "289", "220", "Tower1_3", "43", "58"},	--
	{"0", "2", "3", "55", "0.7", "140", "660", "495", "Tower1_4", "53", "59"},	--
	{"1", "1", "0", "16", "1.1", "100", "75", "75", "Tower2_1", "45", "62"},	--
	{"1", "1", "1", "36", "1.1", "100", "135", "135", "Tower2_2", "45", "64"},	--
	{"1", "1", "2", "75", "1.1", "100", "150", "270", "Tower2_3", "45", "67"},	--
	{"1", "1", "3", "135", "1", "100", "150", "550", "Tower2_4", "47", "70"},	--
	{"2", "0", "0", "9", "0.6", "120", "75", "75", "Tower3_1", "62", "57"},	--
	{"2", "0", "1", "22", "0.6", "130", "125", "125", "Tower3_2", "62", "63"},	--
	{"2", "0", "2", "45", "0.6", "140", "150", "175", "Tower3_3", "62", "71"},	--
	{"2", "0", "3", "80", "0.6", "150", "150", "225", "Tower3_4", "63", "90"},	--
	{"3", "2", "0", "4", "0.8", "110", "100", "120", "Tower4_1", "43", "62"},	--
	{"3", "2", "1", "9", "0.8", "110", "150", "225", "Tower4_2", "43", "67"},	--
	{"3", "2", "2", "19", "0.8", "110", "150", "350", "Tower4_3", "53", "73"},	--
	{"3", "2", "3", "30", "0.6", "110", "150", "700", "Tower4_4", "53", "74"},	--
	{"4", "1", "0", "75", "1", "95", "120", "120", "Tower5_1", "60", "70"},	--
	{"4", "1", "1", "135", "1", "100", "150", "240", "Tower5_2", "60", "84"},	--
	{"4", "1", "2", "200", "1", "105", "150", "360", "Tower5_3", "60", "76"},	--
	{"4", "1", "3", "300", "1", "110", "150", "750", "Tower5_4", "60", "81"},	--
	{"5", "2", "0", "0", "1", "80", "100", "240", "Tower6_1", "67", "60"},	--
	{"5", "2", "1", "0", "1", "80", "100", "420", "Tower6_2", "67", "62"},	--
	{"5", "2", "2", "0", "1", "110", "100", "600", "Tower6_3", "67", "70"},	--
	{"5", "2", "3", "0", "1", "110", "100", "800", "Tower6_4", "67", "94"},	--
	{"6", "2", "0", "20", "0.9", "125", "100", "250", "Tower7_1", "60", "75"},	--
	{"6", "2", "1", "45", "0.9", "125", "150", "450", "Tower7_2", "60", "75"},	--
	{"6", "2", "2", "95", "0.9", "125", "150", "650", "Tower7_3", "60", "75"},	--
	{"6", "2", "3", "165", "0.7", "150", "150", "1000", "Tower7_4", "60", "75"}
},	--
	
barrierData={
	--#id号 #种类 0占一格 1 占两格 2 占4格#HP #帧 #宽 #高
	{"0", "0", "500", "obstacles_1", "44", "57", "0", "0", "100"},	----#树
	{"1", "0", "500", "obstacles_2", "50", "65", "0", "0", "150"},	----#树
	{"2", "0", "500", "obstacles_3", "37", "71", "0", "0", "100"},	----#树
	{"3", "2", "2500", "obstacles_4", "119", "81", "0", "15", "500"},	----#树丛
	{"4", "0", "800", "obstacles_5", "59", "49", "0", "0", "100"},	-- --#石头
	{"5", "0", "1000", "obstacles_6", "39", "58", "0", "0", "150"},	----#石头
	{"6", "0", "800", "obstacles_7", "56", "64", "0", "0", "150"},	----#墓碑
	{"7", "0", "600", "obstacles_9", "49", "81", "0", "10", "100"},	----#稻草人
	{"8", "0", "500", "obstacles_11", "61", "77", "0", "5", "150"},	----#树
	{"9", "0", "500", "obstacles_12", "46", "97", "0", "5", "100"},	----#树
	{"10", "2", "3500", "obstacles_13", "109", "95", "0", "-15", "800"},	----#大成
	{"11", "0", "800", "obstacles_14", "56", "64", "0", "0", "150"},	----#墓碑
	{"12", "2", "2500", "obstacles_16", "119", "116", "0", "-15", "450"},	----#土堆
	{"13", "0", "600", "obstacles_18", "70", "66", "0", "0", "100"},	--	--#井
	{"14", "2", "800", "abstacleAni", "90", "132", "-25", "45", "300"},	----#火把
	{"15", "2", "400", "obstacles_27", "64", "64", "-25", "25", "100"},	----#小土堆
	{"16", "2", "2500", "obstacles_22", "108", "112", "0", "0", "500"},	----#树丛
	{"17", "0", "500", "obstacles_26", "51", "56", "0", "0", "150"},	----#果树
	{"18", "0", "500", "obstacles_20", "73", "76", "0", "0", "150"},	----#椰子树
	{"19", "0", "600", "obstacles_24", "42", "82", "0", "0", "150"},	----#石头
	{"20", "0", "500", "obstacles_25", "53", "50", "0", "0", "100"},	----#小石头
	{"21", "0", "400", "obstacles_10", "30", "72", "0", "0", "150"},	----#", "猫
	{"22", "0", "600", "obstacles_15", "58", "30", "0", "0", "150"},	----#", "篱笆
	{"23", "0", "600", "obstacles_21", "53", "78", "0", "0", "200"}	----# 小树丛
},

enemyData={
	--#怪物种类 #空地属性 0 空1地 #怪物类型 0 普通怪 1 队长怪 2 BOSS怪#怪物攻击力#怪物状态数  #速度 #掉钱数       #动画名 #宽 #高
	{"0", "1", "0", "5", "1", "40", "10", "a1", "50", "60", "monster1_1"},	--	
	{"1", "0", "0", "6", "1", "40", "10", "a1", "72", "76", "monster1_1"},	--	
	{"2", "1", "1", "7", "1", "40", "150", "a1", "75", "90", "monster1_1"},	--
	{"3", "1", "0", "6", "1", "80", "10", "a2", "50", "50", "monster2_1"},	--
	{"4", "0", "0", "6", "1", "80", "10", "a2", "50", "50", "monster2_1"},	--
	{"5", "1", "1", "6", "1", "80", "150", "a2", "72", "76", "monster2_1"},	--
	{"6", "1", "0", "6", "1", "40", "10", "a3", "53", "69", "monster3_1"},	--
	{"7", "0", "0", "6", "1", "40", "10", "a3", "53", "69", "monster3_1"},	--
	{"8", "1", "1", "6", "1", "40", "150", "a3", "75", "90", "monster3_1"},	--
	{"9", "0", "0", "6", "1", "60", "10", "a4", "60", "48", "monster4_1"},	--
	{"10", "0", "0", "6", "1", "60", "10", "a4", "50", "50", "monster4_1"},	--
	{"11", "0", "1", "6", "1", "60", "150", "a4", "90", "75", "monster4_1"},	--
	{"12", "1", "0", "6", "1", "40", "10", "a5", "46", "60", "monster5_1"},	--
	{"13", "0", "0", "6", "1", "40", "10", "a5", "50", "50", "monster5_1"},	--
	{"14", "1", "1", "6", "1", "40", "150", "a5", "69", "90", "monster5_1"},	--
	{"15", "1", "2", "10", "1", "60", "300", "a6", "58", "82", "nil"},	--
	{"16", "0", "2", "10", "1", "80", "500", "a7", "95", "95", "nil"}

	--# 0-2 兽人步兵普通化，气球化，队长化 
	--# 3-5 狼骑兵  普通，气球，队长 
	--# 6-8 山岭兽人 普通，气球，队长 
	--# 9-11 始祖鸟骑兵 普通，气球，队长 
	--# 12-14 兽人祭祀 普通，气球，队长 
	--# 15  BOSS 巨型兽人剑圣 
	--# 16 BOSS 巨龙 
}

}
