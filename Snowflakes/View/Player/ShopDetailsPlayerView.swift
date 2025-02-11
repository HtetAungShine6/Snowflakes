import SwiftUI
import PhotosUI
import Mantis

struct ShopDetailsPlayerView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var getTeamDetailVM = GetTeamDetailByRoomCode()
    
    @State private var team: Team? = nil
    
    @State private var selectedImage: UIImage?
    @State private var croppedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showImageCropper = false

    let playerRoomCode: String
    
    @State private var notifications: [NotificationItem] = [
        NotificationItem(message: "You purchased Pen (x2) and Paper (x3)", amount: 10, color: Color.white, isChecked: false),
        NotificationItem(message: "You purchased Pen (x1) and Paper (x1)", amount: 5, color: Color.white, isChecked: false),
        NotificationItem(message: "You have received 5 Dollars by selling snowflake.", amount: 5, color: Color.white, isChecked: false)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            backButton
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    teamLabel
                    
                    items
                    
                    notificationList
                    
                    uploadImageSection
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .top)
                .background(Color.white)
            }
            .refreshable {
                if let teamNumber = UserDefaults.standard.value(forKey: "TeamDetail-\(playerRoomCode)") as? Int {
                    getTeamDetailVM.fetchTeams(playerRoomCode: playerRoomCode, teamNumber: teamNumber)
                }
            }
        }
        .background(Color.white)
        .navigationBarBackButtonHidden()
        .onAppear {
            if let teamNumber = UserDefaults.standard.value(forKey: "TeamDetail-\(playerRoomCode)") {
                getTeamDetailVM.fetchTeams(playerRoomCode: playerRoomCode, teamNumber: teamNumber as! Int)
            }
        }
        .onReceive(getTeamDetailVM.$team) { team in
            self.team = team
        }
    }
    
    // MARK: - Back Button (Private Function)
    private var backButton: some View {
        Button(action: {
            navigationManager.pop()
        }) {
            HStack {
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
            }
        }
        .padding(.leading, 10)
        .padding(.top, 10)
    }
    
    // MARK: - Team Label (Private Function)
    private var teamLabel: some View {
        HStack {
            VStack(alignment: .leading) {
                if let teamNumber = team?.teamNumber {
                    Text("Team: \(teamNumber)")
                        .font(.custom("Lato-Bold", size: 20))
                } else {
                    Text("No Team Found")
                        .font(.custom("Lato-Bold", size: 20))
                }
                HStack {
                    Text("Balance: ")
                        .font(.custom("Lato-Regular", size: 15))
                    Image("tokenCoin")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    if let tokens = team?.tokens {
                        Text("\(String(describing: tokens)) tokens")
                            .font(.custom("Lato-Regular", size: 15))
                    } else {
                        Text("No tokens found")
                            .font(.custom("Lato-Regular", size: 15))
                    }
                }
            }
            Spacer()
            if let teamStocks = team?.teamStocks {
                ForEach(teamStocks, id: \.self) { item in
                    VStack {
                        Image(item.productName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("\(item.remainingStock)x")
                            .font(.custom("Lato-Regular", size: 16))
                            .foregroundStyle(Color.gray)
                    }
                }
            }
        }
        .padding(.horizontal, 10)
    }
    
    // MARK: - Items List
    private var items: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Buy")
                    .font(.custom("Lato", size: 22).weight(.medium))
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    if let teamStocks = team?.teamStocks {
                        ForEach(teamStocks, id: \.self) { item in
                            PlayerShopItemView(imageName: item.productName, title: "\(item.remainingStock) x \(item.productName) left")
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    
    // MARK: - Notification List
    private var notificationList: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Notifications")
                .font(Font.custom("Lato", size: 22).weight(.medium))
                .foregroundColor(.black)
                .padding(.bottom, 10)
            
            ScrollView {
                ForEach(notifications.indices, id: \.self) { index in
                    let notification = notifications[index]
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(notification.message)
                                .font(Font.custom("Poppins", size: 13))
                                .foregroundColor(.black)
                                .lineLimit(2)
                            
                            Text("Total amount: \(notification.amount) tokens")
                                .font(Font.custom("Poppins", size: 10))
                                .tracking(1.5)
                                .foregroundColor(.black)
                                .opacity(0.65)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            notifications[index].isChecked.toggle()
                            notifications[index].color = notifications[index].isChecked ? AppColors.frostBlue : Color.white
                        }) {
                            Image(systemName: notifications[index].isChecked ? "checkmark.circle.fill" : "checkmark.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(notifications[index].isChecked ? Color.green : Color.gray)
                                .padding(5)
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .background(notification.color)
                    .cornerRadius(12)
                    .shadow(radius: 5, x: 0, y: 2)
                    .frame(height: 55)
                }
            }
        }
        .padding(.horizontal, 10)
    }
    
    // MARK: - Upload Image Section
    private var uploadImageSection: some View {
        VStack {
            Text("Sell your Snowflake")
                .font(Font.custom("Lato", size: 22).weight(.medium))
                .foregroundColor(.black)
            
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 199, height: 238)
                    .background(Color.white.opacity(0.50))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 0.25)
                    )
                
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 199, height: 238)
                        .cornerRadius(20)
                } else {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                }
            }
            .onTapGesture {
                showImagePicker = true
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, showImagePicker: $showImagePicker, showImageCropper: $showImageCropper)
        }
        .fullScreenCover(isPresented: $showImageCropper) {
            if let image = selectedImage {
                ImageCropper(image: image, croppedImage: $croppedImage, isPresented: $showImageCropper)
            }
        }
    }
}

