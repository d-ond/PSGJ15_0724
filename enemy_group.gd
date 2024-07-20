extends Node2D

var enemies: Array = []

@onready var choice = $"../CanvasLayer/choice"
@onready var battle_info = $"../BattleInfo"

func _ready():
	enemies = get_children()
	for i in range(enemies.size()):
		enemies[i].position = Vector2(0, i * 32)
	
func _is_defeated() -> bool:
	for enemy in enemies:
		if not enemy.is_downed:
			return false
	return true
