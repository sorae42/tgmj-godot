extends Node

var piece_history = []

@onready var board = $"../board" as Board

var current_piece
var next_piece

func _ready():
	for i in range(0, 4):
		piece_history.append(Blockdata.Blocks.Z)
		
	next_piece = get_piece(true)
	board.spawn_piece(next_piece, true)
	board.piece_locked.connect(on_piece_locked)
	
	await get_tree().create_timer(3).timeout
	put_piece()
	
func on_piece_locked():
	put_piece()
	
func put_piece():
	current_piece = next_piece
	next_piece = get_piece(false)
	board.spawn_piece(current_piece, false)
	board.spawn_piece(next_piece, true)
	randomize()
	$"../../sound/piece_spawn".stream = load("res://data/se/SEB_mino%d.ogg" % randi_range(1, 7))
	$"../../sound/piece_spawn".play()
	
# based on tgm randomizer
func get_piece(first_piece: bool):
	var tries = 4
	var attempt = 1
	var unique: bool = false
	var current: Blockdata.Blocks
	while (attempt < tries):
		if unique == true:
			break
			
		unique = true
		current = Blockdata.Blocks.values().pick_random()
		
		for piece in piece_history:
			if current == piece:
				unique = false
				break
				
		if first_piece == true:
			match current:
				Blockdata.Blocks.S, Blockdata.Blocks.Z, Blockdata.Blocks.O:
					tries += 1
					unique = false
		
		attempt += 1
		
	if unique == false:
		current = Blockdata.Blocks.values().pick_random()
		
	piece_history.pop_front()
	piece_history.append(current)

	return current
