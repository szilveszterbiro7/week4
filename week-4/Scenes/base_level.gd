extends Node2D


@onready var player=$Player
@onready var clone1=$Clone1
@onready var clone2=$Clone2
@onready var player_camera = $Player/Camera2D
@onready var clone1_camera = $Clone1/Camera2D
@onready var clone2_camera = $Clone2/Camera2D

var split=false
var active_clone=1
var split_sound=preload("res://Assets/Sounds/split.mp3")
var unite_sound=preload("res://Assets/Sounds/unite.mp3")
var transform_audio:AudioStreamPlayer
var union_label:Label
var union_timer:Timer

@export var unite_distance=200
@export var level_title: String=""

func _ready():
	if level_title!="":
		show_level_title()
	transform_audio=AudioStreamPlayer.new()
	transform_audio.volume_db=-12
	add_child(transform_audio)
	player.show()
	player.set_physics_process(true)
	clone1.hide()
	clone2.hide()
	clone1.process_mode=Node.PROCESS_MODE_DISABLED
	clone2.process_mode=Node.PROCESS_MODE_DISABLED
	player.get_node("CollisionShape2D").set_deferred("disabled", false)
	clone1.get_node("CollisionShape2D").set_deferred("disabled", true)
	clone2.get_node("CollisionShape2D").set_deferred("disabled", true)
	update_camera()
	add_child(preload("res://Scenes/pause_menu.tscn").instantiate())
	var message_layer=CanvasLayer.new()
	message_layer.layer=40
	add_child(message_layer)
	union_label=Label.new()
	message_layer.add_child(union_label)
	union_label.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	union_label.offset_top=-100
	union_label.offset_bottom=-40
	union_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	union_label.vertical_alignment=VERTICAL_ALIGNMENT_CENTER
	union_label.mouse_filter=Control.MOUSE_FILTER_IGNORE
	union_label.add_theme_font_size_override("font_size",26)
	union_label.add_theme_color_override("font_color", Color.WHITE)
	union_label.add_theme_color_override("font_outline_color", Color.BLACK)
	union_label.add_theme_constant_override("outline_size",6)
	union_label.hide()
	union_timer=Timer.new()
	union_timer.one_shot=true
	union_timer.wait_time=2
	add_child(union_timer)
	union_timer.timeout.connect(union_label.hide)
func _physics_process(_delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		return
	if Input.is_action_just_pressed("split"):
		if not split:
			split_player()
		else:
			try_unite()
	if Input.is_action_just_pressed("change_character") and split:
		switch_clone()
func split_player():
	player.stop_climbsound()
	play_transform_sound(split_sound)
	split=true
	clone1.global_position = player.global_position + Vector2(-20, 0)
	clone2.global_position = player.global_position + Vector2(20, 0)
	player.hide()
	player.set_physics_process(false)
	player.get_node("CollisionShape2D").set_deferred("disabled", true)
	clone1.show()
	clone2.show()
	clone1.process_mode=Node.PROCESS_MODE_INHERIT
	clone2.process_mode=Node.PROCESS_MODE_INHERIT
	clone1.get_node("CollisionShape2D").set_deferred("disabled", false)
	clone2.get_node("CollisionShape2D").set_deferred("disabled", false)
	active_clone=1
	clone1.active=true
	clone2.active=false
	update_camera()
func switch_clone():
	if active_clone==1:
		active_clone=2
		clone1.active=false
		clone2.active=true
	else:
		active_clone=1
		clone1.active=true
		clone2.active=false
	update_camera()
func try_unite():
	var distance=clone1.global_position.distance_to(clone2.global_position)
	if distance>unite_distance:
		show_union_message("Too far apart to unite!")
		return
	if not can_unite():
		show_union_message("An obstacle is blocking reunion!")
		return
	union_label.hide()
	union_timer.stop()
	unite()
func unite():
	play_transform_sound(unite_sound)
	clone1.stop_climbsound()
	clone2.stop_climbsound()
	split=false
	var middle_position=(clone1.global_position+clone2.global_position)/2
	clone1.active=false
	clone2.active=false
	clone1.hide()
	clone2.hide()
	clone1.process_mode=Node.PROCESS_MODE_DISABLED
	clone2.process_mode=Node.PROCESS_MODE_DISABLED
	clone1.get_node("CollisionShape2D").set_deferred("disabled", true)
	clone2.get_node("CollisionShape2D").set_deferred("disabled", true)
	player.global_position=middle_position
	player.show()
	player.set_physics_process(true)
	player.get_node("CollisionShape2D").set_deferred("disabled", false)
	update_camera()
func update_camera():
	player_camera.enabled=not split
	clone1_camera.enabled= split and active_clone==1
	clone2_camera.enabled=split and active_clone==2
func can_unite():
	var space_state=get_world_2d().direct_space_state
	var start=clone1.get_node("CollisionShape2D").global_position
	var end=clone2.get_node("CollisionShape2D").global_position
	var query = PhysicsRayQueryParameters2D.create(start, end)
	query.exclude=[clone1.get_rid(), clone2.get_rid(), player.get_rid()]
	query.collide_with_bodies=true
	query.collide_with_areas=false
	query.hit_from_inside=true
	var result=space_state.intersect_ray(query)
	if not result.is_empty():
		print("Obstacle detected: ", result["collider"].name)
		return false
	return true
func play_transform_sound(sound:AudioStream):
	transform_audio.stream=sound
	transform_audio.play()
func show_union_message(message:String):
	union_label.text=message
	union_label.show()
	union_timer.start()
func show_level_title():
	var title_layer=CanvasLayer.new()
	title_layer.layer=35
	add_child(title_layer)
	var title_label=Label.new()
	title_layer.add_child(title_label)
	title_label.text=level_title
	title_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	title_label.mouse_filter=Control.MOUSE_FILTER_IGNORE
	title_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	title_label.offset_top=100
	title_label.offset_bottom=170
	title_label.add_theme_font_size_override("font_size", 40)
	title_label.add_theme_color_override("font_color",Color.WHITE)
	title_label.add_theme_color_override("font_outline_color", Color.BLACK)
	title_label.add_theme_constant_override("outline_size", 8)
	var tween=create_tween()
	tween.tween_interval(2)
	tween.tween_property(title_label, "modulate:a", 0, 1)
	tween.tween_callback(title_layer.queue_free)
