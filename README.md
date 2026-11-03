# swift-contravariant

Use this package when you have a generic struct that consumes its type parameter, such as a predicate, an observer or a formatter written as stored closures, and you want a derived `contramap` that adapts it to a new input type by pre-composing a transformation. Start from the `@Contravariant` macro. When the struct produces its parameter instead of consuming it, use the covariant macros in swift-functor; when the parameter both enters and leaves, use swift-profunctor or the invariant macro in swift-functor.

## Laws

- The derived `contramap` satisfies the contravariant functor laws: mapping with the identity changes no behaviour, and mapping with one transformation and then another behaves as a single mapping that applies the second transformation first and the first one after it. Composition runs in the reverse order of the calls.
- Every stored property is rebuilt through the memberwise initializer. A property whose type does not mention the parameter is copied unchanged. A property that mentions it is mapped structurally: arrays and optionals element by element, tuples coordinate by coordinate, and function types by pre-composing the transformation on each argument that holds the parameter.
- Each function arrow flips variance. The parameter may appear only in negative position: as a function argument, or as the result of a function that is itself an argument. Any positive occurrence, including a bare stored property of the parameter type, fails expansion with an `#error` saying the parameter is in the wrong variance position.
- Expansion also fails when the declaration is not a struct, when the struct has anything other than exactly one generic parameter without constraints or a where clause, when a property's type wraps the parameter in any generic type other than an array or an optional (a set or a dictionary, for example), or when a function type that mentions the parameter is `throws` or `async`, variadic, or has attributed arguments.
- The derived method has the same access level as the struct, and it always captures the transformation as escaping.
