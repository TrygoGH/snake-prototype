extends Node
class_name GameData

@export var score := 0
@export var highscore := 0
@export var target_score := 20
@export var game_type := game_types.SCORE_20

enum game_types {
	SCORE_20,
	ENDLESS,
}

## Sets a new high score if the provided score is greater than the current highscore
func set_highscore(new_score: int):
	if new_score > highscore:
		highscore = new_score
