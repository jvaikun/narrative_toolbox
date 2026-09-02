extends Control

@onready var anim_title = $AnimTitle
@onready var submenus = {
	"main": $Content/Main,
	"load": $Content/Load,
	"options": $Content/Options,
}
@onready var sliders = {
	"music": {
		"control": $Content/Options/Content/List/Music,
		"label": $Content/Options/Content/List/MusicNum
	},
	"sfx": {
		"control": $Content/Options/Content/List/SFX,
		"label": $Content/Options/Content/List/SFXNum
	},
	"vo": {
		"control": $Content/Options/Content/List/UI,
		"label": $Content/Options/Content/List/UINum
	},
}

var current_submenu : String = "main" : 
	set(val):
		if val in submenus.keys():
			current_submenu = val
			for sub in submenus.keys():
				submenus[sub].visible = (sub == current_submenu)


func _ready() -> void:
	anim_title.play("RESET")
	$Content/Main/Content/BtnQuit.visible = (OS.get_name() != "Web")
	current_submenu = "main"
	for key in sliders.keys():
		sliders[key].control.value_changed.connect(_on_slider_changed.bind(key))
		sliders[key].control.value = Game.settings[key]
	$Content/Options/Content/List/TextSpd.value = Game.settings.text_speed
	anim_title.play("title_intro")


func _on_btn_new_game_pressed() -> void:
	$CharCreation.show()


func _on_btn_load_game_pressed() -> void:
	current_submenu = "load"


func _on_btn_options_pressed() -> void:
	current_submenu = "options"


func _on_btn_quit_pressed() -> void:
	get_tree().quit()


func _on_slider_changed(val: float, type: String) -> void:
	if type in sliders.keys():
		Game.set_audio(val, type)
		sliders[type].label.text = str(int(val * 100))


func _on_text_spd_value_changed(value: float) -> void:
	Game.settings.text_speed = value


func _on_btn_back_pressed() -> void:
	current_submenu = "main"
