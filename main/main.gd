extends Control

@onready var menu_list = {
	"inventory": $Inventory,
	"system": $System,
	"combat": $Combat,
}
@onready var audio_channels = {
	"music": $Music,
	"sfx": $SFX,
	"vo": $Voice,
}
@onready var player_stat_ui = {
	"name": $Content/Player/Content/Body/Name,
	"skill": $Content/Player/Content/Body/Stats/SkillNum,
	"stamina": $Content/Player/Content/Body/Stats/StaNum,
	"luck": $Content/Player/Content/Body/Stats/LuckNum,
}
@onready var player_portrait = $Content/Player/Content/Body/Portrait
@onready var image_container = $Content/Book/TwoPage/PageL/Frame/Content
@onready var book_image = $Content/Book/TwoPage/PageL/Frame/Content/Image
@onready var narrate_text = $Content/Book/TwoPage/PageR/Frame/Content/Body/Text
@onready var ui_choices = $Content/Book/TwoPage/PageR/Frame/Content/Body/Choices
@onready var choice_timer = $Content/Book/TwoPage/PageR/Frame/Content/Body/Choices/ChoiceTimer
@onready var ui_timer = $Content/Book/TwoPage/PageR/Frame/Content/Body/Choices/Timer
@onready var timer_bar = $Content/Book/TwoPage/PageR/Frame/Content/Body/Choices/Timer/Bar
@onready var choice_btns = $Content/Book/TwoPage/PageR/Frame/Content/Body/Choices/Buttons.get_children()
@onready var anim_book = $Content/Book/AnimBook

var current_menu : String = "none" :
	set(val):
		for key in menu_list.keys():
			if key == val:
				current_menu = val
				menu_list[key].show()
			else:
				menu_list[key].hide()

var timeline = []
var timeline_index : int = -1


func _ready() -> void:
	load_timeline("res://timelines/scene1.tres")
	player_portrait.texture = load(Game.ATLASES.player.path)
	_info_update()
	timer_bar.value = 1.0
	ui_timer.hide()
	for button in choice_btns:
		button.pressed.connect(on_choice_made)
	current_menu = "none"
	next_event()


func _process(_delta: float) -> void:
	if !choice_timer.is_stopped():
		timer_bar.value = choice_timer.time_left/choice_timer.wait_time
	if Input.is_action_just_pressed("ui_home"):
		#next_event()
		pass


func load_timeline(file_path : String):
	timeline = load(file_path).events
	timeline_index = -1
	anim_book.play("RESET")
	narrate_text.text = ""
	narrate_text.visible_characters = 0
	narrate_text.modulate.a = 1


func next_event():
	# Don't go past the end
	if timeline_index >= timeline.size()-1:
		print("End of timeline reached, no more events to play.")
		return
	timeline_index = clamp(timeline_index+1, 0, timeline.size()-1)
	var this_event = timeline[timeline_index]
	if this_event is EventAudio:
		play_audio(this_event)
	elif this_event is EventChoice:
		show_choice(this_event)
	elif this_event is EventImage:
		show_image(this_event)
	elif this_event is EventText:
		show_text(this_event)
	else:
		print("Invalid event type, check timeline data.")


func play_audio(event : EventAudio):
	var this_player : AudioStreamPlayer = audio_channels[event.channel.to_lower()]
	this_player.stream = event.audio
	this_player.play()


func show_image(event : EventImage):
	if image_container.modulate.a != 0:
		anim_book.play("scene_fade_in", -1, -1.0/event.fade_time, true)
		await anim_book.animation_finished
	book_image.texture = event.image
	anim_book.play("scene_fade_in", -1, 1.0/event.fade_time)
	await anim_book.animation_finished
	next_event()


func show_text(event : EventText):
	if narrate_text.modulate.a != 0:
		anim_book.play("text_fade_out")
		await anim_book.animation_finished
	narrate_text.text = ""
	narrate_text.visible_characters = 0
	narrate_text.modulate.a = 1
	var split_string : PackedStringArray = event.lines.split("\n")
	var full_text : String = ""
	var tween_time : float = 1.0
	for line in split_string:
		tween_time = line.length() / Game.settings.text_speed
		full_text += line + "\n"
		narrate_text.text = full_text
		var tween_text = create_tween()
		tween_text.tween_property(narrate_text,
			"visible_characters", full_text.length(), tween_time)
		tween_text.play()
		await tween_text.finished
		await get_tree().create_timer(event.wait_time).timeout
	if timeline_index < timeline.size()-1:
		if timeline[timeline_index+1] is EventChoice:
			next_event()
		else:
			next_prompt()


func next_prompt():
	if ui_choices.modulate.a != 0:
		anim_book.play_backwards("btn_fade_in")
		await anim_book.animation_finished
	for i in choice_btns.size():
		if i == 0:
			choice_btns[i].show()
			choice_btns[i].text = "Next. . ."
		else:
			choice_btns[i].hide()
	anim_book.play("btn_fade_in")


func show_choice(event : EventChoice):
	if ui_choices.modulate.a != 0:
		anim_book.play_backwards("btn_fade_in")
		await anim_book.animation_finished
	ui_timer.hide()
	timer_bar.value = 1.0
	if event.choice_time > 0.0:
		ui_timer.show()
	for i in choice_btns.size():
		if i >= event.choices.size():
			choice_btns[i].hide()
		else:
			choice_btns[i].show()
			choice_btns[i].text = event.choices[i]
	anim_book.play("btn_fade_in")
	await anim_book.animation_finished
	if event.choice_time > 0.0:
		choice_timer.start(event.choice_time)


func on_choice_made():
	choice_timer.stop()
	anim_book.play_backwards("btn_fade_in")
	await anim_book.animation_finished
	next_event()


func _info_update():
	var this_tex = player_portrait.texture
	var atlas_width = int(this_tex.atlas.get_width() / this_tex.region.size.x)
	this_tex.region.position = Vector2(
		Game.player.portrait % atlas_width,
		Game.player.portrait / atlas_width
	) * this_tex.region.size.x
	for key in player_stat_ui.keys():
		player_stat_ui[key].text = str(Game.player[key])


func _on_btn_inventory_pressed() -> void:
	current_menu = "inventory"


func _on_btn_options_pressed() -> void:
	current_menu = "system"


func _on_btn_combat_pressed() -> void:
	var rand_enemy = ["bigrat","brigand","ghoul","wolf","zombie"].pick_random()
	Game.current_enemy = load(Game.ENEMY_PATH % rand_enemy)
	$Combat.init_combat()
	current_menu = "combat"


func _on_choice_timeout() -> void:
	var this_event = timeline[timeline_index]
	if this_event is EventChoice:
		choice_btns[this_event.default_choice].pressed.emit()
