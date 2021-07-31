tool
extends Button


var FOLDER = preload("../assets/folder.png")
var FAILED = preload("../assets/failed.png")
var SCRIPT = preload("../assets/script.png")
var PLAY = preload("../assets/play.png")
var DEBUG = preload("../assets/play_debug.png")
var TAG = preload("../assets/label.png")
var FUNCTION = preload("../assets/function.png")

const Settings: GDScript = preload("../settings.gd")
var filesystem: Reference # Set by GUI
var _menu: PopupMenu = PopupMenu.new()
var _id: int = 0
signal tests_selected


func _pressed() -> void:
	if filesystem.has_been_changed:
		update()
		filesystem.has_been_changed = false
	var position: Vector2 = rect_global_position
	position.y += rect_size.y
	_menu.rect_global_position = position
	_menu.rect_size = Vector2(rect_size.x, 0)
	_menu.grab_focus()
	_menu.popup()
	
func update() -> void:
	# We still require tags as well
	filesystem.update()
	_menu.free()
	_menu = PopupMenu.new()
	add_child(_menu)
	
	# Tags could honestly exist as their own menu
	var _tag_menu = PopupMenu.new()
	_menu.add_child(_tag_menu)
	_menu.add_submenu_item("Run Tagged", _tag_menu.name, 0)
	_menu.set_item_icon(0, TAG)
	for tag in Settings.tags():
		add_menu(_tag_menu, filesystem.indexed[tag], TAG)

	_menu.connect("index_pressed", self, "_on_idx_pressed", [_menu])
	_id = 1
	for dir in filesystem.dirs:
		if dir.tests.empty():
			continue
		var dir_menu: PopupMenu = add_menu(_menu, dir, FOLDER)
		
		for test in dir.tests:
			var test_menu = add_menu(dir_menu, test, SCRIPT)
			_add_tag_editor(test_menu, test)
			
			for method in test.methods:
				add_menu(test_menu, method, FUNCTION)

func add_menu(parent: PopupMenu, data: Reference, ico: Texture) -> PopupMenu:
	var child: PopupMenu = PopupMenu.new()
	child.connect("index_pressed", self, "_on_idx_pressed", [child])
	parent.add_child(child)
	child.name = child.get_index() as String
	parent.add_submenu_item(data.name, child.name, _id)
	parent.set_item_icon(parent.get_item_index(_id), ico)
	_id += 1
	child.add_icon_item(PLAY, "Run All", _id)
	child.set_item_metadata(0, _watTestParcel.new(WAT.RUN, data))
	_id += 1
	child.add_icon_item(DEBUG, "Debug All", _id)
	child.set_item_metadata(1, _watTestParcel.new(WAT.DEBUG, data))
	_id += 1
	return child

func _add_tag_editor(script_menu: PopupMenu, test) -> void:
	var _tag_editor: PopupMenu = PopupMenu.new()
	var idx = 0
	for tag in Settings.tags():
		_tag_editor.add_check_item(tag)
		if tag in test.tags:
			_tag_editor.set_item_checked(0, true)
		idx += 1
	script_menu.add_child(_tag_editor)
	script_menu.add_submenu_item("Edit Tags", _tag_editor.name)
	script_menu.set_item_icon(2, TAG)
	_tag_editor.connect("index_pressed", self, "_on_tagged", [_tag_editor, test])
	
func _on_tagged(idx: int, tag_editor: PopupMenu, test: Reference) -> void:
	var tag: String = tag_editor.get_item_text(idx)
	var is_already_selected: bool = tag_editor.is_item_checked(idx)
	if is_already_selected:
		tag_editor.set_item_checked(idx, false)
		test.tags.erase(tag)
		filesystem.remove_test_from_tag(test, tag)
		push_warning("Removing Tag %s From %s" % [tag, test.gdscript])
	else:
		tag_editor.set_item_checked(idx, true)
		test.tags.append(tag)
		filesystem.add_test_to_tag(test, tag)
		push_warning("Adding Tag %s To %s" % [tag, test.gdscript])

func _on_idx_pressed(idx: int, menu: PopupMenu) -> void:
	emit_signal("tests_selected", menu.get_item_metadata(idx))
