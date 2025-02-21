module ModelTraining

using MLJ
using MLJDecisionTreeInterface
using StableRNGs
using Statistics
using CategoricalArrays

include("Metrics.jl")

"""
Random Forest model for classification.
"""
function create_model()
    RandomForestClassifier = @load RandomForestClassifier pkg=DecisionTree
    
    model = RandomForestClassifier(
        n_trees=300,               
        max_depth=25,           
        min_samples_split=3,       
        min_samples_leaf=2,        
        n_subfeatures=-1,     
        sampling_fraction=0.75,    
        rng=42                     
    )
    
    return model
end

"""
model performance using cross-validation.

# Arguments
- `model`: MLJ model to evaluate
- `X`: Feature matrix
- `y`: Target labels

# Returns
- Named tuple with evaluation metrics
"""
function evaluate_model(model, X, y)
    
    y = categorical(y, levels=sort(unique(y)))
    
    # cross-validation
    rng = StableRNG(42)
    resampling = CV(nfolds=5, shuffle=true)
    
    # Manually compute class frequencies
    unique_labels = unique(y)
    class_counts = Dict(
        label => sum(y .== label) 
        for label in unique_labels
    )
    
    # Perform cross-validation
    evaluations = evaluate(model, X, y; 
        resampling, 
        measure=[accuracy],
        verbosity=0,
        check_measure=false
    )
    

    mach = machine(model, X, y)
    fit!(mach)
    
    # Make predictions
    y_pred = predict_mode(mach, X)
    
    # Compute confusion matrix manually
    tn, fp, fn, tp = Metrics.manual_confusion_matrix(y, y_pred)
    

    calc_precision = Metrics.manual_precision(y, y_pred)
    calc_recall = Metrics.manual_recall(y, y_pred)
    f1_score = 2 * (calc_precision * calc_recall) / (calc_precision + calc_recall)
    

    println("\nClass Frequencies:")
    for (label, count) in class_counts
        println("Label $label: $count samples")
    end
    
    println("\nConfusion Matrix:")
    println("True Negatives: ", tn)
    println("False Positives: ", fp)
    println("False Negatives: ", fn)
    println("True Positives: ", tp)
    
    println("\nDetailed Metrics:")
    println("Precision: ", round(calc_precision, digits=4))
    println("Recall: ", round(calc_recall, digits=4))
    println("F1 Score: ", round(f1_score, digits=4))
    
   
    metrics = Dict(
        :accuracy => round(mean(evaluations.measurement), digits=4),
        :precision => round(calc_precision, digits=4),
        :recall => round(calc_recall, digits=4),
        :f1_score => round(f1_score, digits=4)
    )
    
    return metrics, (tn, fp, fn, tp)
end

end  