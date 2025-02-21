using DataFrames
using CSV


push!(LOAD_PATH, "./src")


using Pipeline
using Preprocessing
using Visualizations

function main()
    # Load and process data
    CSV_PATH = "network_traffic.csv"
    model, evaluation_results, confusion_matrix = Pipeline.run_pipeline(CSV_PATH)
    
    # Load original data for visualization
    df = CSV.read(CSV_PATH, DataFrame)
    
    # Get processed features and labels
    processed_df, _, feature_cols = Preprocessing.preprocess_data(df)
    X = (; (col => processed_df[!, col] for col in feature_cols)...)
    y = processed_df.Label
    
    # Create visualizations
    println("\nGenerating visualizations...")
    plot = Visualizations.create_visualization_report(
        df, 
        model, 
        X, 
        y, 
        confusion_matrix
    )
    
    println("\nVisualization complete! Check 'dos_detection_visualization.png'")
end


if abspath(PROGRAM_FILE) == @__FILE__
    main()
end