// MARK: - Image Picker (Select from Photo Library)
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var showImagePicker: Bool
    @Binding var showImageCropper: Bool

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                print("Image picked: \(uiImage)") // Debugging log
                
                DispatchQueue.main.async {
                    self.parent.selectedImage = uiImage
                    self.parent.showImageCropper = true // Trigger cropper after selecting image
                }
            }
            parent.showImagePicker = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

// MARK: - Image Cropper (Using Mantis)
struct ImageCropper: UIViewControllerRepresentable {
    var image: UIImage
    @Binding var croppedImage: UIImage?
    @Binding var isPresented: Bool

    class Coordinator: NSObject, CropViewControllerDelegate {
        var parent: ImageCropper

        init(parent: ImageCropper) {
            self.parent = parent
        }

        // Called when cropping succeeds
        func cropViewControllerDidCrop(
            _ cropViewController: Mantis.CropViewController,
            cropped: UIImage,
            transformation: Mantis.Transformation,
            cropInfo: Mantis.CropInfo
        ) {
            DispatchQueue.main.async {
                self.parent.croppedImage = cropped // Update the cropped image
                self.parent.isPresented = false // Dismiss cropper
                print("Image cropped successfully") // Debugging log
            }
        }

        // Called when cropping fails
        func cropViewControllerDidFailToCrop(
            _ cropViewController: Mantis.CropViewController,
            original: UIImage
        ) {
            DispatchQueue.main.async {
                self.parent.isPresented = false // Dismiss cropper if fail
                print("Failed to crop image") // Debugging log
            }
        }

        // Called when the user cancels cropping
        func cropViewControllerDidCancel(
            _ cropViewController: Mantis.CropViewController,
            original: UIImage
        ) {
            DispatchQueue.main.async {
                self.parent.isPresented = false // Dismiss cropper
                print("User canceled cropping") // Debugging log
            }
        }

        // Called when resizing starts
        func cropViewControllerDidBeginResize(_ cropViewController: Mantis.CropViewController) {
            print("User started resizing the crop area") // Debugging log
        }

        // Called when resizing ends
        func cropViewControllerDidEndResize(
            _ cropViewController: Mantis.CropViewController,
            original: UIImage,
            cropInfo: Mantis.CropInfo
        ) {
            print("User finished resizing the crop area") // Debugging log
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> Mantis.CropViewController {
        let cropViewController = Mantis.cropViewController(image: image)
        cropViewController.delegate = context.coordinator // Set the coordinator as delegate
        return cropViewController
    }

    func updateUIViewController(_ uiViewController: Mantis.CropViewController, context: Context) {}
}


#Preview {
    ShopDetailsPlayerView(playerRoomCode: "ABCDEF")
}
