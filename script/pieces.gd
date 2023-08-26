extends Node2D
class_name Pieces

signal lock_piece(piece: Pieces)

var bounds = {
	"min_x": 124,
	"max_x": 196.5,
	"max_y": 194
}

var rotation_index = 0
var wall_kick
var piece_data
var is_next
var pieces = []
var other_pieces = []

@onready var scn_piece = preload("res://screen/piece.tscn")

var block_cells

func _ready():
	block_cells = Blockdata.cells[piece_data.block_type]
	
	for cell in block_cells:
		var piece = scn_piece.instantiate() as Piece
		pieces.append(piece)
		add_child(piece)
		if !Globals.mono_mode:
			piece.set_texture(piece_data.piece_texture)
		piece.position = cell * piece.get_size()

	#if is_next == false:
	wall_kick = Blockdata.wall_kicks_jlostz

func _input(event):
	if !find_parent("game").game_start: return
	
	# TODO: input event should be a state so DAS should be possible
	# use _process/_physics_process to handle movement
	if event.is_action_pressed("ui_left", true):
		move(Vector2.LEFT)
	if event.is_action_pressed("ui_right", true):
		move(Vector2.RIGHT)
	if event.is_action_pressed("ui_down", true):
		move(Vector2.DOWN)
	if event.is_action_pressed("key_A"):
		rotate_piece(1)
	if event.is_action_pressed("key_B"):
		rotate_piece(-1)
	if event.is_action_pressed("key_C"):
		rotate_piece(1)

func move(direction: Vector2):
	var new_pos = calc_global_pos(direction, global_position)
	if new_pos:
		global_position = new_pos
		return true
	return false
	
func calc_global_pos(direction: Vector2, starting_pos: Vector2):
	if collide_others(direction, starting_pos):
		return null
	if !within_bound(direction, starting_pos):
		return null
	return starting_pos + direction * pieces[0].get_size().x

func within_bound(direction: Vector2, starting_pos: Vector2):
	for piece in pieces:
		var new_pos = piece.position + starting_pos + direction * piece.get_size()
		if new_pos.x < bounds.get("min_x") || new_pos.x > bounds.get("max_x") || new_pos.y > bounds.get("max_y"):
			return false
	return true

func collide_others(direction: Vector2, starting_pos: Vector2):
	for tetromino in other_pieces:
		var tetromino_pieces = tetromino.pieces
		for tetromino_piece in tetromino_pieces:
			for piece in pieces:
				if starting_pos + piece.position + direction * piece.get_size().x == tetromino.global_position + tetromino_piece.position:
					return true
	return false
	
func rotate_piece(direction: int):
	if piece_data.block_type == Blockdata.Blocks.O:
		return
	if Globals.controlFlip: direction = -direction
		
	var original_index = rotation_index
	
	apply_rot(direction)
	
	rotation_index = wrap(rotation_index + direction, 0, 8)
	
	if !check_wall(rotation_index, direction):
		rotation_index = original_index
		apply_rot(-direction)
	
# HELP WANTED: Fix wall kick
# this is not a usual ARS wall kick rule
func check_wall(rotation_index: int, rotation_direction: int):	
	var wall_kick_index = pass_wall_check(rotation_index, rotation_direction)
	
	for i in wall_kick[0].size():
		var translation = wall_kick[wall_kick_index][i]
		if move(translation):
			return true
	return false
	
func pass_wall_check(rotation_index: int, rotation_direction: int):
	var wall_kick_index = rotation_index * 2
	if rotation_direction < 0:
		wall_kick_index -= 1
		
	return wrap(wall_kick_index, 0, wall_kick.size())
	
func apply_rot(direction: int):
	var rotation_matrix = Blockdata.clockwise_rotation_matrix if direction == 1 else Blockdata.counter_clockwise_rotation_matrix
	var piece_cell = Blockdata.cells[piece_data.block_type]
	
	for i in piece_cell.size():
		var cell = piece_cell[i]

		var coord = rotation_matrix[0] * cell.x + rotation_matrix[1] * cell.y
		piece_cell[i] = coord
		
	for i in pieces.size():
		var piece = pieces[i]
		piece.position = piece_cell[i] * piece.get_size()

func lock():
	$Timer.stop()
	lock_piece.emit(self)
	set_process_input(false)

var gravity = 4

func _physics_process(delta):
	if find_parent("game").game_start:
		if !move(Vector2.DOWN):
			set_lock_fade(1)
			get_tree().create_timer(1).timeout
			lock()

func _on_timer_timeout():
	pass
	
func set_lock_fade(duration: float):
	create_tween().tween_property(self, "modulate", Color8(100, 100, 100), duration)
