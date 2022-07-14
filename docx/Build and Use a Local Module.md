 # Prerequisites
 - AWS account
 - AWS CLI
 - Terraform CLI
# Module structure
- Cấu trúc thư mục điển hình của module mới là:
```
.
├── LICENSE
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
```
- Không có file nào là bắt buộc hoặc có ý nghĩa đặc biệt naò đối với terraform khi sử dụng module. Bạn có thể tạo module với chỉ 1 file `.tf` hoặc sử dụng bất kỳ cấu trúc file nào mà bạn thích.
- Mỗi file của cấu trúc trên sẽ có một mục đích khác nhau:
  - `LICENSE`: chứa license mà theo đó module cuả bạn sẽ được phân phối. Khi bạn share module, `LICENSE` file sẽ cho những người sử dụng file biết các điều khoản mà file cung cấp. Bản thân Terraform không sử dụng file này.
  - `DEADME.md`: mô tả cách thức sử dụng module. 
  - `main.tf`: chứa các thiết lập chính cho module. 
  - `variables.tf`: chứa định nghĩa các biến của module. Khi module được sử dụng bởi ai đó, các variables sẽ được cấu hình như là đối số bên trong `module` block. Vì tất cả giá trị phải được define nên bất kỳ variable nào không cung cấp giá trị mặc định sẽ trở thành đối số băt buộc.