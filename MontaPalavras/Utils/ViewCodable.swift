//
//  ViewCodable.swift
//  MontaPalavras
//
//  Created by Pedro Henrique Cavalcante de Sousa on 20/11/20.
//

import UIKit

// MARK: - ViewCodable
/// Protocol that establishes the standard view initialization
protocol ViewCodable {
    /**
     Should be called in your view's init.
     */
    func setupViews()
    
    /**
     Responsible for setting the correct view hierarchy.
     */
    func setupViewHierarchy()
    
    /**
     Responsible for setting each view's constraints.
     */
    func setupConstraints()
    
    /**
     Responsible for setting actions.
     */
    func setupActions()
    
    /**
     Any additional configuration should be set here.
     */
    func setupAditionalConfiguration()
}

extension ViewCodable {
    func setupViews() {
        setupViewHierarchy()
        setupConstraints()
        setupActions()
        setupAditionalConfiguration()
    }
    
    func setupAditionalConfiguration() { }
}
