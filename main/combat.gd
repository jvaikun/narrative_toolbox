extends ColorRect

const STAT_TEXT = "SKILL: %d\nSTAMINA: %d"

@onready var ui_dice = [
	$Dialog/Main/Content/Body/Player/DiceRoll/Dice1,
	$Dialog/Main/Content/Body/Player/DiceRoll/Dice2,
	$Dialog/Main/Content/Body/Enemy/DiceRoll/Dice1,
	$Dialog/Main/Content/Body/Enemy/DiceRoll/Dice2,
]
@onready var sides = {
	"player": {
		"portrait": $Dialog/Main/Content/Body/Player/Portrait,
		"atlas": Game.ATLASES.player,
		"stats": $Dialog/Main/Content/Body/Player/Stats,
		"name":"",
		"skill":"",
		"stamina":"",
	},
	"enemy": {
		"portrait": $Dialog/Main/Content/Body/Enemy/Portrait,
		"atlas": Game.ATLASES.enemy,
		"stats": $Dialog/Main/Content/Body/Enemy/Stats,
		"name":"",
		"skill":"",
		"stamina":"",
	}
}

var dice_rolls = [1, 1, 1, 1]


func _ready() -> void:
	for key in sides.keys():
		sides[key].portrait.texture = load(sides[key].atlas.path)


func set_portrait(side: String, idx: int):
	var this_atlas = sides[side].portrait.texture
	var atlas_width = int(this_atlas.get_width() / this_atlas.region.size.x)
	sides[side].portrait.texture.region.position = Vector2(
		idx % atlas_width,
		idx / atlas_width
	) * this_atlas.region.size.x


func init_combat():
	for key in sides.keys():
		var data = {}
		if key == "player":
			data = Game.player
		else:
			data = Game.current_enemy
		set_portrait(key, data.portrait)
		sides[key].name = data.name
		sides[key].skill = data.skill
		sides[key].stamina = data.stamina
	_ui_update()


func next_round():
	pass


func _ui_update():
	for key in sides.keys():
		sides[key].stats.text = STAT_TEXT % [sides[key].skill, sides[key].stamina]


func _on_btn_roll_pressed() -> void:
	for i in dice_rolls.size():
		dice_rolls[i] = randi_range(1, 6)
		ui_dice[i].texture = load(Game.DICE_TEXTURES[dice_rolls[i]-1])


func _on_btn_luck_pressed() -> void:
	pass # Replace with function body.


func _on_btn_item_pressed() -> void:
	pass # Replace with function body.


func _on_btn_back_pressed() -> void:
	hide()
