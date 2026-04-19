extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0.0
	
func show_message(text: String) -> void:
	self.text = text
	modulate.a = 1.0
	await get_tree().create_timer(2.0).timeout
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	
func _process(delta: float) -> void:
	pass
