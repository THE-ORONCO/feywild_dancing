class_name Titania
extends Node2D


@export var camera :Camera2D

var beam_progress :Array[float]= []
var beam_wobble :Array[float]= []
var to_punish: Array[Node2D] = []

var running_tweens_count := 0:
	set(val):
		running_tweens_count = val
		if running_tweens_count == 0: punishment_finished.emit()

signal punishment_finished

func _ready() -> void:
	find_all_dancers.call_deferred()
	punishment_finished.connect(reset)

func find_all_dancers() -> void:
	var dancers := get_tree().get_nodes_in_group("dancer")
	
	
	beam_progress.resize(dancers.size())
	beam_wobble.resize(dancers.size())
	to_punish.resize(dancers.size())
	
	for i in range(dancers.size()):
		var dancer := dancers[i]
		to_punish[i] = dancer
		beam_progress[i] = 0.
		beam_wobble[i] = 16.
		dancer.set_meta("mistakes", 0)
		dancer.set_meta("punished", false)
		
		if dancer.has_signal("made_mistake"):
			dancer.made_mistake.connect(func() :
				var mistakes: int = dancer.get_meta("mistakes", 0)
				dancer.set_meta("mistakes", mistakes + 1)
				)

func _process(delta: float) -> void:
	queue_redraw()

func _physics_process(delta: float) -> void:
	if to_punish.filter(mistake_filter).size() != 0:
		punish()

func mistake_filter(dancer) -> bool:
	return is_instance_valid(dancer) && dancer.get_meta("mistakes", 0) >= 1 && not dancer.get_meta("punished", false)

func punish() -> void:	
	print("punish")
	Metronome.timer.paused = true
	#if punish_tween == null || !punish_tween.is_valid():
	
	var to_free := []
	for i in range(to_punish.size()):
		var dancer := to_punish[i]

		if is_instance_valid(dancer) && dancer.get_meta("mistakes", 0) >= 1 && not dancer.get_meta("punished"):
			print("punish dancer ", i, ": ", dancer)
			var punish_tween := create_tween()
			running_tweens_count += 1
			
			dancer.set_meta("punished", true)
			
			beam_progress[i] = 0.
			beam_wobble[i] = 16.
			
			assert(punish_tween != null, "AAAAAAAAAAAAAA")
			assert(punish_tween.is_valid(), "AAAAAAAAAAAAAA")
			var tweener := punish_tween.tween_method(progress_beam.bind(i) , 0., 1., .2)
			tweener.set_ease(Tween.EASE_IN)
			
			var off = camera.offset
			for s in range(0, 2):
				var delt = Vector2(randi_range(-2, 2), randi_range(0, 3))
				punish_tween.tween_property(camera, "offset", off + delt, 0.05)
			punish_tween.tween_property(camera, "offset", off, 0.1)
			
			
			if dancer is Player:
				punish_tween.tween_callback(get_tree().reload_current_scene)
			else:
				punish_tween.tween_callback(dancer.queue_free)
			punish_tween.tween_interval(.4)
			punish_tween.finished.connect(func(): running_tweens_count -= 1)

			to_free.append(dancer)
			
			

func progress_beam(p: float, index: int) -> void:
	assert(p <= 1., "too big")
	assert(index < to_punish.size(), "not possible")
	beam_progress[index] = p

func reset() -> void:
	Metronome.timer.paused = false

	


var wobble := 0
func _draw() -> void:
	for i in range(to_punish.size()):
		var dancer := to_punish[i]
		if !is_instance_valid(dancer): continue 
		
		#print(i, ": ", beam_wobble[i])
		if wobble % randi_range(10, 20) == 0:
			beam_wobble[i] = randf_range(16.,18.)
		
		var progress := beam_progress[i]
		var target := to_local(dancer.global_position)
		var start := target + Vector2.UP * 300.
		var end: Vector2 = lerp(start, target + Vector2.DOWN * Values.TILE_SIZE, progress)

		draw_line(start, end, Color.WHITE, beam_wobble[i])
		draw_circle(end, beam_wobble[i] / 1.8, Color.WHITE)
		wobble += 1
		
		#draw_circle(start, 5., Color.RED)
		#draw_circle(end, 1., Color.PINK)
		#draw_circle(target, 1., Color.PINK)
		
	
	
