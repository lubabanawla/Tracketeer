import SwiftUI


struct VolunteerEntry: Identifiable, Codable {
    var id = UUID()
    var projectName: String
    var hours: Double
    var photoData: Data?
}

struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                    parent.selectedImageData = imageData
                }
            }
            parent.isImagePickerPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isImagePickerPresented = false
        }
    }

    @Binding var isImagePickerPresented: Bool
    @Binding var selectedImageData: Data?

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary // You can change this to .camera if you want to allow taking photos
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct HomeScreen: View {
    @State private var totalHours: Double = 0
    @State private var postText = ""
    @State private var newEntry = VolunteerEntry(projectName: "", hours: 0.0, photoData: nil)
    @State private var entries: [VolunteerEntry] = []
    
    // State for image picker
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImageData: Data? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Circle with total hours
                    ZStack {
                        Circle()
                            .fill(Color.purple.opacity(0.2))
                            .frame(width: 150, height: 150)

                        VStack {
                            Text("\(calculateTotalHours(), specifier: "%.1f")")
                                .font(.system(size: 36, weight: .bold))
                            Text("Total Hours")
                                .font(.subheadline)
                        }
                    }
                    .padding(.top)

                    // Form for adding new entries
                    VStack {
                        TextField("Project Name", text: $newEntry.projectName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Hours", text: Binding(
                            get: { String(format: "%.2f", newEntry.hours) },
                            set: { if let value = Double($0) { newEntry.hours = value } }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)

                        Button("Select Photo") {
                            isImagePickerPresented = true
                        }
                        .padding()

                        // Display selected image if available
                        if let imageData = selectedImageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding()
                        }

                        HStack {
                            Button("Add Entry") {
                                addEntry()
                            }
                            .padding()

                            Button("Clear Fields") {
                                clearFields()
                            }
                            .padding()

                            Button("Reset All") {
                                resetAllEntries()
                            }
                            .padding()
                            .foregroundColor(.red)
                        }
                    }
                    .padding()

                    // List of entries
                    LazyVStack(spacing: 10) {
                        ForEach(entries) { entry in
                            HStack {
                                Text(entry.projectName)
                                Spacer()
                                Text("\(entry.hours, specifier: "%.1f") hours")
                                if let photoData = entry.photoData, let uiImage = UIImage(data: photoData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    Spacer(minLength: 0)
                }
            }
            .navigationTitle("Volunteer Hours")
        }
        .onAppear {
            loadEntries()
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(isImagePickerPresented: $isImagePickerPresented, selectedImageData: $selectedImageData)
        }
    }
    
    private func addEntry() {
        newEntry.photoData = selectedImageData // Attach selected photo data to the current entry
        totalHours += newEntry.hours
        entries.append(newEntry)
        newEntry = VolunteerEntry(projectName: "", hours: 0.0, photoData: nil)
        selectedImageData = nil
        saveEntries()
    }
    
    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: "entries") {
            if let decodedEntries = try? JSONDecoder().decode([VolunteerEntry].self, from: data) {
                entries = decodedEntries
                totalHours = calculateTotalHours() // Update total hours when loading entries
            }
        }
    }
    
    private func saveEntries() {
        if let encodedData = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encodedData, forKey: "entries")
        }
    }
    
    private func calculateTotalHours() -> Double {
        return entries.reduce(0) { $0 + $1.hours }
    }
    
    private func clearFields() {
        newEntry.projectName = ""
        newEntry.hours = 0.0
        selectedImageData = nil
    }
    
    private func resetAllEntries() {
        entries.removeAll()
        totalHours = 0.0
        saveEntries()
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}

