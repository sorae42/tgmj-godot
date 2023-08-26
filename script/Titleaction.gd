extends Sprite2D

func _process(_delta):
	if Engine.get_frames_drawn() % 150 == 0:
		self.visible = !self.visible
