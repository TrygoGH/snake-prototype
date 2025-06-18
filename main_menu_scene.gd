## Handles the main menu UI, allowing the player to select game modes or exit the game.
extends Node2D

@onready var start_button: Button = $CanvasLayer/Control/GridContainer/Button
@onready var endless_button: Button = $CanvasLayer/Control/GridContainer/Button2
@onready var exit_button: Button = $CanvasLayer/Control/GridContainer/Button3

func _ready():
	var sm = Systems.scene_manager
	sm.fade_in(0.5)
	start_button.pressed.connect(start_button_pressed)
	endless_button.pressed.connect(endless_button_pressed)
	exit_button.pressed.connect(exit_button_pressed)

func start_button_pressed():
	var sm = Systems.scene_manager
	var gd = Systems.game_data
	gd.game_type = GameData.game_types.SCORE_20
	sm.switch_scenes(sm.game)

func endless_button_pressed():
	var sm = Systems.scene_manager
	var gd = Systems.game_data
	gd.game_type = GameData.game_types.ENDLESS
	sm.switch_scenes(sm.game)
	
func exit_button_pressed():
	quit()

## Sends the quit notification to close the application gracefully.
func quit():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().root.get_tree().quit()
