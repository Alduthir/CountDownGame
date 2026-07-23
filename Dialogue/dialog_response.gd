class_name DialogResponse
extends Resource

enum Actions { SET_VALUES, END }
enum Values { HEALTH, SUS, TEST}

@export var label: String
@export var action: Actions 
@export var values: Dictionary[Values, int]
