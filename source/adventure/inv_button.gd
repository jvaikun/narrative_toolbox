extends TextureButton

var item_data : ItemData :
	set(val):
		item_data = val
		if item_data != null:
			disabled = false
			$Icon.texture = item_data.image
			tooltip_text = item_data.name
		else:
			disabled = true
			$Icon.texture = null
			tooltip_text = ""


func _on_mouse_entered() -> void:
	if !disabled:
		$SFX.play()
