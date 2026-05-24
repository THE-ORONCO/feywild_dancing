class_name Dialogue
extends CanvasLayer


@onready var text_box: Panel = %TextBox
@onready var text_label: RichTextLabel = %TextLabel

var in_dialogue := false
var dialogue_paused: bool:
	get: return dialogue_tween != null && dialogue_tween.is_valid() && !dialogue_tween.is_running()
var dialogue_tween: Tween

func show_dialog(lines: Array[String]) -> Signal:
	in_dialogue = true
	text_box.show()
	dialogue_tween = create_tween()
	
	for line in lines:
		dialogue_tween.tween_callback(func():
			text_label.text = line
			text_label.visible_ratio = 0.
			)
		dialogue_tween.tween_property(text_label, "visible_characters", line.length(), line.length() * 0.02)
		dialogue_tween.tween_callback(dialogue_tween.pause)
		
	dialogue_tween.tween_property(self, "in_dialogue", false, 0.)
	dialogue_tween.parallel().tween_property(text_box, "visible", false, 0.)
	
	return dialogue_tween.finished

func continue_text() -> void:
	dialogue_tween.play()

func _input(event: InputEvent) -> void:
	if event.is_action("ui_accept"):
		if self.dialogue_paused:
			self.continue_text()
