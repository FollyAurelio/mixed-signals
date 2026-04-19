extends CanvasLayer


signal start_game
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_main_menu_screen()
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_main_menu_screen() -> void:
	$BackButton.hide()
	$ControlsExplanation.hide()
	$TitleText.show()
	$PlayButton.show()
	$ControlsButton.show()
	
	
func show_controls_screen() -> void:
	$TitleText.hide()
	$PlayButton.hide()
	$ControlsButton.hide()
	$BackButton.show()
	$ControlsExplanation.show()
	
	
	
func _on_play_button_pressed() -> void:
	start_game.emit()


func _on_controls_button_pressed() -> void:
	show_controls_screen() # Replace with function body.




func _on_back_button_pressed() -> void:
	show_main_menu_screen()
