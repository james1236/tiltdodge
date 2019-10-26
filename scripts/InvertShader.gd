extends TextureRect

var paused = false;
var progress = 0.0;
var fade = false;

func _ready():
	self.hide();
	pass

func _process(delta):
	if (paused):
		return;
	
	if (fade && 10 > progress):
		progress+=1;
		self.set_modulate(Color(1,1,1,progress/10));

func reveal():
	if (!fade):
		self.show();
		self.fade = true;
		
func away():
	self.hide();
	self.fade = false;
	self.progress = 0.0;

func pause():
	paused = true;
	
func unpause():
	paused = false;