

push!(LOAD_PATH, "./src")

using Pipeline

const CSV_PATH = "network_traffic.csv"

function main()
    if !isfile(CSV_PATH)
        error("Could not find CSV file at: $CSV_PATH")
    end
    
    println("Starting DoS Detection Pipeline...")
    
    try
        model, evaluation_results, confusion_matrix = Pipeline.run_pipeline(CSV_PATH)
        

        println("\nModel Evaluation Results:")
        for (metric, value) in pairs(evaluation_results)
            println("$metric: $value")
        end
        
        println("\nConfusion Matrix:")
        tn, fp, fn, tp = confusion_matrix
        println("True Negatives: $tn")
        println("False Positives: $fp")
        println("False Negatives: $fn")
        println("True Positives: $tp")
        
    catch e
        println("Error during pipeline execution:")
        println(e)
        rethrow(e)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end