module Pipeline

using DataFrames
using MLJ

include("DataLoader.jl")
include("Preprocessing.jl")
include("ModelTraining.jl")

"""
Main function to orchestrate the entire machine learning pipeline.

# Arguments
- `filepath::String`: Path to the input CSV file

# Returns
- Trained model and evaluation results
"""
function run_pipeline(filepath::String)
    # Load data
    df = DataLoader.load_data(filepath)
    
    println("\nPreprocessing data...")
    df_processed, label_dict, feature_cols = Preprocessing.preprocess_data(df)
    
    # Prepare features and labels
    X = (; (col => df_processed[!, col] for col in feature_cols)...)
    y = df_processed.Label
    
    # Create and evaluate model
    println("\nTraining Random Forest model...")
    model = ModelTraining.create_model()
    
    # Perform cross-validation and get metrics
    evaluation_results, confusion_matrix = ModelTraining.evaluate_model(model, X, y)
    
    println("\nModel Evaluation Results:")
    for (metric, value) in pairs(evaluation_results)
        println("$metric: ", value)
    end
    
    return model, evaluation_results, confusion_matrix
end

end