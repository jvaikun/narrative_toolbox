@tool
extends PanelContainer

@onready var btn_fold: Button = %BtnFold
@onready var body: HBoxContainer = %Body
@onready var volume: SpinBox = %Volume

var data : EventAudio = null


func set_data(value):
	data = value
	volume.value = data.volume


func _on_btn_fold_toggled(toggled_on: bool) -> void:
	btn_fold.text = "Hide" if toggled_on else "Show"
	body.visible = toggled_on
