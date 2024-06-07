-- CS#2: Nguoi dung c� VAITRO la �Giang vien� co quyen truy cap du lieu:
-- - Nhu mot nguoi dung co vai tro �Nhan vien co ban� (xem mo ta CS#1).
-- - Xem du lieu phan cong giang day lien quan den ban than minh (PHANCONG).
-- - Xem du lieu tren quan he DANGKY lien quan den cac lop hoc phan ma giang vien duoc phan cong giang day.
-- - Cap nhat du lieu tai cac truong lien quan diem so (trong quan he DANGKY) cua cac sinh vien co tham gia lop hoc phan ma giang vien do duoc phan cong giang day. Cac
-- truong lien quan diem so bao gom: DIEMTH, DIEMQT, DIEMCK, DIEMTK.

-- - Nhu mot nguoi dung co vai tro �Nhan vien co ban� (xem mo ta CS#1)
CREATE OR REPLACE VIEW NHANSU_GV_VIEW AS
SELECT * FROM ADMIN.NHANSU WHERE MANV = SYS_CONTEXT('USERENV', 'SESSION_USER') AND VAITRO = 'GIANG VIEN';

REVOKE SELECT ON ADMIN.NHANSU_GV_VIEW FROM RL_GIANGVIEN;
GRANT SELECT ON ADMIN.NHANSU_GV_VIEW TO RL_GIANGVIEN;
SELECT * FROM ADMIN.NHANSU_GV_VIEW;

CREATE OR REPLACE TRIGGER TRIGGER_NHANSU_GV_UPDATE
INSTEAD OF UPDATE
ON ADMIN.NHANSU_GV_VIEW
FOR EACH ROW
DECLARE
  v_already_fired NUMBER;
BEGIN
  -- Xem trigger duoc kich hoat chua
  SELECT COUNT(*) INTO v_already_fired
  FROM user_triggers
  WHERE trigger_name = 'TRIGGER_NHANSU_GV_UPDATE'
  AND status = 'ENABLED'
  AND triggering_event = 'UPDATE';

  -- Neu trigger chua duoc kich hoat thi update
  IF v_already_fired = 0 THEN
    UPDATE ADMIN.NHANSU_GV_VIEW
    SET DT = :NEW.DT
    WHERE MANV = SYS_CONTEXT('USERENV', 'SESSION_USER');
  END IF;
END;

REVOKE UPDATE ON ADMIN.NHANSU_GV_VIEW FROM RL_GIANGVIEN;
GRANT UPDATE(DT) ON ADMIN.NHANSU_GV_VIEW TO RL_GIANGVIEN;
UPDATE ADMIN.NHANSU_GV_VIEW SET DT = '0941499767';

GRANT SELECT ON ADMIN.SINHVIEN TO RL_GIANGVIEN;
GRANT SELECT ON ADMIN.DONVI TO RL_GIANGVIEN;
GRANT SELECT ON ADMIN.HOCPHAN TO RL_GIANGVIEN;
GRANT SELECT ON ADMIN.KHMO TO RL_GIANGVIEN;

CREATE OR REPLACE VIEW PHANCONG_GV_VIEW AS
SELECT * FROM ADMIN.PHANCONG WHERE MAGV = SYS_CONTEXT('USERENV', 'SESSION_USER');

-- Xem thong tin phan cong cua chinh minh
GRANT SELECT ON ADMIN.PHANCONG_GV_VIEW TO RL_GIANGVIEN;

-- Test phan quyen
SELECT * FROM ADMIN.PHANCONG_GV_VIEW;

CREATE OR REPLACE VIEW DANGKY_GV_VIEW AS
SELECT DK.MASV, DK.MAGV, DK.MAHP, DK.HK, DK.NAM, DK.MACT, DIEMTH, DIEMQT, DIEMCK, DIEMTK
FROM ADMIN.DANGKY DK JOIN ADMIN.PHANCONG PC ON DK.MAGV = PC.MAGV
WHERE PC.MAGV = SYS_CONTEXT('USERENV', 'SESSION_USER');

GRANT SELECT ON ADMIN.DANGKY_GV_VIEW TO RL_GIANGVIEN;
SELECT * FROM ADMIN.DANGKY_GV_VIEW;

CREATE OR REPLACE TRIGGER TRIGGER_DANGKY_GV_UPDATE
INSTEAD OF UPDATE
ON ADMIN.DANGKY_GV_VIEW
FOR EACH ROW
DECLARE
  v_already_fired NUMBER;
BEGIN
  -- Xem trigger duoc kich hoat chua
  SELECT COUNT(*) INTO v_already_fired
  FROM user_triggers
  WHERE trigger_name = 'TRIGGER_NHANSU_NV_UPDATE'
  AND status = 'ENABLED'
  AND triggering_event = 'UPDATE';

  -- Neu trigger chua duoc kich hoat thi update
  IF v_already_fired = 0 THEN
    UPDATE ADMIN.DANGKY_GV_VIEW
    SET DIEMTH = :NEW.DIEMTH, DIEMQT = :NEW.DIEMQT, DIEMCK = :NEW.DIEMCK, DIEMTK = :NEW.DIEMTK 
    WHERE MASV = :NEW.MASV AND MAGV = SYS_CONTEXT('USERENV', 'SESSION_USER');
  END IF;
END;

GRANT UPDATE(DIEMTH, DIEMQT, DIEMCK, DIEMTK) ON ADMIN.DANGKY_GV_VIEW TO RL_GIANGVIEN;
UPDATE ADMIN.DANGKY_GV_VIEW SET DIEMTH = 7, DIEMQT = 7, DIEMCK = 7, DIEMTK = 7 WHERE MASV = 'SV1001';