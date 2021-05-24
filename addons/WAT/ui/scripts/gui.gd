extends PanelContainer
tool

const Log: Script = preload("res://addons/WAT/log.gd")

# Resources require tool to work inside the editor whereas..
# ..scripts objects without tool can be called from tool based scripts
const TestRunner: Script = preload("res://addons/WAT/core/test_runner/test_runner.gd")
const Server: Script = preload("res://addons/WAT/network/server.gd")
const XML: Script = preload("res://addons/WAT/editor/junit_xml.gd")
const PluginAssetsRegistry: Script = preload("res://addons/WAT/ui/scripts/plugin_assets_registry.gd")
onready var TestMenu: MenuButton = $Core/Menu/TestMenu
onready var Results: TabContainer = $Core/Results
onready var Summary: HBoxContainer = $Core/Summary
onready var Core: VBoxContainer = $Core
onready var Launcher: Node = $Launcher
var instance: TestRunner
var server: Server
signal launched_via_editor
signal function_selected

func _ready() -> void:
#	$Core/Menu/QuickRunAll.connect("pressed", Launcher, "_on_RunButton_pressed")
#	$Core/Menu/QuickRunAllDebug.connect("pressed", Launcher, "_on_DebugButton_pressed")
	
	$Core/Menu/TestMenu.connect("tests_selected", Launcher, "_on_RunButton_pressed")
	$Core/Menu/TestMenu.connect("tests_debug_selected", Launcher, "_on_DebugButton_pressed")
	
	
#	if not Engine.is_editor_hint():
#		_set_window_size()
#		# No argument makes the AssetsRegistry default to a scale of 1, which
#		# should make every icon look normal when the Tests UI launches
#		# outside of the editor.
#		_setup_editor_assets(PluginAssetsRegistry.new())
#	$Core.connect("test_strategy_set", self, "_on_test_strategy_set")
	Results.connect("function_selected", self, "_on_function_selected")
	
func _on_function_selected(path: String, function: String) -> void:
	emit_signal("function_selected", path, function)

func _on_test_strategy_set(tests, threads, run_in_editor) -> void:
	if tests.empty():
		push_warning("Tests Are Empty!")
		return
	Results.clear()
	Summary.time()
	if run_in_editor:
		_launch_in_editor(tests, threads)
	else:
		_launch_via_editor(tests, threads)
	
func _launch_in_editor(tests: Array, threads: int) -> void:
	# This is also the launch method used for exported scenes
	instance = TestRunner.new(tests, threads)
	instance.connect("run_completed", self, "_on_run_completed")
	add_child(instance)
	
func _launch_via_editor(tests: Array, threads: int) -> void:
	if not is_instance_valid(server):
		server = Server.new()
		server.connect("run_completed", self, "_on_run_completed")
		add_child(server)
	server.tests = tests
	server.threads = threads
	emit_signal("launched_via_editor")
	
func _on_run_completed(results: Array = []) -> void:
	if is_instance_valid(instance):
		instance.queue_free()
	Summary.summarize(results)
	#TestMenu.set_last_run_success(results)
	XML.write(results)
	Results.display(results)


func _exit_tree() -> void:
	if is_instance_valid(server):
		server.close()
		server.free()

func _set_window_size() -> void:
	OS.window_size = ProjectSettings.get_setting("WAT/Window_Size")

# Loads scaled assets like icons and fonts
func _setup_editor_assets(assets_registry):
	Core._setup_editor_assets(assets_registry)
