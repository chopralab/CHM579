

function feature_importance( node :: DecisionTree.Leaf, a... )
    # Do nothing
end

function feature_importance( node :: DecisionTree.Node, mapping = Dict{Int, Int}() )

    my_depth = depth(node)
    mapping[node.featid] = my_depth
    feature_importance(node.left, mapping)
    feature_importance(node.right,mapping)

    mapping
end

function bootstrap_importance( features, labels; runs = 10000, kwargs... )

    all_mappings = Dict{Int, Int}()
    models = []
    self_accuracy = []

    for i in 1:runs
        current_model = DecisionTreeClassifier(;kwargs...)
        fit!(current_model, features, labels)

        accuracy = sum(predict(current_model, features) .== labels) / length(labels)

        append!(self_accuracy, [accuracy])

        mapping = feature_importance(current_model.root)
        for (feat,val) in mapping
            if !haskey(all_mappings,feat)
                all_mappings[feat] = 0
            end
            all_mappings[feat] += val
        end

        append!(models, [current_model])
    end

    all_mappings, models, self_accuracy
end

function custom_confusion_matrix(y_true::Vector{String}, y_pred::Vector{Any})
    labels = unique([y_true; y_pred])
    n_labels = length(labels)
    conf_matrix = zeros(Int, n_labels, n_labels)

    for (t, p) in zip(y_true, y_pred)
        true_idx = findfirst(==(t), labels)
        pred_idx = findfirst(==(p), labels)
        conf_matrix[true_idx, pred_idx] += 1
    end

    return conf_matrix
end


function cohen_kappa(conf_matrix::Array{Int, 2})
    n = sum(conf_matrix)
    p_observed = sum([conf_matrix[i, i] for i in 1:size(conf_matrix, 1)]) / n
    p_expected = sum([sum(conf_matrix[i, :]) * sum(conf_matrix[:, i]) for i in 1:size(conf_matrix, 1)]) / (n^2)

    return (p_observed - p_expected) / (1 - p_expected)
end


function loocv(train_matrix, train_res, cutoff; kwargs...)
    num_samples = size(train_matrix, 2)
    train_hot = Int.(train_res .> cutoff) .+ 1
    tree = DecisionTreeClassifier(;kwargs...)

    loocv_res = []

    h = ["nohit", "hit"]
    for test_col in 1:num_samples
        train_temp = train_matrix[:, 1:num_samples .!= test_col]
        test_temp = train_matrix[:, test_col]
        fit!(tree, train_temp' |> Matrix, h[train_hot[1:num_samples .!= test_col]])
        res = predict(tree, test_temp' |> Matrix)
        append!(loocv_res, res)
    end

    # confusmat(h[train_hot], loocv_res)
    conf_mat = custom_confusion_matrix(h[train_hot], loocv_res)
    kappa = cohen_kappa(conf_mat)
end

function bootstrap_test_predictions(train_matrix, train_res, test_matrix, cutoff; use_proba = true, runs = 10, kwargs...)
    h = ["nohit", "hit"]

    train_hot = Int.(train_res .> cutoff) .+ 1

    tree = DecisionTreeClassifier(;kwargs...)

    model_test_results = []
    model_train_results = []
    for i in 1:runs
        fit!(tree, train_matrix' |> Matrix, h[train_hot])

        test_res = use_proba ? predict_proba(tree, test_matrix' |> Matrix)[:,1] : predict(tree, test_matrix' |> Matrix) .== "hit"
        train_res = sum(predict(tree, train_matrix' |> Matrix) .== h[train_hot])

        append!(model_test_results, [test_res])
        append!(model_train_results, [train_res])
    end

    model_test_results = hcat(model_test_results...)

    reduce(+, model_test_results, dims = 2) ./ runs, model_train_results
end

function bootstrap_all(train_matrix, train_res, test_matrix; seed=12345, kwargs...)

    Random.seed!(seed)

    test_preds = []
    train_preds = []
    valid_results = []
    for i in 0.1:0.1:0.9
        println(i)
        test, train = bootstrap_test_predictions(train_matrix, train_res, test_matrix, i; kwargs...)
        append!(test_preds, [test])
        append!(train_preds, [maximum(train)] / length(train_res))

        # validation = [loocv(train_matrix, train_res, i).kappa for j in 1:100]
        validation = [loocv(train_matrix, train_res, i) for j in 1:100]
        append!(valid_results, [maximum(validation)])
    end

    vcat(vcat(hcat(test_preds...), train_preds'), valid_results')
end

nothing

