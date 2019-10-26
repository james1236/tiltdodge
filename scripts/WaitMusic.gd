extends AudioStreamPlayer

var fadeout = false;

func _ready():
	self.play();

func _process(delta):
	if ((self.stream_paused or fadeout) && (!get_node("../../Game").started or get_node("../../Game").dead)):
		if (!fadeout):
			self.volume_db = -40;
			self.stop();
			self.play();
		else:
			fadeout = false;
		self.stream_paused = false;
	elif ((!self.stream_paused and !fadeout) && (get_node("../../Game").started and !get_node("../../Game").dead)):
		fadeout = true;
		
	if (0 > self.volume_db && !fadeout):
		self.volume_db+=0.3;
	
	if (self.volume_db > -40 && fadeout):
		self.volume_db -=1;
	elif (fadeout):
		self.stream_paused = true;
		fadeout = false;
