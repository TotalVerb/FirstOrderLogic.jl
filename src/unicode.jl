@reexport module LogicBase

export ¬, ∧, ∨, ⊻, ⇒, ⇔

"""
    ¬(x::Bool) → Bool

A logical "not". Return `false` if the given argument is `true`, and return
`true` if the given argument is `false`.
"""
¬(x::Bool) = ~x

"""
    ∧(x::Bool, y::Bool) → Bool

A logical "and" that does not short-circuit. Return `true` if both arguments are
`true`, and `false` otherwise.
"""
∧(x::Bool, y::Bool) = x & y

"""
    ∨(x::Bool, y::Bool) → Bool

A logical "or" that does not short-circuit. Return `true` if at least one
argument is `true`, and `false` otherwise.
"""
∨(x::Bool, y::Bool) = x | y

"""
    ⊻(x::Bool, y::Bool) → Bool

A logical "exclusive or". Return `true` if exactly one argument is `true`, and
`false` otherwise.
"""
⊻(x::Bool, y::Bool) = x $ y

"""
    ⇒(x::Bool, y::Bool) → Bool

A logical "implies". Return `true` if the first argument is `false`, or if the
second argument is `true`. Return `false` if the first argument is `true` and
the second argument is `false`.
"""
⇒(x::Bool, y::Bool) = ~x | y

"""
    ⇔(x::Bool, y::Bool) → Bool

A logical "if and only if". Return `true` if the first argument is the same as
the second argument.
"""
⇔(x::Bool, y::Bool) = x ≡ y

end  # module
