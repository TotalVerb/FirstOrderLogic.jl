using FirstOrderLogic
if VERSION ≥ v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

# test all boolean operations
@testset "¬" begin
    @test ¬true  ≡ false
    @test ¬false ≡ true
end

@testset "∧" begin
    @test true  ∧ true  ≡ true
    @test true  ∧ false ≡ false
    @test false ∧ true  ≡ false
    @test false ∧ false ≡ false
end

@testset "∨" begin
    @test true  ∨ true  ≡ true
    @test true  ∨ false ≡ true
    @test false ∨ true  ≡ true
    @test false ∨ false ≡ false
end

@testset "⊻" begin
    @test true  ⊻ true  ≡ false
    @test true  ⊻ false ≡ true
    @test false ⊻ true  ≡ true
    @test false ⊻ false ≡ false
end

@testset "⇒" begin
    @test true  ⇒ true  ≡ true
    @test true  ⇒ false ≡ false
    @test false ⇒ true  ≡ true
    @test false ⇒ false ≡ true
end

@testset "⇔" begin
    @test true  ⇔ true  ≡ true
    @test true  ⇔ false ≡ false
    @test false ⇔ true  ≡ false
    @test false ⇔ false ≡ true
end
