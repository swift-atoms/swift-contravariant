import Type_Algebra_Syntax
public import SwiftSyntax
import SwiftSyntaxBuilder

public enum Derivation {
    public static func expansion(of structure: StructDeclSyntax) -> [DeclSyntax] {
        do {
            let shape = try GenericProduct(structure, arity: 1)
            let parameters = shape.parameters
            let fields = shape.properties.fields
            let forward: [String: String] = [:]
            let backward: [String: String] = [parameters[0]: "transform"]
            let arguments = try fields.enumerated().map { index, field in
                field.name + ": " + (try MappingExpression.apply(shape.fields[index], to: "self.\(field.name)", forward: forward, backward: backward))
            }.joined(separator: ", ")
            return [DeclSyntax(stringLiteral: """
                \(shape.access)func contramap<Mapped>(_ transform: @escaping (Mapped) -> \(parameters[0])) -> \(structure.name.text)<Mapped> {
                    \(structure.name.text)<Mapped>(\(arguments))
                }
                """)]
        } catch { return [DeclSyntax(stringLiteral: "#error(\(String(reflecting: "@Contravariant " + String(describing: error))))")] }
    }
}
