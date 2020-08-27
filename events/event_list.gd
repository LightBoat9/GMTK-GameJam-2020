class_name EventList
extends Node

const GoodEvents = [
	preload("res://events/healing_potion/healing_potion.tres"),
	preload("res://events/chest/chest_event.tres"),
]

const BadEvents = [
	preload("res://events/combat/dark_wizard/dark_wizard.tres"),
	preload("res://events/trapped_traveler/trapped_traveler.tres"),
	preload("res://events/combat/zombies/combat_zombies.tres"),
	preload("res://events/combat/skeletons/combat_skeletons.tres"),
]

static func get_random_event() -> Resource:
	var events = GoodEvents + BadEvents
	
	return events[randi() % events.size()]
	
static func get_random_negative() -> Resource:
	return BadEvents[randi() % BadEvents.size()]
	
static func get_random_positive() -> Resource:
	return GoodEvents[randi() % GoodEvents.size()]
