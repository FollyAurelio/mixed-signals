extends CharacterBody2D

var randomer = RandomNumberGenerator.new()
var screen_coords

func _ready() -> void:
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	mob_types.remove_at(0)
	$AnimatedSprite2D.animation = mob_types.pick_random()
	screen_coords = get_viewport_rect().size
	$AnimatedSprite2D.play() # Replace with function body.



func can_move_to(target_pos: Vector2) -> bool:
	var space = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = target_pos + Vector2(32, 32) 
	query.collision_mask = collision_mask
	query.exclude = [self.get_rid()]
	var result = space.intersect_point(query)
	return result.is_empty()


func _on_player_update_world() -> void:
	var direction = Vector2.ZERO
	var rand = randomer.randi_range(0,3)
	if rand == 0:
		direction.x = 1
	elif rand == 1:
		direction.x = -1
	elif rand == 2:
		direction.y = 1
	elif rand == 3:
		direction.y = -1

	if direction != Vector2.ZERO:
		var target = position + direction * 64
		var screen_target = get_viewport().get_canvas_transform() * (target + Vector2(32, 32))
		if can_move_to(target) and (screen_target.x < screen_coords.x and 
		screen_target.x > 0.0 and screen_target.y < screen_coords.y and screen_target.y > 0.0):
			position = target
	

	
	
			
