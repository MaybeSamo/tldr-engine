if (live_call()) return live_result;

global.plat_mode = false;

swapped = false;

swap_progress = 0;
transition_duration = 20;

enter_plat = function() {
	var _kr = party_get_inst("kris");
	if (_kr) {
		_kr.visible = false;
		_kr.is_player = false;
		instance_create(obj_plat_player, _kr.x, _kr.y - 20);
	}
	
	global.plat_mode = true;
	audio_play(snd_platswap_1);
	
	o_camera.target = obj_plat_player;
	
	tween(id, "swap_progress", 0, 1, transition_duration, EaseType.EaseInOutSine);
}

exit_plat = function() {
	global.plat_mode = false;
	audio_play(snd_platswap_2);
	
	tween(id, "swap_progress", 1, 0, transition_duration, EaseType.EaseInOutSine);
}