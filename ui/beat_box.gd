class_name BeatBox
extends TextureButton


@export var track: Timeline.Track
@export var center_color: Color = Color.PINK
@export_range(0., 1.) var ping_time := .2
@export_range(0., 20) var ping_radius := 20.
@export var sound: AudioStream
@export var checked_icon: Texture2D
@export var unchecked_icon: Texture2D

@export var checked := false

var center: Vector2:
	get: return self.position + self.size / 2.

var ratio: float:
	get: return position.y / get_parent().size.y 

var _hit_sound: AudioStreamPlayer
var _hit_tween: Tween
var _hit_r := 0.
var _hit_color: Color

func hit(reset:bool = false) -> void:
	if !button_pressed:
		return 
	if _hit_tween:
		_hit_tween.kill()
	_hit_color = center_color
	_hit_r = 0.
	_hit_tween = create_tween()
	_hit_tween.tween_property(self, "_hit_r", ping_radius, ping_time).set_ease(Tween.EASE_OUT)
	_hit_tween.tween_property(self, "_hit_color:a", 0., max(0., ping_time - 0.07)).from(.5)
	
	if reset:
		self.button_pressed = false
		
	if sound:
		_hit_sound.play()
	
	Timeline.do_tick(track)
	

func _ready() -> void:
	#center = self.position + size
	_hit_sound = AudioStreamPlayer.new()
	_hit_sound.stream = sound
	self.add_child(_hit_sound)
	
	if checked_icon: 	self.texture_pressed = checked_icon
	if unchecked_icon: 	self.texture_normal = unchecked_icon
	
	Timeline.register(self)
	
func _process(delta: float) -> void:
	if _hit_tween:
		queue_redraw()
	
func _draw() -> void:
	draw_circle(size / 2., 2., center_color)
	if is_instance_valid(_hit_tween) && _hit_tween.is_running():
		draw_circle(size / 2., _hit_r, _hit_color, false)
