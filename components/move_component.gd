class_name MoveCmp
extends Node

signal bumped_entity(entity: CollisionObject2D)
signal bumped_wall(wall: TileMapLayer)
signal finished_move

@export var moved_entity: Area2D

var target_dir := Vector2.ZERO

var _move_dir := Vector2.ZERO
var _last_safe_position: Vector2
var _ray: RayCast2D
var _move_tween: Tween
var _rotate_tween: Tween

func _snap(pos: Vector2) -> Vector2:
	return pos.snapped(Vector2.ONE * Values.TILE_SIZE)

func _ready() -> void:
	moved_entity.position = moved_entity.position.snapped(Vector2.ONE * Values.TILE_SIZE)
	moved_entity.position += Vector2.ONE * Values.TILE_SIZE/2
	_last_safe_position = moved_entity.position
	
	Timeline.tick.connect(_do_move)
	moved_entity.area_entered.connect(_handle_collision)
	
	_ray = RayCast2D.new()
	_ray.position = Vector2.ZERO
	moved_entity.add_child.call_deferred(_ray)


func move(target: Vector2, next_tick_delta: float):
	var move_delta := target - moved_entity.position
	_ray.target_position = move_delta
	_ray.force_raycast_update()
	
	if !_ray.is_colliding():	
		_move_tween = create_tween()
		_move_tween.tween_property(
			# we subtract a very small time delta here to ensure that we arrive before the next tick
			moved_entity, "position", target, max(0, next_tick_delta - 0.06)
		).set_trans(Tween.TRANS_SINE)
		_move_tween.finished.connect(finished_move.emit)
		_move_tween.finished.connect(func(): _last_safe_position = moved_entity.position)

	else: # bump
		var collider := _ray.get_collider()
		_emit_collision_info(collider)
			
func turn_right(times: int = 1) -> void:
	target_dir = target_dir.rotated((PI/2) * times)

func turn_left(times: int = 1) -> void:
	target_dir = target_dir.rotated((-PI/2) * times)

func _emit_collision_info(collider: Object) -> void:
	if collider is TileMapLayer:
		bumped_wall.emit(collider)
		print("bumped wall")
	elif collider is CollisionObject2D:
		bumped_entity.emit(collider)
		print("bumped entity ", collider)

func _do_move(track: Timeline.Track, ntd: float) -> void:
	match track:
		Timeline.Track.SQUARE: 
			var delta := target_dir * Values.TILE_SIZE
			move(_last_safe_position + delta, ntd)
	#if _reset_buffer:
		#_reset_buffer = false
		#_input_buffer = Vector2.ZERO
	
func _handle_collision(body: CollisionObject2D) -> void:
	if _move_tween != null || is_instance_valid(_move_tween):
		_move_tween.kill()
		move(_last_safe_position, Timeline.next_tick_delta(Timeline.Track.SQUARE))
	_emit_collision_info(body)
		
