extends Sprite

var paused = false;
var vector = Vector2(0,0);
var bearing = 0;
var posX = 0;
var posY = 0;
var type = "missile";
var frames = 0;
var magnitudeRand = rand_range(0.2,0.3);
var deviationMagnitude = 0;
var magnitude = 8;
var diameter = 6;
var ident = [-1,-1,-1];

# Called when the node enters the scene tree for the first time.
func _ready():
	self.vector.x+=(rand_range(0,1)*deviationMagnitude)-(0.5*deviationMagnitude);
	self.vector.y+=(rand_range(0,1)*deviationMagnitude)-(0.5*deviationMagnitude);
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (paused):
		return;
	
	frames+=1;
	
	#Set own rotation
	set_rotation(-get_parent().bearing);
	
	#Set trail rotation
	get_children()[0].set_rotation(get_parent().bearing+deg2rad(bearing));
	
	self.translate(vector*magnitude*magnitudeRand);
	
	#Despawn
	if (frames > 600):
		despawn();

func despawn():
	var index = get_parent().missileIdents.find(ident);
	if (index > -1):
		get_parent().missileIdents.remove(index);
		self.queue_free();

func pause():
	paused = true;
	
func unpause():
	paused = false;
