function get_trial_info(eti_file_path::String; HEADER_LINE::Int=4)::DataFrame
    return read(eti_file_path, DataFrame, skipto=HEADER_LINE + 1, header=HEADER_LINE)
end