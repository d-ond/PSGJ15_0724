extends Node2D

enum BattleState {
	PLAYER_TURN,
	ENEMY_TURN,
	EXECUTION_PHASE,
	VICTORY,
	DEFEAT
}

var current_state: BattleState = BattleState.PLAYER_TURN

@onready var player_group = $PlayerGroup
@onready var enemy_group = $EnemyGroup
@onready var battle_info = $BattleInfo
@onready var turn_queue: Array = []

func _ready():
	battle_info.player_turn_ended.connect(_on_player_turn_end)
	battle_info.enemy_group_defeated.connect(_on_enemy_group_defeated)
	battle_info.execution_phase_finished.connect(_on_execution_phase_end)
	battle_info.make_selection()

func _on_player_turn_end():
	change_state(BattleState.EXECUTION_PHASE)
	print("calling execute")
	battle_info.execute()

func _on_enemy_turn_end():
	change_state(BattleState.EXECUTION_PHASE)

func _on_execution_phase_end():
	change_state(BattleState.PLAYER_TURN)
	battle_info.make_selection()

func _on_enemy_group_defeated():
	change_state(BattleState.VICTORY)
	_victory()

func change_state(new_state: BattleState):
	current_state = new_state

func _victory():
	print("You win!")
	get_tree().quit()
