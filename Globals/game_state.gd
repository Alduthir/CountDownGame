extends Node

signal ate_changed(new_value: int)
signal days_changed(new_value: int)
signal gameover_changed(new_value: bool)
signal guards_changed(new_value: int)
signal guards_busy_changed(new_value: int)
signal health_changed(new_value: int)
signal hours_changed(new_value: int)
signal kills_changed(new_value: int)
signal minutes_changed(new_value: int)
signal suspicion_changed(new_value: int)
signal thirst_changed(new_value: int)
signal villagers_changed(new_value: int)
signal hours_remaining_changed(new_value: int)

@onready var timer: Timer = Timer.new()
var max_int = 9223372036854775807
var won: bool = false

var max_health: int = 100
var max_hours: int = 24
var max_minutes: int = 60
var max_suspicion: int = 100
var max_thirst: int = 100

var start_ate: int = 0
var start_days: int = 0
var start_guards: int = 0
var start_guards_busy: int = 0
var start_health: int = max_health
var start_kills: int = 0
var start_suspicion: int = 0
var start_time_hours: int = 16
var start_time_minutes: int = 00
var start_thirst: int = max_thirst
var starter_villagers: int = 3
var start_hours_remaining: int = 16
var hours_remaining: int = start_hours_remaining
var deadline_reached := false

var next_event: int = 5
var sunrise_hour: int = 6
var sunset_hour: int = 20
var time_speed: float = 5
var thirst_day: int = 2
var thirst_night: int = 1
var thirst_health_lost_counter: int = 0
var thirst_health_lost_multiplier: int = 3
var thirst_health_lost: int = 1
var guards_killed: int = 0

func _ready() -> void:
	timer.wait_time = 1
	timer.autostart = true
	timer.timeout.connect(_on_minute_tick)
	add_child(timer)
	update_hours_remaining()

func _on_minute_tick():
	GameState.minutes += time_speed

var ate: int = start_ate:
	set(value):
		ate = clampi(value, ate, max_int)
		ate_changed.emit(ate)

var days: int = start_days:
	set(value):
		days = clampi(value, days, max_int)
		days_changed.emit(days)

var guards: int = start_guards:
	set(value):
		guards = clampi(value, 0, max_int)
		guards_changed.emit(guards)

var guards_busy: int = start_guards_busy:
	set(value):
		guards_busy = clampi(value, 0, guards)
		guards_busy_changed.emit(guards_busy)

var health: int = start_health:
	set(value):
		health = clampi(value, 0, max_health)
		if health == 0:
			gameover_changed.emit(true)
		health_changed.emit(health)

var hours: int = start_time_hours:
	set(value):
		hours = clampi(value, hours, max_int)
		while hours > max_hours -1:
			hours -= max_hours
			days += 1
			days_changed.emit(days)
		hours_changed.emit(hours)

var kills: int = start_kills:
	set(value):
		kills = clampi(value, kills, max_int)
		kills_changed.emit(kills)

var minutes: int = start_time_minutes:
	set(value):
		minutes = clampi(value, minutes, max_int)

		while minutes > max_minutes - 1:
			minutes -= max_minutes
			hours += 1

		minutes_changed.emit(minutes)
		update_hours_remaining()

var suspicion: int = start_suspicion:
	set(value):
		suspicion = clampi(value, 0, max_suspicion)
		if suspicion == max_suspicion:
			gameover_changed.emit(true)
		suspicion_changed.emit(suspicion)

var thirst: int = start_thirst:
	set(value):
		if value > thirst:
			thirst_health_lost_counter = 0
		thirst = clampi(value, 0, max_thirst)
		thirst_changed.emit(thirst)

func update_hours_remaining() -> void:
	var start_total_minutes := (
		start_days * 24 * 60
		+ start_time_hours * 60
		+ start_time_minutes
	)

	var current_total_minutes := (
		days * 24 * 60
		+ hours * 60
		+ minutes
	)

	var elapsed_minutes := current_total_minutes - start_total_minutes
	var remaining_minutes := maxi(
		0,
		start_hours_remaining * 60 - elapsed_minutes
	)

	# Naar boven afronden:
	# 15 uur en 55 minuten over wordt als 16 getoond.
	var new_hours_remaining := ceili(remaining_minutes / 60.0)

	if new_hours_remaining != hours_remaining:
		hours_remaining = new_hours_remaining
		hours_remaining_changed.emit(hours_remaining)

	if remaining_minutes <= 0 and not deadline_reached:
		deadline_reached = true
		gameover_changed.emit(true)

var villagers: int = starter_villagers:
	set(value):
		villagers = clampi(value, 0, max_int)
		if villagers == 0:
			gameover_changed.emit(true)
		villagers_changed.emit(villagers)

func is_day() -> bool:
	return hours >= sunrise_hour and hours < sunset_hour

func is_night() -> bool:
	return not is_day()
