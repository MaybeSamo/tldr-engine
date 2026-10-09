if (live_call()) return live_result;

if (dont_step) exit;

var _key_right = InputCheck(INPUT_VERB.RIGHT);
var _key_left = InputCheck(INPUT_VERB.LEFT);
var _key_jump = InputCheck(INPUT_VERB.CANCEL);
var _key_jump_pressed = InputCheck(INPUT_VERB.CANCEL);
var _key_swing = InputCheck(INPUT_VERB.SELECT);
var _key_swing_pressed = InputPressed(INPUT_VERB.SELECT);

var _dir = _key_right - _key_left;

grounded = place_meeting(x, y + 1, obj_plat_block);

mask_index = idle_sprite;

switch (state) {
	case PlatPlayerState.Idle: {
		can_jump = true;
		can_accel = true;
		can_swing = true;
		can_swing_air = false;
        
		image_speed = 0.25;
		sprite_index = idle_sprite;
			
		if (_dir != 0 && !(_key_left && _key_right))
			change_state(PlatPlayerState.Running);
		
		break;
	}
	
	case PlatPlayerState.Running: {
		can_jump = true;
		can_accel = true;
		can_swing = true;
        can_swing_air = false;
		
		image_speed = 0.25;
		sprite_index = run_sprite;
		can_jump = true;
		
		if ((_dir == DIR_LEFT && sign(xspd) == DIR_RIGHT) ||
			_dir == DIR_RIGHT && sign(xspd) == DIR_LEFT)
			sprite_index = turn_sprite;
		
		if ((!_key_right && !_key_left) || xspd == 0
			|| (_key_right && _key_left)) {
			//image_index = 0;
			change_state(PlatPlayerState.RunStop);
		}
			
		break;
	}
	
	case PlatPlayerState.RunStop: {
		can_jump = true;
		can_accel = true;
		can_swing = true;
        can_swing_air = false;
		
		sprite_index = runstop_sprite;
		
		if (animation_end())
			change_state(PlatPlayerState.Idle);
		break;
	}
	
	case PlatPlayerState.Jumpsquat: {
        can_accel = true;
		can_jump = false;
        can_swing = true;
        can_swing_air = false;
		
		sprite_index = land_sprite;
		
		jumpsquat += 1;
		
		if (jumpsquat >= jumpsquat_max) {
			audio_play(snd_ui_cancel, 0, 1, 1.5);
			yspd = -jumpheight;
			jumpsquat = 0;
			change_state(PlatPlayerState.Airborne);
		}
		break;
	}
	
	case PlatPlayerState.Airborne: {
		can_accel = true;
		can_jump = true;
        can_swing_air = true;
        can_swing = false;
		
		image_index = 0.25;
		
		if (sign(yspd) == -1)
			sprite_index = jump_sprite;
		
		if (sign(yspd) == 1)
			sprite_index = fall_sprite;
			
		if (grounded) {
			if (!_key_right && !_key_left) {
				audio_play(snd_noise);
				change_state(PlatPlayerState.Landing);
			} else {
				change_state(PlatPlayerState.Running);
			}
		}
		
		break;
	}
	
	case PlatPlayerState.Landing: {
		can_accel = true;
		can_jump = true;
        can_swing = true;
        can_swing_air = false;
		
		jumpsquat += 1;
		
		sprite_index = land_sprite;
		
		if (animation_end())
			image_speed = 0;
			
		if (jumpsquat >= 8) {
			jumpsquat = 0;
			change_state(PlatPlayerState.Idle);
		}
		
		break;
	}
	
	case PlatPlayerState.SwingGround: {
		can_accel = false;
		can_jump = false;
		can_swing = false;
        can_swing_air = false;
		
		sprite_index = slash_ground_sprite;
		image_speed = 0.5;
		
		var _index = floor(image_index);
		
		if (_index == 1 && swing_phase == 0) {
            gen_hitbox(spr_kris_plat_slash_hbx, 0, 2);
			swing_phase = 1;
			audio_play(snd_ui_cancel);
		}
		
		if (_key_swing) {
			
			if (_index == 5 && swing_phase == 1) {
                gen_hitbox(spr_kris_plat_slash_hbx, 0, 2);
				swing_phase = 2;
				audio_play(snd_heavyswing, 0, 1, 1.1);
			}
			
			if (_index == 8 && swing_phase == 2) {
                gen_hitbox(spr_kris_plat_slash_hbx, 0, 2);
				swing_phase = 3;
				audio_play(snd_ultraswing, 0, 1, 1.1);
			}
		} else {
			if (swing_phase == 1 && _index >= 4) {
				change_state(PlatPlayerState.Idle);
			}
			
			if (swing_phase == 2 && _index >= 8)
				change_state(PlatPlayerState.Idle);
		}
		
		if (animation_end()) {
			change_state(PlatPlayerState.Idle);
		}
		
		break;
	}
	
	case PlatPlayerState.TransitionOut: {
		can_accel = false;
		can_jump = false;
		can_swing = false;
        image_speed = 0.3;
		
		if (sprite_index == slash_ground_sprite && image_index >= 4) {
			image_speed = 0;
			image_index = 4;
		}
        
        break;
	}
    
    case PlatPlayerState.SwingAir: {
        sprite_index = slash_air_sprite;
        if (image_index < 8) {
            if (obj_plat_controller.transition_duration >= 1)
                gen_hitbox(spr_kris_plat_slash_hbxair, 0, sprite_get_number(spr_kris_plat_slash_hbxair) - 1);
            image_index = 8;
        }
        image_speed = 0.5;
        
        if (animation_end())
            change_state(PlatPlayerState.Airborne);
        
        if (grounded)
            change_state(PlatPlayerState.Landing);
        
        break;
    }
}

