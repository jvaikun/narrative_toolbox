class_name Event
extends Resource

@export var wait_time : float = 0.1
@export var wait_for_anim : bool = false
@export var wait_for_input : bool = false

var prev_events : Array[Event]
var next_events : Array[Event]

func _init() -> void:
	prev_events = []
	next_events = []
