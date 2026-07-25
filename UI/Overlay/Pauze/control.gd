extends Control

func _ready():
	visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):  # Esc is default voor ui_cancel
		if visible:
			_resume()
		else:
			_pause()
		get_viewport().set_input_as_handled()  # voorkom dubbele verwerking

func _pause():
	print("pause called, visible was: ", visible)
	visible = true
	print("visible is now: ", visible)
	get_tree().paused = true
	$"/root/Wakeup/CanvasLayer".visible = false

func _resume():
	visible = false
	get_tree().paused = false
	$"/root/Wakeup/CanvasLayer".visible = true


func _on_btn_start_pressed() -> void:
	_resume()


func _on_btn_exit_pressed() -> void:
	get_tree().quit()
