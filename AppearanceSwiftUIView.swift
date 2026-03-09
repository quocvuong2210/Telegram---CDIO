import SwiftUI

struct AppearanceSwiftUIView: View {
    @State private var textSize: Double = 14
    @State private var selectedTheme: String = "Classic"
    @State private var selectedIcon: String = "Default"
    
    var body: some View {
        Form {
            Section(header: Text("COLOR THEME").font(.footnote).foregroundColor(.gray)) {
                
                VStack(spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Bob Harris").font(.caption).bold().foregroundColor(.blue)
                            Text("Good morning! 👋").font(.subheadline)
                            Text("Do you know what time it is?").font(.subheadline)
                        }
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Text("It's morning in Tokyo 😎")
                            .font(.subheadline)
                            .padding(10)
                            .background(Color(red: 0.85, green: 0.98, blue: 0.85))
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(Color(red: 0.85, green: 0.92, blue: 0.98))
                .cornerRadius(12)
                .padding(.vertical, 4)
                
                // 1.2 Cuộn ngang chọn Theme
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ThemeOptionView(name: "Classic", color1: .white, color2: .blue, isSelected: selectedTheme == "Classic")
                            .onTapGesture { selectedTheme = "Classic" }
                        ThemeOptionView(name: "Day", color1: .white, color2: .blue, isSelected: selectedTheme == "Day")
                            .onTapGesture { selectedTheme = "Day" }
                        ThemeOptionView(name: "Night", color1: .black, color2: .gray, isSelected: selectedTheme == "Night")
                            .onTapGesture { selectedTheme = "Night" }
                    }
                    .padding(.vertical, 8)
                }
            }
            
            Section {
                NavigationLink(destination: Text("Màn hình Chat Background")) {
                    Text("Chat Background")
                }
                
                NavigationLink(destination: Text("Màn hình Auto-Night Mode")) {
                    HStack {
                        Text("Auto-Night Mode")
                        Spacer()
                        Text("Disabled").foregroundColor(.gray)
                    }
                }
            }
            
            Section(header: Text("TEXT SIZE").font(.footnote).foregroundColor(.gray)) {
                HStack {
                    Text("A").font(.system(size: 12))
                    Slider(value: $textSize, in: 10...24, step: 1)
                        .accentColor(.blue)
                    Text("A").font(.system(size: 20))
                }
            }
            
            Section(header: Text("APP ICON").font(.footnote).foregroundColor(.gray)) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                       
                        AppIconOptionView(name: "Default", icon: "paperplane.circle.fill", isSelected: selectedIcon == "Default")
                            .onTapGesture { selectedIcon = "Default" }
                        AppIconOptionView(name: "Default X", icon: "paperplane.circle.fill", isSelected: selectedIcon == "Default X")
                            .onTapGesture { selectedIcon = "Default X" }
                        AppIconOptionView(name: "Classic", icon: "paperplane.circle.fill", isSelected: selectedIcon == "Classic")
                            .onTapGesture { selectedIcon = "Classic" }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationBarTitle("Appearance", displayMode: .inline)
        // Gắn nút Share góc phải cho giống 100% mẫu
        .navigationBarItems(trailing: Button(action: {
            print("Bấm nút Share")
        }) {
            Image(systemName: "square.and.arrow.up")
        })
    }
}

struct ThemeOptionView: View {
    var name: String
    var color1: Color
    var color2: Color
    var isSelected: Bool
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    .frame(width: 80, height: 60)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.systemGray6)))
                
                VStack(spacing: 4) {
                    HStack {
                        RoundedRectangle(cornerRadius: 8).fill(color1).frame(width: 40, height: 16)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 8).fill(color2).frame(width: 40, height: 16)
                    }
                }.padding(.horizontal, 10)
            }
            Text(name)
                .font(.caption)
                .foregroundColor(isSelected ? .blue : .primary)
        }
    }
}

struct AppIconOptionView: View {
    var name: String
    var icon: String
    var isSelected: Bool
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
                        .padding(-4)
                )
            
            Text(name)
                .font(.caption)
                .foregroundColor(isSelected ? .blue : .primary)
                .padding(.top, 4)
        }
    }
}

struct AppearanceSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AppearanceSwiftUIView()
        }
    }
}
