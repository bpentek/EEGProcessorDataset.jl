function plot_samples(epd::EPD; start_time::Int=1, end_time::Int=epd.info["sample_nr"], chs::Vector{Int}=collect(1:epd.info["ch_nr"]), CH_SEP::Int=40)

    samples = get_samples(epd; start_time=start_time, end_time=end_time, chs=chs)
    
    events = get_events(epd)
    events = events[findall(start_time .<= events[:, 1] .<= end_time), :]

    time = collect(start_time:1:end_time)

    plot(   xlabel="time (in $(epd.info["time_unit"]))",
            ylabel="channel samples (in $(epd.info["sample_unit"]))",
            xlim=[start_time, end_time], 
            legend=:outertopright,
            tight_layout=true
            )
    
    yticks!([(i - 1)*CH_SEP for i in axes(samples, 2)], epd.info["ch_names"][chs])

    for i in axes(samples, 2)
        plot!(time, samples[:, i] .+ (i - 1)*CH_SEP, color=:gray, label="")
    end

    event_codes = unique(events[:, 2])
    event_times = [events[findall(x -> x == code, events[:, 2]), 1] for code in event_codes]

    for i  in 1:1:length(event_codes)
        event_name = epd.event_ids[event_codes[i]]
        vline!(event_times[i], label="$(event_codes[i]) - $(event_name)", linestyle = :dash, linewidth = 1.5)
    end

    return plot!()

end