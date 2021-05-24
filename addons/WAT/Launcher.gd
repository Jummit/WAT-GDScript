tool
extends Node

const Server: GDScript = preload("res://addons/WAT/network/server.gd")
const TestRunner: GDScript = preload("res://addons/WAT/core/test_runner/test_runner.gd")
#const TestRunnerScene: PackedScene = preload("res://addons/WAT/core/test_runner/TestRunner.tscn")
var test_runner: TestRunner
var server: Server
signal debug_tests
signal launched_via_editor
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
	if not is_instance_valid(server):
		server = Server.new()
		server.connect("run_completed", self, "_on_run_completed")
		add_child(server)
	server.tests = tests.get_tests()
	server.threads = 1
	emit_signal("launched_via_editor")
	print("Debugging Tests")
	
func _on_run_completed(results) -> void:
	get_parent().get_node("Core/Results").display(results)
