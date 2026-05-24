extends Node

@onready var timer: Timer = %Timer

func start() -> void:
	timer.start()

func stop() -> void:
	timer.stop()

func time_left() -> float:
	return timer.time_left

func time_passed() -> float:
	return timer.wait_time - timer.time_left

func ratio_complete() -> float:
	return time_passed() / timer.wait_time

func loop_time() -> float:
	return timer.wait_time
