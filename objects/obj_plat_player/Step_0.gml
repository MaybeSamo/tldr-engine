if (live_call()) return live_result;

var _rpressed = InputCheck(INPUT_VERB.RIGHT);
var _lpressed = InputCheck(INPUT_VERB.LEFT);
var _jpressed = InputCheck(INPUT_VERB.CANCEL);

hspeed += (_rpressed - _lpressed) * h_accel;

hspeed = clamp(hspeed, -max_hspeed, max_hspeed);

if (!_lpressed && !_rpressed)
	hspeed *= h_decel;

grounded = place_meeting(x, y + 1, obj_plat_block);

if (grounded) {
	if (vspeed > 0) 
		vspeed = 0;
	gravity = 0;
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

if (jumpsquat == 2 && grounded && !jumping) {
	vspeed = -jumpheight;
	gravity = grav;
	grounded = false;
	jumping = true;
}

if (jumping)
	jumptime++;
	
var _release_jump = false;

if (!_jpressed && jumping && jumptime >= jump_mintime)
	_release_jump = true;
	
if (vspeed < 0 && _release_jump) {
	vspeed *= 0.25;
}

if (place_meeting(x, y + vspeed, obj_plat_block)) {
    while (!place_meeting(x, y + sign(vspeed), obj_plat_block)) {
        y += sign(vspeed);
    }
    vspeed = 0;
}

if (place_meeting(x + hspeed, y, obj_plat_block)) {
	if (!place_meeting(x + hspeed, y - 1, obj_plat_block)) {
        y -= 1;
    } else {
        while (!place_meeting(x + sign(hspeed), y, obj_plat_block)) {
            x += sign(hspeed);
        }
        hspeed = 0;
    }
}

if (keyboard_check_pressed(ord("R")))
	room_restart();