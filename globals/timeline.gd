extends Node


signal tick(time_till_next_tick: float, kind: Track)

enum Track {
	SQUARE, # move
	CIRCLE,
	TRIANG,
	DIAMON,
}

var _square_marks: Array[BeatBox] = []
var _circle_marks: Array[BeatBox] = []
var _triang_marks: Array[BeatBox] = []
var _diamon_marks: Array[BeatBox] = []

var progress := 0.:
	get: return 1. - Metronome.timer.time_left / Metronome.timer.wait_time

func do_tick(track: Track) -> void:
	tick.emit(track, next_tick_delta(track))

func register(box: BeatBox) -> void:
	match box.track:
		Track.SQUARE: 
			_square_marks.append(box)
			_square_marks.sort_custom(func (a, b): a.ratio < b.ratio)
		Track.CIRCLE: 
			_circle_marks.append(box)
			_circle_marks.sort_custom(func (a, b): a.ratio < b.ratio)
		Track.TRIANG: 
			_triang_marks.append(box)
			_triang_marks.sort_custom(func (a, b): a.ratio < b.ratio)
		Track.DIAMON: 
			_diamon_marks.append(box)
			_diamon_marks.sort_custom(func (a, b): a.ratio < b.ratio)
		var other:
			push_error("unknown track! ", other)

func next_tick_delta(track: Track) -> float:
	var marks: Array[BeatBox] = []
	
	match track:
		Track.SQUARE: marks = _square_marks
		Track.CIRCLE: marks = _circle_marks
		Track.TRIANG: marks = _triang_marks
		Track.DIAMON: marks = _diamon_marks
	
	var ratio := Metronome.ratio_complete()
	
	# find the next mark in the specific track
	for mark: BeatBox in marks:
		var mark_ratio := mark.ratio
		if  mark_ratio > ratio:
			var time_of_mark := Metronome.loop_time() * mark_ratio
			var time_passed := Metronome.time_passed()
			var other := Metronome.loop_time() * ratio
			var time_delta := time_of_mark - time_passed
			assert(time_delta > 0., "this should always be positive!")
			return time_delta
	
	# if no mark was found use the time left + the time till the first mark
	var first_mark_delta :float = marks[0].ratio * Metronome.loop_time()
	return Metronome.time_left() + first_mark_delta

func track_color(track: Track) -> Color:
	match track:
		Track.SQUARE: return Color.html("e6482e")
		Track.CIRCLE: return Color.html("3cacd7")
		Track.TRIANG: return Color.html("f4b514")
		Track.DIAMON: return Color.html("cfc6b8")
	return Color.PINK
