extends AudioStreamPlayer

var music = 0;
var framesSinceLastBeat = 0;
var framesSinceLastSeperate = 0;
var progressLastFrame = 0;
var beat = false;
var audible = true;

var musicArray = [
	{"file":preload("res://sounds/music/track1.ogg"),"length":82.21286, "beats":144, "bpm":105}, #82.21286  - 9   4bars = 36 bars = 144 beats (105bpm)
	{"file":preload("res://sounds/music/track2.ogg"),"length":51.948299,"beats":104, "bpm":120}, #51.948299 - 6.5 4bars = 26 bars = 104 beats (120bpm)
	{"file":preload("res://sounds/music/track3.ogg"),"length":103.594627,"beats":80, "bpm":110}, #loopBegin = 1106200  47.5 bars, 190 beats (80 reduced); (Loading tres instead of wav takes years)
];

func _ready():
	music = floor(rand_range(0,len(musicArray)));
	#music = 2;
	self.set_stream(musicArray[music].file);
	self.play();
	self.stream_paused = true;
	if (!audible):
		self.volume_db = -80;
	
func _process(delta):
	framesSinceLastBeat+=1;
	framesSinceLastSeperate+=1;
	var playPercentage = get_playback_position();# / musicArray[music].length;
	var beatLength = (musicArray[music].length/musicArray[music].beats);
	var beatMod = fmod(playPercentage, beatLength);
	#print(playPercentage);
	if (0.1 > beatMod && framesSinceLastBeat > 15 && progressLastFrame != playPercentage): #1 sec = 60 --- (bpm/60)/60 = beats per sec /60 = beats per frame
		framesSinceLastBeat = 0;
		beat = !beat;
		var backgroundField = get_node("../Game/BackgroundField");
		
		#Beat Cycle Size
		if (backgroundField.beatCycleSize):
			backgroundField.beatCycleSizeIndex+=1;
			if (backgroundField.beatCycleSizeIndex >= len(backgroundField.beatCycleSizes)):
				backgroundField.beatCycleSizeIndex = 0;
			for tile in get_node("../Game/BackgroundField").get_children():
				tile.set_scale(Vector2(backgroundField.beatCycleSizes[backgroundField.beatCycleSizeIndex],backgroundField.beatCycleSizes[backgroundField.beatCycleSizeIndex]));
		
		#Beat Cycle Texture
		if (backgroundField.beatCycleTexture):
			backgroundField.beatCycleTextureIndex+=1;
			if (backgroundField.beatCycleTextureIndex >= len(backgroundField.beatCycleTextures)):
				backgroundField.beatCycleTextureIndex = 0;
			for tile in get_node("../Game/BackgroundField").get_children():
				tile.set_texture(backgroundField.beatCycleTextures[backgroundField.beatCycleTextureIndex]);
		
		
		for enemy in get_node("../Game/EnemyField").get_children():
			if (enemy.type == "enemy"):
				if (beat):
					enemy.scale = Vector2(0.9166666,0.9166666);
				else:
					enemy.scale = Vector2(1,1);

	progressLastFrame = playPercentage;

		#if (framesSinceLastSeperate > 600 && get_node("../Game/EnemyField").seperated):
		#	get_node("../Game/EnemyField").unseperate();
		#	framesSinceLastSeperate = 0;
		#
		#if (framesSinceLastSeperate > 140 && get_node("../").timer > 10):
		#	if (music == 0):
		#		if (floor(playPercentage) == 35):
		#			framesSinceLastSeperate = 0;
		#			get_node("../Game/EnemyField").seperate();
		#	if (music == 1):
		#		if (floor(playPercentage) == 31):
		#			framesSinceLastSeperate = 0;
		#			get_node("../Game/EnemyField").seperate();