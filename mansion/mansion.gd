extends Control

enum DayTimes {MORNING, NOON, NIGHT}

const TIMES = ["Morning", "Noon", "Night"]
const TIME_TEXT = "Day %d, %s"

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
@onready var floors = {
	"2F": {"btn": $Floors/Btn2F, "layer": $"Map/2F"},
	"1F":{"btn": $Floors/Btn1F, "layer": $"Map/1F"},
	"B1":{"btn": $Floors/BtnB1, "layer": $Map/B1},
	"B2":{"btn": $Floors/BtnB2, "layer": $Map/B2},
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

var day : int = 1
var day_time : DayTimes = DayTimes.MORNING


func _ready() -> void:
	for key in floors.keys():
		floors[key].btn.pressed.connect(set_layer.bind(key))


func set_layer(layer):
	for key in floors.keys():
		floors[key].layer.visible = (key == layer)


func _on_btn_advance_pressed() -> void:
	if day_time == DayTimes.NIGHT:
		day_time = DayTimes.MORNING
		day += 1
	else:
		day_time = (day_time + 1) as DayTimes
	$Time/Time.text = TIME_TEXT % [day, TIMES[day_time]]
