extends Node

var screen = 0
var oldscreen = 0

func _ready() -> void:
	$BlackOverlay.modulate = Color(1,1,1,(100 - Globals.brightness) / 100.0)
	var tween = create_tween()
	tween.tween_property($Black, "modulate", Color.TRANSPARENT, 1)
	
func _input(event):
	if event.is_action_pressed("key_service"):
		get_tree().change_scene_to_file("res://screen/service.tscn")
		
	if event.is_action_pressed("ui_accept"):
		$Black.modulate = Color.BLACK
		get_tree().change_scene_to_file("res://screen/game.tscn")

