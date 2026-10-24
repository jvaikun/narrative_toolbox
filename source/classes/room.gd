class_name Room
extends Resource

@export var name : String = "Room Name"
@export var timeline : Timeline
@export var background : Texture2D
@export_multiline var desc : String = "Room description"
@export var exits : Dictionary[String, String]
@export var interactables : Array

var first_visit : bool = true
var characters : Array[Character]


func reset():
	first_visit = true
	characters.clear()
