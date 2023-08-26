extends Label

var start_time = 0
var time_now = 0

var time_running = false

func _process(_delta):
		
	if find_parent("game").game_start:
		if not time_running:
			time_running = true
			start()
		get_time()
		

func get_time():
	time_now = Time.get_unix_time_from_system()
	var elapsed = time_now - start_time
	var ms = str("%.2f" % elapsed).split(".")[1]
	var sec = int(elapsed) % 60
	var minute = Time.get_time_dict_from_unix_time(elapsed).minute

	var elapsed_time = "%02d:%02d:%s" % [minute, sec, ms]
	self.text = elapsed_time

func start():
	start_time = Time.get_unix_time_from_system()
