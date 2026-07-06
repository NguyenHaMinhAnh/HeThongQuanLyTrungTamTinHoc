CREATE TRIGGER trg_Check_SiSo_LopHoc
ON LOP_HOC
AFTER INSERT, UPDATE
AS
BEGIN
    -- Kiểm tra nếu cột SiSo bị cập nhật (tối ưu hiệu suất cho lệnh UPDATE)
    IF UPDATE(SiSo)
    BEGIN
        -- Nếu tồn tại bất kỳ dòng dữ liệu nào mới thêm/sửa có Sĩ số < 0
        IF EXISTS (SELECT 1 FROM inserted WHERE SiSo < 0)
        BEGIN
            -- Báo lỗi và hoàn tác giao dịch (Hủy bỏ lệnh Thêm/Sửa)
            RAISERROR(N'Lỗi Ràng buộc R1: Sĩ số lớp học phải lớn hơn hoặc bằng 0.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;

CREATE TRIGGER trg_Check_TongTien_HoaDon
ON HOA_DON
AFTER INSERT, UPDATE
AS
BEGIN
    -- Tối ưu hóa: Chỉ chạy logic kiểm tra nếu cột TongTien bị tác động
    IF UPDATE(TongTien)
    BEGIN
        -- Tìm xem có hóa đơn nào mới được thêm/sửa mà Tổng tiền < 0 hay không
        IF EXISTS (SELECT 1 FROM inserted WHERE TongTien < 0)
        BEGIN
            -- Nếu có, ném ra thông báo lỗi và hoàn tác toàn bộ thao tác
            RAISERROR(N'Lỗi Ràng buộc R2: Tổng tiền hóa đơn phải lớn hơn hoặc bằng 0.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;

CREATE TRIGGER trg_Check_SDT_HocVien
ON HOC_VIEN
AFTER INSERT, UPDATE
AS
BEGIN
    -- Chỉ chạy kiểm tra khi cột SDT bị thêm hoặc sửa
    IF UPDATE(SDT)
    BEGIN
        -- Kiểm tra độ dài khác 10 HOẶC có chứa ký tự không phải là số (0-9)
        IF EXISTS (
            SELECT 1 
            FROM inserted 
            WHERE LEN(SDT) <> 10 OR SDT LIKE '%[^0-9]%'
        )
        BEGIN
            RAISERROR(N'Lỗi Ràng buộc R3: Số điện thoại học viên phải bao gồm đúng 10 chữ số.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;
CREATE TRIGGER trg_Check_SDT_GiangVien
ON GIANG_VIEN
AFTER INSERT, UPDATE
AS
BEGIN
    IF UPDATE(SDT)
    BEGIN
        IF EXISTS (
            SELECT 1 
            FROM inserted 
            WHERE LEN(SDT) <> 10 OR SDT LIKE '%[^0-9]%'
        )
        BEGIN
            RAISERROR(N'Lỗi Ràng buộc R3: Số điện thoại giảng viên phải bao gồm đúng 10 chữ số.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;

CREATE TRIGGER trg_Check_ThoiGian_LichHoc
ON LICH_HOC
AFTER INSERT, UPDATE
AS
BEGIN
    -- Chỉ chạy kiểm tra khi một trong hai cột Giờ bắt đầu hoặc Giờ kết thúc bị thay đổi
    IF UPDATE(GioBatDau) OR UPDATE(GioKetThuc)
    BEGIN
        -- Tìm xem có dữ liệu nào vi phạm (Giờ bắt đầu lớn hơn hoặc bằng Giờ kết thúc)
        IF EXISTS (
            SELECT 1 
            FROM inserted 
            WHERE GioBatDau >= GioKetThuc
        )
        BEGIN
            -- Ném ra thông báo lỗi và hoàn tác
            RAISERROR(N'Lỗi Ràng buộc R4: Giờ bắt đầu phải nhỏ hơn giờ kết thúc.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;

CREATE TRIGGER trg_Check_TenKH_Unique
ON KHOA_HOC
AFTER INSERT, UPDATE
AS
BEGIN
    -- Tối ưu hóa: Chỉ chạy khi cột Tên Khóa Học (TenKH) bị tác động
    IF UPDATE(TenKH)
    BEGIN
        -- Kiểm tra xem trong bảng KHOA_HOC có Tên khóa học nào (vừa được thêm/sửa)
        -- xuất hiện lớn hơn 1 lần hay không
        IF EXISTS (
            SELECT TenKH 
            FROM KHOA_HOC 
            WHERE TenKH IN (SELECT TenKH FROM inserted)
            GROUP BY TenKH 
            HAVING COUNT(TenKH) > 1
        )
        BEGIN
            -- Nếu có trùng lặp, báo lỗi và hoàn tác giao dịch
            RAISERROR(N'Lỗi Ràng buộc R5: Tên khóa học là duy nhất, không được trùng lặp.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;
CREATE TRIGGER trg_Check_DangKyLopHoc_Unique
ON DANG_KY
AFTER INSERT, UPDATE
AS
BEGIN
    -- Chỉ kiểm tra khi có sự thay đổi ở cột Mã học viên hoặc Mã lớp học
    IF UPDATE(MaHV) OR UPDATE(MaLH)
    BEGIN
        -- Kết hợp bảng DANG_KY với bảng tạm inserted để tìm xem có cặp (MaHV, MaLH) 
        -- nào vừa được thêm/sửa mà xuất hiện nhiều hơn 1 lần trong bảng hay không
        IF EXISTS (
            SELECT dk.MaHV, dk.MaLH 
            FROM DANG_KY dk
            INNER JOIN inserted i ON dk.MaHV = i.MaHV AND dk.MaLH = i.MaLH
            GROUP BY dk.MaHV, dk.MaLH 
            HAVING COUNT(*) > 1
        )
        BEGIN
            -- Ném ra lỗi và hoàn tác thao tác
            RAISERROR(N'Lỗi Ràng buộc R6: Mỗi học viên chỉ được đăng ký vào một lớp học một lần duy nhất.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;

CREATE TRIGGER trg_Check_NgayDangKy_DangKy
ON DANG_KY
AFTER INSERT, UPDATE
AS
BEGIN
    -- Chỉ chạy khi cột NgayDangKy hoặc MaLH bị tác động
    IF UPDATE(NgayDangKy) OR UPDATE(MaLH)
    BEGIN
        -- Kết nối bảng inserted (chứa dữ liệu đang đăng ký) với bảng LOP_HOC
        -- Để kiểm tra xem có ngày đăng ký nào lớn hơn (trễ hơn) ngày khai giảng không
        IF EXISTS (
            SELECT 1 
            FROM inserted i
            JOIN LOP_HOC l ON i.MaLH = l.MaLH
            WHERE i.NgayDangKy > l.TGBatDau
        )
        BEGIN
            RAISERROR(N'Lỗi Ràng buộc R7: Ngày đăng ký phải diễn ra trước hoặc trong ngày bắt đầu lớp học.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;

CREATE TRIGGER trg_Check_NgayKhaiGiang_LopHoc
ON LOP_HOC
AFTER UPDATE
AS
BEGIN
    -- Chỉ chạy khi quản lý sửa cột Thời gian bắt đầu (TGBatDau)
    IF UPDATE(TGBatDau)
    BEGIN
        -- Kết nối bảng inserted (chứa ngày khai giảng mới) với bảng DANG_KY
        -- Để xem việc dời ngày này có vô tình làm cho ngày đăng ký của học viên cũ
        -- biến thành "sau ngày khai giảng" hay không
        IF EXISTS (
            SELECT 1 
            FROM inserted i
            JOIN DANG_KY d ON i.MaLH = d.MaLH
            WHERE d.NgayDangKy > i.TGBatDau
        )
        BEGIN
            RAISERROR(N'Lỗi Ràng buộc R7: Không thể dời ngày bắt đầu lớp học lên trước thời điểm học viên đã đăng ký.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;

CREATE TRIGGER trg_Check_ThongNhatKhoaHoc_DangKy
ON DANG_KY
AFTER INSERT, UPDATE
AS
BEGIN
    -- Chỉ kiểm tra khi có sự thay đổi ở Mã lớp học hoặc Mã khóa học
    IF UPDATE(MaLH) OR UPDATE(MaKH)
    BEGIN
        -- Kết nối dữ liệu vừa nhập (inserted) với bảng LOP_HOC để đối chiếu
        -- Bắt lỗi nếu Mã khóa học nhập vào KHÁC với Mã khóa học gốc của lớp đó
        IF EXISTS (
            SELECT 1 
            FROM inserted i
            JOIN LOP_HOC l ON i.MaLH = l.MaLH
            WHERE i.MaKH <> l.MaKH
        )
        BEGIN
            RAISERROR(N'Lỗi Ràng buộc R8: Mã khóa học trong phiếu đăng ký không khớp với khóa học gốc của lớp học này.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;
CREATE TRIGGER trg_Check_ThongNhatKhoaHoc_LopHoc
ON LOP_HOC
AFTER UPDATE
AS
BEGIN
    -- Chỉ chạy kiểm tra khi quản lý đổi khóa học của lớp học này sang khóa khác
    IF UPDATE(MaKH)
    BEGIN
        -- Kết nối lớp học vừa bị đổi mã (inserted) với các phiếu đăng ký cũ (DANG_KY)
        -- Để xem việc đổi này có làm sai lệch dữ liệu của những học viên đã đăng ký trước đó không
        IF EXISTS (
            SELECT 1 
            FROM inserted i
            JOIN DANG_KY d ON i.MaLH = d.MaLH
            WHERE i.MaKH <> d.MaKH
        )
        BEGIN
            RAISERROR(N'Lỗi Ràng buộc R8: Không thể đổi mã khóa học của lớp này vì đã có học viên đăng ký theo mã khóa học cũ. Vui lòng cập nhật phiếu đăng ký trước.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;

CREATE TRIGGER trg_Check_LopHocCoLichHoc_LopHoc
ON LOP_HOC
AFTER INSERT, UPDATE
AS
BEGIN
    -- Chỉ chạy kiểm tra khi thêm mới hoặc sửa Mã lớp học
    IF UPDATE(MaLH)
    BEGIN
        -- Tìm xem có lớp học nào vừa được thêm/sửa mà CHƯA CÓ lịch học nào tương ứng không
        IF EXISTS (
            SELECT 1 
            FROM inserted i
            WHERE NOT EXISTS (
                SELECT 1 
                FROM LICH_HOC lh 
                WHERE lh.MaLH = i.MaLH
            )
        )
        BEGIN
            RAISERROR(N'Lỗi Ràng buộc R9: Mỗi lớp học khi tạo ra phải có ít nhất một lịch học tương ứng.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;

CREATE TRIGGER trg_Check_LopHocCoLichHoc_LichHoc
ON LICH_HOC
AFTER DELETE, UPDATE
AS
BEGIN
    -- Kiểm tra những Mã lớp học (MaLH) cũ vừa bị xóa đi hoặc bị đổi sang mã khác
    IF EXISTS (
        SELECT 1 
        FROM deleted d
        -- Chỉ xét những lớp vẫn đang còn tồn tại trong bảng LOP_HOC
        JOIN LOP_HOC l ON d.MaLH = l.MaLH 
        -- Nếu đếm số lịch học còn sót lại của lớp đó bằng 0
        WHERE NOT EXISTS (
            SELECT 1 
            FROM LICH_HOC lh 
            WHERE lh.MaLH = d.MaLH
        )
    )
    BEGIN
        RAISERROR(N'Lỗi Ràng buộc R9: Không thể xóa/sửa vì đây là lịch học duy nhất còn lại của lớp học. Lớp học bắt buộc phải có lịch.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

CREATE TRIGGER trg_Check_GioiHanSiSo_DangKy
ON DANG_KY
AFTER INSERT, UPDATE
AS
BEGIN
    -- Chỉ kiểm tra khi có thay đổi liên quan đến việc gán học viên vào Lớp (MaLH)
    IF UPDATE(MaLH)
    BEGIN
        -- Đếm tổng số học viên hiện tại của các lớp vừa được đăng ký
        -- và so sánh với sĩ số tối đa của lớp đó trong bảng LOP_HOC
        IF EXISTS (
            SELECT 1
            FROM LOP_HOC l
            JOIN (
                -- Tính tổng học viên thực tế đang đăng ký của lớp bị tác động
                SELECT MaLH, COUNT(MaHV) AS SoLuongHienTai
                FROM DANG_KY
                WHERE MaLH IN (SELECT MaLH FROM inserted)
                GROUP BY MaLH
            ) AS dk ON l.MaLH = dk.MaLH
            WHERE dk.SoLuongHienTai > l.SiSo
        )
        BEGIN
            RAISERROR(N'Lỗi Ràng buộc R10: Không thể đăng ký thêm, số lượng học viên đã đạt mức tối đa của lớp học này.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;

CREATE TRIGGER trg_Check_GioiHanSiSo_LopHoc
ON LOP_HOC
AFTER INSERT, UPDATE
AS
BEGIN
    -- Nếu quản lý sửa sĩ số lớp (giảm xuống) hoặc tạo lớp mới
    IF UPDATE(SiSo)
    BEGIN
        -- Đối chiếu sĩ số mới với số người đã đăng ký thực tế
        -- (Dùng LEFT JOIN phòng trường hợp lớp mới tinh chưa có ai đăng ký)
        IF EXISTS (
            SELECT 1
            FROM inserted i
            LEFT JOIN (
                SELECT MaLH, COUNT(MaHV) AS SoLuongHienTai
                FROM DANG_KY
                GROUP BY MaLH
            ) AS dk ON i.MaLH = dk.MaLH
            WHERE ISNULL(dk.SoLuongHienTai, 0) > i.SiSo
        )
        BEGIN
            RAISERROR(N'Lỗi Ràng buộc R10: Không thể giảm sĩ số tối đa xuống thấp hơn số lượng học viên đã đăng ký hiện tại.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;