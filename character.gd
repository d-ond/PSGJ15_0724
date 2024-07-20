extends Node2D

@onready var _focus = $Focus
@onready var progress_bar = $ProgressBar
@onready var animation_player = $AnimationPlayer
@onready var is_downed: bool = false

@export var MAX_HEALTH: float = 7
@export var ATTACK_POWER: float = 1

var health: float = 7:
	set(value):
		health = value
		_update_progress_bar()
		_play_animation("Hurt")

func _update_progress_bar():
	progress_bar.value = (health / MAX_HEALTH) * 100

func _play_animation(anim_name: String):
	animation_player.play(anim_name)

func focus():
	_focus.show()

func unfocus():
	_focus.hide()

func take_damage(value: float):
	health -= value
	if health <= 0:
		health = 0
		is_downed = true
	_update_progress_bar()
	_play_animation("Hurt")

func attack(target):
	target.take_damage(ATTACK_POWER)
	_play_animation("Attack")

func _is_defeated() -> bool:
	if health <= 0:
		return true
	return false