if (!grounded && (state != PlatPlayerState.TransitionOut
    && state != PlatPlayerState.SwingAir))
	change_state(PlatPlayerState.Airborne);

if ((grounded && can_jump)
	&& _key_jump_pressed) {
	
	change_state(PlatPlayerState.Jumpsquat);
}

if (can_swing && _key_swing_pressed && state != PlatPlayerState.SwingGround && grounded) {
	change_state(PlatPlayerState.SwingGround);
}

if (can_swing_air && _key_swing_pressed && state != PlatPlayerState.SwingAir && state != PlatPlayerState.TransitionIn && !grounded) {
    change_state(PlatPlayerState.SwingAir);
    audio_play(snd_heavyswing, 0, 1, 1.1);
}

if (sign(xspd) != 0)
	image_xscale = sign(xspd);

//Accelerate with directional movement
if (can_accel) {
	xspd += _dir * x_accel;
}

//If no key pressed, slow down
if ((do_decel && _dir == 0) || !can_accel)
	xspd *= x_decel;

xspd = clamp(xspd, -max_xspd, max_xspd);

//Horizontal Movement and Collision
var _sub_pixel = 0.5;
if (place_meeting(x + xspd, y, obj_plat_block)) {
	var _pixel_check = _sub_pixel * sign(xspd);
	
	while (!place_meeting(x + _pixel_check, y, obj_plat_block)) {
		x += _pixel_check;
	}
	
	xspd = 0;
}

x += xspd;

//Vertical Movement and Collision
yspd += grav;

if (yspd > terminal_velocity) 
	yspd = terminal_velocity;
	
if (place_meeting(x, y + yspd, obj_plat_block)) {
	var _pixel_check = _sub_pixel * sign(yspd);
	
	while (!place_meeting(x, y + _pixel_check, obj_plat_block)) {
		y += _pixel_check;
	}
	
	yspd = 0;
	//grounded = true;
}

y += yspd;

/*
var _rpressed = InputCheck(INPUT_VERB.RIGHT);
var _lpressed = InputCheck(INPUT_VERB.LEFT);
var _jpressed = InputCheck(INPUT_VERB.CANCEL);
var _atkhled = InputCheck(INPUT_VERB.SELECT);
var _atkpressed = InputPressed(INPUT_VERB.SELECT);
var _dir = _rpressed - _lpressed;

was_jumping = jumping;

if (grounded && !turn_anim && !runstop_anim && _dir != 0 && sign(xspd) == -_dir && abs(xspd) > max_xspd * 0.8) {
    turn_anim = true;
    sprite_index = spr_kris_plat_turn;
    image_index = 0;
    image_speed = 0.25;
}

if (!attacking)
	xspd += _dir * h_accel;
xspd = clamp(xspd, -max_xspd, max_xspd);

if (_dir == 0 || attacking) {
    xspd *= h_decel;
    if (abs(xspd) < 0.1) xspd = 0;
}

if (turn_anim) {
    sprite_index = spr_kris_plat_turn;
    if (!grounded || _dir == 0 || image_index + image_speed >= image_number) {
        turn_anim = false;
        sprite_index = spr_kris_plat_run;
        image_index = 0;
        if (sign(xspd) == -_dir) xspd = 0;
    }
}

if (_dir != 0 && !turn_anim) {
    image_xscale = _dir;
    runstop_anim = false;
}

if (grounded && !turn_anim && !runstop_anim && !attacking) {
    if (_dir != 0) {
        sprite_index = spr_kris_plat_run;
        image_speed = 0.15 + (0.25 * abs(xspd) / max_xspd);
    } else if (xspd == 0) {
		image_speed = 0.25;
        sprite_index = spr_kris_plat_idle;
    }
}

if (_dir == 0 && !runstop_anim && !turn_anim && sprite_index == spr_kris_plat_run && xspd != 0) {
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
if (_no_input && !runstop_anim && !turn_anim && sprite_index == spr_kris_plat_run && sprite_index != spr_kris_plat_idle && xspd != 0) {
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

if (grounded && was_jumping && xspd == 0) {
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

if (place_meeting(x + xspd, y, obj_plat_block)) {
    while (!place_meeting(x + sign(xspd), y, obj_plat_block)) {
		x += sign(xspd);
    }
	
	xspd = 0;
}
*/
if (keyboard_check_pressed(ord("R")))
	room_restart();