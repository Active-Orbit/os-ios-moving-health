//
//  BottomNavItemComponent.swift
//  App
//
//  Created by George Stavrou on 25/07/2023.
//

import UIKit

public class BottomNavItemComponent: BaseComponent {
    
    @IBOutlet weak var image: BaseImageView!

    
    public override func onViewPrepared() {
        super.onViewPrepared()
    }
    
    public override func getXibName() -> String {
        return "BottomNavItemComponent"
    }
    
    
    func setImage(_ image: String) {
        self.image.image = ImageProvider.get(image)
    }
    


}
