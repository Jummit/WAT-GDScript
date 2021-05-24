extends "custom_networking.gd"

const IPAddress: String = "127.0.0.1"
signal test_strategy

func _ready() -> void:
	join()
	
func join() -> void:
	_peer = NetworkedMultiplayerENet.new()
	var err: int = _peer.create_client("127.0.0.1", ProjectSettings.get_setting("WAT/Port"))
	if err != OK:
		push_warning(err as String)
	custom_multiplayer.connect("connection_failed", self, "_on_connection_failed")
	custom_multiplayer.network_peer = _peer
	
puppet func test_strategy_received(tests: Array, threads: int) -> void:
	emit_signal("test_strategy", tests, threads)
	
puppet func run_completion_confirmed() -> void:
	get_tree().quit()
	
func _on_failed() -> void:
	push_error("Connection failed")

func _on_run_completed(results: Array) -> void:
	rpc_id(1, "_on_run_completed", results)


