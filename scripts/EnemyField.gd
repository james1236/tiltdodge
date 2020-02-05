extends Node2D

var paused = false;
var bearing = 0;
var magnitudeX = 0;
var magnitudeY = 0;
var noise = OpenSimplexNoise.new();
var distance = 0;
var pace = 0.1;
var difficulty = 0;
var difficultyTuning = 2;

var count = 25;
var seperation = 50;
var frozen = false;

var seperating = false;
var seperatingOut = false;
var seperated = false;
var seperationAnimationTimer = 0;

var enemyTexture = preload("res://images/enemy.png");
var enemyScript = preload("res://scripts/enemy.gd");

var missileTexture = preload("res://images/missile.png");
var missileScript = preload("res://scripts/missile.gd");
var missileTrailTexture = preload("res://images/missiletrail.png");
var missileTrailParticlesTexture = preload("res://images/trailparticle.png");
var missileTrailParticleShader = preload("res://shaders/trailParticleShader.tres");
var missileTrailScript = preload("res://scripts/missileTrail.gd");

var missileIdents = [];

func _ready():
	randomize();
	noise.seed = randi();
	noise.octaves = 4;
	noise.period = 20.0;
	noise.persistence = 0.8;
	setBearing(rand_range(0,360));
	generateEnemies();
	
func _process(delta):
	if (paused):
		return;
		
	if (get_parent().startInput && !frozen):
		if (2 > difficulty):
			difficulty+=0.01;
		else:
			if (3.2 > difficulty):
				difficulty+=0.001;
		
		#Scheduled Events
		var gameTimer = get_node("../../").gameTimer;
		if (gameTimer > 0):
			if (gameTimer % (10*60) == 0):
				#var alarmSfx = get_node("../../Music/AlarmSFX");
				#alarmSfx.stop();
				#alarmSfx.play();
				generateMissiles(floor(6.5*difficulty));
	else:
		difficulty = 0;
		
	distance = distance + pace;
	magnitudeX = noise.get_noise_2d(distance,0)*(difficulty/difficultyTuning);
	magnitudeY = noise.get_noise_2d(distance,100000)*(difficulty/difficultyTuning);
	setBearing(getBearing()+noise.get_noise_2d(100000,distance)*(difficulty/difficultyTuning));
	
	#Set own rotation
	set_rotation(bearing);
	
	#Make enemy rotation fixed
	for enemy in get_children():
		enemy.set_rotation(-bearing);
	
	self.translate(Vector2(magnitudeX,magnitudeY));
	
	##Full negation of translation
	var distance = self.position.distance_squared_to(Vector2(0,0));
	
	if (distance > 40000):
		#Undo translation
		translate(Vector2(-magnitudeX,-magnitudeY));
	#Half negation of translation
	elif (distance > 35000):
		#Undo translation
		translate(Vector2(-magnitudeX/2,-magnitudeY/2));
	
	#Seperation Stuff
	if (seperating):
		seperationAnimationTimer+=1;
		if (seperationAnimationTimer > 100):
			seperating = false;
			if (seperatingOut):
				seperated = true;
				generateMissiles(20);
			else:
				seperated = false;
			seperationAnimationTimer = 100;
		
		if (50 > seperationAnimationTimer):
			for enemy in get_children():
				var tweenFactor = sin(((seperationAnimationTimer/10))*(360/10));
				var amount = 0.1;
				if (!(!seperatingOut && enemy.type == "missile")):
					enemy.translate(Vector2(enemy.posX*amount*tweenFactor,enemy.posY*amount*tweenFactor));
		else:
			for enemy in get_children():
				var amount = 0.4;
				if (!seperatingOut):
					amount*=-1;
				if (!(!seperatingOut && enemy.type == "missile")):
					enemy.translate(Vector2(enemy.posX*amount,enemy.posY*amount));

func setBearing(deg):
	bearing = deg2rad(deg)-PI/2;

func getBearing():
	return rad2deg(bearing+PI/2);
	
func generateEnemies():
	for x in range(0,count/2):
		for y in range(0,count/2):
			var enemy = Sprite.new();
			enemy.set_texture(enemyTexture);
			enemy.translate(Vector2(x*seperation-(count/4)*seperation,y*seperation-(count/4)*seperation));
			enemy.set_script(enemyScript);
			enemy.posX = x-(count/4);
			enemy.posY = y-(count/4);
			if (enemy.posX == 0 && enemy.posY == 0):
				enemy.center = true;
			#enemy.hide();
			self.add_child(enemy);
			
func generateMissiles(quantity=1,meteor=false):
	for iteration in range(0,quantity):
		var attempt = 0;
		var i;
		var j;
		var k;
		
		while (attempt < 100):
			i = floor(rand_range(0,count/2)); #count/4
			j = floor(rand_range(0,2));
			k = floor(rand_range(0,2));

			var index = missileIdents.find(String([i,j,k]));
			if (index == -1):
				break;
			attempt+=1;
		
		if (attempt >= 100 or len(missileIdents) > 75):
			break;
		
		#print("len(missileIdents): ",len(missileIdents));
		
		var missile = Sprite.new();
		var missileTrail = Sprite.new();
		missile.set_texture(missileTexture);
		missileTrail.set_texture(missileTrailTexture);
		missile.set_script(missileScript);
		missileTrail.set_script(missileTrailScript);
		missile.ident = String([i,j,k]);
		missileIdents.push_front(missile.ident);
		if (meteor):
			missile.deviationMagnitude = 0.1;
			missile.scale = Vector2(2,2);
			missile.magnitude = 7;
			missile.diameter = 16;
			
		var missileTrailParticles = Particles2D.new();
		missileTrailParticles.amount = 9;
		missileTrailParticles.lifetime = 2;
		missileTrailParticles.speed_scale = 1.5;
		missileTrailParticles.texture = missileTrailParticlesTexture;
		missileTrailParticles.process_material = missileTrailParticleShader;
		
		if (j == 0):
			if (k == 0):
				missile.translate(Vector2((count/4)*seperation,i*seperation-(count/4)*seperation-count));
				missile.vector = Vector2(-1,0);
				missile.posX = (count/4);
				missile.posY = i-(count/4)+(count/2);
				missile.bearing = 270;
			else:
				missile.translate(Vector2(-(count/4)*seperation,i*seperation-(count/4)*seperation-count));
				missile.vector = Vector2(1,0);
				missile.posX = -(count/4);
				missile.posY = i-(count/4)+(count/2);
				missile.bearing = 90;
		else:
			if (k == 0):
				missile.translate(Vector2(i*seperation-(count/4)*seperation-count,(count/4)*seperation));
				missile.vector = Vector2(0,-1);
				missile.posX = i-(count/4)+(count/2);
				missile.posY = (count/4);
				missile.bearing = 0;
			else:
				missile.translate(Vector2(i*seperation-(count/4)*seperation-count,-(count/4)*seperation));
				missile.vector = Vector2(0,1);
				missile.posX = i-(count/4)+(count/2);
				missile.posY = -(count/4);
				missile.bearing = 180;
		
		missile.add_child(missileTrail);
		missileTrail.add_child(missileTrailParticles);
		self.add_child(missile);

func seperate():
	seperating = true;
	seperatingOut = true;
	seperationAnimationTimer = 0;

func unseperate():
	seperating = true;
	seperatingOut = false;
	seperationAnimationTimer = 00;

func pause():
	paused = true;
	for child in get_children():
		if (child.has_method("pause")):
			child.pause();

func unpause():
	paused = false;
	for child in get_children():
		if (child.has_method("unpause")):
			child.unpause();
