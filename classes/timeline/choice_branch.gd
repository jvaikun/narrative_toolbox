class_name ChoiceBranch
extends Event

@export var title : String = "Choice Title"
@export var condition : Condition
@export var events : Array[Event]

var parent_choice : EventChoice
