extends VBoxContainer

onready var mood_progress = $Mood/TextureProgress
onready var hearts = $Attributes/Hearts
onready var strength = $Attributes/Strength/Label
onready var agility = $Attributes/Agility/Label
onready var intelligence = $Attributes/Intelligence/Label

func update_stats(game_master: Object) -> void:
	mood_progress.value = game_master.mood
	
	for c in hearts.get_children():
		c.visible = false
		
	for i in range(game_master.health):
		hearts.get_child(i).visible = true
		
	strength.text = str(game_master.strength)
	agility.text = str(game_master.agility)
	intelligence.text = str(game_master.intelligence)
