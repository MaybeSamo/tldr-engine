event_inherited();

shinealpha = 0;
shinetimer = 0;
depth_override = true;

image_index = 0;

floortex = instance_nearest(x, y, obj_plat_floortex_floor);

interaction_code = function() {
	obj_plat_controller.enter_plat();
}