extends Panel



@onready var progress_bar: ProgressBar = %ProgressBar
@onready var tracks: Tracks = %Tracks

var _last_hit := 0.

func _process(delta: float) -> void:
	var progress := Timeline.progress
	progress_bar.ratio = progress
	tracks.hit_range(_last_hit, progress)
	_last_hit = progress
