if (live_call()) return live_result;

draw_set_font(font_main);

draw_set_alpha(0.5);
draw_set_colour(c_black);
draw_rectangle(40, 20, 200, 40 + string_width("A") * array_length(variables_to_draw) * 1.5, false);

draw_set_alpha(1);
draw_set_colour(c_white);

for (var i = 0; i < array_length(variables_to_draw); i++) {
	draw_text(50, 20 + string_width("A")*i*1.5, variables_to_draw[i] + ": " + string(variable_instance_get(id, variables_to_draw[i])));
}