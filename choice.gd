extends VBoxContainer

signal target_selected(target)

@onready var targets = []

func _ready():
	# Populate the targets array with the available targets (enemies or allies)
	targets = get_available_targets()

func _on_target_button_pressed(target):
	emit_signal("target_selected", target)

func get_available_targets() -> Array:
	var available_targets = []
	# Add logic to get available targets (e.g., enemies that are not defeated)
	return available_targets

func _show():
	for target in targets:
		var button = Button.new()
		button.text = target.name
		add_child(button)
	self.visible = true

func _hide():
	for button in get_children():
		button.queue_free()
	self.visible = false
