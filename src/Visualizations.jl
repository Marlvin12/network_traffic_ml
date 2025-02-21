module Visualizations

# Export functions that will be used outside the module
export create_visualization_report

using Plots
using DataFrames
using StatsPlots
using MLJ
using Statistics
using Dates
using Colors

# Include Metrics for confusion matrix calculations
include("Metrics.jl")

"""
Plot distribution of protocols in normal vs attack traffic
"""
function plot_protocol_distribution(df::DataFrame)
    protocol_counts = combine(groupby(df, [:Protocol, :Label]), nrow)
    
    return groupedbar(
        protocol_counts.Protocol,
        protocol_counts.nrow,
        group=protocol_counts.Label,
        title="Protocol Distribution",
        xlabel="Protocol",
        ylabel="Count",
        label=["Normal" "Attack"],
        color=[:green :red],
        alpha=0.6
    )
end

"""
Plot packet size distribution for normal vs attack traffic
"""
function plot_packet_size_distribution(df::DataFrame)
    p = histogram(
        df[df.Label .== 0, :Packet_Size],
        bins=50,
        alpha=0.5,
        label="Normal",
        color=:green,
        title="Packet Size Distribution",
        xlabel="Packet Size",
        ylabel="Count"
    )
    
    histogram!(
        p,
        df[df.Label .== 1, :Packet_Size],
        bins=50,
        alpha=0.5,
        label="Attack",
        color=:red
    )
    
    return p
end

"""
Plot confusion matrix as a heatmap
"""
function plot_confusion_matrix(confusion_matrix)
    tn, fp, fn, tp = confusion_matrix
    matrix = [tn fp; fn tp]
    labels = ["Normal", "Attack"]
    
    # Create annotation texts
    annotations = [(j, i, matrix[i, j]) for i in 1:2, j in 1:2]
    
    p = heatmap(
        matrix,
        title="Confusion Matrix",
        xlabel="Predicted",
        ylabel="Actual",
        xticks=(1:2, labels),
        yticks=(1:2, labels),
        color=:blues,
        aspect_ratio=:equal
    )
    
    # Add text annotations
    annotate!(p, [(j, i, text(matrix[i,j], :white, 12)) for i in 1:2, j in 1:2]...)
    
    return p
end

"""
Plot request rate patterns
"""
function plot_request_rate_patterns(df::DataFrame)
    p = violin(
        string.(df.Label),
        df.Request_Rate,
        title="Request Rate by Traffic Type",
        xlabel="Traffic Type (0=Normal, 1=Attack)",
        ylabel="Request Rate",
        color=[:green :red],
        legend=false
    )
    
    # Add box plot overlay
    boxplot!(
        p,
        string.(df.Label),
        df.Request_Rate,
        fillalpha=0.5,
        color=[:green :red]
    )
    
    return p
end

"""
Plot protocol-specific metrics
"""
function plot_protocol_metrics(df::DataFrame)
    protocols = unique(df.Protocol)
    metrics = DataFrame(
        Protocol = String[],
        Traffic_Type = String[],
        Avg_Packet_Size = Float64[],
        Avg_Request_Rate = Float64[]
    )
    
    for protocol in protocols
        for label in [0, 1]
            subset = df[(df.Protocol .== protocol) .& (df.Label .== label), :]
            push!(metrics, (
                protocol,
                label == 0 ? "Normal" : "Attack",
                mean(subset.Packet_Size),
                mean(subset.Request_Rate)
            ))
        end
    end
    
    p = groupedbar(
        metrics.Protocol,
        [metrics.Avg_Packet_Size metrics.Avg_Request_Rate],
        group=metrics.Traffic_Type,
        title="Protocol Metrics",
        xlabel="Protocol",
        ylabel="Average Value",
        label=["Packet Size - Normal" "Packet Size - Attack" "Request Rate - Normal" "Request Rate - Attack"],
        bar_position=:dodge,
        color=[:green :red :lightgreen :pink]
    )
    
    return p
end

"""
Create comprehensive visualization report
"""
function create_visualization_report(df::DataFrame, model, X, y, confusion_matrix)
    # Create individual plots
    p1 = plot_protocol_distribution(df)
    p2 = plot_packet_size_distribution(df)
    p3 = plot_confusion_matrix(confusion_matrix)
    p4 = plot_request_rate_patterns(df)
    p5 = plot_protocol_metrics(df)
    
    # Combine plots
    final_plot = plot(
        p1, p2, p3, p4, p5,
        layout=(3,2),
        size=(1200,1500),
        margin=10Plots.mm
    )
    
    # Save plot
    savefig(final_plot, "dos_detection_visualization.png")
    println("Visualization saved as 'dos_detection_visualization.png'")
    
    return final_plot
end

end # module