function get_events(epd::EPD)::Matrix{Int32}
    if epd.info["event_nr"] == 0
        @error "event_nr is zero in the epd data.\nMake sure that the .epd header was loaded properly"
    end

    if epd.event_timestamps_file == ""
        @error "event_timestamps_file is empty in epd data.\nMake sure that the .epd header was loaded properly"
    end

    if epd.event_codes_file == ""
        @error "event_codes_file is empty in epd data.\nMake sure that the .epd header was loaded properly"
    end
    
    events = Matrix{Int32}(undef, epd.info["event_nr"], 2)
    events[:, 1] = read_bin_array("$(epd.epd_folder)/$(epd.event_timestamps_file)", epd.info["event_nr"], Int32)
    events[:, 2] = read_bin_array("$(epd.epd_folder)/$(epd.event_codes_file)", epd.info["event_nr"], Int32)
    
    return events
end