extends Control


func _ready() -> void:
	$Content/BtnQuit.visible = (OS.get_name() != "Web")


func _on_btn_mansion_pressed() -> void:
	get_tree().change_scene_to_file("res://mansion/title/title.tscn")


func _on_btn_adventure_pressed() -> void:
	pass # Replace with function body.


func _on_btn_quit_pressed() -> void:
	get_tree().quit()
