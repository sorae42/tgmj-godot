extends Node

var game_start = false

func _ready():
	$BlackOverlay.modulate = Color(1,1,1,(100 - Globals.brightness) / 100.0)
	AudioServer.set_bus_volume_db(0, -20)
	
	# temporary
	#$sound/bgm.play()
	
	# set up the annoucer
	var tween = create_tween()
	tween.tween_property($announcer_ready, "modulate", Color(1,1,1,1), 0.5)
	tween.tween_property($announcer_ready, "modulate", Color(1,1,1,1), 0.5)
	tween.tween_property($announcer_ready, "modulate", Color(1,1,1,0), 0.5)
	tween.tween_property($announcer_ready, "modulate", Color(1,1,1,1), 0.5)
	tween.tween_property($announcer_ready, "modulate", Color(1,1,1,1), 0.5)
	tween.tween_property($announcer_ready, "modulate", Color(1,1,1,0), 0.5)
	$sound/ready_go.stream = load("res://data/se/ready.ogg")
	$sound/ready_go.play()
	
	await get_tree().create_timer(1.5).timeout
	$announcer_ready.frame = 1
	$sound/ready_go.stream = load("res://data/se/go.ogg")
	$sound/ready_go.play()
	
	await get_tree().create_timer(1.5).timeout
	game_start = true
	
func _input(event):
	if event.is_action_pressed("key_service"):
		get_tree().change_scene_to_file("res://screen/service.tscn")
