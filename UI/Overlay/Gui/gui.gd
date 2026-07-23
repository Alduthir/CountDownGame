extends Node2D

@onready var health_bar: ProgressBar = $footer/health_bar
var time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_health()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	GameState.health = GameState.max_health - time

func _on_health_changed(new_value: int) -> void:
	health_bar.value = new_value

func setup_health():
	health_bar.max_value = GameState.max_health
	health_bar.value = GameState.health
	GameState.health_changed.connect(_on_health_changed)
