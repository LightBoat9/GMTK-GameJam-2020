extends Control


func display_screen(win: bool) -> void:
	$"../MusicLoop".stop()
	
	visible = true
	if win:
		$"../MusicWin".play()
		$VBoxContainer/Label.text = "You Win!"
	else:
		$"../MusicLose".play()
		$VBoxContainer/Label.text = "You Lose!"

func _on_PlayButton_pressed() -> void:
	get_tree().reload_current_scene()
