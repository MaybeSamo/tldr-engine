_origin_x = sprite_width/2;
_origin_y = sprite_height/2;

generate_tile_sprite = function() {
	draw_set_colour(c_white);
    var _cell_x = floor(xstart / 20);
    var _cell_y = floor(ystart / 20);
	
	if (layer_exists(tile_layer)) {
	
	    var _tilemap = layer_tilemap_get_id(tile_layer);
	    var _tileset = tilemap_get_tileset(_tilemap);
		
		var _tempsurf = surface_create(sprite_width, sprite_height);
		
		surface_set_target(_tempsurf);
		draw_clear_alpha(0, 0);
		
	    for (var i = 0; i < image_xscale; i++) {
	        for (var j = 0; j < image_yscale; j++) {
	            var _tile_data = tilemap_get(_tilemap, _cell_x + i, _cell_y + j);
	            draw_tile(_tileset, _tile_data, 0, (i) * 20, (j) * 20);
				if (remove_original_tile)
					tilemap_set(_tilemap, 0, _cell_x + i, _cell_y + j);
	        }
	    }
		
		surface_reset_target();
		
		sprite_index = sprite_create_from_surface(_tempsurf, 0, 0, sprite_width, sprite_height, false, false, _origin_x, _origin_y);
		
		surface_free(_tempsurf);
		
		image_xscale = 1;
		image_yscale = 1;
	} else {
		show_debug_message($"[{object_get_name(object_index)}]: {tile_layer} is not a valid tile layer.");
	}
}

generate_tile_sprite();


if (layer_make_invisible)
	layer_set_visible(tile_layer, false);
	
if (match_layer_depth)
	depth = layer_get_depth(layer_get_id(tile_layer));