extends Area2D

signal made_mistake

@export var start_direction: Vector2 = Vector2.UP

@onready var move_cmp: MoveCmp = $MoveCmp
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var thud: AudioStreamPlayer = $Thud
@onready var sorry: AudioStreamPlayer = $Sorry


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_cmp.target_dir = start_direction
	move_cmp.bumped_wall.connect(func(_i): turn_right())
	move_cmp.bumped_entity.connect(func(_i): turn_left())
	move_cmp.bumped_entity.connect(func(_i): made_mistake.emit())


func turn_right() -> void:
	sprite_2d.rotate(PI/2.)
	thud.play()
	move_cmp.turn_right()

func turn_left() -> void:
	sprite_2d.rotate(-PI/2.)
	get_tree().create_timer(randf_range(0, 0.3)).timeout.connect(sorry.play)
	sorry.pitch_scale = randf_range(0.9, 1.1)
	move_cmp.turn_left()
	
