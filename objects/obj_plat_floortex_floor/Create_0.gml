og_image_xscale = image_xscale;
og_image_yscale = image_yscale;

event_inherited();

yplat_indicator = collision_rectangle(x, y + sprite_height/2, x + sprite_width, (y + sprite_height/2) + sprite_height/2, obj_plat_floortex_yplat, false, true);
yplat_dist_from_center = 0;
debug_draw = false;

if (!yplat_indicator) {
	debug_print_obj("No yplat indicator.");
}