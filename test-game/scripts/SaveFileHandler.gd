extends Node

var SAVE_FILE_PATH = "user://savegame.save"


func _ready():
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		save_game()


func save_game():
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	
	for node in save_nodes:
		if node.scene_file_path.is_empty() || !node.has_method("save"):
			print("Error saving node '" + node.name + "'")
			continue
		
		var node_data = node.call("save")
		var json_string = JSON.stringify(node_data)
		
		save_file.store_line(json_string)


func load_game():
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	var load_nodes = get_tree().get_nodes_in_group("Persist")
	var i = 0
	
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		
		var json = JSON.new()
		
		var parse_result = json.parse(json_string)
		if parse_result != OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		
		var node_data = json.get_data()
		
		var node = load_nodes[i]
		if node.scene_file_path.is_empty() || !node.has_method("save"):
			print("Error loading node '" + node.name + "'")
			continue
		
		node.call("load_data", node_data)
		i += 1
