extends Area2D

const inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

signal bumped_entity(entity: CollisionObject2D)
signal bumped_wall(wall: TileMapLayer)
signal took_damage(attacker: CollisionObject2D)

@onready var ray: RayCast2D = %Ray

var _input_buffer := Vector2.ZERO
var _reset_buffer := false
var _move_tween: Tween
var _move_dir := Vector2.ZERO

func _ready() -> void:
	self.position = position.snapped(Vector2.ONE * Values.TILE_SIZE)
	self.position += Vector2.ONE * Values.TILE_SIZE/2
	
	Timeline.tick.connect(_do_move)
	self.area_entered.connect(_handle_collision)

func _unhandled_input(event: InputEvent):
	var any_pressed := false
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			_input_buffer = inputs[dir]
			any_pressed = true
			
	if !any_pressed:
		_reset_buffer = true

func move(dir:Vector2, next_tick_delta: float):
	_move_dir = dir

	var target := dir * Values.TILE_SIZE
	ray.target_position = target
	ray.force_raycast_update()
	
	if !ray.is_colliding():	
		_move_tween = create_tween()
		_move_tween.tween_property(
			self, "position", position + target, max(0, next_tick_delta - 0.06)
		).set_trans(Tween.TRANS_SINE)

	else: # bump
		var collider := ray.get_collider()
		if collider is TileMapLayer:
			bumped_wall.emit(collider)
			print("bumped wall")
		elif collider is CollisionObject2D:
			bumped_entity.emit(collider)
			print("bumped entity ", collider)

func _do_move(track: Timeline.Track, ntd: float) -> void:
	match track:
		Timeline.Track.SQUARE: move(_input_buffer, ntd)
	#if _reset_buffer:
		#_reset_buffer = false
		#_input_buffer = Vector2.ZERO
	
func _handle_collision(body: CollisionObject2D) -> void:
	if _move_tween != null || is_instance_valid(_move_tween):
		_move_tween.kill()
		took_damage.emit(body)
		move(-_move_dir, Timeline.next_tick_delta(Timeline.Track.SQUARE))
		
