extends Node
class_name SceneManager

@export var systems_manager: SystemsManager
@export var active_scene_parent: Node
@export var game: PackedScene
@export var main_menu: PackedScene
var current_scene: Node
var current_scene_resource: PackedScene
var scenes: Dictionary[String, PackedScene] = {}

func _ready():
	_add_scene("game", game)
	_add_scene("main_menu", main_menu)
	switch_scenes(game)

func _add_scene(name: String, scene: PackedScene):
	scenes.set(name, scene)

func switch_scenes(scene: PackedScene):
	systems_manager.clear_systems()
	systems_manager.init()
	unload_current_scene()
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
