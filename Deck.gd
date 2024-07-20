extends Node

var draw_pile: Array = []
var discard_pile: Array = []
var hand_pile: Array = []

func create_card(one, two):
	var tup = [one, two]
	return tup

func _ready():
	var nums = [1, 2, 3, 4, 5]
	var suits = ["Attack", "Defend"]
	for i in range(2):
		for j in range(5):
			var c = create_card(suits[i], nums[j])
			draw_pile.push_back(c)
	draw_pile.shuffle()

func draw_card():
	if draw_pile.size() <= 0:
		draw_pile = discard_pile.duplicate(true)
		discard_pile.clear()
		draw_pile.shuffle()
	var c = draw_pile.pop_back()
	hand_pile.push_back(c)
	return c
