extends Node2D

signal dialog_finished(result: Dictionary)

@export var character_image: Texture2D
@onready var portrait = $VBoxContainer/HBoxContainer/Villager
@onready var dialog_text = $VBoxContainer/DialogueContainer/Dialogue
@onready var responses_container = $VBoxContainer/DialogueContainer/ResponseContainer

var steps: Array[DialogStep] = []
var current_step: int = 0

func start_dialog(persona_image: Texture2D, conversation: Array[DialogStep]):
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
	var text_appearing_duration : float = step.text.length() / 30.0
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
		btn.text = response["label"]
		btn.pressed.connect(_on_response.bind(response))
		responses_container.add_child(btn)

func _on_response(response: DialogResponse):
	if response.action != null:
		var action = response.action
		if action == 1:
			_end_dialog()
			return
		if action == 0:
			dialog_finished.emit({"set_values": response.values})
	
	current_step += 1
	_show_step()

func _end_dialog():
	visible = false
