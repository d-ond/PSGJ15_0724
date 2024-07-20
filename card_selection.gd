extends Node2D

@onready var deck = $Player/Deck
@onready var hand = $CanvasLayer/Hand
@onready var hand_cards: Array = []
@onready var selection_phase = SelectionPhase.SETUP
@onready var display_text = $DisplayText

var sel_one
var index_one
var sel_two
var index_two

var index: int = 0

enum SelectionPhase {
	SETUP,
	DRAW_PHASE,
	SELECTION_ONE,
	SELECTION_TWO,
	EXECUTE,
	END_PHASE
}

var chosen_action

func setup_phase():
	hand_cards = hand.get_children()
	for i in range(4):
		deck.draw_card()
	display_drawn_cards()
	switch_focus(index)
	display_text.text = ""
	selection_phase = SelectionPhase.SELECTION_ONE

func display_drawn_cards():
	hand_cards.clear()
	hand_cards = hand.get_children()
	for i in hand_cards.size():
		var c = deck.hand_pile[i]
		var labels = hand_cards[i].get_children()
		labels[0].text = str(c[0])
		labels[1].text = str(c[1])

func execute_action(card1, card2):
	chosen_action = {"ActionType": card1[0], "Number": card2[1]}
	display_text.text = chosen_action["ActionType"] + " for " + str(chosen_action["Number"])
	selection_phase = SelectionPhase.END_PHASE
	
func _process(_delta):
	if selection_phase == SelectionPhase.SETUP:
		setup_phase()
	if selection_phase == SelectionPhase.DRAW_PHASE:
		draw_cards()
	if selection_phase == SelectionPhase.SELECTION_ONE:
		make_selection()
	if selection_phase == SelectionPhase.SELECTION_TWO:
		make_selection()
	if selection_phase == SelectionPhase.EXECUTE:
		execute_action(sel_one, sel_two)
	if selection_phase == SelectionPhase.END_PHASE:
		end_phase()

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
		selection_phase = SelectionPhase.EXECUTE

func switch_focus(new_index):
	hand_cards[new_index].grab_focus()
	
func draw_cards():
	for i in range(2):
		deck.draw_card()
	display_drawn_cards()
	selection_phase = SelectionPhase.SELECTION_ONE
	
func end_phase():
	var p1 = max(index_one, index_two)
	var p2 = min(index_one, index_two)
	var d1 = deck.hand_pile.pop_at(p1)
	deck.discard_pile.push_back(d1)
	var d2 = deck.hand_pile.pop_at(p2)
	deck.discard_pile.push_back(d2)
	for card in hand_cards:
		card.disabled = false
	selection_phase = SelectionPhase.DRAW_PHASE
