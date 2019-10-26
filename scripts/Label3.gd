extends Label

var drawScale = 0.5;
var frames = 0;
var paused = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if (paused):
		return;
		
	frames+=1;
	
	if (get_parent().startInput):
		if (drawScale > -0.1):
			drawScale-=0.05;
			self.rect_scale.x = drawScale;
			self.rect_scale.y = drawScale;
			if (0.05 > drawScale):
				frames = 0;
				set_position(Vector2(-68.57,-23.55));
				self.hide();
	else:
		if (drawScale > -0.1):
			self.show();
			self.rect_scale.x = drawScale;
			self.rect_scale.y = drawScale;
			self.rect_position.y+= sin(frames/8 % 1000)/10;
			
func pause():
	paused = true;
	
func unpause():
	paused = false;