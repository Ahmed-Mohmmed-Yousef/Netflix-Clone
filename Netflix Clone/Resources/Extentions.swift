//
//  Extentions.swift
//  Netflix Clone
//
//  Created by Ahmed on 28/05/2022.
//

import Foundation


extension String {
    func capitalizeFirstLatter() -> String {
        return self.prefix(1).capitalized + self.lowercased().dropFirst()
    }
}
