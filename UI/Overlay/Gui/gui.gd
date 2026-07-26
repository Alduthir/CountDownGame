extends Node2D

@onready var day_label: Label = $header/calander/tooth/day
@onready var guards_label: RichTextLabel = $header/right/gaurds
@onready var health_bar: ProgressBar = $footer/health_bar
@onready var suspicion_bar: ProgressBar = $suspicion_bar/suspicion_bar
@onready var thirst_bar: ProgressBar = $thirst_bar/thirst_bar
@onready var time_label: Label = $header/timer/tooth/time
@onready var time_wheel: TextureRect = $header/center/time_wheel
@onready var villagers_label: Label = $header/left/villagers

var tween_health : Tween
var tween_suspicion : Tween
var tween_thirst : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_hours_remaining()
	setup_guards()
	setup_health()
	setup_suspicion()
	setup_trusts()
	setup_time()
	setup_time_wheel()
	setup_villages()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_hours_remaining_changed(new_value: int) -> void:
	day_label.text = "%02d" % new_value

func _on_gaurd_changed(new_value: int) -> void:
	guards_label.text = "[font_size=8]"+str("%02d" % GameState.guards)+"[/font_size][font_size=4]/"+str("%02d" % GameState.guards_busy)+"[/font_size]"

func _on_health_changed(new_value: int) -> void:
	var speed: float = 1
	if new_value == 0:
		speed = 0.2
	
	if tween_health:
		tween_health.stop()
	tween_health = create_tween()
	tween_health.tween_property(health_bar, "value", new_value, speed).set_ease(Tween.EASE_OUT)

func _on_suspicion_changed(new_value: int) -> void:
	var speed: float = 1
	if new_value == 0:
		speed = 0.2
	
	if tween_suspicion:
		tween_suspicion.stop()
	tween_suspicion = create_tween()
	tween_suspicion.tween_property(suspicion_bar, "value", new_value, speed).set_ease(Tween.EASE_OUT)


func _on_thirst_changed(new_value: int) -> void:
	var speed: float = 1
	if new_value == 0:
		speed = 0.2
		
	if tween_thirst:
		tween_thirst.stop()
	tween_thirst = create_tween()
	tween_thirst.tween_property(thirst_bar, "value", new_value, speed).set_ease(Tween.EASE_OUT)

func _on_time_changed(new_value: int) -> void:
	time_label.text = str("%02d" % GameState.hours) + ":" + str("%02d" % GameState.minutes)
	setup_time_wheel()

func _on_villager_changed(new_value: int) -> void:
	villagers_label.text = str("%02d" % new_value)

func setup_hours_remaining() -> void:
	_on_hours_remaining_changed(GameState.hours_remaining)
	GameState.hours_remaining_changed.connect(
		_on_hours_remaining_changed
	)

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
