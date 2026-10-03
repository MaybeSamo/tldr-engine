shinetimer++;

shinealpha = clamp(shinealpha, 0, 1);


var xscale = (1.35 + (0.15 * sin(shinetimer * 0.03))) / 2;
var yscale = (1.35 + (0.15 * cos(shinetimer * 0.015))) / 2;

draw_sprite_ext(spr_platswap_statue_light, 0, x, y, xscale, yscale, 0, c_lime, shinealpha * (0.5 + (0.15 * sin(shinetimer * 0.02))));
draw_sprite_ext(spr_platswap_statue_top_new, image_index, x, y, image_xscale, 1, 0, image_blend, 1);