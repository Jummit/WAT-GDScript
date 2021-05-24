extends Node

var _peer: NetworkedMultiplayerENet

func _init() -> void:
	custom_multiplayer = MultiplayerAPI.new()
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.allow_object_decoding = true

func _process(delta: float) -> void:
	if custom_multiplayer.has_network_peer():
		custom_multiplayer.poll()

func close() -> void:
	if is_instance_valid(_peer):
		_peer.close_connection()
		_peer = null
