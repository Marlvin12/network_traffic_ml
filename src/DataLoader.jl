module DataLoader

using CSV
using DataFrames

"""
Load network traffic data from a CSV file.
"""
function load_data(filepath::String)
    try
        df = CSV.read(filepath, DataFrame)
        println("Data loaded successfully. Shape: ", size(df))
        println("Columns: ", names(df))  # Print column names
        
        # Print class distribution
        class_counts = combine(groupby(df, :Label), nrow)
        println("\nClass Distribution:")
        println(class_counts)
        
        return df
    catch e
        error("Error loading data: ", e)
    end
end

end  # module DataLoader