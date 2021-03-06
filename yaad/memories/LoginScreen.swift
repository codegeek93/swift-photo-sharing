//
//  LoginScreen.swift
//  memories
//
//  Created by Huỳnh Văn Cao Tín on 11/27/19.
//  Copyright © 2019 Toan Nguyen Dinh. All rights reserved.
//

import SwiftUI

struct LoginScreen: View {
    @State var email: String = ""
    @State var password: String = ""
    @Binding var isLogin: Bool
    @State var onChange: Bool = false
    @Binding var isScreenLogin: Bool
    @EnvironmentObject var store: Store
    var body: some View {
        VStack{
            VStack{
                Spacer()
                Image("share")
                    .resizable()
                    .frame(width: 100, height: 100)
                Text("Member Login")
                    .font(.title)
                    .bold()
                    .padding()
                Spacer()
                VStack(alignment: .leading){
                    TextField("Email", text: $email)
                        .padding()
                        .autocapitalization(.none)
                    if !isValidEmail(emailStr: self.email) && self.onChange {
                        Text("Email is invalid!")
                            .foregroundColor(.red)
                            .padding(5)
                    }
                    SecureField("Password", text: $password)
                        .padding()
                        .shadow(radius: 8)
                    
                    if password.count < 3 && self.onChange {
                        Text("Password is invalid!")
                            .foregroundColor(.red)
                        .padding(5)
                    }

                }
                Button(action:{
                    withAnimation{
                        self.onChange = true
                        print(isValidEmail(emailStr: self.email) && self.onChange)
                        if isValidEmail(emailStr: self.email) && self.onChange {
                            Network.shared.apollo.perform(mutation: LoginMutation(email: self.email, password: self.password)) { result in
                                switch result {
                                    case .success:
                                        guard let data = try? result.get().data else { return }
                                        self.isLogin = true
                                        UserManager.shared.hasAuthenticatedUser = true
                                        UserManager.shared.currentAuthToken = data.login.id
                                        UserDefaults.standard.set(data.login.id, forKey: "authToken")
                                        self.store.onLoadData()
                                    case .failure:
                                        print(result)
                                }
                            }
                        }
                    }
                }){
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding([.top, .bottom], 10)
                        .background(Color.black)
                }
                Spacer()
                HStack{
                    Text("Don't have an account?")
                    Button(action:{
                        withAnimation{
                            self.isScreenLogin.toggle()
                        }
                    }){
                        Text("Register here")
                            .foregroundColor(.blue)
                    }.padding()
                }.padding()
                Spacer()
            }
        }.padding(20)
        .onAppear(){
            self.isLogin = Network.shared.checkAuthentication()
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    @State static var isLogin: Bool = false
    @State static var isScreenLogin: Bool = true
    static var previews: some View {
        LoginScreen(isLogin: $isLogin, isScreenLogin: $isScreenLogin)
    }
}
