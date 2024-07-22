extends Node2D

@onready var deck = $Player/Deck
@onready var hand = $CanvasLayer/Hand
@onready var hand_cards: Array = []
@onready var selection_phase = SelectionPhase.SETUP
@onready var display_text = $DisplayText
@onready var intent_label = $Enemy/IntentLabel
@onready var turn_queue: Array = [[], []]

@onready var player = $Player
@onready var enemy = $Enemy

@onready var win_screen = $CanvasLayer/WinScreen
@onready var lose_screen = $CanvasLayer/LoseScreen

@onready var discard_pile_label = $CanvasLayer/DiscardPile/DiscardPileLabel
@onready var draw_pile_label = $CanvasLayer/DrawPile/DrawPileLabel

var player_action = null
var enemy_action = null

var sel_one
var index_one
var sel_two
var index_two
var target_index = 0

var index: int = 0

var hand_sel_one = 0
var hand_sel_two = 0

enum SelectionPhase {
	SETUP,
	DRAW_PHASE,
	ENEMY_ACTIONS,
	SELECTION_ONE,
	SELECTION_TWO,
	PREPARE_PLAYER,
	EXECUTE,
	END_PHASE,
	VICTORY,
	DEFEAT
}

enum Target {
	ENEMY,
	PLAYER
}

var chosen_action

func display_drawn_cards():
	hand_cards = hand.get_children()
	for i in hand_cards.size():
		var c = deck.hand_pile[i]
		var labels = hand_cards[i].get_children()
		labels[0].text = str(c[0])
		labels[1].text = str(c[1])
	discard_pile_label.text = str(deck.discard_pile.size())
	draw_pile_label.text = str(deck.draw_pile.size())
	
func _process(_delta):
	if selection_phase == SelectionPhase.SETUP:
		setup_phase()
	if selection_phase == SelectionPhase.DRAW_PHASE:
		draw_cards()
	if selection_phase == SelectionPhase.SELECTION_ONE:
		make_selection()
	if selection_phase == SelectionPhase.SELECTION_TWO:
		make_selection()
	if selection_phase == SelectionPhase.PREPARE_PLAYER:
		player_action = create_action(sel_one, sel_two, Target.ENEMY)
		selection_phase = SelectionPhase.EXECUTE
	if selection_phase == SelectionPhase.ENEMY_ACTIONS:
		create_enemy_action()
	if selection_phase == SelectionPhase.EXECUTE:
		execute_actions()
	if selection_phase == SelectionPhase.END_PHASE:
		end_phase()
	if selection_phase == SelectionPhase.VICTORY:
		win_screen.show()
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().reload_current_scene()
	if selection_phase == SelectionPhase.DEFEAT:
		lose_screen.show()
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().reload_current_scene()
		
func setup_phase():
	hand_cards = hand.get_children()
	deck.draw_card(0, 1)
	deck.draw_card(2, 3)
	display_drawn_cards()
	switch_focus(index)
	display_text.text = ""
	discard_pile_label.text = str(deck.discard_pile.size())
	draw_pile_label.text = str(deck.draw_pile.size())
	selection_phase = SelectionPhase.ENEMY_ACTIONS
	
func draw_cards():
	deck.draw_card(index_one, index_two)
	display_drawn_cards()
	discard_pile_label.text = str(deck.discard_pile.size())
	draw_pile_label.text = str(deck.draw_pile.size())
	selection_phase = SelectionPhase.ENEMY_ACTIONS

func create_enemy_action():
	var suits = ["Attack", "Defend"]
	var numbers = [1, 2, 3, 4, 5]
	var en_one = [suits.pick_random(), 0]
	var en_two = [0, numbers.pick_random()]
	enemy_action = create_action(en_one, en_two, Target.PLAYER)
	intent_label.text = en_one[0] + " for " + str(en_two[1])
	selection_phase = SelectionPhase.SELECTION_ONE

func make_selection():
	if Input.is_action_just_pressed("ui_left"):
		if index > 0:
			index -= 1
			switch_focus(index)
	if Input.is_action_just_pressed("ui_right"):
		if index < hand.get_child_count() - 1:
			index += 1
			switch_focus(index)
	if Input.is_action_just_pressed("ui_accept") and selection_phase == SelectionPhase.SELECTION_ONE:
		sel_one = deck.hand_pile[index]
		index_one = index
		hand_cards[index].disabled = true
		selection_phase = SelectionPhase.SELECTION_TWO
	if Input.is_action_just_pressed("ui_accept") and selection_phase == SelectionPhase.SELECTION_TWO and hand_cards[index].disabled == false:
		sel_two = deck.hand_pile[index]
		index_two = index
		hand_cards[index].disabled = true
		selection_phase = SelectionPhase.PREPARE_PLAYER

func switch_focus(new_index):
	hand_cards[new_index].grab_focus()

func create_action(card1, card2, target):
	var action = {"ActionType": card1[0], "Number": card2[1], "TargetIndex": target}
	return action
	
func execute_actions():
	if enemy_action["ActionType"] == "Defend":
		turn_queue[0].push_front(enemy_action)
	if player_action["ActionType"] == "Defend":
		turn_queue[0].push_front(player_action)
	if enemy_action["ActionType"] == "Attack":
		turn_queue[1].push_front(enemy_action)
	if player_action["ActionType"] == "Attack":
		turn_queue[1].push_front(player_action)
	for action_type in turn_queue:
		for action in action_type:
			display_text.text = action["ActionType"] + " for " + str(action["Number"])
			if action["ActionType"] == "Attack":
				if action["TargetIndex"] == Target.ENEMY:
					enemy.take_damage(action["Number"])
					if enemy.is_defeated:
						selection_phase = SelectionPhase.VICTORY
						break
				else:
					player.take_damage(action["Number"])
					if player.is_defeated:
						selection_phase = SelectionPhase.DEFEAT
						break
			if action["ActionType"] == "Defend" and action["TargetIndex"] == Target.PLAYER:
				enemy.receive_block(action["Number"])
			if action["ActionType"] == "Defend" and action["TargetIndex"] == Target.ENEMY:
				player.receive_block(action["Number"])
	if selection_phase != SelectionPhase.VICTORY and selection_phase != SelectionPhase.DEFEAT: 
		selection_phase = SelectionPhase.END_PHASE

func end_phase():
	turn_queue = [[], []]
	player.reset_block()
	enemy.reset_block()
	deck.discard_pile.push_back(deck.hand_pile[index_one])
	deck.discard_pile.push_back(deck.hand_pile[index_two])
	for card in hand_cards:
		card.disabled = false
	deck.hand_pile[index_one] = null
	deck.hand_pile[index_two] = null
	discard_pile_label.text = str(deck.discard_pile.size())
	draw_pile_label.text = str(deck.draw_pile.size())
	selection_phase = SelectionPhase.DRAW_PHASE
