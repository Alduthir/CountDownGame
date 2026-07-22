@tool
class_name DialogueEntry extends Resource

@export_multiline var text := ""
@export var character : Texture

@export_group("Choices")
@export var choices: Array[DialogueChoice] = []: set = set_choices

func set_choices(new_choices: Array[DialogueChoice]) -> void:
	for index in new_choices.size():
		if new_choices[index] == null:
			new_choices[index] = DialogueChoice.new()
	choices = new_choices
