module Metrics

"""
Manually calculate precision for binary classification.

# Arguments
- `y_true`: True labels
- `y_pred`: Predicted labels

# Returns
- Precision score
"""
function manual_precision(y_true, y_pred)
    # Convert to vectors
    y_true_vec = collect(y_true)
    y_pred_vec = collect(y_pred)

    tp = sum((y_true_vec .== 1) .& (y_pred_vec .== 1))
    predicted_positives = sum(y_pred_vec .== 1)
    
    return predicted_positives > 0 ? tp / predicted_positives : 0.0
end

"""
Manually calculate recall for binary classification.

# Arguments
- `y_true`: True labels
- `y_pred`: Predicted labels

# Returns
- Recall score
"""
function manual_recall(y_true, y_pred)
    # Convert to vectors
    y_true_vec = collect(y_true)
    y_pred_vec = collect(y_pred)
    
    # Compute true positives and actual positives
    tp = sum((y_true_vec .== 1) .& (y_pred_vec .== 1))
    actual_positives = sum(y_true_vec .== 1)
    

    return actual_positives > 0 ? tp / actual_positives : 0.0
end

"""
Compute confusion matrix manually.

# Arguments
- `y_true`: True labels
- `y_pred`: Predicted labels

# Returns
- Confusion matrix components
"""
function manual_confusion_matrix(y_true, y_pred)

    y_true_vec = collect(y_true)
    y_pred_vec = collect(y_pred)
    
    # Compute confusion matrix components
    tn = sum((y_true_vec .== 0) .& (y_pred_vec .== 0))
    fp = sum((y_true_vec .== 0) .& (y_pred_vec .== 1))
    fn = sum((y_true_vec .== 1) .& (y_pred_vec .== 0))
    tp = sum((y_true_vec .== 1) .& (y_pred_vec .== 1))
    
    return (tn, fp, fn, tp)
end

end 