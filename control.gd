extends Control

signal attack_selected(target)
signal defend_selected()
signal ability_selected(ability, target)

@onready var attack_button = $Attack
@onready var defend_button = $Defend
@onready var ability_button = $Ability
@onready var target_selection_panel = $TargetSelectionPanel
@onready var abilities_panel = $AbilitiesPanel

func _ready():
	#defend_button.connect("pressed", self, "_on_defend_pressed")
	#ability_button.connect("pressed", self, "_on_ability_pressed")
	target_selection_panel.hide()
	abilities_panel.hide()

func _on_attack_pressed():
	_show_target_selection("attack")

func _on_defend_pressed():
	emit_signal("defend_selected")

func _on_ability_pressed():
	_show_abilities_selection()

func _show_target_selection(action_type):
	target_selection_panel.show()
	target_selection_panel.connect("target_selected", self, "_on_target_selected", [action_type])

func _show_abilities_selection():
	abilities_panel.show()
	abilities_panel.connect("ability_selected", self, "_on_ability_selected")

func _on_target_selected(target, action_type):
	target_selection_panel.hide()
	target_selection_panel.disconnect("target_selected", self, "_on_target_selected")
	
	if action_type == "attack":
		emit_signal("attack_selected", target)
	elif action_type == "ability":
		emit_signal("ability_selected", selected_ability, target)

func _on_ability_selected(ability):
	abilities_panel.hide()
	abilities_panel.disconnect("ability_selected", self, "_on_ability_selected")
	_show_target_selection("ability")
	selected_ability = ability
