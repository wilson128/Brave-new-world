extends StaticBody2D

func save():
	var save_dict = {
		"filename": "bleach",
		"visible": visible
	}
	return save_dict
