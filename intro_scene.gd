extends Node2D

## Called when the node enters the scene tree. Starts the fade-in effect and connects to the completion signal.
func _ready():
	var sm = Systems.scene_manager
	sm.fade_in_complete.connect(_next_scene)
	sm.fade_in(10)

## Switches to the main menu scene when the fade-in is complete or when called explicitly
func _next_scene():
	var sm = Systems.scene_manager
	sm.switch_scenes(sm.main_menu)

## Listens for "ui_accept" input and triggers scene transition
func _input(event):
	if event.is_action_pressed("ui_accept"):
		_next_scene()
