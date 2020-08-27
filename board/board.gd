extends NinePatchRect

const first_event = preload("res://events/class_choice/class_choice.tres")
const last_event = preload("res://events/final_fight/final_fight.tres")

onready var game_piece = $GamePiece
onready var cells = $Cells
onready var tween = $Tween
onready var event_book = $EventBook
onready var event_book_text = $EventBook/Label
onready var event_book_icon = $EventBook/Left/Icon
onready var event_book_require = $EventBook/Left/Require

var _board_spaces: Array
var _board_events: Array

var current_event: Resource

var piece_position = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_board_spaces()
	var c = _board_spaces[0]
	game_piece.rect_global_position = c.rect_global_position - (c.rect_size / 2 * Vector2.DOWN)
	
func move_piece() -> void:
	if piece_position + 1 >= _board_spaces.size():
		return
		
	piece_position += 1
	
	var c = _board_spaces[piece_position]
	tween.interpolate_property(game_piece, "rect_global_position", game_piece.rect_global_position, c.rect_global_position - (c.rect_size / 2 * Vector2.DOWN), 0.5)
	tween.start()
	
func _init_board_spaces() -> void:
	for child in cells.get_children():
		if child is TextureRect:
			_board_spaces.append(child)
			
	_board_spaces.sort_custom(self, "_board_sort")
	
	for i in range(_board_spaces.size()):
		if i == 0:
			_board_events.append(first_event)
		elif i == _board_spaces.size() - 1:
			_board_events.append(last_event)
		else:
			_board_events.append(EventList.get_random_negative())
			
	var ids = []
	while ids.size() < 5:
		var i = randi() % _board_spaces.size()
		if not i in ids:
			ids.append(i)
			
	for i in ids:
		_board_events[i] = EventList.get_random_positive()
		
	for s in range(_board_spaces.size()):
		_board_spaces[s].get_child(0).texture = _board_events[s].icon
		
		if s == 0 or _board_events[s] in EventList.GoodEvents:
			_board_spaces[s].self_modulate = Color("63c74d")
		elif s == _board_spaces.size() - 1 or _board_events[s] in EventList.BadEvents:
			_board_spaces[s].self_modulate = Color("a22633")
		elif _board_events[s] in EventList.NeutralEvents:
			_board_spaces[s].self_modulate = Color("ffffff")
			
	
func _board_sort(a, b) -> bool:
	return int(a.name) < int(b.name)
	
func start_event() -> void:
	current_event = _board_events[piece_position]
	display_event(current_event)
	
func display_event(event: Resource) -> void:
	event_book.visible = true
	event_book_text.text = event.text
	event_book_icon.texture = event.icon
	
	event_book_require.visible = false
	if event.has_stats():
		event_book_require.visible = true
		event_book_require.text = event.stats_string()
	
	var ops = []
	
	for o in event.options:
		ops.append(o.text)

	owner.options.display_options(ops)
	
func end_event() -> void:
	event_book.visible = false
	
func player_at_end() -> bool:
	return piece_position == _board_spaces.size()-1
