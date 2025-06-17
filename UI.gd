extends Control

@export var score_ui: Label
@export var game_over_text: Label
var score := 0

func _ready():
	score = 0
	update_score()

func _start():
	Systems.game_manager.snake_ate_food.connect(
		func(): 
			increase_score(1)
			update_score()
	)
	Systems.game_manager.game_over.connect(
		func(): 
			game_over_text.visible = true
	)
func _process(delta):
	pass

func increase_score(amount: int):
	score += amount

func update_score():
	score_ui.text = str(score)
	
