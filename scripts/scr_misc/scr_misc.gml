/**
 * Approach a target value by a specified amount.
 * @function approach
 * @param {number} _current - The current value.
 * @param {number} _target - The target value to approach.
 * @param {number} _amount - The amount to move towards the target.
 * @returns {number}
 */
function approach(_current, _target, _amount) {
    if (_current < _target) {
        return min(_current + _amount, _target); 
    } else {
        return max(_current - _amount, _target);
    }
}

/**
 * Creates a wave pattern oscillating between two values over a duration.
 * @function wave
 * @param {number} _start_value - The starting value of the wave.
 * @param {number} _end_value - The end value of the wave.
 * @param {number} _duration - The duration of one wave cycle.
 * @param {number} _phase_offset - The phase offset of the wave.
 * @returns {number}
 */
function wave(_start_value, _end_value, _duration, _phase_offset) {
    var _amplitude = (_end_value - _start_value) * 0.5;
    var _current_time = current_time;
    var _wave_phase = ((_current_time * 0.001) + (_duration * _phase_offset)) / _duration;
    return _start_value + _amplitude + sin(_wave_phase * pi) * _amplitude;
}

/**
 * Prepares a file path for usage, replacing backslashes with forward slashes.
 * @function prepare_path
 * @param {string} _file_path - The file path to be prepared.
 * @returns {string}
 */
function prepare_path(_file_path) {
    _file_path = string_replace_all(_file_path, "\\", "/");
    return _file_path;
}
