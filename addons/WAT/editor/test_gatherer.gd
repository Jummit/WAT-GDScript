extends Reference

const DO_NOT_SEARCH_PARENT_DIRECTORIES: bool = true


class TestDirectory extends Reference:
	var path: String
	var subdirs: Array = []
	var all_subdirs: Array = []
	var tests: Array = [] # Tests that within the directory
	var all_tests: Array = [] # Tests that are within all subdirs
	var subdir_count: int setget ,_get_subdir_count
	var test_count: int setget ,_get_test_count
	var name: String setget ,_get_dir_name
	var _dir: Directory
	
	func _init(_path: String) -> void:
		path = _path
	
	func _get_subdir_count() -> int:
		return subdirs.size()
		
	func _get_test_count() -> int:
		return tests.size()
		
	func _get_dir_name() -> String:
		return path.replace("res://", "").capitalize().replace("/", "|")
		
	func open() -> void:
		_dir = Directory.new()
		var err: int = _dir.open(path)
		if err != OK:
			push_warning("Cannot open %s due to error %s" % [path, err])
	
	func populate() -> void:
		_dir.list_dir_begin(DO_NOT_SEARCH_PARENT_DIRECTORIES)
		var name: String = _dir.get_next()
		while name != BLANK:
			if _is_valid_test(name):
				tests.append(TestScript.new("%s/%s" % [path, name], load("%s/%s" % [path, name])))
			elif _dir.dir_exists(name):
				subdirs.append(TestDirectory.new("%s/%s" % [path, name]))
			name = _dir.get_next()
		_dir.list_dir_end()
		
		all_tests = tests
		all_subdirs = subdirs
		for subdir in subdirs:
			subdir.open()
			subdir.populate()
			all_tests += subdir.all_tests
			all_subdirs += subdir.all_subdirs
		
	func _add_test(name: String) -> void:
		var fullpath: String = "%/%" % [path, name]
		var script: GDScript = load(fullpath)
		tests.append(TestScript.new(fullpath, script))
		
	func _add_subdir(name: String) -> void:
		var fullpath: String = "%s/%s" % [path, name]
		subdirs.append(TestDirectory.new(fullpath))
		
	func _is_valid_test(name: String) -> bool:
		var fullpath: String = "%s/%s" % [path, name]
		return fullpath.ends_with(".gd") and fullpath != "res:///addons/WAT/core/test/test.gd" and load(fullpath).get("TEST")
		
	func get_tests() -> Array:
		var scripts: Array = []
		for test in all_tests:
			scripts.append(test.to_dictionary())
		return scripts
		
class TestScript extends Reference:
	var path: String
	var gdscript: GDScript
	var tags: Array = [] # TODO
	var passing: bool = false # TODO
	var name: String setget, _get_name
	var methods: Array = []
	
	func _init(_path: String, _gdscript: GDScript) -> void:
		path = _path
		gdscript = _gdscript
		set_test_methods()
		
	func _get_name() -> String:
		return path.substr(path.find_last("/") + 1).replace(".", " ").replace("gd", "").replace("test", "")
		
	func set_test_methods() -> void:
		methods = []
		for method in gdscript.get_script_method_list():
			if method.name.begins_with("test"):
				methods.append(method.name)
				
	func get_tests() -> Array:
		return [to_dictionary()]
		
	func to_dictionary() -> Dictionary:
		return {
			gdscript = gdscript,
			methods = methods,
			path = path
		}
	
#func _initialize() -> void:
#	primary = TestDirectory.new("res://tests")
#	primary.populate()
	
static func discover() -> TestDirectory:
	var primary: TestDirectory = TestDirectory.new("res://tests")
	primary.open()
	primary.populate()
	return primary

const BLANK: String = ""
const Settings: Script = preload("res://addons/WAT/settings.gd")
var tests: Dictionary

#func discover() -> Dictionary:
#	tests.clear()
#	tests = {dirs = [], scripts = {}, all = []}
#	_discover()
#	#var metadata = _get_metadata()
##	for path in tests.scripts:
##		if(metadata.has(path)):
##			tests.scripts[path]["tags"] = metadata[path]["tags"]
##			if(metadata[path].has("passing")):
##				tests.scripts[path]["passing"] = metadata[path]["passing"]
#	return tests

func _discover(path: String = Settings.test_directory()) -> Array:
	tests.dirs.append(path)
	var scripts: Array = []
	var subdirs: Array = []
	var dir: Directory = Directory.new()
	var err: int = dir.open(path)
	if err != OK:
		push_error("%s : %s " % [path, err as String])
		return []
	dir.list_dir_begin(true)
	var current_name = dir.get_next()
	
	while current_name != BLANK:
		var title: String = path + "/" + current_name
		#																	The third slash is for the leading dir
		if (title.ends_with(".gd") or title.ends_with(".gdc")) and load(title).get("TEST") and title != "res:///addons/WAT/core/test/test.gd" and title != "res:///addons/WAT/core/test/test.gdc":
			var script = load(title)
			var test = {"script": script, "path": title, "tags": [], "passing": false}
			scripts.append(test)
			tests.scripts[title] = test
		elif dir.dir_exists(current_name):
			subdirs.append(title)
#			tests.dirs.append(title)
		current_name = dir.get_next()
	dir.list_dir_end()
	
	for subdir in subdirs:
		# Parent Dirs subsume child dirs
		_discover(subdir)
	tests[path] = scripts
	tests.all += scripts
	return scripts
	
#func _get_metadata() -> Dictionary:
#	var path: String = ProjectSettings.get_setting("WAT/Test_Metadata_Directory")
#	var file: File = File.new()
#	var err: int = file.open(path + "/test_metadata.json", File.READ)
#	if err != OK:
#		push_warning(err as String)
#		return {}
#	var metadata: Dictionary = JSON.parse(file.get_as_text()).result
#	file.close()
#	return metadata
#
#func save(data: Dictionary) -> void:
#	var path: String = ProjectSettings.get_setting("WAT/Test_Metadata_Directory")
#	var file: File = File.new()
#	var err: int = file.open(path + "/test_metadata.json", File.WRITE)
#	if err != OK:
#		push_warning(err as String)
#	for test in data.scripts:
#		var value = data.scripts[test]
#		value.erase("script")
#	var val: String = JSON.print(data.scripts, "\t")
#	file.store_string(val)
#	file.close()
