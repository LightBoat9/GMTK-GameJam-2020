extends Node

enum State {
	ROLL, MOVE, EVENT
}

var state: int = State.EVENT

onready var game_master: Object = $GameMaster
onready var options: Object = $VBoxContainer/ColorRect2/VBoxContainer/HBoxContainer2/Options
onready var game_board: Object = $VBoxContainer/ColorRect2/VBoxContainer/HBoxContainer2/Board
onready var stats: Object = $VBoxContainer/ColorRect2/VBoxContainer/Stats
	
var _selected_option: int = 0

onready var final_screen = $FinalScreen
	
func _ready() -> void:
	_init_state()
	
func _init_state() -> void:
	match state:
		State.ROLL:
			if game_board.player_at_end() and game_master.health > 0:
				final_screen.display_screen(true)
				return
				
			game_master.hide_text_box()
			game_master.display_face_from_mood()
			
			game_master.display_text("Time to roll.")
			
			options.display_options(["Roll That Dice!"])
			yield(options, "option_selected")
			options.hide_options()
			
			game_master.hide_text_box()
			game_master.roll()
			
			yield(game_master.animation, "animation_finished")
			
			var face = game_master.get_dice_face()
			
			game_master.display_text("I rolled a %d." % face)
			
			var op_arr = []
			for i in range(1, 7):
				op_arr.append("Move %d space%s" % [i, "s" if i != 1 else ""])
				
			options.display_options(op_arr)
			_selected_option = yield(options, "option_selected")
			options.hide_options()
			
			state = State.MOVE
			_init_state()
		State.MOVE:
			game_master.hide_dice()
			
			if game_master.get_dice_face() != _selected_option+1:
				game_master.displayed_mood = game_master.Mood.ANGRY
				game_master.display_text("That's not what I rolled!")
				game_master.audio_feedback_negative()
				game_master.mood += abs(game_master.get_dice_face()-_selected_option+1) * 10
			else:
				game_master.display_text("Nice!")
			
			for i in range(_selected_option+1):
				game_board.move_piece()
				
				if game_board.player_at_end():
					break
				
				yield(game_board.tween, "tween_all_completed")
				
				yield(get_tree().create_timer(0.1), "timeout")
			
			state = State.EVENT
			_init_state()
		State.EVENT:
			options.display_options(["Start Event", "Skip Event"])
			_selected_option = yield(options, "option_selected")
			options.hide_options()
			
			if _selected_option == 1:
				game_master.displayed_mood = game_master.Mood.ANGRY
				game_master.display_text("That's against the rules!")
				game_master.audio_feedback_negative()
				
				options.display_options(["Oh Well...", "Wait Nevermind"])
				_selected_option = yield(options, "option_selected")
				
				if _selected_option == 0:
					game_master.mood += 40
					state = State.ROLL
					_init_state()
					return
				else:
					game_master.hide_text_box()
					game_master.display_face_from_mood()
					_init_state()
					return
				
			
			game_board.start_event()
			
			game_master.hide_text_box()
			game_master.display_face_from_mood()
			
			var op = randi() % game_board.current_event.options.size()
			game_master.display_text("I want to %s" % game_board.current_event.options[op].text)
			
			_selected_option = yield(options, "option_selected")
			
			if op != _selected_option:
				game_master.displayed_mood = game_master.Mood.ANGRY
				game_master.display_text("That's not what I wanted!")
				game_master.audio_feedback_negative()
				game_master.mood += 20
			
			var result = game_board.current_event.options[_selected_option].get_result(game_master)
			
			if result.is_end():
				game_board.display_event(result)
				if result.is_positive():
					options.display_options(["Great!"])
				else:
					options.display_options(["..."])
				
				_selected_option = yield(options, "option_selected")
				
				result.apply_changes(game_master)
				state = State.ROLL
				game_board.end_event()
				_init_state()
