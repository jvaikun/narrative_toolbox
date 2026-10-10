class_name Character
extends Resource


@export var name : String = "Character Name"
@export_multiline var desc : String = "Character description"
@export var portrait : Texture2D
@export var schedule : Array[Dictionary] = [
	{"time": 1, "room": "attic", "repeat": false},
	{"time": 3, "room": "study", "repeat": true},
	{"time": 6, "room": "solar", "repeat": false},
]


func add_to_schedule(event : Dictionary):
	pass


func remove_from_schedule(event : Dictionary):
	pass
