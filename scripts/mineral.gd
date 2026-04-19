extends Area2D

var type
var dug
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func start(type : String) -> void:
	self.type = type
	dug = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func dig() -> void:
	pass
	
func _process(delta: float) -> void:
	pass
