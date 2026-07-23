extends Node2D

@onready var day_label: Label = $header/calander/tooth/day
@onready var guards_label: RichTextLabel = $header/right/gaurds
@onready var health_bar: ProgressBar = $footer/health_bar
@onready var suspicion_bar: ProgressBar = $suspicion_bar/suspicion_bar
@onready var thirst_bar: ProgressBar = $thirst_bar/thirst_bar
@onready var time_label: Label = $header/timer/tooth/time
@onready var villagers_label: Label = $header/left/villagers

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_day()
	setup_guards()
	setup_health()
	setup_suspicion()
	setup_trusts()
	setup_time()
	setup_villages()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_day_changed(new_value: int) -> void:
	day_label.text = str("%02d" % new_value)

func _on_gaurd_changed(new_value: int) -> void:
	guards_label.text = "[font_size=8]"+str("%02d" % GameState.guards)+"[/font_size][font_size=4]/"+str("%02d" % GameState.guards_busy)+"[/font_size]"

func _on_health_changed(new_value: int) -> void:
	health_bar.value = new_value

func _on_suspicion_changed(new_value: int) -> void:
	suspicion_bar.value = new_value

func _on_thirst_changed(new_value: int) -> void:
	thirst_bar.value = new_value

func _on_time_changed(new_value: int) -> void:
	time_label.text = str("%02d" % GameState.hours) + ":" + str("%02d" % GameState.minutes)

func _on_villager_changed(new_value: int) -> void:
	villagers_label.text = str("%02d" % new_value)

func setup_day():
	day_label.text = str("%02d" % GameState.days)
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

func setup_villages():
	villagers_label.text = str("%02d" % GameState.villagers)
	GameState.villagers_changed.connect(_on_villager_changed)
