if (live_call()) return live_result;

enum PlatPlayerState {
	Idle,
	Running,
	RunStop,
	Jumpsquat,
	Airborne,
	Falling,
	SwingGround,
	SwingAir,
	Hurt,
	Landing,
	TransitionIn,
	TransitionOut,
}

#macro DIR_LEFT -1
#macro DIR_RIGHT 1

state = PlatPlayerState.Idle;

image_speed = 0.25;

idle_sprite = spr_kris_plat_idle;
run_sprite = spr_kris_plat_run;
runstop_sprite = spr_kris_plat_runstop;
slash_ground_sprite = spr_kris_plat_slash_ground;
turn_sprite = spr_kris_plat_turn;
land_sprite = spr_kris_plat_land;
jump_sprite = spr_kris_jump_up;
fall_sprite = spr_kris_jump_down;

can_accel = true;
do_decel = true;
max_xspd = 4.5;
x_accel = 1;
x_decel = 0.325;

terminal_velocity = 10;

jumpsquat = 0;
jumpsquat_max = 4;
jumpheight = 10;
jumping = false;
jumptime = 0;
jump_mintime = 4;
was_jumping = false;

land_anim = false;
land_anim_time = 0;

runstop_anim = false;
turn_anim = false;

attacking = false;
swing_phase = 0;
attack_hold_timer = 0;
swing_snd_played = false;

grav = 0.625;

can_jump = true;
can_swing = true;

dont_step = false;

grounded = false;

xspd = 0;
yspd = 0;

animation_end = function() {
	return image_index >= image_number - 1;
}

change_state = function(_state) {
	switch (_state) {
		case PlatPlayerState.SwingGround:
		case PlatPlayerState.Landing:
		case PlatPlayerState.Airborne:
		case PlatPlayerState.Jumpsquat:
		case PlatPlayerState.RunStop:
		case PlatPlayerState.Running: {
			image_index = 0;
			break;
		}
	}
	
	if (state == PlatPlayerState.SwingGround)
		swing_phase = 0;
	
	state = _state;
}

gen_hitbox = function(_sprite, _startframe = 0, _endframe = 7) {
    var _hbx = instance_create(obj_plat_slash_hbx, x, y)
    
    _hbx.sprite_index = _sprite
    _hbx.image_index = _startframe;
    _hbx.image_speed = image_speed;
    _hbx.image_xscale = image_xscale;
    _hbx.visible = false;
    _hbx.end_frame = _endframe;
    
    return _hbx;
}

variables_to_draw = [
"hspeed",
"vspeed",
"jumpsquat",
"can_jump",
"grounded"
]