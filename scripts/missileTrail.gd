extends Sprite
var paused = false;

func _ready():
	self.scale.y = 1; #SCALE*4 = OFFSET/4
	self.centered = false;
	
	self.offset.x = -12;
	self.offset.y = 4/self.scale.y;
	
func pause():
	paused = true;
	get_children()[0].speed_scale = 0;
			
func unpause():
	paused = false;
	get_children()[0].speed_scale = 1;
