module Preprocessing

using DataFrames
using CategoricalArrays

"""
Preprocess the network traffic data with feature engineering.

# Arguments
- `df::DataFrame`: Input DataFrame with raw network traffic data.

# Returns
- `processed_df::DataFrame`: Preprocessed DataFrame
- `label_dict::Dict`: Dictionary mapping original labels to encoded values
"""
function preprocess_data(df::DataFrame)
    # Protocol one-hot encoding
    df.Protocol_TCP = Int.(df.Protocol .== "TCP")
    df.Protocol_UDP = Int.(df.Protocol .== "UDP")
    df.Protocol_ICMP = Int.(df.Protocol .== "ICMP")

    # IP address feature extraction (simple numeric encoding)
    df.Source_IP_Numeric = parse.(Int, replace.(df.Source_IP, r"\D" => ""))
    df.Destination_IP_Numeric = parse.(Int, replace.(df.Destination_IP, r"\D" => ""))

    # Advanced interaction features
    df.Packet_Rate_Interaction = df.Packet_Size .* df.Request_Rate
    df.IP_Protocol_Interaction = df.Source_IP_Numeric .* df.Protocol_TCP

    # Identify numeric columns for normalization
    numeric_cols = [
        :Packet_Size, 
        :Request_Rate, 
        :Source_IP_Numeric, 
        :Destination_IP_Numeric,
        :Protocol_TCP,
        :Protocol_UDP,
        :Protocol_ICMP,
        :Packet_Rate_Interaction,
        :IP_Protocol_Interaction
    ]
    
    # Normalize numeric columns
    for col in numeric_cols
        df[!, col] = (df[!, col] .- mean(df[!, col])) ./ std(df[!, col])
    end

    # Create label dictionary
    unique_labels = unique(df.Label)
    label_dict = Dict(i => label for (i, label) in enumerate(unique_labels))
    
    # Ensure labels are categorical with explicit levels
    df.Label = categorical(df.Label, levels=sort(unique(df.Label)))

    println("Preprocessing complete.")
    println("Unique labels: ", unique_labels)
    println("Numeric columns used: ", numeric_cols)

    return df, label_dict, numeric_cols
end

end  