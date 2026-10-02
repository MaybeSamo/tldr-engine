if (live_call()) return live_result;

image_speed = 0.25;

max_hspeed = 4.5;
h_accel = 1;
h_decel = 0.325;

jumpsquat = 0;
jumpsquat_max = 4;
jumpheight = 10;
jumping = false;
jumptime = 0;
jump_mintime = 4;

grav = 0.625;

gravity = grav;

grounded = false;