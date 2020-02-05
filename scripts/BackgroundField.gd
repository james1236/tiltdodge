extends Node2D

var paused = false;
var bearing = 0;
var magnitude = 0;
var noise = OpenSimplexNoise.new();
var distance = 0;
var pace = 0.1;
var enemyTexture = preload("res://images/backgrounds/background24.png");
var enemyScript = preload("res://scripts/backgroundTile.gd");
var count = 44;
var seperation = 16;
var size = 1;
var frozen = false;
var frozenRotation = false;
var frozenTileRotation = false;
var randomTileRotation = false;
var beatCycleSize = false;
var beatCycleSizes;
var beatCycleSizeIndex = 0;
var beatCycleTexture = false;
var beatCycleTextures;
var beatCycleTextureIndex = 0;

var hue_timer = 0;
var speed = 10;
var new_color = Color();

var hueCycle = true;
var altColor;

func _ready():
	randomize();
	noise.seed = randi();
	hue_timer = rand_range(0,360);
	noise.octaves = 4;
	noise.period = 20.0;
	noise.persistence = 0.8;
	generateEnemies();
	setBearing(rand_range(0,360));
	if (!frozenRotation):
		set_rotation(bearing);
	_process(-1);
	
func _process(delta):
	if (delta != -1):
		if (paused or !get_node("../").started):
			return;
	
	distance = distance + pace;
	magnitude = noise.get_noise_2d(distance,0);
	setBearing(getBearing()+(noise.get_noise_2d(-100000,distance)));
	
	if (!frozen):
		translate(Vector2(magnitude,magnitude));
		if (self.position.distance_squared_to(Vector2(0,0)) > 5000):
			translate(Vector2(-magnitude,-magnitude));
		
	if (!frozenRotation):
		#Set own rotation
		set_rotation(bearing);
		if (!frozenTileRotation):
			#Set tiles rotations
			for tile in get_children():
				tile.set_rotation(tile.bearing+bearing);
	
	
	#https://godotengine.org/qa/5393/how-create-color-transition-of-sprite-around-the-color-wheel
	#Simple number that goes from 0 to 360 and repeats.
	hue_timer = fmod(hue_timer + 0.02 * speed, 360);
	var h = hue_timer / 360 #h,s,v needs to be in range 0-1
	
	#New color, the order MUST be set in V,S,H, this is because Color
	#only saves RGB values, it does not save HSV values.
	new_color = Color()
	new_color.v = 1 #value
	new_color.s = 1 #saturation
	new_color.h = h #hue
	
	if (hueCycle):
		self.set_modulate(new_color);
	else:
		if (typeof(altColor) == TYPE_STRING && altColor == "rand3"):
			var rand = floor(rand_range(0,3));
			if (rand == 0):
				altColor = Color(0.0,0.5,1.0,1.0);
			elif (rand == 1):
				altColor = Color(1.0,0.0,1.0,1.0);
			else:
				altColor = Color(0.0,1.0,0.0,1.0);
				
		self.set_modulate(altColor);

func setBearing(deg):
	bearing = deg2rad(deg)-PI/2;

func getBearing():
	return rad2deg(bearing+PI/2);
	
func getMagnitude():
	return magnitude;
	
func generateEnemies():
	for x in range(0,count/2):
		for y in range(0,count/2):
			var enemy = Sprite.new();
			enemy.set_scale(Vector2(size,size));
			enemy.set_texture(enemyTexture);
			enemy.translate(Vector2(x*seperation-(count/4)*seperation,y*seperation-(count/4)*seperation));
			enemy.set_script(enemyScript);
			if (randomTileRotation):
				enemy.bearing = rand_range(0,360);
			#enemy.hide();
			self.add_child(enemy);
		
func pause():
	paused = true;
		
func unpause():
	paused = false;
		
