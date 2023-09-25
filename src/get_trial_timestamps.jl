# returns timestamps of the input trial
function get_trial_timestamps(epd::EPD; start_code::I, end_code::I, trial_nr::I, trial_start_code::I=128)::Tuple{I, I} where I <: Integer

    events = get_events(epd)
    trial_start = findall(x -> x == trial_start_code, events[:, 2])[trial_nr]
    start_idx = findnext(x -> x == start_code, events[:, 2], trial_start)
    end_idx = findnext(x -> x == end_code, events[:, 2], trial_start)
    
    isnothing(start_idx) && throw("ERROR: Start code `$(start_code)` in trial nr. $(trial_nr) does not exist!")
    
    next_trial_start = findnext(x -> x == trial_start_code, events[:, 2], trial_start+1)
    
    if isnothing(end_idx) || (!isnothing(next_trial_start) && next_trial_start < end_idx)
    	throw("ERROR: End code `$(end_code)` in trial nr. $(trial_nr) does not exist!")
    end
    
    if events[start_idx, 1] > events[end_idx, 1]
        throw("ERROR: for codes `$(start_code)` and `$(end_code)` in trial nr. $(trial_nr): starting timestamp ($(events[start_idx, 1])) > ending timestamp ($(events[end_idx, 1]))")
    end

    return (events[start_idx, 1], events[end_idx, 1])

end
