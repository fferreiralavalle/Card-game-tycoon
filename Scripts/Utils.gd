
class_name Utils

static func get_objects_by_class(objects: Array, target_class: String) -> Array:
	var filtered_objects = []
	for obj in objects:
		if obj is Script and obj.get_script().resource_path == target_class:
			filtered_objects.append(obj)
		elif obj is Object and obj.has_method("get_class"):  # If it's a Godot built-in class
			if obj.get_class() == target_class:
				filtered_objects.append(obj)
	return filtered_objects

 
