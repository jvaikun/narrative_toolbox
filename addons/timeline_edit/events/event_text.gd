@tool
extends PanelContainer

@onready var btn_fold: Button = %BtnFold
@onready var body: TextEdit = %Body

var data : EventText = null


func set_data(value):
	data = value
	body.text = data.lines
	body.hide()
	body.show()


func _on_btn_fold_toggled(toggled_on: bool) -> void:
	btn_fold.text = "Hide" if toggled_on else "Show"
	body.visible = toggled_on
