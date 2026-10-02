enum EaseType {
    Linear,
    EaseInSine,
    EaseOutSine,
    EaseInOutSine,
    EaseInQuad,
    EaseOutQuad,
    EaseInOutQuad,
    EaseInCubic,
    EaseOutCubic,
    EaseInOutCubic,
    EaseInQuart,
    EaseOutQuart,
    EaseInOutQuart,
    EaseInQuint,
    EaseOutQuint,
    EaseInOutQuint,
    EaseInExpo,
    EaseOutExpo,
    EaseInOutExpo,
    EaseInCirc,
    EaseOutCirc,
    EaseInOutCirc,
    EaseInBack,
    EaseOutBack,
    EaseInOutBack,
    EaseInElastic,
    EaseOutElastic,
    EaseInOutElastic,
    EaseInBounce,
    EaseOutBounce,
    EaseInOutBounce
}

///@description Calculates an eased output based on a progression 0-1
///@param {real} progress The percent finished with your easing curve (0-1)
///@param {enum.EaseType} ease_type The easing function to apply from the EaseType enum
function easing_curve(_progress, _ease_type) {
    var _p = _progress;

    switch (_ease_type) {

        case EaseType.Linear:
            return _p;

        case EaseType.EaseInSine:
            return 1 - cos((_p * pi) / 2);

        case EaseType.EaseOutSine:
            return sin((_p * pi) / 2);

        case EaseType.EaseInOutSine:
            return -(cos(pi * _p) - 1) / 2;

        case EaseType.EaseInQuad:
            return _p * _p;

        case EaseType.EaseOutQuad:
            return 1 - (1 - _p) * (1 - _p);

        case EaseType.EaseInOutQuad:
            return _p < 0.5
                ? 2 * _p * _p
                : 1 - power(-2 * _p + 2, 2) / 2;

        case EaseType.EaseInCubic:
            return _p * _p * _p;

        case EaseType.EaseOutCubic:
            return 1 - power(1 - _p, 3);

        case EaseType.EaseInOutCubic:
            return _p < 0.5
                ? 4 * _p * _p * _p
                : 1 - power(-2 * _p + 2, 3) / 2;

        case EaseType.EaseInQuart:
            return _p * _p * _p * _p;

        case EaseType.EaseOutQuart:
            return 1 - power(1 - _p, 4);

        case EaseType.EaseInOutQuart:
            return _p < 0.5
                ? 8 * _p * _p * _p * _p
                : 1 - power(-2 * _p + 2, 4) / 2;

        case EaseType.EaseInQuint:
            return _p * _p * _p * _p * _p;

        case EaseType.EaseOutQuint:
            return 1 - power(1 - _p, 5);

        case EaseType.EaseInOutQuint:
            return _p < 0.5
                ? 16 * _p * _p * _p * _p * _p
                : 1 - power(-2 * _p + 2, 5) / 2;

        case EaseType.EaseInExpo:
            return (_p == 0) ? 0 : power(2, 10 * _p - 10);

        case EaseType.EaseOutExpo:
            return (_p == 1) ? 1 : 1 - power(2, -10 * _p);

        case EaseType.EaseInOutExpo:
            if (_p == 0) return 0;
            if (_p == 1) return 1;
            return _p < 0.5
                ? power(2, 20 * _p - 10) / 2
                : (2 - power(2, -20 * _p + 10)) / 2;

        case EaseType.EaseInCirc:
            return 1 - sqrt(1 - _p * _p);

        case EaseType.EaseOutCirc:
            return sqrt(1 - power(_p - 1, 2));

        case EaseType.EaseInOutCirc:
            return _p < 0.5
                ? (1 - sqrt(1 - power(2 * _p, 2))) / 2
                : (sqrt(1 - power(-2 * _p + 2, 2)) + 1) / 2;

        case EaseType.EaseInBack: {
            var c1 = 1.70158;
            var c3 = c1 + 1;
            return c3 * _p * _p * _p - c1 * _p * _p;
        }

        case EaseType.EaseOutBack: {
            var c1 = 1.70158;
            var c3 = c1 + 1;
            return 1 + c3 * power(_p - 1, 3) + c1 * power(_p - 1, 2);
        }

        case EaseType.EaseInOutBack: {
            var c1 = 1.70158;
            var c2 = c1 * 1.525;
            return _p < 0.5
                ? (power(2 * _p, 2) * ((c2 + 1) * 2 * _p - c2)) / 2
                : (power(2 * _p - 2, 2) * ((c2 + 1) * (2 * _p - 2) + c2) + 2) / 2;
        }

        case EaseType.EaseInElastic: {
            if (_p == 0) return 0;
            if (_p == 1) return 1;
            var c4 = (2 * pi) / 3;
            return -power(2, 10 * _p - 10) * sin((_p * 10 - 10.75) * c4);
        }

        case EaseType.EaseOutElastic: {
            if (_p == 0) return 0;
            if (_p == 1) return 1;
            var c4 = (2 * pi) / 3;
            return power(2, -10 * _p) * sin((_p * 10 - 0.75) * c4) + 1;
        }

        case EaseType.EaseInOutElastic: {
            if (_p == 0) return 0;
            if (_p == 1) return 1;
            var c5 = (2 * pi) / 4.5;
            return _p < 0.5
                ? -(power(2, 20 * _p - 10) * sin((20 * _p - 11.125) * c5)) / 2
                : (power(2, -20 * _p + 10) * sin((20 * _p - 11.125) * c5)) / 2 + 1;
        }

        case EaseType.EaseOutBounce: {
            var n1 = 7.5625;
            var d1 = 2.75;
            if (_p < 1 / d1) {
                return n1 * _p * _p;
            } else if (_p < 2 / d1) {
                _p -= 1.5 / d1;
                return n1 * _p * _p + 0.75;
            } else if (_p < 2.5 / d1) {
                _p -= 2.25 / d1;
                return n1 * _p * _p + 0.9375;
            } else {
                _p -= 2.625 / d1;
                return n1 * _p * _p + 0.984375;
            }
        }

        case EaseType.EaseInBounce:
            return 1 - easing_curve(1 - _p, EaseType.EaseOutBounce);

        case EaseType.EaseInOutBounce:
            return _p < 0.5
                ? (1 - easing_curve(1 - 2 * _p, EaseType.EaseOutBounce)) / 2
                : (1 + easing_curve(2 * _p - 1, EaseType.EaseOutBounce)) / 2;

    }

    return _p;
}

