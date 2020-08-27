class_name Event
extends Resource

export var icon: Texture
export(String, MULTILINE) var text: String
export var options: Array

export var health_change: int = 0
export var mood_change: int = 0
export var strength_change: int = 0
export var agility_change: int = 0
export var intelligence_change: int = 0

export var event_str: int = 0
export var event_agi: int = 0
export var event_int: int = 0

func is_end() -> bool:
	return options.size() == 0
	
func apply_changes(game_master: Object) -> void:
	game_master.health += health_change
	game_master.mood += mood_change
	game_master.strength += strength_change
	game_master.agility += agility_change
	game_master.intelligence += intelligence_change

func get_random_option() -> Resource:
	return options[randi() % options.size()]
	
func has_stats() -> bool:
	return event_str > 0 or event_agi > 0 or event_int > 0
	
func stats_string() -> String:
	return "Str:%s\nAgi:%s\nInt:%s" % [event_str, event_agi, event_int]
	
func is_positive() -> bool:
	return health_change > 0 or mood_change > 0 or strength_change > 0 or agility_change > 0 or intelligence_change > 0
