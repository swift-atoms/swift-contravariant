import Contravariant_Macro_Core
public import SwiftSyntax
public import SwiftSyntaxMacros

public struct Macro: MemberMacro {}

extension Macro {
    public static func expansion(
        of _: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo _: [TypeSyntax],
        in _: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let declaration = declaration.as(StructDeclSyntax.self) else {
            throw MacroExpansionErrorMessage(
                "@Contravariant applies to a generic struct declaration only."
            )
        }
        return Derivation.expansion(of: declaration)
    }
}
