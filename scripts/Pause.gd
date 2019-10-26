extends Sprite


func _ready():
	pass

func _process(delta):
	set_position(Vector2(get_viewport().size.x-14,3));
	

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if (event.pressed):
			if (!get_node("../Game").paused):
				get_node("../Game").pause();
				get_node("../Overlay").show();
				hide();
			else:
				get_node("../Game").unpause();
				get_node("../Overlay").hide();


func _on_Area2D_mouse_entered():
	self.set_modulate(Color(1,1,1,0.5));


func _on_Area2D_mouse_exited():
	self.set_modulate(Color(1,1,1,1));
