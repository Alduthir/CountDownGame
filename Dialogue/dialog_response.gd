class_name DialogResponse
extends Resource

enum Actions { SET_VALUES, END, CONTINUE }
enum Values { HEALTH, AMOUNT_STEPS, TIME, SUSPICION, VILLAGERS, GUARDS, IDLE_VILLS, BUSY_GUARDS, GAMEOVER}

@export var label: String
@export var action: Actions 
@export var values: Dictionary[Values, int]
@export var color: Color = Color.WHITE_SMOKE
