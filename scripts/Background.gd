extends Sprite

var mirror = true;
var altColor;

func _ready():
	self.scale.x = get_viewport().size.x/24;
	self.scale.y = get_viewport().size.y/24;

func _process(delta):
	if (mirror):
		self.set_modulate(get_node("../Game/BackgroundField").new_color);
	else:
		if (typeof(altColor) == TYPE_STRING && altColor == "rand3"):
			var rand = floor(rand_range(0,3));
			if (rand == 0):
				altColor = Color(0.0,0.5,1.0,1.0);
			elif (rand == 1):
				altColor = Color(1.0,0.0,1.0,1.0);
			else:
				altColor = Color(0.0,1.0,0.0,1.0);
			
		self.set_modulate(altColor);

