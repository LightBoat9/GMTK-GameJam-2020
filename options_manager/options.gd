extends GridContainer

signal option_selected(id)

onready var ui_select = $UISelect
onready var ui_roll = $UIRoll

func display_options(options: Array) -> void:
	hide_options()
		
	for i in range(options.size()):
		get_child(i).visible = true
		get_child(i).get_child(0).text = options[i]

func _on_option_rolled(id: int) -> void:
	ui_roll.pitch_scale = 1.0 + (0.1 * id)
	ui_roll.play()

func _on_option_pressed(id: int) -> void:
	emit_signal("option_selected", id)
	ui_select.play()
	
func hide_options() -> void:
	for i in range(6):
		get_child(i).visible = false
