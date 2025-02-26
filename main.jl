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
        
        # Manually calculate the correct accuracy from the confusion matrix
        tn, fp, fn, tp = confusion_matrix
        manual_accuracy = round((tp + tn) / (tp + tn + fp + fn), digits=4)
        
        # Update the evaluation results with the correct accuracy
        if haskey(evaluation_results, :accuracy)
            evaluation_results[:mlj_accuracy] = evaluation_results[:accuracy]
            evaluation_results[:accuracy] = manual_accuracy
        else
            evaluation_results[:accuracy] = manual_accuracy
        end

        println("\nModel Evaluation Results:")
        for (metric, value) in pairs(evaluation_results)
            if metric == :mlj_accuracy
                println("$metric: $value (original MLJ calculation)")
            elseif metric == :accuracy
                println("$metric: $value (corrected calculation)")
            else
                println("$metric: $value")
            end
        end
        
        println("\nConfusion Matrix:")
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