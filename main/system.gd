extends ColorRect

@onready var sliders = {
	"music": {
		"control": $Dialog/Main/Content/Body/Options/Music,
		"label": $Dialog/Main/Content/Body/Options/MusicNum
	},
	"sfx": {
		"control": $Dialog/Main/Content/Body/Options/SFX,
		"label": $Dialog/Main/Content/Body/Options/SFXNum
	},
	"vo": {
		"control": $Dialog/Main/Content/Body/Options/UI,
		"label": $Dialog/Main/Content/Body/Options/UINum
	},
}
@onready var txt_speed = $Dialog/Main/Content/Body/Options/TextSpd


func _ready() -> void:
	for key in sliders.keys():
		sliders[key].control.value_changed.connect(_on_slider_changed.bind(key))
		sliders[key].control.value = Game.settings[key]
	txt_speed.value = Game.settings.text_speed


func _on_slider_changed(val: float, type: String) -> void:
	if type in sliders.keys():
		Game.set_audio(val, type)
		sliders[type].label.text = str(int(val * 100))


func _on_text_spd_value_changed(value: float) -> void:
	Game.settings.text_speed = value


func _on_btn_back_pressed() -> void:
	hide()


func _on_btn_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://title/title.tscn")
