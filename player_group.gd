extends Node2D

var players: Array = []
var index: int = 0

signal next_player_turn

func _ready():
	players = get_children()
	for i in range(players.size()):
		players[i].position = Vector2(0, i * 32)
	players[0].focus()

func _on_enemy_group_next_player_turn():
	if index < players.size() - 1:
		switch_focus(index, index + 1)
		index += 1
	else:
		switch_focus(index, 0)
		index = 0
	next_player_turn.emit()

func switch_focus(old_index, new_index):
	if old_index >= 0 and old_index < players.size():
		players[old_index].unfocus()
	if new_index >= 0 and old_index < players.size():
		players[new_index].focus()
