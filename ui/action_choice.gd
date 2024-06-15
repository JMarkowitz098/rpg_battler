extends GridContainer

func clear_focus():
	for child in get_children():
		child.unfocus()
