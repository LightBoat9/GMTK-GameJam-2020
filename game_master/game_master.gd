extends TextureRect

enum Mood {
	HAPPY, NORMAL, ANGRY
}

onready var text_box = $TextBox
onready var text_label = $TextBox/Label
onready var text_tween = $TextBox/Tween
onready var animation = $AnimationPlayer
onready var dice = $Dice
onready var faces = $Faces

var displayed_mood: int = Mood.HAPPY setget set_displayed_mood

var mood: int = 0 setget set_mood
var health: int = 0 setget set_health
var strength: int = 0 setget set_strength
var agility: int = 0 setget set_agility
var intelligence: int = 0 setget set_intelligence


func _ready() -> void:
	randomize()
	display_text(text_label.text)
	call_deferred("_init_stats")

func display_text(text: String) -> void:
	text_box.visible = true
	text_label.text = text
	
	text_tween.interpolate_property(text_label, "visible_characters", 0, text.length(), 0.075*text.length())
	text_tween.start()
	
func hide_text_box() -> void:
	text_box.visible = false
	
func hide_dice() -> void:
	dice.visible = false
	
func roll() -> void:
	animation.play("throw")
	
func get_dice_face() -> int:
	return dice.face
	
func set_displayed_mood(m: int) -> void:
	displayed_mood = m
	
	for i in range(3):
		faces.get_child(i).visible = false
		
	faces.get_child(m).visible = true
	
func display_face_from_mood() -> void:
	if mood < 33:
		self.displayed_mood = Mood.HAPPY
	elif mood < 66:
		self.displayed_mood = Mood.NORMAL
	else:
		self.displayed_mood = Mood.ANGRY
		
func audio_feedback_negative() -> void:
	$NegativeFeedback.play()

func set_mood(to: int) -> void:
	mood = clamp(to, 0, 100)
	owner.stats.update_stats(self)
	
	if mood >= 100:
		owner.final_screen.display_screen(false)
	
func set_health(to: int) -> void:
	health = clamp(to, 0, 5)
	owner.stats.update_stats(self)
	
	if health <= 0:
		owner.final_screen.display_screen(false)
	
func set_strength(to: int) -> void:
	strength = to
	owner.stats.update_stats(self)

func set_agility(to: int) -> void:
	agility = to
	owner.stats.update_stats(self)
	
func set_intelligence(to: int) -> void:
	intelligence = to
	owner.stats.update_stats(self)
	
func _init_stats() -> void:
	mood = 0
	health = 3
	strength = 1
	agility = 1
	intelligence = 1
	owner.stats.update_stats(self)