///@description Handles interpolated animation of an instance variable over a span of time.
function tween_movement() constructor {
    obj = undefined;
    variable = "";
    start_val = 0;
    end_val = 0;
    duration = 0;
    ease_type = 0;
    
    time_source = undefined;
    
    on_complete = undefined;
    on_complete_args = [];
    
    progress = 0;
    
    start = function() {
        if (!instance_exists(obj))
            return false;
        
        progress = 0;
        
        if (time_source_exists(time_source))
            call_cancel(time_source);
    
        time_source = call_later(1, time_source_units_frames, method(self, update), true);
    }
    
    update = function() {
        progress++;
        
        var _p = clamp(progress / duration, 0, 1);
        var _eased = easing_curve(_p, ease_type);
        
        variable_instance_set(obj, variable, lerp(start_val, end_val, _eased));
        
        if (progress >= duration) {
            call_cancel(time_source);
            destroy();
            if (is_method(on_complete))
                method_call(on_complete, on_complete_args);
            return false;
        }
    }
    
    destroy = function() {
        if time_source_exists(time_source)
            call_cancel(time_source);
        time_source = undefined;
        
        return false;
    }
}

///@description Extends tween_movement to animate an instance moving along a parobola arc
function tween_movement_jump() : tween_movement() constructor {
    arc_height = 40;
    target_x = 0;
    target_y = 0;
    start_x = 0;
    start_y = 0;
    
    start = function() {
        if (!instance_exists(obj))
            return false;
        
        start_x = obj.x;
        start_y = obj.y;
        
        if (time_source_exists(time_source))
            call_cancel(time_source);
    
        time_source = call_later(1, time_source_units_frames, method(self, update), true);
    }
    
    update = function() {
        progress++;
        
        var _p = clamp(progress / duration, 0, 1);
        var _ease = easing_curve(_p, ease_type);
        var _arc = -4 * arc_height * _ease * (1 - _ease);
        
        var _x = lerp(start_x, target_x, _ease);
        var _y = lerp(start_y, target_y, _ease);
        
        obj.x = _x;
        obj.y = _y + _arc;
        
        if (progress >= duration) {
            obj.x = target_x;
            obj.y = target_y;
            
            call_cancel(time_source);
            
            destroy();
            
            if (is_method(on_complete))
                method_call(on_complete, on_complete_args);
            return false;
        }
    }
}

///@description Helper function to immediatly instantiate and start a standard tween_movement
///@param {Id.Instance} obj The object to interpolate
///@param {string} variable The variable to interpolate
///@param {real} start_val The start value of the interpolated variable
///@param {real} end_val The end value of the interpolated variable
///@param {real} duration How long (in frames) the tween should last
///@param {Enum.EaseType} ease_type The type of easing curve to use (defaults to linear)
///@param {function} on_complete The function to call when the tween is finished
///@param {array} on_complete_args Arguments that are passed to the callback function
function tween(_obj, _variable, _start_val, _end_val, _duration, _ease_type = EaseType.Linear, _on_complete = undefined, _on_complete_args = []) {
    var _tween = new tween_movement();
    _tween.obj = _obj;
    _tween.variable = _variable;
    _tween.start_val = _start_val;
    _tween.end_val = _end_val;
    _tween.duration = _duration;
    _tween.ease_type = _ease_type;
    _tween.on_complete = _on_complete;
    _tween.on_complete_args = _on_complete_args;
    
    _tween.start();
    
    return _tween;
}

///@description Helper function to make an object move from it's current position to a point b with an arced motion
///@param {Id.Instance} obj The object to interpolate
///@param {real} target_x The target x value to reach
///@param {real} target_y The target y value to reach
///@param {real} duration How long (in frames) the tween should last
///@param {real} arc_height The max height the object's
///@param {Enum.EaseType} ease_type The type of easing curve to use (defaults to linear)
///@param {function} on_complete The function to call when the tween is finished
///@param {array} on_complete_args Arguments that are passed to the callback function
function tween_jump(_obj, _target_x, _target_y, _duration, _arc_height = 40, _ease_type = EaseType.Linear, _on_complete = undefined, _on_complete_args = []) {
    var _tween = new tween_movement_jump();
    _tween.obj = _obj;
    _tween.target_x = _target_x;
    _tween.target_y = _target_y;
    _tween.duration = _duration;
    _tween.arc_height = _arc_height;
    _tween.ease_type = _ease_type;
    _tween.on_complete = _on_complete;
    _tween.on_complete_args = _on_complete_args;

    _tween.start();

    return _tween;
}
