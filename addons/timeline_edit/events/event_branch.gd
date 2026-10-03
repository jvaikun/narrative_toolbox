@tool
extends PanelContainer

@onready var btn_fold: Button = %BtnFold
@onready var body: VBoxContainer = %Body
@onready var wait_time: SpinBox = $Content/Head/WaitTime
@onready var default: SpinBox = $Content/Head/Default

var data : EventChoice = null


func set_data(value):
	data = value
	wait_time.value = data.choice_time
	default.value = data.default_choice
	var event_obj = load("res://addons/timeline_edit/events/event_choice.tscn")
	for i in data.choices.size():
		var new_event = event_obj.instantiate()
		body.add_child(new_event)
		new_event.set_data(data.choices[i])


func _on_btn_fold_toggled(toggled_on: bool) -> void:
	btn_fold.text = "Hide" if toggled_on else "Show"
	body.visible = toggled_on
