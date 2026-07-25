class_name DialogSystem extends Node2D

signal dialog_finished()

@export var character_image: Texture2D
@onready var portrait = $VBoxContainer/HBoxContainer/Villager
@onready var dialog_text = $VBoxContainer/DialogueContainer/Dialogue
@onready var responses_container = $VBoxContainer/DialogueContainer/ResponseContainer

var steps: Array[DialogStep] = []
var current_step: int = 0

func start_dialog(persona_image: Texture2D, conversation: Array[DialogStep]):
	GameState.timer.stop()
	character_image = persona_image
	portrait.texture = character_image
	steps = conversation
	current_step = 0
	visible = true
	_show_step()

func _show_step():
	if current_step >= steps.size():
		_end_dialog()
		return
	
	var step = steps[current_step]
	
	dialog_text.text = step.text
	dialog_text.visible_ratio = 0.0
	var tween := create_tween()
	var text_appearing_duration : float = step.text.length() / 100.0
	tween.tween_property(dialog_text, "visible_ratio", 1.0, text_appearing_duration)
	tween.finished.connect(_render_buttons)
	
	# Clear old buttons
	for child in responses_container.get_children():
		child.queue_free()

func _render_buttons():
	var step = steps[current_step]
	# Create response buttons
	for i in step.responses.size():
		var response = step.responses[i]
		var btn = Button.new()
		btn.add_theme_color_override("font_color", response.color)
		btn.text = response["label"]
		btn.pressed.connect(_on_response.bind(response))
		responses_container.add_child(btn)

func _on_response(response: DialogResponse):
	var steps_to_skip = response.values.get(DialogResponse.Values.AMOUNT_STEPS, 1)
	
	update_stats(response.values)
	match response.action:
		DialogResponse.Actions.END:
			_end_dialog()
			return
		DialogResponse.Actions.CONTINUE:
			pass
		

	current_step += steps_to_skip
	_show_step()

func _end_dialog():
	GameState.timer.start()
	visible = false
	dialog_finished.emit()

func update_stats(result):
	if result:
		for key in result:
			match key:
				DialogResponse.Values.HEALTH:
					GameState.health += result[key]
				DialogResponse.Values.TIME:
					GameState.hours += result[key]
				DialogResponse.Values.SUSPICION:
					GameState.suspicion += result[key]
				DialogResponse.Values.VILLAGERS:
					GameState.villagers += result[key]
				DialogResponse.Values.GUARDS:
					GameState.guards += result[key]
				DialogResponse.Values.BUSY_GUARDS:
					GameState.guards_busy += result[key]
			pass
