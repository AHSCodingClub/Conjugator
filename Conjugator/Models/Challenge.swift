//
//  Challenge.swift
//  Conjugator
//
//  Created by Zheng on 2/13/23.
//

import Foundation

struct Challenge: Hashable {
    var verb: String = ""

    /**
     Should be of length 6 and contain forms for **yo, tú, él/ella/usted, nosotros/nosotras, vosotros/vosotras, and ellos/ellas/ustedes**
     */
    var verbForms: [String] = []

    func getChoices() -> [Choice] {
        switch verbForms.count {
        case 5:
            let choices = [
                Choice(form: .yo, text: verbForms[0]),
                Choice(form: .tu, text: verbForms[1]),
                Choice(form: .el, text: verbForms[2]),
                Choice(form: .nosotros, text: verbForms[3]),
                Choice(form: .ellos, text: verbForms[4]),
            ]
            return choices
        case 6:
            let choices = [
                Choice(form: .yo, text: verbForms[0]),
                Choice(form: .tu, text: verbForms[1]),
                Choice(form: .el, text: verbForms[2]),
                Choice(form: .nosotros, text: verbForms[3]),
                Choice(form: .vosotros, text: verbForms[4]),
                Choice(form: .ellos, text: verbForms[5]),
            ]
            return choices
        default:
            return [
                Choice(form: .yo, text: "Error on this level. Please let your teacher know.")
            ]
        }
    }
}
