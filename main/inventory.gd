extends PanelContainer

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


func _ready() -> void:
	for key in ITEMS.keys():
		$Main/Content/Body/List.add_item(ITEMS[key].name)
		$Main/Content/Body/List.set_item_metadata(-1, key)


func _on_list_item_selected(index: int) -> void:
	var item_id = $Main/Content/Body/List.get_item_metadata(index)
	var this_item = ITEMS[item_id]
	$Main/Content/Body/Info/Image.texture = load(this_item.img_path)
	$Main/Content/Body/Info/Text.text = this_item.desc
	$Main/Content/Body/Info/BtnUse.visible = this_item.usable


func _on_btn_back_pressed() -> void:
	hide()
