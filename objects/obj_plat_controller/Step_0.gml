if (live_call()) return live_result;

if (keyboard_check_pressed(ord("P"))) {
	if (!global.plat_mode)
		enter_plat();
	else
		exit_plat();
}

if (keyboard_check_pressed(ord("D"))) {
	with (obj_plat_floortex_floor)
		debug_draw = !debug_draw;
		
	with (obj_plat_floortex_yplat)
		debug_draw = !debug_draw;
}