extends Node

const ROOM_PATH = "res://data/rooms/%s.tres"
const ITEM_PATH = "res://data/items/%s.tres"
const ENEMY_PATH = "res://data/enemies/%s.tres"
const ATLASES = {
	"player": {
		"path": "res://ui/textures/atlas_player.tres",
		"count": 12,
	},
	"enemy": {
		"path": "res://ui/textures/atlas_npc.tres",
		"count": 14,
	},
	"npc": {
		"path": "res://ui/textures/atlas_npc.tres",
		"count": 14,
	}
}
const DICE_TEXTURES = [
	"res://mansion/main/textures/dice_1.png",
	"res://mansion/main/textures/dice_2.png",
	"res://mansion/main/textures/dice_3.png",
	"res://mansion/main/textures/dice_4.png",
	"res://mansion/main/textures/dice_5.png",
	"res://mansion/main/textures/dice_6.png",
]

var player : Dictionary = {
	"name": "Player",
	"portrait": 0,
	"skill": 12,
	"stamina": 24,
	"luck": 12
}

var stamina_max : int = 0
var inventory : Array = ["magnum", "knife", "sandwich"]
var rations : int = 10

var game_state = {
	"intro": {},
	"act1": {},
	"act2": {},
	"act3": {},
	"outro": {},
}

var settings = {
	"music": 1.0,
	"sfx": 1.0,
	"vo": 1.0,
	"text_speed": 60,
	"auto_text": false,
}

var current_enemy : EnemyData
var first_room : Room = load("res://data/rooms/outside.tres")
var day : int = 1
var time : String = "Morning"


func _ready() -> void:
	randomize()


func set_audio(val : float, type : String):
	if type in settings.keys():
		settings[type] = clamp(val, 0.0, 1.0)
		AudioServer.set_bus_volume_linear(AudioServer.get_bus_index(type), val)


func new_game():
	get_tree().change_scene_to_file("res://mansion/main/main.tscn")


func load_game(_slot : int):
	# Load file
	# Set game state
	# Set player state
	# Set game settings
	pass


func save_game(_slot : int):
	# Open file
	# Get game state
	# Get player state
	# Get game settings
	# Save file
	pass
