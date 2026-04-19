extends Area2D
var velocity = Vector2(0.0, 0.0)
@export var speed = 400

signal beam_collide
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * speed * delta



func _on_body_entered(body: Node2D) -> void:
	beam_collide.emit()
	hide()
	if body.is_in_group("enemy"):
		get_node("CollisionShape2D").set_deferred("disabled",true)
		var sprite = body.get_node("AnimatedSprite2D")
		sprite.animation = "death"
		sprite.play()
		await sprite.animation_finished
		body.queue_free()
	
		
		


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	
	beam_collide.emit()
	hide()# Replace with function body.
