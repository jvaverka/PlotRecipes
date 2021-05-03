using CSV
using DataFrames
using Plots
using PlotThemes
using Unitful

# load dataframe
data = CSV.read("data/alltimes.csv", DataFrame)

# get proper units for comparison
function get_total_seconds(s::String)
    splitmin, splitsec = split(s, "m")
    num_min = parse(Int, splitmin)
    num_sec = parse(Float64, strip(splitsec, 's'))
    num_min*u"minute" + num_sec*u"s"
end

# transform data
data.real = get_total_seconds.(data.real)
data.user = get_total_seconds.(data.user)
data.sys = get_total_seconds.(data.sys)

# format names
data.case = chop.(data.case, tail=4)

# strip units
data.real = data.real |> ustrip
data.user = data.user |> ustrip
data.sys  = data.sys  |> ustrip

# sort to make graph easier to read
sort!(data, :real, rev=true)

# plot and save results
theme(:bright)
bar(data.case, [data.real, data.sys],
    orientation = :h,
    title = "Time per Case",
    label = ["real" "sys"],
    xlabel = "seconds",
    ylabel = "case"
)
savefig("benchmarks.png")