extends Node
class_name Board

signal piece_locked

@export var scn_piece: PackedScene

var piece_data
var is_next_piece
var next_piece

var ROW_COUNT = 20
var COLUMN_COUNT = 10

var pieces: Array[Pieces] = []

func spawn_piece(type: Blockdata.Blocks, is_next: bool):
	piece_data = Blockdata.data[type]
	var piece = scn_piece.instantiate() as Pieces
	
	piece.piece_data = piece_data
	piece.is_next = is_next_piece
	
	if is_next == false:
		piece.position = Vector2(116.5 + 8 * piece_data.spawn_pos_x, 42)
		piece.other_pieces = pieces
		piece.lock_piece.connect(on_piece_locked)
		add_child(piece)

func on_piece_locked(piece):
	pieces.append(piece)
	piece_locked.emit()
	clear_lines()

func clear_lines():
	var board_pieces = fill_board_pieces()
	clear_board_pieces(board_pieces)

func fill_board_pieces():
	var board_pieces  = []
	
	for i in ROW_COUNT:
		board_pieces.append([])
	
	for tetromino in pieces:
		var tetromino_pieces = tetromino.get_children().filter(func (c): return c is Pieces)
		for piece in tetromino_pieces:
			
			var row = (piece.global_position.y + piece.get_size().y / 2) / piece.get_size().y + ROW_COUNT / 2
			board_pieces[row - 1].append(piece)
	return board_pieces

func clear_board_pieces(board_pieces):
	var i = ROW_COUNT
		
	while i > 0:
		var row_to_analyze = board_pieces[i - 1]
		if row_to_analyze.size() == COLUMN_COUNT:
			clear_row(row_to_analyze)
			board_pieces[i - 1].clear()
			move_all_row_pieces_down(board_pieces, i)
			
		i-=1
	
func clear_row(row):
	for piece in row:
		piece.queue_free()	
	
func move_all_row_pieces_down(board_pieces, cleared_row_number):
	for i in range(cleared_row_number -1, 1, -1):
		var row_to_move = board_pieces[i - 1]
		# we hit an empty row no need to check further 
		if row_to_move.size() == 0:
			return false
		
		for piece in row_to_move:
			piece.position.y += piece.get_size().y
			board_pieces[cleared_row_number -1].append(piece)
		board_pieces[i - 1].clear()
