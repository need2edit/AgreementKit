//
//  Demo.swift
//  AgreementKit
//
//  Created by Jake Young on 12/29/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import AgreementKit

extension Agreement {
    
    public struct Example {
        
        
        static func alert(affirmativeConsent: Bool) -> Agreement {
            return Agreement(title: "Terms & Conditions", message: "This is a primary agreement using the .alert style. \n\n Do you understand?", style: .alert, requiresAffirmativeConsent: affirmativeConsent, continueLabel: "I get it!", cancelLabel: "Nope!")
        }
        
        static func textbox(affirmativeConsent: Bool, navigationPosition: Agreement.NavigationPosition) -> Agreement {
            
            let style = Agreement.Style.multipart(navigationPosition: navigationPosition)
            
            return Agreement(title: "Terms & Conditions", message: "This is a primary agreement. The text box style is designed for a few paragraphs of text. \n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus non pharetra ipsum, quis semper neque. Cras ac ante sapien. Etiam non felis fermentum, fermentum erat in, volutpat diam. Cras a metus maximus, mattis erat ac, eleifend velit. Maecenas nec lacus sodales, imperdiet quam sit amet, elementum est. Aliquam ipsum ligula, pretium sollicitudin justo ut, vestibulum vehicula tellus. Vivamus feugiat mauris nec leo pharetra ullamcorper. \n\nQuisque nulla lorem, eleifend id nisl eget, ultrices consequat dolor. Phasellus purus erat, semper eget neque ut, sodales congue diam. Nullam accumsan quam sit amet mauris tincidunt suscipit. Nullam pellentesque egestas nisi vel cursus. Integer massa ex, posuere vitae sollicitudin sit amet, bibendum sit amet mi. Vivamus ut fermentum nunc, quis venenatis mauris. Duis non sagittis dolor. In bibendum feugiat ex sit amet luctus. Vivamus imperdiet egestas mauris, sit amet eleifend sem. Nullam elementum lacus eleifend dapibus maximus. Integer a mi nisi. Integer non massa dictum lectus fringilla malesuada. Cras pellentesque vitae nisl vel tincidunt. Pellentesque a tempus libero, non scelerisque turpis. Nulla sit amet felis et nisl accumsan convallis sed rhoncus dolor. Nam diam velit, vehicula at feugiat nec, ullamcorper vel diam.", style: style, requiresAffirmativeConsent: affirmativeConsent, continueLabel: "I'm Sure", cancelLabel: "Nope!")
            
        }
        
        static func multipart(affirmativeConsent: Bool, navigationPosition: Agreement.NavigationPosition) -> Agreement {
            
            let style = Agreement.Style.multipart(navigationPosition: navigationPosition)
            
            return Agreement(title: "Terms & Conditions", sections: [
                .text("Section 1", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus a lorem nec dui malesuada fringilla ac nec nulla. Fusce iaculis tempus elementum. Maecenas facilisis dui varius urna tincidunt, ut lobortis mi interdum. Integer dapibus lobortis ligula id commodo. Vestibulum varius in mi sit amet cursus."),
                .link("A. Website", URL(string: "https://www.apple.com/")),
                .text("Section 2", "Nulla dictum laoreet turpis, quis ultricies tellus feugiat consequat. Duis ornare efficitur risus vitae aliquet. Phasellus sed condimentum dui, id aliquet tellus. Sed congue massa nibh, vel accumsan erat eleifend sed. Sed nec porttitor ligula, non facilisis massa. Integer porttitor, ante id dignissim accumsan, velit lectus dictum turpis, eu convallis mauris ligula at orci. Morbi sit amet tortor lectus."),
                .link("B. Another Website", URL(string: "https://www.apple.com/")),
                .text("Section 3", "Sed placerat nibh id metus blandit varius. Vivamus et maximus mi. Nulla facilisi. Nullam in justo sed lacus condimentum ultrices sed vitae sem. Cras vestibulum ipsum et posuere interdum. Nunc libero leo, convallis et aliquam at, volutpat quis tortor. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis et nibh leo. Integer rhoncus eget dolor sit amet congue."),
                .link("C. Even Another Website", URL(string: "https://www.apple.com/")),
                .text("Section 4", "Sed placerat nibh id metus blandit varius. Vivamus et maximus mi. Nulla facilisi. Nullam in justo sed lacus condimentum ultrices sed vitae sem. Cras vestibulum ipsum et posuere interdum. Nunc libero leo, convallis et aliquam at, volutpat quis tortor. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis et nibh leo. Integer rhoncus eget dolor sit amet congue. In pretium lorem quis diam eleifend, et varius massa dapibus. Mauris varius neque nunc, eget aliquam eros venenatis vel. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas imperdiet purus id nisi maximus, ac volutpat felis pharetra. Morbi ut fringilla ante. Nulla accumsan, elit ac molestie tristique, metus dolor sollicitudin nibh, non molestie est eros at diam. Maecenas a nisi ut ligula condimentum blandit ut eu est."),
                .callToAction("Send via Email")
                ], style: style, requiresAffirmativeConsent: affirmativeConsent, continueLabel: "I'm Sure", cancelLabel: "Cancel")
        }
    }
    
}
