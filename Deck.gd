extends Node

var draw_pile: Array = []
var discard_pile: Array = []
var hand_pile: Array = [null, null, null, null]

func create_card(one, two):
	var tup = [one, two]
	return tup

func _ready():
	var nums = [1, 2, 3, 4, 5]
	var suits = ["Attack", "Defend", "Null"]
	for i in range(2):
		for j in range(5):
			var c = create_card(suits[i], nums[j])
			draw_pile.push_back(c)
	var c2 = create_card(suits[2], 0)
	draw_pile.push_back(c2)
	draw_pile.shuffle()

func draw_card(i, j):
	discard_to_draw()
	var c = draw_pile.pop_back()
	hand_pile[i] = c
	discard_to_draw()
	c = draw_pile.pop_back()
	hand_pile[j] = c

func discard_to_draw():
	if draw_pile.size() <= 0:
		draw_pile = discard_pile.duplicate(true)
		discard_pile.clear()
		draw_pile.shuffle()
