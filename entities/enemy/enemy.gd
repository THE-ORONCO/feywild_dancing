extends Area2D

@onready var move_cmp: MoveCmp = $MoveCmp
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var thud: AudioStreamPlayer = $Thud

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_cmp.target_dir = Vector2.UP
	move_cmp.bumped_wall.connect(func(_i): turn_right())

func turn_right() -> void:
	sprite_2d.rotate(PI/2.)
	thud.play()
	move_cmp.target_dir = move_cmp.target_dir.rotated(PI / 2.)
