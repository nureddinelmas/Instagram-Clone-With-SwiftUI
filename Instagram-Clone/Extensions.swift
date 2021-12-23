//
//  Extensions.swift
//  Instagram-Clone
//
//  Created by Nureddin Elmas on 2021-12-23.
//

import Foundation
import UIKit

extension String {
    func load() -> UIImage{
        
        do {
            guard let url = URL(string: self) else {
                
                return UIImage()
            }
            
            let data : Data = try Data(contentsOf: url)
            
            return UIImage(data: data) ?? UIImage()
            
        }catch {
            
        }
        
        
        return UIImage()
    }
}

