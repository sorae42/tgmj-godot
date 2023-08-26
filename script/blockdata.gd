extends Node

enum Blocks {
	I, J, L, O, S, T, Z
}

var cells = {
	Blocks.I: [Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(2, 0)],
	Blocks.L: [Vector2(-1, 1), Vector2(-1, 0), Vector2(0,0), Vector2(1, 0)],
	Blocks.J: [Vector2(1,1), Vector2(-1, 0), Vector2(0,0), Vector2(1,0)],
	Blocks.O: [Vector2(0,1), Vector2(1,1), Vector2(0,0), Vector2(1,0)],
	Blocks.Z: [Vector2(0,1), Vector2(1,1), Vector2(-1, 0), Vector2(0,0)],
	Blocks.T: [Vector2(0,1), Vector2(-1,0), Vector2(0,0), Vector2(1,0)],
	Blocks.S: [Vector2(-1, 1), Vector2(0, 1), Vector2(0,0), Vector2(1, 0)]
}

var wall_kicks_jlostz = [
	[Vector2(0,0), Vector2(-1,0), Vector2(-1,1), Vector2(0,-2), Vector2(-1, -2)],
	[Vector2(0,0), Vector2(1,0), Vector2(1, -1), Vector2(0,2), Vector2(1, 2)],
	[Vector2(0,0), Vector2(1, 0), Vector2(1,-1), Vector2(0,2), Vector2(1, 2)],
	[Vector2(0,0), Vector2(-1,0), Vector2(-1, 1), Vector2(0, -2), Vector2(-1, -2)],
	[Vector2(0,0), Vector2(1,0), Vector2(1, 1), Vector2(0,-2), Vector2(1, -2)],
	[Vector2(0,0), Vector2(-1,0), Vector2(-1, -1), Vector2(0, 2), Vector2(-1, 2)],
	[Vector2(0,0), Vector2(-1,0), Vector2(-1,-1), Vector2(0, 2), Vector2(-1, 2)],
	[Vector2(0,0), Vector2(1, 0), Vector2(1, 1), Vector2(0,-2), Vector2(1, -2)]
]

var data = {
	Blocks.I: preload("res://res/p_I.tres"),
	Blocks.J: preload("res://res/p_J.tres"),
	Blocks.L: preload("res://res/p_L.tres"),
	Blocks.O: preload("res://res/p_O.tres"),
	Blocks.S: preload("res://res/p_S.tres"),
	Blocks.T: preload("res://res/p_T.tres"),
	Blocks.Z: preload("res://res/p_Z.tres")
}

var clockwise_rotation_matrix = [Vector2(0, -1), Vector2(1, 0)]
var counter_clockwise_rotation_matrix = [Vector2(0,1), Vector2(-1, 0)]
