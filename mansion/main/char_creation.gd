extends ColorRect

var char_data : Dictionary = {
	"name": "Player",
	"portrait": 0,
	"skill": 12,
	"stamina": 24,
	"luck": 12
}
var portrait_index : int = 0 :
	set(val):
		portrait_index = wrapi(val, 0, Game.ATLASES.player.count)
		char_data.portrait = portrait_index
		var this_tex = $Dialog/Main/Content/Body/Portrait/Carousel/Image.texture
		var atlas_width = int(this_tex.atlas.get_width() / this_tex.region.size.x)
		this_tex.region.position = Vector2(
			portrait_index % atlas_width,
			portrait_index / atlas_width
		) * this_tex.region.size.x

var skill1 : int = 0
var stamina1 : int = 0
var stamina2 : int = 0
var luck1 : int = 0


func _update_ui():
	$Dialog/Main/Content/Body/Stats/SkillDice/Die1.texture = load(Game.DICE_TEXTURES[skill1 - 1])
	$Dialog/Main/Content/Body/Stats/StaminaDice/Die1.texture = load(Game.DICE_TEXTURES[stamina1 - 1])
	$Dialog/Main/Content/Body/Stats/StaminaDice/Die2.texture = load(Game.DICE_TEXTURES[stamina2 - 1])
	$Dialog/Main/Content/Body/Stats/LuckDice/Die1.texture = load(Game.DICE_TEXTURES[luck1 - 1])
	$Dialog/Main/Content/Body/Stats/SkillTotal.text = str(char_data.skill)
	$Dialog/Main/Content/Body/Stats/StaminaTotal.text = str(char_data.stamina)
	$Dialog/Main/Content/Body/Stats/LuckTotal.text = str(char_data.luck)


func _on_btn_prev_pressed() -> void:
	portrait_index -= 1


func _on_btn_next_pressed() -> void:
	portrait_index += 1


func _on_btn_roll_pressed() -> void:
	skill1 = randi_range(1, 6)
	stamina1 = randi_range(1, 6)
	stamina2 = randi_range(1, 6)
	luck1 = randi_range(1, 6)
	char_data.skill = skill1 + 6
	char_data.stamina = stamina1 + stamina2 + 12
	char_data.luck = luck1 + 6
	_update_ui()


func _on_btn_cancel_pressed() -> void:
	hide()


func _on_btn_ok_pressed() -> void:
	char_data.name = $Dialog/Main/Content/Body/Portrait/Name.text
	for key in char_data.keys():
		Game.player[key] = char_data[key]
	Game.new_game()
