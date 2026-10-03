if (live_call()) return live_result;

var _rpressed = InputCheck(INPUT_VERB.RIGHT);
var _lpressed = InputCheck(INPUT_VERB.LEFT);
var _jpressed = InputCheck(INPUT_VERB.CANCEL);
var _dir = _rpressed - _lpressed;

if (grounded && !turn_anim && !runstop_anim && _dir != 0 && sign(hspeed) == -_dir && abs(hspeed) > max_hspeed * 0.8) {
    turn_anim = true;
    sprite_index = spr_kris_plat_turn;
    image_index = 0;
    image_speed = 0.25;
}

hspeed += _dir * h_accel;
hspeed = clamp(hspeed, -max_hspeed, max_hspeed);

if (_dir == 0) {
    hspeed *= h_decel;
    if (abs(hspeed) < 0.1) hspeed = 0;
}

if (turn_anim) {
    sprite_index = spr_kris_plat_turn;
    if (!grounded || _dir == 0 || image_index + image_speed >= image_number) {
        turn_anim = false;
        sprite_index = spr_kris_plat_run;
        image_index = 0;
        if (sign(hspeed) == -_dir) hspeed = 0;
    }
}

if (_dir != 0 && !turn_anim) {
    image_xscale = _dir;
    runstop_anim = false;
}

if (grounded && !turn_anim && !runstop_anim) {
    if (_dir != 0) {
        sprite_index = spr_kris_plat_run;
        image_speed = 0.15 + (0.25 * abs(hspeed) / max_hspeed);
    } else if (hspeed == 0) {
        sprite_index = spr_kris_plat_idle;
    }
}

if (_dir == 0 && !runstop_anim && !turn_anim && sprite_index == spr_kris_plat_run && hspeed != 0) {
    runstop_anim = true;
    sprite_index = spr_kris_plat_runstop;
    image_index = 0;
    image_speed = 0.25;
}

if (runstop_anim) {
    sprite_index = spr_kris_plat_runstop;
    if (image_index + image_speed >= image_number) {
        runstop_anim = false;
        sprite_index = spr_kris_plat_idle;
    }
}

var _no_input = (!_lpressed && !_rpressed) || (_rpressed && _lpressed);
if (_no_input && !runstop_anim && !turn_anim && sprite_index == spr_kris_plat_run && sprite_index != spr_kris_plat_idle && hspeed != 0) {
    runstop_anim = true;
    debug_print_obj("start run stop anim");
    sprite_index = spr_kris_plat_runstop;
    image_index = 0;
    image_speed = 0.25;
}

if (runstop_anim) {
    sprite_index = spr_kris_plat_runstop;
    
    if (image_index >= image_number - 1) {
        runstop_anim = false;
        sprite_index = spr_kris_plat_idle;
    }
}

grounded = place_meeting(x, y + 1, obj_plat_block);

if (grounded) {
	jumping = false;
	jumptime = 0;
} else {
	gravity = grav;
}

if (_jpressed && grounded && jumpsquat < jumpsquat_max) {
	jumpsquat++;
} else {
	jumpsquat = 0;
}

if (jumpsquat >= 2) {
	mask_index = spr_kris_plat_idle;
	sprite_index = spr_kris_plat_land;
}

if (jumpsquat == 4 && grounded && !jumping) {
	sprite_index = spr_kris_jump_up;
	audio_play(snd_spearrise);
	vspeed = -jumpheight;
	gravity = grav;
	grounded = false;
	jumping = true;
	jumpsquat = 0;
}

if (jumping) {
	jumptime++;
	
	image_speed = 0.25;
	
	if (sign(vspeed) == -1)
		sprite_index = spr_kris_jump_up;
	else
		sprite_index = spr_kris_jump_down;
}
	
var _release_jump = false;

if (!_jpressed && jumping && jumptime >= jump_mintime)
	_release_jump = true;
	
if (vspeed < 0 && _release_jump) {
	vspeed *= 0.25;
}

var _vs = vspeed + gravity;

if (_vs != 0 && place_meeting(x, y + _vs, obj_plat_block)) {
    while (!place_meeting(x, y + sign(_vs), obj_plat_block)) {
        y += sign(_vs);
    }
    vspeed = 0;
    gravity = 0;
}

if (place_meeting(x + hspeed, y, obj_plat_block)) {
    while (!place_meeting(x + sign(hspeed), y, obj_plat_block)) {
		x += sign(hspeed);
    }
	
	hspeed = 0;
}

if (keyboard_check_pressed(ord("R")))
	room_restart();