extends Node2D

func _ready():
	var sm = Systems.scene_manager
	sm.fade_in_complete.connect(_next_scene)
	sm.fade_in(10)
	
func _next_scene():
	var sm = Systems.scene_manager
	sm.switch_scenes(sm.main_menu)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_next_scene()
