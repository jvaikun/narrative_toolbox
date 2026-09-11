extends ColorRect

const ITEMS = {
	"magnum": {
		"name": "Magnum Flintlock",
		"img_path": "res://main/textures/flintlock.png",
		"desc": "It's really powerful. Especially against living things!",
		"usable": false,
	},
	"chris_blood": {
		"name": "Chris' Blood",
		"img_path": "res://main/textures/d6_number.png",
		"desc": "You had hoped this wasn't Chris' blood, but it is.",
		"usable": false,
	},
	"not_chris_blood": {
		"name": "Not Chris' Blood",
		"img_path": "res://main/textures/d6_number.png",
		"desc": "You had hoped this wasn't Chris' blood. Thankfully, it isn't.",
		"usable": false,
	},
	"jill_sandwich": {
		"name": "Jill Sandwich",
		"img_path": "res://main/textures/d6_number.png",
		"desc": "You almost ate this for lunch.",
		"usable": true,
	},
}

@onready var item_list = $Dialog/Main/Content/Body/List
@onready var item_img = $Dialog/Main/Content/Body/Info/Image
@onready var item_desc = $Dialog/Main/Content/Body/Info/Text
@onready var item_use = $Dialog/Main/Content/Body/Info/BtnUse


func _ready() -> void:
	for key in ITEMS.keys():
		item_list.add_item(ITEMS[key].name)
		item_list.set_item_metadata(-1, key)
	item_list.select(0)
	_on_list_item_selected(0)


func _on_list_item_selected(index: int) -> void:
	var item_id = item_list.get_item_metadata(index)
	var this_item = ITEMS[item_id]
	item_img.texture = load(this_item.img_path)
	item_desc.text = this_item.desc
	item_use.visible = this_item.usable


func _on_btn_back_pressed() -> void:
	hide()


func _on_btn_use_pressed() -> void:
	pass # Replace with function body.
