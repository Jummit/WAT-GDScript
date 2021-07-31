extends Reference
class_name WAT

enum { RUN, DEBUG, NONE }
const COMPLETED: String = "completed"
const Test: Script = preload("test/test.gd")
const TestRunnerScene: PackedScene = preload("runner/TestRunner.tscn")
#const Settings: Script = preload("settings.gd")

	
static func test_runner() -> _watTestRunner:
	return TestRunnerScene.instance() as _watTestRunner
