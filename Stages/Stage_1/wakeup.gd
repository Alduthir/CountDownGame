extends Control
@onready var end_dialog : DialogData = preload("res://Stages/Stage_1/dialog_wakeup_day_2.tres")
@onready var end_portrait : Texture2D = preload("res://Player/p_count.png")

@export var dialog : DialogData
@export var dialog_data: DialogData

@onready var DialogSystem : DialogSystem = %DialogSystem

func _ready() -> void:
	GameState.timer.timeout.connect(check_stories)
	setup_endgame()
	DialogSystem.start_dialog(dialog_data.portrait, dialog_data.conversation)


func _process(delta: float) -> void:
	pass

func _on_game_end(new_value: bool):
	await get_tree().create_timer(1.9).timeout
	get_tree().change_scene_to_file("res://UI/Overlay/End/end.tscn")

func setup_endgame():
	GameState.gameover_changed.connect(_on_game_end)
	
func check_stories():
	if check_all_quests_completed():
		GameState.won = true
		
		var dialog_system = get_tree().current_scene.find_child("DialogSystem", true, false)
		if dialog_system == null: 
			print_debug("DialogSystem not found in scene tree")
			return
		dialog_system.start_dialog(end_portrait, end_dialog)
		dialog_system.dialog_finished.connect(_dialog_done)

func _dialog_done() -> void:
	pass

func check_all_quests_completed() -> bool:
	var npcs = get_tree().get_nodes_in_group("quest_npcs")
	for npc in npcs:
		if not npc.dialog_completed:
			return false
	return true
