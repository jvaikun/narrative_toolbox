extends ColorRect

@onready var item_list = $Dialog/Main/Content/Body/List
@onready var item_img = $Dialog/Main/Content/Body/Info/Image
@onready var item_desc = $Dialog/Main/Content/Body/Info/Text
@onready var item_use = $Dialog/Main/Content/Body/Info/BtnUse


func _ready() -> void:
	for item_id in Game.inventory:
		var new_item = load(Game.ITEM_PATH % item_id)
		if new_item != null:
			if new_item is ItemData:
				item_list.add_item(new_item.name)
				item_list.set_item_metadata(-1, new_item)
	item_list.select(0)
	_on_list_item_selected(0)


func _on_list_item_selected(index: int) -> void:
	var this_item = item_list.get_item_metadata(index)
	item_img.texture = this_item.image
	item_desc.text = this_item.description
	item_use.visible = this_item.usable


func _on_btn_back_pressed() -> void:
	hide()


func _on_btn_use_pressed() -> void:
	pass # Replace with function body.
