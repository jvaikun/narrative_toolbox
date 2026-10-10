@tool
extends PanelContainer

@onready var btn_fold: Button = %BtnFold
@onready var fade_time: SpinBox = %FadeTime
@onready var wait_for_anim: CheckButton = %WaitForAnim
@onready var body: HBoxContainer = %Body
@onready var image: TextureRect = %Image

var data : EventImage = null


func set_data(value):
	data = value
	image.texture = data.image
	fade_time.value = data.fade_time
	wait_for_anim.button_pressed = data.wait_anim


func _on_btn_fold_toggled(toggled_on: bool) -> void:
	btn_fold.text = "Hide" if toggled_on else "Show"
	body.visible = toggled_on
