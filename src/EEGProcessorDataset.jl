module EEGProcessorDataset

using DataFrames: DataFrame
using CSV: read
using Plots: plot, plot!, vline!, yticks!

include("./EPD.jl")
export EPD

include("./get_samples.jl")
export get_samples

include("./get_events.jl")
export get_events

include("./plot_samples.jl")
export plot_samples

include("./get_trial_info.jl")
export get_trial_info

include("./get_trial_timestamps.jl")
export get_trial_timestamps


end # module EEGProcessorDataset
