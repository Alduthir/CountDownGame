extends Node2D

@export var guard_scene: PackedScene
@export var spawn_locations: Array[Vector2] = []

var guards: Array[Node] = []


func _ready() -> void:
	spawn_guards()
	print("GuardManager gestart")


func spawn_guards() -> void:
	if guard_scene == null:
		push_error("GuardManager: guard_scene is niet ingesteld.")
		return

	if spawn_locations.is_empty():
		push_warning("GuardManager: er zijn geen spawn_locations ingesteld.")
		return

	for spawn_position in spawn_locations:
		spawn_guard(spawn_position)


func spawn_guard(spawn_position: Vector2) -> void:
	var guard := guard_scene.instantiate()

	guard.position = spawn_position

	add_child(guard)
	guards.append(guard)

	guard.tree_exiting.connect(
		_on_guard_removed.bind(guard)
	)

	print("Guard gespawned op: ", guard.position)


func remove_guard(guard: Node) -> void:
	if not is_instance_valid(guard):
		return

	guard.queue_free()


func get_guard_count() -> int:
	return guards.size()


func _on_guard_removed(guard: Node) -> void:
	guards.erase(guard)
