# 📸 ỐNG KÍNH NGÔN NGỮ

**Ứng dụng học ngôn ngữ thông minh – sử dụng camera và AI để nhận diện, dịch, và lưu trữ kiến thức theo cách tự nhiên nhất.**

---

## 🌍 Giới thiệu

**Ống Kính Ngôn Ngữ** là ứng dụng Flutter kết hợp **AI (Google ML Kit)** và **các mô hình ngôn ngữ** để giúp bạn học ngoại ngữ thông qua thế giới xung quanh.  
Chỉ cần đưa camera lên — ứng dụng sẽ **nhận diện vật thể, văn bản, dịch ngữ nghĩa**, và hỗ trợ **ghi âm, phát âm, lưu từ vựng, luyện tập bằng quiz**.

Mục tiêu là biến **việc học ngôn ngữ trở nên sinh động**, tương tác và thực tế — giống như bạn đang sống trong môi trường ngôn ngữ đó.

---

## ⚙️ Tính năng nổi bật

- 📷 **Nhận diện vật thể & văn bản** trong thời gian thực bằng **Google ML Kit**
- 🌐 **Dịch tự động** sang ngôn ngữ hệ thống hoặc ngôn ngữ bạn chọn
- 💾 **Lưu trữ từ vựng, mẫu câu** và **tự động sắp xếp theo chủ đề**
- 🗣️ **Chuyển đổi giọng nói ↔ văn bản** (Speech to Text & Text to Speech)
- 🎯 **Quiz – bài kiểm tra nhanh** để ôn tập từ vựng đã học
- 🧠 **Phân tích & đánh giá kết quả nhận diện** từ camera (score, độ chính xác mô hình)
- 🖼️ **Xử lý ảnh tĩnh & stream camera** với tính toán:
    - Khoảng cách, scale, rotation
    - Overlay vật thể & bounding box
    - Vẽ và cập nhật vùng nhận diện theo frame
- 🔒 **Lưu trữ cục bộ** an toàn bằng Hive
- 💫 Giao diện động, hiệu ứng mượt với animation và overlay tùy biến

---

## 🧩 Công nghệ & Kiến trúc

- **Ngôn ngữ:** Flutter (Dart)
- **Kiến trúc:** Clean Architecture + BLoC pattern
- **Quản lý dependency:** `get_it`
- **Lưu trữ:** Hive
- **AI & Xử lý ngôn ngữ:**
    - `google_mlkit_object_detection`
    - `google_mlkit_text_recognition`
    - `google_mlkit_translation`
    - `speech_to_text`
    - `flutter_tts`
- **Xử lý camera & ảnh:**
    - `camera`
    - `image_cropper`
    - `image_picker`
- **Khác:** animation, localization, permission handler, v.v.

---

## 🧠 Luồng xử lý chính

1. **Camera Stream** → Nhận diện vật thể & văn bản bằng ML Kit
2. **AI Engine** → Xử lý kết quả, dịch sang ngôn ngữ hệ thống
3. **Data Layer** → Lưu từ/câu vào Hive
4. **Quiz Engine** → Sinh câu hỏi ôn tập ngẫu nhiên
5. **Speech Layer** →
    - Văn bản → Giọng nói (`flutter_tts`)
    - Giọng nói → Văn bản (`speech_to_text`)
6. **Overlay Renderer** → Hiển thị bounding box, label, confidence score

---

## 🧰 Cấu trúc dự án (ví dụ)

