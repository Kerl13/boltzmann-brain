-- Input specification for a "tuned" Motzkin tree sampler.

@precision 1.0e-12
@maxiter   30

-- Sampler-specific annotations.
@lowerBound   1000
@upperBound   2000

@generate     Motzkin
@samples      10

Motzkin = Leaf
        | Unary Motzkin [0.45]
        | Binary Motzkin Motzkin.
