if (live_call()) return live_result;

event_inherited();

if (instance_exists(floortex) && instance_exists(floortex.yplat_indicator)) {
	var _offset_factor = (sprite_get_height(floortex.sprite_index)/2) - sprite_get_height(floortex.sprite_index)*0.1;
	y = ystart - ((floortex.yplat_indicator.sprite_height + _offset_factor - floortex.yplat_dist_from_center) * obj_plat_controller.swap_progress);
}

draw_sprite_ext(sprite_index, 0, x + _origin_x, y + _origin_y, image_xscale, image_yscale, 0, c_white, 1);