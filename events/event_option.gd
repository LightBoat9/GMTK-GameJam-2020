class_name EventOption
extends Resource

enum Require {
	STR, AGI, INT
}

export(String, MULTILINE) var text: String
export var results: Array

export(Require) var require_type: int = Require.STR
export var require: int = 0

func get_result(game_master: Object) -> Resource:
	if require == 0:
		return results[randi() % results.size()]
	else:
		if _meets_requirement(game_master):
			return results[0]
		else:
			return results[1]
	
func _meets_requirement(game_master: Object) -> bool:
	match require_type:
		Require.STR:
			return game_master.strength >= require
		Require.AGI:
			return game_master.agility >= require
		Require.INT:
			return game_master.intelligence >= require
	
	return false
