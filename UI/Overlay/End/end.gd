extends Control

@onready var title : Label = $Title
@onready var stats_label: RichTextLabel = $mainscreen/RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var title_text = "You Won"
	if GameState.won == false:
		title_text = "Game Over"
	
	title.text = title_text
	write_stats()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func write_stats():
	var hours = GameState.hours
	var days = GameState.days
	if hours < 16:
		days -= 1
		hours += 24
	hours -= 16
	
	var text = "
	[table=2]
	[cell]Villagers:[/cell][cell]"+ str(GameState.villagers) +"[/cell]
	[cell]Villagers eaten:[/cell][cell]"+ str(GameState.ate) +"[/cell]
	[cell]Guards killed:[/cell][cell]"+ str(GameState.kills) +"[/cell]
	[cell]Time Survived:[/cell][cell]"+ str(days) +" day "+ str(hours) +" hour "+ str(GameState.minutes) +" minutes[/cell]
	[/table]
	"
	stats_label.text = text

func _on_btn_close_pressed() -> void:
	get_tree().quit()
