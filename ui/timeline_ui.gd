class_name TimelineUI
extends CanvasLayer

@export var start_num:= 10
@export var running := false


@onready var tracks: Tracks = %Tracks

func _ready() -> void:
	if running:
		Metronome.start()
	else:
		Metronome.stop()
