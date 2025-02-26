# PB-Bollinger-EA

**PB-Bollinger-EA** là một bot giao dịch tự động được thiết kế để giao dịch vàng (XAU/USD) hoặc các cặp tiền tệ khác trên khung thời gian 4 giờ (H4). Bot sử dụng chỉ báo Bollinger Bands kết hợp với mô hình nến Pin Bar để xác định điểm vào lệnh theo chiến lược xu hướng đảo chiều.

- **Mua**: Khi xuất hiện nến Pin Bar tăng (bullish Pin Bar) chạm dải dưới của Bollinger Bands.  
- **Bán**: Khi xuất hiện nến Pin Bar giảm (bearish Pin Bar) chạm dải trên của Bollinger Bands.

## Tính năng chính
- **Phát hiện Pin Bar**: Bot tự động nhận diện mô hình nến Pin Bar dựa trên giá mở, đóng, cao và thấp của nến trước đó.  
- **Bollinger Bands**: Sử dụng dải Bollinger (20 chu kỳ, độ lệch 2) để xác định vùng giá quá mua hoặc quá bán, làm cơ sở kích hoạt lệnh.  
- **Quản lý lệnh**: Mở hai lệnh mua hoặc bán đồng thời với kích thước lô tùy chỉnh (mặc định 0.05 lot), đặt Stop Loss dựa trên mức thấp nhất (cho lệnh mua) hoặc cao nhất (cho lệnh bán) của nến Pin Bar.  
- **Nền tảng**: Được lập trình tối ưu trên MetaTrader, sử dụng thư viện `Trade.mqh` để thực hiện giao dịch và quản lý vị thế hiệu quả.  

![Ví dụ tín hiệu Pin Bar trên biểu đồ](images/pinbar_demo.png)  

## Mục đích sử dụng
Bot này là công cụ lý tưởng cho những nhà giao dịch muốn tự động hóa chiến lược giao dịch đảo chiều dựa trên Pin Bar và Bollinger Bands trên khung H4. Phù hợp với người dùng yêu thích giao dịch vàng hoặc các cặp tiền tệ có biến động mạnh.

## Yêu cầu
- **Nền tảng**: MetaTrader 4 hoặc 5.  
- **Cặp tiền**: XAU/USD (vàng) hoặc các cặp tiền tệ khác.  
- **Khung thời gian**: H4 (4 giờ).  

## Hướng dẫn cài đặt
1. Sao chép mã nguồn vào thư mục `Experts` của MetaTrader.  
2. Biên dịch tệp trong MetaEditor.  
3. Gắn bot vào biểu đồ XAU/USD (hoặc cặp tiền mong muốn) trên khung H4 và điều chỉnh thông số nếu cần.  

## Lưu ý
- **Kiểm tra trước**: Hãy chạy thử trên tài khoản demo để đảm bảo bot hoạt động đúng với chiến lược của bạn.  
- **Quản lý vốn**: Điều chỉnh kích thước lô (`lotSize`) phù hợp với số dư tài khoản để giảm rủi ro.  
- **Tùy chỉnh**: Hiện tại bot chưa bao gồm Take Profit tự động – bạn có thể thêm logic này nếu cần.  

## Ví dụ minh họa
Dưới đây là hình ảnh minh họa cách bot nhận diện Pin Bar và mở lệnh (giả định):
![Pin Bar tăng chạm dải dưới Bollinger Bands](images/buy_signal.png)  
![Pin Bar giảm chạm dải trên Bollinger Bands](images/sell_signal.png)  

---
Bot được phát triển bởi [Tên của bạn] - Ngày cập nhật: 27/02/2025.
