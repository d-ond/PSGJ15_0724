extends Node2D

enum BattleState {
	PLAYER_TURN, # player selects their moves
	ENEMY_TURN, # enemy selects their moves
	EXECUTION_PHASE, # run the turn queue
	VICTORY, # screen for winning and for any gains
	DEFEAT # essentially game over
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

func _process(_delta):
	if current_state == BattleState.EXECUTION_PHASE:
		battle_info.execute()
	
	if current_state == BattleState.PLAYER_TURN:
		battle_info.make_selection()

func _on_player_turn_end():
	current_state = BattleState.EXECUTION_PHASE

func _on_enemy_turn_end():
	current_state = BattleState.EXECUTION_PHASE
	
func _on_execution_phase_end():
	current_state = BattleState.PLAYER_TURN

func _on_enemy_group_defeated():
	current_state = BattleState.VICTORY
	_victory()

func _victory():
	print("You win!")
	get_tree().quit()
	


