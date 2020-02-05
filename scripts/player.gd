extends Sprite

var paused = false;
var radius = 8;

#keyboard, drag, tilt, joystick
var controlScheme = "tilt";
var death = true;
var gyro = Vector2.ZERO;
var collisionFreeFrames = 0;

var plus1Texture = preload("res://images/plus1.png");
var plus1Script = preload("res://scripts/plus1.gd");

func _ready():
	pass;

#biggest lag
func _process(delta):
	if (paused or !get_parent().startInput):
		return;
		
	if (5 < collisionFreeFrames):
		get_parent().started = true;
	
	if (controlScheme == "tilt"):
		#Tilt Controls
		var senseHorizontal = 5;
		var senseVertical = 5;
		var distance = self.position.distance_squared_to(Vector2(0,0));
		
		gyro = Input.get_gyroscope();
		if (gyro.x == 0 && gyro.y == 0 && gyro.z == 0):
			controlScheme = "joystick";
			$"../../Joystick".show();
			#	gyro = Input.get_accelerometer();
		
		#Switch gyro axis (oops)
		var temp = gyro.x;

		gyro.x = (gyro.y*senseHorizontal);
		gyro.y = (temp*senseVertical);
		
	elif (controlScheme == "drag"):
		#Mouse Test Controls
		var distance = get_global_position().distance_squared_to(get_viewport().get_mouse_position());
		var bearing = get_global_position().angle_to_point(get_viewport().get_mouse_position());
		gyro.x = -(cos(bearing)/1000)*(distance*6);
		gyro.y = -(sin(bearing)/1000)*(distance*6);
	
	elif (controlScheme == "keyboard"):
		gyro.x = 0;
		gyro.y = 0;
		
		var keySense = 1;
		if (Input.is_action_pressed("up")):
			gyro.y = -keySense;
		if (Input.is_action_pressed("down")):
			gyro.y = keySense;
		if (Input.is_action_pressed("left")):
			gyro.x = -keySense;
		if (Input.is_action_pressed("right")):
			gyro.x = keySense;
		if (Input.is_action_pressed("shift")):
			gyro.x = gyro.x * 0.5;
			gyro.y = gyro.y * 0.5;
		
	elif (controlScheme == "joystick"):
		var joystick = get_node("../../Joystick");
		var joystickFinger = joystick.get_node("JoystickFinger");
		
		var distance = Vector2.ZERO.distance_to(joystickFinger.position);
		var bearing = Vector2.ZERO.angle_to_point(joystickFinger.position);
		gyro.x = -cos(bearing)*distance/20;
		gyro.y = -sin(bearing)*distance/20;
		

	translate(Vector2(gyro.x,gyro.y));
	
	#Screen bounds
	if (0+radius > self.get_global_position().x):
		self.set_global_position(Vector2(0+radius+0.1,self.get_global_position().y));
	if (0+radius > self.get_global_position().y):
		self.set_global_position(Vector2(self.get_global_position().x,0+radius++0.1));
	if (get_viewport().size.x-radius < self.get_global_position().x):
		self.set_global_position(Vector2(get_viewport().size.x-radius-0.1,self.get_global_position().y));
	if (get_viewport().size.y-radius < self.get_global_position().y):
		self.set_global_position(Vector2(self.get_global_position().x,get_viewport().size.y-radius-0.1));
	
	var enemyCollide = false;
	var enemyCollided;
	for enemy in get_node("../EnemyField").get_children():
		enemy.set_modulate(Color.white);
		if (sqr(enemy.get_global_position().x-self.get_global_position().x) + sqr(self.get_global_position().y-enemy.get_global_position().y) < sqr(radius+(enemy.diameter/2))):
			enemyCollide = true;
			enemyCollided = enemy;
			break;
	
	if (enemyCollide):
		if (5 < collisionFreeFrames && death):
			#Die
			self.set_modulate(Color.red);
			enemyCollided.set_modulate(Color.red);
			get_parent().dead = true;
			get_parent().get_parent().save_game();
			get_parent().pause();
			get_node("../../Music/DeathSFX").play();
			for plus1 in get_children():
				plus1.queue_free();
		else:
			self.set_modulate(Color.darkgray);
			enemyCollided.set_modulate(Color.darkgray);
	else:
		collisionFreeFrames = collisionFreeFrames+1;
		self.set_modulate(Color.white);

func generatePlus1():
	get_node("../../XPBar").doReveal();
	var plus1 = Sprite.new();
	plus1.set_texture(plus1Texture);
	plus1.set_script(plus1Script);
	self.add_child(plus1);

func sqr(num):
	return num*num;
	
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
