tool
extends Node

const TestRunner: GDScript = preload("res://addons/WAT/core/test_runner/test_runner.gd")
#const TestRunnerScene: PackedScene = preload("res://addons/WAT/core/test_runner/TestRunner.tscn")
var test_runner: TestRunner
#var tests
#var threads = 0

# What happens when we send a decoded object over as a reference? Do we need to duplicate everything?
func _on_RunButton_pressed(test: Reference) -> void:
	#parameters =  Tests, Threads
	print("Running Tests")
	test_runner = TestRunner.new(test.get_tests(), 1)
	test_runner.connect("run_completed", self, "_on_run_completed")
	add_child(test_runner)
	
func _on_DebugButton_pressed(tests) -> void:
	print("Debugging Tests")
	get_parent()._launch_via_editor(tests.get_tests(), 1)
	#func _launch_via_editor(tests: Array, threads: int) -> void:
	
func _on_run_completed(results) -> void:
	get_parent().get_node("Core/Results").display(results)
