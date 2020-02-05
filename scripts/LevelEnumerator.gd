extends Node

var levels = [
	{ #0 - Default (Cycle)
		"Main": {
			
		},
		
		"Background": {
			"mirror": true,
		},
		
		"BackgroundField": {
			"enemyTexture":preload("res://images/backgrounds/background24.png"),
			"beatCycleTexture":false,
			"count": 34,#44
			"seperation": 16,
			"size": 1,
			"beatCycleSize":false,
			"frozen": true,
			"frozenRotation": false,
			"frozenTileRotation": false,
			"randomTileRotation": false,
			
			"speed": 10,
			
			"hueCycle": true,
		},
	},
	{ #1 - Grid (Red)
		"Main": {
			
		},
		
		"Background": {
			"mirror": false,
				"altColor":Color(214.0/255,0.0,0.0,1.0),
		},
		
		"BackgroundField": {
			"enemyTexture":preload("res://images/backgrounds/background24.png"),
			"beatCycleTexture":false,
			"count": 34,
			"seperation": 16,
			"size": 0.5,
			"beatCycleSize":false,
			"frozen": true,
			"frozenRotation": false,
			"frozenTileRotation": true,
			"randomTileRotation": false,
			
			"speed": 10,
			
			"hueCycle": false,
				"altColor": Color.red,
		},
	},
	{ #2 - Shapes (Blue)
		"Main": {
			
		},
		
		"Background": {
			"mirror": false,
				"altColor": Color.blue,
		},
		
		"BackgroundField": {
			"enemyTexture":preload("res://images/backgrounds/background3.png"),
			"beatCycleTexture":true,
				"beatCycleTextures":[
					preload("res://images/backgrounds/background3.png"),
					preload("res://images/backgrounds/background3.png"),
					preload("res://images/backgrounds/background4.png"),
					preload("res://images/backgrounds/background4.png"),
					preload("res://images/backgrounds/background5.png"),
					preload("res://images/backgrounds/background5.png"),
				],
			"count": 34,
			"seperation": 16,
			"size": 0.35,
			"beatCycleSize":true,
				"beatCycleSizes":[0.35,0.25],
			"frozen": true,
			"frozenRotation": true,
			"frozenTileRotation": true,
			"randomTileRotation": false,
			
			"speed": 10,
			
			"hueCycle": false,
				"altColor": Color(0,0,0,0.1),
		},
	},
	{ #3 - Big Doritos (Rand3)
		"Main": {

		},
		
		"Background": {
			"mirror": false,
				"altColor": "rand3",
		},
		
		"BackgroundField": {
			"enemyTexture":preload("res://images/backgrounds/background3.png"),
			"beatCycleTexture":false,
				"beatCycleTextures":[
					preload("res://images/backgrounds/background3.png"),
					preload("res://images/backgrounds/background3.png"),
					preload("res://images/backgrounds/background4.png"),
					preload("res://images/backgrounds/background4.png"),
					preload("res://images/backgrounds/background5.png"),
					preload("res://images/backgrounds/background5.png"),
				],
			"count": 22,
			"seperation": 32,
			"size": 0.85,
			"beatCycleSize":true,
				"beatCycleSizes":[0.85,0.75],
			"frozen": false,
			"frozenRotation": false,
			"frozenTileRotation": false,
			"randomTileRotation": true,
			
			"speed": 10,
			
			"hueCycle": false,
				"altColor": Color(0,0,0,0.04),
		},
	},
	{ #4 - Crystals (Purple)
		"Main": {

		},
		
		"Background": {
			"mirror": false,
				"altColor":Color.magenta,
		},
		
		"BackgroundField": {
			"enemyTexture":preload("res://images/backgrounds/background5.png"),
			"beatCycleTexture":false,
			"count": 10,
			"seperation": 64,
			"size": 8,
			"beatCycleSize":false,
			"frozen": true,
			"frozenRotation": false,
			"frozenTileRotation": false,
			"randomTileRotation": true,
			
			"speed": 10,
			
			"hueCycle": false,
				"altColor": Color(0,0,1,0.1),
		},
	},
];

var nameToPath = {
	"Main":"../",
	"Background":"../Background",
	"BackgroundField":"../Game/BackgroundField",
};

func _ready():
	randomize();
	loadLevel(floor(rand_range(0,len(levels))));
	#loadLevel(3);

func loadLevel(level):
	var levelObj = levels[level];
	for obj in levelObj.keys():
		for prop in levelObj.get(obj).keys():
			get_node(nameToPath.get(obj)).set(prop,levelObj.get(obj).get(prop));
