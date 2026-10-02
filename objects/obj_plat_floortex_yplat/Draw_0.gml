if (live_call()) return live_result;

if (debug_draw) {
	draw_set_colour(c_lime);
	draw_line_width(x, y - (sprite_height * obj_plat_controller.swap_progress) + sprite_height, x, y + sprite_height, 2);
}

draw_set_colour(c_white);