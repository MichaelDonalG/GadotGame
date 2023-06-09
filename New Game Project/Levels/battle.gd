extends Control

func _ready():
	$TextBox.hide()
	$ActionsPanel.hide()
	
	display_text("Cow attacks")

func display_text(text):
	$TextBox.show()
	$TextBox/Text.text = text
