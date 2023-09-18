mutable struct EPD
    
    name::String # name of the dataset 
    epd_folder::String # folder of the dataset 
    version::Float32 # version of the EPD file

    event_timestamps_file::String
    event_codes_file::String
    channel_samples_files::Vector{String}

    #
    info::Dict{String, Any}

    #
    event_ids::Dict{Int32, String}
    

    
end

function line_skip_read(file::IO, skip::Int)::String
    skip = max(0, skip)
    
    for _ in 1:skip
        readline(file)
    end

    return readline(file)
end


function EPD(epd_file_path::String)::EPD

    epd = EPD(  "",
                "",
                0.0,
                "",
                "",
                [],
                Dict("ch_nr" => 0, "sample_freq" => 0.0, "sample_nr" => 0, "ch_names" => String[], "event_nr" => 0, "sample_unit" => "uV", "time_unit" => "samples"),
                Dict(250 => "Start experiment", 251 => "Start block", 128 => "Fixation dot (red)", 150 => "BlankPeriod", 129 => "Stimulus ON", 1 => "CertainResponse", 2 => "UncertainResponse", 3 => "NothingResponse", 131 => "Verbal response", 132 => "SPACE pressed to continue", 252 => "End block", 255 => "End experiment") # event_ids
            )
    @warn "event_ids are hard coded to match the Dots dataset."
    
    epd.epd_folder = dirname(epd_file_path)
    epd.name = split(basename(epd_file_path), ".")[1]

    epd_file = open(epd_file_path, "r")

    epd.version = parse(Float32, line_skip_read(epd_file, 2))
    epd.info["ch_nr"] = parse(Int, line_skip_read(epd_file, 2))
    epd.info["sample_freq"] = parse(Float32, line_skip_read(epd_file, 2))
    epd.info["sample_nr"] = parse(Int, line_skip_read(epd_file, 2))

    line_skip_read(epd_file, 1)
    epd.channel_samples_files = String[]
    for _ in 1:epd.info["ch_nr"]
        push!(epd.channel_samples_files, replace(readline(epd_file), "\n" => ""))
    end
    

    if epd.version == 1.0
        line_skip_read(epd_file, 2)
    end

    epd.event_timestamps_file = line_skip_read(epd_file, 2)
    epd.event_codes_file = line_skip_read(epd_file, 2)

    epd.info["event_nr"] = parse(Int, line_skip_read(epd_file, 2))

    line_skip_read(epd_file, 1)
    for _ in 1:epd.info["ch_nr"]
        push!(epd.info["ch_names"], replace(readline(epd_file), "\n" => ""))
    end

    close(epd_file)

    @info ".epd header read succesfully from $epd_file_path"

    return epd
end
