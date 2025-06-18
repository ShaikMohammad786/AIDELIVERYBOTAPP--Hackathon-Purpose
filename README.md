
# 🚚 Delivery Request App — HackVyuha Winner 🏆

An innovative, real-time delivery request management system built during the **HackVyuha National Hackathon** — hosted by **SRM AP University** and **GeeksForGeeks** — where it proudly secured **1st Place**.  
The project combines a **FastAPI** backend and a **Flutter (Dart)** frontend with IoT capabilities to validate robot access codes and facilitate intelligent delivery flow.

---

## 🌟 Highlights

- 🥇 **National Hackathon 1st Prize Winner**
- ⚡ Fast, secure, and scalable REST API using FastAPI + JWT
- 📱 Sleek mobile frontend with Flutter
- 🤖 Raspberry Pi integration via TCP sockets for real-world robot validation
- 🔒 Access code verification for delivery bot control
- 💰 Seamless booking and payment flow
- 🌐 MongoDB for persistent user data

---

## 📦 Tech Stack

| Layer        | Technology           | Description                             |
|--------------|----------------------|-----------------------------------------|
| Backend      | FastAPI (Python)     | Secure RESTful APIs, JWT Auth, TCP Comm |
| Frontend     | Flutter (Dart)       | Mobile UI/UX for end-users              |
| Database     | MongoDB              | Stores users, sessions, metadata        |
| IoT Comm     | TCP Socket (Python)  | Raspberry Pi control & communication    |
| Auth         | OAuth2 + JWT         | Token-based login and session security  |

---

## 🛠️ Features

### 🔐 Authentication
- **Register/Login** with secure hashing (`bcrypt`)
- **JWT-based access tokens** for authenticated sessions

### 📡 Robot Access Code
- Generate & share a dynamic **6-digit code**
- Validate user input via backend call to Raspberry Pi (TCP)
- Only allow delivery after code is successfully validated

### 📦 Delivery Booking
- Users can book deliveries in a few taps
- Select delivery slots and input destinations

### 💳 Payment Integration
- Fake/mock payment screen to simulate real-world flow

### 🧾 Profile & Session Handling
- Retrieve current user profile from JWT
- Error handling for unauthorized access

---

## 🚀 Quickstart

### 📂 Project Structure

📦 DeliveryRequestApp/
├── backend/
│   └── main.py                         # FastAPI backend logic
├── frontend/
│   ├── main.dart                       # Flutter entry point
│   ├── pubspec.yaml                    # Flutter dependencies
│   ├── screens/                        # App screens
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── accesscode_screen.dart
│   │   ├── bookdelivery_screen.dart
│   │   ├── payment_screen.dart
│   ├── widgets/                        # Custom UI components
│   │   ├── animated_button.dart
│   │   ├── glass_card.dart
├── lib/                                # Flutter main lib folder
│   └── main.dart
├── assets/                             # Animation and background assets
│   ├── code_anim.json
│   ├── code_bg.json
│   ├── delivery_anim.json
│   ├── delivery_bg.json
│   ├── denied.json
│   ├── payment_anim.json
│   ├── payment_bg.json
│   ├── robot_login.json
│   ├── robot_register.json
│   ├── success.json
├── test/
│   └── widget_test.dart                # Sample widget test
├── pubspec.lock
├── README.md                           # Project overview and documentation
├── ios/                                # iOS specific build and config files
├── android/                            # Android build outputs and config
├── linux/                              # Linux-specific Flutter files
├── macos/                              # macOS-specific Flutter files
├── windows/                            # Windows-specific Flutter files
├── web/                                # Web build and assets

---

### 🔧 Setup Instructions

#### 💡 Backend (FastAPI)

1. **Install Dependencies**
   ```bash
   pip install fastapi uvicorn pymongo python-jose[cryptography] passlib[bcrypt]
   ```

2. **Run Backend**
   ```bash
   uvicorn main:app --reload
   ```

> ⚙️ Ensure MongoDB is running locally (`mongodb://localhost:27017`)

---

#### 📱 Frontend (Flutter)

1. **Install Flutter** ([Guide](https://docs.flutter.dev/get-started/install))
2. **Get Dependencies**
   ```bash
   flutter pub get
   ```
3. **Run App**
   ```bash
   flutter run
   ```

---

## 🔒 API Endpoints

| Method | Endpoint       | Description                      |
|--------|----------------|----------------------------------|
| POST   | `/register`     | Register new user                |
| POST   | `/login`        | Login and get JWT token          |
| GET    | `/profile`      | Get user profile from token      |
| GET    | `/get_code`     | Get current robot access code    |
| POST   | `/verify`       | Verify access code via Raspberry Pi |

---

## 🤖 Robot Access Code Logic

The FastAPI backend communicates with a Raspberry Pi over a TCP connection using a specific IP and port:

```python
with socket.create_connection((PI_IP, PI_PORT), timeout=5) as s:
    s.sendall(code.encode())
    response = s.recv(1024).decode()
```

Expected reply:
- `"SUCCESS"` — access granted
- Any other — access denied

---



## 🏁 Achievements

- 🥇 **Won National HackVyuha Hackathon 2024**  
- 💡 Developed in under 14 hours  
- 🚀 Successfully demonstrated end-to-end delivery flow with Raspberry Pi validation

---



## 📬 Contact

**Shaik Mohammad**  
**skmohammad378@gmail.com**
**9391970347**

## 🧠 Future Enhancements

- Add real-time tracking using GPS & Flutter Maps
- OTP or QR-based validation instead of simple access code
- Admin dashboard for delivery insights
- Integration with Razorpay or UPI for real payments

---

## 📄 License

MIT License. Free to use and modify.

---

## 💚 Built with Passion at HackVyuha by SRM AP × GeeksForGeeks
