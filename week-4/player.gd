extends CharacterBody2D


@export var speed=300
@export var jump_velocity=-550.0
@export var climb_speed=180

@onready var sprite=$CollisionShape2D/Sprite2D

var gravity=900
var visual_scale:Vector2
var visual_position:Vector2
var animation_time=0
var was_grounded=false
var jump_sound=preload("res://Assets/Sounds/jump.mp3")
var land_sound=preload("res://Assets/Sounds/landing.mp3")
var sound_player:AudioStreamPlayer
var climbing=false
var climb_sound=preload("res://Assets/Sounds/climb.mp3")
var climb_audio:AudioStreamPlayer

func _ready():
	climb_audio=AudioStreamPlayer.new()
	climb_audio.stream=climb_sound
	climb_audio.volume_db=-18
	add_child(climb_audio)
	sound_player=AudioStreamPlayer.new()
	sound_player.volume_db=-12
	add_child(sound_player)
	visual_scale=sprite.scale
	visual_position=sprite.position
func _physics_process(delta):
	climbing=can_climb_here() and Input.is_action_pressed("climb")
	if climbing:
		velocity.x=Input.get_axis("left","right")*speed
		velocity.y=Input.get_axis("climb_up", "climb_down")*climb_speed
	else:
		if not is_on_floor():
			velocity.y+=gravity*delta
		velocity.x=Input.get_axis("left", "right")*speed
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y=jump_velocity
			play_sound(jump_sound)
	move_and_slide()
	update_climbsound()
	animate_character(delta)
func animate_character(delta):
	animation_time+=delta
	var grounded=is_on_floor()
	var target_scale=visual_scale
	var bob=0
	var tilt=0
	if velocity.x>10:
		sprite.flip_h=false
	elif velocity.x<-10:
		sprite.flip_h=true
	if climbing:
		if velocity.length()>10:
			tilt=sin(animation_time*14)*0.06
	elif not grounded:
		target_scale=visual_scale*Vector2(0.9,1.1)
	elif abs(velocity.x)>10:
		bob=-abs(sin(animation_time*14))*4
		tilt= sin(animation_time*14)*0.04
	if grounded and not was_grounded:
		sprite.scale=visual_scale*Vector2(1.15,0.85)
		play_sound(land_sound)
	var smoothing=1-exp(-14.0*delta)
	sprite.scale=sprite.scale.lerp(target_scale, smoothing)
	sprite.position=visual_position+Vector2(0, bob)
	sprite.rotation=lerp_angle(sprite.rotation, tilt, smoothing)
	was_grounded=grounded
func play_sound(sound:AudioStream):
	sound_player.stream=sound
	sound_player.pitch_scale=randf_range(0.95,1.05)
	sound_player.play()
func can_climb_here():
	for surface in get_tree().get_nodes_in_group("main_climb"):
		if surface is Area2D and surface.overlaps_body(self):
			return true
	return false
func update_climbsound():
	if climbing and velocity.length()>10:
		if not climb_audio.playing:
			climb_audio.play()
	else:
		climb_audio.stop()
func stop_climbsound():
	climb_audio.stop()
