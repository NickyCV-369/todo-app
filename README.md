Giới thiệu

Ứng dụng Todo List đa nền tảng (Android/iOS/Web) được phát triển bằng Flutter, kết nối với Microservice (REST API + Realtime) để quản lý và đồng bộ dữ liệu.
Ứng dụng hỗ trợ lưu trữ offline, đồng bộ realtime, tìm kiếm, lọc/sắp xếp và thông báo nhắc việc.

- Tính năng

- Hiển thị danh sách công việc (GET API).

- Thêm công việc mới (POST API).

- Chỉnh sửa công việc (PUT/PATCH API).

- Xóa công việc (DELETE API / vuốt để xóa).

- Đánh dấu hoàn thành/chưa hoàn thành.

- Đồng bộ Realtime (WebSocket/Firebase).

- Lưu trữ offline bằng SharedPreferences / Sqflite.

- Tìm kiếm công việc theo tiêu đề/mô tả.

- Lọc & Sắp xếp (theo trạng thái, tiêu đề, ngày).

- Thông báo nhắc nhở khi gần đến hạn.

- Hỗ trợ đa nền tảng: Android, iOS, Web (responsive).

⚙️ Cài đặt & Chạy ứng dụng
1. Clone project
git clone https://github.com/NickyCV-369/todo-app.git
cd todo-app

2. Cài đặt dependencies
flutter pub get

3. Cấu hình backend

Dùng Node.js/FastAPI:

Chạy server backend tại http://localhost:3000:
cd todo_service
npm install
node server.js

API endpoints:

GET /todos

POST /todos

PUT /todos/{id}

DELETE /todos/{id}

4. Chạy trên Mobile
flutter run -d android
flutter run -d ios

5. Chạy trên Web
flutter run -d chrome

🖥️ Demo Video

👉 Link video demo: 

Trong video gồm:

Giới thiệu ứng dụng.

Demo trên mobile và web.

Trình diễn các tính năng: thêm, sửa, xóa, tìm kiếm, lọc, realtime, offline, thông báo.

Giải thích nhanh cấu trúc mã nguồn.

📚 Công nghệ sử dụng

Flutter (Dart) – UI đa nền tảng.

Provider – State management.

http/dio – Gọi REST API.

web_socket_channel / Firebase – Đồng bộ realtime.

shared_preferences / sqflite – Lưu trữ offline.

flutter_local_notifications – Thông báo.
