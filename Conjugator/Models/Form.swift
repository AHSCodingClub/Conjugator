//
//  Form.swift
//  Conjugator
//
//  Created by Zheng on 2/13/23.
//

import Foundation

/// An enumeration for possible verb forms
enum Form: CaseIterable {
    case yo
    case tu
    case el
    case nosotros
    case vosotros
    case ellos

    static func random(includeVosotros: Bool) -> Form {
        let allCases: [Form] = {
            if includeVosotros {
                return Form.allCases
            } else {
                return Form.allCases.filter { $0 != .vosotros }
            }
        }()

        return allCases.randomElement() ?? .yo
    }

    var title: String {
        switch self {
        case .yo:
            return "Yo"
        case .tu:
            return "Tú"
        case .el:
            return "Él/Ella/Usted"
        case .nosotros:
            return "Nosotros"
        case .vosotros:
            return "Vosotros"
        case .ellos:
            return "Ellos"
        }
    }
}
