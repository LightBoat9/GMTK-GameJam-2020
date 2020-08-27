tool
extends TextureRect

var face: int = 1 setget set_face

func randomize_face() -> void:
	self.face = randi() % 6 + 1
	
func set_face(f: int) -> void:
	if f < 1 or f > 6:
		return
		
	face = f
	
	$Faces.texture.region = Rect2(16*(f-1),0,16,14)
