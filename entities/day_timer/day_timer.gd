class_name DayTimer
extends Node

signal day_over

@export var over_day_gradient: Gradient

@onready var timer: Timer = %Timer

func _ready() -> void:
	timer.timeout.connect(day_over.emit)

func start() -> void:
	timer.start()

func _physics_process(delta: float) -> void:
	var ratio := timer.time_left / timer.wait_time 
	var color := over_day_gradient.sample(ratio)
	RenderingServer.set_default_clear_color(color)
