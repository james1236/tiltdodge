extends Sprite

func _ready():
	self.hide();
	self.scale.x = get_viewport().size.x/12;
	self.scale.y = get_viewport().size.y/12;

func _process(delta):
	pass;

