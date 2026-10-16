extends ColorRect

const STAT_TEXT = "SKILL: %d\nSTAMINA: %d"
const RESULT_NORMAL = "%s inflicts 2 STAMINA damage on %s!"
const RESULT_DRAW = "Draw, no damage inflicted!"
const RESULT_WIN = "The enemy has been slain!"
const RESULT_LOSE = "You have been slain!"

@onready var ui_dice = [
	$Dialog/Main/Content/Body/Player/DiceRoll/Dice1,
	$Dialog/Main/Content/Body/Player/DiceRoll/Dice2,
	$Dialog/Main/Content/Body/Enemy/DiceRoll/Dice1,
	$Dialog/Main/Content/Body/Enemy/DiceRoll/Dice2,
]
@onready var sides = {
	"player": {
		"header": $Dialog/Main/Content/Body/Player/Name,
		"portrait": $Dialog/Main/Content/Body/Player/Portrait,
		"atlas": Game.ATLASES.player,
		"stats": $Dialog/Main/Content/Body/Player/Stats,
		"name":"",
		"skill":"",
		"stamina":"",
	},
	"enemy": {
		"header": $Dialog/Main/Content/Body/Enemy/Name,
		"portrait": $Dialog/Main/Content/Body/Enemy/Portrait,
		"atlas": Game.ATLASES.enemy,
		"stats": $Dialog/Main/Content/Body/Enemy/Stats,
		"name":"",
		"skill":"",
		"stamina":"",
	}
}

var dice_rolls = [1, 1, 1, 1]

signal combat_won


func _ready() -> void:
	for key in sides.keys():
		sides[key].portrait.texture = load(sides[key].atlas.path)


func set_portrait(side: String, idx: int):
	var this_tex = sides[side].portrait.texture
	var atlas_width = int(this_tex.atlas.get_width() / this_tex.region.size.x)
	sides[side].portrait.texture.region.position = Vector2(
		idx % atlas_width,
		idx / atlas_width
	) * this_tex.region.size.x


func init_combat():
	for key in sides.keys():
		var data = {}
		if key == "player":
			data = Game.player
			set_portrait(key, data.portrait)
		else:
			data = Game.current_enemy
			sides.enemy.portrait.texture = data.portrait
		sides[key].name = data.name
		sides[key].header.text = data.name
		sides[key].skill = data.skill
		sides[key].stamina = data.stamina
	_ui_update()


func _ui_update():
	for key in sides.keys():
		sides[key].stats.text = STAT_TEXT % [sides[key].skill, sides[key].stamina]
	if sides.player.stamina == 0:
		%Results.text += "\n" + RESULT_LOSE
		%BtnRoll.hide()
		%BtnLuck.hide()
		%BtnContinue.show()
	elif sides.enemy.stamina == 0:
		%Results.text += "\n" + RESULT_WIN
		%BtnRoll.hide()
		%BtnLuck.hide()
		%BtnContinue.show()


func _on_btn_roll_pressed() -> void:
	for i in dice_rolls.size():
		dice_rolls[i] = randi_range(1, 6)
		ui_dice[i].texture = load(Game.DICE_TEXTURES[dice_rolls[i]-1])
	var player_atk = dice_rolls[0] + dice_rolls[1] + sides.player.skill
	var enemy_atk = dice_rolls[2] + dice_rolls[3] + sides.enemy.skill
	if player_atk > enemy_atk:
		%Results.text = RESULT_NORMAL % [sides.player.name, sides.enemy.name]
		sides.enemy.stamina -= 2
	elif player_atk < enemy_atk:
		%Results.text = RESULT_NORMAL % [sides.enemy.name, sides.player.name]
		sides.player.stamina -= 2
	else:
		%Results.text = RESULT_DRAW
	_ui_update()


func _on_btn_luck_pressed() -> void:
	var luck_roll = randi_range(1, 6)
	luck_roll += randi_range(1, 6)
	if luck_roll <= Game.player.luck:
		print("Luck test passed!")
	else:
		print("Luck test failed!")
	Game.player.luck -= 1


func _on_btn_item_pressed() -> void:
	pass # Replace with function body.


func _on_btn_continue_pressed() -> void:
	if sides.player.stamina == 0:
		get_tree().change_scene_to_file("res://mansion/title/title.tscn")
	else:
		Game.player.stamina = sides.player.stamina
		combat_won.emit()
		hide()
