# Simple propositional logic

module PropositionalLogic

export PropositionalVariable, BinaryConnective

abstract Formula

immutable PropositionalVariable <: Formula
    var::Symbol
end

immutable BinaryConnective{T} <: Formula
    x::Formula
    y::Formula
end

immutable Assignment
    table::Dict{PropositionalVariable, Bool}
end

assign(a::Assignment, v::PropositionalVariable) = a.table[v]
assign(a::Assignment, c::BinaryConnective{:∧}) =
    assign(a, c.x) && assign(a, c.y)
assign(a::Assignment, c::BinaryConnective{:∨}) =
    assign(a, c.x) || assign(a, c.y)
assign(a::Assignment, c::BinaryConnective{:⇒}) = assign(a, c.x) ⇒ assign(a, c.y)
assign(a::Assignment, c::BinaryConnective{:⇔}) = assign(a, c.x) ⇔ assign(a, c.y)

function assignments(vs::PropositionalVariable...)
end

end
