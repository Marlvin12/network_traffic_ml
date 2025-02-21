# Network Traffic Attack Classification

## Project Overview

This project implements a machine learning pipeline for network traffic attack classification using Random Forest algorithm.

## Current Model Performance

### Metrics Summary
- **Accuracy**: 0.7482 (74.82%)
- **Precision**: 0.7679 (76.79%)
- **Recall**: 1.0 (100%)
- **F1 Score**: 0.8687 (86.87%)

### Detailed Analysis
The current model shows:
- Perfect recall (identifies all positive instances)
- Moderate precision (76.79% of predicted attacks are actual attacks)
- Overall accuracy of 74.82%

## Class Distribution
- Total Samples: 10,000
- Negative Class (0): 2,514 samples (25.14%)
- Positive Class (1): 7,486 samples (74.86%)

## Challenges and Limitations
1. **Class Imbalance**: Significant skew in class distribution
2. **High False Positive Rate**: 2,263 false positives out of 2,514 negative samples
3. Limited feature engineering

## Recommended Next Steps

### 1. Feature Engineering
- Extract more domain-specific features
- Create advanced interaction features
- Analyze feature importance

### 2. Handling Class Imbalance
- Implement advanced resampling techniques
  - SMOTE (Synthetic Minority Over-sampling Technique)
  - Class weights
  - Undersampling majority class

### 3. Model Improvements
- Experiment with hyperparameter tuning
- Try alternative algorithms
  - Gradient Boosting
  - Support Vector Machines
  - Ensemble methods

### 4. Advanced Techniques
- Cross-validation with stratification
- Hyperparameter optimization
- Ensemble model creation

## Potential Feature Expansion
- Extract more information from:
  - Timestamp
  - IP address characteristics
  - Protocol-specific details
  - Packet-level interactions

## Technical Requirements
- Julia 1.6+
- Key Dependencies:
  - MLJ
  - DataFrames
  - DecisionTree.jl

## Running the Project
```bash
julia main.jl
```

## Future Work
1. Develop more sophisticated feature extraction
2. Implement advanced anomaly detection techniques
3. Create a real-time classification system
4. Develop model interpretability tools

## Contributions
Contributions are welcome! Please open an issue or submit a pull request.

## License
[Add your license information]
