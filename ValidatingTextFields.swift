import SwiftUI
import Foundation

struct ContentView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var userDetails = ""
    @State private var nameError = ""
    
    
    var body: some View {
        
        VStack{
            Form {
                ValidatingTextField( label: "Name :", placeholder: "Enter youe name", text: self.$name,
                             validationMethods: [validateF1]
                             )
                ValidatingTextField(label: "Email Address :" ,placeholder: "Enter your email address", text: self.$email, validationMethods: [validateF1, validateF2])
                ValidatingTextField(label: "User details :" ,placeholder: "Enter what you like", text: self.$userDetails,  validationMethods: [])
                
                Button(action: {
                    print("Validation passed. ")
                }) {
                    Text("Submit Form")
                }
                .disabled((validateF1(name: name)  != nil) || 
                    (validateF1(name: email) != nil) ||
                    (validateF2(name: email) != nil))
                
            }
            .font(.system(size: 15))
        }
    }
}

struct ValidatingTextField: View { 
    var label : String
    var placeholder : String 
    @Binding var text : String 
    var validationMethods: [(_ name: String )  -> String?] 
    
    @State private var focused = false
    @State private var valid = true
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack (spacing:0){
            HStack  {
                Text(label)
                .font(.system(size: 15))
                .frame(width: 110, alignment: .leading)
                .foregroundColor( Color.gray)
                
                TextField(placeholder, text: self.$text, 
                      onEditingChanged: { edit in
                        
                        self.focused = edit
                        if !edit{
                            self.valid = true
                            self.errorMessage.removeAll()
                            for validationMethod in self.validationMethods {
                                let error = validationMethod(self.text)
                                if error == nil { 
                                    self.errorMessage.removeAll()
                                }
                                else{
                                    if (error != nil) {
                                        self.errorMessage.append("\n ")
                                    }
                                    self.errorMessage.append(error ?? "")
                                    self.valid = false
                                }
                            }
                        }
                }
                )
                .textFieldStyle(ValidatingTextfieldStyle( focused: $focused, valid: $valid)).font(.system(size: 15))
            }
            HStack {
                if (!valid  ){ 
                    Spacer()
                        .frame(width: 135, height: 10)
                
                    Text(errorMessage)   
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.red)
                        .lineLimit(nil)
                        .padding(0)
                        .lineSpacing(0)
                }
            }
            .font(.system(size: 12))
        
        }
    }
    }


struct ValidatingTextfieldStyle: TextFieldStyle {
    @Binding var focused: Bool
    @Binding var valid: Bool
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(
                .horizontal, 10)
        .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(whichColor(valid: valid, focused: focused), lineWidth: 2)
                    
        ).padding(5)
            
    }
    
    private func whichColor(valid: Bool, focused: Bool)-> Color {
        if (!valid && !focused) {
            return Color.red
        }
        if focused  {
            return Color.blue
        }
        return Color.gray
    }
}
    
func validateF1(name:String)-> String? {
    if name.isEmpty {
        return "A value is required"
    }
    return nil
}

func validateF2 (name:String)-> String? {
    if name.contains("@") {
        return nil
    }
    return "Must be a valid email address "
}



