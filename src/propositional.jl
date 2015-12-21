# Simple propositional logic

module PropositionalLogic

using ..LogicBase

export PropositionalVariable, BinaryConnective, assignments, ⊢

abstract Formula

immutable PropositionalVariable <: Formula
    var::Symbol
end

immutable Negate <: Formula
    f::Formula
end

immutable BinaryConnective{T} <: Formula
    x::Formula
    y::Formula
end

function Base.writemime(io::IO, ::MIME"text/plain", pv::PropositionalVariable)
    print(io, pv.var)
end

function Base.writemime(io::IO, ::MIME"text/plain", n::Negate)
    print(io, '¬')
    writemime(io, "text/plain", n.f)
end

function Base.writemime{T}(io::IO, ::MIME"text/plain", bc::BinaryConnective{T})
    print(io, '(')
    writemime(io, "text/plain", bc.x)
    print(io, ' ', T, ' ')
    writemime(io, "text/plain", bc.y)
    print(io, ')')
end

immutable Assignment
    table::Dict{PropositionalVariable, Bool}
end

assign(a::Assignment, v::PropositionalVariable) = a.table[v]
assign(a::Assignment, n::Negate) = ¬assign(a, n.f)
assign(a::Assignment, c::BinaryConnective{:∧}) =
    assign(a, c.x) && assign(a, c.y)
assign(a::Assignment, c::BinaryConnective{:∨}) =
    assign(a, c.x) || assign(a, c.y)
assign(a::Assignment, c::BinaryConnective{:⇒}) = assign(a, c.x) ⇒ assign(a, c.y)
assign(a::Assignment, c::BinaryConnective{:⇔}) = assign(a, c.x) ⇔ assign(a, c.y)

immutable AssignmentIterator
    over::Vector{PropositionalVariable}
end

Base.start(ai::AssignmentIterator) = UInt(1) << length(ai.over)
function Base.next(ai::AssignmentIterator, state::UInt)
    state -= 1
    len = length(ai.over)
    assignmentdata = [
        v => state & (UInt(1) << (len - i)) ≠ 0
        for (i, v) in enumerate(ai.over)]
    Assignment(assignmentdata), state
end
Base.done(ai::AssignmentIterator, state::UInt) = state == UInt(0)

vars(v::PropositionalVariable) = Set([v])
vars(n::Negate) = vars(n.f)
vars(bc::BinaryConnective) = vars(bc.x) ∪ vars(bc.y)

assignments(vs::Vector{PropositionalVariable}) = AssignmentIterator(vs)
assignments(vs::Set{PropositionalVariable}) = assignments(collect(vs))
assignments(f::Formula) = assignments(vars(f))
assignments(f::Formula, g::Formula) = assignments(vars(f) ∪ vars(g))
assignments(vs::Vector{Formula}) = assignments(foldl(∪, Set(), vs))

#= Tautology & Entailment =#
⊢(::Tuple{}, f::Formula) = all(a -> assign(a, f), assignments(f))
⊢(f::Formula, g::Formula) =
    all(a -> assign(a, f) ⇒ assign(a, g), assignments(f, g))
⊢(fs, g::Formula) = all(a -> ¬assign(a, g) ∧ ¬⋀(map(f -> assign(a, f), fs)))

#= Convenience Functions =#
LogicBase. ¬(f::Formula) = Negate(f)
LogicBase. ∧(f::Formula, g::Formula) = BinaryConnective{:∧}(f, g)
LogicBase. ∨(f::Formula, g::Formula) = BinaryConnective{:∨}(f, g)
LogicBase. ⊻(f::Formula, g::Formula) = BinaryConnective{:⊻}(f, g)
LogicBase. ⇒(f::Formula, g::Formula) = BinaryConnective{:⇒}(f, g)
LogicBase. ⇔(f::Formula, g::Formula) = BinaryConnective{:⇔}(f, g)

end
