extends Node

const IPAddress: String = "127.0.0.1"
var _peer: NetworkedMultiplayerENet

func _init() -> void:
	_close()
	custom_multiplayer = MultiplayerAPI.new()
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.allow_object_decoding = true
	_peer = NetworkedMultiplayerENet.new()
	_create_peer()
	custom_multiplayer.network_peer = _peer

func _process(delta: float) -> void:
	if custom_multiplayer.has_network_peer():
		custom_multiplayer.poll()

func _close() -> void:
	if is_instance_valid(_peer):
		_peer.close_connection()
		_peer = null

func _port() -> int:
	return ProjectSettings.get_setting("WAT/Port")

func _create_peer() -> void:
	pass
	
func _exit_tree() -> void:
	_close()
