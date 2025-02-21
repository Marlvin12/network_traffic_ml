module Preprocessing

using DataFrames
using CategoricalArrays
using Statistics

"""
Convert IP address to normalized features
"""
function process_ip_address(ip_str)  
    # Convert to standard String 
    ip_str = String(ip_str)
    
    octets = parse.(Int, split(ip_str, "."))
    first_octet = octets[1]
    
    # Convert to 32-bit integer representation
    ip_int = (octets[1] << 24) + (octets[2] << 16) + (octets[3] << 8) + octets[4]
    
    # Determine if private IP
    is_private = Int(
        (octets[1] == 10) ||  # Class A private
        (octets[1] == 172 && 16 <= octets[2] <= 31) ||  # Class B private
        (octets[1] == 192 && octets[2] == 168)  # Class C private
    )
    
    return ip_int, is_private
end

"""
Calculate protocol-specific features
"""
function get_protocol_features(protocol::AbstractString, packet_size::Number, request_rate::Number)
    # Protocol characteristics
    header_sizes = Dict("TCP" => 20, "UDP" => 8, "ICMP" => 8)
    header_size = header_sizes[String(protocol)]
    
    # Calculate payload and overhead
    payload_size = packet_size - header_size
    overhead_ratio = header_size / packet_size
    
    # Protocol-specific risk factor
    risk_factor = if String(protocol) == "ICMP"
        request_rate > 50 ? 1.0 : 0.5
    elseif String(protocol) == "UDP"
        (packet_size > 150 && request_rate > 30) ? 1.0 : 0.5
    else  # TCP
        (packet_size < 100 && request_rate > 20) ? 1.0 : 0.5
    end
    
    return payload_size, overhead_ratio, risk_factor
end

"""
Preprocess the network traffic data with feature engineering.

# Arguments
- `df::DataFrame`: Input DataFrame with raw network traffic data.

# Returns
- `processed_df::DataFrame`: Preprocessed DataFrame
- `label_dict::Dict`: Dictionary mapping original labels to encoded values
- `feature_cols::Vector{Symbol}`: List of feature column names
"""
function preprocess_data(df::DataFrame)
    # Convert IP columns to standard String type
    df.Source_IP = String.(df.Source_IP)
    df.Destination_IP = String.(df.Destination_IP)
    df.Protocol = String.(df.Protocol)
    
    # Process IP addresses
    src_ip_features = [process_ip_address(ip) for ip in df.Source_IP]
    dst_ip_features = [process_ip_address(ip) for ip in df.Destination_IP]
    
    # Extract IP features
    df.Source_IP_Int = getindex.(src_ip_features, 1)
    df.Source_Is_Private = getindex.(src_ip_features, 2)
    df.Dest_IP_Int = getindex.(dst_ip_features, 1)
    df.Dest_Is_Private = getindex.(dst_ip_features, 2)
    
    # Protocol one-hot encoding
    df.Protocol_TCP = Int.(df.Protocol .== "TCP")
    df.Protocol_UDP = Int.(df.Protocol .== "UDP")
    df.Protocol_ICMP = Int.(df.Protocol .== "ICMP")
    
    # Calculate protocol-specific features
    protocol_features = [
        get_protocol_features(p, s, r) 
        for (p, s, r) in zip(df.Protocol, df.Packet_Size, df.Request_Rate)
    ]
    
    df.Payload_Size = getindex.(protocol_features, 1)
    df.Overhead_Ratio = getindex.(protocol_features, 2)
    df.Risk_Factor = getindex.(protocol_features, 3)
    
    # Traffic pattern features
    df.Request_Intensity = df.Request_Rate .* (1.0 .+ 0.5 .* df.Protocol_TCP)
    
    # Define numeric columns for normalization
    numeric_cols = [
        :Source_IP_Int,
        :Dest_IP_Int,
        :Packet_Size,
        :Request_Rate,
        :Payload_Size,
        :Overhead_Ratio,
        :Request_Intensity,
        :Risk_Factor
    ]
    
    # Normalize numeric columns
    for col in numeric_cols
        col_data = df[!, col]
        μ = mean(col_data)
        σ = std(col_data)
        df[!, col] = (col_data .- μ) ./ (σ + eps())
    end
    
    # Binary/categorical columns don't need normalization
    feature_cols = vcat(
        numeric_cols,
        [:Protocol_TCP, :Protocol_UDP, :Protocol_ICMP,
         :Source_Is_Private, :Dest_Is_Private]
    )
    
   
    df.Label = categorical(df.Label)
    
    # Create label dictionary
    unique_labels = sort(unique(df.Label))
    label_dict = Dict(i => label for (i, label) in enumerate(unique_labels))
    
    println("Preprocessing complete:")
    println("Features generated: ", length(feature_cols))
    println("Numeric features normalized: ", length(numeric_cols))
    println("Protocol features encoded: TCP, UDP, ICMP")
    
    return df, label_dict, feature_cols
end

end