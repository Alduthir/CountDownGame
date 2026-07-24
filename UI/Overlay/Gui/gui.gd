extends Node2D

@onready var day_label: Label = $header/calander/tooth/day
@onready var guards_label: RichTextLabel = $header/right/gaurds
@onready var health_bar: ProgressBar = $footer/health_bar
@onready var suspicion_bar: ProgressBar = $suspicion_bar/suspicion_bar
@onready var thirst_bar: ProgressBar = $thirst_bar/thirst_bar
@onready var time_label: Label = $header/timer/tooth/time
@onready var time_wheel: TextureRect = $header/center/time_wheel
@onready var villagers_label: Label = $header/left/villagers
@onready var timer: Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_day()
	setup_guards()
	setup_health()
	setup_suspicion()
	setup_trusts()
	setup_time()
	setup_time_wheel()
	setup_villages()
	
	timer.wait_time = GameState.time_speed
	timer.autostart = true
	timer.timeout.connect(_on_minute_tick)
	add_child(timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_day_changed(new_value: int) -> void:
	var days_left: int = GameState.next_event - GameState.days
	day_label.text = str("%02d" % days_left)
	timer.stop()

func _on_gaurd_changed(new_value: int) -> void:
	guards_label.text = "[font_size=8]"+str("%02d" % GameState.guards)+"[/font_size][font_size=4]/"+str("%02d" % GameState.guards_busy)+"[/font_size]"

func _on_health_changed(new_value: int) -> void:
	health_bar.value = new_value

func _on_minute_tick():
	GameState.minutes += 1

func _on_suspicion_changed(new_value: int) -> void:
	suspicion_bar.value = new_value

func _on_thirst_changed(new_value: int) -> void:
	thirst_bar.value = new_value

func _on_time_changed(new_value: int) -> void:
	time_label.text = str("%02d" % GameState.hours) + ":" + str("%02d" % GameState.minutes)
	setup_time_wheel()

func _on_villager_changed(new_value: int) -> void:
	villagers_label.text = str("%02d" % new_value)

func setup_day():
	_on_day_changed(0)
	GameState.days_changed.connect(_on_day_changed)

func setup_guards():
	guards_label.text = "[font_size=8]"+str("%02d" % GameState.guards)+"[/font_size][font_size=4]/"+str("%02d" % GameState.guards_busy)+"[/font_size]"
	GameState.guards_changed.connect(_on_gaurd_changed)

func setup_health():
	health_bar.max_value = GameState.max_health
	health_bar.value = GameState.health
	GameState.health_changed.connect(_on_health_changed)

func setup_suspicion():
	suspicion_bar.max_value = GameState.max_suspicion
	suspicion_bar.value = GameState.suspicion
	GameState.suspicion_changed.connect(_on_suspicion_changed)

func setup_trusts():
	thirst_bar.max_value = GameState.max_thirst
	thirst_bar.value = GameState.thirst
	GameState.thirst_changed.connect(_on_thirst_changed)

func setup_time():
	time_label.text = str("%02d" % GameState.hours) + ":" + str("%02d" % GameState.minutes)
	GameState.hours_changed.connect(_on_time_changed)
	GameState.minutes_changed.connect(_on_time_changed)

func setup_time_wheel():
	var deg_for_hours: float = 360 / 24
	var deg_for_minutes: float = deg_for_hours / 60
	var deg_move_minutes: float = deg_for_minutes * GameState.minutes
	var deg_move_hours: float = deg_for_hours * GameState.hours
	var deg_final_location: float = deg_move_hours + deg_move_minutes + 90 #shift to correct time
	if deg_final_location > 360:
		deg_final_location -= 360
	time_wheel.rotation_degrees = deg_final_location

func setup_villages():
	villagers_label.text = str("%02d" % GameState.villagers)
	GameState.villagers_changed.connect(_on_villager_changed)
