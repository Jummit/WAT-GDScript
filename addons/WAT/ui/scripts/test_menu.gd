extends MenuButton
tool

const USE_LEGIBLE_UNIQUE_NAME: bool = true
enum { RUN_ALL, RUN_DIR, RUN_SCRIPT, RUN_TAG, RUN_METHOD, RUN_FAILURES }
signal _tests_selected
var testdir: Reference = load("res://addons/WAT/editor/test_gatherer.gd").discover()

# WE DO NOT WANT TO AUTO-REFRESH
# WE ONLY REFRESH IF DIRECTORY INFORMATION CHANGES
# IS THERE AN EASY TO DO THIS (EDITORFILESYSTEM MAYBE?)

# TODO
# TagEditor
# JSON Load/Save Meta
# OnSave/Move/Deleted Update

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
		# Add RunAll, DebugAll, RunAllNested, DebugAllNested
		# We also need to add script menus?
		# And Tags and MetaData
		# And JSON LOAD/SAVE (probably bet for different script)
		# We also need a large index so we can remove or delete scripts...
		# ..or just set them as invalid
		# ..but then how do we reorganize the menu?
		var dir_menu: PopupMenu = PopupMenu.new()
		dir_menu.popup_exclusive = not Engine.is_editor_hint()
		dir_menu.name = dir.name
		menu.add_child(dir_menu, USE_LEGIBLE_UNIQUE_NAME)
		menu.add_submenu_item(dir.path, dir.name)
		menu.set_item_icon(idx, Icon.FOLDER)
		
		var test_idx: int = 0
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
						test_menu.add_item(method.replace("_", " ").replace("test ", ""))
						test_menu.set_item_icon(method_idx, Icon.FUNCTION)
						method_idx += 1
						
	for subdir in dir.subdirs:
		idx += int(not subdir.tests.empty())
		_add_menu(subdir, idx)

func _setup_editor_assets(reg) -> void:
	pass

