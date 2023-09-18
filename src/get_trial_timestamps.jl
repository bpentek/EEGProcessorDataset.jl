# returns timestamps of the input trial
function get_trial_timestamps(epd::EPD; start_code::I, end_code::I, trial_nr::I)::Tuple{I, I} where I <: Integer

    events = get_events(epd)
    start_idx = findall(x -> x == start_code, events[:, 2])[trial_nr]
    end_idx = findall(x -> x == end_code, events[:, 2])[trial_nr]
    
    if events[start_idx, 1] > events[end_idx, 1]
        throw("ERROR: for codes `$(start_code)` and `$(end_code)` in trial nr. $(trial_nr): starting timestamp ($(events[start_idx, 1])) > ending timestamp ($(events[end_idx, 1]))")
    end


    return (events[start_idx, 1], events[end_idx, 1])

end
