if (live_call()) return live_result;

if (keyboard_check_pressed(ord("P"))) {
	if (!global.plat_mode)
		enter_plat();
	else
		exit_plat();
}