extends Node2D

@onready var choice = $"../CanvasLayer/choice"
@onready var enemy_group = $"../EnemyGroup"

var action_queue: Array = []
var is_battling: bool = false
var index: int = 0

signal enemy_group_defeated
signal player_turn_ended
signal execution_phase_finished

var is_selection_phase: bool = false

func _ready():
	show_choice()

func _add_to_queue(action):
	action_queue.push_back(action)

func _clear_action_queue():
	action_queue.clear()

func execute():
	for i in action_queue:
		enemy_group.enemies[i].take_damage(1)
		await get_tree().create_timer(1).timeout
		if enemy_group.enemies[i]._is_defeated():
			_clear_action_queue()
			enemy_group_defeated.emit()
			break
	action_queue.clear()
	execution_phase_finished.emit()
	
func make_selection():
	is_selection_phase = true

func _process(_delta):
	if is_selection_phase:
		if not choice.visible:
			if Input.is_action_just_pressed("ui_up"):
				if index > 0:
					switch_focus(index, index - 1)
					index -= 1
					print(index)

			if Input.is_action_just_pressed("ui_down"):
				if index < enemy_group.enemies.size() - 1:
					switch_focus(index, index + 1)
					index += 1
					print(index)

			if Input.is_action_just_pressed("ui_accept"):
				if action_queue.size() != 2:
					_add_to_queue(index)
				if action_queue.size() == 2:
					player_turn_ended.emit()
					is_selection_phase = false
					print("player turn ended")

		if action_queue.size() == 2 and not is_battling:
			player_turn_ended.emit()
			is_selection_phase = false
			is_battling = true
			_reset_focus()

func switch_focus(old_index, new_index):
	if old_index >= 0 and old_index < enemy_group.enemies.size():
		enemy_group.enemies[old_index].unfocus()
	if new_index >= 0 and new_index < enemy_group.enemies.size():
		enemy_group.enemies[new_index].focus()

func show_choice():
	choice.show()
	choice.find_child("Attack").grab_focus()

func _reset_focus():
	index = 0
	for enemy in enemy_group.enemies:
		enemy.unfocus()

func _start_choosing():
	_reset_focus()
	enemy_group.enemies[0].focus()

func _on_attack_pressed():
	choice.hide()
	_start_choosing()
	

