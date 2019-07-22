extends PanelContainer
tool

# Using seperate non-tool script so we can avoid a resource race vs reimports
const COLOR_SUCCESS: Color = Color(0, 1, 0, 1)
const COLOR_FAILED: Color = Color(1, 1, 1, 1)
const COLOR_CRASHED: Color = Color(1, 1, 0, 1)

func success() -> Resource:
	return load("res://addons/WAT/UI/icons/success.png")

func failed() -> Resource:
	return load("res://addons/WAT/UI/icons/failed.png")

func crash_icon() -> Resource:
	return load("res://addons/WAT/UI/icons/crash_warning.png")

var cache: Array = []
var success: bool = false
var crashed: bool = false
var passed: int = 0
var total: int = 0
var icon: Texture

func display(cases: Array) -> void:
	var tree: Tree = $Display
	var root: TreeItem = tree.create_item()
	total = cases.size()

	for c in cases:
		passed += int(c.success)
		var case: TreeItem = tree.create_item(root)
		_add_script_data(case, c)

		for m in c.methods:
			var method: TreeItem = tree.create_item(case)
			_add_method_data(method, m)

			for expectation in m.expectations:
				var e: TreeItem = tree.create_item(method)
				var expect: TreeItem = tree.create_item(e)
				var result: TreeItem = tree.create_item(e)
				_add_expectation_data(e, expect, result, expectation)


	success = total > 0 and total == passed
	icon = success() if success else failed()
	root.set_text(0, "%s/%s" % [passed, total])
	root.set_icon(0, icon)
	root.set_custom_color(0, COLOR_SUCCESS if success else COLOR_FAILED)

func _add_script_data(script: TreeItem, data) -> void:
	script.set_text(0, "(%s/%s) %s" % [data.passed, data.total, data.title])
	script.set_tooltip(0, data.path)
	script.set_icon(0, success() if data.success else failed())
	script.set_custom_color(0, COLOR_SUCCESS if data.success else COLOR_FAILED)
	cache.append(script)

func _add_method_data(method: TreeItem, data: Dictionary) -> void:
<<<<<<< HEAD
	method.set_text(0, "%s" % data.context)
	method.set_icon(0, ICON_SUCCESS if data.success else ICON_FAILED)
=======
	method.collapsed = true
	method.set_text(0, "(%s/%s) %s" % [data.passed, data.total, data.context])
	method.set_icon(0, success() if data.success else failed())
>>>>>>> master
	method.set_custom_color(0, COLOR_SUCCESS if data.success else COLOR_FAILED)
	method.set_tooltip(0, "Source: %s" % data.title)

func _add_expectation_data(expectation: TreeItem, expect: TreeItem, result: TreeItem, data) -> void:
	expectation.collapsed = true
	expectation.set_text(0, data.context)
	expectation.set_icon(0, success() if data.success else failed())
	expectation.set_custom_color(0, COLOR_SUCCESS if data.success else COLOR_FAILED)
	expect.set_text(0, "Expect: %s" % data.expected)
	result.set_text(0, "Result: %s" % data.result)

func crash(data) -> void:
	print("Crash Not Implemented")
	print("Crash Data Should Not Reach Results?")

func collapse_all(collapse):
	for item in cache:
		item.collapsed = collapse
