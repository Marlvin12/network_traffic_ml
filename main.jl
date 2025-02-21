# Main entry point for the network traffic ML 

push!(LOAD_PATH, "./src")

using Pipeline

CSV_PATH = "network_traffic.csv"

function main()
    model, evaluation_results, confusion_matrix = Pipeline.run_pipeline(CSV_PATH)
end

main()