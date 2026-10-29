extends Control

const WAIT_TIME = 0.1

@onready var menu_list = {
	"inventory": $Inventory,
	"system": $System,
	"combat": $Combat,
}
@onready var audio_channels = {
	"music": $Music,
	"sfx": $SFX,
	"voice": $Voice,
}
@onready var player_stat_ui = {
	"name": $Content/Player/Content/Body/Name,
	"skill": $Content/Player/Content/Body/Stats/SkillNum,
	"stamina": $Content/Player/Content/Body/Stats/StaNum,
	"luck": $Content/Player/Content/Body/Stats/LuckNum,
}
@onready var player_portrait = $Content/Player/Content/Body/Portrait
@onready var image_container = $Content/Book/TwoPage/PageL/Frame/Content
@onready var popup_container = $Content/Book/TwoPage/PageL/Frame/Popups
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
var current_event : Event = null


func _ready() -> void:
	load_timeline("res://timelines/mm_intro.tres")
	player_portrait.texture = load(Game.ATLASES.player.path)
	_info_update()
	timer_bar.value = 1.0
	ui_timer.hide()
	for i in choice_btns.size():
		choice_btns[i].pressed.connect(_on_choice_made.bind(i))
	$Combat.visibility_changed.connect(_info_update)
	current_menu = "none"
	play_event()


func _process(_delta: float) -> void:
	if !choice_timer.is_stopped():
		timer_bar.value = choice_timer.time_left/choice_timer.wait_time


func load_timeline(file_path : String):
	timeline = load(file_path)
	timeline.compile()
	current_event = timeline.events[0]
	#timeline_index = -1
	anim_book.play("RESET")
	narrate_text.text = ""
	narrate_text.visible_characters = 0
	narrate_text.modulate.a = 1


func play_event():
	if current_event is EventAudio:
		play_audio(current_event)
	elif current_event is EventChoice:
		show_choice(current_event)
	elif current_event is EventImage:
		show_image(current_event)
	elif current_event is EventText:
		show_text(current_event)
	elif current_event is EventCombat:
		start_combat(current_event)
	elif current_event is EventJump:
		jump(current_event)
	elif current_event is EventPopup:
		show_popup(current_event)
	else:
		print("Invalid event type, check timeline data.")


func next_event(index : int = 0):
	if current_event.next_events.is_empty():
		print("End of timeline reached, no more events to play.")
		return
	else:
		current_event = current_event.next_events[index]
	play_event()


func set_variable(event : EventVarSet):
	var global = get_tree().root.get_node_or_null(event.global_name)
	if global:
		global.set(event.var_name, event.set_value)


func check_condition(cond : Condition):
	var compare = Expression.new()
	var exp_string = "comp_var" + cond.comparator + str(cond.comp_value)
	var error = compare.parse(exp_string, ["comp_var"])
	if error != OK:
		push_error(compare.get_error_text())
		return false
	var check_var = get_tree().root.get_node_or_null(Game.get(cond.var_name))
	var result = compare.execute([check_var], self)
	if not compare.has_execute_failed() and result is bool:
		return result
	else:
		return false


func play_audio(event : EventAudio):
	var this_player : AudioStreamPlayer = audio_channels[event.channel.to_lower()]
	this_player.stream = event.audio
	this_player.play()
	next_event()


func show_popup(event : EventPopup):
	var popup_inst = event.popup_scene.instantiate()
	popup_inst.is_dialogue = false
	popup_inst.modulate.a = 0.0
	popup_container.add_child(popup_inst)
	var tween_fade = create_tween()
	tween_fade.tween_property(popup_inst, "modulate:a", 1.0, 0.5)
	tween_fade.play()
	await tween_fade.finished
	next_event()


func clear_popups():
	for child in popup_container.get_children():
		child.queue_free()


func show_image(event : EventImage):
	clear_popups()
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
		await get_tree().create_timer(WAIT_TIME).timeout
	if !current_event.next_events.is_empty():
		if current_event.next_events[0] is EventChoice:
			next_event()
		else:
			next_prompt()


func start_combat(event: EventCombat):
	Game.current_enemy = event.enemy
	$Combat.init_combat()
	current_menu = "combat"
	await $Combat.combat_won
	next_event()


func jump(event: EventJump):
	load_timeline("res://timelines/%s.tres" % event.timeline)
	play_event()


func next_prompt():
	_disable_choices(true)
	if ui_choices.modulate.a != 0:
		anim_book.play_backwards("btn_fade_in")
		await anim_book.animation_finished
	ui_timer.hide()
	for i in choice_btns.size():
		if i == 0:
			choice_btns[i].show()
			choice_btns[i].text = "Next..."
		else:
			choice_btns[i].hide()
	anim_book.play("btn_fade_in")
	await anim_book.animation_finished
	_disable_choices(false)


func show_choice(event : EventChoice):
	_disable_choices(true)
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
			choice_btns[i].text = event.choices[i].title
	anim_book.play("btn_fade_in")
	await anim_book.animation_finished
	_disable_choices(false)
	if event.choice_time > 0.0:
		choice_timer.start(event.choice_time)


func _on_choice_made(index: int):
	_disable_choices(true)
	choice_timer.stop()
	anim_book.play_backwards("btn_fade_in")
	await anim_book.animation_finished
	next_event(index)


func _info_update():
	var this_tex = player_portrait.texture
	var atlas_width = int(this_tex.atlas.get_width() / this_tex.region.size.x)
	this_tex.region.position = Vector2(
		Game.player.portrait % atlas_width,
		Game.player.portrait / atlas_width
	) * this_tex.region.size.x
	for key in player_stat_ui.keys():
		player_stat_ui[key].text = str(Game.player[key])
	%Rations.text = "Rations: %d" % Game.rations


func _disable_choices(disable : bool):
	for button in choice_btns:
		button.disabled = disable


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
	if current_event is EventChoice:
		choice_btns[current_event.default_choice].pressed.emit()


func _on_btn_eat_pressed() -> void:
	if Game.player.stamina < Game.stamina_max:
		Game.rations -= 1
		Game.player.stamina = min(Game.player.stamina+4, Game.stamina_max)
	_info_update()
