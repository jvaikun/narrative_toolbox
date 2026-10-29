extends PanelContainer

var texture : Texture2D :
	set(val):
		texture = val
		$Frame/Content/ViewCont/View/Sprite.texture = texture

var text : String = "" :
	set(val):
		text = val
		$Frame/Content/Dialogue.text = text

var is_dialogue : bool = false :
	set(val):
		is_dialogue = val
		$Frame/Content/VSeparator.visible = is_dialogue
		$Frame/Content/Dialogue.visible = is_dialogue


func show_dialogue(speed : float = 0.5):
	pass
