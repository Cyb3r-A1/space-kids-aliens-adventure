extends Node

func _ready():
	if "--server" in OS.get_cmdline_args():
		start_server()
	else:
		connect_to_server()

func start_server():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(4242)
	multiplayer.multiplayer_peer = peer
	print("🚀 Server running on port 4242")

func connect_to_server():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client("127.0.0.1", 4242)
	multiplayer.multiplayer_peer = peer
	print("🔌 Connected to server")
