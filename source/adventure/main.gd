extends Control

@onready var audio_channels = {
	"music": $Music,
	"sfx": $SFX,
	"vo": $Voice,
}
@onready var inv_slots = [
	{"button": %Slot1, "item": null},
	{"button": %Slot2, "item": null},
	{"button": %Slot3, "item": null},
	{"button": %Slot4, "item": null},
	{"button": %Slot5, "item": null},
	{"button": %Slot6, "item": null},
	{"button": %Slot7, "item": null},
	{"button": %Slot8, "item": null},
]
@onready var nav_buttons = {
	"nw": %BtnNW, "n": %BtnN, "ne": %BtnNE,
	"w": %BtnW, "u": %BtnUp, "d": %BtnDown, "e": %BtnE,
	"sw": %BtnSW, "s": %BtnS, "se": %BtnSE,
}
@onready var ui_info: Label = %Info
@onready var ui_text: RichTextLabel = %RoomText

var current_room : Room
var current_event : Event
var active_item : ItemData = null


func _ready() -> void:
	for i in inv_slots.size():
		inv_slots[i].button.pressed.connect(_on_inv_clicked.bind(i))
	for key in nav_buttons.keys():
		nav_buttons[key].pressed.connect(_on_nav_pressed.bind(key))
	load_room(Game.first_room)
	_inv_update()


func _process(_delta: float) -> void:
	if active_item != null:
		%CursorTag.global_position = get_global_mouse_position()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			active_item = null
			%CursorTag.hide()


func load_room(new_room : Room):
	current_room = new_room
	ui_info.text = "%s, Day %d, %s" % [current_room.name, Game.day, Game.time]
	ui_text.text = current_room.desc
	%Scene.texture = current_room.background
	for key in nav_buttons.keys():
		nav_buttons[key].disabled = !(key in current_room.exits.keys())


#func play_event():
	#if current_event is EventAudio:
		#play_audio(current_event)
	#elif current_event is EventChoice:
		#show_choice(current_event)
	#elif current_event is EventImage:
		#show_image(current_event)
	#elif current_event is EventText:
		#show_text(current_event)
	#else:
		#print("Invalid event type, check timeline data.")


#func next_event(index : int = 0):
	#if current_event.next_events.is_empty():
		#print("End of timeline reached, no more events to play.")
		#return
	#else:
		#current_event = current_event.next_events[index]
	#play_event()
#
#
#func play_audio(event : EventAudio):
	#var this_player : AudioStreamPlayer = audio_channels[event.channel.to_lower()]
	#this_player.stream = event.audio
	#this_player.play()
	#next_event()


#func show_image(event : EventImage):
	#if image_container.modulate.a != 0:
		#anim_book.play("scene_fade_in", -1, -1.0/event.fade_time, true)
		#await anim_book.animation_finished
	#book_image.texture = event.image
	#anim_book.play("scene_fade_in", -1, 1.0/event.fade_time)
	#await anim_book.animation_finished
	#next_event()
#
#
#func show_text(event : EventText):
	#if narrate_text.modulate.a != 0:
		#anim_book.play("text_fade_out")
		#await anim_book.animation_finished
	#narrate_text.text = ""
	#narrate_text.visible_characters = 0
	#narrate_text.modulate.a = 1
	#var split_string : PackedStringArray = event.lines.split("\n")
	#var full_text : String = ""
	#var tween_time : float = 1.0
	#for line in split_string:
		#tween_time = line.length() / Game.settings.text_speed
		#full_text += line + "\n"
		#narrate_text.text = full_text
		#var tween_text = create_tween()
		#tween_text.tween_property(narrate_text,
			#"visible_characters", full_text.length(), tween_time)
		#tween_text.play()
		#await tween_text.finished
		#await get_tree().create_timer(WAIT_TIME).timeout
	#if !current_event.next_events.is_empty():
		#if current_event.next_events[0] is EventChoice:
			#next_event()
		#else:
			#next_prompt()
#
#
#func next_prompt():
	#if ui_choices.modulate.a != 0:
		#anim_book.play_backwards("btn_fade_in")
		#await anim_book.animation_finished
	#ui_timer.hide()
	#for i in choice_btns.size():
		#if i == 0:
			#choice_btns[i].show()
			#choice_btns[i].text = "Next..."
		#else:
			#choice_btns[i].hide()
	#anim_book.play("btn_fade_in")
#
#
#func show_choice(event : EventChoice):
	#if ui_choices.modulate.a != 0:
		#anim_book.play_backwards("btn_fade_in")
		#await anim_book.animation_finished
	#ui_timer.hide()
	#timer_bar.value = 1.0
	#if event.choice_time > 0.0:
		#ui_timer.show()
	#for i in choice_btns.size():
		#if i >= event.choices.size():
			#choice_btns[i].hide()
		#else:
			#choice_btns[i].show()
			#choice_btns[i].text = event.choices[i].title
	#anim_book.play("btn_fade_in")
	#await anim_book.animation_finished
	#if event.choice_time > 0.0:
		#choice_timer.start(event.choice_time)
#
#
#func _on_choice_made(index: int):
	#choice_timer.stop()
	#anim_book.play_backwards("btn_fade_in")
	#await anim_book.animation_finished
	#next_event(index)


func _inv_update():
	var inv_size = Game.inventory.size()
	for i in inv_slots.size():
		if i >= inv_size:
			inv_slots[i].item = null
			inv_slots[i].button.texture_normal = null
		else:
			var new_item = load(Game.ITEM_PATH % Game.inventory[i])
			inv_slots[i].item = new_item
			inv_slots[i].button.texture_normal = new_item.image


func _on_inv_clicked(slot: int):
	if slot < inv_slots.size():
		print("Inventory clicked: %s" % inv_slots[slot].item.name)
		active_item = inv_slots[slot].item
		%CursorTag.text = active_item.name
		%CursorTag.show()


func _on_nav_pressed(dir: String):
	if dir in nav_buttons.keys():
		print("Direction clicked: %s to %s" % [dir, current_room.exits[dir]])
		var new_room = load(Game.ROOM_PATH % current_room.exits[dir])
		load_room(new_room)
