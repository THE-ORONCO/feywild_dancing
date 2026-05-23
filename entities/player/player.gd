class_name Player
extends Area2D

const inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

signal bumped_entity(entity: CollisionObject2D)
signal bumped_wall(wall: TileMapLayer)
signal took_damage(attacker: CollisionObject2D)

@onready var move_cmp: MoveCmp = %MoveCmp

var _input_buffer := Vector2.ZERO
var _reset_buffer := false

func _ready() -> void:
	move_cmp.bumped_wall.connect(func(_i): $Thud.play())
	
func _input(event: InputEvent):
	var any_pressed := false
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move_cmp.target_dir = inputs[dir]
			any_pressed = true
			
	if !any_pressed:
		_reset_buffer = true


		
