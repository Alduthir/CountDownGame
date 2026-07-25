extends Node2D

@export var villager_scene: PackedScene
@export var start_villagers: int = 10

@export var spawn_area_top_left := Vector2(-200, -120)
@export var spawn_area_bottom_right := Vector2(200, 120)

@export var spawn_locations: Array[Vector2] = []

var villagers: Array[Node] = []


func _ready() -> void:
	randomize()

	spawn_villagers(start_villagers)
	print("VillagerManager gestart")


func spawn_villagers(amount: int) -> void:
	if amount <= 0:
		return

	for i in amount:ssss
		spawn_villager()


func spawn_villager() -> void:
	if villager_scene == null:
		push_error("VillagerManager: villager_scene is niet ingesteld.")
		return

	var villager := villager_scene.instantiate()

	villager.position = get_random_spawn_position()

	add_child(villager)
	villagers.append(villager)

	villager.tree_exiting.connect(
		_on_villager_removed.bind(villager)
	)

	update_villager_count()
	print("Villager gespawned op: ", villager.position)


func get_random_spawn_position() -> Vector2:
	if not spawn_locations.is_empty():
		return spawn_locations.pick_random()

	push_warning(
		"VillagerManager: geen spawn_locations ingesteld. " +
		"Het willekeurige spawngebied wordt gebruikt."
	)

	return Vector2(
		randf_range(
			spawn_area_top_left.x,
			spawn_area_bottom_right.x
		),
		randf_range(
			spawn_area_top_left.y,
			spawn_area_bottom_right.y
		)
	)


func add_villagers(amount: int) -> void:
	spawn_villagers(amount)


func remove_villager(villager: Node) -> void:
	if not is_instance_valid(villager):
		return

	villager.queue_free()


func get_villager_count() -> int:
	return villagers.size()


func _on_villager_removed(villager: Node) -> void:
	villagers.erase(villager)
	update_villager_count()


func update_villager_count() -> void:
	GameState.villagers = villagers.size()
