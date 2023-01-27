using Pkg;
Pkg.activate();
Pkg.instantiate();
# Pkg.add("Clustering");
# Pkg.add("Plots");
# Pkg.add("Random");
# Pkg.add("DataFrames");
# Pkg.add("CSV");
# Pkg.add("PlotlyJS");
# Pkg.add("Downloads");
# Pkg.add("TickTock");
# Pkg.add("BenchmarkTools");

# Packages
using Clustering;
using Random;
using Plots;
using PlotlyJS, CSV, DataFrames;
using Downloads;
using TickTock;
using BenchmarkTools;

# Création des graphes
function plotG(X::Vector{Float64}, Y::Vector{Float64}, group::Vector, title::String, xaxis::String, yaxis::String)
    return plot(
        X, Y, kind="scatter", mode="markers", group=group,
        Layout(
            title=title,
            xaxis_title=xaxis,
            yaxis_title=yaxis,
            font=attr(
                family="Courier New, monospace",
                size=18,
                color = "RebeccaPurple"
            )
        )
    )
end

# Analyse du kmeans
function kmeans_analysis(f1::Vector{Float64}, f2::Vector{Float64}, nb::Int, itr::Int)

    f1_min = minimum(f1)
    f2_min = minimum(f2)

    f1_max = maximum(f1)
    f2_max = maximum(f2)

    f1_var = (f1 .- f1_min) ./ (f1_max - f1_min)
    f2_var = (f2 .- f2_min) ./ (f2_max - f2_min)

    matrix = [f1_var f2_var]'

    Random.seed!(1)
    result = kmeans(matrix, nb; maxiter = itr, display = :iter)
    a = assignments(result)

    # Afficher les résultats
    kmeans_analysis = plot(
        f1_var, f2_var,
        kind="scatter", mode="markers", group=a,
        Layout(
            title="Analyse du kmeans",
            xaxis_title = "Score de la Majorite",
            yaxis_title = "Score de Participation",
            font=attr(
                family="Courier New, monospace",
                size=18,
                color="RebeccaPurple"
            )
        )
    )

    savefig(plotG(X, Y, a, "Titre", "xaxis", "yaxis"), "plot_kmeans.png")
end

# Fonction principale
function main()
    Downloads.download("https://raw.githubusercontent.com/altheaFeu/kmeansDeputeJulia/main/deputes-active.csv", "deputes.csv")
    dataset = CSV.read("deputes.csv", DataFrame)

    print("Entrez la valeur de X (ex : dataset.scoreMajorite):")
    X = readline()
    print("Entrez la valeur de Y (ex : dataset.scoreParticipation):")
    Y = readline()

    savefig(plotG(X, Y, dataset.group, "Titre", "xaxis", "yaxis"), "plot_analysis.png")

    print("Veuillez entrez un nombre de clusters : ")
    nb = readline()
    nb = parse(Int64, nb)

    print("Veuillez entrez un nombre d'itérations : ")
    iter = readline()
    iter = parse(Int64, itr)

    kmeans_analysis(X, Y, nb, iter)
end

tick()
main()
println("Le script a duré $(tok()) secondes")

