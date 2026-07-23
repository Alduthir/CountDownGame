extends Node

signal ate_changed(new_value: int)
signal days_changed(new_value: int)
signal gameover_changed(new_value: bool)
signal guards_changed(new_value: int)
signal guards_busy_changed(new_value: int)
signal health_changed(new_value: int)
signal hours_changed(new_value: int)
signal minutes_changed(new_value: int)
signal suspicion_changed(new_value: int)
signal thirts_changed(new_value: int)
signal villagers_changed(new_value: int)

var max_int = 9223372036854775807

var max_health: int = 100
var max_hours: int = 24
var max_minutes: int = 60
var max_suspicion: int = 100
var max_thirts: int = 100

var start_ate: int = 0
var start_days: int = 0
var start_guards: int = 0
var start_guards_busy: int = 0
var start_health: int = max_health
var start_time_hours: int = 13
var start_time_minutes: int = 0
var start_suspicion: int = 0
var start_thirts: int = max_thirts
var starter_villagers: int = 2

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
		health_changed.emit(health)
		if health == 0:
			gameover_changed.emit(true)

var hours: int = start_time_hours:
	set(value):
		hours = clampi(value, hours, max_int)
		while hours > max_hours -1:
			hours -= max_hours
			days += 1
			days_changed.emit(days)
		hours_changed.emit(hours)

var minutes: int = start_time_minutes:
	set(value):
		minutes = clampi(value, minutes, max_int)
		while minutes > max_minutes -1:
			minutes -= max_minutes
			hours += 1
			hours_changed.emit(hours)
		minutes_changed.emit(minutes)

var suspicion: int = start_suspicion:
	set(value):
		suspicion = clampi(value, 0, max_suspicion)
		if suspicion == max_suspicion:
			gameover_changed.emit(true)
		suspicion_changed.emit(suspicion)

var thirts: int = start_thirts:
	set(value):
		thirts = clampi(value, 0, max_thirts)
		thirts_changed.emit(thirts)

var villagers: int = starter_villagers:
	set(value):
		villagers = clampi(value, 0, max_int)
		if villagers == 0:
			gameover_changed.emit(true)
		villagers_changed.emit(villagers)
