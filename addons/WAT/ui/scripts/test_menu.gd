extends MenuButton
tool

const USE_LEGIBLE_UNIQUE_NAME: bool = true
enum { RUN_ALL, RUN_DIR, RUN_SCRIPT, RUN_TAG, RUN_METHOD, RUN_FAILURES }
signal _tests_selected
var testdir: Reference = load("res://addons/WAT/editor/test_gatherer.gd").discover()
signal tests_selected
signal tests_debug_selected

# TODO
# Add Metadata so we can execute test runs
# Track Files so we know where they are using the editor-filesystem..
# ..also see how far back this is supported and if resource-saved will also work?
# Save/Load JSON Metadata and implement Tagged Tests using it
# NOTE: We do not want to auto-refresh tests. We only update on change (this may require a parent dir reference for some issues)

# NOTE
# Rather than check on save/delete, we could connect the popups to a generic 
# about_to_show method, do a quick for loop to check their validity if dirs or test
# ..and if they don't exist, then we remove them! This would save a hell lot of time
# The only real problem here is that we don't account for tests being moved

class Strategy:
	var run_type: int
	var data: Reference
	
	func _init(_run_type: int, _data: Reference) -> void:
		run_type = _run_type
		data = _data
	
enum IndexType {
	RUN,
	DEBUG,
}

class Icon:
	const FOLDER: Texture = preload("res://addons/WAT/assets/folder.png")
	const PLAY: Texture = preload("res://addons/WAT/assets/play.png")
	const DEBUG: Texture = preload("res://addons/WAT/assets/play_debug.png")
	const TAG: Texture = preload("res://addons/WAT/assets/label.png")
	const FAILED: Texture = preload("res://addons/WAT/assets/failed.png")
	const SCRIPT: Texture = preload("res://addons/WAT/assets/script.png")
	const FUNCTION: Texture = preload("res://addons/WAT/assets/function.png")

var menu: PopupMenu = get_popup()

func _ready() -> void:
	menu.clear()
	menu = get_popup()
	menu.popup_exclusive = not Engine.is_editor_hint()
	menu.add_icon_item(Icon.PLAY, "Run All")
	menu.set_item_metadata(0, Strategy.new(IndexType.RUN, testdir))
	menu.add_icon_item(Icon.DEBUG, "Debug All")
	menu.set_item_metadata(1, Strategy.new(IndexType.DEBUG, testdir))
	menu.add_icon_item(Icon.FAILED, "Run Failed")
	menu.add_icon_item(Icon.TAG, "Run Tagged")
	_add_menu(testdir, 3)

func _add_menu(dir: Reference, idx: int) -> void:
	if not dir.tests.empty():
		var dir_menu: PopupMenu = PopupMenu.new()
		dir_menu.popup_exclusive = not Engine.is_editor_hint()
		dir_menu.name = dir.name
		menu.add_child(dir_menu, USE_LEGIBLE_UNIQUE_NAME)
		menu.add_submenu_item(dir.path, dir.name)
		menu.set_item_icon(idx, Icon.FOLDER)
	
		dir_menu.add_icon_item(Icon.PLAY, "Run All")
		dir_menu.set_item_metadata(0, Strategy.new(IndexType.RUN, dir))
		dir_menu.add_icon_item(Icon.DEBUG, "Debug All")
		dir_menu.set_item_metadata(1, Strategy.new(IndexType.DEBUG, dir))
		dir_menu.connect("index_pressed", self, "_on_idx_pressed", [dir_menu])
		
		var test_idx: int = 2
		for test in dir.tests:
			var test_menu: PopupMenu = PopupMenu.new()
			test_menu.name = test.name
			test_menu.popup_exclusive = not Engine.is_editor_hint()
			dir_menu.add_child(test_menu, USE_LEGIBLE_UNIQUE_NAME)
			dir_menu.add_submenu_item(test.name, test.name)
			dir_menu.set_item_icon(test_idx, Icon.SCRIPT)
			
			test_menu.add_icon_item(Icon.PLAY, "Run All")
			test_menu.set_item_metadata(0, Strategy.new(IndexType.RUN, test))
			test_menu.add_icon_item(Icon.DEBUG, "Debug All")
			test_menu.set_item_metadata(0, Strategy.new(IndexType.DEBUG, test))
			test_menu.connect("index_pressed", self, "_on_idx_pressed", [test_menu])
			test_idx += 1
			
			var method_idx: int = 2
			if not test.methods.empty():
				for method in test.methods:
						var method_menu: PopupMenu = PopupMenu.new()
						method_menu.name = method.name
						method_menu.popup_exclusive = not Engine.is_editor_hint()
						test_menu.add_child(method_menu, USE_LEGIBLE_UNIQUE_NAME)
						test_menu.add_submenu_item(method.name, method.name)
						test_menu.set_item_icon(method_idx, Icon.FUNCTION)
						method_menu.add_icon_item(Icon.PLAY, "Run Method")
						method_menu.set_item_metadata(0, Strategy.new(IndexType.RUN, method))
						method_menu.add_icon_item(Icon.DEBUG, "Debug Method")
						method_menu.set_item_metadata(1, Strategy.new(IndexType.DEBUG, method))
						method_menu.connect("index_pressed", self, "_on_idx_pressed", [method_menu])
						method_idx += 1
						
	for subdir in dir.subdirs:
		idx += int(not subdir.tests.empty())
		_add_menu(subdir, idx)
		
func _on_idx_pressed(idx: int, menu: PopupMenu = null) -> void:
	var strategy: Strategy = menu.get_item_metadata(idx)
	match strategy.run_type:
		IndexType.RUN:
			emit_signal("tests_selected", strategy.data)
			print("Run %s" % strategy.data.path)
		IndexType.DEBUG:
			print("Debug %s " % strategy.data.path)
			emit_signal("tests_debug_selected", strategy.data)

func _setup_editor_assets(reg) -> void:
	pass

func _on_resource_saved(res) -> void:
	print(res.resource_path)
