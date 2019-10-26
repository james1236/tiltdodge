extends Sprite

var paused = false;
var timer = 50;
var lifespan = 100.0;
var speed = 0.1;

func _ready():
	pass

func _process(delta):
	if (paused):
		return;
	
	timer+=1;
	self.set_modulate(Color(1.0,1.0,1.0,(lifespan-timer)/lifespan));
	self.translate(Vector2(0,-speed));
	if (timer > lifespan):
		self.queue_free();

func pause():
	paused = true;
	
func unpause():
	paused = false;
