extends Control

@export var dialog_data: DialogData

func _ready() -> void:
	$DialogSystem.start_dialog(dialog_data.portrait, dialog_data.conversation)
	$DialogSystem.dialog_finished.connect(_on_dialog_done)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_dialog_done(result: Dictionary):
	if result.has("set_values"):
		for key in result["set_values"]:
			pass
