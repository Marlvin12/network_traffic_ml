# Network Traffic DoS Detection System

## Project Overview
This project implements a machine learning pipeline for detecting Denial of Service (DoS) attacks in network traffic using Random Forest classification.

## Current Model Performance

### Metrics Summary
- **Accuracy**: 0.7481 (74.81%)
- **Precision**: 0.773 (77.3%)
- **Recall**: 1.0 (100%)
- **F1 Score**: 0.872 (87.2%)

### Confusion Matrix
- True Negatives: 316
- False Positives: 2198
- False Negatives: 0
- True Positives: 7486

### Class Distribution
- Total Samples: 10,000
- Normal Traffic (0): 2,514 samples (25.14%)
- DoS Attack (1): 7,486 samples (74.86%)

## Project Structure
```
project_root/
├── src/
│   ├── DataLoader.jl      # Data loading and initial processing
│   ├── Preprocessing.jl   # Feature engineering and data preprocessing
│   ├── ModelTraining.jl   # Random Forest model implementation
│   ├── Pipeline.jl        # Main pipeline orchestration
│   ├── Metrics.jl        # Custom evaluation metrics
│   └── Visualizations.jl  # Data and results visualization
├── main.jl               # Main execution script
├── visualize_results.jl  # Visualization script
└── network_traffic.csv   # Dataset
```

## Features
Current implementation includes:
- IP address feature extraction (private/public, network class)
- Protocol-specific features (TCP, UDP, ICMP)
- Traffic pattern analysis
- Packet size and request rate processing
- Automated visualization generation

## Key Findings
1. Perfect Recall (1.0):
   - Model catches all DoS attacks
   - No false negatives

2. Moderate Precision (0.773):
   - Some false positives
   - Room for improvement in normal traffic classification

3. Class Imbalance Impact:
   - Dataset is imbalanced (75% attacks)
   - Affects model's ability to classify normal traffic

## Technical Requirements
- Julia 1.11+
- Required Packages:
  ```julia
  using Pkg
  Pkg.add([
      "MLJ",
      "MLJDecisionTreeInterface",
      "DataFrames",
      "CSV",
      "Plots",
      "StatsPlots",
      "CategoricalArrays",
      "StableRNGs"
  ])
  ```

## Usage
1. Clone the repository
2. Install dependencies
3. Run the main script:
   ```julia
   julia> include("main.jl")
   ```
4. Generate visualizations:
   ```julia

   ![dos_detection_visualization](https://github.com/user-attachments/assets/67c7206e-7799-49ef-a715-705e02229dcb)

   julia> include("visualize_results.jl")
   julia> main()
   ```

## Visualization Outputs
The visualization script generates comprehensive plots including:
- Protocol distribution analysis
- Packet size distributions
- Confusion matrix visualization
- Request rate patterns
- Protocol-specific metrics

## Future Improvements
1. Feature Engineering:
   - Enhanced IP address feature extraction
   - More sophisticated protocol analysis
   - Time-based pattern detection

2. Model Optimization:
   - Address class imbalance
   - Hyperparameter tuning
   - Ensemble methods exploration

3. System Enhancements:
   - Real-time detection capabilities
   - Enhanced visualization options
   - Performance optimization

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.
