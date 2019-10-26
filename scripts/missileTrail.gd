extends Sprite

func _ready():
	self.scale.y = 1; #SCALE*4 = OFFSET/4
	self.centered = false;
	
	self.offset.x = -12;
	self.offset.y = 4/self.scale.y;