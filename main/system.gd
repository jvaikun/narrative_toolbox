extends PanelContainer

@onready var sliders = {
	"music": {
		"control": $Main/Content/Body/Options/Music,
		"label": $Main/Content/Body/Options/MusicNum
	},
	"sfx": {
		"control": $Main/Content/Body/Options/SFX,
		"label": $Main/Content/Body/Options/SFXNum
	},
	"vo": {
		"control": $Main/Content/Body/Options/UI,
		"label": $Main/Content/Body/Options/UINum
	},
}


func _ready() -> void:
	for key in sliders.keys():
		sliders[key].control.value_changed.connect(_on_slider_changed.bind(key))
		sliders[key].control.value = Game.settings[key]
	$Main/Content/Body/Options/TextSpd.value = Game.settings.text_speed


func _on_slider_changed(val: float, type: String) -> void:
	if type in sliders.keys():
		Game.set_audio(val, type)
		sliders[type].label.text = str(int(val * 100))


func _on_btn_back_pressed() -> void:
	hide()


func _on_btn_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://title/title.tscn")


func _on_text_spd_value_changed(value: float) -> void:
	Game.settings.text_speed = value
