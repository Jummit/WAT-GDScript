extends MenuButton
tool

const USE_LEGIBLE_UNIQUE_NAME: bool = true
enum { RUN_ALL, RUN_DIR, RUN_SCRIPT, RUN_TAG, RUN_METHOD, RUN_FAILURES }
signal _tests_selected
var testdir: Reference = load("res://addons/WAT/editor/test_gatherer.gd").discover()

# TODO
# Add Metadata so we can execute test runs
# Track Files so we know where they are using the editor-filesystem..
# ..also see how far back this is supported and if resource-saved will also work?
# Save/Load JSON Metadata and implement Tagged Tests using it
# NOTE: We do not want to auto-refresh tests. We only update on change (this may require a parent dir reference for some issues)

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
	menu.add_icon_item(Icon.DEBUG, "Debug All")
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
		dir_menu.add_icon_item(Icon.DEBUG, "Debug All")
		
		var test_idx: int = 2
		for test in dir.tests:
			var test_menu: PopupMenu = PopupMenu.new()
			test_menu.name = test.name
			test_menu.popup_exclusive = not Engine.is_editor_hint()
			dir_menu.add_child(test_menu, USE_LEGIBLE_UNIQUE_NAME)
			dir_menu.add_submenu_item(test.name, test.name)
			dir_menu.set_item_icon(test_idx, Icon.SCRIPT)
			test_idx += 1
			
			var method_idx: int = 0
			if not test.methods.empty():
				for method in test.methods:
						var method_menu: PopupMenu = PopupMenu.new()
						method_menu.name = method.replace("_", " ").replace("test ", "")
						method_menu.popup_exclusive = not Engine.is_editor_hint()
						test_menu.add_child(method_menu, USE_LEGIBLE_UNIQUE_NAME)
						test_menu.add_submenu_item(method_menu.name, method_menu.name)
						test_menu.set_item_icon(method_idx, Icon.FUNCTION)
						method_menu.add_icon_item(Icon.PLAY, "Run Method")
						method_menu.add_icon_item(Icon.DEBUG, "Debug Method")
						method_idx += 1
						
	for subdir in dir.subdirs:
		idx += int(not subdir.tests.empty())
		_add_menu(subdir, idx)

func _setup_editor_assets(reg) -> void:
	pass

