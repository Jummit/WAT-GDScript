extends MenuButton
tool

enum { RUN_ALL, RUN_DIR, RUN_SCRIPT, RUN_TAG, RUN_METHOD, RUN_FAILURES }
signal _tests_selected
var testdir: Reference = load("res://addons/WAT/editor/test_gatherer.gd").discover()

# WE DO NOT WANT TO AUTO-REFRESH
# WE ONLY REFRESH IF DIRECTORY INFORMATION CHANGES
# IS THERE AN EASY TO DO THIS (EDITORFILESYSTEM MAYBE?)

var menu: PopupMenu = get_popup()

func _ready() -> void:
	menu.clear()
	menu = get_popup()
	menu.popup_exclusive = not Engine.is_editor_hint()
	_add_menu(testdir)

func _add_menu(dir: Reference) -> void:
	if not dir.tests.empty():
		# Add RunAll, DebugAll, RunAllNested, DebugAllNested
		# We also need to add script menus?
		# And Tags and MetaData
		# And JSON LOAD/SAVE (probably bet for different script)
		var dir_menu: PopupMenu = PopupMenu.new()
		dir_menu.popup_exclusive = not Engine.is_editor_hint()
		dir_menu.name = dir.name
		menu.add_child(dir_menu, true)
		menu.add_submenu_item(dir.path, dir.name)
		for test in dir.tests:
			dir_menu.add_item(test.name)
	for subdir in dir.subdirs:
		_add_menu(subdir)

func _setup_editor_assets(reg) -> void:
	pass

