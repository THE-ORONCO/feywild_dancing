extends Area2D

@export var start_direction: Vector2 = Vector2.UP

@onready var move_cmp: MoveCmp = $MoveCmp
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var thud: AudioStreamPlayer = $Thud
@onready var clank: AudioStreamPlayer = $Clank


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_cmp.target_dir = start_direction
	move_cmp.bumped_wall.connect(func(_i): turn_right())
	move_cmp.bumped_entity.connect(func(_i): turn_left())


func turn_right() -> void:
	thud.play()
	move_cmp.turn_right(2)

func turn_left() -> void:
	get_tree().create_timer(randf_range(0, 0.3)).timeout.connect(clank.play)
	clank.pitch_scale = randf_range(0.9, 1.1)
	
