extends Control

@onready var btn_choices = $Timeline/Content/Choices.get_children()
@onready var desc: Label = $Timeline/Content/Desc

var tl_test
var current_event


func _ready() -> void:
	tl_test = load("res://test/tl_test.tres")
	tl_test.compile()
	current_event = tl_test.events[0]
	for i in btn_choices.size():
		btn_choices[i].pressed.connect(_on_choice_pressed.bind(i))
	_update()


func _update():
	$Timeline/Content/Nav/BtnPrev.disabled = (current_event.prev_events.is_empty())
	$Timeline/Content/Nav/BtnNext.disabled = (current_event.next_events.is_empty())
	for btn in btn_choices:
		btn.hide()
	if current_event is EventImage:
		desc.text = "Event is EventImage."
		$Timeline/Content/Details/Image.texture = current_event.image
	if current_event is EventText:
		desc.text = "Event is EventText."
		$Timeline/Content/Details/Caption.text = current_event.lines
	if current_event is EventChoice:
		desc.text = "Event is EventChoice."
		for i in current_event.choices.size():
			btn_choices[i].text = current_event.choices[i].title
			btn_choices[i].show()
	if current_event is EventVarCheck:
		desc.text = "Event is EventVarCheck"
	if current_event is EventVarSet:
		desc.text = "Event is EventVarSet"
		set_variable(current_event)
	desc.text += "\nGame.state_var1: %d\nGame.state_var2: %d\nGame.state_var3: %d\n" % [
		Game.state_var1, Game.state_var2, Game.state_var3]


func set_variable(event : EventVarSet):
	var global = get_tree().root.get_node_or_null(event.global_name)
	if global:
		global.set(event.var_name, event.set_value)


func check_variable(event : EventVarCheck):
	if check_condition(event.condition):
		current_event = event.next_events[0]
	else:
		current_event = event.next_events[1]


func check_condition(cond : Condition):
	var compare = Expression.new()
	var exp_string = "comp_var" + cond.comparator + str(cond.comp_value)
	var error = compare.parse(exp_string, ["comp_var"])
	if error != OK:
		push_error(compare.get_error_text())
		return false
	var check_var = Game.get(cond.var_name)
	var result = compare.execute([check_var], self)
	if not compare.has_execute_failed() and result is bool:
		return result
	else:
		return false


func _on_choice_pressed(btn_index):
	if current_event is EventChoice:
		current_event = current_event.next_events[btn_index]
		_update()


func _on_btn_prev_pressed() -> void:
	if !current_event.prev_events.is_empty():
		current_event = current_event.prev_events[0]
		_update()


func _on_btn_next_pressed() -> void:
	if !current_event.next_events.is_empty():
		if current_event is EventVarCheck:
			check_variable(current_event)
		else:
			current_event = current_event.next_events[0]
		_update()
