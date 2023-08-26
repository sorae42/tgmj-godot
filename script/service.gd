# scene for displaying service menu
extends Node

func write(text: String, clear: bool = false):
	if clear:
		$printer.text = " " + text
	else:
		$printer.text += " " + text

var opt_en = ["display scale", "brightness", "audio level", "sound test", "rotatation flip", "input key", "game start"]
var opt_jp = ["画面のスケール", "明るさ", "音量", "サウンドテスト", "rotatation flip", "入力キー", "ゲームをはじめる"]

var options: Array
var length: int

var W = 320
var H = 240

var OPT = 0
var SCR = 0

var isSubmenu = false
var rt = 0
var second = 0
var minute = 0

func _ready():
	options = opt_en
	DisplayServer.window_set_size(Vector2(W*Globals.displayScale, H*Globals.displayScale))
	AudioServer.set_bus_volume_db(0, -20)
	$BlackOverlay.modulate = Color(1,1,1,(100 - Globals.brightness) / 100.0)
	center_window()
	
func _process(_delta):
	options = opt_jp if (Globals.service_lang_jp == true) else opt_en
	length = len(options)
	
func _input(event):
	if event.is_action_pressed("key_service"):
		Globals.service_lang_jp = !Globals.service_lang_jp
	if event.is_action_pressed("key_service_jmpgs"):
		OPT = length
		
	if event.is_action_pressed("ui_accept"):
		isSubmenu = !isSubmenu
		SCR = OPT + 1 if isSubmenu else 0
		
	if event.is_action_pressed("ui_up"):
		OPT -= 1
	if event.is_action_pressed("ui_down"):
		OPT += 1
		
	var e = 0
	if event.is_action_pressed("ui_left"):
		e = -1
	if event.is_action_pressed("ui_right"):
		e = 1
		
	if OPT < 0: OPT = 0
	if OPT >= length: OPT = length-1
	
	handle_screen(e)

func handle_screen(event):
	if SCR == 0: service_0()
	elif SCR == 1: service_1(event)
	elif SCR == 2: service_2(event)
	elif SCR == 3: service_3(event)
	elif SCR == 4: service_play_jingle()
	elif SCR == 5: service_4(event)
	elif SCR == 6: service_5()
	elif SCR == 7: game_start()
	else: service_0()
	
	if SCR > 0:
		write("\n\n enter key: exit")
	else:
		write_runtime()

func service_0():
	write("service operator\n\n", true)
	for i in range(0, length):
		if i == length - 1:
			write("\n") # seperate game start option
		write((">" if OPT == i else " "))
		write(options[i])
		write("\n")


func service_1(event):
	Globals.displayScale += event
	write("set display scale\n\n", true)
	write(" < Scale: %d >" % Globals.displayScale)
	write("\n\n %dx%d" % [W*Globals.displayScale, H*Globals.displayScale])
	if Globals.displayScale < 1: Globals.displayScale = 1
	
	DisplayServer.window_set_size(Vector2(W*Globals.displayScale, H*Globals.displayScale))
	center_window()
	
func service_2(event):
	Globals.brightness += event * 5
	write("set display brightness\n\n", true)
	write(" < BG: %d%% >" % Globals.brightness)
	if Globals.brightness < 0: Globals.brightness = 0
	if Globals.brightness > 100: Globals.brightness = 100
	$BlackOverlay.modulate = Color(1,1,1,(100 - Globals.brightness) / 100.0)
	
func service_3(event):
	Globals.audioLevel += event * 5
	write("set audio level\n\n", true)
	write(" < SE: %d%% >" % Globals.audioLevel)
	write("%d" % AudioServer.get_bus_volume_db(0))
	if Globals.audioLevel < 0: Globals.audioLevel = 0
	if Globals.audioLevel > 100: Globals.audioLevel = 100
	AudioServer.set_bus_volume_db(0, Globals.audioLevel - 100)
	
func service_4(event):
	write("set rotation flip\n\n", true)
	write("< " + ("set" if Globals.controlFlip else "not set") + " >")
	write("\n\n Rotate:" + ("A B" if not Globals.controlFlip else "B A") + " C")
	if abs(event) == 1:
		Globals.controlFlip = !Globals.controlFlip
		event = 0
		
func service_5():
	write("input key", true)
	write("""\n\n A: key Z
 B: key X
 C: key C
 <: key arrow Left
 >: key arrow Right
 v: key arrow Down

 START: key Enter/Return
 SERVICE: key CMD/Ctrl + \\""")

func write_runtime():
	rt = Time.get_ticks_msec()
	second = floor((rt / 1000) % 60)
	minute = floor((rt / (1000 * 60)) % 60)
	
	write("\n runtime: %02d:%02d" % [minute, second])

func service_play_jingle():
	$sound_test.play()
	SCR = 0
	isSubmenu = false
	
func center_window() -> void:
	var window = get_window()
	var screen = window.current_screen
	var screen_rect = DisplayServer.screen_get_usable_rect(screen)
	var window_size = window.get_size_with_decorations()
	window.position = screen_rect.position + (screen_rect.size / 2 - window_size / 2)

func game_start():
	get_tree().change_scene_to_file("res://screen/title.tscn")
