extends Node

var tokens: Array[Token]

func get_all_file_paths(path: String) -> Array[String]:  
	var file_paths: Array[String] = []  
	var dir = DirAccess.open(path)  
	dir.list_dir_begin()  
	var file_name = dir.get_next()  
	while file_name != "":  
		var file_path = path + "/" + file_name  
		if dir.current_is_dir():  
			file_paths += get_all_file_paths(file_path)  
		else:  
			file_paths.append(file_path)  
		file_name = dir.get_next()  
	return file_paths

func _ready():
	var token_paths = get_all_file_paths("res://resources/Tokens")
	for token in token_paths:
		tokens.append(load(token))

func get_token_from_id(id: int):
	for token: Token in tokens:
		if token.id == id:
			return token
	return null
