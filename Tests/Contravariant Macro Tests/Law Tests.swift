import Contravariant_Macro
import Testing
@Contravariant private struct Observers<A> { let first: (A) -> Int; let second: [(A) -> String]; let label: String }
@Test func contravariantIdentityAndReversedComposition() {
    let value = Observers<Int>(first: { $0 * 2 }, second: [String.init], label: "x")
    let identity = value.contramap { $0 }
    let successive = value.contramap { $0 + 1 }.contramap { $0 * 3 }
    let composed = value.contramap { $0 * 3 + 1 }
    for input in [-2, 0, 4] {
        #expect(identity.first(input) == value.first(input))
        #expect(successive.first(input) == composed.first(input))
        #expect(successive.second[0](input) == composed.second[0](input))
    }
}
