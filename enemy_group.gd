extends Node2D

var enemies: Array = []

@onready var choice = $"../CanvasLayer/choice"
@onready var battle_info = $"../BattleInfo"

func _ready():
	enemies = get_children()
	for i in range(enemies.size()):
		enemies[i].position = Vector2(0, i * 32)
	#show_choice()

#func _process(_delta):
	#if not choice.visible:
		#if Input.is_action_just_pressed("ui_up"):
			#if index > 0:
				#switch_focus(index, index - 1)
				#index -= 1
				#print(index)
#
		#if Input.is_action_just_pressed("ui_down"):
			#if index < enemies.size() - 1:
				#switch_focus(index, index + 1)
				#index += 1
				#print(index)
#
		#if Input.is_action_just_pressed("ui_accept"):
			#if battle_info.action_queue.size() != 2:
				#battle_info._add_to_queue(index)
			#if battle_info.action_queue.size() == 2:
				#player_turn_ended.emit()
#
	#if battle_info.action_queue.size() == 2 and not is_battling:
		#player_turn_ended.emit()
		#is_battling = true
		#_reset_focus()

#func switch_focus(old_index, new_index):
	#if old_index >= 0 and old_index < enemies.size():
		#enemies[old_index].unfocus()
	#if new_index >= 0 and new_index < enemies.size():
		#enemies[new_index].focus()
#
#func show_choice():
	#choice.show()
	#choice.find_child("Attack").grab_focus()
#
#func _reset_focus():
	#index = 0
	#for enemy in enemies:
		#enemy.unfocus()
#
#func _start_choosing():
	#_reset_focus()
	#enemies[0].focus()
#
#func _on_attack_pressed():
	#choice.hide()
	#_start_choosing()
	
func _is_defeated() -> bool:
	for i in range(enemies.size()):
		if enemies[i].is_downed == false:
			return false
	return true
	
