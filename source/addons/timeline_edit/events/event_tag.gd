@tool
extends PanelContainer

@onready var type: Label = %Type
@onready var btn_fold: Button = %BtnFold
@onready var tag_id: LineEdit = %TagID

var data : EventTag = null


func set_data(value):
	data = value
	tag_id.text = data.tag_id


func _on_btn_fold_toggled(toggled_on: bool) -> void:
	btn_fold.text = "Hide" if toggled_on else "Show"
	#body.visible = toggled_on
