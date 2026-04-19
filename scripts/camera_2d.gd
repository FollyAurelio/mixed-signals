extends Camera2D

var screen_coords
var player 
var camera_direction = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_coords = get_viewport_rect().size
	player = get_node("../../Player")
	
func start() -> void:
	position = Vector2(256, 256)



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_right") and camera_direction == Vector2.ZERO:
		camera_direction = Vector2(256, 0)
		player.get_node("VisibleOnScreenNotifier2D").screen_exited.disconnect(_on_visible_on_screen_notifier_2d_screen_exited)
		position += camera_direction

	elif event.is_action_released("camera_right") and camera_direction == Vector2(256, 0):
		position -= camera_direction
		camera_direction = Vector2.ZERO
		player.get_node("VisibleOnScreenNotifier2D").screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)

	elif event.is_action_pressed("camera_left") and camera_direction == Vector2.ZERO:
		camera_direction = Vector2(-256, 0)
		player.get_node("VisibleOnScreenNotifier2D").screen_exited.disconnect(_on_visible_on_screen_notifier_2d_screen_exited)
		position += camera_direction

	elif event.is_action_released("camera_left") and camera_direction == Vector2(-256, 0):
		position -= camera_direction
		camera_direction = Vector2.ZERO
		player.get_node("VisibleOnScreenNotifier2D").screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)

	elif event.is_action_pressed("camera_up") and camera_direction == Vector2.ZERO:
		camera_direction = Vector2(0, -256)
		player.get_node("VisibleOnScreenNotifier2D").screen_exited.disconnect(_on_visible_on_screen_notifier_2d_screen_exited)
		position += camera_direction

	elif event.is_action_released("camera_up") and camera_direction == Vector2(0, -256):
		position -= camera_direction
		camera_direction = Vector2.ZERO
		player.get_node("VisibleOnScreenNotifier2D").screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)

	elif event.is_action_pressed("camera_down") and camera_direction == Vector2.ZERO:
		camera_direction = Vector2(0, 256)
		player.get_node("VisibleOnScreenNotifier2D").screen_exited.disconnect(_on_visible_on_screen_notifier_2d_screen_exited)
		position += camera_direction

	elif event.is_action_released("camera_down") and camera_direction == Vector2(0, 256):
		position -= camera_direction
		camera_direction = Vector2.ZERO
		player.get_node("VisibleOnScreenNotifier2D").screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	var player_position = player.position 
	var player_screen_position = get_viewport().get_canvas_transform() * (player_position + Vector2(32, 32))
	if player_screen_position.x > screen_coords.x:
		position += Vector2(512, 0)
	elif player_screen_position.x < 0:
		position += Vector2(-512, 0)
	elif player_screen_position.y > screen_coords.y:
		position += Vector2(0, 512)
	elif player_screen_position.y < 0:
		position += Vector2(0, -512)
		
