extends Node2D

@onready var dialogue: Dialogue = %Dialogue
@onready var day_timer: DayTimer = $DayTimer
@onready var timeline_ui: TimelineUI = %TimelineUI
const WIN_SCREEN = preload("uid://bsnqddp7yonko")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Values.has_seen(dialogue):
		start_the_day()
	else:
		dialogue.show_dialog([
			"As you open your eyes you find yourself in a castle.",
			"In front of you stands a queen unlike any you have seen before.",
			"In her overwhelming pressence you can only cower. You are caught in her domain.",
			"[color=white]Queen Titania: You have wandered into my castle little musician. Come and stay a little.",
			"[color=white]Queen Titania: Entertain us with your songs and take part in our fey dance.",
			"[color=white]Queen Titania: Do this without fault and I might let you go.",
			"Around you stand servants. Other humans that seem gaunt and ragged.",
			"You hear someone wisper that they don't want to dance anymore.",
			"But suddenly your hands grip your lute and you start playing unable to stop."
		]).connect(start_the_day)
		
	day_timer.day_over.connect(get_tree().change_scene_to_packed.bind(WIN_SCREEN))

func start_the_day() -> void:
	timeline_ui.show()
	
	for i in range(12):
		if i % 4 == 0:
			var tri:= timeline_ui.tracks.add_triangle()
			tri.button_pressed = true
			tri.disabled = true
		else:
			timeline_ui.tracks.add_triangle()
		if i % 2 == 0:
			if i % 4 == 0:
				var dia: = timeline_ui.tracks.add_diamond()
				dia.button_pressed = true
				dia.disabled = true
			else: 
				timeline_ui.tracks.add_diamond()

		if i % 3 == 0:
			if i % 6  == 0:
				var sq: = timeline_ui.tracks.add_square()
				sq.button_pressed = true
				sq.disabled = true
			else:
				timeline_ui.tracks.add_square()
		await get_tree().create_timer(.2).timeout

	Metronome.start()
	day_timer.start()
