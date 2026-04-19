extends Node
@export var enemy_scene: PackedScene
@export var mine_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clean_game_over()

func new_game() -> void:
	$MainMenu.hide()
	$World.show()
	$Player.show()
	$Player.start()
	$"World/Camera2D".start()
	$HUD.show()
	$"HUD/GameOver".hide()
	$Player.set_physics_process(true)
	$World/Camera2D.set_process(true)
	var enemies = $EnemySpawner.get_children()
	for spawn_point in enemies:
		var enemy = enemy_scene.instantiate()
		enemy.position = spawn_point.position
		$EnemySpawner.add_child(enemy)
		enemy.start()
	var mines = $MineSpawner.get_children()
	for mine_point in mines:
		var mine = mine_scene.instantiate()
		mine.position = mine_point.position
		$MineSpawner.add_child(mine)
		mine.start(mine_point.type)
	
func clean_game_over() -> void:
	$MainMenu.show()
	$World.hide()
	$Player.hide()
	$Player.set_physics_process(false)
	$HUD.hide()
	$"HUD/Menu".hide()
	$World/Camera2D.set_process(false)
	var enemies = $EnemySpawner.get_children()
	for enemy in enemies:
		if enemy.is_in_group("enemy"):	
			enemy.queue_free()
	var mines = $MineSpawner.get_children()
	for mine in mines:
		if mine.is_in_group("mineral"):
			mine.dug = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
