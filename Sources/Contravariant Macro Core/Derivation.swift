import Type_Algebra_Syntax
public import SwiftSyntax
import SwiftSyntaxBuilder

public enum Derivation {
    public static func expansion(of declaration: some DeclGroupSyntax) -> [DeclSyntax] {
        do {
            return try Type.Syntax.Mapping.members(of: declaration, method: "contramap",
                parameters: [.init("Mapped", backward: "transform")])
        } catch { return [DeclSyntax(stringLiteral: "#error(\(String(reflecting: "@Contravariant " + String(describing: error))))")] }
    }
}
