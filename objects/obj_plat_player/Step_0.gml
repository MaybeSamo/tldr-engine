if (live_call()) return live_result;

var _rpressed = InputCheck(INPUT_VERB.RIGHT);
var _lpressed = InputCheck(INPUT_VERB.LEFT);
var _jpressed = InputCheck(INPUT_VERB.CANCEL);
var _atkhled = InputCheck(INPUT_VERB.SELECT);
var _atkpressed = InputPressed(INPUT_VERB.SELECT);
var _dir = _rpressed - _lpressed;

was_jumping = jumping;

if (grounded && !turn_anim && !runstop_anim && _dir != 0 && sign(hspeed) == -_dir && abs(hspeed) > max_hspeed * 0.8) {
    turn_anim = true;
    sprite_index = spr_kris_plat_turn;
    image_index = 0;
    image_speed = 0.25;
}

if (!attacking)
	hspeed += _dir * h_accel;
hspeed = clamp(hspeed, -max_hspeed, max_hspeed);

if (_dir == 0 || attacking) {
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

if (grounded && !turn_anim && !runstop_anim && !attacking) {
    if (_dir != 0) {
        sprite_index = spr_kris_plat_run;
        image_speed = 0.15 + (0.25 * abs(hspeed) / max_hspeed);
    } else if (hspeed == 0) {
		image_speed = 0.25;
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
	audio_play(snd_ui_cancel, 0, 1, 1.5);
	vspeed = -jumpheight;
	gravity = grav;
	grounded = false;
	jumping = true;
	jumpsquat = 0;
}

if (grounded && was_jumping && hspeed == 0) {
	land_anim = true;
	land_anim_time = 0;
	sprite_index = spr_kris_plat_land;
	image_index = 0;
	audio_play(snd_noise);
}

if (land_anim && !attacking) {
	land_anim_time++;
	sprite_index = spr_kris_plat_land;
	image_speed = 0.25;
	if (image_index >= image_number - 1) {
		image_index = image_number - 1;
		//land_anim = false;
	}
	
	if (land_anim_time >= 8)
		land_anim = false;
}

if (jumping) {
	jumptime++;
	
	image_speed = 0.25;
	
	if (sign(vspeed) == -1)
		sprite_index = spr_kris_jump_up;
	else
		sprite_index = spr_kris_jump_down;
}

if (!attacking && _atkpressed) {
	image_index = 0;
	swing_phase = 0;
	attacking = true;
	audio_play(snd_ui_cancel);
}

if (attacking && _atkhled) {
	attack_hold_timer++;
	
	sprite_index = spr_kris_plat_slash_ground;
	image_speed = 0.65;
	
	var _index = floor(image_index);
	
	if (_index == 4 && swing_phase == 0) {
		swing_phase = 1;
		audio_play(snd_heavyswing, 0, 1, 1.1);
	}
		
	if (_index == 7 && swing_phase == 1) {
		swing_phase = 2;
		audio_play(snd_ultraswing, 0, 1, 1.1);
	}
	
	if (_index == image_number - 1) {
		attacking = false;
		attack_hold_timer = 0;
	}
}

if (attacking) {
	var _index = floor(image_index);
}

if (attacking && !_atkhled) {
	if (swing_phase == 0 && image_index >= 4)
		attacking = false;
		
	if (swing_phase == 1 && image_index >= 7)
		attacking = false;
		
	if (swing_phase == 2 && image_index >= image_number - 1)
		attacking = false;
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