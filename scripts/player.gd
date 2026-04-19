extends CharacterBody2D

signal update_world
signal game_over

var beam_shot = false
var health = 4
var fuel = 100.0
const fuel_value = {"platinum" : 100, "diamond" : 70, "gold" : 50, "silver" : 40, 
					"ruby" : 30, "sapphire" :30, "bronze" : 25, "coal" : 20}
var menu_open = false
@export var world: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func start() -> void:
	position = Vector2(0.0, 0.0)
	$AnimatedSprite2D.animation = "idle_4"
	$AnimatedSprite2D.play() # Replace with function body.
	$LaserBeam.hide()
	$LaserBeam.get_node("CollisionShape2D").disabled = true
	beam_shot = false
	health = 4
	fuel = 100.0
	menu_open = false

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
	if not beam_shot:
		if Input.is_action_just_pressed("move_right"):
			direction.x = 1
			update_world.emit()
			update_fuel(-0.5)
		elif Input.is_action_just_pressed("move_left"):
			direction.x = -1
			update_world.emit()
			update_fuel(-0.5)
		elif Input.is_action_just_pressed("move_down"):
			direction.y = 1
			update_world.emit()
			update_fuel(-0.5)
		elif Input.is_action_just_pressed("move_up"):
			direction.y = -1
			update_world.emit()
			update_fuel(-0.5)
		elif Input.is_action_just_pressed("shoot_right"):
			$LaserBeam.show()
			beam_shot = true
			$LaserBeam.get_node("CollisionShape2D").disabled = false
			$LaserBeam.position = Vector2(0,0)
			$LaserBeam.velocity = Vector2(1.0, 0.0)
			update_fuel(-1.0)
			
		elif Input.is_action_just_pressed("shoot_left"):
			$LaserBeam.show()	
			beam_shot = true
			$LaserBeam.get_node("CollisionShape2D").disabled = false
			$LaserBeam.position = Vector2(0,0)
			$LaserBeam.velocity = Vector2(-1.0, 0.0)
			update_fuel(-1.0)
			
			
		elif Input.is_action_just_pressed("shoot_up"):
			$LaserBeam.show()	
			beam_shot = true
			$LaserBeam.get_node("CollisionShape2D").disabled = false
			$LaserBeam.position = Vector2(0,0)
			$LaserBeam.velocity = Vector2(0.0, -1.0)
			update_fuel(-1.0)	
				
		elif Input.is_action_just_pressed("shoot_down"):
			$LaserBeam.show()	
			beam_shot = true
			$LaserBeam.get_node("CollisionShape2D").disabled = false
			$LaserBeam.position = Vector2(0,0)
			$LaserBeam.velocity = Vector2(0.0, 1.0)
			update_fuel(-1.0)
		
		elif Input.is_action_just_pressed("dig"):
			dig()
		
		elif Input.is_action_just_pressed("menu") and not menu_open:
			menu_open = true
			$"../HUD/Menu".show()
			
		elif Input.is_action_just_pressed("menu") and menu_open:
			menu_open = false
			$"../HUD/Menu".hide()
		
	if direction != Vector2.ZERO:
		var target = position + direction * 64
		if can_move_to(target):
			position = target
			
	update_fuel_display()

func dig() -> void:
	var layer2 = world.get_node("Layer2")
	var tile_coords = layer2.local_to_map(position)
	var tile = layer2.get_cell_atlas_coords(tile_coords)
	if tile == Vector2i(4,1):
		update_fuel(-5.0)
		layer2.set_cell(tile_coords, 0, Vector2i(5, 1))
		
		var space = get_world_2d().direct_space_state
		var query = PhysicsPointQueryParameters2D.new()
		query.position = position
		query.collision_mask = 8  # layer 4
		query.collide_with_areas = true
		query.collide_with_bodies = false
		var result = space.intersect_point(query)
		if not result.is_empty():
			var collider = result[0].collider
			if collider.type == "mine":
				$"../HUD/FadeoutText".show_message("Oops, mined a mine...")
				health -= 1
				flash()
				handle_health_animation()
			else:
				update_fuel(fuel_value[collider.type])
				$"../HUD/FadeoutText".show_message("Mined "+collider.type+"! +" +str(int(fuel_value[collider.type])) +" fuel")
	else:
		$"../HUD/FadeoutText".show_message("You can't mine here!")
	
func flash():
	$AnimatedSprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color.WHITE

func _on_laser_beam_beam_collide() -> void:
	beam_shot = false

func handle_health_animation() -> void:
	$AnimatedSprite2D.animation = "idle_" + str(health)

func handle_game_over() -> void:
	$"../HUD/GameOver".show()
	$AnimatedSprite2D.animation = "death"
	await $AnimatedSprite2D.animation_finished
	hide()
	set_physics_process(false)
	await get_tree().create_timer(4).timeout
	game_over.emit()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		health -= 1
		flash()
		handle_health_animation()
		if health <= 0:
			handle_game_over()

func update_fuel_display() -> void:
	$"../HUD/Fuel".text = "FUEL : " + str(fuel) + "%"

func update_fuel(new_fuel : float) -> void:
	fuel += new_fuel
	if fuel <= 0:
		handle_game_over()
	elif fuel > 100:
		fuel = 100.0
