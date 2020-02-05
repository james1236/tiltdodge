extends Sprite

var goingUp = false;
var modulation = 255;
var bounceTimer = 0;

func _ready():
	pass # Replace with function body.

func _process(delta):
	#Animate on new score
	if ((get_node("../../Game").started or get_node("../../Game").dead) and (get_node("../../").gameTimer % 60 == 0 && self.scale.x != 1) and (get_node("../../").gameTimer > 1)):
		bounceTimer = 2;
		get_parent().position.y -= bounceTimer;
		get_node("../../Game/Player").scale = (Vector2(1+bounceTimer/10,1+bounceTimer/10));
		if (get_node("../../").timer == get_node("../../").highscore && get_node("../../").highscore > 0):
			self.set_modulate(Color(1,1,1,1));
	
	if (bounceTimer > 0):
		bounceTimer-=0.25;
		get_parent().position.y += 0.25;
		get_node("../../Game/Player").scale = (Vector2(1+bounceTimer/10,1+bounceTimer/10));
		
	#Run score updates only when paused or a +1 has been obtained (syncs +1s)
	if (get_node("../../Game").paused or get_node("../../").gameTimer % 60 == 0):
		var highscorePercentage = get_node("../../").highscore/100;
		if (0.02 > highscorePercentage):
			highscorePercentage = 0.02;
		elif (highscorePercentage > 1):
			highscorePercentage = 1;
			
		self.scale.x = highscorePercentage;
	
	#Run pulse animation when game is not playing only
	if (!get_node("../../Game").started):
		if (goingUp):
			modulation+=2;
		else:
			modulation-=2;
			
		if (modulation > 255):
			modulation = 255;
			goingUp = false;
		elif (modulation < 80):
			modulation = 80;
			goingUp = true;
			
		self.set_modulate(Color(1,1,1,float(modulation)/255));
		get_node("../XPText").set_modulate(Color(1,1,1,float(modulation+88)/255));
