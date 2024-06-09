extends HBoxContainer

@onready var skill_button = $SkillButton
@onready var icon_focus = $Container/Focus

@onready var text:
	get:
		return skill_button.text
	set(value):
		skill_button.text = value
	
func focus():
	icon_focus.focus()

func unfocus():
	icon_focus.unfocus()
