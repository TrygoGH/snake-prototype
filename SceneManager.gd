extends Node
class_name SceneManager

@export var systems_manager: SystemsManager
@export var game: PackedScene
@export var main_menu: PackedScene
@export var intro: PackedScene
@onready var active_scene_parent: Node = $SceneGroup/ActiveScene
@onready var fade_rect: ColorRect = $SceneGroup/CanvasLayer/Fade

signal fade_out_complete
signal fade_in_complete 

var current_scene: Node
var current_scene_resource: PackedScene
var scenes: Dictionary[String, PackedScene] = {}
var tween: Tween

func _ready():
	_add_scene("game", game)
	_add_scene("main_menu", main_menu)
	switch_scenes(intro)

func _add_scene(name: String, scene: PackedScene):
	scenes.set(name, scene)

func switch_scenes(scene: PackedScene):
	systems_manager.clear_systems()
	systems_manager.init()
	unload_current_scene()
	if tween: end_fade()
	load_scene(scene)
	
func load_scene(scene: PackedScene):
	current_scene_resource = scene
	current_scene = scene.instantiate()
	active_scene_parent.add_child(current_scene)

func unload_current_scene():
	if current_scene:
		current_scene.queue_free()
		
func reload_current_scene():
	if current_scene_resource:
		switch_scenes(current_scene_resource)

func fade_in(duration := 1.0):
	fade_rect.modulate.a = 1.0  # Start fully opaque
	tween = create_tween()
	tween.finished.connect(func(): fade_in_complete.emit())
	tween.tween_property(
		fade_rect, 
		"modulate:a", 
		0.0, 
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
func fade_out(duration := 1.0):
	fade_rect.modulate.a = 0.0  # Start transparent
	tween = create_tween()
	tween.finished.connect(fade_out_completed)
	tween.tween_property(
		fade_rect, 
		"modulate:a", 
		1.0, 
		duration
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func end_fade():
	tween.kill()

func fade_out_completed():
	print("FADED")
	fade_out_complete.emit()
