### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ d8e1a80e-2c6d-11ee-07e4-534ac08b286c
begin

	using Pkg
	Pkg.activate("/hdd/balazs/research/EEGProcessorDataset.jl")
	using EEGProcessorDataset
	
end

# ╔═╡ 78139790-e9f0-4d34-b5af-0f3d810b07ce
md"""
# Loading .epd file header
"""

# ╔═╡ 5aaa99e2-40a5-4559-b37f-2101580f10f7
EPD_FILE_PATH = "/hdd/rslsync/PCE2022/Dots_30_ICA_cleaned_for_UBB/reref_Cleaned_datasets/Dots_30_001/Dots_30_001.epd";

# ╔═╡ 4e6c9004-cd8d-4945-b1d5-6e8bcb17424f
begin
	epd = EPD(EPD_FILE_PATH)
	epd
end

# ╔═╡ 21456e20-09c7-4d21-85f6-c97269f406cb
epd.info

# ╔═╡ 210cf292-d3b1-4b2f-b41a-0bd73156c3e0
md"""
# Getting EEG samples
"""

# ╔═╡ 0adba3c4-1618-4745-9868-2e4cbb39d621
get_samples(epd)

# ╔═╡ fe21122a-05cf-49f3-ac6a-aa8ec1507e2a
get_samples(epd; start_time=1000000, end_time=1100000, chs=[1, 3, 5, 111])

# ╔═╡ a4d6c338-3d37-41fb-b206-14eb7df02597
md"""
# Getting events (codes and timestamps)
"""

# ╔═╡ 8cad45ec-6af5-4de3-aa4a-9f1c36388bf5
events = get_events(epd)

# ╔═╡ 704c5018-a797-4235-a904-48f8a3afd92d
md"""
Event IDs are also hardcoded to match the Dots (PCE2022) dataset
"""

# ╔═╡ 5049ec46-353f-478e-a83a-55ff8d81991f
epd.event_ids

# ╔═╡ 06a9a880-b8a9-4c0d-8004-e17bdd907d70
md"""
# Plotting samples
"""

# ╔═╡ 4fd1f36f-29ce-49aa-90de-aece6d252e2b
plot_samples(epd; start_time=8000, end_time=15000, chs=[1, 2, 33, 67, 100])

# ╔═╡ 8104a99b-d063-4cdf-bf0e-13e5d5d08c03
md"""
# Loading trial info from .eti file
"""

# ╔═╡ 326a2c3e-ded8-4a5e-8525-a254b7139d32
trialinfo_df = get_trial_info("/hdd/rslsync/PCE2022/Dots_30_ICA_cleaned_for_UBB/reref_Cleaned_datasets/Dots_30_001/Dots_30_001-TrialInfo.eti")

# ╔═╡ bc490b89-3ca9-40e9-89fa-9608beeabe0b
md"""
# Example #1: loading EEG data of a trial of interest
"""

# ╔═╡ 8e42e0b9-3006-4af8-8234-f71da6efb913
TRIAL_NR = 129

# ╔═╡ 118e6585-72a9-4664-b07a-8fc79aba6f9b
md"""
First we should check if the trial is good (and the response is accurate)
"""

# ╔═╡ e33b8e29-05d1-4bd6-ad96-38472d7ca4c8
begin
	if trialinfo_df[TRIAL_NR, :Accuracy] == 0 
		throw("ERROR: in trial nr. $(TRIAL_NR) the response was inaccurate")
	end
		
	if trialinfo_df[TRIAL_NR, :GoodTrialsManual] == 0
		throw("ERROR: trial nr. $(TRIAL_NR) was marked as bad by the experimenters")
	end
	
	# rare case, but can happen
	epd_resp_id = events[findall(x -> x ∈ [1, 2, 3], events[:, 2])[TRIAL_NR], 2]
	if epd_resp_id != trialinfo_df[TRIAL_NR, :ResponseID]
		throw("ERROR: mismatch between response ID in .epd file ($(epd_resp_id)) and .eti file ($(trialinfo_df[TRIAL_NR, :ResponseID]))")
	end
end

# ╔═╡ 27907c2b-72f8-40a4-98e1-84adb87ef4e0
trial_timestamps = get_trial_timestamps(epd, start_code=150, end_code=131, trial_nr=TRIAL_NR)

# ╔═╡ 5f0a6135-6d9f-4902-aa8e-35cff72316c8
plot_samples(epd; start_time=trial_timestamps[1], end_time=trial_timestamps[2], chs=[1, 2, 3])

# ╔═╡ Cell order:
# ╠═d8e1a80e-2c6d-11ee-07e4-534ac08b286c
# ╟─78139790-e9f0-4d34-b5af-0f3d810b07ce
# ╠═5aaa99e2-40a5-4559-b37f-2101580f10f7
# ╠═4e6c9004-cd8d-4945-b1d5-6e8bcb17424f
# ╠═21456e20-09c7-4d21-85f6-c97269f406cb
# ╟─210cf292-d3b1-4b2f-b41a-0bd73156c3e0
# ╠═0adba3c4-1618-4745-9868-2e4cbb39d621
# ╠═fe21122a-05cf-49f3-ac6a-aa8ec1507e2a
# ╟─a4d6c338-3d37-41fb-b206-14eb7df02597
# ╠═8cad45ec-6af5-4de3-aa4a-9f1c36388bf5
# ╟─704c5018-a797-4235-a904-48f8a3afd92d
# ╠═5049ec46-353f-478e-a83a-55ff8d81991f
# ╟─06a9a880-b8a9-4c0d-8004-e17bdd907d70
# ╠═4fd1f36f-29ce-49aa-90de-aece6d252e2b
# ╟─8104a99b-d063-4cdf-bf0e-13e5d5d08c03
# ╠═326a2c3e-ded8-4a5e-8525-a254b7139d32
# ╟─bc490b89-3ca9-40e9-89fa-9608beeabe0b
# ╠═8e42e0b9-3006-4af8-8234-f71da6efb913
# ╟─118e6585-72a9-4664-b07a-8fc79aba6f9b
# ╠═e33b8e29-05d1-4bd6-ad96-38472d7ca4c8
# ╠═27907c2b-72f8-40a4-98e1-84adb87ef4e0
# ╠═5f0a6135-6d9f-4902-aa8e-35cff72316c8
