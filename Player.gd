extends Node2D

var max_hp = 10.0
var curr_hp = 10.0
var is_defeated = false
var block = 0.0
var curr_block = 0.0
@onready var health_bar = $HealthBar
@onready var shield_bar = $ShieldBar
@onready var health_bar_label = $HealthBarLabel
@onready var shield_bar_label = $ShieldBarLabel

func _ready():
	shield_bar.hide()
	shield_bar_label.hide()
	health_bar_label.text = str(curr_hp) + "/" + str(max_hp)

func take_damage(value):
	var health_damage = 0
	if curr_block > 0:
		curr_block -= value
		if curr_block <= 0:
			hide_block_bar()
			health_damage = curr_block
			curr_hp += health_damage
		update_block_bar(value)
	else:
		curr_hp -= value
	update_health_bar()
	if curr_hp <= 0:
		is_defeated = true

func receive_block(value):
	block = value
	set_block_bar()

func update_health_bar():
	health_bar.value = (curr_hp / max_hp) * 100
	health_bar_label.text = str(int(curr_hp)) + "/" + str(int(max_hp))

func set_block_bar():
	shield_bar.show()
	shield_bar_label.show()
	shield_bar.max_value = block
	shield_bar.value = block
	curr_block = block
	shield_bar_label.text = str(int(curr_block)) + "/" + str(int(block))
	
func update_block_bar(value):
	curr_block -= value
	if curr_block > 0:
		shield_bar.value = (curr_block / block) * 100
	else:
		shield_bar.hide()
		shield_bar_label.hide()
	shield_bar_label.text = str(int(curr_block)) + "/" + str(int(block))
	
func hide_block_bar():
	shield_bar.hide()
	shield_bar_label.hide()
		
func reset_block():
	block = 0
	curr_block = 0
	shield_bar.value = 0
	shield_bar.hide()
	shield_bar_label.text = "0/0"
	shield_bar_label.hide()


