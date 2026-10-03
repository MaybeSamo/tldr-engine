if (live_call()) return live_result;

image_index = lerp(0, image_number - 1, obj_plat_controller.swap_progress);
shinealpha = lerp(0, 0.75, obj_plat_controller.swap_progress);

y = ystart + ((floortex._origin_y - floortex.yplat_indicator.sprite_height + floortex.yplat_dist_from_center) * obj_plat_controller.swap_progress);