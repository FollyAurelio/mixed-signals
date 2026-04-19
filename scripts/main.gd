extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$World.hide()
	$Player.hide()
	$Player.set_physics_process(false)
	$HUD.hide()
	$World/Camera2D.set_process(false)
	var enemies = $EnemySpawner.get_children()
	for enemy in enemies:
		enemy.hide()

func new_game() -> void:
	$MainMenu.hide()
	$World.show()
	$Player.show()
	$HUD.show()
	$"HUD/GameOver".hide()
	$Player.set_physics_process(true)
	$World/Camera2D.set_process(true)
	var enemies = $EnemySpawner.get_children()
	for enemy in enemies:
		enemy.show()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
