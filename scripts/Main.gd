extends Node2D

var timer = 0;
var highscore = 0;
var gameTimer = 0;
var invertTime = 50*60;

func _ready():
	load_game();
	pass


func _process(delta):
	if (!get_node("Game").paused && get_node("Game").started):
		gameTimer+=1;
		timer = timer + 1.0/60.0;
		var formattedTimer = formatTimer(timer);
		get_node("Score").set_text(formattedTimer);
		if (timer > highscore):
			highscore = timer;
			get_node("Highscore").set_text("best "+formattedTimer);
			if (gameTimer % 60 == 0):
				get_node("Game/Player").generatePlus1();
				if (7 > get_node("Music/Plus1SFX").pitch_scale):
					get_node("Music/Plus1SFX").pitch_scale+=0.05;
				get_node("Music/Plus1SFX").play();
		
		#Invert Shader
		if (gameTimer == invertTime):
			get_node("InvertShader").reveal();
			
		#Spawn Missiles/Meteors
		if (gameTimer > 0 && gameTimer % 45 == 0):
			if (!(gameTimer > 50*60)):
				$Game/EnemyField.generateMissiles();
			else:
				$Game/EnemyField.generateMissiles(2,true);

func resetTimer():
	timer = 0;
	gameTimer = 0;
	get_node("Score").set_text("0.0");
	
func formatTimer(value):
	var formattedTimer = String(floor(value*10)/10);
	if (! "." in formattedTimer):
		formattedTimer = formattedTimer + ".0";
	return formattedTimer;
	
#https://docs.godotengine.org/en/3.1/tutorials/io/saving_games.html
func load_game():
	var f = File.new();
	if f.file_exists("user://savegame.bin"):
		f.open_encrypted_with_pass("user://savegame.bin", File.READ, "ASOD873q*21/2");
		highscore = f.get_var();
		
		var formattedTimer = formatTimer(highscore);
		get_node("Highscore").set_text("best "+formattedTimer);
		
		f.close();
		
func save_game():
	var f = File.new();
	f.open_encrypted_with_pass("user://savegame.bin", File.WRITE, "ASOD873q*21/2");
	f.store_var(highscore);
	f.close();