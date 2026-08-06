# MIS 443 – Finance Analysis (Final Exam)

Bài thi cuối kỳ môn **MIS 443 – Finance Analysis**, phân tích dữ liệu ngân hàng bán lẻ bằng **PostgreSQL**.

| | |
|---|---|
| **Sinh viên** | Vũ Đông Dương |
| **MSSV** | 2032300044 |
| **Môn học** | MIS 443 – Finance Analysis |
| **CSDL** | PostgreSQL |
| **Tổng điểm** | 100 marks |

## Bối cảnh nghiệp vụ

Cơ sở dữ liệu mô phỏng một ngân hàng bán lẻ quản lý khách hàng, chi nhánh, tài khoản và giao dịch. Ban quản lý sử dụng dữ liệu này để theo dõi giá trị khách hàng, số dư tài khoản, hiệu quả chi nhánh và mức độ hoạt động giao dịch.

Quy ước dữ liệu:

- Số dư dương = tiền khách hàng đang gửi.
- Số dư âm ở tài khoản Credit Card = khoản khách hàng đang nợ.
- Giao dịch dương = ghi có (credit); giao dịch âm = ghi nợ (debit).

## Cấu trúc dữ liệu

| Bảng | Mô tả | Số dòng |
|---|---|---|
| `customers` | Mỗi dòng là một khách hàng | 6 |
| `branches` | Mỗi dòng là một chi nhánh | 15 |
| `accounts` | Tài khoản, thuộc 1 khách hàng và 1 chi nhánh | 15 |
| `transactions` | Giao dịch, thuộc 1 tài khoản | 15 |

Quan hệ khóa ngoại:

```
customers 1─────< accounts >─────1 branches
                     │
                     1
                     │
                     <
               transactions
```

Ràng buộc chính: `account_type ∈ {Checking, Savings, Credit Card}`, `amount <> 0`, `char_length(state) = 2`.

## Cấu trúc thư mục

```
MIS443_2032300044_Finance/
├── Data & Form/
│   ├── MIS443_Finance_PostgreSQL.sql          # Script tạo bảng + nạp dữ liệu mẫu
│   └── MIS443_Finance_Final_Exam_Skeleton.sql # Đề thi (skeleton) do giảng viên cung cấp
├── MIS443_2032300044_VUDONGDUONG/
│   ├── MIS443_2032300044_VUDONGDUONG.sql      # Bài làm hoàn chỉnh
│   └── MIS443_2032300044_VUDONGDUONG.docx     # Báo cáo Word
└── README.md
```

## Nội dung bài làm

| Câu | Chủ đề | Điểm | Kỹ thuật SQL chính |
|---|---|---|---|
| 1 | Database setup | 10 | `CREATE DATABASE`, `COUNT`, `UNION ALL` |
| 2 | Customer & account overview | 10 | `WHERE`, `CONCAT`, `ORDER BY`, aggregate |
| 3 | Account balance analysis | 20 | `SUM`, `AVG`, `GROUP BY`, filter theo `account_type` |
| 4 | Branch & customer portfolio analysis | 20 | `JOIN` nhiều bảng, `GROUP BY … ORDER BY … LIMIT` |
| 5 | Customer value & activity | 20 | `JOIN` 4 bảng, `HAVING`, aggregate lồng nhau |
| 6 | Advanced finance analysis | 20 | Subquery, window function `RANK()`, `CTE` |

## Hướng dẫn chạy

Yêu cầu: PostgreSQL 12 trở lên (khuyến nghị dùng pgAdmin hoặc `psql`).

**Bước 1 — Tạo database**

```sql
CREATE DATABASE vudongduong;
```

**Bước 2 — Nạp dữ liệu**

Kết nối vào database vừa tạo và chạy script dữ liệu:

```bash
psql -U postgres -d vudongduong -f "Data & Form/MIS443_Finance_PostgreSQL.sql"
```

**Bước 3 — Kiểm tra dữ liệu đã nạp đúng**

```sql
SELECT 'accounts' AS table_name, COUNT(*) FROM public.accounts
UNION ALL SELECT 'branches', COUNT(*) FROM public.branches
UNION ALL SELECT 'customers', COUNT(*) FROM public.customers
UNION ALL SELECT 'transactions', COUNT(*) FROM public.transactions
ORDER BY table_name;
```

Kết quả mong đợi: accounts = 15, branches = 15, customers = 6, transactions = 15.

**Bước 4 — Chạy bài làm**

```bash
psql -U postgres -d vudongduong -f "MIS443_2032300044_VUDONGDUONG/MIS443_2032300044_VUDONGDUONG.sql"
```

Mỗi câu trả lời trong file đều kèm phần *Expected result* để đối chiếu kết quả.

## Lưu ý

- Không chỉnh sửa các bảng và dữ liệu do giảng viên cung cấp trong `MIS443_Finance_PostgreSQL.sql`.
- Script dữ liệu không tự tạo database; cần tạo trước ở Bước 1.
- Tên database viết thường, không dấu, không khoảng trắng.

## Bản quyền

Bài tập học thuật phục vụ mục đích học tập môn MIS 443.
