extends Control

@export var score_label: Label
@export var main_label: Label
@export var highscore_label: Label
@export var context_label: Label

func _ready():
	score_label.text = "Press any key to start"
	context_label.text = ""
	main_label.visible = true
	
	var gd = Systems.game_data
	if gd.game_type == GameData.game_types.ENDLESS:
		highscore_label.visible = true
		
	update_score()

func _start():
	Systems.game_manager.snake_ate_food.connect(
		func(): 
			update_score()
	)
	Systems.game_manager.game_over.connect(
		func(): 
			game_over()
			
	)
	Systems.game_manager.start.connect(
		func(): 
			main_label.visible = false
	)
func _process(delta):
	pass

func update_score():
	var text: String = ""
	var gd = Systems.game_data
	match gd.game_type:
		GameData.game_types.ENDLESS:
			text = str("total score: ", gd.score)
		GameData.game_types.SCORE_20:
			text = str("score left: ", 20 - gd.score)
		_:
			text = str("score: ", gd.score)
			
	score_label.text = text
	highscore_label.text = str("highscore: ", gd.highscore)
	
func game_over():
	const lose_text: Dictionary[String, String] = {
		"main": "YOU LOST",
		"context": "Press R to restart\nPress ESC to exit",
	}
	const game_over_text: Dictionary[String, String] = {
		"main": "GAME OVER",
		"context": "Press R to restart\nPress ESC to exit",
	}
	const win_text: Dictionary[String, String] = {
		"main": "YOU WON",
		"context": "Press R to restart\nPress ESC to exit",
	}	
	
	var text: String = ""
	var context_text: String = ""
	var gd = Systems.game_data
	match gd.game_type:
		GameData.game_types.ENDLESS:
			text = game_over_text.main
			context_text = game_over_text.context
		GameData.game_types.SCORE_20:
			text = lose_text.main
			context_text = lose_text.context
			if gd.score >= 20:
				text = win_text.main
				context_text = win_text.context
		_:
			text = lose_text.main
			context_text = lose_text.context
			
	print(main_label)
	main_label.text = text
	context_label.text = context_text
	main_label.visible = true
