# Network Traffic DoS Detection System

## Project Overview
This project implements a machine learning pipeline for detecting Denial of Service (DoS) attacks in network traffic using Random Forest classification.

## Current Model Performance

### Metrics Summary
- **Accuracy**: 0.9849 (98.49%)
- **Precision**: 0.971 (97.1%)
- **Recall**: 0.9998 (99.98%)
- **F1 Score**: 0.9852 (98.52%)

### Confusion Matrix
- True Negatives: 4835
- False Positives: 150
- False Negatives: 1
- True Positives: 5014

### Class Distribution
- Total Samples: 10,000
- Normal Traffic (0): 4,985 samples (49.85%)
- DoS Attack (1): 5,015 samples (50.15%)

## Project Structure
```
project_root/
├── src/
│   ├── DataLoader.jl      # Data loading and initial processing
│   ├── Preprocessing.jl   # Feature engineering and data preprocessing
│   ├── ModelTraining.jl   # Random Forest model implementation
│   ├── Pipeline.jl        # Main pipeline orchestration
│   ├── Metrics.jl         # Custom evaluation metrics
│   └── Visualizations.jl  # Data and results visualization
├── main.jl                # Main execution script
├── visualize_results.jl   # Visualization script
└── network_traffic.csv    # Dataset
```

## Features
Current implementation includes:
- IP address feature extraction (private/public, network class)
- Protocol-specific features (TCP, UDP, ICMP)
- Traffic pattern analysis
- Packet size and request rate processing
- Automated visualization generation

## Key Findings
1. Excellent Overall Performance:
   - Near-perfect accuracy (98.49%)
   - Extremely high F1 score (98.52%)

2. Near-Perfect Attack Detection:
   - Outstanding recall (99.98%)
   - Only 1 missed attack out of 5,015 total attacks
   - Extremely low false negative rate

3. Strong Normal Traffic Classification:
   - High precision (97.1%)
   - Only 150 false positives out of 4,985 normal samples
   - Balanced dataset (approximately 50/50 distribution)

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

![dos_detection_visualization](https://github.com/user-attachments/assets/2907d3b9-1a1e-4be9-8acb-a0a39234fe2a)

## Future Improvements
1. Feature Engineering:
   - Enhanced IP address feature extraction
   - More sophisticated protocol analysis
   - Time-based pattern detection

2. Model Optimization:
   - Hyperparameter tuning
   - Ensemble methods exploration
   - Deep learning approaches for comparison

3. System Enhancements:
   - Real-time detection capabilities
   - Enhanced visualization options
   - Performance optimization for large-scale deployment

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.
