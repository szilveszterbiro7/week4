extends CharacterBody2D


@export var speed=300
@export var jump_velocity=-550
@export var climb_speed=180

var gravity=900
var active=false
var climbing=false
var visual_scale:Vector2
var visual_position:Vector2
var animation_time=0
var was_grounded=false
var jump_sound=preload("res://Assets/Sounds/jump.mp3")
var land_sound=preload("res://Assets/Sounds/landing.mp3")
var climb_sound=preload("res://Assets/Sounds/climb.mp3")
var climb_audio:AudioStreamPlayer
var sound_player:AudioStreamPlayer

@onready var indicator=$Indicator
@onready var sprite=$Sprite2D

func _ready():
	sound_player=AudioStreamPlayer.new()
	sound_player.volume_db=-12
	add_child(sound_player)
	visual_scale=sprite.scale
	visual_position=sprite.position
	climb_audio=AudioStreamPlayer.new()
	climb_audio.stream=climb_sound
	climb_audio.volume_db=-18
	add_child(climb_audio)
func _physics_process(delta):
	indicator.visible=active
	var near_surface=can_climb_here()
	if active:
		climbing=near_surface and Input.is_action_pressed("climb")
	elif not near_surface:
		climbing=false
	if climbing:
		velocity=Vector2.ZERO
		if active:
			velocity.y=Input.get_axis("climb_up","climb_down")*climb_speed
			velocity.x=Input.get_axis("left","right")*speed
	else:
		if not is_on_floor():
			velocity.y+=gravity*delta
		if active:
			var direction=Input.get_axis("left", "right")
			velocity.x=direction*speed
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y=jump_velocity
				play_sound(jump_sound)
		else:
			velocity.x=0
	move_and_slide()
	update_climbsound()
	animate_character(delta)
func can_climb_here()->bool:
	var climb_group=""
	if name=="Clone1":
		climb_group="blue_climb"
	elif name=="Clone2":
		climb_group="orange_climb"
	else:
		return false
	for surface in get_tree().get_nodes_in_group(climb_group):
		if surface is Area2D and surface.overlaps_body(self):
			return true
	return false
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
			tilt=sin(animation_time*14)>0.06
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
func update_climbsound():
	var moving_on_surface=(active and climbing and velocity.length()>10)
	if moving_on_surface:
		if not climb_audio.playing:
			climb_audio.play()
	else:
		climb_audio.stop()
func stop_climbsound():
	climb_audio.stop()
