extends CharacterBody2D

signal update_world

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#position = Vector2(0.0, 0.0)
	$AnimatedSprite2D.animation = "idle_4"
	$AnimatedSprite2D.play() # Replace with function body.



func can_move_to(target_pos: Vector2) -> bool:
	var space = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = target_pos + Vector2(32, 32) 
	query.collision_mask = collision_mask
	query.exclude = [self.get_rid()]
	var result = space.intersect_point(query)
	return result.is_empty()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_just_pressed("move_right"):
		direction.x = 1
		update_world.emit()
	elif Input.is_action_just_pressed("move_left"):
		direction.x = -1
		update_world.emit()
	elif Input.is_action_just_pressed("move_down"):
		direction.y = 1
		update_world.emit()
	elif Input.is_action_just_pressed("move_up"):
		direction.y = -1
		update_world.emit()

	if direction != Vector2.ZERO:
		var target = position + direction * 64
		if can_move_to(target):
			position = target

	
