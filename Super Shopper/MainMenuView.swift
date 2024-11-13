// MainMenuView.swift

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Text("Super Shopper")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                NavigationLink(destination: ContentView()) {
                    VStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.green)
                        Text("New List")
                            .font(.title2)
                            .fontWeight(.medium)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }

                HStack(spacing: 40) {
                    NavigationLink(destination: ViewListsView()) {
                        VStack {
                            Image(systemName: "list.bullet")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)
                            Text("View Lists")
                                .font(.title3)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }

                    NavigationLink(destination: SettingsView()) {
                        VStack {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.orange)
                            Text("Settings")
                                .font(.title3)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                }
            }
            .padding()
            .navigationBarHidden(true)
            .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
