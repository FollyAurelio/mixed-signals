extends Camera2D

var screen_coords
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_coords = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	var player_position = get_node("../../Player").position 
	var player_screen_position = get_viewport().get_canvas_transform() * (player_position + Vector2(32, 32))
	if player_screen_position.x > screen_coords.x:
		position += Vector2(512, 0)
	elif player_screen_position.x < 0:
		position += Vector2(-512, 0)
	elif player_screen_position.y > screen_coords.y:
		position += Vector2(0, 512)
	elif player_screen_position.y < 0:
		position += Vector2(0, -512)
		
