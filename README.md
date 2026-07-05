# Hệ Thống Quản Lý Trung Tâm Tin Học

## 1. Giới thiệu dự án

**Hệ thống Quản lý Trung tâm Tin học** là đồ án môn học Phân tích và Thiết kế Hệ thống Thông tin, được thực hiện nhằm phân tích, thiết kế và minh họa một hệ thống hỗ trợ quản lý hoạt động tại trung tâm đào tạo tin học.

Hệ thống hướng đến việc thay thế quy trình quản lý thủ công bằng Excel và hồ sơ giấy, giúp dữ liệu được lưu trữ tập trung, hạn chế sai sót, hỗ trợ tra cứu nhanh và cung cấp báo cáo phục vụ công tác quản lý.

## 2. Bài toán đặt ra

Hoạt động quản lý tại trung tâm tin học thường bao gồm nhiều nghiệp vụ như tiếp nhận học viên, ghi danh khóa học, xếp lớp, quản lý giảng viên, lập lịch học, thu học phí, điểm danh, nhập điểm và lập báo cáo.

Nếu các nghiệp vụ này được xử lý thủ công, dữ liệu dễ bị phân mảnh, khó tra cứu, dễ sai sót và khó tổng hợp báo cáo. Vì vậy, dự án đề xuất xây dựng một hệ thống thông tin quản lý tập trung nhằm tối ưu hóa quy trình vận hành của trung tâm.

## 3. Mục tiêu dự án

- Phân tích hiện trạng quản lý tại trung tâm tin học.
- Xác định các yêu cầu chức năng và phi chức năng của hệ thống.
- Xây dựng mô hình Use Case cho các nhóm người dùng.
- Thiết kế cơ sở dữ liệu bằng ERD và mô hình dữ liệu logic.
- Thiết kế mô hình xử lý bằng BFD và DFD.
- Minh họa giao diện hệ thống cho các chức năng chính.
- Hỗ trợ quản lý học viên, khóa học, lớp học, giảng viên, tài chính và báo cáo thống kê.

## 4. Vai trò thực hiện

- Khảo sát và phân tích hiện trạng nghiệp vụ.
- Xác định tác nhân và chức năng hệ thống.
- Đặc tả Use Case cho các nghiệp vụ chính.
- Thiết kế mô hình dữ liệu ERD.
- Thiết kế mô hình phân rã chức năng BFD.
- Thiết kế mô hình luồng dữ liệu DFD.
- Xây dựng dữ liệu mẫu và giao diện chương trình minh họa.
- Hoàn thiện báo cáo phân tích và thiết kế hệ thống.

## 5. Công nghệ và công cụ sử dụng

- UML
- Use Case Diagram
- ERD
- BFD
- DFD
- SQL / SQL Server
- C#
- Draw.io / công cụ vẽ mô hình
- Microsoft Word

## 6. Đối tượng sử dụng hệ thống

- Quản trị viên
- Quản lý
- Nhân viên
- Giảng viên
- Học viên
- Ngân hàng / hệ thống thanh toán

## 7. Chức năng chính

### Quản lý hệ thống
- Đăng nhập, đăng xuất
- Đổi mật khẩu
- Quản lý tài khoản người dùng
- Phân quyền theo vai trò

### Quản lý học viên
- Thêm, sửa, xóa thông tin học viên
- Tìm kiếm và xem thông tin học viên
- Ghi danh học viên vào khóa học và lớp học

### Quản lý giảng viên
- Quản lý hồ sơ giảng viên
- Phân công giảng viên phụ trách lớp học
- Theo dõi lịch dạy

### Quản lý đào tạo
- Quản lý khóa học
- Quản lý lớp học
- Quản lý lịch học
- Kiểm tra trùng lịch học và lịch dạy

### Quản lý tài chính
- Lập hóa đơn học phí
- Theo dõi trạng thái thanh toán
- Quản lý lịch sử giao dịch

### Nghiệp vụ giảng dạy
- Xem lịch dạy
- Điểm danh học viên
- Nhập điểm học viên

### Báo cáo và thống kê
- Báo cáo doanh thu
- Thống kê số lượng học viên
- Báo cáo kết quả học tập
- Xuất file báo cáo

## 8. Mô hình phân tích thiết kế

### Use Case tổng thể

![Use Case tổng thể](diagrams/use-case-tong-the.png)

### Mô hình phân rã chức năng BFD

![BFD](diagrams/bfd.png)

### DFD mức 0

![DFD mức 0](diagrams/dfd-muc-0.png)

### DFD mức 1

![DFD mức 1](diagrams/dfd-muc-1.png)

### Mô hình ERD

![ERD](diagrams/erd.png)

## 9. Một số giao diện minh họa

### Màn hình đăng nhập

![Màn hình đăng nhập](screenshots/dang-nhap.png)

### Màn hình chính

![Màn hình chính](screenshots/man-hinh-quan-ly.png)

### Quản lý học viên

![Quản lý học viên](screenshots/quan-ly-hoc-vien.png)

### Quản lý giảng viên

![Quản lý giảng viên](screenshots/quan-ly-giang-vien.png)

### Quản lý khóa học

![Quản lý khóa học](screenshots/quan-ly-khoa-hoc.png)

### Quản lý lớp học

![Quản lý lớp học](screenshots/quan-ly-lop-hoc.png)

### Quản lý tài chính

![Quản lý tài chính](screenshots/quan-ly-tai-chinh.png)

### Ghi danh học viên

![Ghi danh học viên](screenshots/ghi-danh.png)

### Báo cáo thống kê

![Báo cáo thống kê](screenshots/bao-cao-thong-ke.png)
