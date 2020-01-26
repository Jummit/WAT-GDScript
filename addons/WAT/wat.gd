tool
extends PanelContainer

enum RUN { ALL, DIRECTORY, SCRIPT }
enum OPTION { ADD_SCRIPT_TEMPLATE, PRINT_STRAY_NODES }
const FileSystem: Reference = preload("res://addons/WAT/filesystem.gd")
const TestRunner: String = "res://addons/WAT/runner/TestRunner.tscn"
signal test_runner_started
signal results_displayed
onready var GUI: VBoxContainer = $GUI

func _ready() -> void:
	set_process(false)
	GUI.RunOptions.connect("id_pressed", self, "_on_run_pressed")
	GUI.Results.connect("displayed", self, "emit_signal", ["results_displayed"])
	GUI.filesystem = FileSystem
	GUI.MoreOptions.connect("id_pressed", self, "_on_more_options_pressed")
	$GUI/Options/More/Overwrite.connect("confirmed", self, "_save_templates")

func _on_run_pressed(option: int) -> void:
	match option:
		RUN.ALL:
			_run(ProjectSettings.get_setting("WAT/Test_Directory"))
		RUN.DIRECTORY:
			_run(GUI.selected(GUI.DirectorySelector))
		RUN.SCRIPT:
			_run(GUI.selected(GUI.ScriptSelector))

func _run(path: String) -> void:
#	ProjectSettings.set_setting("AutoQuit", true)
	WAT.Settings.enable_autoquit()
	ProjectSettings.set_setting("WAT/ActiveRunPath", path)
	GUI.Results.begin_searching_for_new_results(WAT.Results)
	emit_signal("test_runner_started", TestRunner)

func _on_more_options_pressed(id: int) -> void:
	match id:
		OPTION.ADD_SCRIPT_TEMPLATE:
			add_templates()
		OPTION.PRINT_STRAY_NODES:
			print_stray_nodes()

func add_templates():
	var data = FileSystem.templates()
	if data.exists:
		print("data exists")
		$GUI/Options/More/Overwrite.popup_centered()
	else:
		print("data did not exist")
		_save_templates()
		
func _save_templates() -> void:
	var path = ProjectSettings.get_setting("editor/script_templates_search_path")
	var wat_template = load("res://addons/WAT/script_templates/WATTemplate.gd")
	var savepath: String = "%s/WATTemplate.gd" % path
	ResourceSaver.save(savepath, wat_template)
