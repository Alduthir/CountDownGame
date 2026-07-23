extends Node2D

@onready var day_label: Label = $header/calander/tooth/day
@onready var health_bar: ProgressBar = $footer/health_bar
@onready var suspicion_bar: ProgressBar = $suspicion_bar/suspicion_bar
@onready var thirst_bar: ProgressBar = $thirst_bar/thirst_bar
@onready var time_label: Label = $header/timer/tooth/time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_day()
	setup_health()
	setup_suspicion()
	setup_trusts()
	setup_time()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_day_changed(new_value: int) -> void:
	day_label.text = str("%02d" % new_value)

func _on_health_changed(new_value: int) -> void:
	health_bar.value = new_value

func _on_suspicion_changed(new_value: int) -> void:
	suspicion_bar.value = new_value

func _on_thirst_changed(new_value: int) -> void:
	thirst_bar.value = new_value

func _on_time_changed(new_value: int) -> void:
	time_label.text = str("%02d" % GameState.hours) + ":" + str("%02d" % GameState.minutes)

func setup_day():
	day_label.text = str("%02d" % GameState.days)
	GameState.days_changed.connect(_on_day_changed)

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
