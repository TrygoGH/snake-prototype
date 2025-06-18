## Manages scene loading, unloading, and transitions with fade effects.
## Keeps track of the current active scene and handles switching between predefined scenes.
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

## Adds a scene to the internal scenes dictionary for later switching.
func _add_scene(name: String, scene: PackedScene):
	scenes.set(name, scene)

## Switches to a new scene by clearing systems, unloading current scene, stopping any fade,
## and loading the new scene.
func switch_scenes(scene: PackedScene):
	systems_manager.clear_systems()
	systems_manager.init()
	unload_current_scene()
	if tween:
		end_fade()
	load_scene(scene)

## Loads a new scene instance as a child of active_scene_parent and updates current references.
func load_scene(scene: PackedScene):
	current_scene_resource = scene
	current_scene = scene.instantiate()
	active_scene_parent.add_child(current_scene)

## Queues the current scene for deletion if it exists.
func unload_current_scene():
	if current_scene:
		current_scene.queue_free()

## Reloads the currently active scene by switching to its resource.
func reload_current_scene():
	if current_scene_resource:
		switch_scenes(current_scene_resource)

## Starts a fade-in animation by interpolating fade_rect's opacity from fully opaque to transparent.
func fade_in(duration := 1.0):
	fade_rect.modulate.a = 1.0  # Start fully opaque
	tween = create_tween()
	tween.finished.connect(func():
		fade_in_complete.emit()
	)
	tween.tween_property(
		fade_rect,
		"modulate:a",
		0.0,
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

## Starts a fade-out animation by interpolating fade_rect's opacity from transparent to fully opaque.
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

## Immediately stops any running fade tween.
func end_fade():
	tween.kill()

## Called when fade-out finishes; emits fade_out_complete signal.
func fade_out_completed():
	print("FADED")
	fade_out_complete.emit()

## Called when the node is ready, registers predefined scenes, and switches to the intro scene.
func _ready():
	_add_scene("game", game)
	_add_scene("main_menu", main_menu)
	switch_scenes(intro)
