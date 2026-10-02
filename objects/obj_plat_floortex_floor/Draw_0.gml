if (live_call()) return live_result;

var _pc = obj_plat_controller;

//Set the size to 1/10 of itself based off of the perspective shift progress
image_yscale = lerp(1, 0.1, _pc.swap_progress);

//Calculate the y position offset based off of the y plat indicator object
if (instance_exists(yplat_indicator)) {
	_true_yplat_y = yplat_indicator.y;
	
	if (sign(yplat_indicator.image_yscale) == -1) {
		_true_yplat_y += 20 * yplat_indicator.image_yscale;
	}
	yplat_dist_from_center = (_true_yplat_y - (ystart + sprite_get_height(sprite_index) / 2));
	y = ystart + (-yplat_indicator.sprite_height + og_image_yscale + yplat_dist_from_center) * _pc.swap_progress;
}
else {
	//If there is no yplat_indicator, search for one
	yplat_indicator = collision_rectangle(x, y, x + sprite_width, y + sprite_height, obj_plat_floortex_yplat, false, true);
	if (yplat_indicator != noone) {
		debug_print_obj("Found a yplat indicator.");
	} else {
		debug_print_obj("Failed to find a yplat indicator.")
	}
}

draw_sprite_ext(sprite_index, 0, x + _origin_x, y + _origin_y, image_xscale, image_yscale, 0, c_white, 1);

if (debug_draw) {
	draw_set_colour(c_red);
	draw_rectangle(xstart, ystart, xstart + sprite_get_width(sprite_index) - 1, ystart + sprite_get_height(sprite_index) - 1, true);
	
	if (instance_exists(yplat_indicator)) {
        draw_set_colour(c_orange);
        
		var _top = ystart + -yplat_indicator.sprite_height + _origin_y + yplat_dist_from_center;
		
        draw_rectangle(xstart, _top, xstart + sprite_get_width(sprite_index) - 1, _top + sprite_get_height(sprite_index) * 0.1 - 1, true);
    }
	
	draw_set_colour(c_white);
}