extends Node2D

var paused = true;
var started = false;
var startInput = false;
var dead = false;

var glitchIndex = 0;

var glitchTextures = [
	preload("res://images/player/skin0/player.png"),
	preload("res://images/player/skin0/playerglitchl1.png"),
	preload("res://images/player/skin0/playerglitchl2.png"),
	preload("res://images/player/skin0/playerglitchl3.png"),
	preload("res://images/player/skin0/playerglitchl2.png"),
	preload("res://images/player/skin0/playerglitchl1.png"),
	preload("res://images/player/skin0/player.png"),
	preload("res://images/player/skin0/playerglitchr1.png"),
	preload("res://images/player/skin0/playerglitchr2.png"),
	preload("res://images/player/skin0/playerglitchr3.png"),
	preload("res://images/player/skin0/playerglitchr2.png"),
	preload("res://images/player/skin0/playerglitchr1.png"),
];

func _ready():
	translate(Vector2(get_viewport().size.x/2,get_viewport().size.y/2));

func _process(delta):
	var music = get_node("../Music");
	var change = false;
	
	if (started && !dead):
		music.stream_paused = false;
		if (music.pitch_scale < 0.98):
			music.pitch_scale+=0.02;
			change = true;
		else:
			glitchIndex = 0;
			get_node("Player").set_texture(glitchTextures[0]);
	elif (dead):
		if (music.pitch_scale > 0.1):
			music.pitch_scale-=0.02;
			change = true;
		else:
			music.stream_paused = true;
			glitchIndex = 0;
			get_node("Player").set_texture(glitchTextures[0]);
			
	if (change):
		glitchIndex+=1;
		if (glitchIndex > 11):
			glitchIndex = 0;
		if (!dead or glitchIndex%2 == 0):
			get_node("Player").set_texture(glitchTextures[glitchIndex]);

func _input(event):
	var keyboardCondition = (get_node("Player").controlScheme == "keyboard" && event is InputEventKey && Input.is_action_pressed("start"));
	if (event is InputEventScreenTouch) or keyboardCondition:
		if (keyboardCondition or event.pressed):
			if (!startInput):
				startInput = true;
				get_node("../XPBar").doHide();
			if (paused):
				get_node("../Overlay").hide();
				get_node("../Pause").show();
				if (dead):
					if (get_node("../Music").stream_paused):
						respawn();
				else:
					unpause();
			else:
				#Test - Live background change
				#get_node("../LevelEnumerator").loadLevel(floor(rand_range(0,len(get_node("../LevelEnumerator").levels))));
				#for tile in get_node("BackgroundField").get_children():
				#	tile.queue_free();
				#get_node("BackgroundField")._ready();
	
				if (get_node("Player").controlScheme == "joystick"):
					var joystick = get_node("../Joystick");
					joystick.show();
					joystick.position = event.position;
					joystick.get_node("JoystickFinger").position = Vector2.ZERO;
		else:
			if (get_node("Player").controlScheme == "joystick"):
				var joystick = get_node("../Joystick");
				joystick.get_node("JoystickFinger").position = Vector2.ZERO;
				joystick.hide();
				
	if event is InputEventScreenDrag:
		if (get_node("Player").controlScheme == "joystick"):
			var joystick = get_node("../Joystick");
			joystick.get_node("JoystickFinger").set_position(event.position-joystick.position);

			#Bounds
			while (joystick.get_node("JoystickFinger").position.distance_to(Vector2.ZERO) > 40):
				var bearing = joystick.get_node("JoystickFinger").position.angle_to_point(Vector2.ZERO);
				var x = -cos(bearing)*2;
				var y = -sin(bearing)*2;
				joystick.get_node("JoystickFinger").translate(Vector2(x,y));
				
func respawn():
	randomize();
	
	get_node("../LevelEnumerator").loadLevel(floor(rand_range(0,len(get_node("../LevelEnumerator").levels))));
	for tile in get_node("BackgroundField").get_children():
		tile.queue_free();
	get_node("BackgroundField")._ready();
	
	dead = false;
	startInput = false;
	started = false;
	get_parent().resetTimer();

	get_node("BackgroundField").set_position(Vector2.ZERO);
	get_node("BackgroundField").setBearing(rand_range(0,360));
	get_node("BackgroundField").set_rotation(get_children()[0].bearing);
	get_node("BackgroundField").hue_timer = rand_range(0,360);
	get_node("BackgroundField")._process(-1);
	get_node("Player").set_position(Vector2.ZERO);
	get_node("Player").set_scale(Vector2.ONE);
	get_node("Player").set_modulate(Color.white);
	get_node("Player").collisionFreeFrames = 0;
	get_node("EnemyField").setBearing(rand_range(0,360));
	get_node("EnemyField").set_position(Vector2.ZERO);
	get_node("EnemyField").seperated = false;
	get_node("EnemyField").missileIdents = [];
	get_node("TapToStart").drawScale = 0.5;
	
	for enemy in get_node("EnemyField").get_children():
		enemy.queue_free();
	get_node("EnemyField").generateEnemies();
	
	for plus1 in get_node("Player").get_children():
		plus1.queue_free();
	
	get_node("../XPBar").doReveal();
	get_node("../Overlay").hide();
	get_node("../InvertShader").away();
	get_node("../Music/Plus1SFX").pitch_scale = 1;
	get_node("../Music/Plus1SFX/Plus1SFXLow").pitch_scale = 1;
	get_node("../Music/Plus1SFX/Plus1SFXHigh").pitch_scale = 1;
	
	get_node("../Music").setTrack()
	
	unpause();


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
