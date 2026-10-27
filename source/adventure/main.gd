extends Control

const RAND_STEPS = preload("res://audio/rand_steps.tres")

@onready var audio_channels = {
	"music": $Music,
	"sfx": $SFX,
	"vo": $Voice,
}
@onready var inv_slots = %Slots.get_children()
@onready var nav_buttons = {
	"nw": %BtnNW, "n": %BtnN, "ne": %BtnNE,
	"w": %BtnW, "u": %BtnUp, "d": %BtnDown, "e": %BtnE,
	"sw": %BtnSW, "s": %BtnS, "se": %BtnSE,
}
@onready var ui_info: Label = %Info
@onready var ui_text: RichTextLabel = %RoomText
@onready var room_anim: AnimationPlayer = %RoomAnim

var current_room : Room
var current_event : Event
var active_item : ItemData = null


func _ready() -> void:
	room_anim.play("RESET")
	for i in inv_slots.size():
		inv_slots[i].pressed.connect(_on_inv_clicked.bind(i))
	for key in nav_buttons.keys():
		nav_buttons[key].pressed.connect(_on_nav_pressed.bind(key))
	load_room(Game.first_room)
	_inv_update()
	$Music.stream = load("res://audio/tense_loop.mp3")
	$Music.play()


func _process(_delta: float) -> void:
	if active_item != null:
		%Cursor.global_position = get_global_mouse_position()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			active_item = null
			%Cursor.hide()


func load_room(new_room : Room):
	current_room = new_room
	ui_info.text = "%s, Day %d, %s" % [current_room.name, Game.day, Game.time]
	for key in nav_buttons.keys():
		nav_buttons[key].disabled = !(key in current_room.exits.keys())
	current_room.timeline.compile()
	current_event = current_room.timeline.events[0]
	play_event()


func play_event():
	if current_event is EventAudio:
		play_audio(current_event)
	elif current_event is EventImage:
		show_image(current_event)
	elif current_event is EventText:
		show_text(current_event)
	else:
		print("Invalid event type, check timeline data.")


func next_event(index : int = 0):
	if current_event.next_events.is_empty():
		print("End of timeline reached, no more events to play.")
		return
	else:
		current_event = current_event.next_events[index]
	play_event()


func play_audio(event : EventAudio):
	var this_player : AudioStreamPlayer = audio_channels[event.channel.to_lower()]
	this_player.stream = event.audio
	this_player.play()
	next_event()


func show_image(event : EventImage):
	if %Scene.modulate.a != 0:
		room_anim.play("scene_fade_in", -1, -1.0/event.fade_time, true)
		await room_anim.animation_finished
	%Scene.texture = event.image
	room_anim.play("scene_fade_in", -1, 1.0/event.fade_time)
	await room_anim.animation_finished
	next_event()


func show_text(event : EventText):
	if ui_text.modulate.a != 0:
		room_anim.play("text_fade_out")
		await room_anim.animation_finished
	ui_text.text = ""
	ui_text.visible_characters = 0
	ui_text.modulate.a = 1
	var split_string : PackedStringArray = event.lines.split("\n")
	var full_text : String = ""
	var tween_time : float = 1.0
	for line in split_string:
		tween_time = line.length() / Game.settings.text_speed
		full_text += line + "\n"
		ui_text.text = full_text
		var tween_text = create_tween()
		tween_text.tween_property(ui_text,
			"visible_characters", full_text.length(), tween_time)
		tween_text.play()
		await tween_text.finished
	next_event()


func _inv_update():
	var inv_size = Game.inventory.size()
	for i in inv_slots.size():
		if i >= inv_size:
			inv_slots[i].item_data = null
		else:
			var new_item = load(Game.ITEM_PATH % Game.inventory[i])
			inv_slots[i].item_data = new_item


func _on_inv_clicked(slot: int):
	if slot < inv_slots.size():
		#print("Inventory clicked: %s" % inv_slots[slot].item_data.name)
		active_item = inv_slots[slot].item_data
		%CursorIcon.texture = active_item.image
		%CursorTag.text = active_item.name
		%Cursor.show()


func _on_nav_pressed(dir: String):
	if dir in nav_buttons.keys():
		#print("Direction clicked: %s to %s" % [dir, current_room.exits[dir]])
		$SFX.stream = RAND_STEPS
		$SFX.volume_db = -20.0
		room_anim.play("room_fade_out")
		for i in 3:
			$SFX.play()
			await $SFX.finished
		$SFX.volume_db = 0.0
		var new_room = load(Game.ROOM_PATH % current_room.exits[dir])
		load_room(new_room)


func _on_btn_system_pressed() -> void:
	$System.show()
