extends Control

@onready var mansion_map = {
	"entrance": $"Map/1F/Entrance",
	"1f_east1": $"Map/1F/1FEast1",
	"1f_east2": $"Map/1F/1FEast2",
	"1f_east3": $"Map/1F/1FEast3",
	"1f_west1": $"Map/1F/1FWest1",
	"1f_west2": $"Map/1F/1FWest2",
	"1f_west3": $"Map/1F/1FWest3",
	"courtyard": $"Map/1F/Courtyard",
	"2f_east1": $"Map/2F/2FEast1",
	"2f_east2": $"Map/2F/2FEast2",
	"2f_west1": $"Map/2F/2FWest1",
	"2f_west2": $"Map/2F/2FWest2",
	"cellar1": $Map/B1/Cellar1,
	"cellar2": $Map/B1/Cellar2,
	"cellar3": $Map/B1/Cellar3,
	"crypt1": $Map/B2/Crypt1,
	"crypt2": $Map/B2/Crypt2,
	"crypt3": $Map/B2/Crypt3,
}

var characters = {
	"npc1":{
		"name": "NPC Name",
		"portrait": 0,
		"desc": "NPC Description",
		"schedule": {
			"room1": [0, 1, 2, 3],
			"room2": [4, 5],
			"room3": [8, 9],
		}
	},
	"npc2":{
		"name": "NPC Name",
		"portrait": 0,
		"desc": "NPC Description",
		"schedule": {
			"room1": [0, 1, 2, 3],
			"room2": [4, 5],
			"room3": [8, 9],
		}
	},
	"npc3":{
		"name": "NPC Name",
		"portrait": 0,
		"desc": "NPC Description",
		"schedule": {
			"room1": [0, 1, 2, 3],
			"room2": [4, 5],
			"room3": [8, 9],
		}
	},
	"npc4":{
		"name": "NPC Name",
		"portrait": 0,
		"desc": "NPC Description",
		"schedule": {
			"room1": [0, 1, 2, 3],
			"room2": [4, 5],
			"room3": [8, 9],
		}
	},
}

var turn_count : int = 0


func _ready() -> void:
	pass # Replace with function body.
