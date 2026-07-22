@tool
extends Control

@export var current_dialogue : DialogueEntry

@onready var _rtb_dialogue := %Dialogue
@onready var _response_container := %ResponseContainer
@onready var _villager := %Villager
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	show_text(current_dialogue.text)

func create_buttons(dialogue_options : Array[DialogueChoice]):
	for button in _response_container.get_children():
		button.queue_free()
	for option in dialogue_options:
		var button := Button.new()
		_response_container.add_child(button)
		button.text = option.text
		button.autowrap_mode = TextServer.AUTOWRAP_WORD
		# Connect using an anonymous (lambda) function so we can pass the index
		#button.pressed.connect(func(): show_text(target_line_idx))
		# Or use binding
		# button.pressed.connect(show_text.bind(target_line_idx))
		if option.action == null:
			button.pressed.connect(get_tree().quit)
			button.theme_type_variation = "buttonQuit"
		else:
			button.pressed.connect(option.action.execute)

func show_text(text : String) -> void:
	_rtb_dialogue.text = text
	_villager.texture = current_dialogue.character
	create_buttons(current_dialogue.choices)
	
	for button: Button in _response_container.get_children():
		button.disabled = true
		button.modulate.a = 0
	
	_rtb_dialogue.visible_ratio = 0.0
	var tween := create_tween()
	
	var text_appearing_duration : float = current_dialogue.text.length() / 30.0
	tween.tween_property(_rtb_dialogue, "visible_ratio", 1.0, text_appearing_duration)
	tween.finished.connect(display_buttons)

func display_buttons() -> void:
	var button_tween := create_tween()
	for button : Button in _response_container.get_children():
		button.disabled = false
		button_tween.tween_property(button, "modulate:a", 1, 0.3)
