tool
extends "custom_networking.gd"

# Ran By The GUI when running in Editor
# Otherwise ignored (e.g Running GUI as a scene or exported scene)
# Since we're talking to localhost from localhost, we allow object decoding

var tests: Array = []
var threads: int = 1
signal run_completed

func _create_peer() -> void:
	var err: int = _peer.create_server(ProjectSettings.get_setting("WAT/Port"))
	if err != OK:
		push_warning(err as String)
	custom_multiplayer.network_peer = _peer
	custom_multiplayer.connect("network_peer_connected", self, "_on_peer_connected")
	
func _on_peer_connected(id: int) -> void:
	rpc_id(id, "test_strategy_received", tests, threads)

master func _on_run_completed(results: Array) -> void:
	rpc_id(multiplayer.get_rpc_sender_id(), "run_completion_confirmed")
	emit_signal("run_completed", results)
	

