function approach(current, target, amount) {
	if (current < target) {
	    return min(current+amount, target); 
	} else {
	    return max(current-amount, target);
	}
}

function wave(startValue, endValue, duration, phaseOffset) {
    if (duration <= 0) {
        throw ("Duration must be greater than zero");
    }

    var _amplitude = (endValue - startValue) * 0.5;
    var _wave_phase = ((current_time * 0.001) + (duration * phaseOffset)) / duration;
    return startValue + _amplitude + sin(_wave_phase * pi) * _amplitude;
}