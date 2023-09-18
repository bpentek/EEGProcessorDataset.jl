function read_bin_array(bin_file_path::String, size::Int, type::Type)::Vector{type}
    arr = Vector{type}(undef, size)
    read!(bin_file_path, arr)
    return arr
end

function get_samples(epd::EPD; start_time::Int=1, end_time::Int=epd.info["sample_nr"], chs::Vector{Int}=collect(1:epd.info["ch_nr"]))::Matrix{Float32}

    if start_time > end_time || start_time < 1 || end_time > epd.info["sample_nr"]
        @error "Invalid time interval selected: [$start_time, $end_time]"
    end

    data = Matrix{Float32}(undef, end_time - start_time + 1, length(chs))
    for (i, ch) in enumerate(chs)
        ch_samples = read_bin_array("$(epd.epd_folder)/$(epd.channel_samples_files[ch])", epd.info["sample_nr"], Float32)
        data[:, i] = ch_samples[start_time:end_time]
    end

    return data

end