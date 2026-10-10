class_name Condition
extends Resource

@export var var_name : String = "var_name"
@export_enum("==", "!=", "<", "<=", ">", ">=") var comparator : String
@export var comp_value : Variant


func evaluate(value : Variant) -> bool:
	var compare = Expression.new()
	var exp_string = "comp_var" + comparator + str(comp_value)
	var error = compare.parse(exp_string, ["comp_var"])
	if error != OK:
		push_error(compare.get_error_text())
		return false
	var result = compare.execute([value], self)
	if not compare.has_execute_failed() and result is bool:
		return result
	else:
		return false
