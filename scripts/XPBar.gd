extends Sprite

var hiding = false;
var revealing = false;
var modulation = 157;

func _ready():
	self.set_position(Vector2(12,get_viewport().size.y-7));


func _process(delta):
	if (hiding or revealing):
		if (hiding):
			modulation-=5;
			if (0 > modulation):
				self.hide();
				hiding = false;
				modulation = 0;
			
		elif (revealing):
			modulation+=10;
			if (modulation > 255):
				revealing = false;
				modulation = 255;
		
		self.set_modulate(Color(1,1,1,float(modulation)/255))
		
func doHide():
	hiding = true;
	revealing = false;

func doReveal():
	self.show();
	revealing = true;
	hiding = false;
